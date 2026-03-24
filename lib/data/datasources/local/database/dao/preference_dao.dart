/// Data Access Object for Preference operations (Key-Value store)
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/user/preference_model.dart';

/// DAO for preferences table operations (Key-Value store)
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class PreferenceDao extends BaseDao {
  PreferenceDao(super.dbHelper);

  /// Save or update a preference (UPSERT)
  Future<void> save(PreferenceModel preference) async {
    await executeWithErrorHandling(
      operationName: 'save preference',
      operation: () async {
        await insertRow(
          table: PreferencesTable.tableName,
          values: preference.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Preference saved: ${preference.key} = ${preference.value}');
      },
    );
  }

  /// Get preference by key
  Future<PreferenceModel?> getByKey(String key) async {
    return await executeWithErrorHandling(
      operationName: 'get preference by key',
      operation: () async {
        final maps = await queryRows(
          table: PreferencesTable.tableName,
          where: '${PreferencesTable.columnKey} = ?',
          whereArgs: [key],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return PreferenceModel.fromMap(maps.first);
      },
    );
  }

  /// Get all preferences
  Future<List<PreferenceModel>> getAll() async {
    return await executeWithErrorHandling(
      operationName: 'get all preferences',
      operation: () async {
        final maps = await queryRows(
          table: PreferencesTable.tableName,
          orderBy: '${PreferencesTable.columnKey} ASC',
        );

        logger.debug('Retrieved ${maps.length} preferences');
        return maps.map((map) => PreferenceModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete a preference by key
  Future<void> delete(String key) async {
    await executeWithErrorHandling(
      operationName: 'delete preference',
      operation: () async {
        final count = await deleteRows(
          table: PreferencesTable.tableName,
          where: '${PreferencesTable.columnKey} = ?',
          whereArgs: [key],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Preference not found',
            entityType: 'Preference',
            entityId: key,
          );
        }

        logger.debug('Preference deleted: $key');
      },
    );
  }

  /// Delete all preferences
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all preferences',
      operation: () async {
        await deleteRows(table: PreferencesTable.tableName);
        logger.debug('All preferences deleted');
      },
    );
  }

  /// Check if a preference exists
  Future<bool> exists(String key) async {
    final preference = await getByKey(key);
    return preference != null;
  }
}
