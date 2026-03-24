/// StudentAchievement entity representing an earned achievement
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_achievement.freezed.dart';

@freezed
class StudentAchievement with _$StudentAchievement {
  const factory StudentAchievement({
    required String studentId,
    required String achievementId,
    required DateTime earnedAt,
    Map<String, dynamic>? context,
  }) = _StudentAchievement;

  const StudentAchievement._();

  /// Check if achievement was earned today
  bool get earnedToday {
    final now = DateTime.now();
    return earnedAt.year == now.year &&
        earnedAt.month == now.month &&
        earnedAt.day == now.day;
  }

  /// Check if achievement was earned this week
  bool get earnedThisWeek {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return earnedAt.isAfter(weekAgo);
  }

  /// Get days since earned
  int get daysSinceEarned => DateTime.now().difference(earnedAt).inDays;

  /// Get formatted earned date
  String get formattedEarnedDate {
    final now = DateTime.now();
    final difference = now.difference(earnedAt);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  /// Get context value for a key
  dynamic getContext(String key) => context?[key];
}
