/// Flashcard repository interface for managing flashcards and progress
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard_progress.dart';

/// Repository interface for flashcard operations
abstract class FlashcardRepository {
  // ==================== DECK OPERATIONS ====================

  /// Get deck by ID with cards
  Future<Either<Failure, FlashcardDeck?>> getDeckById(String deckId);

  /// Get deck by topic ID
  Future<Either<Failure, FlashcardDeck?>> getDeckByTopicId(
    String topicId,
    String segment,
  );

  /// Get all decks for a chapter
  Future<Either<Failure, List<FlashcardDeck>>> getDecksByChapterId(
    String chapterId,
    String segment,
  );

  /// Save a deck
  Future<Either<Failure, FlashcardDeck>> saveDeck(FlashcardDeck deck);

  /// Delete a deck and its cards
  Future<Either<Failure, void>> deleteDeck(String deckId);

  // ==================== CARD OPERATIONS ====================

  /// Get all cards for a deck
  Future<Either<Failure, List<Flashcard>>> getCardsByDeckId(String deckId);

  /// Save a card
  Future<Either<Failure, Flashcard>> saveCard(Flashcard card);

  /// Save multiple cards at once
  Future<Either<Failure, void>> saveCards(List<Flashcard> cards);

  // ==================== PROGRESS OPERATIONS ====================

  /// Get progress for a specific card
  Future<Either<Failure, FlashcardProgress?>> getCardProgress(String cardId);

  /// Get deck progress summary
  Future<Either<Failure, DeckProgress>> getDeckProgress(String deckId);

  /// Update progress after reviewing a card (implements spaced repetition)
  Future<Either<Failure, FlashcardProgress>> recordReview(
    String cardId,
    bool known,
  );

  /// Get all cards due for review
  Future<Either<Failure, List<FlashcardProgress>>> getDueCards();

  /// Get cards due for review in a specific deck
  Future<Either<Failure, List<FlashcardProgress>>> getDueCardsInDeck(String deckId);

  /// Reset progress for a deck
  Future<Either<Failure, void>> resetDeckProgress(String deckId);
}
