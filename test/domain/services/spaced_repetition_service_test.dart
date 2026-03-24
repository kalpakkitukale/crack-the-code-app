/// Tests for SpacedRepetitionService pure functions
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/spaced_repetition_dao.dart';
import 'package:crack_the_code/data/models/pedagogy/spaced_repetition_model.dart';
import 'package:crack_the_code/domain/services/spaced_repetition_service.dart';

void main() {
  group('SpacedRepetitionService', () {
    late MockSpacedRepetitionDao mockDao;
    late SpacedRepetitionService service;

    setUp(() {
      mockDao = MockSpacedRepetitionDao();
      service = SpacedRepetitionService(dao: mockDao);
    });

    group('standardIntervals', () {
      test('hasCorrectValues', () {
        expect(SpacedRepetitionService.standardIntervals, [1, 3, 7, 14, 30, 60, 120]);
      });

      test('hasSevenIntervals', () {
        expect(SpacedRepetitionService.standardIntervals.length, 7);
      });
    });

    group('minEaseFactor', () {
      test('is1Point3', () {
        expect(SpacedRepetitionService.minEaseFactor, 1.3);
      });
    });

    group('defaultEaseFactor', () {
      test('is2Point5', () {
        expect(SpacedRepetitionService.defaultEaseFactor, 2.5);
      });
    });

    group('getQualityFromScore', () {
      test('score100_returns5', () {
        expect(service.getQualityFromScore(100), 5);
      });

      test('score95_returns5', () {
        expect(service.getQualityFromScore(95), 5);
      });

      test('score94_returns4', () {
        expect(service.getQualityFromScore(94), 4);
      });

      test('score85_returns4', () {
        expect(service.getQualityFromScore(85), 4);
      });

      test('score84_returns3', () {
        expect(service.getQualityFromScore(84), 3);
      });

      test('score70_returns3', () {
        expect(service.getQualityFromScore(70), 3);
      });

      test('score69_returns2', () {
        expect(service.getQualityFromScore(69), 2);
      });

      test('score50_returns2', () {
        expect(service.getQualityFromScore(50), 2);
      });

      test('score49_returns1', () {
        expect(service.getQualityFromScore(49), 1);
      });

      test('score30_returns1', () {
        expect(service.getQualityFromScore(30), 1);
      });

      test('score29_returns0', () {
        expect(service.getQualityFromScore(29), 0);
      });

      test('score0_returns0', () {
        expect(service.getQualityFromScore(0), 0);
      });
    });

    group('updateEaseFactor', () {
      test('perfectQuality5_increasesEaseFactor', () {
        final result = service.updateEaseFactor(
          currentEaseFactor: 2.5,
          quality: 5,
        );

        // EF' = 2.5 + (0.1 - (5-5) * (0.08 + (5-5) * 0.02))
        // EF' = 2.5 + 0.1 = 2.6
        expect(result, closeTo(2.6, 0.001));
      });

      test('quality4_slightlyIncreasesEaseFactor', () {
        final result = service.updateEaseFactor(
          currentEaseFactor: 2.5,
          quality: 4,
        );

        // EF' = 2.5 + (0.1 - (5-4) * (0.08 + (5-4) * 0.02))
        // EF' = 2.5 + (0.1 - 1 * (0.08 + 0.02))
        // EF' = 2.5 + (0.1 - 0.1) = 2.5
        expect(result, closeTo(2.5, 0.001));
      });

      test('quality3_decreasesEaseFactor', () {
        final result = service.updateEaseFactor(
          currentEaseFactor: 2.5,
          quality: 3,
        );

        // EF' = 2.5 + (0.1 - (5-3) * (0.08 + (5-3) * 0.02))
        // EF' = 2.5 + (0.1 - 2 * (0.08 + 0.04))
        // EF' = 2.5 + (0.1 - 0.24) = 2.36
        expect(result, closeTo(2.36, 0.001));
      });

      test('quality2_decreasesEaseFactor', () {
        final result = service.updateEaseFactor(
          currentEaseFactor: 2.5,
          quality: 2,
        );

        // EF' = 2.5 + (0.1 - (5-2) * (0.08 + (5-2) * 0.02))
        // EF' = 2.5 + (0.1 - 3 * (0.08 + 0.06))
        // EF' = 2.5 + (0.1 - 0.42) = 2.18
        expect(result, closeTo(2.18, 0.001));
      });

      test('quality1_decreasesEaseFactor', () {
        final result = service.updateEaseFactor(
          currentEaseFactor: 2.5,
          quality: 1,
        );

        // EF' = 2.5 + (0.1 - (5-1) * (0.08 + (5-1) * 0.02))
        // EF' = 2.5 + (0.1 - 4 * (0.08 + 0.08))
        // EF' = 2.5 + (0.1 - 0.64) = 1.96
        expect(result, closeTo(1.96, 0.001));
      });

      test('quality0_decreasesEaseFactor', () {
        final result = service.updateEaseFactor(
          currentEaseFactor: 2.5,
          quality: 0,
        );

        // EF' = 2.5 + (0.1 - (5-0) * (0.08 + (5-0) * 0.02))
        // EF' = 2.5 + (0.1 - 5 * (0.08 + 0.1))
        // EF' = 2.5 + (0.1 - 0.9) = 1.7
        expect(result, closeTo(1.7, 0.001));
      });

      test('lowEaseFactor_clampsToMinimum', () {
        // Start with already low ease factor and fail badly
        final result = service.updateEaseFactor(
          currentEaseFactor: 1.4,
          quality: 0,
        );

        // Should not go below 1.3
        expect(result, 1.3);
      });

      test('repeatedFailures_clampsToMinimum', () {
        var easeFactor = 2.5;

        // Simulate multiple failures
        for (int i = 0; i < 10; i++) {
          easeFactor = service.updateEaseFactor(
            currentEaseFactor: easeFactor,
            quality: 0,
          );
        }

        expect(easeFactor, 1.3);
      });
    });

    group('calculateNextReview', () {
      test('incorrectAnswer_resetsToOneDay', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 30,
          answeredCorrectly: false,
          consecutiveCorrect: 5,
          easeFactor: 2.5,
        );

        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 1);
      });

      test('firstCorrect_returnsInterval1WithEaseFactor', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 0,
          answeredCorrectly: true,
          consecutiveCorrect: 0,
          easeFactor: 2.5,
        );

        // Interval 0 = 1 day * 2.5 = 2.5 ≈ 3 days
        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 3); // 1 * 2.5 = 2.5 rounded to 3
      });

      test('secondCorrect_returnsInterval3WithEaseFactor', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 1,
          answeredCorrectly: true,
          consecutiveCorrect: 1,
          easeFactor: 2.5,
        );

        // Interval 1 = 3 days * 2.5 = 7.5 ≈ 8 days
        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 8); // 3 * 2.5 = 7.5 rounded to 8
      });

      test('thirdCorrect_returnsInterval7WithEaseFactor', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 3,
          answeredCorrectly: true,
          consecutiveCorrect: 2,
          easeFactor: 2.5,
        );

        // Interval 2 = 7 days * 2.5 = 17.5 ≈ 18 days
        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 18); // 7 * 2.5 = 17.5 rounded to 18
      });

      test('easeFactor1_usesMinimalMultiplier', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 0,
          answeredCorrectly: true,
          consecutiveCorrect: 0,
          easeFactor: 1.0,
        );

        // Interval 0 = 1 day * 1.0 = 1 day
        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 1);
      });

      test('highConsecutiveCorrect_capsAtMaxInterval', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 60,
          answeredCorrectly: true,
          consecutiveCorrect: 100, // Way more than max index
          easeFactor: 2.5,
        );

        // Should use last interval (120) * 2.5 = 300 days
        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 300); // 120 * 2.5 = 300
      });

      test('consecutiveCorrectOfSix_usesInterval120', () {
        final now = DateTime.now();
        final result = service.calculateNextReview(
          currentInterval: 60,
          answeredCorrectly: true,
          consecutiveCorrect: 6, // Index 6 = 120 days
          easeFactor: 1.0,
        );

        final daysDiff = result.difference(now).inDays;
        expect(daysDiff, 120);
      });
    });
  });

  group('SpacedRepStatistics', () {
    test('accuracy_withNoReviews_returnsZero', () {
      const stats = SpacedRepStatistics(
        totalItems: 10,
        totalReviews: 0,
        totalCorrect: 0,
        averageInterval: 7.0,
        averageEaseFactor: 2.5,
        dueToday: 5,
      );

      expect(stats.accuracy, 0);
    });

    test('accuracy_allCorrect_returns100', () {
      const stats = SpacedRepStatistics(
        totalItems: 10,
        totalReviews: 50,
        totalCorrect: 50,
        averageInterval: 7.0,
        averageEaseFactor: 2.5,
        dueToday: 5,
      );

      expect(stats.accuracy, 100.0);
    });

    test('accuracy_halfCorrect_returns50', () {
      const stats = SpacedRepStatistics(
        totalItems: 10,
        totalReviews: 100,
        totalCorrect: 50,
        averageInterval: 7.0,
        averageEaseFactor: 2.5,
        dueToday: 5,
      );

      expect(stats.accuracy, 50.0);
    });

    test('accuracy_quarterCorrect_returns25', () {
      const stats = SpacedRepStatistics(
        totalItems: 10,
        totalReviews: 80,
        totalCorrect: 20,
        averageInterval: 7.0,
        averageEaseFactor: 2.5,
        dueToday: 5,
      );

      expect(stats.accuracy, 25.0);
    });

    test('hasCorrectValues', () {
      const stats = SpacedRepStatistics(
        totalItems: 15,
        totalReviews: 100,
        totalCorrect: 75,
        averageInterval: 10.5,
        averageEaseFactor: 2.3,
        dueToday: 8,
      );

      expect(stats.totalItems, 15);
      expect(stats.totalReviews, 100);
      expect(stats.totalCorrect, 75);
      expect(stats.averageInterval, 10.5);
      expect(stats.averageEaseFactor, 2.3);
      expect(stats.dueToday, 8);
      expect(stats.accuracy, 75.0);
    });
  });
}

/// Mock SpacedRepetitionDao for testing
class MockSpacedRepetitionDao implements SpacedRepetitionDao {
  final List<SpacedRepetitionModel> _records = [];

  @override
  Future<SpacedRepetitionModel?> getByConceptAndStudent({
    required String conceptId,
    required String studentId,
  }) async {
    try {
      return _records.firstWhere(
        (r) => r.conceptId == conceptId && r.studentId == studentId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> upsert(SpacedRepetitionModel model) async {
    _records.removeWhere((r) => r.id == model.id);
    _records.add(model);
  }

  @override
  Future<List<SpacedRepetitionModel>> getReviewsDue({
    required String studentId,
    DateTime? beforeDate,
    int? limit,
  }) async {
    final cutoff = beforeDate ?? DateTime.now();
    var results = _records.where(
      (r) => r.studentId == studentId && r.nextReviewDate.isBefore(cutoff),
    ).toList();
    if (limit != null) {
      results = results.take(limit).toList();
    }
    return results;
  }

  @override
  Future<int> getReviewsDueCount({
    required String studentId,
    DateTime? beforeDate,
  }) async {
    final cutoff = beforeDate ?? DateTime.now();
    return _records.where(
      (r) => r.studentId == studentId && r.nextReviewDate.isBefore(cutoff),
    ).length;
  }

  @override
  Future<Map<DateTime, int>> getUpcomingReviewSchedule({
    required String studentId,
    int days = 7,
  }) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> getStatistics(String studentId) async {
    return {
      'total_items': _records.where((r) => r.studentId == studentId).length,
      'total_reviews': 0,
      'total_correct': 0,
      'avg_interval': 7.0,
      'avg_ease_factor': 2.5,
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
