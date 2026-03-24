/// Note repository interface for managing video notes
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/note.dart';

/// Repository interface for note operations
abstract class NoteRepository {
  /// Add a new note
  Future<Either<Failure, Note>> addNote(Note note);

  /// Update an existing note
  Future<Either<Failure, Note>> updateNote(Note note);

  /// Delete a note by ID
  Future<Either<Failure, void>> deleteNote(String noteId);

  /// Get all notes for a specific video
  Future<Either<Failure, List<Note>>> getNotesByVideoId(String videoId);

  /// Get all notes sorted by updated date (newest first)
  Future<Either<Failure, List<Note>>> getAllNotes();

  /// Get a specific note by ID
  Future<Either<Failure, Note?>> getNoteById(String noteId);

  /// Get notes count
  Future<Either<Failure, int>> getNotesCount();

  /// Get notes count for a specific video
  Future<Either<Failure, int>> getNotesCountByVideoId(String videoId);

  /// Search notes by content
  Future<Either<Failure, List<Note>>> searchNotes(String query);

  /// Get recent notes (limit to specific count)
  Future<Either<Failure, List<Note>>> getRecentNotes(int limit);

  /// Delete all notes for a specific video
  Future<Either<Failure, void>> deleteNotesByVideoId(String videoId);
}
