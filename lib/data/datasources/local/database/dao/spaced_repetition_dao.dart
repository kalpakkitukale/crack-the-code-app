/// Data Access Object for SpacedRepetition operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/pedagogy/spaced_repetition_model.dart';

/// DAO for spaced_repetition table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class SpacedRepetitionDao extends BaseDao {
  SpacedRepetitionDao(super.dbHelper);

  /// Insert or replace a spaced repetition record
  Future<void> upsert(SpacedRepetitionModel record) async {
    await executeWithErrorHandling(
      operationName: 'upsert spaced repetition',
      operation: () async {
        await insertRow(
          table: SpacedRepetitionTable.tableName,
          values: record.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
    );
  }

  /// Get record by concept and student
  Future<SpacedRepetitionModel?> getByConceptAndStudent({
    required String conceptId,
    required String studentId,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get spaced repetition record',
      operation: () async {
        final maps = await queryRows(
          table: SpacedRepetitionTable.tableName,
          where:
              '${SpacedRepetitionTable.columnConceptId} = ? AND ${SpacedRepetitionTable.columnStudentId} = ?',
          whereArgs: [conceptId, studentId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return SpacedRepetitionModel.fromMap(maps.first);
      },
    );
  }

  /// Get all reviews due for a student
  Future<List<SpacedRepetitionModel>> getReviewsDue({
    required String studentId,
    DateTime? beforeDate,
    int? limit,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get reviews due',
      operation: () async {
        final cutoffDate = beforeDate ?? DateTime.now();

        final maps = await queryRows(
          table: SpacedRepetitionTable.tableName,
          where:
              '${SpacedRepetitionTable.columnStudentId} = ? AND ${SpacedRepetitionTable.columnNextReviewDate} <= ?',
          whereArgs: [studentId, cutoffDate.millisecondsSinceEpoch],
          orderBy: '${SpacedRepetitionTable.columnNextReviewDate} ASC',
          limit: limit,
        );

        return maps.map((map) => SpacedRepetitionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get count of reviews due
  Future<int> getReviewsDueCount({
    required String studentId,
    DateTime? beforeDate,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get reviews due count',
      operation: () async {
        final cutoffDate = beforeDate ?? DateTime.now();

        final query = '''
          SELECT COUNT(*) FROM ${SpacedRepetitionTable.tableName}
          WHERE ${SpacedRepetitionTable.columnStudentId} = ?
            AND ${SpacedRepetitionTable.columnNextReviewDate} <= ?
        ''';

        return await firstIntValue(
                query, [studentId, cutoffDate.millisecondsSinceEpoch]) ??
            0;
      },
    );
  }

  /// Get all records for a student
  Future<List<SpacedRepetitionModel>> getByStudent(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get student spaced repetition records',
      operation: () async {
        final maps = await queryRows(
          table: SpacedRepetitionTable.tableName,
          where: '${SpacedRepetitionTable.columnStudentId} = ?',
          whereArgs: [studentId],
          orderBy: '${SpacedRepetitionTable.columnNextReviewDate} ASC',
        );

        return maps.map((map) => SpacedRepetitionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get upcoming reviews (next 7 days)
  Future<Map<DateTime, int>> getUpcomingReviewSchedule({
    required String studentId,
    int days = 7,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get upcoming review schedule',
      operation: () async {
        final now = DateTime.now();
        final futureDate = now.add(Duration(days: days));

        final result = await rawQuery('''
          SELECT
            DATE(${SpacedRepetitionTable.columnNextReviewDate} / 1000, 'unixepoch') as review_date,
            COUNT(*) as count
          FROM ${SpacedRepetitionTable.tableName}
          WHERE ${SpacedRepetitionTable.columnStudentId} = ?
            AND ${SpacedRepetitionTable.columnNextReviewDate} >= ?
            AND ${SpacedRepetitionTable.columnNextReviewDate} <= ?
          GROUP BY DATE(${SpacedRepetitionTable.columnNextReviewDate} / 1000, 'unixepoch')
          ORDER BY review_date ASC
        ''', [
          studentId,
          now.millisecondsSinceEpoch,
          futureDate.millisecondsSinceEpoch
        ]);

        final schedule = <DateTime, int>{};
        for (final row in result) {
          final dateStr = row['review_date'] as String;
          final count = row['count'] as int;
          final date = DateTime.parse(dateStr);
          schedule[date] = count;
        }

        return schedule;
      },
    );
  }

  /// Get review statistics
  Future<Map<String, dynamic>> getStatistics(String studentId) async {
    return await executeWithErrorHandling(
      operationName: 'get spaced repetition statistics',
      operation: () async {
        final result = await rawQuery('''
          SELECT
            COUNT(*) as total_items,
            SUM(${SpacedRepetitionTable.columnTotalReviews}) as total_reviews,
            SUM(${SpacedRepetitionTable.columnCorrectReviews}) as total_correct,
            AVG(${SpacedRepetitionTable.columnIntervalDays}) as avg_interval,
            AVG(${SpacedRepetitionTable.columnEaseFactor}) as avg_ease_factor
          FROM ${SpacedRepetitionTable.tableName}
          WHERE ${SpacedRepetitionTable.columnStudentId} = ?
        ''', [studentId]);

        return result.first;
      },
    );
  }

  /// Delete record
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete spaced repetition record',
      operation: () async {
        await deleteRows(
          table: SpacedRepetitionTable.tableName,
          where: '${SpacedRepetitionTable.columnId} = ?',
          whereArgs: [id],
        );
      },
    );
  }

  /// Delete all records for a student
  Future<void> deleteByStudent(String studentId) async {
    await executeWithErrorHandling(
      operationName: 'delete student spaced repetition records',
      operation: () async {
        await deleteRows(
          table: SpacedRepetitionTable.tableName,
          where: '${SpacedRepetitionTable.columnStudentId} = ?',
          whereArgs: [studentId],
        );
      },
    );
  }
}
