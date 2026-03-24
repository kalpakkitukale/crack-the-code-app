/// Database backup and restore utility
///
/// Provides methods to export database to JSON and import for recovery.
/// Used before migrations and for data portability.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:sqflite/sqflite.dart' as sqflite_mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_desktop;

/// Result of a backup operation
class BackupResult {
  final bool success;
  final String? filePath;
  final int tableCount;
  final int totalRows;
  final String? error;
  final DateTime timestamp;

  const BackupResult({
    required this.success,
    this.filePath,
    required this.tableCount,
    required this.totalRows,
    this.error,
    required this.timestamp,
  });

  @override
  String toString() {
    if (success) {
      return 'Backup successful: $tableCount tables, $totalRows rows at $filePath';
    }
    return 'Backup failed: $error';
  }
}

/// Result of a restore operation
class RestoreResult {
  final bool success;
  final int tablesRestored;
  final int rowsRestored;
  final String? error;
  final DateTime timestamp;

  const RestoreResult({
    required this.success,
    required this.tablesRestored,
    required this.rowsRestored,
    this.error,
    required this.timestamp,
  });

  @override
  String toString() {
    if (success) {
      return 'Restore successful: $tablesRestored tables, $rowsRestored rows';
    }
    return 'Restore failed: $error';
  }
}

/// Database backup and restore utility
class DatabaseBackup {
  final DatabaseHelper _dbHelper;

  DatabaseBackup([DatabaseHelper? dbHelper])
      : _dbHelper = dbHelper ?? DatabaseHelper();

  /// Tables to include in backup (user data only, not cached content)
  static const List<String> backupTables = [
    // User data - critical
    DatabaseTables.bookmarks,
    DatabaseTables.notes,
    DatabaseTables.progress,
    DatabaseTables.collections,
    DatabaseTables.collectionVideos,
    DatabaseTables.preferences,
    DatabaseTables.searchHistory,
    // Quiz history - important
    DatabaseTables.quizAttempts,
    // Pedagogy data - important
    DatabaseTables.conceptMastery,
    DatabaseTables.gamification,
    DatabaseTables.badges,
    DatabaseTables.learningPaths,
    DatabaseTables.recommendationsHistory,
    // Junior app - important
    DatabaseTables.userProfileJunior,
    DatabaseTables.parentalControls,
    DatabaseTables.screenTimeLog,
    // Study tools - user-generated
    DatabaseTables.videoQA,
    DatabaseTables.flashcardProgress,
    DatabaseTables.chapterNotes,
  ];

  /// Create a backup of user data
  Future<BackupResult> createBackup({String? customPath}) async {
    logger.info('Creating database backup...');

    try {
      final db = await _dbHelper.database;
      final backupData = <String, dynamic>{
        'version': kDatabaseVersion,
        'timestamp': DateTime.now().toIso8601String(),
        'tables': <String, List<Map<String, dynamic>>>{},
      };

      int totalRows = 0;
      int tableCount = 0;

      for (final tableName in backupTables) {
        try {
          final rows = await _queryAllRows(db, tableName);
          if (rows.isNotEmpty) {
            (backupData['tables'] as Map<String, List<Map<String, dynamic>>>)[tableName] = rows;
            totalRows += rows.length;
            tableCount++;
            logger.debug('Backed up $tableName: ${rows.length} rows');
          }
        } catch (e) {
          // Table might not exist
          logger.debug('Skipping $tableName: $e');
        }
      }

      // Save to file
      final filePath = customPath ?? await _getBackupFilePath();
      final file = File(filePath);
      await file.writeAsString(jsonEncode(backupData));

      logger.info('Backup completed: $tableCount tables, $totalRows rows');

      return BackupResult(
        success: true,
        filePath: filePath,
        tableCount: tableCount,
        totalRows: totalRows,
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      logger.error('Backup failed', e, stackTrace);
      return BackupResult(
        success: false,
        tableCount: 0,
        totalRows: 0,
        error: e.toString(),
        timestamp: DateTime.now(),
      );
    }
  }

  /// Restore data from a backup file
  Future<RestoreResult> restoreBackup(String filePath) async {
    logger.info('Restoring database from backup: $filePath');

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileSystemException('Backup file not found', filePath);
      }

      final content = await file.readAsString();
      final backupData = jsonDecode(content) as Map<String, dynamic>;

      final backupVersion = backupData['version'] as int?;
      if (backupVersion == null) {
        throw const FormatException('Invalid backup file: missing version');
      }

      if (backupVersion > kDatabaseVersion) {
        throw FormatException(
          'Backup version ($backupVersion) is newer than current database version ($kDatabaseVersion)',
        );
      }

      final db = await _dbHelper.database;
      final tables = backupData['tables'] as Map<String, dynamic>?;

      if (tables == null || tables.isEmpty) {
        return RestoreResult(
          success: true,
          tablesRestored: 0,
          rowsRestored: 0,
          timestamp: DateTime.now(),
        );
      }

      int tablesRestored = 0;
      int rowsRestored = 0;

      for (final entry in tables.entries) {
        final tableName = entry.key;
        final rows = entry.value as List<dynamic>;

        if (rows.isEmpty) continue;

        try {
          // Clear existing data
          await _deleteAllRows(db, tableName);

          // Insert restored data
          for (final row in rows) {
            await _insertRow(db, tableName, row as Map<String, dynamic>);
            rowsRestored++;
          }

          tablesRestored++;
          logger.debug('Restored $tableName: ${rows.length} rows');
        } catch (e) {
          logger.warning('Failed to restore $tableName: $e');
        }
      }

      logger.info('Restore completed: $tablesRestored tables, $rowsRestored rows');

      return RestoreResult(
        success: true,
        tablesRestored: tablesRestored,
        rowsRestored: rowsRestored,
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      logger.error('Restore failed', e, stackTrace);
      return RestoreResult(
        success: false,
        tablesRestored: 0,
        rowsRestored: 0,
        error: e.toString(),
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get list of available backup files
  Future<List<FileSystemEntity>> listBackups() async {
    try {
      final backupDir = await _getBackupDirectory();
      final dir = Directory(backupDir);

      if (!await dir.exists()) {
        return [];
      }

      final files = await dir
          .list()
          .where((entity) =>
              entity is File && entity.path.endsWith('.streamshaala.backup'))
          .toList();

      // Sort by modification time (newest first)
      files.sort((a, b) {
        final aStat = (a as File).statSync();
        final bStat = (b as File).statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      return files;
    } catch (e) {
      logger.error('Failed to list backups: $e');
      return [];
    }
  }

  /// Delete old backups, keeping only the most recent N
  Future<int> cleanupOldBackups({int keepCount = 5}) async {
    try {
      final backups = await listBackups();

      if (backups.length <= keepCount) {
        return 0;
      }

      int deleted = 0;
      for (int i = keepCount; i < backups.length; i++) {
        try {
          await backups[i].delete();
          deleted++;
        } catch (e) {
          logger.warning('Failed to delete backup: ${backups[i].path}');
        }
      }

      logger.info('Cleaned up $deleted old backups');
      return deleted;
    } catch (e) {
      logger.error('Failed to cleanup backups: $e');
      return 0;
    }
  }

  /// Get backup directory path
  Future<String> _getBackupDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = '${appDir.path}/streamshaala/backups';

    final dir = Directory(backupDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return backupDir;
  }

  /// Get default backup file path with timestamp
  Future<String> _getBackupFilePath() async {
    final backupDir = await _getBackupDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    return '$backupDir/$timestamp.streamshaala.backup';
  }

  /// Query all rows from a table
  Future<List<Map<String, dynamic>>> _queryAllRows(
    dynamic db,
    String tableName,
  ) async {
    final query = 'SELECT * FROM $tableName';

    if (db is sqflite_mobile.Database) {
      return await db.rawQuery(query);
    } else if (db is sqflite_desktop.Database) {
      return await db.rawQuery(query);
    } else {
      throw UnsupportedError('Unknown database type');
    }
  }

  /// Delete all rows from a table
  Future<void> _deleteAllRows(dynamic db, String tableName) async {
    final query = 'DELETE FROM $tableName';

    if (db is sqflite_mobile.Database) {
      await db.execute(query);
    } else if (db is sqflite_desktop.Database) {
      await db.execute(query);
    } else {
      throw UnsupportedError('Unknown database type');
    }
  }

  /// Insert a row into a table
  Future<void> _insertRow(
    dynamic db,
    String tableName,
    Map<String, dynamic> values,
  ) async {
    // Build INSERT statement
    final columns = values.keys.join(', ');
    final placeholders = List.filled(values.length, '?').join(', ');
    final query = 'INSERT OR REPLACE INTO $tableName ($columns) VALUES ($placeholders)';

    if (db is sqflite_mobile.Database) {
      await db.rawInsert(query, values.values.toList());
    } else if (db is sqflite_desktop.Database) {
      await db.rawInsert(query, values.values.toList());
    } else {
      throw UnsupportedError('Unknown database type');
    }
  }
}
