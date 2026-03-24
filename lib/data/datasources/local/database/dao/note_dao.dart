/// Data Access Object for Note operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/core/utils/validation_helpers.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/user/note_model.dart';

/// DAO for note table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class NoteDao extends BaseDao {
  NoteDao(super.dbHelper);

  /// Insert a note
  Future<void> insert(NoteModel note) async {
    await executeWithErrorHandling(
      operationName: 'insert note',
      operation: () async {
        await insertRow(
          table: NotesTable.tableName,
          values: note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Note inserted: ${note.id}');
      },
    );
  }

  /// Update a note
  Future<void> update(NoteModel note) async {
    await executeWithErrorHandling(
      operationName: 'update note',
      operation: () async {
        final count = await updateRows(
          table: NotesTable.tableName,
          values: note.toMap(),
          where: '${NotesTable.columnId} = ?',
          whereArgs: [note.id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Note not found',
            entityType: 'Note',
            entityId: note.id,
          );
        }

        logger.debug('Note updated: ${note.id}');
      },
    );
  }

  /// Delete a note by ID
  Future<void> delete(String noteId) async {
    await executeWithErrorHandling(
      operationName: 'delete note',
      operation: () async {
        final count = await deleteRows(
          table: NotesTable.tableName,
          where: '${NotesTable.columnId} = ?',
          whereArgs: [noteId],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Note not found',
            entityType: 'Note',
            entityId: noteId,
          );
        }

        logger.debug('Note deleted: $noteId');
      },
    );
  }

  /// Get note by ID
  Future<NoteModel?> getById(String noteId) async {
    return await executeWithErrorHandling(
      operationName: 'get note by ID',
      operation: () async {
        final maps = await queryRows(
          table: NotesTable.tableName,
          where: '${NotesTable.columnId} = ?',
          whereArgs: [noteId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return NoteModel.fromMap(maps.first);
      },
    );
  }

  /// Get all notes for a specific video
  Future<List<NoteModel>> getAllByVideoId(String videoId,
      {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get notes by video ID',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${NotesTable.columnVideoId} = ? AND ${NotesTable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${NotesTable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        final maps = await queryRows(
          table: NotesTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: '${NotesTable.columnTimestampSeconds} ASC',
        );

        logger.debug('Retrieved ${maps.length} notes for video: $videoId');
        return maps.map((map) => NoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Get all notes sorted by updated date (newest first)
  Future<List<NoteModel>> getAll({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get all notes',
      operation: () async {
        final maps = await queryRows(
          table: NotesTable.tableName,
          where: profileId != null ? '${NotesTable.columnProfileId} = ?' : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${NotesTable.columnUpdatedAt} DESC',
        );

        logger.debug('Retrieved ${maps.length} notes');
        return maps.map((map) => NoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Search notes by content
  Future<List<NoteModel>> searchByContent(String query,
      {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'search notes',
      operation: () async {
        // Sanitize search query to prevent LIKE injection
        final sanitizedQuery = SqlSanitizer.sanitizeSearchQuery(query);

        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              "${NotesTable.columnContent} LIKE ? ESCAPE '\\' AND ${NotesTable.columnProfileId} = ?";
          whereArgs = [sanitizedQuery, profileId];
        } else {
          whereClause = "${NotesTable.columnContent} LIKE ? ESCAPE '\\'";
          whereArgs = [sanitizedQuery];
        }

        final maps = await queryRows(
          table: NotesTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: '${NotesTable.columnUpdatedAt} DESC',
        );

        logger.debug('Found ${maps.length} notes matching "$query"');
        return maps.map((map) => NoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Get recent notes (limit to specific count)
  Future<List<NoteModel>> getRecent(int limit, {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get recent notes',
      operation: () async {
        final maps = await queryRows(
          table: NotesTable.tableName,
          where: profileId != null ? '${NotesTable.columnProfileId} = ?' : null,
          whereArgs: profileId != null ? [profileId] : null,
          orderBy: '${NotesTable.columnUpdatedAt} DESC',
          limit: limit,
        );

        logger.debug('Retrieved ${maps.length} recent notes');
        return maps.map((map) => NoteModel.fromMap(map)).toList();
      },
    );
  }

  /// Get notes count
  Future<int> getCount({String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get notes count',
      operation: () async {
        final String query;
        final List<dynamic>? queryArgs;

        if (profileId != null) {
          query =
              'SELECT COUNT(*) FROM ${NotesTable.tableName} WHERE ${NotesTable.columnProfileId} = ?';
          queryArgs = [profileId];
        } else {
          query = 'SELECT COUNT(*) FROM ${NotesTable.tableName}';
          queryArgs = null;
        }

        return await firstIntValue(query, queryArgs) ?? 0;
      },
    );
  }

  /// Get notes count for a specific video
  Future<int> getCountByVideoId(String videoId, {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get notes count by video ID',
      operation: () async {
        final String query;
        final List<dynamic> queryArgs;

        if (profileId != null) {
          query =
              'SELECT COUNT(*) FROM ${NotesTable.tableName} WHERE ${NotesTable.columnVideoId} = ? AND ${NotesTable.columnProfileId} = ?';
          queryArgs = [videoId, profileId];
        } else {
          query =
              'SELECT COUNT(*) FROM ${NotesTable.tableName} WHERE ${NotesTable.columnVideoId} = ?';
          queryArgs = [videoId];
        }

        return await firstIntValue(query, queryArgs) ?? 0;
      },
    );
  }

  /// Delete all notes for a specific video
  Future<void> deleteByVideoId(String videoId, {String? profileId}) async {
    await executeWithErrorHandling(
      operationName: 'delete notes by video ID',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${NotesTable.columnVideoId} = ? AND ${NotesTable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${NotesTable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        await deleteRows(
          table: NotesTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
        );

        logger.debug('Notes deleted for video: $videoId');
      },
    );
  }

  /// Delete all notes for a specific profile
  Future<void> deleteAllForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete notes for profile',
      operation: () async {
        await deleteRows(
          table: NotesTable.tableName,
          where: '${NotesTable.columnProfileId} = ?',
          whereArgs: [profileId],
        );
        logger.debug('All notes deleted for profile: $profileId');
      },
    );
  }

  /// Delete all notes
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all notes',
      operation: () async {
        await deleteRows(table: NotesTable.tableName);
        logger.debug('All notes deleted');
      },
    );
  }
}
