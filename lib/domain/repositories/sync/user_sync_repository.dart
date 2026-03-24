/// User Sync Repository Interface
/// Defines the contract for syncing user data to Google Drive
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/data/models/sync/sync_state.dart';

/// Repository interface for user data synchronization
abstract class UserSyncRepository {
  /// Initialize the repository
  Future<Either<Failure, void>> initialize();

  /// Whether sync is available (user signed in with Drive access)
  bool get isSyncAvailable;

  /// Get current sync state
  AppSyncState get syncState;

  /// Stream of sync state changes
  Stream<AppSyncState> get syncStateStream;

  /// Perform a full sync (download from Drive, merge, upload changes)
  Future<Either<Failure, void>> performFullSync();

  /// Sync a specific data type
  Future<Either<Failure, void>> syncDataType(String dataType);

  /// Upload local changes to Drive
  Future<Either<Failure, void>> uploadChanges();

  /// Download data from Drive and merge with local
  Future<Either<Failure, void>> downloadAndMerge();

  // ==================== Progress ====================

  /// Sync video progress
  Future<Either<Failure, void>> syncProgress();

  /// Queue a progress update for sync
  void queueProgressUpdate(Map<String, dynamic> progress);

  // ==================== Bookmarks ====================

  /// Sync bookmarks
  Future<Either<Failure, void>> syncBookmarks();

  /// Queue a bookmark update for sync
  void queueBookmarkUpdate(Map<String, dynamic> bookmark);

  // ==================== Notes ====================

  /// Sync personal notes
  Future<Either<Failure, void>> syncNotes();

  /// Queue a note update for sync
  void queueNoteUpdate(Map<String, dynamic> note);

  /// Sync chapter notes
  Future<Either<Failure, void>> syncChapterNotes();

  /// Queue a chapter note update for sync
  void queueChapterNoteUpdate(Map<String, dynamic> note);

  // ==================== Collections ====================

  /// Sync collections/playlists
  Future<Either<Failure, void>> syncCollections();

  /// Queue a collection update for sync
  void queueCollectionUpdate(Map<String, dynamic> collection);

  // ==================== Quiz & Learning ====================

  /// Sync quiz data
  Future<Either<Failure, void>> syncQuizData();

  /// Sync flashcard progress
  Future<Either<Failure, void>> syncFlashcardProgress();

  /// Sync learning progress
  Future<Either<Failure, void>> syncLearningProgress();

  // ==================== Gamification ====================

  /// Sync gamification data (XP, badges, streaks)
  Future<Either<Failure, void>> syncGamification();

  // ==================== Preferences ====================

  /// Sync user preferences
  Future<Either<Failure, void>> syncPreferences();

  // ==================== Conflict Resolution ====================

  /// Handle sync conflicts
  /// Returns the resolution strategy used
  Future<ConflictResolution> resolveConflict(
    String dataType,
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  );

  // ==================== Cleanup ====================

  /// Clear all sync state (e.g., on sign out)
  Future<void> clearSyncState();

  /// Get pending operations count
  int get pendingOperationsCount;
}

/// Strategy for resolving sync conflicts
enum ConflictResolution {
  /// Use local data (overwrite remote)
  keepLocal,

  /// Use remote data (overwrite local)
  keepRemote,

  /// Merge both (combine changes)
  merge,

  /// User must decide
  askUser,
}

/// User sync-related failure
class UserSyncFailure extends Failure {
  const UserSyncFailure(String message) : super(message: message);
}
