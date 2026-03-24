/// Collection repository interface for managing video collections
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/collection.dart';
import 'package:crack_the_code/domain/entities/user/collection_video.dart';

/// Repository interface for collection operations
abstract class CollectionRepository {
  /// Create a new collection
  Future<Either<Failure, Collection>> createCollection(Collection collection);

  /// Update an existing collection
  Future<Either<Failure, Collection>> updateCollection(Collection collection);

  /// Delete a collection
  Future<Either<Failure, void>> deleteCollection(String collectionId);

  /// Get all collections
  Future<Either<Failure, List<Collection>>> getAllCollections();

  /// Get a specific collection by ID with all videos
  Future<Either<Failure, Collection>> getCollectionById(String collectionId);

  /// Add video to collection
  Future<Either<Failure, CollectionVideo>> addVideoToCollection(
    CollectionVideo collectionVideo,
  );

  /// Remove video from collection
  Future<Either<Failure, void>> removeVideoFromCollection({
    required String collectionId,
    required String videoId,
  });

  /// Check if video is in a collection
  Future<Either<Failure, bool>> isVideoInCollection({
    required String collectionId,
    required String videoId,
  });

  /// Get all collections containing a specific video
  Future<Either<Failure, List<Collection>>> getCollectionsForVideo(String videoId);

  /// Get videos in a collection
  Future<Either<Failure, List<CollectionVideo>>> getVideosInCollection(
    String collectionId,
  );

  /// Get collections count
  Future<Either<Failure, int>> getCollectionsCount();

  /// Get total videos count across all collections
  Future<Either<Failure, int>> getTotalVideosCount();
}
