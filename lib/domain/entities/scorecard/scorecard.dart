/// Scorecard entity representing performance analytics at different levels
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'scorecard.freezed.dart';

@freezed
class Scorecard with _$Scorecard {
  const factory Scorecard({
    required String id,
    required String studentId,
    required ScorecardLevel level,
    required String entityId,
    required int totalQuizzes,
    required int completedQuizzes,
    required int passedQuizzes,
    required double averageScore,
    required int totalPoints,
    required DateTime lastUpdated,
    @Default(0) int totalTimeSpent,
    @Default(0) int perfectScores,
    @Default([]) List<double> recentScores,
    Map<String, ConceptPerformance>? conceptPerformance,
    Map<String, int>? difficultyBreakdown,
  }) = _Scorecard;

  const Scorecard._();

  /// Get completion percentage
  double get completionPercentage =>
      totalQuizzes > 0 ? (completedQuizzes / totalQuizzes) * 100 : 0.0;

  /// Get pass rate percentage
  double get passRate =>
      completedQuizzes > 0 ? (passedQuizzes / completedQuizzes) * 100 : 0.0;

  /// Get fail rate percentage
  double get failRate => 100 - passRate;

  /// Get number of failed quizzes
  int get failedQuizzes => completedQuizzes - passedQuizzes;

  /// Get pending quizzes count
  int get pendingQuizzes => totalQuizzes - completedQuizzes;

  /// Get average time per quiz in minutes
  int get averageTimePerQuiz =>
      completedQuizzes > 0 ? totalTimeSpent ~/ completedQuizzes : 0;

  /// Get perfect score rate
  double get perfectScoreRate =>
      completedQuizzes > 0 ? (perfectScores / completedQuizzes) * 100 : 0.0;

  /// Check if scorecard is excellent (>= 90% average)
  bool get isExcellent => averageScore >= 90.0;

  /// Check if scorecard is good (>= 75% average)
  bool get isGood => averageScore >= 75.0 && averageScore < 90.0;

  /// Check if scorecard is average (>= 60% average)
  bool get isAverage => averageScore >= 60.0 && averageScore < 75.0;

  /// Check if scorecard needs improvement (< 60% average)
  bool get needsImprovement => averageScore < 60.0;

  /// Get performance trend (improving, declining, stable)
  PerformanceTrend get trend {
    if (recentScores.length < 3) return PerformanceTrend.stable;

    final recent = recentScores.take(3).toList();
    final older = recentScores.skip(3).take(3).toList();

    if (older.isEmpty) return PerformanceTrend.stable;

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;

    final diff = recentAvg - olderAvg;

    if (diff > 5) return PerformanceTrend.improving;
    if (diff < -5) return PerformanceTrend.declining;
    return PerformanceTrend.stable;
  }

  /// Get grade based on average score
  String get grade {
    if (averageScore >= 90) return 'A';
    if (averageScore >= 80) return 'B';
    if (averageScore >= 70) return 'C';
    if (averageScore >= 60) return 'D';
    return 'F';
  }

  /// Get formatted average score
  String get formattedAverageScore => '${averageScore.toStringAsFixed(1)}%';

  /// Get weak concepts (< 60% performance)
  List<String> get weakConcepts {
    if (conceptPerformance == null) return [];
    return conceptPerformance!.entries
        .where((e) => e.value.percentage < 60.0)
        .map((e) => e.key)
        .toList();
  }

  /// Get strong concepts (>= 80% performance)
  List<String> get strongConcepts {
    if (conceptPerformance == null) return [];
    return conceptPerformance!.entries
        .where((e) => e.value.percentage >= 80.0)
        .map((e) => e.key)
        .toList();
  }

  /// Check if has concept performance data
  bool get hasConceptPerformance =>
      conceptPerformance != null && conceptPerformance!.isNotEmpty;

  /// Get most difficult concept
  String? get mostDifficultConcept {
    if (!hasConceptPerformance) return null;
    return conceptPerformance!.entries
        .reduce((a, b) => a.value.percentage < b.value.percentage ? a : b)
        .key;
  }

  /// Get best concept
  String? get bestConcept {
    if (!hasConceptPerformance) return null;
    return conceptPerformance!.entries
        .reduce((a, b) => a.value.percentage > b.value.percentage ? a : b)
        .key;
  }
}

/// Scorecard level enum
enum ScorecardLevel {
  video,
  topic,
  chapter,
  subject;

  String get displayName {
    switch (this) {
      case ScorecardLevel.video:
        return 'Video';
      case ScorecardLevel.topic:
        return 'Topic';
      case ScorecardLevel.chapter:
        return 'Chapter';
      case ScorecardLevel.subject:
        return 'Subject';
    }
  }
}

/// Performance trend enum
enum PerformanceTrend {
  improving,
  declining,
  stable;

  String get displayName {
    switch (this) {
      case PerformanceTrend.improving:
        return 'Improving';
      case PerformanceTrend.declining:
        return 'Declining';
      case PerformanceTrend.stable:
        return 'Stable';
    }
  }

  String get emoji {
    switch (this) {
      case PerformanceTrend.improving:
        return '📈';
      case PerformanceTrend.declining:
        return '📉';
      case PerformanceTrend.stable:
        return '➡️';
    }
  }
}

/// Concept performance tracking
@freezed
class ConceptPerformance with _$ConceptPerformance {
  const factory ConceptPerformance({
    required String concept,
    required int totalQuestions,
    required int correctAnswers,
    required int attempts,
  }) = _ConceptPerformance;

  const ConceptPerformance._();

  /// Get accuracy percentage
  double get percentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  /// Get incorrect answers count
  int get incorrectAnswers => totalQuestions - correctAnswers;

  /// Check if concept is mastered (>= 80%)
  bool get isMastered => percentage >= 80.0;

  /// Check if concept needs improvement (< 60%)
  bool get needsImprovement => percentage < 60.0;

  /// Get performance level
  String get performanceLevel {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 75) return 'Good';
    if (percentage >= 60) return 'Average';
    return 'Needs Improvement';
  }
}
