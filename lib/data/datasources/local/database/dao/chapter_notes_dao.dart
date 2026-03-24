/// Data Access Object for Chapter Notes operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/core/utils/validation_helpers.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/study_tools/chapter_note_model.dart';

/// DAO for chapter_notes table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class ChapterNotesDao extends BaseDao {
  ChapterNotesDao(super.dbHelper);

  /// Insert or replace a chapter note
  Future<void> insert(ChapterNoteModel note) async {
    await executeWithErrorHandling(
      operationName: 'insert chapter note',
      operation: () async {
        await insertRow(
          table: ChapterNotesTable.tableName,
          values: note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Chapter note inserted: ${note.id}');
      },
    );
  }

  /// Insert multiple notes at once (for curated notes from JSON)
  Future<void> insertAll(List<ChapterNoteModel> notes) async {
    await executeWithErrorHandling(
      operationName: 'insert chapter notes',
      operation: () async {
        await batch(
          (batchHelper) {
            for (final note in notes) {
              batchHelper.insert(
                ChapterNotesTable.tableName,
                note.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          },
          noResult: true,
        );
        logger.debug('Inserted ${notes.length} chapter notes');
      },
    );
  }

  /// Get all notes for a chapter (curated + personal for this profile)
  Future<List<ChapterNoteModel>> getAllNotes(
    String chapterId,
    String profileId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get all chapter notes',
      operation: () async {
        // Get curated notes (no profile) + personal notes for this profile
        final maps = await queryRows(
          table: ChapterNotesTable.tableName,
          where:
              '${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnSegment} = ? AND (${ChapterNotesTable.columnNoteType} = ? OR ${ChapterNotesTable.columnProfileId} = ?)',
          whereArgs: [chapterId, segment, 'curated', profileId],
          orderBy:
              '${ChapterNotesTable.columnNoteType} ASC, ${ChapterNotesTable.columnIsPinned} DESC, ${ChapterNotesTable.columnCreatedAt} DESC',
        );

        logger.debug(
            'Retrieved ${maps.length} notes for chapter: $chapterId, profile: $profileId');
        return maps.map((map) => ChapterNoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Get only curated notes for a chapter
  Future<List<ChapterNoteModel>> getCuratedNotes(
    String chapterId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get curated notes',
      operation: () async {
        final maps = await queryRows(
          table: ChapterNotesTable.tableName,
          where:
              '${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnSegment} = ? AND ${ChapterNotesTable.columnNoteType} = ?',
          whereArgs: [chapterId, segment, 'curated'],
          orderBy:
              '${ChapterNotesTable.columnIsPinned} DESC, ${ChapterNotesTable.columnCreatedAt} DESC',
        );

        logger.debug(
            'Retrieved ${maps.length} curated notes for chapter: $chapterId');
        return maps.map((map) => ChapterNoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Get only personal notes for a chapter and profile
  Future<List<ChapterNoteModel>> getPersonalNotes(
    String chapterId,
    String profileId,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get personal notes',
      operation: () async {
        final maps = await queryRows(
          table: ChapterNotesTable.tableName,
          where:
              '${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnProfileId} = ? AND ${ChapterNotesTable.columnNoteType} = ?',
          whereArgs: [chapterId, profileId, 'personal'],
          orderBy:
              '${ChapterNotesTable.columnIsPinned} DESC, ${ChapterNotesTable.columnUpdatedAt} DESC',
        );

        logger.debug(
            'Retrieved ${maps.length} personal notes for chapter: $chapterId, profile: $profileId');
        return maps.map((map) => ChapterNoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Get note by ID
  Future<ChapterNoteModel?> getById(String noteId) async {
    return await executeWithErrorHandling(
      operationName: 'get chapter note by ID',
      operation: () async {
        final maps = await queryRows(
          table: ChapterNotesTable.tableName,
          where: '${ChapterNotesTable.columnId} = ?',
          whereArgs: [noteId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return ChapterNoteModel.fromMap(maps.first);
      },
    );
  }

  /// Update a note
  Future<void> update(ChapterNoteModel note) async {
    await executeWithErrorHandling(
      operationName: 'update chapter note',
      operation: () async {
        await updateRows(
          table: ChapterNotesTable.tableName,
          values: note.toMap(),
          where: '${ChapterNotesTable.columnId} = ?',
          whereArgs: [note.id],
        );
        logger.debug('Chapter note updated: ${note.id}');
      },
    );
  }

  /// Delete a note by ID
  Future<void> deleteById(String noteId) async {
    await executeWithErrorHandling(
      operationName: 'delete chapter note',
      operation: () async {
        await deleteRows(
          table: ChapterNotesTable.tableName,
          where: '${ChapterNotesTable.columnId} = ?',
          whereArgs: [noteId],
        );
        logger.debug('Chapter note deleted: $noteId');
      },
    );
  }

  /// Delete all personal notes for a chapter and profile
  Future<void> deletePersonalNotes(String chapterId, String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete personal notes',
      operation: () async {
        await deleteRows(
          table: ChapterNotesTable.tableName,
          where:
              '${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnProfileId} = ? AND ${ChapterNotesTable.columnNoteType} = ?',
          whereArgs: [chapterId, profileId, 'personal'],
        );
        logger.debug(
            'Personal notes deleted for chapter: $chapterId, profile: $profileId');
      },
    );
  }

  /// Delete all curated notes for a chapter (for cache refresh)
  Future<void> deleteCuratedNotes(String chapterId) async {
    await executeWithErrorHandling(
      operationName: 'delete curated notes',
      operation: () async {
        await deleteRows(
          table: ChapterNotesTable.tableName,
          where:
              '${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnNoteType} = ?',
          whereArgs: [chapterId, 'curated'],
        );
        logger.debug('Curated notes deleted for chapter: $chapterId');
      },
    );
  }

  /// Get notes count for a chapter
  Future<({int curated, int personal})> getNotesCount(
    String chapterId,
    String profileId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'get notes count',
      operation: () async {
        // Count curated notes
        final curatedQuery =
            'SELECT COUNT(*) FROM ${ChapterNotesTable.tableName} WHERE ${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnSegment} = ? AND ${ChapterNotesTable.columnNoteType} = ?';
        final curatedCount =
            await firstIntValue(curatedQuery, [chapterId, segment, 'curated']);

        // Count personal notes
        final personalQuery =
            'SELECT COUNT(*) FROM ${ChapterNotesTable.tableName} WHERE ${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnProfileId} = ? AND ${ChapterNotesTable.columnNoteType} = ?';
        final personalCount =
            await firstIntValue(personalQuery, [chapterId, profileId, 'personal']);

        return (curated: curatedCount ?? 0, personal: personalCount ?? 0);
      },
    );
  }

  /// Search notes
  Future<List<ChapterNoteModel>> searchNotes(
    String query,
    String chapterId,
    String profileId,
    String segment,
  ) async {
    return await executeWithErrorHandling(
      operationName: 'search notes',
      operation: () async {
        // Sanitize search query to prevent LIKE injection
        final sanitizedQuery = SqlSanitizer.sanitizeSearchQuery(query);

        final maps = await queryRows(
          table: ChapterNotesTable.tableName,
          where:
              "${ChapterNotesTable.columnChapterId} = ? AND ${ChapterNotesTable.columnSegment} = ? AND (${ChapterNotesTable.columnNoteType} = ? OR ${ChapterNotesTable.columnProfileId} = ?) AND (${ChapterNotesTable.columnTitle} LIKE ? ESCAPE '\\' OR ${ChapterNotesTable.columnContent} LIKE ? ESCAPE '\\')",
          whereArgs: [
            chapterId,
            segment,
            'curated',
            profileId,
            sanitizedQuery,
            sanitizedQuery,
          ],
          orderBy:
              '${ChapterNotesTable.columnNoteType} ASC, ${ChapterNotesTable.columnIsPinned} DESC',
        );

        logger.debug('Found ${maps.length} notes matching "$query"');
        return maps.map((map) => ChapterNoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete all notes
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all chapter notes',
      operation: () async {
        await deleteRows(table: ChapterNotesTable.tableName);
        logger.debug('All chapter notes deleted');
      },
    );
  }
}
