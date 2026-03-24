/// Data Access Object for Quiz operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/quiz/quiz_model.dart';

/// DAO for quizzes_offline table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class QuizDao extends BaseDao {
  QuizDao(super.dbHelper);

  /// Insert a quiz
  Future<void> insert(QuizModel quiz) async {
    await executeWithErrorHandling(
      operationName: 'insert quiz',
      operation: () async {
        await insertRow(
          table: QuizzesOfflineTable.tableName,
          values: quiz.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Quiz saved: ${quiz.id}');
      },
    );
  }

  /// Get a quiz by ID
  Future<QuizModel?> getById(String id) async {
    return await executeWithErrorHandling(
      operationName: 'get quiz by ID',
      operation: () async {
        final maps = await queryRows(
          table: QuizzesOfflineTable.tableName,
          where: '${QuizzesOfflineTable.columnId} = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return QuizModel.fromMap(maps.first);
      },
    );
  }

  /// Get quizzes by level (e.g., 'video', 'topic', 'chapter', 'subject')
  Future<List<QuizModel>> getByLevel(String level) async {
    return await executeWithErrorHandling(
      operationName: 'get quizzes by level',
      operation: () async {
        final maps = await queryRows(
          table: QuizzesOfflineTable.tableName,
          where: '${QuizzesOfflineTable.columnLevel} = ?',
          whereArgs: [level],
        );

        logger.debug('Retrieved ${maps.length} quizzes for level: $level');
        return maps.map((map) => QuizModel.fromMap(map)).toList();
      },
    );
  }

  /// Get quizzes filtered by both level and entity ID
  /// This ensures quizzes are scoped to their parent entity (chapter/topic/video)
  Future<List<QuizModel>> getByLevelAndEntity(
    String level,
    String entityId,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get quizzes by level and entity',
      operation: () async {
        final maps = await queryRows(
          table: QuizzesOfflineTable.tableName,
          where:
              '${QuizzesOfflineTable.columnLevel} = ? AND ${QuizzesOfflineTable.columnEntityId} = ?',
          whereArgs: [level, entityId],
        );

        logger.debug(
          'Retrieved ${maps.length} quizzes for level: $level and entityId: $entityId',
        );
        return maps.map((map) => QuizModel.fromMap(map)).toList();
      },
    );
  }

  /// Get quiz for a specific entity (e.g., a specific video ID, topic ID, etc.)
  Future<QuizModel?> getByEntityId(String entityId) async {
    return await executeWithErrorHandling(
      operationName: 'get quiz by entity ID',
      operation: () async {
        final maps = await queryRows(
          table: QuizzesOfflineTable.tableName,
          where: '${QuizzesOfflineTable.columnEntityId} = ?',
          whereArgs: [entityId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return QuizModel.fromMap(maps.first);
      },
    );
  }

  /// Get all quizzes
  Future<List<QuizModel>> getAll() async {
    return await executeWithErrorHandling(
      operationName: 'get all quizzes',
      operation: () async {
        final maps = await queryRows(table: QuizzesOfflineTable.tableName);

        logger.debug('Retrieved ${maps.length} quizzes');
        return maps.map((map) => QuizModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete a quiz by ID
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete quiz',
      operation: () async {
        final count = await deleteRows(
          table: QuizzesOfflineTable.tableName,
          where: '${QuizzesOfflineTable.columnId} = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Quiz not found',
            entityType: 'Quiz',
            entityId: id,
          );
        }

        logger.debug('Quiz deleted: $id');
      },
    );
  }

  /// Delete all quizzes
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all quizzes',
      operation: () async {
        await deleteRows(table: QuizzesOfflineTable.tableName);
        logger.debug('All quizzes deleted');
      },
    );
  }
}
