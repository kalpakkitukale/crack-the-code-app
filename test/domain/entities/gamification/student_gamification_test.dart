/// Tests for StudentGamification entity computed properties
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/entities/gamification/student_gamification.dart';

void main() {
  group('StudentGamification', () {
    group('xpForNextLevel', () {
      test('level1_returns400', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
        );

        // level 2 = 2^2 * 100 = 400
        expect(gamification.xpForNextLevel, 400);
      });

      test('level5_returns3600', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
        );

        // level 6 = 6^2 * 100 = 3600
        expect(gamification.xpForNextLevel, 3600);
      });

      test('level10_returns12100', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 10,
        );

        // level 11 = 11^2 * 100 = 12100
        expect(gamification.xpForNextLevel, 12100);
      });
    });

    group('xpForCurrentLevel', () {
      test('level1_returns100', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
        );

        // level 1 = 1^2 * 100 = 100
        expect(gamification.xpForCurrentLevel, 100);
      });

      test('level5_returns2500', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
        );

        // level 5 = 5^2 * 100 = 2500
        expect(gamification.xpForCurrentLevel, 2500);
      });
    });

    group('xpProgress', () {
      test('noXp_returnsZero', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
          totalXp: 0,
        );

        // 0 - 100 = -100, but clamped to 0
        expect(gamification.xpProgress, 0);
      });

      test('atLevelThreshold_returnsZero', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
          totalXp: 2500, // Exactly at level 5 threshold
        );

        // 2500 - 2500 = 0
        expect(gamification.xpProgress, 0);
      });

      test('aboveLevelThreshold_returnsProgress', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
          totalXp: 3000, // 500 above level 5 threshold
        );

        // 3000 - 2500 = 500
        expect(gamification.xpProgress, 500);
      });

      test('belowThreshold_clampsToZero', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
          totalXp: 100, // Well below level 5 threshold of 2500
        );

        // 100 - 2500 = -2400, clamped to 0
        expect(gamification.xpProgress, 0);
      });
    });

    group('levelProgress', () {
      test('atLevelStart_returnsZero', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
          totalXp: 100, // At level 1 threshold
        );

        expect(gamification.levelProgress, 0.0);
      });

      test('halfwayToNextLevel_returns0Point5', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
          totalXp: 250, // 150 progress, 300 needed for next level
        );

        // xpNeeded = 400 - 100 = 300
        // xpProgress = 250 - 100 = 150
        // progress = 150 / 300 = 0.5
        expect(gamification.levelProgress, 0.5);
      });

      test('almostAtNextLevel_returnsHighValue', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
          totalXp: 390, // Close to 400 needed for level 2
        );

        // progress = (390-100) / (400-100) = 290/300 = 0.9667
        expect(gamification.levelProgress, closeTo(0.967, 0.001));
      });

      test('belowCurrentLevel_clampsToZero', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
          totalXp: 100, // Below level 5 threshold
        );

        expect(gamification.levelProgress, 0.0);
      });

      test('aboveNextLevel_clampsToOne', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
          totalXp: 500, // Above level 2 threshold of 400
        );

        // progress would be > 1.0 but clamped to 1.0
        expect(gamification.levelProgress, 1.0);
      });
    });

    group('isActiveToday', () {
      test('noLastActiveDate_returnsFalse', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
        );

        expect(gamification.isActiveToday, false);
      });

      test('activeToday_returnsTrue', () {
        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          lastActiveDate: DateTime.now(),
        );

        expect(gamification.isActiveToday, true);
      });

      test('activeYesterday_returnsFalse', () {
        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        expect(gamification.isActiveToday, false);
      });

      test('activeEarlierToday_returnsTrue', () {
        final now = DateTime.now();
        final earlierToday = DateTime(now.year, now.month, now.day, 1, 0);

        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          lastActiveDate: earlierToday,
        );

        expect(gamification.isActiveToday, true);
      });
    });

    group('isStreakAtRisk', () {
      test('noLastActiveDate_withStreak_returnsTrue', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          currentStreak: 5,
          lastActiveDate: null,
        );

        expect(gamification.isStreakAtRisk, true);
      });

      test('noLastActiveDate_noStreak_returnsFalse', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          currentStreak: 0,
          lastActiveDate: null,
        );

        expect(gamification.isStreakAtRisk, false);
      });

      test('activeToday_returnsFalse', () {
        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          currentStreak: 5,
          lastActiveDate: DateTime.now(),
        );

        expect(gamification.isStreakAtRisk, false);
      });

      test('activeYesterday_returnsFalse', () {
        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          currentStreak: 5,
          lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        expect(gamification.isStreakAtRisk, false);
      });

      test('activeTwoDaysAgo_withStreak_returnsTrue', () {
        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          currentStreak: 5,
          lastActiveDate: DateTime.now().subtract(const Duration(days: 2)),
        );

        expect(gamification.isStreakAtRisk, true);
      });

      test('activeTwoDaysAgo_noStreak_returnsFalse', () {
        final gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          currentStreak: 0,
          lastActiveDate: DateTime.now().subtract(const Duration(days: 2)),
        );

        expect(gamification.isStreakAtRisk, false);
      });
    });

    group('levelTitle', () {
      test('level1_returnsNovice', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 1,
        );

        expect(gamification.levelTitle, 'Novice');
      });

      test('level4_returnsNovice', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 4,
        );

        expect(gamification.levelTitle, 'Novice');
      });

      test('level5_returnsBeginner', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 5,
        );

        expect(gamification.levelTitle, 'Beginner');
      });

      test('level9_returnsBeginner', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 9,
        );

        expect(gamification.levelTitle, 'Beginner');
      });

      test('level10_returnsIntermediate', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 10,
        );

        expect(gamification.levelTitle, 'Intermediate');
      });

      test('level20_returnsAdvanced', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 20,
        );

        expect(gamification.levelTitle, 'Advanced');
      });

      test('level30_returnsExpert', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 30,
        );

        expect(gamification.levelTitle, 'Expert');
      });

      test('level40_returnsMaster', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 40,
        );

        expect(gamification.levelTitle, 'Master');
      });

      test('level50_returnsGrandmaster', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 50,
        );

        expect(gamification.levelTitle, 'Grandmaster');
      });

      test('level100_returnsGrandmaster', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
          level: 100,
        );

        expect(gamification.levelTitle, 'Grandmaster');
      });
    });

    group('default values', () {
      test('hasCorrectDefaults', () {
        const gamification = StudentGamification(
          id: 'test-1',
          studentId: 'student-1',
        );

        expect(gamification.totalXp, 0);
        expect(gamification.level, 1);
        expect(gamification.currentStreak, 0);
        expect(gamification.longestStreak, 0);
        expect(gamification.lastActiveDate, isNull);
        expect(gamification.unlockedBadgeIds, isEmpty);
        expect(gamification.updatedAt, isNull);
      });
    });
  });

  group('XpEventType', () {
    test('baseXp_values', () {
      expect(XpEventType.watchVideo.baseXp, 10);
      expect(XpEventType.passPreQuiz.baseXp, 15);
      expect(XpEventType.passPostQuiz.baseXp, 25);
      expect(XpEventType.perfectScore.baseXp, 50);
      expect(XpEventType.dailyStreak.baseXp, 10);
      expect(XpEventType.weekStreak.baseXp, 50);
      expect(XpEventType.completeChapter.baseXp, 100);
      expect(XpEventType.fixGap.baseXp, 30);
      expect(XpEventType.completeReview.baseXp, 15);
      expect(XpEventType.completePath.baseXp, 200);
      expect(XpEventType.unlockBadge.baseXp, 25);
      expect(XpEventType.firstVideoOfDay.baseXp, 5);
    });

    test('displayName_values', () {
      expect(XpEventType.watchVideo.displayName, 'Video Watched');
      expect(XpEventType.passPreQuiz.displayName, 'Pre-Quiz Passed');
      expect(XpEventType.passPostQuiz.displayName, 'Post-Quiz Passed');
      expect(XpEventType.perfectScore.displayName, 'Perfect Score!');
      expect(XpEventType.dailyStreak.displayName, 'Daily Streak');
      expect(XpEventType.weekStreak.displayName, 'Week Streak Bonus');
      expect(XpEventType.completeChapter.displayName, 'Chapter Complete');
      expect(XpEventType.fixGap.displayName, 'Gap Fixed');
      expect(XpEventType.completeReview.displayName, 'Review Complete');
      expect(XpEventType.completePath.displayName, 'Path Complete');
      expect(XpEventType.unlockBadge.displayName, 'Badge Unlocked');
      expect(XpEventType.firstVideoOfDay.displayName, 'First Video Today');
    });
  });

  group('XpAwardResult', () {
    test('hasCorrectValues', () {
      const result = XpAwardResult(
        xpAwarded: 50,
        newTotalXp: 250,
        newLevel: 2,
        leveledUp: true,
        newBadges: ['badge-1', 'badge-2'],
      );

      expect(result.xpAwarded, 50);
      expect(result.newTotalXp, 250);
      expect(result.newLevel, 2);
      expect(result.leveledUp, true);
      expect(result.newBadges, ['badge-1', 'badge-2']);
    });

    test('leveledUp_canBeFalse', () {
      const result = XpAwardResult(
        xpAwarded: 10,
        newTotalXp: 110,
        newLevel: 1,
        leveledUp: false,
        newBadges: [],
      );

      expect(result.leveledUp, false);
      expect(result.newBadges, isEmpty);
    });
  });

  group('StreakResult', () {
    test('hasCorrectValues', () {
      const result = StreakResult(
        currentStreak: 7,
        longestStreak: 10,
        streakIncremented: true,
        streakBroken: false,
        bonusXp: 50,
      );

      expect(result.currentStreak, 7);
      expect(result.longestStreak, 10);
      expect(result.streakIncremented, true);
      expect(result.streakBroken, false);
      expect(result.bonusXp, 50);
    });

    test('streakBroken_scenario', () {
      const result = StreakResult(
        currentStreak: 1,
        longestStreak: 10,
        streakIncremented: true,
        streakBroken: true,
      );

      expect(result.currentStreak, 1);
      expect(result.streakBroken, true);
      expect(result.bonusXp, isNull);
    });
  });
}
