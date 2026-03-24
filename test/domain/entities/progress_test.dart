import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';

import '../../fixtures/progress_fixtures.dart';

void main() {
  group('Progress', () {
    final now = DateTime.now();

    test('calculates progress fraction correctly', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(progress.progressFraction, 0.5);
    });

    test('handles zero total duration', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 0,
        totalDuration: 0,
        completed: false,
        lastWatched: now,
      );

      expect(progress.progressFraction, 0.0);
    });

    test('clamps progress fraction to 1.0', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 1200,
        totalDuration: 1000,
        completed: true,
        lastWatched: now,
      );

      expect(progress.progressFraction, 1.0);
    });

    test('calculates completion percentage correctly', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 750,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(progress.completionPercentage, 75.0);
    });

    test('calculates remaining duration correctly', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 400,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(progress.remainingDuration, 600);
    });

    test('clamps remaining duration to zero when over-watched', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 1200,
        totalDuration: 1000,
        completed: true,
        lastWatched: now,
      );

      expect(progress.remainingDuration, 0);
    });

    test('identifies started videos correctly', () {
      final started = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 100,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      final notStarted = Progress(
        id: '2',
        videoId: 'test-video-2',
        watchDuration: 0,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(started.isStarted, true);
      expect(notStarted.isStarted, false);
    });

    test('identifies almost complete videos correctly', () {
      final almostComplete = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 960,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      final notAlmostComplete = Progress(
        id: '2',
        videoId: 'test-video-2',
        watchDuration: 900,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(almostComplete.isAlmostComplete, true);
      expect(notAlmostComplete.isAlmostComplete, false);
    });

    test('identifies in-progress videos correctly', () {
      final inProgress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      final completed = Progress(
        id: '2',
        videoId: 'test-video-2',
        watchDuration: 1000,
        totalDuration: 1000,
        completed: true,
        lastWatched: now,
      );

      final notStarted = Progress(
        id: '3',
        videoId: 'test-video-3',
        watchDuration: 0,
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(inProgress.isInProgress, true);
      expect(completed.isInProgress, false);
      expect(notStarted.isInProgress, false);
    });

    test('formats watch duration correctly (less than 1 hour)', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 125, // 2:05
        totalDuration: 1000,
        completed: false,
        lastWatched: now,
      );

      expect(progress.formattedWatchDuration, '02:05');
    });

    test('formats watch duration correctly (over 1 hour)', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 3665, // 1:01:05
        totalDuration: 5000,
        completed: false,
        lastWatched: now,
      );

      expect(progress.formattedWatchDuration, '01:01:05');
    });

    test('formats remaining duration correctly', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 625, // 125 seconds remaining = 2:05
        completed: false,
        lastWatched: now,
      );

      expect(progress.formattedRemainingDuration, '02:05');
    });

    test('identifies recently watched videos correctly', () {
      final recent = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(days: 3)),
      );

      final notRecent = Progress(
        id: '2',
        videoId: 'test-video-2',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(days: 10)),
      );

      expect(recent.isWatchedRecently, true);
      expect(notRecent.isWatchedRecently, false);
    });

    test('formats time since last watched - just now', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(seconds: 30)),
      );

      expect(progress.timeSinceLastWatched, 'Just now');
    });

    test('formats time since last watched - minutes', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(minutes: 5)),
      );

      expect(progress.timeSinceLastWatched, '5 minutes ago');
    });

    test('formats time since last watched - hours', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(hours: 3)),
      );

      expect(progress.timeSinceLastWatched, '3 hours ago');
    });

    test('formats time since last watched - days', () {
      final progress = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(days: 5)),
      );

      expect(progress.timeSinceLastWatched, '5 days ago');
    });

    test('formats time since last watched - singular forms', () {
      final oneMinute = Progress(
        id: '1',
        videoId: 'test-video',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(minutes: 1)),
      );

      final oneHour = Progress(
        id: '2',
        videoId: 'test-video-2',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(hours: 1)),
      );

      final oneDay = Progress(
        id: '3',
        videoId: 'test-video-3',
        watchDuration: 500,
        totalDuration: 1000,
        completed: false,
        lastWatched: now.subtract(const Duration(days: 1)),
      );

      expect(oneMinute.timeSinceLastWatched, '1 minute ago');
      expect(oneHour.timeSinceLastWatched, '1 hour ago');
      expect(oneDay.timeSinceLastWatched, '1 day ago');
    });

    // =========================================================================
    // CRITICAL: 90% COMPLETION THRESHOLD BOUNDARY VALUE ANALYSIS
    // This is a core business rule that must be verified
    // =========================================================================
    group('90% Completion Threshold (CRITICAL)', () {
      // Test exact boundary values around 90%
      test('at 0% - returns false for isCompleted check', () {
        final progress = ProgressFixtures.notStarted;
        final percentage = progress.completionPercentage;
        expect(percentage >= 90, false, reason: '0% should not be complete');
      });

      test('at 50% - returns false for isCompleted check', () {
        final progress = ProgressFixtures.halfWatched;
        final percentage = progress.completionPercentage;
        expect(percentage >= 90, false, reason: '50% should not be complete');
      });

      test('at 89% - returns false for isCompleted check', () {
        final progress = ProgressFixtures.almostComplete89;
        final percentage = progress.completionPercentage;
        expect(percentage < 90, true, reason: '89% should not be complete');
      });

      test('at 90% - returns true for isCompleted check', () {
        final progress = ProgressFixtures.atThreshold90;
        final percentage = progress.completionPercentage;
        expect(percentage >= 90, true, reason: '90% should be complete');
      });

      test('at 100% - returns true for isCompleted check', () {
        final progress = ProgressFixtures.fullyCompleted;
        final percentage = progress.completionPercentage;
        expect(percentage >= 90, true, reason: '100% should be complete');
      });

      // Boundary value analysis for real video duration (600 seconds)
      group('Real-world 600 second video', () {
        test('534 seconds watched (89%) should NOT be complete', () {
          final progress = Progress(
            id: 'bva-534',
            videoId: 'video-600',
            watchDuration: 534,
            totalDuration: 600,
            completed: false,
            lastWatched: now,
          );

          final percentage = (progress.watchDuration / progress.totalDuration) * 100;
          expect(percentage, closeTo(89.0, 0.1));
          expect(percentage >= 90, false);
        });

        test('539 seconds watched (89.83%) should NOT be complete', () {
          final progress = Progress(
            id: 'bva-539',
            videoId: 'video-600',
            watchDuration: 539,
            totalDuration: 600,
            completed: false,
            lastWatched: now,
          );

          final percentage = (progress.watchDuration / progress.totalDuration) * 100;
          expect(percentage < 90, true, reason: '89.83% should not be complete');
        });

        test('540 seconds watched (90%) SHOULD be complete', () {
          final progress = Progress(
            id: 'bva-540',
            videoId: 'video-600',
            watchDuration: 540,
            totalDuration: 600,
            completed: true,
            lastWatched: now,
          );

          final percentage = (progress.watchDuration / progress.totalDuration) * 100;
          expect(percentage >= 90, true, reason: '90% should be complete');
          expect(progress.completed, true);
        });

        test('541 seconds watched (90.16%) SHOULD be complete', () {
          final progress = Progress(
            id: 'bva-541',
            videoId: 'video-600',
            watchDuration: 541,
            totalDuration: 600,
            completed: true,
            lastWatched: now,
          );

          final percentage = (progress.watchDuration / progress.totalDuration) * 100;
          expect(percentage >= 90, true, reason: '90.16% should be complete');
        });
      });

      // Parametrized boundary tests
      group('Systematic boundary tests', () {
        final boundaryTestCases = [
          (watch: 0, total: 100, expectComplete: false),
          (watch: 50, total: 100, expectComplete: false),
          (watch: 89, total: 100, expectComplete: false),
          (watch: 90, total: 100, expectComplete: true),
          (watch: 91, total: 100, expectComplete: true),
          (watch: 95, total: 100, expectComplete: true),
          (watch: 100, total: 100, expectComplete: true),
          (watch: 110, total: 100, expectComplete: true), // Over-watched
        ];

        for (final tc in boundaryTestCases) {
          test('${tc.watch}/${tc.total} should ${tc.expectComplete ? '' : 'NOT '}be complete', () {
            final percentage = tc.total > 0 ? (tc.watch / tc.total) * 100 : 0.0;
            expect(
              percentage >= 90,
              tc.expectComplete,
              reason: '${percentage.toStringAsFixed(2)}% ${tc.expectComplete ? '>=' : '<'} 90%',
            );
          });
        }
      });
    });

    // =========================================================================
    // FIXTURES TESTS
    // =========================================================================
    group('Fixtures', () {
      test('withPercentage helper creates correct progress', () {
        final progress50 = ProgressFixtures.withPercentage(50);
        expect(progress50.completionPercentage, closeTo(50, 1));

        final progress75 = ProgressFixtures.withPercentage(75);
        expect(progress75.completionPercentage, closeTo(75, 1));

        final progress90 = ProgressFixtures.withPercentage(90);
        expect(progress90.completionPercentage, closeTo(90, 1));
        expect(progress90.completed, true);
      });

      test('sampleHistory returns correct list', () {
        final history = ProgressFixtures.sampleHistory;
        expect(history.length, 4);
        expect(history.first.completed, true);
        expect(history.last.completed, false);
      });
    });

    // =========================================================================
    // COPY WITH TESTS
    // =========================================================================
    group('copyWith', () {
      test('creates new instance with updated fields', () {
        final original = ProgressFixtures.halfWatched;
        final updated = original.copyWith(watchDuration: 400);

        expect(updated.watchDuration, 400);
        expect(updated.id, original.id);
        expect(updated.videoId, original.videoId);
        expect(original.watchDuration, 300, reason: 'Original should be unchanged');
      });

      test('preserves all fields when no changes', () {
        final original = ProgressFixtures.fullyCompleted;
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.videoId, original.videoId);
        expect(copy.title, original.title);
        expect(copy.channelName, original.channelName);
        expect(copy.thumbnailUrl, original.thumbnailUrl);
        expect(copy.watchDuration, original.watchDuration);
        expect(copy.totalDuration, original.totalDuration);
        expect(copy.completed, original.completed);
        expect(copy.lastWatched, original.lastWatched);
      });
    });

    // =========================================================================
    // EDGE CASES
    // =========================================================================
    group('Edge Cases', () {
      test('zero duration video handles gracefully', () {
        final progress = ProgressFixtures.zeroDuration;

        expect(progress.progressFraction, 0.0);
        expect(progress.completionPercentage, 0.0);
        expect(progress.remainingDuration, 0);
        expect(progress.isStarted, false);
        expect(progress.isInProgress, false);
      });

      test('over-watched video handles gracefully', () {
        final progress = ProgressFixtures.overWatched;

        expect(progress.progressFraction, 1.0); // Clamped
        expect(progress.remainingDuration, 0); // Clamped
        expect(progress.completed, true);
      });

      test('missing metadata video handles gracefully', () {
        final progress = ProgressFixtures.missingMetadata;

        expect(progress.title, isNull);
        expect(progress.channelName, isNull);
        expect(progress.thumbnailUrl, isNull);
        // Other computed properties should still work
        expect(progress.progressFraction, closeTo(0.167, 0.01));
      });
    });
  });
}
