/// User Sync Provider
/// Riverpod provider for user data synchronization to Google Drive
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/services/connectivity_service.dart';
import 'package:streamshaala/data/datasources/remote/drive_sync_datasource.dart';
import 'package:streamshaala/data/models/sync/sync_state.dart';
import 'package:streamshaala/data/repositories/sync/user_sync_repository_impl.dart';
import 'package:streamshaala/domain/repositories/sync/user_sync_repository.dart';

part 'user_sync_provider.g.dart';

/// Provides the drive sync datasource
@riverpod
DriveSyncDatasource driveSyncDatasource(Ref ref) {
  return DriveSyncDatasource();
}

/// Provides the user sync repository
@riverpod
UserSyncRepository userSyncRepository(Ref ref) {
  final datasource = ref.watch(driveSyncDatasourceProvider);
  return UserSyncRepositoryImpl(
    datasource: datasource,
    connectivityService: connectivityService,
  );
}

/// State for user sync
class UserSyncState {
  final bool isInitialized;
  final bool isSyncing;
  final bool isAvailable;
  final String? error;
  final AppSyncState syncState;
  final int pendingCount;

  const UserSyncState({
    this.isInitialized = false,
    this.isSyncing = false,
    this.isAvailable = false,
    this.error,
    AppSyncState? syncState,
    this.pendingCount = 0,
  }) : syncState = syncState ?? const AppSyncState(
          content: SyncState(id: 'content', dataType: 'content'),
          userData: SyncState(id: 'userData', dataType: 'userData'),
        );

  UserSyncState copyWith({
    bool? isInitialized,
    bool? isSyncing,
    bool? isAvailable,
    String? error,
    AppSyncState? syncState,
    int? pendingCount,
  }) {
    return UserSyncState(
      isInitialized: isInitialized ?? this.isInitialized,
      isSyncing: isSyncing ?? this.isSyncing,
      isAvailable: isAvailable ?? this.isAvailable,
      error: error,
      syncState: syncState ?? this.syncState,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  /// Whether sync is currently in progress
  bool get hasError => error != null;

  /// Last sync time
  DateTime? get lastSyncTime => syncState.lastFullSync;
}

/// Notifier for user sync state
@riverpod
class UserSyncNotifier extends _$UserSyncNotifier {
  @override
  UserSyncState build() {
    return const UserSyncState();
  }

  UserSyncRepository get _repository => ref.read(userSyncRepositoryProvider);

  /// Initialize the sync system
  Future<bool> initialize() async {
    if (state.isInitialized) return state.isAvailable;

    final result = await _repository.initialize();
    return result.fold(
      (failure) {
        state = state.copyWith(
          isInitialized: true,
          isAvailable: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isInitialized: true,
          isAvailable: _repository.isSyncAvailable,
          syncState: _repository.syncState,
          error: null,
        );

        // Listen to sync state changes
        _repository.syncStateStream.listen((syncState) {
          state = state.copyWith(syncState: syncState);
        });

        return true;
      },
    );
  }

  /// Perform a full sync
  Future<bool> performFullSync() async {
    if (!state.isAvailable) {
      state = state.copyWith(error: 'Sync not available');
      return false;
    }

    state = state.copyWith(isSyncing: true, error: null);

    final result = await _repository.performFullSync();
    return result.fold(
      (failure) {
        state = state.copyWith(
          isSyncing: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isSyncing: false,
          syncState: _repository.syncState,
          pendingCount: _repository.pendingOperationsCount,
          error: null,
        );
        return true;
      },
    );
  }

  /// Sync a specific data type
  Future<bool> syncDataType(String dataType) async {
    final result = await _repository.syncDataType(dataType);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(error: null);
        return true;
      },
    );
  }

  /// Upload pending changes
  Future<bool> uploadChanges() async {
    final result = await _repository.uploadChanges();
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          pendingCount: _repository.pendingOperationsCount,
          error: null,
        );
        return true;
      },
    );
  }

  // ==================== Queue Updates ====================

  /// Queue a progress update
  void queueProgressUpdate(Map<String, dynamic> progress) {
    _repository.queueProgressUpdate(progress);
    state = state.copyWith(
      pendingCount: _repository.pendingOperationsCount,
    );
  }

  /// Queue a bookmark update
  void queueBookmarkUpdate(Map<String, dynamic> bookmark) {
    _repository.queueBookmarkUpdate(bookmark);
    state = state.copyWith(
      pendingCount: _repository.pendingOperationsCount,
    );
  }

  /// Queue a note update
  void queueNoteUpdate(Map<String, dynamic> note) {
    _repository.queueNoteUpdate(note);
    state = state.copyWith(
      pendingCount: _repository.pendingOperationsCount,
    );
  }

  /// Queue a chapter note update
  void queueChapterNoteUpdate(Map<String, dynamic> note) {
    _repository.queueChapterNoteUpdate(note);
    state = state.copyWith(
      pendingCount: _repository.pendingOperationsCount,
    );
  }

  /// Queue a collection update
  void queueCollectionUpdate(Map<String, dynamic> collection) {
    _repository.queueCollectionUpdate(collection);
    state = state.copyWith(
      pendingCount: _repository.pendingOperationsCount,
    );
  }

  // ==================== Clear ====================

  /// Clear all sync state (e.g., on sign out)
  Future<void> clearSyncState() async {
    await _repository.clearSyncState();
    state = const UserSyncState();
  }
}

/// Provider for sync availability
@riverpod
bool userSyncAvailable(Ref ref) {
  final syncState = ref.watch(userSyncNotifierProvider);
  return syncState.isAvailable;
}

/// Provider for pending sync count
@riverpod
int pendingSyncCount(Ref ref) {
  final syncState = ref.watch(userSyncNotifierProvider);
  return syncState.pendingCount;
}

/// Provider for last sync time
@riverpod
DateTime? lastSyncTime(Ref ref) {
  final syncState = ref.watch(userSyncNotifierProvider);
  return syncState.lastSyncTime;
}
