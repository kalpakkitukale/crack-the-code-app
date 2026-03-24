/// SubjectGapAnalysis entity for comprehensive subject-level analysis
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';

part 'subject_gap_analysis.freezed.dart';
part 'subject_gap_analysis.g.dart';

@freezed
class SubjectGapAnalysis with _$SubjectGapAnalysis {
  const factory SubjectGapAnalysis({
    required String studentId,
    required String subjectId,
    required String subjectName,
    required int targetGrade,
    required double overallReadiness,
    required Map<int, double> gradeBreakdown,
    required List<ConceptGap> gaps,
    required int estimatedFixMinutes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    LearningPath? recommendedPath,
    DateTime? analyzedAt,
  }) = _SubjectGapAnalysis;

  const SubjectGapAnalysis._();

  factory SubjectGapAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SubjectGapAnalysisFromJson(json);

  /// Check if student is ready for target grade (>= 80%)
  bool get isReady => overallReadiness >= 80;

  /// Get total gap count
  int get totalGaps => gaps.length;

  /// Get critical gap count
  int get criticalGapCount =>
      gaps.where((g) => g.severity == GapSeverity.critical).length;

  /// Get severe gap count
  int get severeGapCount =>
      gaps.where((g) => g.severity == GapSeverity.severe).length;

  /// Get moderate gap count
  int get moderateGapCount =>
      gaps.where((g) => g.severity == GapSeverity.moderate).length;

  /// Get mild gap count
  int get mildGapCount =>
      gaps.where((g) => g.severity == GapSeverity.mild).length;

  /// Get gaps sorted by priority
  List<ConceptGap> get gapsByPriority =>
      List<ConceptGap>.from(gaps)
        ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

  /// Get estimated fix time in hours
  double get estimatedFixHours => estimatedFixMinutes / 60;

  /// Get formatted fix time
  String get formattedFixTime {
    if (estimatedFixMinutes < 60) {
      return '$estimatedFixMinutes minutes';
    }
    final hours = estimatedFixMinutes ~/ 60;
    final minutes = estimatedFixMinutes % 60;
    if (minutes == 0) {
      return '$hours hours';
    }
    return '$hours hours $minutes minutes';
  }

  /// Get weakest grade level
  int? get weakestGrade {
    if (gradeBreakdown.isEmpty) return null;
    return gradeBreakdown.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  /// Get strongest grade level
  int? get strongestGrade {
    if (gradeBreakdown.isEmpty) return null;
    return gradeBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get readiness status message
  String get statusMessage {
    if (overallReadiness >= 90) {
      return 'Excellent! You are well prepared for Class $targetGrade.';
    }
    if (overallReadiness >= 80) {
      return 'Good! You are ready for Class $targetGrade with minor gaps.';
    }
    if (overallReadiness >= 70) {
      return 'Fair. Some foundation concepts need attention.';
    }
    if (overallReadiness >= 50) {
      return 'Foundation work needed before starting Class $targetGrade.';
    }
    return 'Significant gaps found. A personalized learning path is recommended.';
  }

  /// Get action recommendation
  GapAnalysisAction get recommendedAction {
    if (overallReadiness >= 90) return GapAnalysisAction.proceed;
    if (overallReadiness >= 80) return GapAnalysisAction.quickReview;
    if (overallReadiness >= 60) return GapAnalysisAction.targetedFix;
    return GapAnalysisAction.foundationPath;
  }
}

/// Recommended actions based on gap analysis
enum GapAnalysisAction {
  proceed,
  quickReview,
  targetedFix,
  foundationPath;

  String get displayName {
    switch (this) {
      case GapAnalysisAction.proceed:
        return 'Start Learning';
      case GapAnalysisAction.quickReview:
        return 'Quick Review First';
      case GapAnalysisAction.targetedFix:
        return 'Fix Gaps First';
      case GapAnalysisAction.foundationPath:
        return 'Start Foundation Path';
    }
  }

  String get buttonText {
    switch (this) {
      case GapAnalysisAction.proceed:
        return 'Start Class Now';
      case GapAnalysisAction.quickReview:
        return 'Review & Start';
      case GapAnalysisAction.targetedFix:
        return 'Fix My Gaps';
      case GapAnalysisAction.foundationPath:
        return 'Start My Learning Path';
    }
  }
}
