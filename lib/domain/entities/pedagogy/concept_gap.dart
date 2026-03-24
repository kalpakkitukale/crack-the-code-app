/// ConceptGap entity representing a knowledge gap to be fixed
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'concept_gap.freezed.dart';
part 'concept_gap.g.dart';

@freezed
class ConceptGap with _$ConceptGap {
  const factory ConceptGap({
    required String id,
    required String conceptId,
    required String conceptName,
    required int gradeLevel,
    required double currentMastery,
    required int priorityScore,
    required List<String> blockedConcepts,
    required List<String> recommendedVideoIds,
    required int estimatedFixMinutes,
    String? subject,
    String? chapterId,
  }) = _ConceptGap;

  const ConceptGap._();

  factory ConceptGap.fromJson(Map<String, dynamic> json) =>
      _$ConceptGapFromJson(json);

  /// Check if this is a critical gap (very low mastery)
  bool get isCritical => currentMastery < 30;

  /// Check if this is a severe gap
  bool get isSevere => currentMastery < 50;

  /// Check if this gap blocks many concepts
  bool get isHighImpact => blockedConcepts.length >= 3;

  /// Get severity level
  GapSeverity get severity {
    if (currentMastery < 20) return GapSeverity.critical;
    if (currentMastery < 40) return GapSeverity.severe;
    if (currentMastery < 60) return GapSeverity.moderate;
    return GapSeverity.mild;
  }
}

enum GapSeverity {
  mild,
  moderate,
  severe,
  critical;

  String get displayName {
    switch (this) {
      case GapSeverity.mild:
        return 'Needs Review';
      case GapSeverity.moderate:
        return 'Needs Practice';
      case GapSeverity.severe:
        return 'Significant Gap';
      case GapSeverity.critical:
        return 'Critical Gap';
    }
  }
}
