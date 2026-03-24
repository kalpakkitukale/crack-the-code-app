/// Gamification state management provider
///
/// Manages XP, levels, streaks, and badges
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/gamification/badge.dart';
import 'package:crack_the_code/domain/entities/gamification/student_gamification.dart';
import 'package:crack_the_code/domain/services/gamification_service.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Gamification state
class GamificationState {
  final StudentGamification? studentData;
  final List<Badge> allBadges;
  final List<Badge> unlockedBadges;
  final List<BadgeProgress> badgeProgress;
  final XpAwardResult? lastXpAward;
  final StreakResult? lastStreakUpdate;
  final List<Badge>? newlyUnlockedBadges;
  final bool showLevelUpAnimation;
  final bool showBadgeUnlockedDialog;
  final bool isLoading;
  final String? error;

  const GamificationState({
    this.studentData,
    this.allBadges = const [],
    this.unlockedBadges = const [],
    this.badgeProgress = const [],
    this.lastXpAward,
    this.lastStreakUpdate,
    this.newlyUnlockedBadges,
    this.showLevelUpAnimation = false,
    this.showBadgeUnlockedDialog = false,
    this.isLoading = false,
    this.error,
  });

  factory GamificationState.initial() => const GamificationState();

  GamificationState copyWith({
    StudentGamification? studentData,
    List<Badge>? allBadges,
    List<Badge>? unlockedBadges,
    List<BadgeProgress>? badgeProgress,
    XpAwardResult? lastXpAward,
    StreakResult? lastStreakUpdate,
    List<Badge>? newlyUnlockedBadges,
    bool? showLevelUpAnimation,
    bool? showBadgeUnlockedDialog,
    bool? isLoading,
    String? error,
    bool clearNewBadges = false,
    bool clearLastXpAward = false,
    bool clearError = false,
  }) {
    return GamificationState(
      studentData: studentData ?? this.studentData,
      allBadges: allBadges ?? this.allBadges,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      badgeProgress: badgeProgress ?? this.badgeProgress,
      lastXpAward: clearLastXpAward ? null : lastXpAward ?? this.lastXpAward,
      lastStreakUpdate: lastStreakUpdate ?? this.lastStreakUpdate,
      newlyUnlockedBadges: clearNewBadges ? null : newlyUnlockedBadges ?? this.newlyUnlockedBadges,
      showLevelUpAnimation: showLevelUpAnimation ?? this.showLevelUpAnimation,
      showBadgeUnlockedDialog: showBadgeUnlockedDialog ?? this.showBadgeUnlockedDialog,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Get current XP
  int get totalXp => studentData?.totalXp ?? 0;

  /// Get current level
  int get level => studentData?.level ?? 1;

  /// Get level title
  String get levelTitle => studentData?.levelTitle ?? 'Novice';

  /// Get current streak
  int get currentStreak => studentData?.currentStreak ?? 0;

  /// Get longest streak
  int get longestStreak => studentData?.longestStreak ?? 0;

  /// Get XP progress to next level (0-1)
  double get levelProgress => studentData?.levelProgress ?? 0.0;

  /// Get XP needed for next level
  int get xpForNextLevel => studentData?.xpForNextLevel ?? 100;

  /// Get XP progress within current level
  int get xpProgress => studentData?.xpProgress ?? 0;

  /// Check if streak is at risk
  bool get isStreakAtRisk => studentData?.isStreakAtRisk ?? false;

  /// Check if active today
  bool get isActiveToday => studentData?.isActiveToday ?? false;

  /// Get unlocked badge count
  int get unlockedBadgeCount => unlockedBadges.length;

  /// Get total badge count
  int get totalBadgeCount => allBadges.length;

  /// Check if just leveled up
  bool get justLeveledUp => lastXpAward?.leveledUp ?? false;
}

/// Gamification state notifier
class GamificationNotifier extends StateNotifier<GamificationState> {
  final GamificationService _gamificationService;

  GamificationNotifier({
    required GamificationService gamificationService,
  })  : _gamificationService = gamificationService,
        super(GamificationState.initial());

  /// Safely update state only if still mounted
  void _safeSetState(GamificationState newState) {
    if (mounted) {
      state = newState;
    }
  }

  @override
  void dispose() {
    logger.debug('GamificationNotifier: Disposing...');
    super.dispose();
  }

  /// Load gamification data for a student
  Future<void> loadGamification(String studentId) async {
    try {
      logger.info('Loading gamification data for student: $studentId');
      _safeSetState(state.copyWith(isLoading: true, clearError: true));

      final studentData = await _gamificationService.getState(studentId);
      final allBadges = await _gamificationService.loadBadges();

      if (!mounted) return;

      final unlockedBadgeIds = studentData?.unlockedBadgeIds ?? [];
      final unlockedBadges = allBadges
          .where((b) => unlockedBadgeIds.contains(b.id))
          .toList();

      _safeSetState(state.copyWith(
        studentData: studentData,
        allBadges: allBadges,
        unlockedBadges: unlockedBadges,
        isLoading: false,
      ));

      logger.info('Gamification loaded: Level ${studentData?.level ?? 1}, XP ${studentData?.totalXp ?? 0}');
    } catch (e, stackTrace) {
      logger.error('Failed to load gamification data', e, stackTrace);
      _safeSetState(state.copyWith(isLoading: false, error: 'Failed to load gamification: $e'));
    }
  }

  /// Award XP for an event
  Future<void> awardXp({
    required String studentId,
    required XpEventType event,
    int? bonusMultiplier,
    String? entityId,
    String? entityType,
  }) async {
    try {
      logger.info('Awarding XP for event: ${event.displayName}');

      final result = await _gamificationService.awardXp(
        studentId: studentId,
        event: event,
        bonusMultiplier: bonusMultiplier,
        entityId: entityId,
        entityType: entityType,
      );

      if (!mounted) return;

      List<Badge>? newBadges;
      if (result.newBadges.isNotEmpty) {
        newBadges = state.allBadges.where((b) => result.newBadges.contains(b.id)).toList();
      }

      final updatedStudentData = await _gamificationService.getState(studentId);

      if (!mounted) return;

      final updatedUnlockedBadges = state.allBadges
          .where((b) => updatedStudentData?.unlockedBadgeIds.contains(b.id) ?? false)
          .toList();

      _safeSetState(state.copyWith(
        studentData: updatedStudentData,
        unlockedBadges: updatedUnlockedBadges,
        lastXpAward: result,
        newlyUnlockedBadges: newBadges,
        showLevelUpAnimation: result.leveledUp,
        showBadgeUnlockedDialog: newBadges?.isNotEmpty ?? false,
      ));

      logger.info('XP awarded: +${result.xpAwarded}. Total: ${result.newTotalXp}, Level: ${result.newLevel}');
    } catch (e, stackTrace) {
      logger.error('Failed to award XP', e, stackTrace);
      _safeSetState(state.copyWith(error: 'Failed to award XP: $e'));
    }
  }

  /// Update streak for today
  Future<void> updateStreak(String studentId) async {
    try {
      logger.info('Updating streak for student: $studentId');

      final result = await _gamificationService.updateStreak(studentId);

      if (!mounted) return;

      final updatedStudentData = await _gamificationService.getState(studentId);

      if (!mounted) return;

      _safeSetState(state.copyWith(studentData: updatedStudentData, lastStreakUpdate: result));

      if (result.streakIncremented) {
        logger.info('Streak updated: ${result.currentStreak} days');
      }
    } catch (e, stackTrace) {
      logger.error('Failed to update streak', e, stackTrace);
      _safeSetState(state.copyWith(error: 'Failed to update streak: $e'));
    }
  }

  /// Get recent XP events
  Future<List<Map<String, dynamic>>> getRecentXpEvents(String studentId) async {
    try {
      return await _gamificationService.getRecentXpEvents(studentId: studentId, limit: 20);
    } catch (e) {
      logger.error('Failed to get recent XP events', e);
      return [];
    }
  }

  void dismissLevelUpAnimation() => state = state.copyWith(showLevelUpAnimation: false);
  void dismissBadgeUnlockedDialog() => state = state.copyWith(showBadgeUnlockedDialog: false, clearNewBadges: true);
  void clearLastXpAward() => state = state.copyWith(clearLastXpAward: true);
  void clearError() => state = state.copyWith(clearError: true);
}

/// Provider for gamification state management
final gamificationProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  final container = injectionContainer;
  return GamificationNotifier(gamificationService: container.gamificationService);
});

/// Derived provider for streak-related data only
/// Widgets watching this rebuild only when streak data changes
final streakDataProvider = Provider<StreakData>((ref) {
  final state = ref.watch(gamificationProvider);
  return StreakData(
    currentStreak: state.currentStreak,
    longestStreak: state.longestStreak,
    isStreakAtRisk: state.isStreakAtRisk,
    isActiveToday: state.isActiveToday,
  );
});

/// Immutable streak data for efficient comparison
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final bool isStreakAtRisk;
  final bool isActiveToday;

  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.isStreakAtRisk,
    required this.isActiveToday,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakData &&
          currentStreak == other.currentStreak &&
          longestStreak == other.longestStreak &&
          isStreakAtRisk == other.isStreakAtRisk &&
          isActiveToday == other.isActiveToday;

  @override
  int get hashCode =>
      currentStreak.hashCode ^
      longestStreak.hashCode ^
      isStreakAtRisk.hashCode ^
      isActiveToday.hashCode;
}

/// Derived provider for XP/level-related data only
/// Widgets watching this rebuild only when XP/level data changes
final xpLevelDataProvider = Provider<XpLevelData>((ref) {
  final state = ref.watch(gamificationProvider);
  return XpLevelData(
    level: state.level,
    levelTitle: state.levelTitle,
    totalXp: state.totalXp,
    xpProgress: state.xpProgress,
    xpForNextLevel: state.xpForNextLevel,
    levelProgress: state.levelProgress,
  );
});

/// Immutable XP/level data for efficient comparison
class XpLevelData {
  final int level;
  final String levelTitle;
  final int totalXp;
  final int xpProgress;
  final int xpForNextLevel;
  final double levelProgress;

  const XpLevelData({
    required this.level,
    required this.levelTitle,
    required this.totalXp,
    required this.xpProgress,
    required this.xpForNextLevel,
    required this.levelProgress,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XpLevelData &&
          level == other.level &&
          levelTitle == other.levelTitle &&
          totalXp == other.totalXp &&
          xpProgress == other.xpProgress &&
          xpForNextLevel == other.xpForNextLevel &&
          levelProgress == other.levelProgress;

  @override
  int get hashCode =>
      level.hashCode ^
      levelTitle.hashCode ^
      totalXp.hashCode ^
      xpProgress.hashCode ^
      xpForNextLevel.hashCode ^
      levelProgress.hashCode;
}
