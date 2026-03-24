/// User Sync Repository Implementation
/// Implements user data synchronization to Google Drive
library;

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/services/connectivity_service.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/database_helper.dart';
import 'package:crack_the_code/data/datasources/remote/drive_sync_datasource.dart';
import 'package:crack_the_code/data/models/sync/sync_operation.dart';
import 'package:crack_the_code/data/models/sync/sync_state.dart';
import 'package:crack_the_code/domain/repositories/sync/user_sync_repository.dart';

/// Implementation of user sync repository
class UserSyncRepositoryImpl implements UserSyncRepository {
  final DriveSyncDatasource _datasource;
  final ConnectivityService _connectivityService;
  final DatabaseHelper _databaseHelper;

  AppSyncState _syncState = AppSyncState.initial();
  final _syncStateController = StreamController<AppSyncState>.broadcast();
  final SyncQueue _pendingOperations = SyncQueue();

  UserSyncRepositoryImpl({
    DriveSyncDatasource? datasource,
    ConnectivityService? connectivityService,
    DatabaseHelper? databaseHelper,
  })  : _datasource = datasource ?? DriveSyncDatasource(),
        _connectivityService = connectivityService ?? connectivityService!,
        _databaseHelper = databaseHelper ?? DatabaseHelper();

  @override
  bool get isSyncAvailable => _datasource.isReady;

  @override
  AppSyncState get syncState => _syncState;

  @override
  Stream<AppSyncState> get syncStateStream => _syncStateController.stream;

  @override
  int get pendingOperationsCount => _pendingOperations.length;

  void _updateSyncState(AppSyncState newState) {
    _syncState = newState;
    _syncStateController.add(_syncState);
  }

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      final success = await _datasource.initialize();
      if (!success) {
        return const Left(UserSyncFailure('Failed to initialize sync'));
      }

      // Load sync state from Drive
      final syncStateData = await _datasource.readSyncState();
      if (syncStateData != null) {
        _syncState = AppSyncState.fromJson(syncStateData);
        _syncStateController.add(_syncState);
      }

      logger.info('User sync repository initialized');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to initialize user sync: $e');
      return Left(UserSyncFailure('Failed to initialize sync: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> performFullSync() async {
    if (!_datasource.isReady) {
      return const Left(UserSyncFailure('Sync not available'));
    }

    if (!_connectivityService.isOnline) {
      return const Left(UserSyncFailure('No network connection'));
    }

    try {
      // Update sync state
      _updateSyncState(_syncState.copyWith(
        userData: _syncState.userData.startSync(),
      ));

      // Download and merge remote data
      final downloadResult = await downloadAndMerge();
      if (downloadResult.isLeft()) {
        _updateSyncState(_syncState.copyWith(
          userData: _syncState.userData.failSync('Download failed'),
        ));
        return downloadResult;
      }

      // Upload local changes
      final uploadResult = await uploadChanges();
      if (uploadResult.isLeft()) {
        _updateSyncState(_syncState.copyWith(
          userData: _syncState.userData.failSync('Upload failed'),
        ));
        return uploadResult;
      }

      // Update sync state
      _updateSyncState(_syncState.copyWith(
        userData: _syncState.userData.completeSync(),
        lastFullSync: DateTime.now(),
      ));

      // Save sync state to Drive
      await _datasource.writeSyncState(_syncState.toJson());

      logger.info('Full sync completed');
      return const Right(null);
    } catch (e) {
      logger.error('Full sync failed: $e');
      _updateSyncState(_syncState.copyWith(
        userData: _syncState.userData.failSync(e.toString()),
      ));
      return Left(UserSyncFailure('Full sync failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncDataType(String dataType) async {
    switch (dataType) {
      case 'progress':
        return syncProgress();
      case 'bookmarks':
        return syncBookmarks();
      case 'notes':
        return syncNotes();
      case 'chapter_notes':
        return syncChapterNotes();
      case 'collections':
        return syncCollections();
      case 'quiz_data':
        return syncQuizData();
      case 'flashcard_progress':
        return syncFlashcardProgress();
      case 'learning_progress':
        return syncLearningProgress();
      case 'gamification':
        return syncGamification();
      case 'preferences':
        return syncPreferences();
      default:
        return Left(UserSyncFailure('Unknown data type: $dataType'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadChanges() async {
    try {
      // Sync all data types
      await syncProgress();
      await syncBookmarks();
      await syncNotes();
      await syncChapterNotes();
      await syncCollections();
      await syncQuizData();
      await syncFlashcardProgress();
      await syncLearningProgress();
      await syncGamification();
      await syncPreferences();

      // Process any pending individual operations
      final successCount = await _datasource.processPendingOperations();
      logger.info('Uploaded changes, processed $successCount pending operations');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to upload changes: $e');
      return Left(UserSyncFailure('Failed to upload changes: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> downloadAndMerge() async {
    try {
      final remoteData = await _datasource.readAllData();
      logger.info('Downloaded ${remoteData.length} data files from Drive');

      final db = await _databaseHelper.database;

      // Merge progress data
      if (remoteData.containsKey(DriveFileNames.progress)) {
        await _mergeProgress(db, remoteData[DriveFileNames.progress]!);
      }

      // Merge bookmarks
      if (remoteData.containsKey(DriveFileNames.bookmarks)) {
        await _mergeBookmarks(db, remoteData[DriveFileNames.bookmarks]!);
      }

      // Merge notes
      if (remoteData.containsKey(DriveFileNames.notes)) {
        await _mergeNotes(db, remoteData[DriveFileNames.notes]!);
      }

      // Merge chapter notes
      if (remoteData.containsKey(DriveFileNames.chapterNotes)) {
        await _mergeChapterNotes(db, remoteData[DriveFileNames.chapterNotes]!);
      }

      // Merge collections
      if (remoteData.containsKey(DriveFileNames.collections)) {
        await _mergeCollections(db, remoteData[DriveFileNames.collections]!);
      }

      // Merge quiz data
      if (remoteData.containsKey(DriveFileNames.quizData)) {
        await _mergeQuizData(db, remoteData[DriveFileNames.quizData]!);
      }

      // Merge flashcard progress
      if (remoteData.containsKey(DriveFileNames.flashcardProgress)) {
        await _mergeFlashcardProgress(db, remoteData[DriveFileNames.flashcardProgress]!);
      }

      // Merge learning progress
      if (remoteData.containsKey(DriveFileNames.learningProgress)) {
        await _mergeLearningProgress(db, remoteData[DriveFileNames.learningProgress]!);
      }

      // Merge gamification
      if (remoteData.containsKey(DriveFileNames.gamification)) {
        await _mergeGamification(db, remoteData[DriveFileNames.gamification]!);
      }

      // Merge preferences
      if (remoteData.containsKey(DriveFileNames.preferences)) {
        await _mergePreferences(db, remoteData[DriveFileNames.preferences]!);
      }

      logger.info('Merged remote data successfully');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to download and merge: $e');
      return Left(UserSyncFailure('Failed to download and merge: $e'));
    }
  }

  // ==================== Merge Helpers ====================

  Future<void> _mergeProgress(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} progress items from remote');

    for (final remoteItem in remoteItems) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, ProgressTable.tableName, id);
      final resolution = await resolveConflict('progress', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, ProgressTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeBookmarks(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} bookmarks from remote');

    for (final remoteItem in remoteItems) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, BookmarksTable.tableName, id);
      final resolution = await resolveConflict('bookmarks', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, BookmarksTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeNotes(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} notes from remote');

    for (final remoteItem in remoteItems) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, NotesTable.tableName, id);
      final resolution = await resolveConflict('notes', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, NotesTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeChapterNotes(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} chapter notes from remote');

    for (final remoteItem in remoteItems) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, ChapterNotesTable.tableName, id);
      final resolution = await resolveConflict('chapter_notes', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, ChapterNotesTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeCollections(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} collections from remote');

    for (final remoteItem in remoteItems) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, CollectionsTable.tableName, id);
      final resolution = await resolveConflict('collections', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, CollectionsTable.tableName, remoteItem);
      }
    }

    // Also merge collection videos
    final remoteVideos = remoteData['videos'] as List? ?? [];
    for (final remoteVideo in remoteVideos) {
      final id = remoteVideo['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, CollectionVideosTable.tableName, id);
      final resolution = await resolveConflict('collection_videos', localItem ?? {}, remoteVideo as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, CollectionVideosTable.tableName, remoteVideo);
      }
    }
  }

  Future<void> _mergeQuizData(dynamic db, Map<String, dynamic> remoteData) async {
    // Merge quiz attempts
    final remoteAttempts = remoteData['attempts'] as List? ?? [];
    logger.info('Merging ${remoteAttempts.length} quiz attempts from remote');

    for (final remoteItem in remoteAttempts) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, QuizAttemptsTable.tableName, id);
      final resolution = await resolveConflict('quiz_attempts', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, QuizAttemptsTable.tableName, remoteItem);
      }
    }

    // Merge quiz sessions
    final remoteSessions = remoteData['sessions'] as List? ?? [];
    for (final remoteItem in remoteSessions) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, QuizSessionsTable.tableName, id);
      final resolution = await resolveConflict('quiz_sessions', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, QuizSessionsTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeFlashcardProgress(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} flashcard progress items from remote');

    for (final remoteItem in remoteItems) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, FlashcardProgressTable.tableName, id);
      final resolution = await resolveConflict('flashcard_progress', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, FlashcardProgressTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeLearningProgress(dynamic db, Map<String, dynamic> remoteData) async {
    // Merge concept mastery
    final remoteConcepts = remoteData['concept_mastery'] as List? ?? [];
    logger.info('Merging ${remoteConcepts.length} concept mastery items from remote');

    for (final remoteItem in remoteConcepts) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, ConceptMasteryTable.tableName, id);
      final resolution = await resolveConflict('concept_mastery', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, ConceptMasteryTable.tableName, remoteItem);
      }
    }

    // Merge spaced repetition
    final remoteSpacedRep = remoteData['spaced_repetition'] as List? ?? [];
    for (final remoteItem in remoteSpacedRep) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, SpacedRepetitionTable.tableName, id);
      final resolution = await resolveConflict('spaced_repetition', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, SpacedRepetitionTable.tableName, remoteItem);
      }
    }

    // Merge learning paths
    final remotePaths = remoteData['learning_paths'] as List? ?? [];
    for (final remoteItem in remotePaths) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, LearningPathsTable.tableName, id);
      final resolution = await resolveConflict('learning_paths', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, LearningPathsTable.tableName, remoteItem);
      }
    }
  }

  Future<void> _mergeGamification(dynamic db, Map<String, dynamic> remoteData) async {
    // Merge gamification profile
    final remoteProfile = remoteData['profile'] as Map<String, dynamic>?;
    if (remoteProfile != null) {
      final id = remoteProfile['id'] as String?;
      if (id != null) {
        final localItem = await _queryOne(db, GamificationTable.tableName, id);
        final resolution = await resolveConflict('gamification', localItem ?? {}, remoteProfile);

        if (resolution == ConflictResolution.keepRemote) {
          await _upsert(db, GamificationTable.tableName, remoteProfile);
        }
      }
    }

    // Merge badges
    final remoteBadges = remoteData['badges'] as List? ?? [];
    logger.info('Merging ${remoteBadges.length} badges from remote');

    for (final remoteItem in remoteBadges) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, BadgesTable.tableName, id);
      final resolution = await resolveConflict('badges', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsert(db, BadgesTable.tableName, remoteItem);
      }
    }

    // Merge XP events
    final remoteXpEvents = remoteData['xp_events'] as List? ?? [];
    for (final remoteItem in remoteXpEvents) {
      final id = remoteItem['id'] as String?;
      if (id == null) continue;

      final localItem = await _queryOne(db, XpEventsTable.tableName, id);
      // XP events are append-only, so we only add new ones
      if (localItem == null) {
        await _upsert(db, XpEventsTable.tableName, remoteItem as Map<String, dynamic>);
      }
    }
  }

  Future<void> _mergePreferences(dynamic db, Map<String, dynamic> remoteData) async {
    final remoteItems = remoteData['items'] as List? ?? [];
    logger.info('Merging ${remoteItems.length} preferences from remote');

    for (final remoteItem in remoteItems) {
      final key = remoteItem['key'] as String?;
      if (key == null) continue;

      // Preferences are keyed by 'key' column, not 'id'
      final localItem = await _queryOneByKey(db, PreferencesTable.tableName, PreferencesTable.columnKey, key);
      final resolution = await resolveConflict('preferences', localItem ?? {}, remoteItem as Map<String, dynamic>);

      if (resolution == ConflictResolution.keepRemote) {
        await _upsertByKey(db, PreferencesTable.tableName, PreferencesTable.columnKey, key, remoteItem);
      }
    }
  }

  // ==================== Database Helpers ====================

  Future<Map<String, dynamic>?> _queryOne(dynamic db, String tableName, String id) async {
    final List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> _queryOneByKey(dynamic db, String tableName, String keyColumn, String keyValue) async {
    final List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: '$keyColumn = ?',
      whereArgs: [keyValue],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> _upsert(dynamic db, String tableName, Map<String, dynamic> data) async {
    try {
      await db.insert(
        tableName,
        data,
        conflictAlgorithm: 5, // ConflictAlgorithm.replace
      );
    } catch (e) {
      logger.error('Failed to upsert into $tableName: $e');
    }
  }

  Future<void> _upsertByKey(dynamic db, String tableName, String keyColumn, String keyValue, Map<String, dynamic> data) async {
    try {
      // Check if exists
      final existing = await _queryOneByKey(db, tableName, keyColumn, keyValue);
      if (existing != null) {
        await db.update(
          tableName,
          data,
          where: '$keyColumn = ?',
          whereArgs: [keyValue],
        );
      } else {
        await db.insert(tableName, data);
      }
    } catch (e) {
      logger.error('Failed to upsert by key into $tableName: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _queryAll(dynamic db, String tableName) async {
    return await db.query(tableName);
  }

  // ==================== Progress ====================

  @override
  Future<Either<Failure, void>> syncProgress() async {
    try {
      final db = await _databaseHelper.database;
      final rows = await _queryAll(db, ProgressTable.tableName);

      final progressData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': rows,
      };

      final success = await _datasource.writeProgress(progressData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write progress to Drive'));
      }

      logger.info('Synced ${rows.length} progress items to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync progress: $e');
      return Left(UserSyncFailure('Failed to sync progress: $e'));
    }
  }

  @override
  void queueProgressUpdate(Map<String, dynamic> progress) {
    _pendingOperations.add(SyncOperation(
      id: 'progress_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.update,
      entityType: 'progress',
      entityId: progress['videoId'] as String? ?? 'all',
      payload: progress,
      createdAt: DateTime.now(),
    ));
  }

  // ==================== Bookmarks ====================

  @override
  Future<Either<Failure, void>> syncBookmarks() async {
    try {
      final db = await _databaseHelper.database;
      final rows = await _queryAll(db, BookmarksTable.tableName);

      final bookmarksData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': rows,
      };

      final success = await _datasource.writeBookmarks(bookmarksData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write bookmarks to Drive'));
      }

      logger.info('Synced ${rows.length} bookmarks to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync bookmarks: $e');
      return Left(UserSyncFailure('Failed to sync bookmarks: $e'));
    }
  }

  @override
  void queueBookmarkUpdate(Map<String, dynamic> bookmark) {
    _pendingOperations.add(SyncOperation(
      id: 'bookmark_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.update,
      entityType: 'bookmarks',
      entityId: bookmark['videoId'] as String? ?? 'all',
      payload: bookmark,
      createdAt: DateTime.now(),
    ));
  }

  // ==================== Notes ====================

  @override
  Future<Either<Failure, void>> syncNotes() async {
    try {
      final db = await _databaseHelper.database;
      final rows = await _queryAll(db, NotesTable.tableName);

      final notesData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': rows,
      };

      final success = await _datasource.writeNotes(notesData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write notes to Drive'));
      }

      logger.info('Synced ${rows.length} notes to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync notes: $e');
      return Left(UserSyncFailure('Failed to sync notes: $e'));
    }
  }

  @override
  void queueNoteUpdate(Map<String, dynamic> note) {
    _pendingOperations.add(SyncOperation(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.update,
      entityType: 'notes',
      entityId: note['id'] as String? ?? 'all',
      payload: note,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Either<Failure, void>> syncChapterNotes() async {
    try {
      final db = await _databaseHelper.database;
      final rows = await _queryAll(db, ChapterNotesTable.tableName);

      final chapterNotesData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': rows,
      };

      final success = await _datasource.writeChapterNotes(chapterNotesData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write chapter notes to Drive'));
      }

      logger.info('Synced ${rows.length} chapter notes to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync chapter notes: $e');
      return Left(UserSyncFailure('Failed to sync chapter notes: $e'));
    }
  }

  @override
  void queueChapterNoteUpdate(Map<String, dynamic> note) {
    _pendingOperations.add(SyncOperation(
      id: 'chapter_note_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.update,
      entityType: 'chapter_notes',
      entityId: note['id'] as String? ?? 'all',
      payload: note,
      createdAt: DateTime.now(),
    ));
  }

  // ==================== Collections ====================

  @override
  Future<Either<Failure, void>> syncCollections() async {
    try {
      final db = await _databaseHelper.database;
      final collections = await _queryAll(db, CollectionsTable.tableName);
      final collectionVideos = await _queryAll(db, CollectionVideosTable.tableName);

      final collectionsData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': collections,
        'videos': collectionVideos,
      };

      final success = await _datasource.writeCollections(collectionsData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write collections to Drive'));
      }

      logger.info('Synced ${collections.length} collections and ${collectionVideos.length} videos to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync collections: $e');
      return Left(UserSyncFailure('Failed to sync collections: $e'));
    }
  }

  @override
  void queueCollectionUpdate(Map<String, dynamic> collection) {
    _pendingOperations.add(SyncOperation(
      id: 'collection_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.update,
      entityType: 'collections',
      entityId: collection['id'] as String? ?? 'all',
      payload: collection,
      createdAt: DateTime.now(),
    ));
  }

  // ==================== Quiz & Learning ====================

  @override
  Future<Either<Failure, void>> syncQuizData() async {
    try {
      final db = await _databaseHelper.database;
      final attempts = await _queryAll(db, QuizAttemptsTable.tableName);
      final sessions = await _queryAll(db, QuizSessionsTable.tableName);

      final quizData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'attempts': attempts,
        'sessions': sessions,
      };

      final success = await _datasource.writeQuizData(quizData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write quiz data to Drive'));
      }

      logger.info('Synced ${attempts.length} quiz attempts and ${sessions.length} sessions to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync quiz data: $e');
      return Left(UserSyncFailure('Failed to sync quiz data: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncFlashcardProgress() async {
    try {
      final db = await _databaseHelper.database;
      final rows = await _queryAll(db, FlashcardProgressTable.tableName);

      final flashcardData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': rows,
      };

      final success = await _datasource.writeFlashcardProgress(flashcardData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write flashcard progress to Drive'));
      }

      logger.info('Synced ${rows.length} flashcard progress items to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync flashcard progress: $e');
      return Left(UserSyncFailure('Failed to sync flashcard progress: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncLearningProgress() async {
    try {
      final db = await _databaseHelper.database;
      final conceptMastery = await _queryAll(db, ConceptMasteryTable.tableName);
      final spacedRepetition = await _queryAll(db, SpacedRepetitionTable.tableName);
      final learningPaths = await _queryAll(db, LearningPathsTable.tableName);

      final learningData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'concept_mastery': conceptMastery,
        'spaced_repetition': spacedRepetition,
        'learning_paths': learningPaths,
      };

      final success = await _datasource.writeLearningProgress(learningData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write learning progress to Drive'));
      }

      logger.info('Synced ${conceptMastery.length} concept mastery, ${spacedRepetition.length} spaced rep, ${learningPaths.length} paths to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync learning progress: $e');
      return Left(UserSyncFailure('Failed to sync learning progress: $e'));
    }
  }

  // ==================== Gamification ====================

  @override
  Future<Either<Failure, void>> syncGamification() async {
    try {
      final db = await _databaseHelper.database;
      final gamificationProfiles = await _queryAll(db, GamificationTable.tableName);
      final badges = await _queryAll(db, BadgesTable.tableName);
      final xpEvents = await _queryAll(db, XpEventsTable.tableName);

      final gamificationData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'profile': gamificationProfiles.isNotEmpty ? gamificationProfiles.first : null,
        'badges': badges,
        'xp_events': xpEvents,
      };

      final success = await _datasource.writeGamification(gamificationData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write gamification to Drive'));
      }

      logger.info('Synced gamification data (${badges.length} badges, ${xpEvents.length} XP events) to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync gamification: $e');
      return Left(UserSyncFailure('Failed to sync gamification: $e'));
    }
  }

  // ==================== Preferences ====================

  @override
  Future<Either<Failure, void>> syncPreferences() async {
    try {
      final db = await _databaseHelper.database;
      final rows = await _queryAll(db, PreferencesTable.tableName);

      final preferencesData = {
        'updatedAt': DateTime.now().toIso8601String(),
        'items': rows,
      };

      final success = await _datasource.writePreferences(preferencesData);
      if (!success) {
        return const Left(UserSyncFailure('Failed to write preferences to Drive'));
      }

      logger.info('Synced ${rows.length} preferences to Drive');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync preferences: $e');
      return Left(UserSyncFailure('Failed to sync preferences: $e'));
    }
  }

  // ==================== Conflict Resolution ====================

  @override
  Future<ConflictResolution> resolveConflict(
    String dataType,
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) async {
    // If local is empty, use remote
    if (local.isEmpty) {
      return ConflictResolution.keepRemote;
    }

    // Default strategy: last-write-wins based on timestamp
    final localTimestamp = _extractTimestamp(local);
    final remoteTimestamp = _extractTimestamp(remote);

    if (localTimestamp == null && remoteTimestamp == null) {
      return ConflictResolution.keepLocal;
    }

    if (localTimestamp == null) {
      return ConflictResolution.keepRemote;
    }

    if (remoteTimestamp == null) {
      return ConflictResolution.keepLocal;
    }

    return localTimestamp.isAfter(remoteTimestamp)
        ? ConflictResolution.keepLocal
        : ConflictResolution.keepRemote;
  }

  /// Extract timestamp from various possible timestamp fields
  DateTime? _extractTimestamp(Map<String, dynamic> data) {
    // Try various timestamp field names
    final timestampFields = [
      'updatedAt',
      'updated_at',
      'lastWatched',
      'last_watched',
      'createdAt',
      'created_at',
      'completedAt',
      'completed_at',
      'timestamp',
    ];

    for (final field in timestampFields) {
      final value = data[field];
      if (value != null) {
        if (value is String) {
          return DateTime.tryParse(value);
        } else if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value);
        }
      }
    }

    return null;
  }

  // ==================== Cleanup ====================

  @override
  Future<void> clearSyncState() async {
    _syncState = AppSyncState.initial();
    _syncStateController.add(_syncState);
    _pendingOperations.clear();
    _datasource.clear();
    logger.info('Sync state cleared');
  }

  void dispose() {
    _syncStateController.close();
  }
}
