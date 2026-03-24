/// Data Access Object for Video Summary operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/study_tools/video_summary_model.dart';

/// DAO for video summaries table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class VideoSummaryDao extends BaseDao {
  VideoSummaryDao(super.dbHelper);

  /// Insert or replace a video summary
  Future<void> insert(VideoSummaryModel summary) async {
    await executeWithErrorHandling(
      operationName: 'insert video summary',
      operation: () async {
        await insertRow(
          table: VideoSummariesTable.tableName,
          values: summary.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Video summary inserted: ${summary.id}');
      },
    );
  }

  /// Get summary by video ID and segment
  Future<VideoSummaryModel?> getByVideoId(String videoId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get video summary',
      operation: () async {
        final maps = await queryRows(
          table: VideoSummariesTable.tableName,
          where:
              '${VideoSummariesTable.columnVideoId} = ? AND ${VideoSummariesTable.columnSegment} = ?',
          whereArgs: [videoId, segment],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return VideoSummaryModel.fromMap(maps.first);
      },
    );
  }

  /// Delete summary by video ID
  Future<void> deleteByVideoId(String videoId) async {
    await executeWithErrorHandling(
      operationName: 'delete video summary',
      operation: () async {
        await deleteRows(
          table: VideoSummariesTable.tableName,
          where: '${VideoSummariesTable.columnVideoId} = ?',
          whereArgs: [videoId],
        );
        logger.debug('Video summary deleted for video: $videoId');
      },
    );
  }

  /// Delete all summaries
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all video summaries',
      operation: () async {
        await deleteRows(table: VideoSummariesTable.tableName);
        logger.debug('All video summaries deleted');
      },
    );
  }
}
