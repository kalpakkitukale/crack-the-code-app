/// Test suite for GamificationNotifier and GamificationState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/domain/entities/gamification/badge.dart';
import 'package:streamshaala/domain/entities/gamification/student_gamification.dart';
import 'package:streamshaala/domain/services/gamification_service.dart';
import 'package:streamshaala/presentation/providers/gamification/gamification_provider.dart';

void main() {
  group('GamificationState', () {
    test('initial_hasDefaultValues', () {
      final state = GamificationState.initial();

      expect(state.studentData, isNull);
      expect(state.allBadges, isEmpty);
      expect(state.unlockedBadges, isEmpty);
      expect(state.badgeProgress, isEmpty);
      expect(state.lastXpAward, isNull);
      expect(state.lastStreakUpdate, isNull);
      expect(state.newlyUnlockedBadges, isNull);
      expect(state.showLevelUpAnimation, false);
      expect(state.showBadgeUnlockedDialog, false);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('derivedGetters_returnDefaultsWhenStudentDataNull', () {
      final state = GamificationState.initial();

      expect(state.totalXp, 0);
      expect(state.level, 1);
      expect(state.levelTitle, 'Novice');
      expect(state.currentStreak, 0);
      expect(state.longestStreak, 0);
      expect(state.levelProgress, 0.0);
      expect(state.xpForNextLevel, 100);
      expect(state.xpProgress, 0);
      expect(state.isStreakAtRisk, false);
      expect(state.isActiveToday, false);
    });

    test('derivedGetters_returnStudentDataValues', () {
      final studentData = StudentGamification(
        id: 'gam-1',
        studentId: 'student-1',
        totalXp: 250,
        level: 3,
        currentStreak: 5,
        longestStreak: 10,
        lastActiveDate: DateTime.now(),
      );

      final state = GamificationState(
        studentData: studentData,
      );

      expect(state.totalXp, 250);
      expect(state.level, 3);
      expect(state.currentStreak, 5);
      expect(state.longestStreak, 10);
      expect(state.isActiveToday, true);
    });

    test('levelTitle_changesWithLevel', () {
      expect(_stateWithLevel(1).levelTitle, 'Novice');
      expect(_stateWithLevel(5).levelTitle, 'Beginner');
      expect(_stateWithLevel(10).levelTitle, 'Intermediate');
      expect(_stateWithLevel(20).levelTitle, 'Advanced');
      expect(_stateWithLevel(30).levelTitle, 'Expert');
      expect(_stateWithLevel(40).levelTitle, 'Master');
      expect(_stateWithLevel(50).levelTitle, 'Grandmaster');
    });

    test('badgeCounts_calculateCorrectly', () {
      final allBadges = [
        _createTestBadge('badge-1'),
        _createTestBadge('badge-2'),
        _createTestBadge('badge-3'),
      ];
      final unlockedBadges = [
        _createTestBadge('badge-1'),
      ];

      final state = GamificationState(
        allBadges: allBadges,
        unlockedBadges: unlockedBadges,
      );

      expect(state.totalBadgeCount, 3);
      expect(state.unlockedBadgeCount, 1);
    });

    test('justLeveledUp_checksLastXpAward', () {
      final noAward = GamificationState.initial();
      expect(noAward.justLeveledUp, false);

      final withAwardNoLevelUp = GamificationState(
        lastXpAward: const XpAwardResult(
          xpAwarded: 10,
          newTotalXp: 110,
          newLevel: 1,
          leveledUp: false,
          newBadges: [],
        ),
      );
      expect(withAwardNoLevelUp.justLeveledUp, false);

      final withAwardLevelUp = GamificationState(
        lastXpAward: const XpAwardResult(
          xpAwarded: 50,
          newTotalXp: 500,
          newLevel: 2,
          leveledUp: true,
          newBadges: [],
        ),
      );
      expect(withAwardLevelUp.justLeveledUp, true);
    });

    group('copyWith', () {
      test('updatesSpecifiedFields', () {
        final initial = GamificationState.initial();
        final studentData = StudentGamification(
          id: 'gam-1',
          studentId: 'student-1',
        );

        final updated = initial.copyWith(
          studentData: studentData,
          isLoading: true,
          showLevelUpAnimation: true,
        );

        expect(updated.studentData, studentData);
        expect(updated.isLoading, true);
        expect(updated.showLevelUpAnimation, true);
      });

      test('clearNewBadges_clearsNewlyUnlockedBadges', () {
        final initial = GamificationState(
          newlyUnlockedBadges: [_createTestBadge('new-badge')],
        );

        final updated = initial.copyWith(clearNewBadges: true);

        expect(updated.newlyUnlockedBadges, isNull);
      });

      test('clearLastXpAward_clearsLastXpAward', () {
        final initial = GamificationState(
          lastXpAward: const XpAwardResult(
            xpAwarded: 10,
            newTotalXp: 110,
            newLevel: 1,
            leveledUp: false,
            newBadges: [],
          ),
        );

        final updated = initial.copyWith(clearLastXpAward: true);

        expect(updated.lastXpAward, isNull);
      });

      test('clearError_clearsError', () {
        final initial = GamificationState(error: 'Some error');

        final updated = initial.copyWith(clearError: true);

        expect(updated.error, isNull);
      });
    });
  });

  group('StreakData', () {
    test('equality_worksCorrectly', () {
      const streak1 = StreakData(
        currentStreak: 5,
        longestStreak: 10,
        isStreakAtRisk: false,
        isActiveToday: true,
      );
      const streak2 = StreakData(
        currentStreak: 5,
        longestStreak: 10,
        isStreakAtRisk: false,
        isActiveToday: true,
      );
      const streak3 = StreakData(
        currentStreak: 6,
        longestStreak: 10,
        isStreakAtRisk: false,
        isActiveToday: true,
      );

      expect(streak1, equals(streak2));
      expect(streak1, isNot(equals(streak3)));
    });

    test('hashCode_isConsistent', () {
      const streak1 = StreakData(
        currentStreak: 5,
        longestStreak: 10,
        isStreakAtRisk: false,
        isActiveToday: true,
      );
      const streak2 = StreakData(
        currentStreak: 5,
        longestStreak: 10,
        isStreakAtRisk: false,
        isActiveToday: true,
      );

      expect(streak1.hashCode, equals(streak2.hashCode));
    });
  });

  group('XpLevelData', () {
    test('equality_worksCorrectly', () {
      const xp1 = XpLevelData(
        level: 5,
        levelTitle: 'Beginner',
        totalXp: 500,
        xpProgress: 100,
        xpForNextLevel: 3600,
        levelProgress: 0.5,
      );
      const xp2 = XpLevelData(
        level: 5,
        levelTitle: 'Beginner',
        totalXp: 500,
        xpProgress: 100,
        xpForNextLevel: 3600,
        levelProgress: 0.5,
      );
      const xp3 = XpLevelData(
        level: 6,
        levelTitle: 'Beginner',
        totalXp: 500,
        xpProgress: 100,
        xpForNextLevel: 3600,
        levelProgress: 0.5,
      );

      expect(xp1, equals(xp2));
      expect(xp1, isNot(equals(xp3)));
    });

    test('hashCode_isConsistent', () {
      const xp1 = XpLevelData(
        level: 5,
        levelTitle: 'Beginner',
        totalXp: 500,
        xpProgress: 100,
        xpForNextLevel: 3600,
        levelProgress: 0.5,
      );
      const xp2 = XpLevelData(
        level: 5,
        levelTitle: 'Beginner',
        totalXp: 500,
        xpProgress: 100,
        xpForNextLevel: 3600,
        levelProgress: 0.5,
      );

      expect(xp1.hashCode, equals(xp2.hashCode));
    });
  });

  group('GamificationNotifier', () {
    late MockGamificationService mockService;

    setUp(() {
      mockService = MockGamificationService();
    });

    GamificationNotifier createNotifier() {
      return GamificationNotifier(gamificationService: mockService);
    }

    group('loadGamification', () {
      test('success_updatesStateWithData', () async {
        final studentData = StudentGamification(
          id: 'gam-1',
          studentId: 'student-1',
          totalXp: 250,
          level: 2,
          unlockedBadgeIds: ['badge-1'],
        );
        final badges = [
          _createTestBadge('badge-1'),
          _createTestBadge('badge-2'),
        ];
        mockService.setStudentState(studentData);
        mockService.setBadges(badges);

        final notifier = createNotifier();

        await notifier.loadGamification('student-1');

        expect(notifier.state.studentData, studentData);
        expect(notifier.state.allBadges, badges);
        expect(notifier.state.unlockedBadges.length, 1);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
      });

      test('failure_setsErrorState', () async {
        mockService.setError('Failed to load');

        final notifier = createNotifier();

        await notifier.loadGamification('student-1');

        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, contains('Failed to load'));
      });
    });

    group('awardXp', () {
      test('success_updatesStateWithXpAward', () async {
        final studentData = StudentGamification(
          id: 'gam-1',
          studentId: 'student-1',
          totalXp: 100,
          level: 1,
        );
        final xpResult = const XpAwardResult(
          xpAwarded: 10,
          newTotalXp: 110,
          newLevel: 1,
          leveledUp: false,
          newBadges: [],
        );
        mockService.setStudentState(studentData);
        mockService.setXpResult(xpResult);
        mockService.setBadges([]);

        final notifier = createNotifier();

        await notifier.awardXp(
          studentId: 'student-1',
          event: XpEventType.watchVideo,
        );

        expect(notifier.state.lastXpAward, xpResult);
        expect(notifier.state.showLevelUpAnimation, false);
      });

      test('levelUp_triggersAnimation', () async {
        final studentData = StudentGamification(
          id: 'gam-1',
          studentId: 'student-1',
          totalXp: 400,
          level: 2,
        );
        final xpResult = const XpAwardResult(
          xpAwarded: 100,
          newTotalXp: 500,
          newLevel: 2,
          leveledUp: true,
          newBadges: [],
        );
        mockService.setStudentState(studentData);
        mockService.setXpResult(xpResult);
        mockService.setBadges([]);

        final notifier = createNotifier();

        await notifier.awardXp(
          studentId: 'student-1',
          event: XpEventType.completeChapter,
        );

        expect(notifier.state.showLevelUpAnimation, true);
      });
    });

    group('updateStreak', () {
      test('success_updatesStateWithStreakResult', () async {
        final studentData = StudentGamification(
          id: 'gam-1',
          studentId: 'student-1',
          currentStreak: 5,
          longestStreak: 10,
        );
        final streakResult = const StreakResult(
          currentStreak: 6,
          longestStreak: 10,
          streakIncremented: true,
          streakBroken: false,
        );
        mockService.setStudentState(studentData);
        mockService.setStreakResult(streakResult);
        mockService.setBadges([]);

        final notifier = createNotifier();

        await notifier.updateStreak('student-1');

        expect(notifier.state.lastStreakUpdate, streakResult);
      });
    });

    group('UI actions', () {
      test('dismissLevelUpAnimation_clearsAnimation', () {
        final notifier = createNotifier();
        // Manually set animation flag
        notifier.state = notifier.state.copyWith(showLevelUpAnimation: true);

        notifier.dismissLevelUpAnimation();

        expect(notifier.state.showLevelUpAnimation, false);
      });

      test('dismissBadgeUnlockedDialog_clearsDialogAndBadges', () {
        final notifier = createNotifier();
        // Manually set dialog flag
        notifier.state = notifier.state.copyWith(
          showBadgeUnlockedDialog: true,
          newlyUnlockedBadges: [_createTestBadge('new')],
        );

        notifier.dismissBadgeUnlockedDialog();

        expect(notifier.state.showBadgeUnlockedDialog, false);
        expect(notifier.state.newlyUnlockedBadges, isNull);
      });

      test('clearLastXpAward_clearsXpAward', () {
        final notifier = createNotifier();
        notifier.state = notifier.state.copyWith(
          lastXpAward: const XpAwardResult(
            xpAwarded: 10,
            newTotalXp: 110,
            newLevel: 1,
            leveledUp: false,
            newBadges: [],
          ),
        );

        notifier.clearLastXpAward();

        expect(notifier.state.lastXpAward, isNull);
      });

      test('clearError_clearsError', () {
        final notifier = createNotifier();
        notifier.state = notifier.state.copyWith(error: 'Some error');

        notifier.clearError();

        expect(notifier.state.error, isNull);
      });
    });
  });
}

/// Helper to create state with specific level
GamificationState _stateWithLevel(int level) {
  return GamificationState(
    studentData: StudentGamification(
      id: 'gam-1',
      studentId: 'student-1',
      level: level,
    ),
  );
}

/// Create a test badge
Badge _createTestBadge(String id) {
  return Badge(
    id: id,
    name: 'Test Badge $id',
    description: 'Description for $id',
    iconPath: 'assets/badges/$id.png',
    category: BadgeCategory.learning,
    condition: const VideosWatchedCondition(5),
  );
}

/// Mock GamificationService
class MockGamificationService implements GamificationService {
  StudentGamification? _studentState;
  List<Badge> _badges = [];
  XpAwardResult? _xpResult;
  StreakResult? _streakResult;
  String? _error;

  void setStudentState(StudentGamification state) {
    _studentState = state;
    _error = null;
  }

  void setBadges(List<Badge> badges) {
    _badges = badges;
  }

  void setXpResult(XpAwardResult result) {
    _xpResult = result;
  }

  void setStreakResult(StreakResult result) {
    _streakResult = result;
  }

  void setError(String error) {
    _error = error;
  }

  @override
  Future<StudentGamification?> getState(String studentId) async {
    if (_error != null) throw Exception(_error);
    return _studentState;
  }

  @override
  Future<List<Badge>> loadBadges() async {
    if (_error != null) throw Exception(_error);
    return _badges;
  }

  @override
  Future<XpAwardResult> awardXp({
    required String studentId,
    required XpEventType event,
    int? bonusMultiplier,
    String? entityId,
    String? entityType,
  }) async {
    if (_error != null) throw Exception(_error);
    return _xpResult ?? const XpAwardResult(
      xpAwarded: 10,
      newTotalXp: 110,
      newLevel: 1,
      leveledUp: false,
      newBadges: [],
    );
  }

  @override
  Future<StreakResult> updateStreak(String studentId) async {
    if (_error != null) throw Exception(_error);
    return _streakResult ?? const StreakResult(
      currentStreak: 1,
      longestStreak: 1,
      streakIncremented: true,
      streakBroken: false,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentXpEvents({
    required String studentId,
    int limit = 20,
  }) async {
    return [];
  }

  // Required by interface but not used in tests
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
