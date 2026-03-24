/// Data Access Object for Question operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/quiz/question_model.dart';

/// DAO for questions_offline table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class QuestionDao extends BaseDao {
  QuestionDao(super.dbHelper);

  /// Insert a single question
  Future<void> insert(QuestionModel question) async {
    await executeWithErrorHandling(
      operationName: 'insert question',
      operation: () async {
        await insertRow(
          table: QuestionsOfflineTable.tableName,
          values: question.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Question saved: ${question.id}');
      },
    );
  }

  /// Insert multiple questions in a batch (for quiz loading)
  Future<void> insertBatch(List<QuestionModel> questions) async {
    await executeWithErrorHandling(
      operationName: 'batch insert questions',
      operation: () async {
        await batch(
          (batchHelper) {
            for (final question in questions) {
              batchHelper.insert(
                QuestionsOfflineTable.tableName,
                question.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          },
          noResult: true,
        );
        logger.debug('Batch inserted ${questions.length} questions');
      },
    );
  }

  /// Get a question by ID
  Future<QuestionModel?> getById(String id) async {
    return await executeWithErrorHandling(
      operationName: 'get question by ID',
      operation: () async {
        final maps = await queryRows(
          table: QuestionsOfflineTable.tableName,
          where: '${QuestionsOfflineTable.columnId} = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return QuestionModel.fromMap(maps.first);
      },
    );
  }

  /// Get multiple questions by IDs
  Future<List<QuestionModel>> getByIds(List<String> ids) async {
    return await executeWithErrorHandling(
      operationName: 'get questions by IDs',
      operation: () async {
        if (ids.isEmpty) return [];

        // Create placeholders for IN clause
        final placeholders = List.filled(ids.length, '?').join(',');

        final maps = await queryRows(
          table: QuestionsOfflineTable.tableName,
          where: '${QuestionsOfflineTable.columnId} IN ($placeholders)',
          whereArgs: ids,
        );

        logger.debug('Retrieved ${maps.length} questions');
        return maps.map((map) => QuestionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all questions
  Future<List<QuestionModel>> getAll() async {
    return await executeWithErrorHandling(
      operationName: 'get all questions',
      operation: () async {
        final maps = await queryRows(table: QuestionsOfflineTable.tableName);

        logger.debug('Retrieved ${maps.length} questions');
        return maps.map((map) => QuestionModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete a question by ID
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete question',
      operation: () async {
        final count = await deleteRows(
          table: QuestionsOfflineTable.tableName,
          where: '${QuestionsOfflineTable.columnId} = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Question not found',
            entityType: 'Question',
            entityId: id,
          );
        }

        logger.debug('Question deleted: $id');
      },
    );
  }

  /// Get random questions with limit - optimized for daily challenge
  /// Uses SQL ORDER BY RANDOM() LIMIT instead of loading all and filtering in Dart
  Future<List<QuestionModel>> getRandomQuestions({required int limit}) async {
    return await executeWithErrorHandling(
      operationName: 'get random questions',
      operation: () async {
        final maps = await queryRows(
          table: QuestionsOfflineTable.tableName,
          orderBy: 'RANDOM()',
          limit: limit,
        );

        logger.debug('Retrieved ${maps.length} random questions');
        return maps.map((map) => QuestionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all question IDs - efficient for shuffling when we don't need full question data
  Future<List<String>> getAllIds() async {
    return await executeWithErrorHandling(
      operationName: 'get all question IDs',
      operation: () async {
        final maps = await queryRows(
          table: QuestionsOfflineTable.tableName,
          columns: [QuestionsOfflineTable.columnId],
        );

        logger.debug('Retrieved ${maps.length} question IDs');
        return maps
            .map((map) => map[QuestionsOfflineTable.columnId] as String)
            .toList();
      },
    );
  }

  /// Get question count - useful for checking if questions are available
  Future<int> getCount() async {
    return await executeWithErrorHandling(
      operationName: 'get question count',
      operation: () async {
        const query =
            'SELECT COUNT(*) FROM ${QuestionsOfflineTable.tableName}';
        return await firstIntValue(query) ?? 0;
      },
    );
  }

  /// Delete all questions
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all questions',
      operation: () async {
        await deleteRows(table: QuestionsOfflineTable.tableName);
        logger.debug('All questions deleted');
      },
    );
  }
}
