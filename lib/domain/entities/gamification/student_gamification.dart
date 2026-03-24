/// StudentGamification entity for XP, levels, and streaks
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_gamification.freezed.dart';
part 'student_gamification.g.dart';

@freezed
class StudentGamification with _$StudentGamification {
  const factory StudentGamification({
    required String id,
    required String studentId,
    @Default(0) int totalXp,
    @Default(1) int level,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastActiveDate,
    @Default([]) List<String> unlockedBadgeIds,
    DateTime? updatedAt,
  }) = _StudentGamification;

  const StudentGamification._();

  factory StudentGamification.fromJson(Map<String, dynamic> json) =>
      _$StudentGamificationFromJson(json);

  /// XP required for next level (level^2 * 100)
  int get xpForNextLevel => (level + 1) * (level + 1) * 100;

  /// XP required for current level
  int get xpForCurrentLevel => level * level * 100;

  /// XP progress within current level (clamped to minimum 0)
  int get xpProgress {
    final progress = totalXp - xpForCurrentLevel;
    // Ensure we never show negative progress
    return progress < 0 ? 0 : progress;
  }

  /// Progress percentage to next level (0.0 - 1.0)
  /// Always clamped between 0 and 1 to ensure valid display values
  double get levelProgress {
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    if (xpNeeded <= 0) return 0.0; // Prevent division by zero
    final progress = xpProgress / xpNeeded;
    // Clamp to valid range to prevent negative or >100% progress display
    return progress.clamp(0.0, 1.0);
  }

  /// Check if active today
  bool get isActiveToday {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    return lastActiveDate!.year == now.year &&
        lastActiveDate!.month == now.month &&
        lastActiveDate!.day == now.day;
  }

  /// Check if streak is at risk (wasn't active yesterday)
  bool get isStreakAtRisk {
    if (lastActiveDate == null) return currentStreak > 0;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final isYesterday = lastActiveDate!.year == yesterday.year &&
        lastActiveDate!.month == yesterday.month &&
        lastActiveDate!.day == yesterday.day;
    return !isActiveToday && !isYesterday && currentStreak > 0;
  }

  /// Get level title
  String get levelTitle {
    if (level >= 50) return 'Grandmaster';
    if (level >= 40) return 'Master';
    if (level >= 30) return 'Expert';
    if (level >= 20) return 'Advanced';
    if (level >= 10) return 'Intermediate';
    if (level >= 5) return 'Beginner';
    return 'Novice';
  }
}

/// XP event types with their base values
enum XpEventType {
  watchVideo(10),
  passPreQuiz(15),
  passPostQuiz(25),
  perfectScore(50),
  dailyStreak(10),
  weekStreak(50),
  completeChapter(100),
  fixGap(30),
  completeReview(15),
  completePath(200),
  unlockBadge(25),
  firstVideoOfDay(5);

  final int baseXp;
  const XpEventType(this.baseXp);

  String get displayName {
    switch (this) {
      case XpEventType.watchVideo:
        return 'Video Watched';
      case XpEventType.passPreQuiz:
        return 'Pre-Quiz Passed';
      case XpEventType.passPostQuiz:
        return 'Post-Quiz Passed';
      case XpEventType.perfectScore:
        return 'Perfect Score!';
      case XpEventType.dailyStreak:
        return 'Daily Streak';
      case XpEventType.weekStreak:
        return 'Week Streak Bonus';
      case XpEventType.completeChapter:
        return 'Chapter Complete';
      case XpEventType.fixGap:
        return 'Gap Fixed';
      case XpEventType.completeReview:
        return 'Review Complete';
      case XpEventType.completePath:
        return 'Path Complete';
      case XpEventType.unlockBadge:
        return 'Badge Unlocked';
      case XpEventType.firstVideoOfDay:
        return 'First Video Today';
    }
  }
}

/// Result of XP award
class XpAwardResult {
  final int xpAwarded;
  final int newTotalXp;
  final int newLevel;
  final bool leveledUp;
  final List<String> newBadges;

  const XpAwardResult({
    required this.xpAwarded,
    required this.newTotalXp,
    required this.newLevel,
    required this.leveledUp,
    required this.newBadges,
  });
}

/// Result of streak update
class StreakResult {
  final int currentStreak;
  final int longestStreak;
  final bool streakIncremented;
  final bool streakBroken;
  final int? bonusXp;

  const StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.streakIncremented,
    required this.streakBroken,
    this.bonusXp,
  });
}
