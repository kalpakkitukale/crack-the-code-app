/// Data Access Object for Screen Time Log operations
/// Tracks daily usage for parental monitoring in Junior segment
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'dart:convert';
import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';

/// Screen time session record
class ScreenTimeSession {
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;

  const ScreenTimeSession({
    required this.startTime,
    this.endTime,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'duration_minutes': durationMinutes,
      };

  factory ScreenTimeSession.fromJson(Map<String, dynamic> json) {
    return ScreenTimeSession(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
    );
  }
}

/// Screen time log data for a single day
class ScreenTimeLogData {
  final int? id;
  final String userId;
  final String date;
  final int minutesUsed;
  final List<ScreenTimeSession> sessions;
  final bool limitReached;
  final bool wasExtended;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScreenTimeLogData({
    this.id,
    required this.userId,
    required this.date,
    this.minutesUsed = 0,
    this.sessions = const [],
    this.limitReached = false,
    this.wasExtended = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) ScreenTimeLogTable.columnId: id,
      ScreenTimeLogTable.columnUserId: userId,
      ScreenTimeLogTable.columnDate: date,
      ScreenTimeLogTable.columnMinutesUsed: minutesUsed,
      ScreenTimeLogTable.columnSessions: jsonEncode(
        sessions.map((s) => s.toJson()).toList(),
      ),
      ScreenTimeLogTable.columnLimitReached: limitReached ? 1 : 0,
      ScreenTimeLogTable.columnWasExtended: wasExtended ? 1 : 0,
      ScreenTimeLogTable.columnCreatedAt: createdAt.millisecondsSinceEpoch,
      ScreenTimeLogTable.columnUpdatedAt: updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ScreenTimeLogData.fromMap(Map<String, dynamic> map) {
    return ScreenTimeLogData(
      id: map[ScreenTimeLogTable.columnId] as int?,
      userId: map[ScreenTimeLogTable.columnUserId] as String,
      date: map[ScreenTimeLogTable.columnDate] as String,
      minutesUsed: map[ScreenTimeLogTable.columnMinutesUsed] as int? ?? 0,
      sessions: _parseSessions(map[ScreenTimeLogTable.columnSessions]),
      limitReached: (map[ScreenTimeLogTable.columnLimitReached] as int?) == 1,
      wasExtended: (map[ScreenTimeLogTable.columnWasExtended] as int?) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[ScreenTimeLogTable.columnCreatedAt] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[ScreenTimeLogTable.columnUpdatedAt] as int,
      ),
    );
  }

  static List<ScreenTimeSession> _parseSessions(dynamic value) {
    if (value == null) return [];
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded
              .map((e) => ScreenTimeSession.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        logger.warning('Failed to parse screen time sessions: $e');
      }
    }
    return [];
  }

  ScreenTimeLogData copyWith({
    int? id,
    String? userId,
    String? date,
    int? minutesUsed,
    List<ScreenTimeSession>? sessions,
    bool? limitReached,
    bool? wasExtended,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScreenTimeLogData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      minutesUsed: minutesUsed ?? this.minutesUsed,
      sessions: sessions ?? this.sessions,
      limitReached: limitReached ?? this.limitReached,
      wasExtended: wasExtended ?? this.wasExtended,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// DAO for screen time log table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class ScreenTimeDao extends BaseDao {
  ScreenTimeDao(super.dbHelper);

  /// Get date string in YYYY-MM-DD format
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Save or update screen time log (UPSERT)
  Future<ScreenTimeLogData> save(ScreenTimeLogData data) async {
    return await executeWithErrorHandling(
      operationName: 'save screen time log',
      operation: () async {
        final now = DateTime.now();
        final dataToSave = data.copyWith(updatedAt: now);

        final insertedId = await insertRow(
          table: ScreenTimeLogTable.tableName,
          values: dataToSave.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        logger.debug(
            'Screen time log saved for user: ${data.userId}, date: ${data.date}');
        return dataToSave.copyWith(id: insertedId);
      },
    );
  }

  /// Get screen time log for a specific date
  Future<ScreenTimeLogData?> getByDate(String userId, DateTime date) async {
    return await executeWithErrorHandling(
      operationName: 'get screen time log',
      operation: () async {
        final dateStr = _formatDate(date);

        final maps = await queryRows(
          table: ScreenTimeLogTable.tableName,
          where:
              '${ScreenTimeLogTable.columnUserId} = ? AND ${ScreenTimeLogTable.columnDate} = ?',
          whereArgs: [userId, dateStr],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return ScreenTimeLogData.fromMap(maps.first);
      },
    );
  }

  /// Get today's screen time log (or create if doesn't exist)
  Future<ScreenTimeLogData> getOrCreateToday(String userId) async {
    final today = DateTime.now();
    final existing = await getByDate(userId, today);

    if (existing != null) {
      return existing;
    }

    final now = DateTime.now();
    final newLog = ScreenTimeLogData(
      userId: userId,
      date: _formatDate(today),
      minutesUsed: 0,
      sessions: [],
      createdAt: now,
      updatedAt: now,
    );

    return await save(newLog);
  }

  /// Add minutes to today's usage
  Future<ScreenTimeLogData> addMinutes(String userId, int minutes) async {
    final log = await getOrCreateToday(userId);
    final updated = log.copyWith(
      minutesUsed: log.minutesUsed + minutes,
      updatedAt: DateTime.now(),
    );
    return await save(updated);
  }

  /// Mark limit as reached
  Future<void> markLimitReached(String userId) async {
    final log = await getOrCreateToday(userId);
    final updated = log.copyWith(
      limitReached: true,
      updatedAt: DateTime.now(),
    );
    await save(updated);
    logger.info('Screen time limit reached for user: $userId');
  }

  /// Mark time as extended by parent
  Future<void> markExtended(String userId) async {
    final log = await getOrCreateToday(userId);
    final updated = log.copyWith(
      wasExtended: true,
      updatedAt: DateTime.now(),
    );
    await save(updated);
    logger.info('Screen time extended for user: $userId');
  }

  /// Get screen time logs for a date range
  Future<List<ScreenTimeLogData>> getRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get screen time log range',
      operation: () async {
        final startStr = _formatDate(startDate);
        final endStr = _formatDate(endDate);

        final maps = await queryRows(
          table: ScreenTimeLogTable.tableName,
          where:
              '${ScreenTimeLogTable.columnUserId} = ? AND ${ScreenTimeLogTable.columnDate} >= ? AND ${ScreenTimeLogTable.columnDate} <= ?',
          whereArgs: [userId, startStr, endStr],
          orderBy: '${ScreenTimeLogTable.columnDate} DESC',
        );

        logger.debug('Retrieved ${maps.length} screen time logs for range');
        return maps.map((map) => ScreenTimeLogData.fromMap(map)).toList();
      },
    );
  }

  /// Get this week's total minutes
  Future<int> getWeeklyTotalMinutes(String userId) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final logs = await getRange(userId, weekAgo, now);
    return logs.fold<int>(0, (sum, log) => sum + log.minutesUsed);
  }

  /// Delete old logs (keep last 30 days)
  Future<int> cleanupOldLogs(String userId) async {
    return await executeWithErrorHandling(
      operationName: 'cleanup old logs',
      operation: () async {
        final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
        final cutoffStr = _formatDate(cutoffDate);

        final deleted = await deleteRows(
          table: ScreenTimeLogTable.tableName,
          where:
              '${ScreenTimeLogTable.columnUserId} = ? AND ${ScreenTimeLogTable.columnDate} < ?',
          whereArgs: [userId, cutoffStr],
        );

        logger.debug(
            'Cleaned up $deleted old screen time logs for user: $userId');
        return deleted;
      },
    );
  }
}
