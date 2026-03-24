/// MasteryCalculationService - Calculates concept mastery scores
library;

import 'package:crack_the_code/core/constants/app_thresholds.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/concept_mastery_dao.dart';
import 'package:crack_the_code/data/models/pedagogy/concept_mastery_model.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_mastery.dart';

/// Service for calculating and updating concept mastery
class MasteryCalculationService {
  final ConceptMasteryDao _masteryDao;

  /// Weights for mastery calculation (from specification)
  static const double preQuizWeight = 0.15;
  static const double checkpointWeight = 0.20;
  static const double postQuizWeight = 0.35;
  static const double practiceWeight = 0.20;
  static const double spacedRepWeight = 0.10;

  MasteryCalculationService({required ConceptMasteryDao masteryDao})
      : _masteryDao = masteryDao;

  /// Calculate new mastery score based on multiple sources
  double calculateMastery({
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
    double? previousMastery,
  }) {
    double totalWeight = 0;
    double weightedSum = 0;

    // Add each score component if available
    if (preQuizScore != null) {
      weightedSum += preQuizScore * preQuizWeight;
      totalWeight += preQuizWeight;
    }

    if (checkpointScore != null) {
      weightedSum += checkpointScore * checkpointWeight;
      totalWeight += checkpointWeight;
    }

    if (postQuizScore != null) {
      weightedSum += postQuizScore * postQuizWeight;
      totalWeight += postQuizWeight;
    }

    if (practiceScore != null) {
      weightedSum += practiceScore * practiceWeight;
      totalWeight += practiceWeight;
    }

    if (spacedRepScore != null) {
      weightedSum += spacedRepScore * spacedRepWeight;
      totalWeight += spacedRepWeight;
    }

    // If no scores available, return previous mastery or 0
    if (totalWeight == 0) {
      return previousMastery ?? 0;
    }

    // Normalize the weighted sum
    final newMastery = weightedSum / totalWeight;

    // Blend with previous mastery if available (80% new, 20% old)
    if (previousMastery != null && previousMastery > 0) {
      return (newMastery * 0.8) + (previousMastery * 0.2);
    }

    return newMastery;
  }

  /// Determine mastery level from score
  MasteryLevel getMasteryLevel(double score) {
    if (score >= MasteryThresholds.mastered) return MasteryLevel.mastered;
    if (score >= MasteryThresholds.proficient) return MasteryLevel.proficient;
    if (score >= MasteryThresholds.familiar) return MasteryLevel.familiar;
    if (score >= MasteryThresholds.learning) return MasteryLevel.learning;
    return MasteryLevel.notLearned;
  }

  /// Check if concept is a gap
  bool isGap(double mastery) => MasteryThresholds.isGap(mastery);

  /// Update mastery after pre-quiz
  Future<ConceptMastery> updateAfterPreQuiz({
    required String studentId,
    required String conceptId,
    required double preQuizScore,
    int? gradeLevel,
  }) async {
    return _updateMastery(
      studentId: studentId,
      conceptId: conceptId,
      preQuizScore: preQuizScore,
      gradeLevel: gradeLevel,
    );
  }

  /// Update mastery after video checkpoints
  Future<ConceptMastery> updateAfterCheckpoints({
    required String studentId,
    required String conceptId,
    required double checkpointScore,
    int? gradeLevel,
  }) async {
    return _updateMastery(
      studentId: studentId,
      conceptId: conceptId,
      checkpointScore: checkpointScore,
      gradeLevel: gradeLevel,
    );
  }

  /// Update mastery after post-quiz
  Future<ConceptMastery> updateAfterPostQuiz({
    required String studentId,
    required String conceptId,
    required double postQuizScore,
    int? gradeLevel,
  }) async {
    return _updateMastery(
      studentId: studentId,
      conceptId: conceptId,
      postQuizScore: postQuizScore,
      gradeLevel: gradeLevel,
    );
  }

  /// Update mastery after practice
  Future<ConceptMastery> updateAfterPractice({
    required String studentId,
    required String conceptId,
    required double practiceScore,
    int? gradeLevel,
  }) async {
    return _updateMastery(
      studentId: studentId,
      conceptId: conceptId,
      practiceScore: practiceScore,
      gradeLevel: gradeLevel,
    );
  }

  /// Update mastery after spaced repetition review
  Future<ConceptMastery> updateAfterSpacedRep({
    required String studentId,
    required String conceptId,
    required double spacedRepScore,
    int? gradeLevel,
  }) async {
    return _updateMastery(
      studentId: studentId,
      conceptId: conceptId,
      spacedRepScore: spacedRepScore,
      gradeLevel: gradeLevel,
    );
  }

  /// Internal method to update mastery
  Future<ConceptMastery> _updateMastery({
    required String studentId,
    required String conceptId,
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
    int? gradeLevel,
  }) async {
    try {
      // Get existing mastery record
      final existing = await _masteryDao.getByConceptAndStudent(
        conceptId: conceptId,
        studentId: studentId,
      );

      // Calculate new mastery score
      final newMasteryScore = calculateMastery(
        preQuizScore: preQuizScore ?? existing?.preQuizScore,
        checkpointScore: checkpointScore ?? existing?.checkpointScore,
        postQuizScore: postQuizScore ?? existing?.postQuizScore,
        practiceScore: practiceScore ?? existing?.practiceScore,
        spacedRepScore: spacedRepScore ?? existing?.spacedRepScore,
        previousMastery: existing?.masteryScore,
      );

      // Create updated model
      final model = ConceptMasteryModel(
        id: existing?.id ?? 'mastery_${studentId}_$conceptId',
        conceptId: conceptId,
        studentId: studentId,
        masteryScore: newMasteryScore,
        level: getMasteryLevel(newMasteryScore),
        lastAssessed: DateTime.now(),
        totalAttempts: (existing?.totalAttempts ?? 0) + 1,
        isGap: isGap(newMasteryScore),
        nextReviewDate: _calculateNextReviewDate(newMasteryScore),
        reviewStreak: existing?.reviewStreak ?? 0,
        preQuizScore: preQuizScore ?? existing?.preQuizScore,
        checkpointScore: checkpointScore ?? existing?.checkpointScore,
        postQuizScore: postQuizScore ?? existing?.postQuizScore,
        practiceScore: practiceScore ?? existing?.practiceScore,
        spacedRepScore: spacedRepScore ?? existing?.spacedRepScore,
        gradeLevel: gradeLevel ?? existing?.gradeLevel,
      );

      // Save to database
      await _masteryDao.upsert(model);

      logger.debug(
        'Updated mastery for $conceptId: ${newMasteryScore.toStringAsFixed(1)}%',
      );

      return model.toEntity();
    } catch (e, stackTrace) {
      logger.error('Failed to update mastery', e, stackTrace);
      rethrow;
    }
  }

  /// Calculate next review date based on mastery level
  DateTime _calculateNextReviewDate(double mastery) {
    final now = DateTime.now();
    final intervalDays = ReviewIntervals.getIntervalForScore(mastery);
    return now.add(Duration(days: intervalDays));
  }

  /// Get mastery for a concept
  Future<ConceptMastery?> getMastery({
    required String studentId,
    required String conceptId,
  }) async {
    final model = await _masteryDao.getByConceptAndStudent(
      conceptId: conceptId,
      studentId: studentId,
    );
    return model?.toEntity();
  }

  /// Get all mastery records for a student
  Future<List<ConceptMastery>> getAllMastery(String studentId) async {
    final models = await _masteryDao.getByStudent(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  /// Get all gaps for a student
  Future<List<ConceptMastery>> getGaps(String studentId) async {
    final models = await _masteryDao.getGapsForStudent(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  /// Get mastery statistics
  Future<MasteryStatistics> getStatistics(String studentId) async {
    final stats = await _masteryDao.getStatistics(studentId);
    final gradeBreakdown = await _masteryDao.getMasteryByGrade(studentId);

    return MasteryStatistics(
      totalConcepts: (stats['total_concepts'] as int?) ?? 0,
      averageMastery: (stats['avg_mastery'] as num?)?.toDouble() ?? 0,
      gapCount: (stats['gap_count'] as int?) ?? 0,
      masteredCount: (stats['mastered_count'] as int?) ?? 0,
      familiarCount: (stats['familiar_count'] as int?) ?? 0,
      learningCount: (stats['learning_count'] as int?) ?? 0,
      gradeBreakdown: gradeBreakdown,
    );
  }
}

/// Statistics for student mastery
class MasteryStatistics {
  final int totalConcepts;
  final double averageMastery;
  final int gapCount;
  final int masteredCount;
  final int familiarCount;
  final int learningCount;
  final Map<int, double> gradeBreakdown;

  const MasteryStatistics({
    required this.totalConcepts,
    required this.averageMastery,
    required this.gapCount,
    required this.masteredCount,
    required this.familiarCount,
    required this.learningCount,
    required this.gradeBreakdown,
  });

  /// Get mastery percentage (non-gap concepts)
  double get masteryPercentage {
    if (totalConcepts == 0) return 0;
    return ((totalConcepts - gapCount) / totalConcepts) * 100;
  }
}
