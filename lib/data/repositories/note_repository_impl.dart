/// Note repository implementation
///
/// Refactored to use RepositoryErrorHandler mixin for centralized error handling.
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/data/datasources/local/database/dao/note_dao.dart';
import 'package:streamshaala/data/models/user/note_model.dart';
import 'package:streamshaala/data/repositories/base_repository.dart';
import 'package:streamshaala/domain/entities/user/note.dart';
import 'package:streamshaala/domain/repositories/note_repository.dart';

/// Implementation of NoteRepository using local database
///
/// Uses [RepositoryErrorHandler] mixin for standardized error handling,
/// reducing boilerplate and ensuring consistent exception-to-failure conversion.
class NoteRepositoryImpl with RepositoryErrorHandler implements NoteRepository {
  final NoteDao _noteDao;

  /// Optional profile ID for multi-profile support
  /// When set, all operations are scoped to this profile
  String? profileId;

  NoteRepositoryImpl(this._noteDao);

  @override
  Future<Either<Failure, Note>> addNote(Note note) {
    return executeWithErrorHandling(
      operationName: 'addNote',
      entityType: 'Note',
      entityId: note.id,
      operation: () async {
        logInfo('Adding note for video: ${note.videoId}', profileId: profileId);

        final model = NoteModel.fromEntity(note, profileId: profileId ?? '');
        await _noteDao.insert(model);

        logInfo('Note added successfully', profileId: profileId);
        return note;
      },
    );
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) {
    return executeWithErrorHandling(
      operationName: 'updateNote',
      entityType: 'Note',
      entityId: note.id,
      operation: () async {
        logInfo('Updating note: ${note.id}', profileId: profileId);

        final model = NoteModel.fromEntity(note, profileId: profileId ?? '');
        await _noteDao.update(model);

        logInfo('Note updated successfully', profileId: profileId);
        return note;
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteNote(String noteId) {
    return executeVoidWithErrorHandling(
      operationName: 'deleteNote',
      entityType: 'Note',
      entityId: noteId,
      operation: () async {
        logInfo('Deleting note: $noteId', profileId: profileId);
        await _noteDao.delete(noteId);
        logInfo('Note deleted successfully', profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesByVideoId(String videoId) {
    return executeWithErrorHandling(
      operationName: 'getNotesByVideoId',
      operation: () async {
        logInfo('Getting notes for video: $videoId', profileId: profileId);

        final models =
            await _noteDao.getAllByVideoId(videoId, profileId: profileId);
        final notes = models.map((model) => model.toEntity()).toList();

        logInfo('Retrieved ${notes.length} notes for video',
            profileId: profileId);
        return notes;
      },
    );
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() {
    return executeWithErrorHandling(
      operationName: 'getAllNotes',
      operation: () async {
        logInfo('Getting all notes', profileId: profileId);

        final models = await _noteDao.getAll(profileId: profileId);
        final notes = models.map((model) => model.toEntity()).toList();

        logInfo('Retrieved ${notes.length} notes', profileId: profileId);
        return notes;
      },
    );
  }

  @override
  Future<Either<Failure, Note?>> getNoteById(String noteId) {
    return executeWithErrorHandling(
      operationName: 'getNoteById',
      entityType: 'Note',
      entityId: noteId,
      operation: () async {
        logDebug('Getting note by ID: $noteId', profileId: profileId);

        final model = await _noteDao.getById(noteId);
        return model?.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, int>> getNotesCount() {
    return executeWithErrorHandling(
      operationName: 'getNotesCount',
      operation: () async {
        logDebug('Getting notes count', profileId: profileId);
        return await _noteDao.getCount(profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, int>> getNotesCountByVideoId(String videoId) {
    return executeWithErrorHandling(
      operationName: 'getNotesCountByVideoId',
      operation: () async {
        logDebug('Getting notes count for video: $videoId',
            profileId: profileId);
        return await _noteDao.getCountByVideoId(videoId, profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) {
    return executeWithErrorHandling(
      operationName: 'searchNotes',
      operation: () async {
        logInfo('Searching notes with query: $query', profileId: profileId);

        final models =
            await _noteDao.searchByContent(query, profileId: profileId);
        final notes = models.map((model) => model.toEntity()).toList();

        logInfo('Found ${notes.length} notes matching query',
            profileId: profileId);
        return notes;
      },
    );
  }

  @override
  Future<Either<Failure, List<Note>>> getRecentNotes(int limit) {
    return executeWithErrorHandling(
      operationName: 'getRecentNotes',
      operation: () async {
        logInfo('Getting $limit recent notes', profileId: profileId);

        final models = await _noteDao.getRecent(limit, profileId: profileId);
        final notes = models.map((model) => model.toEntity()).toList();

        logInfo('Retrieved ${notes.length} recent notes', profileId: profileId);
        return notes;
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteNotesByVideoId(String videoId) {
    return executeVoidWithErrorHandling(
      operationName: 'deleteNotesByVideoId',
      operation: () async {
        logWarning('Deleting all notes for video: $videoId',
            profileId: profileId);
        await _noteDao.deleteByVideoId(videoId, profileId: profileId);
        logInfo('Notes deleted successfully for video', profileId: profileId);
      },
    );
  }
}
