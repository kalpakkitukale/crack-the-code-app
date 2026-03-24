/// GapAnalysisService - Detects concept gaps and calculates priority scores
library;

import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/json/concept_json_data_source.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/concept_mastery_dao.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_mastery.dart';
import 'package:crack_the_code/domain/entities/pedagogy/subject_gap_analysis.dart';

/// Gap Analysis Service - runs entirely on device
/// Implements the gap detection algorithm from specification
class GapAnalysisService {
  final ConceptJsonDataSource _conceptDataSource;
  final ConceptMasteryDao _masteryDao;

  /// Gap threshold - mastery below this is considered a gap
  static const double gapThreshold = 60.0;

  GapAnalysisService({
    required ConceptJsonDataSource conceptDataSource,
    required ConceptMasteryDao masteryDao,
  })  : _conceptDataSource = conceptDataSource,
        _masteryDao = masteryDao;

  /// Detect all gaps for a student trying to learn a target concept
  Future<List<ConceptGap>> detectGaps({
    required String studentId,
    required String targetConceptId,
  }) async {
    try {
      // 1. Get all prerequisites of target concept (recursive)
      final prerequisiteChain = await _conceptDataSource.getPrerequisiteChain(targetConceptId);

      if (prerequisiteChain.isEmpty) {
        logger.debug('No prerequisites found for concept: $targetConceptId');
        return [];
      }

      // 2. Get student mastery for all concepts
      final masteryRecords = await _masteryDao.getByStudent(studentId);
      final masteryMap = {for (var m in masteryRecords) m.conceptId: m};

      // 3. Check each prerequisite for gaps
      final gaps = <ConceptGap>[];

      for (final concept in prerequisiteChain) {
        final mastery = masteryMap[concept.id];
        final masteryScore = mastery?.masteryScore ?? 0;

        // If mastery < 60%, mark as gap
        if (masteryScore < gapThreshold) {
          // Get videos for this concept
          final videos = await _conceptDataSource.getVideosForConcept(concept.id);
          final videoIds = videos.map((v) => v.id).toList();

          // Find concepts that depend on this one
          final blockedConcepts = await _findBlockedConcepts(concept.id);

          final gap = ConceptGap(
            id: 'gap_${studentId}_${concept.id}',
            conceptId: concept.id,
            conceptName: concept.name,
            gradeLevel: concept.gradeLevel,
            currentMastery: masteryScore,
            priorityScore: _calculatePriorityScore(
              masteryScore: masteryScore,
              blockedConcepts: blockedConcepts,
              gradeLevel: concept.gradeLevel,
              lastAssessed: mastery?.lastAssessed,
            ),
            blockedConcepts: blockedConcepts,
            recommendedVideoIds: videoIds,
            estimatedFixMinutes: concept.estimatedMinutes + 10, // Video + quiz time
            subject: concept.subject,
            chapterId: concept.chapterId,
          );

          gaps.add(gap);
        }
      }

      // 4. Sort by priority (highest first)
      gaps.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

      logger.debug('Detected ${gaps.length} gaps for student $studentId');
      return gaps;
    } catch (e, stackTrace) {
      logger.error('Failed to detect gaps', e, stackTrace);
      return [];
    }
  }

  /// Calculate gap priority score (0-100)
  /// Formula: A (severity) + B (blocking impact) + C (foundation level) + D (recency)
  int _calculatePriorityScore({
    required double masteryScore,
    required List<String> blockedConcepts,
    required int gradeLevel,
    DateTime? lastAssessed,
  }) {
    int score = 0;

    // A. Severity (40 points max)
    if (masteryScore < 20) {
      score += 40;
    } else if (masteryScore < 40) {
      score += 30;
    } else if (masteryScore < 60) {
      score += 20;
    }

    // B. Blocking Impact (30 points max)
    if (blockedConcepts.length >= 5) {
      score += 30;
    } else if (blockedConcepts.length >= 3) {
      score += 20;
    } else if (blockedConcepts.isNotEmpty) {
      score += 10;
    }

    // C. Foundation Level (20 points max) - lower grades = more foundational
    if (gradeLevel <= 4) {
      score += 20;
    } else if (gradeLevel <= 6) {
      score += 15;
    } else if (gradeLevel <= 8) {
      score += 10;
    } else {
      score += 5;
    }

    // D. Recency (10 points max) - less recent = higher priority
    if (lastAssessed == null) {
      score += 10; // Never assessed, highest priority
    } else {
      final daysSinceAssessed = DateTime.now().difference(lastAssessed).inDays;
      if (daysSinceAssessed >= 30) {
        score += 10;
      } else if (daysSinceAssessed >= 14) {
        score += 7;
      } else if (daysSinceAssessed >= 7) {
        score += 4;
      }
    }

    return score;
  }

  /// Find all concepts that are blocked by a given concept
  Future<List<String>> _findBlockedConcepts(String conceptId) async {
    final allConcepts = await _conceptDataSource.loadConcepts();
    final blocked = <String>[];

    // Direct dependents
    for (final concept in allConcepts) {
      if (concept.prerequisiteIds.contains(conceptId)) {
        blocked.add(concept.id);
      }
    }

    return blocked;
  }

  /// Detect gaps for entire subject (pre-assessment)
  Future<SubjectGapAnalysis> analyzeSubjectReadiness({
    required String studentId,
    required String subjectId,
    required String subjectName,
    required int targetGrade,
  }) async {
    try {
      // Get all concepts for this subject up to target grade - 1
      final allConcepts = await _conceptDataSource.loadConcepts();
      final relevantConcepts = allConcepts
          .where((c) => c.subject == subjectName && c.gradeLevel < targetGrade)
          .toList();

      if (relevantConcepts.isEmpty) {
        return SubjectGapAnalysis(
          studentId: studentId,
          subjectId: subjectId,
          subjectName: subjectName,
          targetGrade: targetGrade,
          overallReadiness: 100,
          gradeBreakdown: {},
          gaps: [],
          estimatedFixMinutes: 0,
          analyzedAt: DateTime.now(),
        );
      }

      // Get mastery for all concepts
      final masteryRecords = await _masteryDao.getByStudent(studentId);
      final masteryMap = {for (var m in masteryRecords) m.conceptId: m};

      // Calculate grade-wise scores
      final gradeBreakdown = <int, double>{};
      final gradeConceptCounts = <int, int>{};

      for (final concept in relevantConcepts) {
        final mastery = masteryMap[concept.id];
        final score = mastery?.masteryScore ?? 0;

        gradeBreakdown[concept.gradeLevel] =
            (gradeBreakdown[concept.gradeLevel] ?? 0) + score;
        gradeConceptCounts[concept.gradeLevel] =
            (gradeConceptCounts[concept.gradeLevel] ?? 0) + 1;
      }

      // Average scores per grade
      for (final grade in gradeBreakdown.keys.toList()) {
        gradeBreakdown[grade] =
            gradeBreakdown[grade]! / gradeConceptCounts[grade]!;
      }

      // Calculate overall readiness (weighted by grade importance)
      double totalWeight = 0;
      double weightedSum = 0;

      for (final entry in gradeBreakdown.entries) {
        final weight = (targetGrade - entry.key).toDouble(); // Recent grades weigh more
        totalWeight += weight;
        weightedSum += entry.value * weight;
      }

      final overallReadiness = totalWeight > 0 ? weightedSum / totalWeight : 0.0;

      // Detect all gaps
      final gaps = <ConceptGap>[];
      for (final concept in relevantConcepts) {
        final mastery = masteryMap[concept.id];
        final masteryScore = mastery?.masteryScore ?? 0;

        if (masteryScore < gapThreshold) {
          final videos = await _conceptDataSource.getVideosForConcept(concept.id);
          final blockedConcepts = await _findBlockedConcepts(concept.id);

          gaps.add(ConceptGap(
            id: 'gap_${studentId}_${concept.id}',
            conceptId: concept.id,
            conceptName: concept.name,
            gradeLevel: concept.gradeLevel,
            currentMastery: masteryScore,
            priorityScore: _calculatePriorityScore(
              masteryScore: masteryScore,
              blockedConcepts: blockedConcepts,
              gradeLevel: concept.gradeLevel,
              lastAssessed: mastery?.lastAssessed,
            ),
            blockedConcepts: blockedConcepts,
            recommendedVideoIds: videos.map((v) => v.id).toList(),
            estimatedFixMinutes: concept.estimatedMinutes + 10,
            subject: concept.subject,
            chapterId: concept.chapterId,
          ));
        }
      }

      // Sort gaps by priority
      gaps.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

      // Calculate total fix time
      final estimatedFixMinutes = gaps.fold<int>(
        0,
        (sum, gap) => sum + gap.estimatedFixMinutes,
      );

      return SubjectGapAnalysis(
        studentId: studentId,
        subjectId: subjectId,
        subjectName: subjectName,
        targetGrade: targetGrade,
        overallReadiness: overallReadiness,
        gradeBreakdown: gradeBreakdown,
        gaps: gaps,
        estimatedFixMinutes: estimatedFixMinutes,
        analyzedAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      logger.error('Failed to analyze subject readiness', e, stackTrace);
      rethrow;
    }
  }

  /// Get full prerequisite chain for a concept
  Future<List<Concept>> getPrerequisiteChain(String conceptId) async {
    return _conceptDataSource.getPrerequisiteChain(conceptId);
  }

  /// Check if a specific concept is a gap for a student
  Future<bool> isConceptGap({
    required String studentId,
    required String conceptId,
  }) async {
    final mastery = await _masteryDao.getByConceptAndStudent(
      conceptId: conceptId,
      studentId: studentId,
    );

    return mastery == null || mastery.masteryScore < gapThreshold;
  }

  /// Get gap count for a student
  Future<int> getGapCount(String studentId) async {
    final gaps = await _masteryDao.getGapsForStudent(studentId);
    return gaps.length;
  }
}
