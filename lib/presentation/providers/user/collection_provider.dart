/// Collection Provider
/// Manages user video collections using real repository
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/user/collection.dart';
import 'package:crack_the_code/domain/entities/user/collection_video.dart';
import 'package:crack_the_code/domain/repositories/collection_repository.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:uuid/uuid.dart';

/// Provider for collection repository access
final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  return injectionContainer.collectionRepository;
});

/// State for collections
class CollectionState {
  final List<Collection> collections;
  final bool isLoading;
  final String? error;

  const CollectionState({
    required this.collections,
    this.isLoading = false,
    this.error,
  });

  factory CollectionState.initial() => const CollectionState(
        collections: [],
        isLoading: true,
      );

  CollectionState copyWith({
    List<Collection>? collections,
    bool? isLoading,
    String? error,
  }) {
    return CollectionState(
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get collection by ID
  Collection? getById(String id) {
    try {
      return collections.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Total video count across all collections
  int get totalVideoCount {
    return collections.fold(0, (sum, c) => sum + c.videoCount);
  }

  /// Check if video is in any collection
  bool isVideoInAnyCollection(String videoId) {
    return collections.any((c) => c.containsVideo(videoId));
  }

  /// Get collections containing a specific video
  List<Collection> getCollectionsContainingVideo(String videoId) {
    return collections.where((c) => c.containsVideo(videoId)).toList();
  }
}

/// Collection notifier for state management
class CollectionNotifier extends StateNotifier<CollectionState> {
  final CollectionRepository _repository;

  CollectionNotifier(this._repository) : super(CollectionState.initial()) {
    loadCollections();
  }

  final _uuid = const Uuid();

  /// Safely update state only if still mounted
  void _safeSetState(CollectionState newState) {
    if (mounted) {
      state = newState;
    }
  }

  /// Load all collections from repository
  Future<void> loadCollections() async {
    logger.info('[Collections] Loading collections from repository');
    _safeSetState(state.copyWith(isLoading: true, error: null));

    final result = await _repository.getAllCollections();

    if (!mounted) return;

    result.fold(
      (failure) {
        logger.error('[Collections] Failed to load: ${failure.message}');
        _safeSetState(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (collections) {
        logger.info('[Collections] Loaded ${collections.length} collections');
        _safeSetState(state.copyWith(
          collections: collections,
          isLoading: false,
          error: null,
        ));
      },
    );
  }

  @override
  void dispose() {
    logger.debug('[Collections] Disposing CollectionNotifier');
    super.dispose();
  }

  /// Create a new collection
  Future<bool> createCollection({
    required String name,
    String? description,
  }) async {
    if (name.trim().isEmpty) {
      state = state.copyWith(error: 'Collection name cannot be empty');
      return false;
    }

    logger.info('[Collections] Creating collection: $name');

    final now = DateTime.now();
    final collection = Collection(
      id: _uuid.v4(),
      name: name.trim(),
      description: description?.trim(),
      createdAt: now,
      updatedAt: now,
      videos: [],
    );

    final result = await _repository.createCollection(collection);

    return result.fold(
      (failure) {
        logger.error('[Collections] Failed to create: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (created) {
        logger.info('[Collections] Created successfully: ${created.id}');
        state = state.copyWith(
          collections: [...state.collections, created],
          error: null,
        );
        return true;
      },
    );
  }

  /// Update an existing collection
  Future<bool> updateCollection({
    required String id,
    required String name,
    String? description,
  }) async {
    if (name.trim().isEmpty) {
      state = state.copyWith(error: 'Collection name cannot be empty');
      return false;
    }

    final existing = state.getById(id);
    if (existing == null) {
      state = state.copyWith(error: 'Collection not found');
      return false;
    }

    logger.info('[Collections] Updating collection: $id');

    final updated = existing.copyWith(
      name: name.trim(),
      description: description?.trim(),
      updatedAt: DateTime.now(),
    );

    final result = await _repository.updateCollection(updated);

    return result.fold(
      (failure) {
        logger.error('[Collections] Failed to update: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (updatedCollection) {
        logger.info('[Collections] Updated successfully');
        final updatedList = state.collections.map((c) {
          return c.id == id ? updatedCollection : c;
        }).toList();
        state = state.copyWith(
          collections: updatedList,
          error: null,
        );
        return true;
      },
    );
  }

  /// Delete a collection
  Future<bool> deleteCollection(String id) async {
    logger.info('[Collections] Deleting collection: $id');

    final result = await _repository.deleteCollection(id);

    return result.fold(
      (failure) {
        logger.error('[Collections] Failed to delete: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        logger.info('[Collections] Deleted successfully');
        final updatedList = state.collections.where((c) => c.id != id).toList();
        state = state.copyWith(
          collections: updatedList,
          error: null,
        );
        return true;
      },
    );
  }

  /// Add video to a collection
  Future<bool> addVideoToCollection({
    required String collectionId,
    required String videoId,
    required String videoTitle,
    String? thumbnailUrl,
    int? duration,
    String? channelName,
  }) async {
    logger.info('[Collections] Adding video $videoId to collection $collectionId');

    final collectionVideo = CollectionVideo(
      id: _uuid.v4(),
      collectionId: collectionId,
      videoId: videoId,
      videoTitle: videoTitle,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      channelName: channelName,
      addedAt: DateTime.now(),
    );

    final result = await _repository.addVideoToCollection(collectionVideo);

    return result.fold(
      (failure) {
        logger.error('[Collections] Failed to add video: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (addedVideo) {
        logger.info('[Collections] Video added successfully');
        // Update local state
        final updatedList = state.collections.map((c) {
          if (c.id == collectionId) {
            return c.copyWith(
              videos: [...c.videos, addedVideo],
              updatedAt: DateTime.now(),
            );
          }
          return c;
        }).toList();
        state = state.copyWith(
          collections: updatedList,
          error: null,
        );
        return true;
      },
    );
  }

  /// Remove video from a collection
  Future<bool> removeVideoFromCollection({
    required String collectionId,
    required String videoId,
  }) async {
    logger.info('[Collections] Removing video $videoId from collection $collectionId');

    final result = await _repository.removeVideoFromCollection(
      collectionId: collectionId,
      videoId: videoId,
    );

    return result.fold(
      (failure) {
        logger.error('[Collections] Failed to remove video: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        logger.info('[Collections] Video removed successfully');
        // Update local state
        final updatedList = state.collections.map((c) {
          if (c.id == collectionId) {
            return c.copyWith(
              videos: c.videos.where((v) => v.videoId != videoId).toList(),
              updatedAt: DateTime.now(),
            );
          }
          return c;
        }).toList();
        state = state.copyWith(
          collections: updatedList,
          error: null,
        );
        return true;
      },
    );
  }

  /// Refresh collections from repository
  Future<void> refresh() async {
    await loadCollections();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for collections
final collectionProvider = StateNotifierProvider<CollectionNotifier, CollectionState>(
  (ref) => CollectionNotifier(ref.watch(collectionRepositoryProvider)),
);

/// Provider to get a specific collection by ID
final collectionByIdProvider = Provider.family<Collection?, String>((ref, id) {
  final state = ref.watch(collectionProvider);
  return state.getById(id);
});

/// Provider for collections containing a specific video
final collectionsForVideoProvider = Provider.family<List<Collection>, String>((ref, videoId) {
  final state = ref.watch(collectionProvider);
  return state.getCollectionsContainingVideo(videoId);
});
