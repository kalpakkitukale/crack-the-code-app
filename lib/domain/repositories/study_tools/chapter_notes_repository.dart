/// Chapter Notes repository interface
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_note.dart';

/// Repository interface for chapter notes operations
abstract class ChapterNotesRepository {
  /// Get all notes for a chapter (curated + personal for this profile)
  Future<Either<Failure, List<ChapterNote>>> getAllNotes(
    String chapterId,
    String profileId,
    String segment,
  );

  /// Get only curated notes (from JSON)
  /// Set [forceRefresh] to true to bypass cache and reload from JSON
  Future<Either<Failure, List<ChapterNote>>> getCuratedNotes(
    String chapterId,
    String subjectId,
    String segment, {
    bool forceRefresh = false,
  });

  /// Get only personal notes (from database)
  Future<Either<Failure, List<ChapterNote>>> getPersonalNotes(
    String chapterId,
    String profileId,
  );

  /// Save personal note (students only)
  Future<Either<Failure, ChapterNote>> savePersonalNote(ChapterNote note);

  /// Update personal note
  Future<Either<Failure, ChapterNote>> updatePersonalNote(ChapterNote note);

  /// Delete personal note
  Future<Either<Failure, void>> deletePersonalNote(String noteId);

  /// Get notes count (curated and personal separately)
  Future<Either<Failure, ({int curated, int personal})>> getNotesCount(
    String chapterId,
    String profileId,
    String subjectId,
    String segment,
  );

  /// Search notes
  Future<Either<Failure, List<ChapterNote>>> searchNotes(
    String query,
    String chapterId,
    String profileId,
    String segment,
  );
}
