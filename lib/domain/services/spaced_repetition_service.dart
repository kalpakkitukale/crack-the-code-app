/// SpacedRepetitionService - SM-2 inspired spaced repetition algorithm
library;

import 'dart:math';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/spaced_repetition_dao.dart';
import 'package:streamshaala/data/models/pedagogy/spaced_repetition_model.dart';

/// Service for spaced repetition scheduling
/// Implements SM-2 inspired algorithm running entirely on device
class SpacedRepetitionService {
  final SpacedRepetitionDao _dao;

  /// Standard intervals in days: 1 → 3 → 7 → 14 → 30 → 60 → 120
  static const List<int> standardIntervals = [1, 3, 7, 14, 30, 60, 120];

  /// Minimum ease factor
  static const double minEaseFactor = 1.3;

  /// Default ease factor
  static const double defaultEaseFactor = 2.5;

  SpacedRepetitionService({required SpacedRepetitionDao dao}) : _dao = dao;

  /// Calculate next review date based on performance
  DateTime calculateNextReview({
    required int currentInterval,
    required bool answeredCorrectly,
    required int consecutiveCorrect,
    required double easeFactor,
  }) {
    if (!answeredCorrectly) {
      // Reset to 1 day on wrong answer
      return DateTime.now().add(const Duration(days: 1));
    }

    // Progress through intervals
    final nextIndex = min(consecutiveCorrect, standardIntervals.length - 1);
    final baseInterval = standardIntervals[nextIndex];

    // Adjust interval by ease factor
    final adjustedInterval = (baseInterval * easeFactor).round();

    return DateTime.now().add(Duration(days: adjustedInterval));
  }

  /// Update ease factor based on performance (SM-2 algorithm)
  double updateEaseFactor({
    required double currentEaseFactor,
    required int quality, // 0-5 scale: 0-2 = fail, 3-5 = pass
  }) {
    // SM-2 formula: EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    final newEaseFactor = currentEaseFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    // Clamp to minimum
    return max(minEaseFactor, newEaseFactor);
  }

  /// Get quality score from percentage (0-5 scale)
  int getQualityFromScore(double scorePercentage) {
    if (scorePercentage >= 95) return 5; // Perfect
    if (scorePercentage >= 85) return 4; // Great
    if (scorePercentage >= 70) return 3; // Good (pass threshold)
    if (scorePercentage >= 50) return 2; // Barely remembered
    if (scorePercentage >= 30) return 1; // Struggled
    return 0; // Failed
  }

  /// Record a review result
  Future<SpacedRepetitionModel> recordReview({
    required String studentId,
    required String conceptId,
    required double scorePercentage,
  }) async {
    try {
      // Get existing record or create new
      final existing = await _dao.getByConceptAndStudent(
        conceptId: conceptId,
        studentId: studentId,
      );

      final quality = getQualityFromScore(scorePercentage);
      final answeredCorrectly = quality >= 3;

      final currentInterval = existing?.intervalDays ?? 0;
      final currentEaseFactor = existing?.easeFactor ?? defaultEaseFactor;
      final currentConsecutiveCorrect = existing?.consecutiveCorrect ?? 0;

      // Calculate new values
      final newEaseFactor = updateEaseFactor(
        currentEaseFactor: currentEaseFactor,
        quality: quality,
      );

      final newConsecutiveCorrect =
          answeredCorrectly ? currentConsecutiveCorrect + 1 : 0;

      final nextReviewDate = calculateNextReview(
        currentInterval: currentInterval,
        answeredCorrectly: answeredCorrectly,
        consecutiveCorrect: newConsecutiveCorrect,
        easeFactor: newEaseFactor,
      );

      final newInterval = nextReviewDate.difference(DateTime.now()).inDays;

      // Create updated model
      final model = SpacedRepetitionModel(
        id: existing?.id ?? 'sr_${studentId}_$conceptId',
        conceptId: conceptId,
        studentId: studentId,
        intervalDays: newInterval,
        easeFactor: newEaseFactor,
        consecutiveCorrect: newConsecutiveCorrect,
        nextReviewDate: nextReviewDate,
        lastReviewDate: DateTime.now(),
        totalReviews: (existing?.totalReviews ?? 0) + 1,
        correctReviews: (existing?.correctReviews ?? 0) + (answeredCorrectly ? 1 : 0),
      );

      await _dao.upsert(model);

      logger.debug(
        'Recorded review for $conceptId: ${answeredCorrectly ? "correct" : "incorrect"}, '
        'next review in $newInterval days',
      );

      return model;
    } catch (e, stackTrace) {
      logger.error('Failed to record review', e, stackTrace);
      rethrow;
    }
  }

  /// Initialize spaced repetition for a new concept
  Future<SpacedRepetitionModel> initializeConcept({
    required String studentId,
    required String conceptId,
    double initialMastery = 0,
  }) async {
    try {
      // Calculate initial interval based on mastery
      int initialInterval;
      if (initialMastery >= 80) {
        initialInterval = 7; // Already knows well, review in a week
      } else if (initialMastery >= 60) {
        initialInterval = 3; // Familiar, review in 3 days
      } else {
        initialInterval = 1; // Needs practice, review tomorrow
      }

      final model = SpacedRepetitionModel(
        id: 'sr_${studentId}_$conceptId',
        conceptId: conceptId,
        studentId: studentId,
        intervalDays: initialInterval,
        easeFactor: defaultEaseFactor,
        consecutiveCorrect: 0,
        nextReviewDate: DateTime.now().add(Duration(days: initialInterval)),
        lastReviewDate: null,
        totalReviews: 0,
        correctReviews: 0,
      );

      await _dao.upsert(model);
      return model;
    } catch (e, stackTrace) {
      logger.error('Failed to initialize spaced repetition', e, stackTrace);
      rethrow;
    }
  }

  /// Get concepts due for review today
  Future<List<SpacedRepetitionModel>> getDueReviews({
    required String studentId,
    int? limit,
  }) async {
    return _dao.getReviewsDue(
      studentId: studentId,
      beforeDate: DateTime.now(),
      limit: limit,
    );
  }

  /// Get count of reviews due today
  Future<int> getDueReviewsCount(String studentId) async {
    return _dao.getReviewsDueCount(
      studentId: studentId,
      beforeDate: DateTime.now(),
    );
  }

  /// Get upcoming review schedule
  Future<Map<DateTime, int>> getUpcomingSchedule({
    required String studentId,
    int days = 7,
  }) async {
    return _dao.getUpcomingReviewSchedule(
      studentId: studentId,
      days: days,
    );
  }

  /// Get spaced repetition statistics
  Future<SpacedRepStatistics> getStatistics(String studentId) async {
    final stats = await _dao.getStatistics(studentId);
    final dueCount = await getDueReviewsCount(studentId);

    return SpacedRepStatistics(
      totalItems: (stats['total_items'] as int?) ?? 0,
      totalReviews: (stats['total_reviews'] as int?) ?? 0,
      totalCorrect: (stats['total_correct'] as int?) ?? 0,
      averageInterval: (stats['avg_interval'] as num?)?.toDouble() ?? 0,
      averageEaseFactor: (stats['avg_ease_factor'] as num?)?.toDouble() ?? defaultEaseFactor,
      dueToday: dueCount,
    );
  }

  /// Check if a concept is due for review
  Future<bool> isDueForReview({
    required String studentId,
    required String conceptId,
  }) async {
    final record = await _dao.getByConceptAndStudent(
      conceptId: conceptId,
      studentId: studentId,
    );

    if (record == null) return false;
    return record.isDue;
  }
}

/// Statistics for spaced repetition
class SpacedRepStatistics {
  final int totalItems;
  final int totalReviews;
  final int totalCorrect;
  final double averageInterval;
  final double averageEaseFactor;
  final int dueToday;

  const SpacedRepStatistics({
    required this.totalItems,
    required this.totalReviews,
    required this.totalCorrect,
    required this.averageInterval,
    required this.averageEaseFactor,
    required this.dueToday,
  });

  /// Get accuracy percentage
  double get accuracy {
    if (totalReviews == 0) return 0;
    return (totalCorrect / totalReviews) * 100;
  }
}
