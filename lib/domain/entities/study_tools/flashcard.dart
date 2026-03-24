/// Flashcard entities for flashcard study feature
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard.freezed.dart';
part 'flashcard.g.dart';

/// Flashcard difficulty level
enum FlashcardDifficulty {
  easy,
  medium,
  hard,
}

/// Individual flashcard
@freezed
class Flashcard with _$Flashcard {
  const factory Flashcard({
    required String id,
    required String deckId,
    required String front,
    required String back,
    String? hint,
    String? imageUrl,
    @Default(0) int orderIndex,
    @Default(FlashcardDifficulty.medium) FlashcardDifficulty difficulty,
    required DateTime createdAt,
  }) = _Flashcard;

  const Flashcard._();

  factory Flashcard.fromJson(Map<String, dynamic> json) =>
      _$FlashcardFromJson(json);

  /// Check if card has a hint
  bool get hasHint => hint != null && hint!.isNotEmpty;

  /// Check if card has an image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Get front preview (first 50 characters)
  String get frontPreview {
    if (front.length <= 50) return front;
    return '${front.substring(0, 50)}...';
  }

  /// Get back preview (first 50 characters)
  String get backPreview {
    if (back.length <= 50) return back;
    return '${back.substring(0, 50)}...';
  }
}

/// Flashcard deck containing multiple cards
@freezed
class FlashcardDeck with _$FlashcardDeck {
  const factory FlashcardDeck({
    required String id,
    required String name,
    String? description,
    String? topicId,
    String? chapterId,
    @Default(0) int cardCount,
    required String segment,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<Flashcard> cards,
  }) = _FlashcardDeck;

  const FlashcardDeck._();

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) =>
      _$FlashcardDeckFromJson(json);

  /// Check if deck has description
  bool get hasDescription => description != null && description!.isNotEmpty;

  /// Check if deck is linked to a topic
  bool get hasTopicId => topicId != null && topicId!.isNotEmpty;

  /// Check if deck is linked to a chapter
  bool get hasChapterId => chapterId != null && chapterId!.isNotEmpty;

  /// Check if deck is empty
  bool get isEmpty => cards.isEmpty;

  /// Check if deck has cards
  bool get hasCards => cards.isNotEmpty;

  /// Get actual card count from loaded cards
  int get actualCardCount => cards.length;

  /// Get cards sorted by order index
  List<Flashcard> get sortedCards {
    final sorted = List<Flashcard>.from(cards);
    sorted.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return sorted;
  }
}
