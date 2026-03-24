/// Content Sync Provider
/// Riverpod provider for content synchronization from R2
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/remote_content_config.dart';
import 'package:streamshaala/core/services/connectivity_service.dart';
import 'package:streamshaala/data/datasources/remote/content_sync_datasource.dart';
import 'package:streamshaala/data/repositories/sync/content_sync_repository_impl.dart';
import 'package:streamshaala/domain/repositories/sync/content_sync_repository.dart';

part 'content_sync_provider.g.dart';

/// Provides the content sync datasource
@riverpod
ContentSyncDatasource contentSyncDatasource(Ref ref) {
  return ContentSyncDatasource();
}

/// Provides the content sync repository
@riverpod
ContentSyncRepository contentSyncRepository(Ref ref) {
  final datasource = ref.watch(contentSyncDatasourceProvider);
  return ContentSyncRepositoryImpl(
    datasource: datasource,
    connectivityService: connectivityService,
  );
}

/// State for content sync
class ContentSyncState {
  final bool isInitialized;
  final bool isSyncing;
  final bool hasUpdates;
  final String? error;
  final ContentManifest? manifest;
  final DateTime? lastSyncTime;
  final Map<String, double> syncProgress; // segment -> progress (0-1)

  const ContentSyncState({
    this.isInitialized = false,
    this.isSyncing = false,
    this.hasUpdates = false,
    this.error,
    this.manifest,
    this.lastSyncTime,
    this.syncProgress = const {},
  });

  ContentSyncState copyWith({
    bool? isInitialized,
    bool? isSyncing,
    bool? hasUpdates,
    String? error,
    ContentManifest? manifest,
    DateTime? lastSyncTime,
    Map<String, double>? syncProgress,
  }) {
    return ContentSyncState(
      isInitialized: isInitialized ?? this.isInitialized,
      isSyncing: isSyncing ?? this.isSyncing,
      hasUpdates: hasUpdates ?? this.hasUpdates,
      error: error,
      manifest: manifest ?? this.manifest,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      syncProgress: syncProgress ?? this.syncProgress,
    );
  }
}

/// Notifier for content sync state
@riverpod
class ContentSyncNotifier extends _$ContentSyncNotifier {
  @override
  ContentSyncState build() {
    return const ContentSyncState();
  }

  ContentSyncRepository get _repository => ref.read(contentSyncRepositoryProvider);

  /// Initialize the sync system
  Future<void> initialize() async {
    if (state.isInitialized) return;

    await _repository.initialize();
    state = state.copyWith(isInitialized: true);

    // Check for updates
    await checkForUpdates();
  }

  /// Check if content updates are available
  Future<bool> checkForUpdates() async {
    final result = await _repository.checkForUpdates();
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (hasUpdates) {
        state = state.copyWith(hasUpdates: hasUpdates, error: null);
        return hasUpdates;
      },
    );
  }

  /// Fetch the content manifest
  Future<ContentManifest?> fetchManifest() async {
    final result = await _repository.fetchManifest();
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return null;
      },
      (manifest) {
        state = state.copyWith(manifest: manifest, error: null);
        return manifest;
      },
    );
  }

  /// Sync content for a segment
  Future<bool> syncSegment(String segment, {bool forceRefresh = false}) async {
    state = state.copyWith(
      isSyncing: true,
      syncProgress: {...state.syncProgress, segment: 0.0},
    );

    final result = await _repository.syncSegment(
      segment,
      forceRefresh: forceRefresh,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSyncing: false,
          error: failure.message,
          syncProgress: {...state.syncProgress, segment: 0.0},
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isSyncing: false,
          error: null,
          lastSyncTime: DateTime.now(),
          syncProgress: {...state.syncProgress, segment: 1.0},
        );
        return true;
      },
    );
  }

  /// Sync content for a chapter
  Future<bool> syncChapter(
    String segment,
    String subjectId,
    String chapterId, {
    bool forceRefresh = false,
  }) async {
    final result = await _repository.syncChapter(
      segment,
      subjectId,
      chapterId,
      forceRefresh: forceRefresh,
    );

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

  /// Clear all cached content
  Future<void> clearCache() async {
    final result = await _repository.clearCache();
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => state = state.copyWith(
        error: null,
        lastSyncTime: null,
        syncProgress: {},
      ),
    );
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    return _repository.getCacheStats();
  }
}

/// Provider for checking if content updates are available
@riverpod
Future<bool> contentUpdatesAvailable(Ref ref) async {
  final repository = ref.watch(contentSyncRepositoryProvider);
  final result = await repository.checkForUpdates();
  return result.fold((_) => false, (hasUpdates) => hasUpdates);
}
