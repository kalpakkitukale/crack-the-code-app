/// Chapter Notes repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/cache_manager.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/chapter_notes_dao.dart';
import 'package:streamshaala/data/models/study_tools/chapter_note_model.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_note.dart';
import 'package:streamshaala/domain/repositories/study_tools/chapter_notes_repository.dart';

/// Implementation of ChapterNotesRepository
/// - Curated notes: JSON-first loading with database caching
/// - Personal notes: Database-only (profile-specific)
class ChapterNotesRepositoryImpl implements ChapterNotesRepository {
  final ChapterNotesDao _notesDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  ChapterNotesRepositoryImpl(this._notesDao, this._jsonDataSource);

  @override
  Future<Either<Failure, List<ChapterNote>>> getAllNotes(
    String chapterId,
    String profileId,
    String segment,
  ) async {
    try {
      logger.info(
          'Getting all notes for chapter: $chapterId, profile: $profileId');

      // Get all notes from database (curated + personal for this profile)
      final cached =
          await _notesDao.getAllNotes(chapterId, profileId, segment);

      final notes = cached.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${notes.length} total notes');
      return Right(notes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting notes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get notes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting notes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ChapterNote>>> getCuratedNotes(
    String chapterId,
    String subjectId,
    String segment, {
    bool forceRefresh = false,
  }) async {
    try {
      logger.info('Getting curated notes for chapter: $chapterId');

      final cacheKey = CacheManager.curatedNotesKey(chapterId, segment);

      // 1. Check database cache first (if not force refresh)
      if (!forceRefresh) {
        final isExpired = await CacheManager.isCacheExpired(cacheKey);
        final cached = await _notesDao.getCuratedNotes(chapterId, segment);

        if (cached.isNotEmpty && !isExpired) {
          logger.debug('Curated notes found in valid cache: ${cached.length}');
          return Right(cached.map((model) => model.toEntity()).toList());
        }

        // Cache exists but expired - delete and reload
        if (cached.isNotEmpty && isExpired) {
          logger.info('Cache expired, refreshing curated notes');
          await _notesDao.deleteCuratedNotes(chapterId);
        }
      } else {
        // Force refresh - clear existing cache
        logger.info('Force refresh requested, clearing cache');
        await _notesDao.deleteCuratedNotes(chapterId);
        await CacheManager.invalidateCache(cacheKey);
      }

      // 2. Load from JSON
      final jsonModels = await _jsonDataSource.loadCuratedNotes(
        subjectId: subjectId,
        chapterId: chapterId,
        segment: segment,
      );

      if (jsonModels.isNotEmpty) {
        // Cache to database
        await _notesDao.insertAll(jsonModels);
        await CacheManager.markCacheUpdated(cacheKey);
        logger.info(
            'Curated notes loaded from JSON and cached: ${jsonModels.length}');
        return Right(jsonModels.map((model) => model.toEntity()).toList());
      }

      logger.info('No curated notes found');
      return const Right([]);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting curated notes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get curated notes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting curated notes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ChapterNote>>> getPersonalNotes(
    String chapterId,
    String profileId,
  ) async {
    try {
      logger.info(
          'Getting personal notes for chapter: $chapterId, profile: $profileId');

      final models = await _notesDao.getPersonalNotes(chapterId, profileId);
      final notes = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${notes.length} personal notes');
      return Right(notes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting personal notes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get personal notes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting personal notes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ChapterNote>> savePersonalNote(
    ChapterNote note,
  ) async {
    try {
      logger.info('Saving personal note: ${note.id}');

      // Ensure it's a personal note
      if (note.isCurated) {
        return Left(ValidationFailure(
          message: 'Cannot save curated notes as personal',
          details: 'Note type must be personal',
        ));
      }

      final model = ChapterNoteModel.fromEntity(note);
      await _notesDao.insert(model);

      logger.info('Personal note saved successfully');
      return Right(note);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving personal note', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save personal note',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving personal note', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ChapterNote>> updatePersonalNote(
    ChapterNote note,
  ) async {
    try {
      logger.info('Updating personal note: ${note.id}');

      // Verify it's a personal note
      final existing = await _notesDao.getById(note.id);
      if (existing == null) {
        return Left(NotFoundFailure(
          message: 'Note not found',
          entityType: 'ChapterNote',
          entityId: note.id,
          details: 'Note with ID ${note.id} does not exist',
        ));
      }

      if (existing.noteType == 'curated') {
        return Left(ValidationFailure(
          message: 'Cannot update curated notes',
          details: 'Curated notes are read-only',
        ));
      }

      // Update with new timestamp
      final updatedNote = note.copyWith(
        updatedAt: DateTime.now(),
      );

      final model = ChapterNoteModel.fromEntity(updatedNote);
      await _notesDao.update(model);

      logger.info('Personal note updated successfully');
      return Right(updatedNote);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error updating personal note', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to update personal note',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error updating personal note', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deletePersonalNote(String noteId) async {
    try {
      logger.info('Deleting personal note: $noteId');

      // Verify it's a personal note
      final existing = await _notesDao.getById(noteId);
      if (existing == null) {
        return Left(NotFoundFailure(
          message: 'Note not found',
          entityType: 'ChapterNote',
          entityId: noteId,
          details: 'Note with ID $noteId does not exist',
        ));
      }

      if (existing.noteType == 'curated') {
        return Left(ValidationFailure(
          message: 'Cannot delete curated notes',
          details: 'Curated notes are read-only',
        ));
      }

      await _notesDao.deleteById(noteId);

      logger.info('Personal note deleted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting personal note', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete personal note',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting personal note', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ({int curated, int personal})>> getNotesCount(
    String chapterId,
    String profileId,
    String subjectId,
    String segment,
  ) async {
    try {
      logger.debug('Getting notes count for chapter: $chapterId');

      // First ensure curated notes are loaded
      await getCuratedNotes(chapterId, subjectId, segment);

      final counts =
          await _notesDao.getNotesCount(chapterId, profileId, segment);

      return Right(counts);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting notes count', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get notes count',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting notes count', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ChapterNote>>> searchNotes(
    String query,
    String chapterId,
    String profileId,
    String segment,
  ) async {
    try {
      logger.info('Searching notes: $query in chapter: $chapterId');

      final models =
          await _notesDao.searchNotes(query, chapterId, profileId, segment);
      final notes = models.map((model) => model.toEntity()).toList();

      logger.info('Found ${notes.length} matching notes');
      return Right(notes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error searching notes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to search notes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error searching notes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
