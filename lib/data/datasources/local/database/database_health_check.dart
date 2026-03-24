/// Database health check utility
///
/// Provides methods to verify database schema integrity, validate tables,
/// and check for missing columns or indexes.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:sqflite/sqflite.dart' as sqflite_mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_desktop;

/// Result of a database health check
class DatabaseHealthCheckResult {
  final bool isHealthy;
  final List<String> missingTables;
  final Map<String, List<String>> missingColumns;
  final List<String> missingIndexes;
  final List<String> warnings;
  final DateTime checkedAt;

  const DatabaseHealthCheckResult({
    required this.isHealthy,
    required this.missingTables,
    required this.missingColumns,
    required this.missingIndexes,
    required this.warnings,
    required this.checkedAt,
  });

  factory DatabaseHealthCheckResult.healthy() => DatabaseHealthCheckResult(
        isHealthy: true,
        missingTables: const [],
        missingColumns: const {},
        missingIndexes: const [],
        warnings: const [],
        checkedAt: DateTime.now(),
      );

  @override
  String toString() {
    if (isHealthy) {
      return 'Database is healthy (checked at $checkedAt)';
    }
    final issues = <String>[];
    if (missingTables.isNotEmpty) {
      issues.add('Missing tables: ${missingTables.join(", ")}');
    }
    if (missingColumns.isNotEmpty) {
      for (final entry in missingColumns.entries) {
        issues.add('Missing columns in ${entry.key}: ${entry.value.join(", ")}');
      }
    }
    if (missingIndexes.isNotEmpty) {
      issues.add('Missing indexes: ${missingIndexes.join(", ")}');
    }
    return 'Database issues found: ${issues.join("; ")}';
  }
}

/// Database health check utility
class DatabaseHealthCheck {
  final DatabaseHelper _dbHelper;

  DatabaseHealthCheck([DatabaseHelper? dbHelper])
      : _dbHelper = dbHelper ?? DatabaseHelper();

  /// Expected tables in the database
  static const List<String> expectedTables = [
    // User data tables
    DatabaseTables.bookmarks,
    DatabaseTables.notes,
    DatabaseTables.progress,
    DatabaseTables.collections,
    DatabaseTables.collectionVideos,
    DatabaseTables.preferences,
    DatabaseTables.searchHistory,
    DatabaseTables.appState,
    // Quiz system tables
    DatabaseTables.questionsOffline,
    DatabaseTables.quizzesOffline,
    DatabaseTables.quizSessions,
    DatabaseTables.quizAttempts,
    // Pedagogy system tables
    DatabaseTables.conceptMastery,
    DatabaseTables.spacedRepetition,
    DatabaseTables.learningPaths,
    DatabaseTables.gamification,
    DatabaseTables.xpEvents,
    DatabaseTables.badges,
    DatabaseTables.videoLearningSessions,
    DatabaseTables.preAssessments,
    DatabaseTables.chapterAssessments,
    DatabaseTables.recommendationsHistory,
    // Junior app tables
    DatabaseTables.userProfileJunior,
    DatabaseTables.parentalControls,
    DatabaseTables.screenTimeLog,
    // Study tools tables
    DatabaseTables.videoSummaries,
    DatabaseTables.glossaryTerms,
    DatabaseTables.videoQA,
    DatabaseTables.mindMapNodes,
    DatabaseTables.flashcardDecks,
    DatabaseTables.flashcards,
    DatabaseTables.flashcardProgress,
    // Chapter study tools tables
    DatabaseTables.chapterSummaries,
    DatabaseTables.chapterNotes,
  ];

  /// Expected columns for critical tables
  static const Map<String, List<String>> expectedColumns = {
    DatabaseTables.bookmarks: [
      BookmarksTable.columnId,
      BookmarksTable.columnVideoId,
      BookmarksTable.columnProfileId,
      BookmarksTable.columnTitle,
      BookmarksTable.columnCreatedAt,
    ],
    DatabaseTables.progress: [
      ProgressTable.columnId,
      ProgressTable.columnVideoId,
      ProgressTable.columnProfileId,
      ProgressTable.columnTitle,
      ProgressTable.columnWatchDuration,
      ProgressTable.columnTotalDuration,
      ProgressTable.columnCompleted,
      ProgressTable.columnLastWatched,
    ],
    DatabaseTables.quizAttempts: [
      QuizAttemptsTable.columnId,
      QuizAttemptsTable.columnQuizId,
      QuizAttemptsTable.columnStudentId,
      QuizAttemptsTable.columnScore,
      QuizAttemptsTable.columnPassed,
      QuizAttemptsTable.columnCompletedAt,
      QuizAttemptsTable.columnStatus,
      QuizAttemptsTable.columnAssessmentType,
    ],
    DatabaseTables.gamification: [
      GamificationTable.columnId,
      GamificationTable.columnStudentId,
      GamificationTable.columnTotalXp,
      GamificationTable.columnLevel,
      GamificationTable.columnCurrentStreak,
      GamificationTable.columnLongestStreak,
    ],
  };

  /// Run a complete health check on the database
  Future<DatabaseHealthCheckResult> runHealthCheck() async {
    logger.info('Running database health check...');

    try {
      final db = await _dbHelper.database;
      final missingTables = <String>[];
      final missingColumns = <String, List<String>>{};
      final missingIndexes = <String>[];
      final warnings = <String>[];

      // Check tables
      final existingTables = await _getExistingTables(db);
      for (final table in expectedTables) {
        if (!existingTables.contains(table)) {
          missingTables.add(table);
        }
      }

      // Check columns for critical tables
      for (final entry in expectedColumns.entries) {
        final tableName = entry.key;
        final expectedCols = entry.value;

        if (missingTables.contains(tableName)) continue;

        final existingCols = await _getExistingColumns(db, tableName);
        final missing = expectedCols
            .where((col) => !existingCols.contains(col))
            .toList();

        if (missing.isNotEmpty) {
          missingColumns[tableName] = missing;
        }
      }

      // Check for orphaned data (warnings only)
      final orphanedSessionsCount = await _countOrphanedSessions(db);
      if (orphanedSessionsCount > 0) {
        warnings.add('Found $orphanedSessionsCount orphaned quiz sessions');
      }

      final isHealthy = missingTables.isEmpty && missingColumns.isEmpty;

      final result = DatabaseHealthCheckResult(
        isHealthy: isHealthy,
        missingTables: missingTables,
        missingColumns: missingColumns,
        missingIndexes: missingIndexes,
        warnings: warnings,
        checkedAt: DateTime.now(),
      );

      if (isHealthy) {
        logger.info('Database health check passed');
      } else {
        logger.warning('Database health check found issues: $result');
      }

      return result;
    } catch (e, stackTrace) {
      logger.error('Database health check failed', e, stackTrace);
      return DatabaseHealthCheckResult(
        isHealthy: false,
        missingTables: const [],
        missingColumns: const {},
        missingIndexes: const [],
        warnings: ['Health check failed: $e'],
        checkedAt: DateTime.now(),
      );
    }
  }

  /// Get list of existing tables in the database
  Future<Set<String>> _getExistingTables(dynamic db) async {
    const query =
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'";

    List<Map<String, dynamic>> result;
    if (db is sqflite_mobile.Database) {
      result = await db.rawQuery(query);
    } else if (db is sqflite_desktop.Database) {
      result = await db.rawQuery(query);
    } else {
      throw UnsupportedError('Unknown database type');
    }

    return result.map((row) => row['name'] as String).toSet();
  }

  /// Get list of existing columns in a table
  Future<Set<String>> _getExistingColumns(dynamic db, String tableName) async {
    final query = "PRAGMA table_info($tableName)";

    List<Map<String, dynamic>> result;
    if (db is sqflite_mobile.Database) {
      result = await db.rawQuery(query);
    } else if (db is sqflite_desktop.Database) {
      result = await db.rawQuery(query);
    } else {
      throw UnsupportedError('Unknown database type');
    }

    return result.map((row) => row['name'] as String).toSet();
  }

  /// Count orphaned quiz sessions (sessions older than 24 hours in 'active' state)
  Future<int> _countOrphanedSessions(dynamic db) async {
    try {
      final cutoff =
          DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch;
      final query = '''
        SELECT COUNT(*) as count FROM ${QuizSessionsTable.tableName}
        WHERE ${QuizSessionsTable.columnState} IN ('active', 'in_progress')
        AND ${QuizSessionsTable.columnStartTime} < ?
      ''';

      List<Map<String, dynamic>> result;
      if (db is sqflite_mobile.Database) {
        result = await db.rawQuery(query, [cutoff]);
      } else if (db is sqflite_desktop.Database) {
        result = await db.rawQuery(query, [cutoff]);
      } else {
        throw UnsupportedError('Unknown database type');
      }

      return (result.first['count'] as int?) ?? 0;
    } catch (e) {
      // Table might not exist yet
      return 0;
    }
  }

  /// Clean up orphaned quiz sessions
  Future<int> cleanupOrphanedSessions() async {
    logger.info('Cleaning up orphaned quiz sessions...');

    try {
      final db = await _dbHelper.database;
      final cutoff =
          DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch;

      final query = '''
        DELETE FROM ${QuizSessionsTable.tableName}
        WHERE ${QuizSessionsTable.columnState} IN ('active', 'in_progress')
        AND ${QuizSessionsTable.columnStartTime} < ?
      ''';

      int deletedCount;
      if (db is sqflite_mobile.Database) {
        deletedCount = await db.rawDelete(query, [cutoff]);
      } else if (db is sqflite_desktop.Database) {
        deletedCount = await db.rawDelete(query, [cutoff]);
      } else {
        throw UnsupportedError('Unknown database type');
      }

      logger.info('Cleaned up $deletedCount orphaned quiz sessions');
      return deletedCount;
    } catch (e, stackTrace) {
      logger.error('Failed to cleanup orphaned sessions', e, stackTrace);
      return 0;
    }
  }

  /// Get database statistics
  Future<Map<String, int>> getTableRowCounts() async {
    logger.debug('Getting database statistics...');

    try {
      final db = await _dbHelper.database;
      final counts = <String, int>{};

      for (final table in expectedTables) {
        try {
          final query = 'SELECT COUNT(*) as count FROM $table';
          List<Map<String, dynamic>> result;
          if (db is sqflite_mobile.Database) {
            result = await db.rawQuery(query);
          } else if (db is sqflite_desktop.Database) {
            result = await db.rawQuery(query);
          } else {
            continue;
          }
          counts[table] = (result.first['count'] as int?) ?? 0;
        } catch (e) {
          // Table might not exist
          counts[table] = -1;
        }
      }

      return counts;
    } catch (e, stackTrace) {
      logger.error('Failed to get table row counts', e, stackTrace);
      return {};
    }
  }
}
