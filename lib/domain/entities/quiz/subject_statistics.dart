/// SubjectStatistics entity representing performance data for a specific subject
///
/// This entity tracks quiz performance metrics for a single subject,
/// including overall performance, topic-level analysis, and time invested.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_statistics.freezed.dart';

@freezed
class SubjectStatistics with _$SubjectStatistics {
  const factory SubjectStatistics({
    /// Unique identifier for the subject
    required String subjectId,

    /// Display name of the subject
    required String subjectName,

    /// Total number of quiz attempts in this subject
    required int totalAttempts,

    /// Average score across all attempts (0-100)
    required double averageScore,

    /// Highest score achieved in this subject (0-100)
    required int bestScore,

    /// Total time spent on quizzes in this subject
    required Duration totalTimeSpent,

    /// List of topic IDs that have been attempted
    required List<String> topicsAttempted,

    /// Performance breakdown by topic (topicId -> average score 0-100)
    required Map<String, double> topicPerformance,

    /// Date of the most recent attempt in this subject
    DateTime? lastAttemptDate,

    /// Lowest score achieved in this subject (0-100)
    int? worstScore,

    /// Number of passed quizzes in this subject
    @Default(0) int totalPassed,

    /// Number of failed quizzes in this subject
    @Default(0) int totalFailed,

    /// Number of perfect scores (100%) in this subject
    @Default(0) int perfectScoreCount,

    /// Average time per quiz in seconds
    @Default(0) int averageTimeSeconds,
  }) = _SubjectStatistics;

  const SubjectStatistics._();

  /// Calculate pass rate percentage for this subject
  double get passRate {
    if (totalAttempts == 0) return 0.0;
    return (totalPassed / totalAttempts) * 100;
  }

  /// Calculate fail rate percentage for this subject
  double get failRate {
    if (totalAttempts == 0) return 0.0;
    return (totalFailed / totalAttempts) * 100;
  }

  /// Get average time per quiz in minutes
  int get averageTimeMinutes {
    if (totalAttempts == 0) return 0;
    return (totalTimeSpent.inMinutes / totalAttempts).round();
  }

  /// Get formatted total time spent (e.g., "2h 30m")
  String get formattedTotalTime {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    } else if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${minutes}m';
    }
  }

  /// Get score range (difference between best and worst)
  int get scoreRange {
    if (worstScore == null) return 0;
    return bestScore - worstScore!;
  }

  /// Check if performance is consistent (small range)
  bool get isConsistent => scoreRange <= 15; // Within 15 points

  /// Get performance trend (improving, declining, stable)
  /// Note: Requires historical data - placeholder for now
  PerformanceTrend get performanceTrend {
    // This would ideally compare recent scores vs older scores
    // For now, return stable as default
    return PerformanceTrend.stable;
  }

  /// Get weak topics (< 60% average)
  List<String> get weakTopics {
    return topicPerformance.entries
        .where((entry) => entry.value < 60.0)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get strong topics (>= 80% average)
  List<String> get strongTopics {
    return topicPerformance.entries
        .where((entry) => entry.value >= 80.0)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get topics sorted by performance (worst to best)
  List<MapEntry<String, double>> get topicsByPerformance {
    final topics = topicPerformance.entries.toList();
    topics.sort((a, b) => a.value.compareTo(b.value));
    return topics;
  }

  /// Calculate mastery level (0-100) based on multiple factors
  double get masteryLevel {
    if (totalAttempts == 0) return 0.0;

    // Factors:
    // - Average score (50% weight)
    // - Pass rate (30% weight)
    // - Consistency (20% weight)

    final scoreWeight = averageScore * 0.5;
    final passRateWeight = passRate * 0.3;
    final consistencyWeight = (isConsistent ? 20.0 : 10.0);

    return scoreWeight + passRateWeight + consistencyWeight;
  }

  /// Get mastery level category
  MasteryLevel get masteryCategory {
    final level = masteryLevel;
    if (level >= 90) return MasteryLevel.expert;
    if (level >= 75) return MasteryLevel.proficient;
    if (level >= 60) return MasteryLevel.developing;
    if (level >= 40) return MasteryLevel.beginner;
    return MasteryLevel.novice;
  }

  /// Check if has sufficient data for meaningful statistics
  bool get hasSufficientData => totalAttempts >= 2;

  /// Get improvement percentage (requires comparing to initial performance)
  /// Note: Placeholder - would need historical data tracking
  double? get improvementPercentage => null;

  /// Get formatted average score for display
  String get formattedAverageScore => '${averageScore.toStringAsFixed(1)}%';

  /// Get formatted best score for display
  String get formattedBestScore => '$bestScore%';

  /// Get formatted pass rate for display
  String get formattedPassRate => '${passRate.toStringAsFixed(1)}%';
}

/// Performance trend enum
enum PerformanceTrend {
  improving,   // Recent scores higher than older scores
  declining,   // Recent scores lower than older scores
  stable,      // Consistent performance
}

/// Mastery level enum for categorizing subject mastery
enum MasteryLevel {
  expert,      // >= 90% mastery
  proficient,  // >= 75% mastery
  developing,  // >= 60% mastery
  beginner,    // >= 40% mastery
  novice,      // < 40% mastery
}

/// Extension for mastery level display
extension MasteryLevelExtension on MasteryLevel {
  String get displayName {
    switch (this) {
      case MasteryLevel.expert:
        return 'Expert';
      case MasteryLevel.proficient:
        return 'Proficient';
      case MasteryLevel.developing:
        return 'Developing';
      case MasteryLevel.beginner:
        return 'Beginner';
      case MasteryLevel.novice:
        return 'Novice';
    }
  }

  String get description {
    switch (this) {
      case MasteryLevel.expert:
        return 'You have mastered this subject!';
      case MasteryLevel.proficient:
        return 'You have a strong understanding of this subject.';
      case MasteryLevel.developing:
        return 'You\'re making good progress in this subject.';
      case MasteryLevel.beginner:
        return 'You\'re still learning the fundamentals.';
      case MasteryLevel.novice:
        return 'This subject needs more attention and practice.';
    }
  }
}
