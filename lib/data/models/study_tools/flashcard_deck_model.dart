/// Flashcard Deck data model for database operations
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard.dart';

/// Flashcard Deck model for SQLite database
class FlashcardDeckModel {
  final String id;
  final String name;
  final String? description;
  final String? topicId;
  final String? chapterId;
  final int cardCount;
  final String segment;
  final int createdAt;
  final int updatedAt;

  const FlashcardDeckModel({
    required this.id,
    required this.name,
    this.description,
    this.topicId,
    this.chapterId,
    required this.cardCount,
    required this.segment,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from database map
  factory FlashcardDeckModel.fromMap(Map<String, dynamic> map) {
    return FlashcardDeckModel(
      id: map[FlashcardDecksTable.columnId] as String,
      name: map[FlashcardDecksTable.columnName] as String,
      description: map[FlashcardDecksTable.columnDescription] as String?,
      topicId: map[FlashcardDecksTable.columnTopicId] as String?,
      chapterId: map[FlashcardDecksTable.columnChapterId] as String?,
      cardCount: map[FlashcardDecksTable.columnCardCount] as int? ?? 0,
      segment: map[FlashcardDecksTable.columnSegment] as String,
      createdAt: map[FlashcardDecksTable.columnCreatedAt] as int,
      updatedAt: map[FlashcardDecksTable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      FlashcardDecksTable.columnId: id,
      FlashcardDecksTable.columnName: name,
      FlashcardDecksTable.columnDescription: description,
      FlashcardDecksTable.columnTopicId: topicId,
      FlashcardDecksTable.columnChapterId: chapterId,
      FlashcardDecksTable.columnCardCount: cardCount,
      FlashcardDecksTable.columnSegment: segment,
      FlashcardDecksTable.columnCreatedAt: createdAt,
      FlashcardDecksTable.columnUpdatedAt: updatedAt,
    };
  }

  /// Convert to domain entity (without cards - cards loaded separately)
  FlashcardDeck toEntity({List<Flashcard> cards = const []}) {
    return FlashcardDeck(
      id: id,
      name: name,
      description: description,
      topicId: topicId,
      chapterId: chapterId,
      cardCount: cardCount,
      segment: segment,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      cards: cards,
    );
  }

  /// Create from domain entity
  factory FlashcardDeckModel.fromEntity(FlashcardDeck deck) {
    return FlashcardDeckModel(
      id: deck.id,
      name: deck.name,
      description: deck.description,
      topicId: deck.topicId,
      chapterId: deck.chapterId,
      cardCount: deck.cardCount,
      segment: deck.segment,
      createdAt: deck.createdAt.millisecondsSinceEpoch,
      updatedAt: deck.updatedAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading from asset files)
  factory FlashcardDeckModel.fromJson(Map<String, dynamic> json, String segment) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final cards = json['cards'] as List<dynamic>?;

    return FlashcardDeckModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      topicId: json['topicId'] as String?,
      chapterId: json['chapterId'] as String?,
      cardCount: cards?.length ?? json['cardCount'] as int? ?? 0,
      segment: segment,
      createdAt: json['createdAt'] as int? ?? now,
      updatedAt: json['updatedAt'] as int? ?? now,
    );
  }
}
