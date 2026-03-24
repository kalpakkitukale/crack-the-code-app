/// Data Access Object for Progress operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/user/progress_model.dart';

/// DAO for progress table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class ProgressDao extends BaseDao {
  ProgressDao(super.dbHelper);

  /// Insert or update progress
  Future<void> insert(ProgressModel progress) async {
    await executeWithErrorHandling(
      operationName: 'save progress',
      operation: () async {
        await insertRow(
          table: ProgressTable.tableName,
          values: progress.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Progress saved: ${progress.videoId}');
      },
    );
  }

  /// Update progress
  Future<void> update(ProgressModel progress) async {
    await executeWithErrorHandling(
      operationName: 'update progress',
      operation: () async {
        final count = await updateRows(
          table: ProgressTable.tableName,
          values: progress.toMap(),
          where: '${ProgressTable.columnId} = ?',
          whereArgs: [progress.id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Progress record not found',
            entityType: 'Progress',
            entityId: progress.id,
          );
        }

        logger.debug('Progress updated: ${progress.videoId}');
      },
    );
  }

  /// Get progress by video ID and optional profile ID
  Future<ProgressModel?> getByVideoId(String videoId, {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get progress by video ID',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${ProgressTable.columnVideoId} = ? AND ${ProgressTable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${ProgressTable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        final maps = await queryRows(
          table: ProgressTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return ProgressModel.fromMap(maps.first);
      },
    );
  }

  /// Get all in-progress videos (not completed but have watch time)
  Future<List<ProgressModel>> getInProgress({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get in-progress videos',
      operation: () async {
        final String whereClause;
        final List<dynamic>? whereArgs;

        if (profileId != null) {
          whereClause =
              '${ProgressTable.columnCompleted} = 0 AND ${ProgressTable.columnWatchDuration} > 0 AND ${ProgressTable.columnProfileId} = ?';
          whereArgs = [profileId];
        } else {
          whereClause =
              '${ProgressTable.columnCompleted} = 0 AND ${ProgressTable.columnWatchDuration} > 0';
          whereArgs = null;
        }

        final maps = await queryRows(
          table: ProgressTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: '${ProgressTable.columnLastWatched} DESC',
        );

        logger.debug('Retrieved ${maps.length} in-progress videos');
        return maps.map((map) => ProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all completed videos
  Future<List<ProgressModel>> getCompleted({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get completed videos',
      operation: () async {
        final String whereClause;
        final List<dynamic>? whereArgs;

        if (profileId != null) {
          whereClause =
              '${ProgressTable.columnCompleted} = 1 AND ${ProgressTable.columnProfileId} = ?';
          whereArgs = [profileId];
        } else {
          whereClause = '${ProgressTable.columnCompleted} = 1';
          whereArgs = null;
        }

        final maps = await queryRows(
          table: ProgressTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: '${ProgressTable.columnLastWatched} DESC',
        );

        logger.debug('Retrieved ${maps.length} completed videos');
        return maps.map((map) => ProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all progress records sorted by last watched
  Future<List<ProgressModel>> getAll({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get all progress',
      operation: () async {
        final maps = await queryRows(
          table: ProgressTable.tableName,
          where: profileId != null
              ? '${ProgressTable.columnProfileId} = ?'
              : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${ProgressTable.columnLastWatched} DESC',
        );

        logger.debug('Retrieved ${maps.length} progress records');
        return maps.map((map) => ProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Get recent progress records (limit to specific count)
  Future<List<ProgressModel>> getRecent(int limit, {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get recent progress',
      operation: () async {
        final maps = await queryRows(
          table: ProgressTable.tableName,
          where: profileId != null
              ? '${ProgressTable.columnProfileId} = ?'
              : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${ProgressTable.columnLastWatched} DESC',
          limit: limit,
        );

        logger.debug('Retrieved ${maps.length} recent progress records');
        return maps.map((map) => ProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Get recently watched videos (last 7 days)
  Future<List<ProgressModel>> getRecentlyWatched({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get recently watched videos',
      operation: () async {
        final sevenDaysAgo = DateTime.now()
            .subtract(const Duration(days: 7))
            .millisecondsSinceEpoch;

        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${ProgressTable.columnLastWatched} >= ? AND ${ProgressTable.columnProfileId} = ?';
          whereArgs = [sevenDaysAgo, profileId];
        } else {
          whereClause = '${ProgressTable.columnLastWatched} >= ?';
          whereArgs = [sevenDaysAgo];
        }

        final maps = await queryRows(
          table: ProgressTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: '${ProgressTable.columnLastWatched} DESC',
        );

        logger.debug('Retrieved ${maps.length} recently watched videos');
        return maps.map((map) => ProgressModel.fromMap(map)).toList();
      },
    );
  }

  /// Get total watch time in seconds
  Future<int> getTotalWatchTime({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get total watch time',
      operation: () async {
        final String query;
        final List<dynamic>? queryArgs;

        if (profileId != null) {
          query =
              'SELECT SUM(${ProgressTable.columnWatchDuration}) as total FROM ${ProgressTable.tableName} WHERE ${ProgressTable.columnProfileId} = ?';
          queryArgs = [profileId];
        } else {
          query =
              'SELECT SUM(${ProgressTable.columnWatchDuration}) as total FROM ${ProgressTable.tableName}';
          queryArgs = null;
        }

        return await firstIntValue(query, queryArgs) ?? 0;
      },
    );
  }

  /// Get statistics
  Future<Map<String, dynamic>> getStatistics({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get statistics',
      operation: () async {
        final String whereClause = profileId != null
            ? 'WHERE ${ProgressTable.columnProfileId} = ?'
            : '';
        final List<dynamic>? queryArgs = profileId != null ? [profileId] : null;

        final String query = '''
          SELECT
            COUNT(*) as totalVideosWatched,
            SUM(CASE WHEN ${ProgressTable.columnCompleted} = 1 THEN 1 ELSE 0 END) as completedVideos,
            SUM(CASE WHEN ${ProgressTable.columnCompleted} = 0 AND ${ProgressTable.columnWatchDuration} > 0 THEN 1 ELSE 0 END) as inProgressVideos,
            SUM(${ProgressTable.columnWatchDuration}) as totalWatchTimeSeconds,
            AVG(CAST(${ProgressTable.columnWatchDuration} AS REAL) / NULLIF(${ProgressTable.columnTotalDuration}, 0) * 100) as avgCompletionRate
          FROM ${ProgressTable.tableName}
          $whereClause
        ''';

        final result = await rawQuery(query, queryArgs);
        final data = result.first;

        return {
          'totalVideosWatched': data['totalVideosWatched'] as int? ?? 0,
          'completedVideos': data['completedVideos'] as int? ?? 0,
          'inProgressVideos': data['inProgressVideos'] as int? ?? 0,
          'totalWatchTimeSeconds': data['totalWatchTimeSeconds'] as int? ?? 0,
          'avgCompletionRate': data['avgCompletionRate'] as double? ?? 0.0,
        };
      },
    );
  }

  /// Delete progress record by video ID and optional profile ID
  Future<void> delete(String videoId, {String? profileId}) async {
    await executeWithErrorHandling(
      operationName: 'delete progress',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${ProgressTable.columnVideoId} = ? AND ${ProgressTable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${ProgressTable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        final count = await deleteRows(
          table: ProgressTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Progress record not found',
            entityType: 'Progress',
            entityId: videoId,
          );
        }

        logger.debug('Progress deleted: $videoId');
      },
    );
  }

  /// Delete all progress records for a specific profile
  Future<void> deleteAllForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete progress for profile',
      operation: () async {
        await deleteRows(
          table: ProgressTable.tableName,
          where: '${ProgressTable.columnProfileId} = ?',
          whereArgs: [profileId],
        );
        logger.debug('All progress records deleted for profile: $profileId');
      },
    );
  }

  /// Delete all progress records
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all progress',
      operation: () async {
        await deleteRows(table: ProgressTable.tableName);
        logger.debug('All progress records deleted');
      },
    );
  }
}
