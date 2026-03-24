/// Glossary Term entity for chapter glossary
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'glossary_term.freezed.dart';
part 'glossary_term.g.dart';

/// Difficulty level for glossary terms
enum TermDifficulty {
  easy,
  medium,
  hard,
}

@freezed
class GlossaryTerm with _$GlossaryTerm {
  const factory GlossaryTerm({
    required String id,
    required String term,
    required String definition,
    String? pronunciation,
    String? exampleUsage,
    required String chapterId,
    required String segment,
    @Default(TermDifficulty.medium) TermDifficulty difficulty,
    String? imageUrl,
    String? audioUrl,
    required DateTime createdAt,
  }) = _GlossaryTerm;

  const GlossaryTerm._();

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) =>
      _$GlossaryTermFromJson(json);

  /// Check if term has pronunciation guide
  bool get hasPronunciation => pronunciation != null && pronunciation!.isNotEmpty;

  /// Check if term has example usage
  bool get hasExample => exampleUsage != null && exampleUsage!.isNotEmpty;

  /// Check if term has image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if term has audio
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  /// Check if term has multimedia (image or audio)
  bool get hasMultimedia => hasImage || hasAudio;

  /// Get first letter (for alphabetical grouping)
  String get firstLetter => term.isNotEmpty ? term[0].toUpperCase() : '';

  /// Get definition preview (first 100 characters)
  String get definitionPreview {
    if (definition.length <= 100) return definition;
    return '${definition.substring(0, 100)}...';
  }
}
