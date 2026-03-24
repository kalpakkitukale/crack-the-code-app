/// Data Access Object for QuizSession operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/quiz/quiz_session_model.dart';

/// DAO for quiz_sessions table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class QuizSessionDao extends BaseDao {
  QuizSessionDao(super.dbHelper);

  /// Create a new quiz session
  Future<void> insert(QuizSessionModel session) async {
    await executeWithErrorHandling(
      operationName: 'insert quiz session',
      operation: () async {
        await insertRow(
          table: QuizSessionsTable.tableName,
          values: session.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Quiz session created: ${session.id}');
      },
    );
  }

  /// Update an existing quiz session
  Future<void> update(QuizSessionModel session) async {
    await executeWithErrorHandling(
      operationName: 'update quiz session',
      operation: () async {
        final count = await updateRows(
          table: QuizSessionsTable.tableName,
          values: session.toMap(),
          where: '${QuizSessionsTable.columnId} = ?',
          whereArgs: [session.id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Quiz session not found',
            entityType: 'QuizSession',
            entityId: session.id,
          );
        }

        logger.debug('Quiz session updated: ${session.id}');
      },
    );
  }

  /// Get a quiz session by ID
  Future<QuizSessionModel?> getById(String id) async {
    return await executeWithErrorHandling(
      operationName: 'get quiz session by ID',
      operation: () async {
        final maps = await queryRows(
          table: QuizSessionsTable.tableName,
          where: '${QuizSessionsTable.columnId} = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return QuizSessionModel.fromMap(maps.first);
      },
    );
  }

  /// Get all sessions for a student
  Future<List<QuizSessionModel>> getByStudentId(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get sessions by student ID',
      operation: () async {
        final maps = await queryRows(
          table: QuizSessionsTable.tableName,
          where: '${QuizSessionsTable.columnStudentId} = ?',
          whereArgs: [studentId],
          orderBy: '${QuizSessionsTable.columnStartTime} DESC',
        );

        logger.debug(
            'Retrieved ${maps.length} sessions for student: $studentId');
        return maps.map((map) => QuizSessionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get the current active session for a student (state = inProgress or paused)
  Future<QuizSessionModel?> getActiveSession(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get active session',
      operation: () async {
        final maps = await queryRows(
          table: QuizSessionsTable.tableName,
          where:
              '${QuizSessionsTable.columnStudentId} = ? AND ${QuizSessionsTable.columnState} IN (?, ?)',
          whereArgs: [studentId, 'inProgress', 'paused'],
          orderBy: '${QuizSessionsTable.columnStartTime} DESC',
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return QuizSessionModel.fromMap(maps.first);
      },
    );
  }

  /// Delete a quiz session by ID
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete quiz session',
      operation: () async {
        final count = await deleteRows(
          table: QuizSessionsTable.tableName,
          where: '${QuizSessionsTable.columnId} = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Quiz session not found',
            entityType: 'QuizSession',
            entityId: id,
          );
        }

        logger.debug('Quiz session deleted: $id');
      },
    );
  }

  /// Delete all quiz sessions for a specific profile
  Future<void> deleteAllForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete quiz sessions for profile',
      operation: () async {
        final count = await deleteRows(
          table: QuizSessionsTable.tableName,
          where: '${QuizSessionsTable.columnStudentId} = ?',
          whereArgs: [profileId],
        );

        logger.debug('Deleted $count quiz sessions for profile: $profileId');
      },
    );
  }

  /// Delete completed quiz sessions (for cleanup)
  /// Keeps only sessions from the last N days
  Future<void> deleteCompleted({int keepDays = 30}) async {
    await executeWithErrorHandling(
      operationName: 'delete completed sessions',
      operation: () async {
        final cutoffTime = DateTime.now()
            .subtract(Duration(days: keepDays))
            .millisecondsSinceEpoch;

        final count = await deleteRows(
          table: QuizSessionsTable.tableName,
          where:
              '${QuizSessionsTable.columnState} = ? AND ${QuizSessionsTable.columnEndTime} < ?',
          whereArgs: ['completed', cutoffTime],
        );

        logger.debug('Deleted $count old completed sessions');
      },
    );
  }
}
