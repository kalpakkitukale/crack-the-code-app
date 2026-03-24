/// Achievement entity representing a badge or achievement
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String name,
    required String description,
    required String iconUrl,
    required AchievementCategory category,
    required Map<String, dynamic> criteria,
    @Default(0) int points,
  }) = _Achievement;

  const Achievement._();

  /// Check if achievement is milestone type
  bool get isMilestone => category == AchievementCategory.milestone;

  /// Check if achievement is performance type
  bool get isPerformance => category == AchievementCategory.performance;

  /// Check if achievement is engagement type
  bool get isEngagement => category == AchievementCategory.engagement;

  /// Get criteria value for a key
  dynamic getCriteria(String key) => criteria[key];

  /// Check if criteria contains a key
  bool hasCriteria(String key) => criteria.containsKey(key);
}

/// Achievement category enum
enum AchievementCategory {
  milestone,    // First video, first quiz, topic complete
  performance,  // Perfect score, high scores
  engagement    // Streaks, daily login
}
