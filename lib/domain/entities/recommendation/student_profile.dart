/// StudentProfile entity for personalized learning analytics
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_profile.freezed.dart';

@freezed
class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    required String studentId,
    required LearningStyle learningStyle,
    required Map<String, double> subjectProficiency,
    required Map<String, int> conceptMastery,
    required StudyPattern studyPattern,
    required PerformanceMetrics performanceMetrics,
    required DateTime lastUpdated,
    @Default([]) List<String> weakConcepts,
    @Default([]) List<String> strongConcepts,
    @Default([]) List<String> preferredTopics,
    Map<String, dynamic>? preferences,
  }) = _StudentProfile;

  const StudentProfile._();

  /// Get overall proficiency level
  ProficiencyLevel get overallProficiency {
    if (subjectProficiency.isEmpty) return ProficiencyLevel.beginner;

    final avgProficiency = subjectProficiency.values.reduce((a, b) => a + b) /
        subjectProficiency.length;

    if (avgProficiency >= 80) return ProficiencyLevel.advanced;
    if (avgProficiency >= 60) return ProficiencyLevel.intermediate;
    return ProficiencyLevel.beginner;
  }

  /// Get weakest subject
  String? get weakestSubject {
    if (subjectProficiency.isEmpty) return null;
    return subjectProficiency.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  /// Get strongest subject
  String? get strongestSubject {
    if (subjectProficiency.isEmpty) return null;
    return subjectProficiency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get subjects needing attention (< 60% proficiency)
  List<String> get subjectsNeedingAttention {
    return subjectProficiency.entries
        .where((e) => e.value < 60)
        .map((e) => e.key)
        .toList();
  }

  /// Get mastered concepts (>= 80% mastery)
  List<String> get masteredConcepts {
    return conceptMastery.entries
        .where((e) => e.value >= 80)
        .map((e) => e.key)
        .toList();
  }

  /// Get concepts needing practice (< 60% mastery)
  List<String> get conceptsNeedingPractice {
    return conceptMastery.entries
        .where((e) => e.value < 60)
        .map((e) => e.key)
        .toList();
  }

  /// Check if student is consistent
  bool get isConsistent => studyPattern.consistency >= 70;

  /// Check if student is at risk
  bool get isAtRisk {
    return overallProficiency == ProficiencyLevel.beginner &&
        studyPattern.consistency < 50;
  }

  /// Get recommended study time per day (in minutes)
  int get recommendedStudyTime {
    // Base recommendation on current patterns and performance
    final current = studyPattern.averageDailyMinutes;
    final target = overallProficiency == ProficiencyLevel.beginner ? 90 : 60;

    if (current < target) {
      return ((target - current) * 0.5 + current).round();
    }
    return current.round();
  }

  /// Get learning efficiency score (0-100)
  double get learningEfficiency {
    if (studyPattern.totalMinutes == 0) return 0;

    final timeEfficiency =
        (performanceMetrics.averageScore / studyPattern.averageDailyMinutes) *
            10;
    return timeEfficiency.clamp(0, 100);
  }

  /// Check if has preferences set
  bool get hasPreferences => preferences != null && preferences!.isNotEmpty;
}

/// Learning style enum
enum LearningStyle {
  visual,
  auditory,
  kinesthetic,
  readingWriting,
  mixed;

  String get displayName {
    switch (this) {
      case LearningStyle.visual:
        return 'Visual Learner';
      case LearningStyle.auditory:
        return 'Auditory Learner';
      case LearningStyle.kinesthetic:
        return 'Kinesthetic Learner';
      case LearningStyle.readingWriting:
        return 'Reading/Writing Learner';
      case LearningStyle.mixed:
        return 'Mixed Style Learner';
    }
  }

  String get description {
    switch (this) {
      case LearningStyle.visual:
        return 'Learns best through diagrams, charts, and visual aids';
      case LearningStyle.auditory:
        return 'Learns best through listening and verbal explanations';
      case LearningStyle.kinesthetic:
        return 'Learns best through hands-on practice and examples';
      case LearningStyle.readingWriting:
        return 'Learns best through reading texts and writing notes';
      case LearningStyle.mixed:
        return 'Benefits from a combination of learning methods';
    }
  }

  String get icon {
    switch (this) {
      case LearningStyle.visual:
        return '👁️';
      case LearningStyle.auditory:
        return '👂';
      case LearningStyle.kinesthetic:
        return '✋';
      case LearningStyle.readingWriting:
        return '📝';
      case LearningStyle.mixed:
        return '🎯';
    }
  }
}

/// Proficiency level enum
enum ProficiencyLevel {
  beginner,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case ProficiencyLevel.beginner:
        return 'Beginner';
      case ProficiencyLevel.intermediate:
        return 'Intermediate';
      case ProficiencyLevel.advanced:
        return 'Advanced';
    }
  }
}

/// Study pattern tracking
@freezed
class StudyPattern with _$StudyPattern {
  const factory StudyPattern({
    required int totalSessions,
    required int totalMinutes,
    required double averageDailyMinutes,
    required int currentStreak,
    required int longestStreak,
    required double consistency,
    required List<int> preferredHours,
    Map<String, int>? dayOfWeekDistribution,
  }) = _StudyPattern;

  const StudyPattern._();

  /// Get total hours
  double get totalHours => totalMinutes / 60;

  /// Get average session duration
  int get averageSessionDuration =>
      totalSessions > 0 ? (totalMinutes / totalSessions).round() : 0;

  /// Check if has strong streak
  bool get hasStrongStreak => currentStreak >= 7;

  /// Check if study pattern is regular
  bool get isRegular => consistency >= 70;

  /// Get most productive time
  String get mostProductiveTime {
    if (preferredHours.isEmpty) return 'Not enough data';

    final avgHour =
        preferredHours.reduce((a, b) => a + b) ~/ preferredHours.length;

    if (avgHour >= 6 && avgHour < 12) return 'Morning (6 AM - 12 PM)';
    if (avgHour >= 12 && avgHour < 17) return 'Afternoon (12 PM - 5 PM)';
    if (avgHour >= 17 && avgHour < 21) return 'Evening (5 PM - 9 PM)';
    return 'Night (9 PM - 6 AM)';
  }

  /// Get formatted consistency
  String get formattedConsistency => '${consistency.toStringAsFixed(0)}%';
}

/// Performance metrics tracking
@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    required int totalQuizzes,
    required int passedQuizzes,
    required double averageScore,
    required double averageTimePerQuiz,
    required int perfectScores,
    required int improvements,
    required int declines,
    @Default([]) List<double> recentScores,
  }) = _PerformanceMetrics;

  const PerformanceMetrics._();

  /// Get pass rate
  double get passRate =>
      totalQuizzes > 0 ? (passedQuizzes / totalQuizzes) * 100 : 0.0;

  /// Get perfect score rate
  double get perfectScoreRate =>
      totalQuizzes > 0 ? (perfectScores / totalQuizzes) * 100 : 0.0;

  /// Get improvement rate
  double get improvementRate {
    final total = improvements + declines;
    return total > 0 ? (improvements / total) * 100 : 0.0;
  }

  /// Get performance trend
  String get trend {
    if (improvements > declines) return 'Improving';
    if (declines > improvements) return 'Declining';
    return 'Stable';
  }

  /// Get trend emoji
  String get trendEmoji {
    if (improvements > declines) return '📈';
    if (declines > improvements) return '📉';
    return '➡️';
  }

  /// Check if performing well
  bool get isPerformingWell => averageScore >= 75 && passRate >= 80;

  /// Check if needs support
  bool get needsSupport => averageScore < 60 || passRate < 70;

  /// Get formatted average time
  String get formattedAverageTime {
    final minutes = averageTimePerQuiz.toInt();
    final seconds = ((averageTimePerQuiz - minutes) * 60).toInt();
    return '${minutes}m ${seconds}s';
  }
}
