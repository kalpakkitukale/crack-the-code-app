/// Data Access Object for Collection operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/user/collection_model.dart';

/// DAO for collection table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class CollectionDao extends BaseDao {
  CollectionDao(super.dbHelper);

  /// Insert a collection
  Future<void> insert(CollectionModel collection) async {
    await executeWithErrorHandling(
      operationName: 'insert collection',
      operation: () async {
        await insertRow(
          table: CollectionsTable.tableName,
          values: collection.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Collection inserted: ${collection.name}');
      },
    );
  }

  /// Update a collection
  Future<void> update(CollectionModel collection) async {
    await executeWithErrorHandling(
      operationName: 'update collection',
      operation: () async {
        final count = await updateRows(
          table: CollectionsTable.tableName,
          values: collection.toMap(),
          where: '${CollectionsTable.columnId} = ?',
          whereArgs: [collection.id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Collection not found',
            entityType: 'Collection',
            entityId: collection.id,
          );
        }

        logger.debug('Collection updated: ${collection.name}');
      },
    );
  }

  /// Delete a collection
  Future<void> delete(String collectionId) async {
    await executeWithErrorHandling(
      operationName: 'delete collection',
      operation: () async {
        final count = await deleteRows(
          table: CollectionsTable.tableName,
          where: '${CollectionsTable.columnId} = ?',
          whereArgs: [collectionId],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Collection not found',
            entityType: 'Collection',
            entityId: collectionId,
          );
        }

        logger.debug('Collection deleted: $collectionId');
      },
    );
  }

  /// Get collection by ID
  Future<CollectionModel?> getById(String collectionId,
      {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get collection by ID',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${CollectionsTable.columnId} = ? AND ${CollectionsTable.columnProfileId} = ?';
          whereArgs = [collectionId, profileId];
        } else {
          whereClause = '${CollectionsTable.columnId} = ?';
          whereArgs = [collectionId];
        }

        final maps = await queryRows(
          table: CollectionsTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return CollectionModel.fromMap(maps.first);
      },
    );
  }

  /// Get all collections sorted by created date (newest first)
  Future<List<CollectionModel>> getAll({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get all collections',
      operation: () async {
        final maps = await queryRows(
          table: CollectionsTable.tableName,
          where: profileId != null
              ? '${CollectionsTable.columnProfileId} = ?'
              : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${CollectionsTable.columnCreatedAt} DESC',
        );

        logger.debug('Retrieved ${maps.length} collections');
        return maps.map((map) => CollectionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get collections count
  Future<int> getCount({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get collections count',
      operation: () async {
        final String query;
        final List<dynamic>? queryArgs;

        if (profileId != null) {
          query =
              'SELECT COUNT(*) FROM ${CollectionsTable.tableName} WHERE ${CollectionsTable.columnProfileId} = ?';
          queryArgs = [profileId];
        } else {
          query = 'SELECT COUNT(*) FROM ${CollectionsTable.tableName}';
          queryArgs = null;
        }

        return await firstIntValue(query, queryArgs) ?? 0;
      },
    );
  }

  /// Delete all collections for a specific profile
  Future<void> deleteAllForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete collections for profile',
      operation: () async {
        await deleteRows(
          table: CollectionsTable.tableName,
          where: '${CollectionsTable.columnProfileId} = ?',
          whereArgs: [profileId],
        );
        logger.debug('All collections deleted for profile: $profileId');
      },
    );
  }

  /// Delete all collections
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all collections',
      operation: () async {
        await deleteRows(table: CollectionsTable.tableName);
        logger.debug('All collections deleted');
      },
    );
  }
}
