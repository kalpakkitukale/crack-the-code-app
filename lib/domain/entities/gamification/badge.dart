/// Badge entity for achievements
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String name,
    required String description,
    required String iconPath,
    required BadgeCategory category,
    @JsonKey(fromJson: _conditionFromJson, toJson: _conditionToJson)
    required BadgeCondition condition,
    @Default(0) int xpBonus,
  }) = _Badge;

  const Badge._();

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

/// Badge categories
enum BadgeCategory {
  learning,
  streak,
  mastery,
  special;

  String get displayName {
    switch (this) {
      case BadgeCategory.learning:
        return 'Learning';
      case BadgeCategory.streak:
        return 'Streak';
      case BadgeCategory.mastery:
        return 'Mastery';
      case BadgeCategory.special:
        return 'Special';
    }
  }
}

/// Badge unlock conditions - manually serialized
sealed class BadgeCondition {
  const BadgeCondition();
}

class VideosWatchedCondition extends BadgeCondition {
  final int count;
  const VideosWatchedCondition(this.count);
}

class QuizzesPassedCondition extends BadgeCondition {
  final int count;
  const QuizzesPassedCondition(this.count);
}

class PerfectScoresCondition extends BadgeCondition {
  final int count;
  const PerfectScoresCondition(this.count);
}

class StreakDaysCondition extends BadgeCondition {
  final int days;
  const StreakDaysCondition(this.days);
}

class ConceptsMasteredCondition extends BadgeCondition {
  final int count;
  const ConceptsMasteredCondition(this.count);
}

class GapsFixedCondition extends BadgeCondition {
  final int count;
  const GapsFixedCondition(this.count);
}

class ReviewsCompletedCondition extends BadgeCondition {
  final int count;
  const ReviewsCompletedCondition(this.count);
}

class PathsCompletedCondition extends BadgeCondition {
  final int count;
  const PathsCompletedCondition(this.count);
}

class SubjectMasteredCondition extends BadgeCondition {
  final int count;
  const SubjectMasteredCondition(this.count);
}

class ConsecutiveCheckpointsCondition extends BadgeCondition {
  final int count;
  const ConsecutiveCheckpointsCondition(this.count);
}

class EarlyMorningCondition extends BadgeCondition {
  final int count;
  const EarlyMorningCondition(this.count);
}

class LateNightCondition extends BadgeCondition {
  final int count;
  const LateNightCondition(this.count);
}

/// Helper to deserialize BadgeCondition from JSON
BadgeCondition _conditionFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String;
  switch (type) {
    case 'videosWatched':
      return VideosWatchedCondition(json['count'] as int);
    case 'quizzesPassed':
      return QuizzesPassedCondition(json['count'] as int);
    case 'perfectScores':
      return PerfectScoresCondition(json['count'] as int);
    case 'streakDays':
      return StreakDaysCondition(json['days'] as int);
    case 'conceptsMastered':
      return ConceptsMasteredCondition(json['count'] as int);
    case 'gapsFixed':
      return GapsFixedCondition(json['count'] as int);
    case 'reviewsCompleted':
      return ReviewsCompletedCondition(json['count'] as int);
    case 'pathsCompleted':
      return PathsCompletedCondition(json['count'] as int);
    case 'subjectMastered':
      return SubjectMasteredCondition(json['count'] as int);
    case 'consecutiveCheckpoints':
      return ConsecutiveCheckpointsCondition(json['count'] as int);
    case 'earlyMorning':
      return EarlyMorningCondition(json['count'] as int);
    case 'lateNight':
      return LateNightCondition(json['count'] as int);
    default:
      throw ArgumentError('Unknown badge condition type: $type');
  }
}

/// Helper to serialize BadgeCondition to JSON
Map<String, dynamic> _conditionToJson(BadgeCondition condition) {
  return switch (condition) {
    VideosWatchedCondition(:final count) => {'type': 'videosWatched', 'count': count},
    QuizzesPassedCondition(:final count) => {'type': 'quizzesPassed', 'count': count},
    PerfectScoresCondition(:final count) => {'type': 'perfectScores', 'count': count},
    StreakDaysCondition(:final days) => {'type': 'streakDays', 'days': days},
    ConceptsMasteredCondition(:final count) => {'type': 'conceptsMastered', 'count': count},
    GapsFixedCondition(:final count) => {'type': 'gapsFixed', 'count': count},
    ReviewsCompletedCondition(:final count) => {'type': 'reviewsCompleted', 'count': count},
    PathsCompletedCondition(:final count) => {'type': 'pathsCompleted', 'count': count},
    SubjectMasteredCondition(:final count) => {'type': 'subjectMastered', 'count': count},
    ConsecutiveCheckpointsCondition(:final count) => {'type': 'consecutiveCheckpoints', 'count': count},
    EarlyMorningCondition(:final count) => {'type': 'earlyMorning', 'count': count},
    LateNightCondition(:final count) => {'type': 'lateNight', 'count': count},
  };
}

/// Student's progress toward a badge
@freezed
class BadgeProgress with _$BadgeProgress {
  const factory BadgeProgress({
    required String badgeId,
    required String studentId,
    required Badge badge,
    required double progress, // 0.0 - 1.0
    required bool isUnlocked,
    DateTime? unlockedAt,
  }) = _BadgeProgress;

  const BadgeProgress._();

  factory BadgeProgress.fromJson(Map<String, dynamic> json) =>
      _$BadgeProgressFromJson(json);

  /// Get progress percentage (0-100)
  int get progressPercent => (progress * 100).round();

  /// Check if close to unlocking (>= 80%)
  bool get isCloseToUnlock => progress >= 0.8 && !isUnlocked;
}
