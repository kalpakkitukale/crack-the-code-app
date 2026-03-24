/// Data Access Object for Parental Controls operations
/// Manages PIN, time limits, and content restrictions for Junior segment
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'dart:convert';
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';

/// Parental Controls settings model
class ParentalControlsData {
  final int? id;
  final String userId;
  final String? pinHash;
  final int dailyLimitMinutes;
  final String difficultyFilter;
  final List<String> hiddenSubjects;
  final bool showTimeToChild;
  final String? weeklyReportEmail;
  final bool isEnabled;
  final DateTime? pinChangedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParentalControlsData({
    this.id,
    required this.userId,
    this.pinHash,
    this.dailyLimitMinutes = 0,
    this.difficultyFilter = 'all',
    this.hiddenSubjects = const [],
    this.showTimeToChild = true,
    this.weeklyReportEmail,
    this.isEnabled = false,
    this.pinChangedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) ParentalControlsTable.columnId: id,
      ParentalControlsTable.columnUserId: userId,
      ParentalControlsTable.columnPinHash: pinHash,
      ParentalControlsTable.columnDailyLimitMinutes: dailyLimitMinutes,
      ParentalControlsTable.columnDifficultyFilter: difficultyFilter,
      ParentalControlsTable.columnHiddenSubjects: jsonEncode(hiddenSubjects),
      ParentalControlsTable.columnShowTimeToChild: showTimeToChild ? 1 : 0,
      ParentalControlsTable.columnWeeklyReportEmail: weeklyReportEmail,
      ParentalControlsTable.columnIsEnabled: isEnabled ? 1 : 0,
      ParentalControlsTable.columnPinChangedAt:
          pinChangedAt?.millisecondsSinceEpoch,
      ParentalControlsTable.columnCreatedAt: createdAt.millisecondsSinceEpoch,
      ParentalControlsTable.columnUpdatedAt: updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ParentalControlsData.fromMap(Map<String, dynamic> map) {
    return ParentalControlsData(
      id: map[ParentalControlsTable.columnId] as int?,
      userId: map[ParentalControlsTable.columnUserId] as String,
      pinHash: map[ParentalControlsTable.columnPinHash] as String?,
      dailyLimitMinutes:
          map[ParentalControlsTable.columnDailyLimitMinutes] as int? ?? 0,
      difficultyFilter:
          map[ParentalControlsTable.columnDifficultyFilter] as String? ?? 'all',
      hiddenSubjects:
          _parseJsonList(map[ParentalControlsTable.columnHiddenSubjects]),
      showTimeToChild:
          (map[ParentalControlsTable.columnShowTimeToChild] as int?) == 1,
      weeklyReportEmail:
          map[ParentalControlsTable.columnWeeklyReportEmail] as String?,
      isEnabled: (map[ParentalControlsTable.columnIsEnabled] as int?) == 1,
      pinChangedAt: map[ParentalControlsTable.columnPinChangedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[ParentalControlsTable.columnPinChangedAt] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map[ParentalControlsTable.columnCreatedAt] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          map[ParentalControlsTable.columnUpdatedAt] as int),
    );
  }

  static List<String> _parseJsonList(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (e) {
        logger.warning('Failed to parse hidden subjects JSON: $e');
      }
    }
    return [];
  }

  ParentalControlsData copyWith({
    int? id,
    String? userId,
    String? pinHash,
    int? dailyLimitMinutes,
    String? difficultyFilter,
    List<String>? hiddenSubjects,
    bool? showTimeToChild,
    String? weeklyReportEmail,
    bool? isEnabled,
    DateTime? pinChangedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParentalControlsData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pinHash: pinHash ?? this.pinHash,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      difficultyFilter: difficultyFilter ?? this.difficultyFilter,
      hiddenSubjects: hiddenSubjects ?? this.hiddenSubjects,
      showTimeToChild: showTimeToChild ?? this.showTimeToChild,
      weeklyReportEmail: weeklyReportEmail ?? this.weeklyReportEmail,
      isEnabled: isEnabled ?? this.isEnabled,
      pinChangedAt: pinChangedAt ?? this.pinChangedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// DAO for parental controls table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class ParentalControlsDao extends BaseDao {
  ParentalControlsDao(super.dbHelper);

  /// Save or update parental controls settings (UPSERT)
  Future<ParentalControlsData> save(ParentalControlsData data) async {
    return await executeWithErrorHandling(
      operationName: 'save parental controls',
      operation: () async {
        final now = DateTime.now();
        final dataToSave = data.copyWith(updatedAt: now);

        final insertedId = await insertRow(
          table: ParentalControlsTable.tableName,
          values: dataToSave.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        logger.debug('Parental controls saved for user: ${data.userId}');
        return dataToSave.copyWith(id: insertedId);
      },
    );
  }

  /// Get parental controls by user ID
  Future<ParentalControlsData?> getByUserId(String userId) async {
    return await executeWithErrorHandling(
      operationName: 'get parental controls',
      operation: () async {
        final maps = await queryRows(
          table: ParentalControlsTable.tableName,
          where: '${ParentalControlsTable.columnUserId} = ?',
          whereArgs: [userId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return ParentalControlsData.fromMap(maps.first);
      },
    );
  }

  /// Update PIN hash
  Future<void> updatePin(String userId, String pinHash) async {
    await executeWithErrorHandling(
      operationName: 'update PIN',
      operation: () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        await updateRows(
          table: ParentalControlsTable.tableName,
          values: {
            ParentalControlsTable.columnPinHash: pinHash,
            ParentalControlsTable.columnPinChangedAt: now,
            ParentalControlsTable.columnUpdatedAt: now,
          },
          where: '${ParentalControlsTable.columnUserId} = ?',
          whereArgs: [userId],
        );

        logger.debug('PIN updated for user: $userId');
      },
    );
  }

  /// Update time limit
  Future<void> updateTimeLimit(String userId, int minutes) async {
    await executeWithErrorHandling(
      operationName: 'update time limit',
      operation: () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        await updateRows(
          table: ParentalControlsTable.tableName,
          values: {
            ParentalControlsTable.columnDailyLimitMinutes: minutes,
            ParentalControlsTable.columnUpdatedAt: now,
          },
          where: '${ParentalControlsTable.columnUserId} = ?',
          whereArgs: [userId],
        );

        logger.debug('Time limit updated for user: $userId to $minutes minutes');
      },
    );
  }

  /// Enable/disable parental controls
  Future<void> setEnabled(String userId, bool enabled) async {
    await executeWithErrorHandling(
      operationName: 'update parental controls enabled status',
      operation: () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        await updateRows(
          table: ParentalControlsTable.tableName,
          values: {
            ParentalControlsTable.columnIsEnabled: enabled ? 1 : 0,
            ParentalControlsTable.columnUpdatedAt: now,
          },
          where: '${ParentalControlsTable.columnUserId} = ?',
          whereArgs: [userId],
        );

        logger.debug(
            'Parental controls ${enabled ? "enabled" : "disabled"} for user: $userId');
      },
    );
  }

  /// Delete parental controls for a user
  Future<void> delete(String userId) async {
    await executeWithErrorHandling(
      operationName: 'delete parental controls',
      operation: () async {
        await deleteRows(
          table: ParentalControlsTable.tableName,
          where: '${ParentalControlsTable.columnUserId} = ?',
          whereArgs: [userId],
        );
        logger.debug('Parental controls deleted for user: $userId');
      },
    );
  }
}
