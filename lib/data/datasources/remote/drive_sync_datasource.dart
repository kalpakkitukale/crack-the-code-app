/// Drive Sync Datasource
/// Handles syncing user data to/from Google Drive appDataFolder
library;

import 'package:crack_the_code/core/services/google_drive_service.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/models/sync/sync_operation.dart';

/// File names for user data stored in Google Drive
class DriveFileNames {
  DriveFileNames._();

  static const String syncState = 'sync_state.json';
  static const String profile = 'profile.json';
  static const String progress = 'data/progress.json';
  static const String bookmarks = 'data/bookmarks.json';
  static const String notes = 'data/notes.json';
  static const String chapterNotes = 'data/chapter_notes.json';
  static const String collections = 'data/collections.json';
  static const String quizData = 'data/quiz_data.json';
  static const String flashcardProgress = 'data/flashcard_progress.json';
  static const String learningProgress = 'data/learning_progress.json';
  static const String gamification = 'data/gamification.json';
  static const String searchHistory = 'data/search_history.json';
  static const String preferences = 'data/preferences.json';
}

/// Datasource for syncing user data to Google Drive
class DriveSyncDatasource {
  final GoogleDriveService _driveService;
  final SyncQueue _pendingQueue = SyncQueue();

  DriveSyncDatasource({GoogleDriveService? driveService})
      : _driveService = driveService ?? GoogleDriveService();

  /// Whether the datasource is ready for sync
  bool get isReady => _driveService.isInitialized;

  /// Number of pending operations
  int get pendingCount => _pendingQueue.length;

  /// Initialize the datasource
  Future<bool> initialize() async {
    return _driveService.initialize();
  }

  /// Sign in and initialize
  Future<bool> signInAndInitialize() async {
    return _driveService.signInAndInitialize();
  }

  // ==================== Sync State ====================

  /// Read sync state from Drive
  Future<Map<String, dynamic>?> readSyncState() async {
    return _driveService.readFile(DriveFileNames.syncState);
  }

  /// Write sync state to Drive
  Future<bool> writeSyncState(Map<String, dynamic> state) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.syncState,
      state,
    );
    return fileId != null;
  }

  // ==================== Profile ====================

  /// Read user profile from Drive
  Future<Map<String, dynamic>?> readProfile() async {
    return _driveService.readFile(DriveFileNames.profile);
  }

  /// Write user profile to Drive
  Future<bool> writeProfile(Map<String, dynamic> profile) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.profile,
      profile,
    );
    return fileId != null;
  }

  // ==================== Progress ====================

  /// Read video progress from Drive
  Future<Map<String, dynamic>?> readProgress() async {
    return _driveService.readFile(DriveFileNames.progress);
  }

  /// Write video progress to Drive
  Future<bool> writeProgress(Map<String, dynamic> progress) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.progress,
      progress,
    );
    return fileId != null;
  }

  // ==================== Bookmarks ====================

  /// Read bookmarks from Drive
  Future<Map<String, dynamic>?> readBookmarks() async {
    return _driveService.readFile(DriveFileNames.bookmarks);
  }

  /// Write bookmarks to Drive
  Future<bool> writeBookmarks(Map<String, dynamic> bookmarks) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.bookmarks,
      bookmarks,
    );
    return fileId != null;
  }

  // ==================== Notes ====================

  /// Read personal notes from Drive
  Future<Map<String, dynamic>?> readNotes() async {
    return _driveService.readFile(DriveFileNames.notes);
  }

  /// Write personal notes to Drive
  Future<bool> writeNotes(Map<String, dynamic> notes) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.notes,
      notes,
    );
    return fileId != null;
  }

  /// Read chapter notes from Drive
  Future<Map<String, dynamic>?> readChapterNotes() async {
    return _driveService.readFile(DriveFileNames.chapterNotes);
  }

  /// Write chapter notes to Drive
  Future<bool> writeChapterNotes(Map<String, dynamic> notes) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.chapterNotes,
      notes,
    );
    return fileId != null;
  }

  // ==================== Collections ====================

  /// Read collections (playlists) from Drive
  Future<Map<String, dynamic>?> readCollections() async {
    return _driveService.readFile(DriveFileNames.collections);
  }

  /// Write collections to Drive
  Future<bool> writeCollections(Map<String, dynamic> collections) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.collections,
      collections,
    );
    return fileId != null;
  }

  // ==================== Quiz Data ====================

  /// Read quiz data from Drive
  Future<Map<String, dynamic>?> readQuizData() async {
    return _driveService.readFile(DriveFileNames.quizData);
  }

  /// Write quiz data to Drive
  Future<bool> writeQuizData(Map<String, dynamic> quizData) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.quizData,
      quizData,
    );
    return fileId != null;
  }

  // ==================== Flashcard Progress ====================

  /// Read flashcard progress from Drive
  Future<Map<String, dynamic>?> readFlashcardProgress() async {
    return _driveService.readFile(DriveFileNames.flashcardProgress);
  }

  /// Write flashcard progress to Drive
  Future<bool> writeFlashcardProgress(Map<String, dynamic> progress) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.flashcardProgress,
      progress,
    );
    return fileId != null;
  }

  // ==================== Learning Progress ====================

  /// Read learning progress from Drive
  Future<Map<String, dynamic>?> readLearningProgress() async {
    return _driveService.readFile(DriveFileNames.learningProgress);
  }

  /// Write learning progress to Drive
  Future<bool> writeLearningProgress(Map<String, dynamic> progress) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.learningProgress,
      progress,
    );
    return fileId != null;
  }

  // ==================== Gamification ====================

  /// Read gamification data from Drive
  Future<Map<String, dynamic>?> readGamification() async {
    return _driveService.readFile(DriveFileNames.gamification);
  }

  /// Write gamification data to Drive
  Future<bool> writeGamification(Map<String, dynamic> data) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.gamification,
      data,
    );
    return fileId != null;
  }

  // ==================== Search History ====================

  /// Read search history from Drive
  Future<Map<String, dynamic>?> readSearchHistory() async {
    return _driveService.readFile(DriveFileNames.searchHistory);
  }

  /// Write search history to Drive
  Future<bool> writeSearchHistory(Map<String, dynamic> history) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.searchHistory,
      history,
    );
    return fileId != null;
  }

  // ==================== Preferences ====================

  /// Read user preferences from Drive
  Future<Map<String, dynamic>?> readPreferences() async {
    return _driveService.readFile(DriveFileNames.preferences);
  }

  /// Write user preferences to Drive
  Future<bool> writePreferences(Map<String, dynamic> preferences) async {
    final fileId = await _driveService.writeFile(
      DriveFileNames.preferences,
      preferences,
    );
    return fileId != null;
  }

  // ==================== Batch Operations ====================

  /// Read all user data from Drive
  Future<Map<String, Map<String, dynamic>>> readAllData() async {
    final results = <String, Map<String, dynamic>>{};

    final fileNames = [
      DriveFileNames.profile,
      DriveFileNames.progress,
      DriveFileNames.bookmarks,
      DriveFileNames.notes,
      DriveFileNames.chapterNotes,
      DriveFileNames.collections,
      DriveFileNames.quizData,
      DriveFileNames.flashcardProgress,
      DriveFileNames.learningProgress,
      DriveFileNames.gamification,
      DriveFileNames.searchHistory,
      DriveFileNames.preferences,
    ];

    for (final fileName in fileNames) {
      final data = await _driveService.readFile(fileName);
      if (data != null) {
        results[fileName] = data;
      }
    }

    logger.info('Read ${results.length} data files from Drive');
    return results;
  }

  /// Write multiple data files to Drive
  Future<int> writeAllData(Map<String, Map<String, dynamic>> data) async {
    var successCount = 0;

    for (final entry in data.entries) {
      final fileId = await _driveService.writeFile(entry.key, entry.value);
      if (fileId != null) {
        successCount++;
      }
    }

    logger.info('Wrote $successCount/${data.length} data files to Drive');
    return successCount;
  }

  /// List all files in Drive
  Future<Map<String, String>> listFiles() async {
    return _driveService.listFiles();
  }

  // ==================== Pending Operations ====================

  /// Add an operation to the pending queue
  void queueOperation(SyncOperation operation) {
    _pendingQueue.add(operation);
    logger.debug('Queued sync operation: $operation');
  }

  /// Get and remove the next pending operation
  SyncOperation? popOperation() {
    return _pendingQueue.pop();
  }

  /// Process all pending operations
  Future<int> processPendingOperations() async {
    var successCount = 0;

    while (_pendingQueue.isNotEmpty) {
      final operation = _pendingQueue.pop();
      if (operation == null) break;

      final success = await _processOperation(operation);
      if (success) {
        successCount++;
      } else if (operation.shouldRetry) {
        // Re-queue with incremented retry count
        _pendingQueue.add(operation.withError('Operation failed'));
      }
    }

    return successCount;
  }

  Future<bool> _processOperation(SyncOperation operation) async {
    try {
      switch (operation.entityType) {
        case 'progress':
          return await writeProgress(operation.payload ?? {});
        case 'bookmarks':
          return await writeBookmarks(operation.payload ?? {});
        case 'notes':
          return await writeNotes(operation.payload ?? {});
        case 'chapter_notes':
          return await writeChapterNotes(operation.payload ?? {});
        case 'collections':
          return await writeCollections(operation.payload ?? {});
        case 'quiz_data':
          return await writeQuizData(operation.payload ?? {});
        case 'flashcard_progress':
          return await writeFlashcardProgress(operation.payload ?? {});
        case 'learning_progress':
          return await writeLearningProgress(operation.payload ?? {});
        case 'gamification':
          return await writeGamification(operation.payload ?? {});
        default:
          logger.warning('Unknown entity type: ${operation.entityType}');
          return false;
      }
    } catch (e) {
      logger.error('Failed to process operation $operation: $e');
      return false;
    }
  }

  /// Clear Drive service state
  void clear() {
    _driveService.clear();
    _pendingQueue.clear();
  }
}
