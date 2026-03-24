/// Data Access Object for Flashcard operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/study_tools/flashcard_deck_model.dart';
import 'package:streamshaala/data/models/study_tools/flashcard_model.dart';
import 'package:streamshaala/data/models/study_tools/flashcard_progress_model.dart';

/// DAO for flashcard table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class FlashcardDao extends BaseDao {
  FlashcardDao(super.dbHelper);

  // ==================== DECK OPERATIONS ====================

  /// Insert or replace a deck
  Future<void> insertDeck(FlashcardDeckModel deck) async {
    await executeWithErrorHandling(
      operationName: 'insert flashcard deck',
      operation: () async {
        await insertRow(
          table: FlashcardDecksTable.tableName,
          values: deck.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Flashcard deck inserted: ${deck.id}');
      },
    );
  }

  /// Get deck by ID
  Future<FlashcardDeckModel?> getDeckById(String deckId) async {
    return await executeWithErrorHandling(
      operationName: 'get flashcard deck',
      operation: () async {
        final maps = await queryRows(
          table: FlashcardDecksTable.tableName,
          where: '${FlashcardDecksTable.columnId} = ?',
          whereArgs: [deckId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return FlashcardDeckModel.fromMap(maps.first);
      },
    );
  }

  /// Get deck by topic ID and segment
  Future<FlashcardDeckModel?> getDeckByTopicId(
      String topicId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get deck by topic',
      operation: () async {
        final maps = await queryRows(
          table: FlashcardDecksTable.tableName,
          where:
              '${FlashcardDecksTable.columnTopicId} = ? AND ${FlashcardDecksTable.columnSegment} = ?',
          whereArgs: [topicId, segment],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return FlashcardDeckModel.fromMap(maps.first);
      },
    );
  }

  /// Get all decks for a chapter
  Future<List<FlashcardDeckModel>> getDecksByChapterId(
      String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get decks by chapter',
      operation: () async {
        final maps = await queryRows(
          table: FlashcardDecksTable.tableName,
          where:
              '${FlashcardDecksTable.columnChapterId} = ? AND ${FlashcardDecksTable.columnSegment} = ?',
          whereArgs: [chapterId, segment],
          orderBy: '${FlashcardDecksTable.columnName} ASC',
        );

        logger.debug('Retrieved ${maps.length} decks for chapter: $chapterId');
        return maps.map((map) => FlashcardDeckModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete a deck and its cards (cascade delete handles cards)
  Future<void> deleteDeck(String deckId) async {
    await executeWithErrorHandling(
      operationName: 'delete deck',
      operation: () async {
        await deleteRows(
          table: FlashcardDecksTable.tableName,
          where: '${FlashcardDecksTable.columnId} = ?',
          whereArgs: [deckId],
        );
        logger.debug('Flashcard deck deleted: $deckId');
      },
    );
  }

  // ==================== CARD OPERATIONS ====================

  /// Insert a flashcard
  Future<void> insertCard(FlashcardModel card) async {
    await executeWithErrorHandling(
      operationName: 'insert flashcard',
      operation: () async {
        await insertRow(
          table: FlashcardsTable.tableName,
          values: card.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Flashcard inserted: ${card.id}');
      },
    );
  }

  /// Insert multiple cards at once
  Future<void> insertCards(List<FlashcardModel> cards) async {
    await executeWithErrorHandling(
      operationName: 'insert flashcards batch',
      operation: () async {
        await batch(
          (batchHelper) {
            for (final card in cards) {
              batchHelper.insert(
                FlashcardsTable.tableName,
                card.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          },
          noResult: true,
        );
        logger.debug('Inserted ${cards.length} flashcards');
      },
    );
  }

  /// Get all cards for a deck
  Future<List<FlashcardModel>> getCardsByDeckId(String deckId) async {
    return await executeWithErrorHandling(
      operationName: 'get flashcards',
      operation: () async {
        final maps = await queryRows(
          table: FlashcardsTable.tableName,
          where: '${FlashcardsTable.columnDeckId} = ?',
          whereArgs: [deckId],
          orderBy: '${FlashcardsTable.columnOrderIndex} ASC',
        );

        logger.debug('Retrieved ${maps.length} cards for deck: $deckId');
        return maps.map((map) => FlashcardModel.fromMap(map)).toList();
      },
    );
  }

  // ==================== PROGRESS OPERATIONS ====================

  /// Insert or update progress
  Future<void> insertProgress(FlashcardProgressModel progress) async {
    await executeWithErrorHandling(
      operationName: 'update flashcard progress',
      operation: () async {
        await insertRow(
          table: FlashcardProgressTable.tableName,
          values: progress.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Flashcard progress updated: ${progress.id}');
      },
    );
  }

  /// Get progress for a card
  Future<FlashcardProgressModel?> getProgress(
      String cardId, String profileId) async {
    return await executeWithErrorHandling(
      operationName: 'get flashcard progress',
      operation: () async {
        final maps = await queryRows(
          table: FlashcardProgressTable.tableName,
          where:
              '${FlashcardProgressTable.columnCardId} = ? AND ${FlashcardProgressTable.columnProfileId} = ?',
          whereArgs: [cardId, profileId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return FlashcardProgressModel.fromMap(maps.first);
      },
    );
  }

  /// Get all progress for cards in a deck
  Future<List<FlashcardProgressModel>> getProgressByDeckId(
      String deckId, String profileId) async {
    return await executeWithErrorHandling(
      operationName: 'get deck progress',
      operation: () async {
        // Join cards and progress to get progress for all cards in a deck
        final query = '''
          SELECT p.* FROM ${FlashcardProgressTable.tableName} p
          INNER JOIN ${FlashcardsTable.tableName} c ON p.${FlashcardProgressTable.columnCardId} = c.${FlashcardsTable.columnId}
          WHERE c.${FlashcardsTable.columnDeckId} = ? AND p.${FlashcardProgressTable.columnProfileId} = ?
        ''';

        final maps = await rawQuery(query, [deckId, profileId]);
        return maps.map((map) => FlashcardProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Get cards due for review
  Future<List<FlashcardProgressModel>> getDueCards(String profileId) async {
    return await executeWithErrorHandling(
      operationName: 'get due cards',
      operation: () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        final maps = await queryRows(
          table: FlashcardProgressTable.tableName,
          where:
              '${FlashcardProgressTable.columnProfileId} = ? AND (${FlashcardProgressTable.columnNextReviewDate} IS NULL OR ${FlashcardProgressTable.columnNextReviewDate} <= ?)',
          whereArgs: [profileId, now],
          orderBy: '${FlashcardProgressTable.columnNextReviewDate} ASC',
        );

        logger.debug('Found ${maps.length} cards due for review');
        return maps.map((map) => FlashcardProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete all progress for a profile
  Future<void> deleteProgressForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete progress for profile',
      operation: () async {
        await deleteRows(
          table: FlashcardProgressTable.tableName,
          where: '${FlashcardProgressTable.columnProfileId} = ?',
          whereArgs: [profileId],
        );
        logger.debug('Flashcard progress deleted for profile: $profileId');
      },
    );
  }

  /// Delete all flashcard data
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all flashcard data',
      operation: () async {
        await deleteRows(table: FlashcardProgressTable.tableName);
        await deleteRows(table: FlashcardsTable.tableName);
        await deleteRows(table: FlashcardDecksTable.tableName);
        logger.debug('All flashcard data deleted');
      },
    );
  }
}
