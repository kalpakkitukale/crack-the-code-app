/// ChapterAssessment entity for chapter-level diagnostic assessment
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';

part 'chapter_assessment.freezed.dart';
part 'chapter_assessment.g.dart';

@freezed
class ChapterAssessment with _$ChapterAssessment {
  const factory ChapterAssessment({
    required String id,
    required String studentId,
    required String chapterId,
    required String chapterName,
    required String subjectId,
    required int gradeLevel,
    @Default([]) List<String> questionIds,
    @Default({}) Map<String, String> answers,
    @Default(0) int currentQuestionIndex,
    required DateTime startedAt,
    DateTime? completedAt,
    ChapterAssessmentResult? result,
  }) = _ChapterAssessment;

  const ChapterAssessment._();

  factory ChapterAssessment.fromJson(Map<String, dynamic> json) =>
      _$ChapterAssessmentFromJson(json);

  /// Check if assessment is complete
  bool get isComplete => completedAt != null && result != null;

  /// Check if all questions answered
  bool get allQuestionsAnswered =>
      currentQuestionIndex >= questionIds.length;

  /// Get progress percentage
  double get progress {
    if (questionIds.isEmpty) return 0;
    return (currentQuestionIndex / questionIds.length) * 100;
  }

  /// Get total questions count
  int get totalQuestions => questionIds.length;

  /// Get answered questions count
  int get answeredQuestions => answers.length;

  /// Get duration in minutes
  int get durationMinutes {
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(startedAt).inMinutes;
  }
}

/// Chapter assessment result with concept-level analysis
@freezed
class ChapterAssessmentResult with _$ChapterAssessmentResult {
  const factory ChapterAssessmentResult({
    required String assessmentId,
    required String chapterId,
    required double overallScore,
    required Map<String, double> conceptScores,
    required List<ConceptGap> identifiedGaps,
    required int estimatedFixMinutes,
    @Default([]) List<String> recommendedVideoIds,
    DateTime? generatedAt,
  }) = _ChapterAssessmentResult;

  const ChapterAssessmentResult._();

  factory ChapterAssessmentResult.fromJson(Map<String, dynamic> json) =>
      _$ChapterAssessmentResultFromJson(json);

  /// Check if student passed chapter assessment (>= 70%)
  bool get passed => overallScore >= 70;

  /// Check if student has mastery (>= 80%)
  bool get hasMastery => overallScore >= 80;

  /// Check if student has critical gaps
  bool get hasCriticalGaps =>
      identifiedGaps.any((gap) => gap.isCritical);

  /// Get count of gaps
  int get gapCount => identifiedGaps.length;

  /// Get mastered concepts count
  int get masteredConceptCount =>
      conceptScores.values.where((score) => score >= 80).length;

  /// Get concepts needing work
  int get conceptsNeedingWork =>
      conceptScores.values.where((score) => score < 60).length;

  /// Get weakest concept
  String? get weakestConcept {
    if (conceptScores.isEmpty) return null;
    return conceptScores.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  /// Get performance level description
  String get performanceLevel {
    if (overallScore >= 90) return 'Excellent';
    if (overallScore >= 80) return 'Good';
    if (overallScore >= 70) return 'Satisfactory';
    if (overallScore >= 50) return 'Needs Improvement';
    return 'Foundation Gaps';
  }

  /// Get recommendation action
  ChapterRecommendation get recommendation {
    if (overallScore >= 80) return ChapterRecommendation.proceed;
    if (overallScore >= 60) return ChapterRecommendation.reviewAndProceed;
    if (overallScore >= 40) return ChapterRecommendation.focusedPractice;
    return ChapterRecommendation.foundationFirst;
  }
}

/// Recommendation actions after chapter assessment
enum ChapterRecommendation {
  proceed,
  reviewAndProceed,
  focusedPractice,
  foundationFirst;

  String get displayName {
    switch (this) {
      case ChapterRecommendation.proceed:
        return 'Ready to Proceed';
      case ChapterRecommendation.reviewAndProceed:
        return 'Review & Proceed';
      case ChapterRecommendation.focusedPractice:
        return 'Focused Practice Needed';
      case ChapterRecommendation.foundationFirst:
        return 'Build Foundation First';
    }
  }

  String get description {
    switch (this) {
      case ChapterRecommendation.proceed:
        return 'You have a strong grasp of this chapter. Move to the next one!';
      case ChapterRecommendation.reviewAndProceed:
        return 'Quick review recommended before moving forward.';
      case ChapterRecommendation.focusedPractice:
        return 'Practice specific concepts before continuing.';
      case ChapterRecommendation.foundationFirst:
        return 'Some prerequisite concepts need attention first.';
    }
  }
}
