/// Concept entity representing a learning concept with prerequisites
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'concept.freezed.dart';
part 'concept.g.dart';

@freezed
class Concept with _$Concept {
  const factory Concept({
    required String id,
    required String name,
    required int gradeLevel,
    required String subject,
    required String chapterId,
    required List<String> prerequisiteIds,
    required List<String> dependentIds,
    required List<String> videoIds,
    required List<String> questionIds,
    @Default(15) int estimatedMinutes,
    @Default('intermediate') String difficulty,
    @Default([]) List<String> keywords,
  }) = _Concept;

  const Concept._();

  factory Concept.fromJson(Map<String, dynamic> json) => _$ConceptFromJson(json);

  /// Check if this concept has prerequisites
  bool get hasPrerequisites => prerequisiteIds.isNotEmpty;

  /// Check if other concepts depend on this
  bool get hasDependents => dependentIds.isNotEmpty;

  /// Get number of prerequisites
  int get prerequisiteCount => prerequisiteIds.length;

  /// Get number of dependents
  int get dependentCount => dependentIds.length;

  /// Check if this is a foundational concept (no prerequisites)
  bool get isFoundational => prerequisiteIds.isEmpty;

  /// Get difficulty level
  DifficultyLevel get difficultyLevel {
    switch (difficulty.toLowerCase()) {
      case 'advanced':
        return DifficultyLevel.advanced;
      case 'intermediate':
        return DifficultyLevel.intermediate;
      default:
        return DifficultyLevel.basic;
    }
  }
}

enum DifficultyLevel {
  basic,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case DifficultyLevel.basic:
        return 'Basic';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
    }
  }
}
