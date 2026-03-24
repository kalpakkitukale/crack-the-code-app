/// Data Access Object for Chapter Summary operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/study_tools/chapter_summary_model.dart';

/// DAO for chapter_summaries table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class ChapterSummaryDao extends BaseDao {
  ChapterSummaryDao(super.dbHelper);

  /// Insert or replace a chapter summary
  Future<void> insert(ChapterSummaryModel summary) async {
    await executeWithErrorHandling(
      operationName: 'insert chapter summary',
      operation: () async {
        await insertRow(
          table: ChapterSummariesTable.tableName,
          values: summary.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Chapter summary inserted: ${summary.id}');
      },
    );
  }

  /// Get summary for a specific chapter, subject, and segment
  Future<ChapterSummaryModel?> getSummary(
    String chapterId,
    String subjectId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get chapter summary',
      operation: () async {
        final maps = await queryRows(
          table: ChapterSummariesTable.tableName,
          where:
              '${ChapterSummariesTable.columnChapterId} = ? AND ${ChapterSummariesTable.columnSubjectId} = ? AND ${ChapterSummariesTable.columnSegment} = ?',
          whereArgs: [chapterId, subjectId, segment],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        logger.debug('Retrieved chapter summary for chapter: $chapterId');
        return ChapterSummaryModel.fromMap(maps.first);
      },
    );
  }

  /// Get all summaries for a subject
  Future<List<ChapterSummaryModel>> getBySubjectId(
    String subjectId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get chapter summaries by subject',
      operation: () async {
        final maps = await queryRows(
          table: ChapterSummariesTable.tableName,
          where:
              '${ChapterSummariesTable.columnSubjectId} = ? AND ${ChapterSummariesTable.columnSegment} = ?',
          whereArgs: [subjectId, segment],
        );

        logger.debug(
            'Retrieved ${maps.length} chapter summaries for subject: $subjectId');
        return maps.map((map) => ChapterSummaryModel.fromMap(map)).toList();
      },
    );
  }

  /// Get summary by ID
  Future<ChapterSummaryModel?> getById(String summaryId) async {
    return await executeWithErrorHandling(
      operationName: 'get chapter summary by ID',
      operation: () async {
        final maps = await queryRows(
          table: ChapterSummariesTable.tableName,
          where: '${ChapterSummariesTable.columnId} = ?',
          whereArgs: [summaryId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return ChapterSummaryModel.fromMap(maps.first);
      },
    );
  }

  /// Check if a chapter has a summary
  Future<bool> hasSummary(
    String chapterId,
    String subjectId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'check if chapter has summary',
      operation: () async {
        final query =
            'SELECT COUNT(*) FROM ${ChapterSummariesTable.tableName} WHERE ${ChapterSummariesTable.columnChapterId} = ? AND ${ChapterSummariesTable.columnSubjectId} = ? AND ${ChapterSummariesTable.columnSegment} = ?';
        final count =
            await firstIntValue(query, [chapterId, subjectId, segment]);

        return (count ?? 0) > 0;
      },
    );
  }

  /// Delete summary for a chapter
  Future<void> deleteByChapterId(String chapterId) async {
    await executeWithErrorHandling(
      operationName: 'delete chapter summary',
      operation: () async {
        await deleteRows(
          table: ChapterSummariesTable.tableName,
          where: '${ChapterSummariesTable.columnChapterId} = ?',
          whereArgs: [chapterId],
        );
        logger.debug('Chapter summary deleted for chapter: $chapterId');
      },
    );
  }

  /// Delete all summaries
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all chapter summaries',
      operation: () async {
        await deleteRows(table: ChapterSummariesTable.tableName);
        logger.debug('All chapter summaries deleted');
      },
    );
  }
}
