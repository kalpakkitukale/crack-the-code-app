/// Glossary Term data model for database operations
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/domain/entities/study_tools/glossary_term.dart';

/// Glossary Term model for SQLite database
class GlossaryTermModel {
  final String id;
  final String term;
  final String definition;
  final String? pronunciation;
  final String? exampleUsage;
  final String chapterId;
  final String segment;
  final String difficulty;
  final String? imageUrl;
  final String? audioUrl;
  final int createdAt;

  const GlossaryTermModel({
    required this.id,
    required this.term,
    required this.definition,
    this.pronunciation,
    this.exampleUsage,
    required this.chapterId,
    required this.segment,
    required this.difficulty,
    this.imageUrl,
    this.audioUrl,
    required this.createdAt,
  });

  /// Convert from database map
  factory GlossaryTermModel.fromMap(Map<String, dynamic> map) {
    return GlossaryTermModel(
      id: map[GlossaryTermsTable.columnId] as String,
      term: map[GlossaryTermsTable.columnTerm] as String,
      definition: map[GlossaryTermsTable.columnDefinition] as String,
      pronunciation: map[GlossaryTermsTable.columnPronunciation] as String?,
      exampleUsage: map[GlossaryTermsTable.columnExampleUsage] as String?,
      chapterId: map[GlossaryTermsTable.columnChapterId] as String,
      segment: map[GlossaryTermsTable.columnSegment] as String,
      difficulty: map[GlossaryTermsTable.columnDifficulty] as String? ?? 'medium',
      imageUrl: map[GlossaryTermsTable.columnImageUrl] as String?,
      audioUrl: map[GlossaryTermsTable.columnAudioUrl] as String?,
      createdAt: map[GlossaryTermsTable.columnCreatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      GlossaryTermsTable.columnId: id,
      GlossaryTermsTable.columnTerm: term,
      GlossaryTermsTable.columnDefinition: definition,
      GlossaryTermsTable.columnPronunciation: pronunciation,
      GlossaryTermsTable.columnExampleUsage: exampleUsage,
      GlossaryTermsTable.columnChapterId: chapterId,
      GlossaryTermsTable.columnSegment: segment,
      GlossaryTermsTable.columnDifficulty: difficulty,
      GlossaryTermsTable.columnImageUrl: imageUrl,
      GlossaryTermsTable.columnAudioUrl: audioUrl,
      GlossaryTermsTable.columnCreatedAt: createdAt,
    };
  }

  /// Get difficulty as enum
  TermDifficulty get difficultyEnum {
    switch (difficulty) {
      case 'easy':
        return TermDifficulty.easy;
      case 'hard':
        return TermDifficulty.hard;
      default:
        return TermDifficulty.medium;
    }
  }

  /// Convert to domain entity
  GlossaryTerm toEntity() {
    return GlossaryTerm(
      id: id,
      term: term,
      definition: definition,
      pronunciation: pronunciation,
      exampleUsage: exampleUsage,
      chapterId: chapterId,
      segment: segment,
      difficulty: difficultyEnum,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }

  /// Create from domain entity
  factory GlossaryTermModel.fromEntity(GlossaryTerm term) {
    return GlossaryTermModel(
      id: term.id,
      term: term.term,
      definition: term.definition,
      pronunciation: term.pronunciation,
      exampleUsage: term.exampleUsage,
      chapterId: term.chapterId,
      segment: term.segment,
      difficulty: term.difficulty.name,
      imageUrl: term.imageUrl,
      audioUrl: term.audioUrl,
      createdAt: term.createdAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading from asset files)
  factory GlossaryTermModel.fromJson(Map<String, dynamic> json, String chapterId, String segment) {
    final now = DateTime.now().millisecondsSinceEpoch;

    return GlossaryTermModel(
      id: json['id'] as String,
      term: json['term'] as String,
      definition: json['definition'] as String,
      pronunciation: json['pronunciation'] as String?,
      exampleUsage: json['exampleUsage'] as String?,
      chapterId: chapterId,
      segment: segment,
      difficulty: json['difficulty'] as String? ?? 'medium',
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      createdAt: json['createdAt'] as int? ?? now,
    );
  }
}
