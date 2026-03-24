/// Data Access Object for CollectionVideo operations (Many-to-Many relationship)
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/user/collection_video_model.dart';

/// DAO for collection_videos table operations (Many-to-Many relationship)
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class CollectionVideoDao extends BaseDao {
  CollectionVideoDao(super.dbHelper);

  /// Insert a video into a collection
  Future<void> insert(CollectionVideoModel video) async {
    await executeWithErrorHandling(
      operationName: 'insert video into collection',
      operation: () async {
        await insertRow(
          table: CollectionVideosTable.tableName,
          values: video.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug(
            'Video added to collection: ${video.collectionId} - ${video.videoId}');
      },
    );
  }

  /// Delete a video from a collection
  Future<void> deleteByCollectionAndVideo(
      String collectionId, String videoId) async {
    await executeWithErrorHandling(
      operationName: 'delete video from collection',
      operation: () async {
        final count = await deleteRows(
          table: CollectionVideosTable.tableName,
          where:
              '${CollectionVideosTable.columnCollectionId} = ? AND ${CollectionVideosTable.columnVideoId} = ?',
          whereArgs: [collectionId, videoId],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Video not found in collection',
            entityType: 'CollectionVideo',
            entityId: '$collectionId-$videoId',
          );
        }

        logger
            .debug('Video removed from collection: $collectionId - $videoId');
      },
    );
  }

  /// Get all videos in a collection
  Future<List<CollectionVideoModel>> getByCollectionId(
      String collectionId) async {
    return await executeWithErrorHandling(
      operationName: 'get videos by collection ID',
      operation: () async {
        final maps = await queryRows(
          table: CollectionVideosTable.tableName,
          where: '${CollectionVideosTable.columnCollectionId} = ?',
          whereArgs: [collectionId],
          orderBy: '${CollectionVideosTable.columnAddedAt} DESC',
        );

        logger.debug(
            'Retrieved ${maps.length} videos for collection: $collectionId');
        return maps.map((map) => CollectionVideoModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all collections that contain a specific video
  Future<List<CollectionVideoModel>> getCollectionsForVideo(
      String videoId) async {
    return await executeWithErrorHandling(
      operationName: 'get collections for video',
      operation: () async {
        final maps = await queryRows(
          table: CollectionVideosTable.tableName,
          where: '${CollectionVideosTable.columnVideoId} = ?',
          whereArgs: [videoId],
          orderBy: '${CollectionVideosTable.columnAddedAt} DESC',
        );

        logger.debug('Video $videoId is in ${maps.length} collections');
        return maps.map((map) => CollectionVideoModel.fromMap(map)).toList();
      },
    );
  }

  /// Check if a video is in a collection
  Future<bool> isVideoInCollection(String collectionId, String videoId) async {
    return await executeWithErrorHandling(
      operationName: 'check video in collection',
      operation: () async {
        final maps = await queryRows(
          table: CollectionVideosTable.tableName,
          where:
              '${CollectionVideosTable.columnCollectionId} = ? AND ${CollectionVideosTable.columnVideoId} = ?',
          whereArgs: [collectionId, videoId],
          limit: 1,
        );

        return maps.isNotEmpty;
      },
    );
  }

  /// Get total number of videos across all collections
  Future<int> getTotalVideosCount() async {
    return await executeWithErrorHandling(
      operationName: 'get total videos count',
      operation: () async {
        final query =
            'SELECT COUNT(*) FROM ${CollectionVideosTable.tableName}';
        return await firstIntValue(query) ?? 0;
      },
    );
  }

  /// Get video count for a specific collection
  Future<int> getVideoCountForCollection(String collectionId) async {
    return await executeWithErrorHandling(
      operationName: 'get video count for collection',
      operation: () async {
        final query =
            'SELECT COUNT(*) FROM ${CollectionVideosTable.tableName} WHERE ${CollectionVideosTable.columnCollectionId} = ?';
        return await firstIntValue(query, [collectionId]) ?? 0;
      },
    );
  }

  /// Delete all videos from a collection
  Future<void> deleteByCollectionId(String collectionId) async {
    await executeWithErrorHandling(
      operationName: 'delete videos by collection ID',
      operation: () async {
        await deleteRows(
          table: CollectionVideosTable.tableName,
          where: '${CollectionVideosTable.columnCollectionId} = ?',
          whereArgs: [collectionId],
        );
        logger.debug('All videos deleted from collection: $collectionId');
      },
    );
  }

  /// Delete all collection video associations
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all collection videos',
      operation: () async {
        await deleteRows(table: CollectionVideosTable.tableName);
        logger.debug('All collection video associations deleted');
      },
    );
  }
}
