import 'package:sqflite/sqflite.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/database_helper.dart';
import 'package:crack_the_code/core/services/youtube_metadata_service.dart';
import 'package:crack_the_code/core/constants/database_constants.dart';

/// One-time migration utility to fix progress records
/// Fixes two issues:
/// 1. Updates completion flag for videos with >= 90% watch progress
/// 2. Fetches missing metadata for "Untitled Video" entries
class ProgressMigration {
  /// Run the progress migration
  static Future<void> migrate() async {
    logger.info('Starting progress migration...');

    try {
      final db = await DatabaseHelper().database;

      // Fix completion status for videos >= 90%
      await _fixCompletionStatus(db);

      // Fetch missing metadata from YouTube
      await _fetchMissingMetadata(db);

      logger.info('Progress migration completed successfully');
    } catch (e, stackTrace) {
      logger.error('Progress migration failed', e, stackTrace);
    }
  }

  /// Fix completion status based on 90% threshold
  static Future<void> _fixCompletionStatus(Database db) async {
    logger.info('Fixing completion status for progress records...');

    try {
      // Get all progress records that aren't marked complete but should be
      final results = await db.rawQuery('''
        SELECT id, video_id, watch_duration, total_duration, completed
        FROM progress
        WHERE total_duration > 0
      ''');

      int fixed = 0;
      int alreadyCorrect = 0;

      for (final row in results) {
        final watchDuration = row['watch_duration'] as int;
        final totalDuration = row['total_duration'] as int;
        final currentCompleted = (row['completed'] as int) == 1;

        // Calculate completion percentage
        final completionPercentage = watchDuration / totalDuration;
        final shouldBeComplete = completionPercentage >= 0.9;

        // Update if completion status is incorrect
        if (shouldBeComplete != currentCompleted) {
          await db.update(
            'progress',
            {'completed': shouldBeComplete ? 1 : 0},
            where: 'id = ?',
            whereArgs: [row['id']],
          );

          fixed++;
          logger.debug('Fixed completion for video ${row['video_id']}: '
              '${(completionPercentage * 100).toInt()}% → ${shouldBeComplete ? "complete" : "incomplete"}');
        } else {
          alreadyCorrect++;
        }
      }

      logger.info('Completion status migration: $fixed fixed, $alreadyCorrect already correct');
    } catch (e, stackTrace) {
      logger.error('Error fixing completion status', e, stackTrace);
      rethrow;
    }
  }

  /// Fetch missing metadata from YouTube for progress entries with null titles
  static Future<void> _fetchMissingMetadata(Database db) async {
    logger.info('Fetching missing metadata from YouTube...');

    try {
      // Get all progress records with missing metadata (null title)
      final results = await db.rawQuery('''
        SELECT id, video_id, title, channel_name, thumbnail_url
        FROM progress
        WHERE title IS NULL
      ''');

      if (results.isEmpty) {
        logger.info('No missing metadata found - all progress entries have titles');
        return;
      }

      logger.info('Found ${results.length} progress entries with missing metadata');

      int fetched = 0;
      int failed = 0;
      int cached = 0;

      for (final row in results) {
        final videoId = row['video_id'] as String;

        try {
          // Fetch metadata from YouTube oEmbed API
          final metadata = await YouTubeMetadataService.fetchMetadata(videoId);

          if (metadata != null) {
            // Update progress table with metadata
            await db.update(
              'progress',
              {
                'title': metadata['title'],
                'channel_name': metadata['channelName'],
                'thumbnail_url': metadata['thumbnailUrl'],
              },
              where: 'id = ?',
              whereArgs: [row['id']],
            );

            // Also cache in video_metadata_cache table
            final now = DateTime.now().millisecondsSinceEpoch;
            await db.insert(
              'video_metadata_cache',
              {
                'video_id': videoId,
                'title': metadata['title'],
                'channel_name': metadata['channelName'],
                'thumbnail_url': metadata['thumbnailUrl'],
                'created_at': now,
                'updated_at': now,
                'source': 'youtube_oembed',
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );

            fetched++;
            cached++;
            logger.debug('Fetched metadata for $videoId: ${metadata['title']}');

            // Small delay to avoid rate limiting
            await Future.delayed(const Duration(milliseconds: 100));
          } else {
            failed++;
            logger.warning('Failed to fetch metadata for video $videoId');
          }
        } catch (e) {
          failed++;
          logger.warning('Error fetching metadata for $videoId: $e');
        }
      }

      logger.info('Metadata migration: $fetched fetched, $cached cached, $failed failed');
    } catch (e, stackTrace) {
      logger.error('Error fetching missing metadata', e, stackTrace);
      rethrow;
    }
  }

  /// Check if migration has been run
  static Future<bool> hasMigrated() async {
    try {
      final db = await DatabaseHelper().database;

      // Check app_state table for migration flag
      final List<Map<String, dynamic>> results = await db.query(
        AppStateTable.tableName,
        where: '${AppStateTable.columnKey} = ?',
        whereArgs: [AppStateTable.keyProgressMigrationV1],
      );

      return results.isNotEmpty && results.first[AppStateTable.columnValue] == '1';
    } catch (e) {
      logger.warning('Could not check migration status: $e');
      return false;
    }
  }

  /// Mark migration as completed
  static Future<void> markMigrationComplete() async {
    try {
      final db = await DatabaseHelper().database;

      await db.insert(
        AppStateTable.tableName,
        {
          AppStateTable.columnKey: AppStateTable.keyProgressMigrationV1,
          AppStateTable.columnValue: '1',
          AppStateTable.columnUpdatedAt: DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      logger.info('Migration marked as complete');
    } catch (e) {
      logger.warning('Could not mark migration as complete: $e');
    }
  }

  /// Run migration if not already run
  static Future<void> migrateIfNeeded() async {
    final migrated = await hasMigrated();

    if (!migrated) {
      logger.info('Running progress migration for the first time...');
      await migrate();
      await markMigrationComplete();
    } else {
      logger.debug('Progress migration already completed, skipping');
    }
  }
}
