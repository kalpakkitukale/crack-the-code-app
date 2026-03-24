/// Flashcard data model for database operations
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';

/// Flashcard model for SQLite database
class FlashcardModel {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final String? hint;
  final String? imageUrl;
  final int orderIndex;
  final String difficulty;
  final int createdAt;

  const FlashcardModel({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.hint,
    this.imageUrl,
    required this.orderIndex,
    this.difficulty = 'medium',
    required this.createdAt,
  });

  /// Convert from database map
  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map[FlashcardsTable.columnId] as String,
      deckId: map[FlashcardsTable.columnDeckId] as String,
      front: map[FlashcardsTable.columnFront] as String,
      back: map[FlashcardsTable.columnBack] as String,
      hint: map[FlashcardsTable.columnHint] as String?,
      imageUrl: map[FlashcardsTable.columnImageUrl] as String?,
      orderIndex: map[FlashcardsTable.columnOrderIndex] as int? ?? 0,
      createdAt: map[FlashcardsTable.columnCreatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      FlashcardsTable.columnId: id,
      FlashcardsTable.columnDeckId: deckId,
      FlashcardsTable.columnFront: front,
      FlashcardsTable.columnBack: back,
      FlashcardsTable.columnHint: hint,
      FlashcardsTable.columnImageUrl: imageUrl,
      FlashcardsTable.columnOrderIndex: orderIndex,
      FlashcardsTable.columnCreatedAt: createdAt,
    };
  }

  /// Convert to domain entity
  Flashcard toEntity() {
    return Flashcard(
      id: id,
      deckId: deckId,
      front: front,
      back: back,
      hint: hint,
      imageUrl: imageUrl,
      orderIndex: orderIndex,
      difficulty: _parseDifficulty(difficulty),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }

  /// Parse difficulty string to enum
  static FlashcardDifficulty _parseDifficulty(String difficulty) {
    return switch (difficulty.toLowerCase()) {
      'easy' => FlashcardDifficulty.easy,
      'hard' => FlashcardDifficulty.hard,
      _ => FlashcardDifficulty.medium,
    };
  }

  /// Create from domain entity
  factory FlashcardModel.fromEntity(Flashcard card) {
    return FlashcardModel(
      id: card.id,
      deckId: card.deckId,
      front: card.front,
      back: card.back,
      hint: card.hint,
      imageUrl: card.imageUrl,
      orderIndex: card.orderIndex,
      difficulty: card.difficulty.name,
      createdAt: card.createdAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading from asset files)
  factory FlashcardModel.fromJson(Map<String, dynamic> json, String deckId) {
    final now = DateTime.now().millisecondsSinceEpoch;

    return FlashcardModel(
      id: json['id'] as String,
      deckId: deckId,
      front: json['front'] as String,
      back: json['back'] as String,
      hint: json['hint'] as String?,
      imageUrl: json['imageUrl'] as String?,
      orderIndex: json['orderIndex'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'medium',
      createdAt: json['createdAt'] as int? ?? now,
    );
  }
}
