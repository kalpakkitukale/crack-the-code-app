/// ConceptMastery entity tracking student's mastery of a concept
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'concept_mastery.freezed.dart';
part 'concept_mastery.g.dart';

@freezed
class ConceptMastery with _$ConceptMastery {
  const factory ConceptMastery({
    required String id,
    required String conceptId,
    required String studentId,
    required double masteryScore,
    required MasteryLevel level,
    required DateTime lastAssessed,
    required int totalAttempts,
    @Default(false) bool isGap,
    DateTime? nextReviewDate,
    @Default(0) int reviewStreak,
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
    int? gradeLevel,
  }) = _ConceptMastery;

  const ConceptMastery._();

  factory ConceptMastery.fromJson(Map<String, dynamic> json) =>
      _$ConceptMasteryFromJson(json);

  /// Check if mastery is below gap threshold
  bool get needsAttention => masteryScore < 60;

  /// Check if mastery is strong
  bool get isStrong => masteryScore >= 80;

  /// Check if mastered
  bool get isMastered => masteryScore >= 90;

  /// Check if due for review
  bool get isDueForReview {
    if (nextReviewDate == null) return false;
    return DateTime.now().isAfter(nextReviewDate!);
  }

  /// Get days until next review
  int? get daysUntilReview {
    if (nextReviewDate == null) return null;
    return nextReviewDate!.difference(DateTime.now()).inDays;
  }

  /// Get mastery level from score
  static MasteryLevel levelFromScore(double score) {
    if (score >= 90) return MasteryLevel.mastered;
    if (score >= 80) return MasteryLevel.proficient;
    if (score >= 60) return MasteryLevel.familiar;
    if (score >= 40) return MasteryLevel.learning;
    return MasteryLevel.notLearned;
  }
}

enum MasteryLevel {
  notLearned,
  learning,
  familiar,
  proficient,
  mastered;

  String get displayName {
    switch (this) {
      case MasteryLevel.notLearned:
        return 'Not Learned';
      case MasteryLevel.learning:
        return 'Learning';
      case MasteryLevel.familiar:
        return 'Familiar';
      case MasteryLevel.proficient:
        return 'Proficient';
      case MasteryLevel.mastered:
        return 'Mastered';
    }
  }

  int get minScore {
    switch (this) {
      case MasteryLevel.notLearned:
        return 0;
      case MasteryLevel.learning:
        return 40;
      case MasteryLevel.familiar:
        return 60;
      case MasteryLevel.proficient:
        return 80;
      case MasteryLevel.mastered:
        return 90;
    }
  }
}
