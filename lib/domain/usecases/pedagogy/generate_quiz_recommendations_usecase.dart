/// GenerateQuizRecommendationsUseCase - Bridges quiz results with pedagogy system
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/json/concept_json_data_source.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/entities/pedagogy/quiz_recommendation.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/services/gap_analysis_service.dart';

/// Parameters for generate quiz recommendations use case
class GenerateQuizRecommendationsParams {
  final QuizResult quizResult;
  final String studentId;
  final AssessmentType assessmentType;

  const GenerateQuizRecommendationsParams({
    required this.quizResult,
    required this.studentId,
    required this.assessmentType,
  });
}

/// Use case for generating personalized recommendations from quiz results.
///
/// Algorithm:
/// 1. Extract weak concept IDs from quiz result (< 60% accuracy)
/// 2. For each weak concept, call GapAnalysisService.detectGaps()
/// 3. Load recommended videos via ConceptJsonDataSource and ContentRepository
/// 4. Create QuizRecommendation for each gap
/// 5. Sort by priority score and return RecommendationsBundle
class GenerateQuizRecommendationsUseCase {
  final GapAnalysisService _gapAnalysisService;
  final ConceptJsonDataSource _conceptDataSource;
  final ContentRepository _contentRepository;

  /// Mastery threshold - concepts below this are considered weak
  static const double weaknessThreshold = 60.0;

  const GenerateQuizRecommendationsUseCase({
    required GapAnalysisService gapAnalysisService,
    required ConceptJsonDataSource conceptDataSource,
    required ContentRepository contentRepository,
  })  : _gapAnalysisService = gapAnalysisService,
        _conceptDataSource = conceptDataSource,
        _contentRepository = contentRepository;

  Future<Either<Failure, RecommendationsBundle>> call(
    GenerateQuizRecommendationsParams params,
  ) async {
    try {
      final result = params.quizResult;
      final studentId = params.studentId;

      // 1. Extract weak concept IDs from quiz result
      final weakConceptIds = await _extractWeakConceptIds(result);

      if (weakConceptIds.isEmpty) {
        // No weak areas - return empty bundle
        logger.debug('No weak concepts found in quiz result');
        return Right(RecommendationsBundle(
          quizResultId: result.sessionId,
          assessmentType: params.assessmentType,
          recommendations: [],
          generatedAt: DateTime.now(),
          totalEstimatedMinutes: 0,
          subjectName: result.subjectName,
          quizScore: result.scorePercentage,
        ));
      }

      logger.debug('Found ${weakConceptIds.length} weak concepts: $weakConceptIds');

      // 2. For each weak concept, detect gaps and get recommendations
      final recommendations = <QuizRecommendation>[];

      for (final conceptId in weakConceptIds) {
        try {
          // Get concept details
          final concept = await _conceptDataSource.getConceptById(conceptId);
          if (concept == null) {
            logger.warning('Concept not found: $conceptId');
            continue;
          }

          // Detect gaps for this concept
          final gaps = await _gapAnalysisService.detectGaps(
            studentId: studentId,
            targetConceptId: conceptId,
          );

          // If this concept itself is a gap, use it directly
          // Otherwise, use the first prerequisite gap found
          ConceptGap? relevantGap;
          if (gaps.any((g) => g.conceptId == conceptId)) {
            relevantGap = gaps.firstWhere((g) => g.conceptId == conceptId);
          } else if (gaps.isNotEmpty) {
            relevantGap = gaps.first; // Highest priority prerequisite gap
          }

          // If no gap detected (mastery >= 60%), create a synthetic gap
          // This can happen if the concept is weak but just above threshold
          if (relevantGap == null) {
            final mastery = _getConceptMasteryFromResult(result, conceptId);
            logger.debug('Creating synthetic gap for $conceptId with mastery $mastery');

            final videoMappings = await _conceptDataSource.getVideosForConcept(conceptId);

            relevantGap = ConceptGap(
              id: 'gap_${studentId}_${conceptId}',
              conceptId: conceptId,
              conceptName: concept.name,
              gradeLevel: concept.gradeLevel,
              currentMastery: mastery,
              priorityScore: _calculateSyntheticPriorityScore(mastery),
              blockedConcepts: [],
              recommendedVideoIds: videoMappings.map((v) => v.id).toList(),
              estimatedFixMinutes: concept.estimatedMinutes + 10,
              subject: concept.subject,
              chapterId: concept.chapterId,
            );
          }

          // 3. Load recommended videos (full Video objects)
          // First try to get videos from content repository
          List<Video> videos = await _loadRecommendedVideos(relevantGap.recommendedVideoIds);

          // If content repository doesn't have them, create from VideoConceptMapping
          if (videos.isEmpty) {
            logger.debug('No videos in content repository, loading from video mappings for concept: $conceptId');
            final videoMappings = await _conceptDataSource.getVideosForConcept(conceptId);
            videos = videoMappings.map((mapping) => _convertMappingToVideo(mapping, concept)).toList();

            if (videos.isNotEmpty) {
              logger.info('✅ Loaded ${videos.length} videos from mappings for concept: $conceptId');
            } else {
              logger.warning('No videos found for concept: $conceptId');
            }
          }

          // 4. Create QuizRecommendation
          final recommendation = QuizRecommendation(
            gap: relevantGap,
            recommendedVideos: videos,
            topicName: concept.name,
            estimatedFixMinutes: relevantGap.estimatedFixMinutes,
            dismissed: false,
            acted: false,
            generatedAt: DateTime.now(),
          );

          recommendations.add(recommendation);
        } catch (e, stackTrace) {
          logger.error('Failed to process concept $conceptId', e, stackTrace);
          // Continue with other concepts
        }
      }

      // 5. Sort by priority score (highest first)
      recommendations.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

      // Calculate total estimated time
      final totalMinutes = recommendations.fold<int>(
        0,
        (sum, rec) => sum + rec.estimatedFixMinutes,
      );

      logger.info('Generated ${recommendations.length} recommendations');

      return Right(RecommendationsBundle(
        quizResultId: result.sessionId,
        assessmentType: params.assessmentType,
        recommendations: recommendations,
        generatedAt: DateTime.now(),
        totalEstimatedMinutes: totalMinutes,
        subjectName: result.subjectName,
        quizScore: result.scorePercentage,
      ));
    } catch (e, stackTrace) {
      logger.error('Failed to generate quiz recommendations', e, stackTrace);
      return Left(RecommendationGenerationFailure(
        message: 'Failed to generate recommendations: ${e.toString()}',
      ));
    }
  }

  /// Extract weak concept IDs from quiz result.
  ///
  /// Strategy:
  /// 1. From conceptAnalysis: concepts with < 60% score
  /// 2. From wrong questions: conceptTags from incorrect answers
  /// 3. Deduplicate and return unique concept IDs
  Future<Set<String>> _extractWeakConceptIds(QuizResult result) async {
    final weakConceptIds = <String>{};

    // Strategy 1: From concept analysis
    if (result.hasConceptAnalysis) {
      for (final entry in result.conceptAnalysis!.entries) {
        final conceptName = entry.key;
        final conceptScore = entry.value;

        if (conceptScore.percentage < weaknessThreshold) {
          // Find concept by name
          final concept = await _findConceptByName(conceptName);
          if (concept != null) {
            weakConceptIds.add(concept.id);
            logger.debug('Weak concept from analysis: ${concept.name} (${conceptScore.percentage.toStringAsFixed(1)}%)');
          }
        }
      }
    }

    // Strategy 2: From wrong questions (if questions available)
    if (result.questions != null) {
      for (final question in result.questions!) {
        final isCorrect = result.questionResults[question.id] ?? false;

        if (!isCorrect && question.conceptTags.isNotEmpty) {
          // Add all concept tags from wrong questions
          weakConceptIds.addAll(question.conceptTags);
          logger.debug('Weak concepts from wrong question ${question.id}: ${question.conceptTags}');
        }
      }
    }

    // Strategy 3: From weak areas (topic names)
    if (result.hasWeakAreas) {
      for (final weakArea in result.weakAreas!) {
        final concept = await _findConceptByName(weakArea);
        if (concept != null) {
          weakConceptIds.add(concept.id);
          logger.debug('Weak concept from weak area: ${concept.name}');
        }
      }
    }

    return weakConceptIds;
  }

  /// Find concept by name (fuzzy matching)
  Future<dynamic> _findConceptByName(String name) async {
    final allConcepts = await _conceptDataSource.loadConcepts();

    // Try exact match first
    for (final c in allConcepts) {
      if (c.name.toLowerCase() == name.toLowerCase()) {
        return c;
      }
    }

    // Try contains match
    for (final c in allConcepts) {
      if (c.name.toLowerCase().contains(name.toLowerCase()) ||
          name.toLowerCase().contains(c.name.toLowerCase())) {
        return c;
      }
    }

    return null;
  }

  /// Load full Video objects from video IDs
  Future<List<Video>> _loadRecommendedVideos(List<String> videoIds) async {
    final videos = <Video>[];

    for (final videoId in videoIds) {
      final result = await _contentRepository.getVideoById(videoId);

      result.fold(
        (failure) {
          logger.warning('Failed to load video $videoId: ${failure.message}');
        },
        (video) {
          videos.add(video);
        },
      );
    }

    // Sort videos by rating and views (best first)
    videos.sort((a, b) {
      final aScore = (a.rating * 0.7) + (a.viewCount / 100000 * 0.3);
      final bScore = (b.rating * 0.7) + (b.viewCount / 100000 * 0.3);
      return bScore.compareTo(aScore);
    });

    return videos;
  }

  /// Get concept mastery from quiz result
  double _getConceptMasteryFromResult(QuizResult result, String conceptId) {
    // Try to find in concept analysis by name
    if (result.hasConceptAnalysis) {
      for (final entry in result.conceptAnalysis!.entries) {
        // This is approximate - we'd need to match concept ID to name
        // For now, return an average of weak concepts
        return entry.value.percentage;
      }
    }

    // Default to midpoint of weakness threshold
    return weaknessThreshold / 2;
  }

  /// Calculate priority score for synthetic gaps
  int _calculateSyntheticPriorityScore(double mastery) {
    // Use simplified scoring based on mastery level
    if (mastery < 20) return 40;
    if (mastery < 40) return 30;
    if (mastery < 60) return 20;
    return 10;
  }

  /// Convert VideoConceptMapping to Video entity
  /// Creates a Video object from mapping data with sensible defaults
  Video _convertMappingToVideo(dynamic mapping, dynamic concept) {
    final now = DateTime.now();
    final youtubeId = mapping.youtubeId as String;

    return Video(
      id: mapping.id as String,
      title: mapping.title as String,
      description: 'Educational video for ${concept.name}',
      youtubeId: youtubeId,
      youtubeUrl: 'https://www.youtube.com/watch?v=$youtubeId',
      thumbnailUrl: 'https://img.youtube.com/vi/$youtubeId/mqdefault.jpg',
      duration: mapping.duration as int,
      durationDisplay: _formatDuration(mapping.duration as int),
      channelName: 'Educational Content',
      channelId: 'unknown',
      language: 'English',
      topicId: concept.id as String,
      difficulty: concept.difficulty as String? ?? 'intermediate',
      examRelevance: [],
      rating: 4.5,
      viewCount: 10000,
      tags: [concept.name as String, concept.subject as String],
      dateAdded: now,
      lastUpdated: now,
    );
  }

  /// Format duration in seconds to HH:MM:SS or MM:SS
  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
}

/// Failure specific to recommendation generation
class RecommendationGenerationFailure extends Failure {
  const RecommendationGenerationFailure({required super.message});
}
