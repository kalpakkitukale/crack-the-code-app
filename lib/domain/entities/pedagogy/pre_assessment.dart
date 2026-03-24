/// PreAssessment entity for subject-level diagnostic assessment
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';

part 'pre_assessment.freezed.dart';
part 'pre_assessment.g.dart';

@freezed
class PreAssessment with _$PreAssessment {
  const factory PreAssessment({
    required String id,
    required String studentId,
    required String subjectId,
    required int targetGrade,
    required PreAssessmentPhase currentPhase,
    @Default([]) List<String> questionIds,
    @Default({}) Map<String, String> answers,
    @Default(0) int currentQuestionIndex,
    required DateTime startedAt,
    DateTime? completedAt,
    PreAssessmentResult? result,
  }) = _PreAssessment;

  const PreAssessment._();

  factory PreAssessment.fromJson(Map<String, dynamic> json) =>
      _$PreAssessmentFromJson(json);

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

/// Pre-assessment phases (adaptive algorithm)
enum PreAssessmentPhase {
  /// Phase 1: Quick screening - one question per grade
  quickScreening,

  /// Phase 2: Deep dive into weak grades
  deepDive,

  /// Phase 3: Find exact knowledge frontier
  boundaryDetection;

  String get displayName {
    switch (this) {
      case PreAssessmentPhase.quickScreening:
        return 'Quick Screening';
      case PreAssessmentPhase.deepDive:
        return 'Deep Dive';
      case PreAssessmentPhase.boundaryDetection:
        return 'Boundary Detection';
    }
  }

  String get description {
    switch (this) {
      case PreAssessmentPhase.quickScreening:
        return 'Testing one concept from each grade level';
      case PreAssessmentPhase.deepDive:
        return 'Exploring areas that need attention';
      case PreAssessmentPhase.boundaryDetection:
        return 'Finding your exact knowledge level';
    }
  }

  int get phaseNumber {
    switch (this) {
      case PreAssessmentPhase.quickScreening:
        return 1;
      case PreAssessmentPhase.deepDive:
        return 2;
      case PreAssessmentPhase.boundaryDetection:
        return 3;
    }
  }
}

/// Pre-assessment result with gap analysis
@freezed
class PreAssessmentResult with _$PreAssessmentResult {
  const factory PreAssessmentResult({
    required String assessmentId,
    required double overallReadiness,
    required Map<int, double> gradeScores,
    required List<ConceptGap> identifiedGaps,
    required int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    LearningPath? recommendedPath,
    DateTime? generatedAt,
  }) = _PreAssessmentResult;

  const PreAssessmentResult._();

  factory PreAssessmentResult.fromJson(Map<String, dynamic> json) =>
      _$PreAssessmentResultFromJson(json);

  /// Check if student is ready (>= 80% readiness)
  bool get isReady => overallReadiness >= 80;

  /// Check if student has critical gaps
  bool get hasCriticalGaps =>
      identifiedGaps.any((gap) => gap.isCritical);

  /// Get count of gaps by severity
  int get criticalGapCount =>
      identifiedGaps.where((gap) => gap.isCritical).length;

  int get severeGapCount =>
      identifiedGaps.where((gap) => gap.isSevere && !gap.isCritical).length;

  int get moderateGapCount =>
      identifiedGaps.where((gap) => !gap.isSevere).length;

  /// Get lowest scoring grade
  int? get weakestGrade {
    if (gradeScores.isEmpty) return null;
    return gradeScores.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  /// Get readiness level description
  String get readinessLevel {
    if (overallReadiness >= 90) return 'Excellent';
    if (overallReadiness >= 80) return 'Good';
    if (overallReadiness >= 70) return 'Fair';
    if (overallReadiness >= 50) return 'Needs Work';
    return 'Foundation Required';
  }
}
