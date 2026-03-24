/// Data Access Object for QuizAttempt operations (Phase 4)
///
/// Refactored to use BaseDao for platform-abstracted database operations.
/// Provides comprehensive database operations for quiz attempts including:
/// - CRUD operations
/// - Filtered history queries with pagination
/// - Statistics aggregation
/// - Streak calculation
/// - Performance analytics
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/quiz/quiz_attempt_model.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_filter.dart';

/// DAO for quiz_attempts table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class QuizAttemptDao extends BaseDao {
  QuizAttemptDao(super.dbHelper);

  /// Insert a new quiz attempt
  Future<void> insert(QuizAttemptModel attempt) async {
    await executeWithErrorHandling(
      operationName: 'insert quiz attempt',
      operation: () async {
        await insertRow(
          table: QuizAttemptsTable.tableName,
          values: attempt.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
    );
  }

  /// Update an existing quiz attempt
  Future<void> update(QuizAttemptModel attempt) async {
    await executeWithErrorHandling(
      operationName: 'update quiz attempt',
      operation: () async {
        final count = await updateRows(
          table: QuizAttemptsTable.tableName,
          values: attempt.toMap(),
          where: '${QuizAttemptsTable.columnId} = ?',
          whereArgs: [attempt.id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Quiz attempt not found',
            entityType: 'QuizAttempt',
            entityId: attempt.id,
          );
        }

        logger.debug('Quiz attempt updated: ${attempt.id}');
      },
    );
  }

  /// Get a quiz attempt by ID
  Future<QuizAttemptModel?> getById(String id) async {
    return await executeWithErrorHandling(
      operationName: 'get quiz attempt by ID',
      operation: () async {
        final maps = await queryRows(
          table: QuizAttemptsTable.tableName,
          where: '${QuizAttemptsTable.columnId} = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return QuizAttemptModel.fromMap(maps.first);
      },
    );
  }

  /// Get quiz attempts with filters and pagination
  Future<List<QuizAttemptModel>> getFiltered({
    required String studentId,
    QuizFilters? filters,
    int? limit,
    int? offset,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get filtered quiz attempts',
      operation: () async {
        // Build WHERE clause - only show completed quizzes in history/statistics
        final conditions = <String>[
          '${QuizAttemptsTable.columnStudentId} = ?',
          '${QuizAttemptsTable.columnStatus} = ?'
        ];
        final args = <dynamic>[studentId, 'completed'];

        // Apply filters
        if (filters != null) {
          final sqlComponents = filters.toSqlComponents();
          if (sqlComponents['where'] != null) {
            conditions.add(sqlComponents['where'] as String);
            final filterArgs = sqlComponents['whereArgs'] as List<dynamic>?;
            if (filterArgs != null) {
              args.addAll(filterArgs);
            }
          }
        }

        final whereClause = conditions.join(' AND ');
        final orderBy = filters?.getOrderByClause() ??
            '${QuizAttemptsTable.columnCompletedAt} DESC';

        final maps = await queryRows(
          table: QuizAttemptsTable.tableName,
          where: whereClause,
          whereArgs: args,
          orderBy: orderBy,
          limit: limit,
          offset: offset,
        );

        return maps.map((map) => QuizAttemptModel.fromMap(map)).toList();
      },
    );
  }

  /// Get count of quiz attempts matching filters
  Future<int> getCount({
    required String studentId,
    QuizFilters? filters,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get quiz attempts count',
      operation: () async {
        // Build WHERE clause - only count completed quizzes
        final conditions = <String>[
          '${QuizAttemptsTable.columnStudentId} = ?',
          '${QuizAttemptsTable.columnStatus} = ?'
        ];
        final args = <dynamic>[studentId, 'completed'];

        // Apply filters
        if (filters != null) {
          final sqlComponents = filters.toSqlComponents();
          if (sqlComponents['where'] != null) {
            conditions.add(sqlComponents['where'] as String);
            final filterArgs = sqlComponents['whereArgs'] as List<dynamic>?;
            if (filterArgs != null) {
              args.addAll(filterArgs);
            }
          }
        }

        final whereClause = conditions.join(' AND ');
        final query =
            'SELECT COUNT(*) FROM ${QuizAttemptsTable.tableName} WHERE $whereClause';
        final result = await rawQuery(query, args);

        return (result.first['COUNT(*)'] as int?) ?? 0;
      },
    );
  }

  /// Get recent quiz attempts for a student
  Future<List<QuizAttemptModel>> getRecent({
    required String studentId,
    int limit = 10,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get recent quiz attempts',
      operation: () async {
        final maps = await queryRows(
          table: QuizAttemptsTable.tableName,
          where:
              '${QuizAttemptsTable.columnStudentId} = ? AND ${QuizAttemptsTable.columnStatus} = ?',
          whereArgs: [studentId, 'completed'],
          orderBy: '${QuizAttemptsTable.columnCompletedAt} DESC',
          limit: limit,
        );

        logger.debug('Retrieved ${maps.length} recent quiz attempts');
        return maps.map((map) => QuizAttemptModel.fromMap(map)).toList();
      },
    );
  }

  /// Get quiz attempts grouped by date (for streak calculation)
  Future<Map<DateTime, int>> getStreakData(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get streak data',
      operation: () async {
        final result = await rawQuery('''
          SELECT
            DATE(${QuizAttemptsTable.columnCompletedAt} / 1000, 'unixepoch') as date,
            COUNT(*) as count
          FROM ${QuizAttemptsTable.tableName}
          WHERE ${QuizAttemptsTable.columnStudentId} = ?
            AND ${QuizAttemptsTable.columnStatus} = ?
          GROUP BY DATE(${QuizAttemptsTable.columnCompletedAt} / 1000, 'unixepoch')
          ORDER BY date DESC
        ''', [studentId, 'completed']);

        final streakData = <DateTime, int>{};
        for (final row in result) {
          final dateStr = row['date'] as String;
          final count = row['count'] as int;
          final date = DateTime.parse(dateStr);
          streakData[date] = count;
        }

        logger.debug('Retrieved streak data with ${streakData.length} dates');
        return streakData;
      },
    );
  }

  /// Get score trend data over specified days
  Future<Map<String, double>> getScoreTrend({
    required String studentId,
    required int days,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get score trend data',
      operation: () async {
        final cutoffTime = DateTime.now()
            .subtract(Duration(days: days))
            .millisecondsSinceEpoch;

        final result = await rawQuery('''
          SELECT
            DATE(${QuizAttemptsTable.columnCompletedAt} / 1000, 'unixepoch') as date,
            AVG(${QuizAttemptsTable.columnScore}) * 100 as avg_score
          FROM ${QuizAttemptsTable.tableName}
          WHERE ${QuizAttemptsTable.columnStudentId} = ?
            AND ${QuizAttemptsTable.columnCompletedAt} >= ?
            AND ${QuizAttemptsTable.columnStatus} = ?
          GROUP BY DATE(${QuizAttemptsTable.columnCompletedAt} / 1000, 'unixepoch')
          ORDER BY date ASC
        ''', [studentId, cutoffTime, 'completed']);

        final trendData = <String, double>{};
        for (final row in result) {
          final dateStr = row['date'] as String;
          final avgScore = (row['avg_score'] as num).toDouble();
          trendData[dateStr] = avgScore;
        }

        logger
            .debug('Retrieved score trend data with ${trendData.length} dates');
        return trendData;
      },
    );
  }

  /// Get aggregate statistics for a student
  Future<Map<String, dynamic>> getStatistics(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get aggregate statistics',
      operation: () async {
        final result = await rawQuery('''
          SELECT
            COUNT(*) as total_attempts,
            AVG(${QuizAttemptsTable.columnScore}) * 100 as avg_score,
            MAX(${QuizAttemptsTable.columnScore}) * 100 as best_score,
            SUM(${QuizAttemptsTable.columnTimeTaken}) as total_time,
            SUM(CASE WHEN ${QuizAttemptsTable.columnPassed} = 1 THEN 1 ELSE 0 END) as total_passed,
            SUM(CASE WHEN ${QuizAttemptsTable.columnScore} = 1.0 THEN 1 ELSE 0 END) as perfect_count,
            MAX(${QuizAttemptsTable.columnCompletedAt}) as last_quiz_time
          FROM ${QuizAttemptsTable.tableName}
          WHERE ${QuizAttemptsTable.columnStudentId} = ?
            AND ${QuizAttemptsTable.columnStatus} = ?
        ''', [studentId, 'completed']);

        logger.debug('Retrieved aggregate statistics for student');

        // Handle empty result
        if (result.isEmpty) {
          return {
            'total_attempts': 0,
            'avg_score': 0.0,
            'best_score': 0.0,
            'total_time': 0,
            'total_passed': 0,
            'perfect_count': 0,
            'last_quiz_time': null,
          };
        }

        return result.first;
      },
    );
  }

  /// Get subject-wise statistics for a student
  Future<List<Map<String, dynamic>>> getSubjectStatistics(
    String studentId,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get subject statistics',
      operation: () async {
        final result = await rawQuery('''
          SELECT
            ${QuizAttemptsTable.columnSubjectId} as subject_id,
            ${QuizAttemptsTable.columnSubjectName} as subject_name,
            COUNT(*) as total_attempts,
            AVG(${QuizAttemptsTable.columnScore}) * 100 as avg_score,
            MAX(${QuizAttemptsTable.columnScore}) * 100 as best_score,
            MIN(${QuizAttemptsTable.columnScore}) * 100 as worst_score,
            SUM(${QuizAttemptsTable.columnTimeTaken}) as total_time,
            SUM(CASE WHEN ${QuizAttemptsTable.columnPassed} = 1 THEN 1 ELSE 0 END) as total_passed,
            SUM(CASE WHEN ${QuizAttemptsTable.columnScore} = 1.0 THEN 1 ELSE 0 END) as perfect_count,
            MAX(${QuizAttemptsTable.columnCompletedAt}) as last_attempt_time,
            AVG(${QuizAttemptsTable.columnTimeTaken}) as avg_time
          FROM ${QuizAttemptsTable.tableName}
          WHERE ${QuizAttemptsTable.columnStudentId} = ?
            AND ${QuizAttemptsTable.columnSubjectId} IS NOT NULL
            AND ${QuizAttemptsTable.columnStatus} = ?
          GROUP BY ${QuizAttemptsTable.columnSubjectId}, ${QuizAttemptsTable.columnSubjectName}
        ''', [studentId, 'completed']);

        logger.debug(
            'Retrieved subject statistics for ${result.length} subjects');
        return result;
      },
    );
  }

  /// Delete a quiz attempt by ID
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete quiz attempt',
      operation: () async {
        final count = await deleteRows(
          table: QuizAttemptsTable.tableName,
          where: '${QuizAttemptsTable.columnId} = ?',
          whereArgs: [id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Quiz attempt not found',
            entityType: 'QuizAttempt',
            entityId: id,
          );
        }

        logger.debug('Quiz attempt deleted: $id');
      },
    );
  }

  /// Delete all quiz attempts for a specific profile
  Future<int> deleteAllForProfile(String profileId) async {
    return await executeWithErrorHandling(
      operationName: 'delete quiz attempts for profile',
      operation: () async {
        final count = await deleteRows(
          table: QuizAttemptsTable.tableName,
          where: '${QuizAttemptsTable.columnStudentId} = ?',
          whereArgs: [profileId],
        );

        logger.debug('Deleted $count quiz attempts for profile: $profileId');
        return count;
      },
    );
  }

  /// Delete old quiz attempts (for cleanup)
  /// Keeps only attempts from the last N days
  Future<void> deleteOld({int keepDays = 90}) async {
    await executeWithErrorHandling(
      operationName: 'delete old quiz attempts',
      operation: () async {
        final cutoffTime = DateTime.now()
            .subtract(Duration(days: keepDays))
            .millisecondsSinceEpoch;

        final count = await deleteRows(
          table: QuizAttemptsTable.tableName,
          where: '${QuizAttemptsTable.columnCompletedAt} < ?',
          whereArgs: [cutoffTime],
        );

        logger.debug('Deleted $count old quiz attempts');
      },
    );
  }

  /// Update recommendation metadata for a quiz attempt
  Future<void> updateRecommendationMetadata({
    required String attemptId,
    required bool hasRecommendations,
    required int recommendationCount,
    required String recommendationsHistoryId,
    required String assessmentType,
  }) async {
    await executeWithErrorHandling(
      operationName: 'update recommendation metadata',
      operation: () async {
        final updates = {
          QuizAttemptsTable.columnHasRecommendations:
              hasRecommendations ? 1 : 0,
          QuizAttemptsTable.columnRecommendationCount: recommendationCount,
          QuizAttemptsTable.columnRecommendationsGeneratedAt:
              DateTime.now().millisecondsSinceEpoch,
          QuizAttemptsTable.columnRecommendationStatus: 'available',
          QuizAttemptsTable.columnRecommendationsHistoryId:
              recommendationsHistoryId,
          QuizAttemptsTable.columnAssessmentType: assessmentType,
        };

        await updateRows(
          table: QuizAttemptsTable.tableName,
          values: updates,
          where: '${QuizAttemptsTable.columnId} = ?',
          whereArgs: [attemptId],
        );

        logger.debug(
          'Updated recommendation metadata for quiz attempt: $attemptId ($recommendationCount recommendations)',
        );
      },
    );
  }

  /// Update recommendation status for a quiz attempt
  Future<void> updateRecommendationStatus({
    required String attemptId,
    required String status,
  }) async {
    await executeWithErrorHandling(
      operationName: 'update recommendation status',
      operation: () async {
        await updateRows(
          table: QuizAttemptsTable.tableName,
          values: {QuizAttemptsTable.columnRecommendationStatus: status},
          where: '${QuizAttemptsTable.columnId} = ?',
          whereArgs: [attemptId],
        );

        logger.debug(
          'Updated recommendation status for quiz attempt: $attemptId to $status',
        );
      },
    );
  }

  /// Update learning path progress for a quiz attempt
  Future<void> updateLearningPathProgress({
    required String attemptId,
    required String learningPathId,
    required double progress,
  }) async {
    await executeWithErrorHandling(
      operationName: 'update learning path progress',
      operation: () async {
        await updateRows(
          table: QuizAttemptsTable.tableName,
          values: {
            QuizAttemptsTable.columnLearningPathId: learningPathId,
            QuizAttemptsTable.columnLearningPathProgress: progress,
          },
          where: '${QuizAttemptsTable.columnId} = ?',
          whereArgs: [attemptId],
        );

        logger.debug(
          'Updated learning path progress for quiz attempt: $attemptId (${(progress * 100).toStringAsFixed(0)}%)',
        );
      },
    );
  }
}
