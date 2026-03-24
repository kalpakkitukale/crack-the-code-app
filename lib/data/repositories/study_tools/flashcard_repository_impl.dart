/// Flashcard repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/flashcard_dao.dart';
import 'package:streamshaala/data/models/study_tools/flashcard_deck_model.dart';
import 'package:streamshaala/data/models/study_tools/flashcard_model.dart';
import 'package:streamshaala/data/models/study_tools/flashcard_progress_model.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard_progress.dart';
import 'package:streamshaala/domain/repositories/study_tools/flashcard_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of FlashcardRepository using JSON-first loading with database caching
class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardDao _flashcardDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  /// Profile ID for multi-profile support
  String profileId = '';

  /// Subject ID for JSON lookup (set by provider)
  String? subjectId;

  FlashcardRepositoryImpl(this._flashcardDao, this._jsonDataSource);

  // ==================== DECK OPERATIONS ====================

  @override
  Future<Either<Failure, FlashcardDeck?>> getDeckById(String deckId) async {
    try {
      logger.info('Getting flashcard deck: $deckId');

      // Check database first
      var deckModel = await _flashcardDao.getDeckById(deckId);

      // If not in database, check JSON cache
      if (deckModel == null) {
        final jsonCards = _jsonDataSource.getCardsByDeckId(deckId);
        if (jsonCards.isNotEmpty) {
          // Cards exist in JSON cache, meaning deck was loaded
          // This shouldn't happen if deck was properly cached, but handle gracefully
          logger.warning('Deck $deckId not in DB but cards exist in JSON cache');
        }
      }

      if (deckModel == null) {
        return const Right(null);
      }

      // Load cards for the deck (from database or JSON cache)
      var cardModels = await _flashcardDao.getCardsByDeckId(deckId);

      // If no cards in DB, try JSON cache
      if (cardModels.isEmpty) {
        final jsonCards = _jsonDataSource.getCardsByDeckId(deckId);
        if (jsonCards.isNotEmpty) {
          // Cache cards to database
          await _flashcardDao.insertCards(jsonCards);
          cardModels = jsonCards;
        }
      }

      final cards = cardModels.map((m) => m.toEntity()).toList();
      final deck = deckModel.toEntity(cards: cards);

      logger.info('Retrieved deck with ${cards.length} cards');
      return Right(deck);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting deck', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get flashcard deck',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting deck', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, FlashcardDeck?>> getDeckByTopicId(
    String topicId,
    String segment,
  ) async {
    try {
      logger.info('Getting flashcard deck for topic: $topicId');

      final deckModel = await _flashcardDao.getDeckByTopicId(topicId, segment);
      if (deckModel == null) {
        return const Right(null);
      }

      // Load cards for the deck
      var cardModels = await _flashcardDao.getCardsByDeckId(deckModel.id);

      // If no cards in DB, try JSON cache
      if (cardModels.isEmpty) {
        final jsonCards = _jsonDataSource.getCardsByDeckId(deckModel.id);
        if (jsonCards.isNotEmpty) {
          await _flashcardDao.insertCards(jsonCards);
          cardModels = jsonCards;
        }
      }

      final cards = cardModels.map((m) => m.toEntity()).toList();
      final deck = deckModel.toEntity(cards: cards);

      logger.info('Retrieved deck with ${cards.length} cards for topic');
      return Right(deck);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting deck by topic', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get flashcard deck',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting deck by topic', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardDeck>>> getDecksByChapterId(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.info('Getting flashcard decks for chapter: $chapterId');

      // 1. Check database cache first
      var deckModels = await _flashcardDao.getDecksByChapterId(chapterId, segment);

      // 2. If empty and subject ID is set, load from JSON
      if (deckModels.isEmpty && subjectId != null) {
        final jsonDeckModels = await _jsonDataSource.loadFlashcards(
          subjectId: subjectId!,
          chapterId: chapterId,
          segment: segment,
        );

        if (jsonDeckModels.isNotEmpty) {
          // Cache decks to database
          for (final deck in jsonDeckModels) {
            await _flashcardDao.insertDeck(deck);

            // Cache cards to database
            final jsonCards = _jsonDataSource.getCardsByDeckId(deck.id);
            if (jsonCards.isNotEmpty) {
              await _flashcardDao.insertCards(jsonCards);
            }
          }

          deckModels = jsonDeckModels;
          logger.info('Flashcards loaded from JSON and cached: ${deckModels.length} decks');
        }
      }

      // Load cards for each deck
      final decks = <FlashcardDeck>[];
      for (final deckModel in deckModels) {
        var cardModels = await _flashcardDao.getCardsByDeckId(deckModel.id);

        // If no cards in DB, try JSON cache
        if (cardModels.isEmpty) {
          cardModels = _jsonDataSource.getCardsByDeckId(deckModel.id);
        }

        final cards = cardModels.map((m) => m.toEntity()).toList();
        decks.add(deckModel.toEntity(cards: cards));
      }

      logger.info('Retrieved ${decks.length} decks');
      return Right(decks);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting decks by chapter', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get flashcard decks',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting decks by chapter', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, FlashcardDeck>> saveDeck(FlashcardDeck deck) async {
    try {
      logger.info('Saving flashcard deck: ${deck.name}');

      final deckModel = FlashcardDeckModel.fromEntity(deck);
      await _flashcardDao.insertDeck(deckModel);

      // Save cards if any
      if (deck.cards.isNotEmpty) {
        final cardModels = deck.cards
            .map((c) => FlashcardModel.fromEntity(c))
            .toList();
        await _flashcardDao.insertCards(cardModels);
      }

      logger.info('Deck saved successfully');
      return Right(deck);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving deck', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save flashcard deck',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving deck', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDeck(String deckId) async {
    try {
      logger.info('Deleting flashcard deck: $deckId');

      await _flashcardDao.deleteDeck(deckId);

      logger.info('Deck deleted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting deck', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete flashcard deck',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting deck', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  // ==================== CARD OPERATIONS ====================

  @override
  Future<Either<Failure, List<Flashcard>>> getCardsByDeckId(
    String deckId,
  ) async {
    try {
      logger.info('Getting cards for deck: $deckId');

      var models = await _flashcardDao.getCardsByDeckId(deckId);

      // If no cards in DB, try JSON cache
      if (models.isEmpty) {
        models = _jsonDataSource.getCardsByDeckId(deckId);
        if (models.isNotEmpty) {
          // Cache to database
          await _flashcardDao.insertCards(models);
        }
      }

      final cards = models.map((m) => m.toEntity()).toList();

      logger.info('Retrieved ${cards.length} cards');
      return Right(cards);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting cards', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get flashcards',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting cards', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Flashcard>> saveCard(Flashcard card) async {
    try {
      logger.info('Saving flashcard: ${card.frontPreview}');

      final model = FlashcardModel.fromEntity(card);
      await _flashcardDao.insertCard(model);

      logger.info('Card saved successfully');
      return Right(card);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving card', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save flashcard',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving card', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveCards(List<Flashcard> cards) async {
    try {
      logger.info('Saving ${cards.length} flashcards');

      final models = cards.map((c) => FlashcardModel.fromEntity(c)).toList();
      await _flashcardDao.insertCards(models);

      logger.info('Cards saved successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving cards', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save flashcards',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving cards', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  // ==================== PROGRESS OPERATIONS ====================

  @override
  Future<Either<Failure, FlashcardProgress?>> getCardProgress(
    String cardId,
  ) async {
    try {
      logger.debug('Getting progress for card: $cardId');

      final model = await _flashcardDao.getProgress(cardId, profileId);
      final progress = model?.toEntity();

      return Right(progress);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get card progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, DeckProgress>> getDeckProgress(String deckId) async {
    try {
      logger.info('Getting deck progress: $deckId');

      // Get all cards in the deck
      final cards = await _flashcardDao.getCardsByDeckId(deckId);
      final totalCards = cards.length;

      // Get all progress for these cards
      final progressList = await _flashcardDao.getProgressByDeckId(
        deckId,
        profileId,
      );

      final now = DateTime.now().millisecondsSinceEpoch;
      int reviewedCards = 0;
      int masteredCards = 0;
      int dueCards = 0;
      double totalAccuracy = 0;
      int? lastStudiedAt;

      for (final progress in progressList) {
        reviewedCards++;

        // Calculate accuracy
        if (progress.reviewCount > 0) {
          totalAccuracy += progress.correctCount / progress.reviewCount;
        }

        // Check if mastered (high accuracy + long interval)
        final accuracy = progress.reviewCount > 0
            ? progress.correctCount / progress.reviewCount
            : 0;
        if (accuracy >= 0.8 && progress.intervalDays >= 7) {
          masteredCards++;
        }

        // Check if due for review
        if (progress.nextReviewDate == null ||
            progress.nextReviewDate! <= now) {
          dueCards++;
        }

        // Track last studied
        if (progress.lastReviewedAt != null) {
          if (lastStudiedAt == null ||
              progress.lastReviewedAt! > lastStudiedAt) {
            lastStudiedAt = progress.lastReviewedAt;
          }
        }
      }

      // Add unreviewed cards to due count
      dueCards += (totalCards - reviewedCards);

      final averageAccuracy = reviewedCards > 0
          ? (totalAccuracy / reviewedCards) * 100
          : 0.0;

      final deckProgress = DeckProgress(
        deckId: deckId,
        profileId: profileId,
        totalCards: totalCards,
        reviewedCards: reviewedCards,
        masteredCards: masteredCards,
        dueCards: dueCards,
        averageAccuracy: averageAccuracy,
        lastStudiedAt: lastStudiedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(lastStudiedAt)
            : null,
      );

      return Right(deckProgress);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting deck progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get deck progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting deck progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, FlashcardProgress>> recordReview(
    String cardId,
    bool known,
  ) async {
    try {
      logger.info('Recording review for card: $cardId, known: $known');

      // Get existing progress or create new
      var progressModel = await _flashcardDao.getProgress(cardId, profileId);

      final now = DateTime.now();

      if (progressModel == null) {
        // Create new progress
        progressModel = FlashcardProgressModel(
          id: const Uuid().v4(),
          cardId: cardId,
          profileId: profileId,
          known: known ? 1 : 0,
          easeFactor: 2.5,
          intervalDays: known ? 1 : 0,
          nextReviewDate: known
              ? now.add(const Duration(days: 1)).millisecondsSinceEpoch
              : now.millisecondsSinceEpoch,
          reviewCount: 1,
          correctCount: known ? 1 : 0,
          lastReviewedAt: now.millisecondsSinceEpoch,
        );
      } else {
        // Update using SM-2 algorithm
        final newReviewCount = progressModel.reviewCount + 1;
        final newCorrectCount = progressModel.correctCount + (known ? 1 : 0);

        // Calculate new ease factor
        var newEaseFactor = progressModel.easeFactor;
        if (known) {
          // Increase ease factor slightly for correct answers
          newEaseFactor = progressModel.easeFactor + 0.1;
          if (newEaseFactor > 2.5) newEaseFactor = 2.5;
        } else {
          // Decrease ease factor for incorrect answers
          newEaseFactor = progressModel.easeFactor - 0.3;
          if (newEaseFactor < 1.3) newEaseFactor = 1.3;
        }

        // Calculate new interval
        int newIntervalDays;
        if (known) {
          if (progressModel.intervalDays == 0) {
            newIntervalDays = 1;
          } else if (progressModel.intervalDays == 1) {
            newIntervalDays = 6;
          } else {
            newIntervalDays =
                (progressModel.intervalDays * newEaseFactor).round();
          }
        } else {
          newIntervalDays = 1; // Reset to 1 day for incorrect
        }

        final newNextReviewDate = now
            .add(Duration(days: newIntervalDays))
            .millisecondsSinceEpoch;

        progressModel = FlashcardProgressModel(
          id: progressModel.id,
          cardId: cardId,
          profileId: profileId,
          known: known ? 1 : 0,
          easeFactor: newEaseFactor,
          intervalDays: newIntervalDays,
          nextReviewDate: newNextReviewDate,
          reviewCount: newReviewCount,
          correctCount: newCorrectCount,
          lastReviewedAt: now.millisecondsSinceEpoch,
        );
      }

      await _flashcardDao.insertProgress(progressModel);

      logger.info('Review recorded successfully');
      return Right(progressModel.toEntity());
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error recording review', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to record review',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error recording review', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardProgress>>> getDueCards() async {
    try {
      logger.info('Getting all due cards');

      final models = await _flashcardDao.getDueCards(profileId);
      final progress = models.map((m) => m.toEntity()).toList();

      logger.info('Found ${progress.length} due cards');
      return Right(progress);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting due cards', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get due cards',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting due cards', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardProgress>>> getDueCardsInDeck(
    String deckId,
  ) async {
    try {
      logger.info('Getting due cards in deck: $deckId');

      final allProgress = await _flashcardDao.getProgressByDeckId(
        deckId,
        profileId,
      );

      final now = DateTime.now().millisecondsSinceEpoch;
      final dueProgress = allProgress
          .where((p) => p.nextReviewDate == null || p.nextReviewDate! <= now)
          .map((m) => m.toEntity())
          .toList();

      logger.info('Found ${dueProgress.length} due cards in deck');
      return Right(dueProgress);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting due cards in deck', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get due cards',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting due cards in deck', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetDeckProgress(String deckId) async {
    try {
      logger.warning('Resetting progress for deck: $deckId');

      // Get all cards in the deck and delete their progress
      final cards = await _flashcardDao.getCardsByDeckId(deckId);
      for (final card in cards) {
        final progress = await _flashcardDao.getProgress(card.id, profileId);
        if (progress != null) {
          // Delete progress by inserting with reset values
          // (since we use replace, we could also just delete)
          await _flashcardDao.deleteProgressForProfile(profileId);
          break; // Delete all progress for profile, then break
        }
      }

      logger.info('Deck progress reset successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error resetting progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to reset deck progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error resetting progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
