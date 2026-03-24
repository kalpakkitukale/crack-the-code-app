/// Data Access Object for Bookmark operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/user/bookmark_model.dart';

/// DAO for bookmark table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class BookmarkDao extends BaseDao {
  BookmarkDao(super.dbHelper);

  /// Insert a bookmark
  Future<void> insert(BookmarkModel bookmark) async {
    await executeWithErrorHandling(
      operationName: 'insert bookmark',
      operation: () async {
        await insertRow(
          table: BookmarksTable.tableName,
          values: bookmark.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Bookmark inserted: ${bookmark.videoId}');
      },
    );
  }

  /// Delete a bookmark by video ID and optional profile ID
  Future<void> deleteByVideoId(String videoId, {String? profileId}) async {
    await executeWithErrorHandling(
      operationName: 'delete bookmark',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${BookmarksTable.columnVideoId} = ? AND ${BookmarksTable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${BookmarksTable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        final count = await deleteRows(
          table: BookmarksTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Bookmark not found',
            entityType: 'Bookmark',
            entityId: videoId,
          );
        }

        logger.debug('Bookmark deleted: $videoId');
      },
    );
  }

  /// Get all bookmarks sorted by created date (newest first)
  Future<List<BookmarkModel>> getAll({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get all bookmarks',
      operation: () async {
        final maps = await queryRows(
          table: BookmarksTable.tableName,
          where: profileId != null
              ? '${BookmarksTable.columnProfileId} = ?'
              : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${BookmarksTable.columnCreatedAt} DESC',
        );

        logger.debug('Retrieved ${maps.length} bookmarks');
        return maps.map((map) => BookmarkModel.fromMap(map)).toList();
      },
    );
  }

  /// Get bookmark by video ID and optional profile ID
  Future<BookmarkModel?> getByVideoId(String videoId,
      {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get bookmark by video ID',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${BookmarksTable.columnVideoId} = ? AND ${BookmarksTable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${BookmarksTable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        final maps = await queryRows(
          table: BookmarksTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return BookmarkModel.fromMap(maps.first);
      },
    );
  }

  /// Check if video is bookmarked
  Future<bool> isBookmarked(String videoId, {String? profileId}) async {
    final bookmark = await getByVideoId(videoId, profileId: profileId);
    return bookmark != null;
  }

  /// Get bookmarks count
  Future<int> getCount({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get bookmarks count',
      operation: () async {
        final String query;
        final List<dynamic>? queryArgs;

        if (profileId != null) {
          query =
              'SELECT COUNT(*) FROM ${BookmarksTable.tableName} WHERE ${BookmarksTable.columnProfileId} = ?';
          queryArgs = [profileId];
        } else {
          query = 'SELECT COUNT(*) FROM ${BookmarksTable.tableName}';
          queryArgs = null;
        }

        return await firstIntValue(query, queryArgs) ?? 0;
      },
    );
  }

  /// Delete all bookmarks
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all bookmarks',
      operation: () async {
        await deleteRows(table: BookmarksTable.tableName);
        logger.debug('All bookmarks deleted');
      },
    );
  }

  /// Delete all bookmarks for a specific profile
  Future<void> deleteAllForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete bookmarks for profile',
      operation: () async {
        await deleteRows(
          table: BookmarksTable.tableName,
          where: '${BookmarksTable.columnProfileId} = ?',
          whereArgs: [profileId],
        );
        logger.debug('All bookmarks deleted for profile: $profileId');
      },
    );
  }

  /// Get recent bookmarks (limit to specific count)
  Future<List<BookmarkModel>> getRecent(int limit, {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get recent bookmarks',
      operation: () async {
        final maps = await queryRows(
          table: BookmarksTable.tableName,
          where: profileId != null
              ? '${BookmarksTable.columnProfileId} = ?'
              : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${BookmarksTable.columnCreatedAt} DESC',
          limit: limit,
        );

        logger.debug('Retrieved ${maps.length} recent bookmarks');
        return maps.map((map) => BookmarkModel.fromMap(map)).toList();
      },
    );
  }
}
