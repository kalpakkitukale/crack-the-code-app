/// QuizStatistics entity representing aggregate quiz performance data
///
/// This entity provides comprehensive statistics about a student's quiz performance
/// including overall metrics, subject breakdowns, and performance trends.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'subject_statistics.dart';

part 'quiz_statistics.freezed.dart';

@freezed
class QuizStatistics with _$QuizStatistics {
  const factory QuizStatistics({
    /// Total number of quiz attempts across all subjects
    required int totalAttempts,

    /// Average score across all quizzes (0-100)
    required double averageScore,

    /// Current consecutive days with at least one quiz
    required int currentStreak,

    /// Total time spent on quizzes across all attempts
    required Duration totalTimeSpent,

    /// Statistics broken down by subject
    required Map<String, SubjectStatistics> subjectBreakdown,

    /// List of topic IDs where performance is weak (< 60%)
    required List<String> weakTopics,

    /// List of topic IDs where performance is strong (>= 80%)
    required List<String> strongTopics,

    /// Date of the most recent quiz attempt
    DateTime? lastQuizDate,

    /// Highest score achieved across all quizzes (0-100)
    int? bestScore,

    /// Number of quizzes with 100% score
    @Default(0) int perfectScoreCount,

    /// Total number of passed quizzes
    @Default(0) int totalPassed,

    /// Total number of failed quizzes
    @Default(0) int totalFailed,

    /// Longest streak achieved (consecutive days)
    @Default(0) int longestStreak,
  }) = _QuizStatistics;

  const QuizStatistics._();

  /// Calculate pass rate percentage
  double get passRate {
    if (totalAttempts == 0) return 0.0;
    return (totalPassed / totalAttempts) * 100;
  }

  /// Calculate fail rate percentage
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

  /// Check if student has active learning streak
  bool get hasActiveStreak => currentStreak > 0;

  /// Get performance level based on average score
  PerformanceLevel get performanceLevel {
    if (averageScore >= 90) return PerformanceLevel.excellent;
    if (averageScore >= 80) return PerformanceLevel.good;
    if (averageScore >= 70) return PerformanceLevel.average;
    if (averageScore >= 60) return PerformanceLevel.needsImprovement;
    return PerformanceLevel.struggling;
  }

  /// Get subjects sorted by performance (best to worst)
  List<SubjectStatistics> get subjectsByPerformance {
    final subjects = subjectBreakdown.values.toList();
    subjects.sort((a, b) => b.averageScore.compareTo(a.averageScore));
    return subjects;
  }

  /// Get subjects sorted by attempt count (most to least)
  List<SubjectStatistics> get subjectsByActivity {
    final subjects = subjectBreakdown.values.toList();
    subjects.sort((a, b) => b.totalAttempts.compareTo(a.totalAttempts));
    return subjects;
  }

  /// Check if has sufficient data for meaningful statistics (minimum 3 attempts)
  bool get hasSufficientData => totalAttempts >= 3;

  /// Get improvement suggestion based on statistics
  String get improvementSuggestion {
    if (weakTopics.isEmpty) {
      return 'Great work! Keep maintaining your performance across all topics.';
    } else if (weakTopics.length <= 3) {
      return 'Focus on improving ${weakTopics.length} weak topic${weakTopics.length > 1 ? 's' : ''} to boost your overall performance.';
    } else {
      return 'Consider reviewing fundamental concepts. You have ${weakTopics.length} topics that need attention.';
    }
  }
}

/// Performance level enum for categorizing student performance
enum PerformanceLevel {
  excellent,           // >= 90%
  good,               // >= 80%
  average,            // >= 70%
  needsImprovement,   // >= 60%
  struggling,         // < 60%
}

/// Extension to get performance level display information
extension PerformanceLevelExtension on PerformanceLevel {
  String get displayName {
    switch (this) {
      case PerformanceLevel.excellent:
        return 'Excellent';
      case PerformanceLevel.good:
        return 'Good';
      case PerformanceLevel.average:
        return 'Average';
      case PerformanceLevel.needsImprovement:
        return 'Needs Improvement';
      case PerformanceLevel.struggling:
        return 'Struggling';
    }
  }

  String get description {
    switch (this) {
      case PerformanceLevel.excellent:
        return 'Outstanding performance! Keep up the great work.';
      case PerformanceLevel.good:
        return 'Good work! You\'re doing well overall.';
      case PerformanceLevel.average:
        return 'You\'re on the right track, but there\'s room for improvement.';
      case PerformanceLevel.needsImprovement:
        return 'Consider spending more time reviewing the material.';
      case PerformanceLevel.struggling:
        return 'You may need additional help with the concepts.';
    }
  }
}
