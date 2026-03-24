/// Collection repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/collection_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/collection_video_dao.dart';
import 'package:streamshaala/data/models/user/collection_model.dart';
import 'package:streamshaala/data/models/user/collection_video_model.dart';
import 'package:streamshaala/domain/entities/user/collection.dart';
import 'package:streamshaala/domain/entities/user/collection_video.dart';
import 'package:streamshaala/domain/repositories/collection_repository.dart';

/// Implementation of CollectionRepository using local database
class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionDao _collectionDao;
  final CollectionVideoDao _collectionVideoDao;

  /// Optional profile ID for multi-profile support
  /// When set, all operations are scoped to this profile
  String? profileId;

  CollectionRepositoryImpl(
    this._collectionDao,
    this._collectionVideoDao,
  );

  @override
  Future<Either<Failure, Collection>> createCollection(
    Collection collection,
  ) async {
    try {
      logger.info('Creating collection: ${collection.name}${profileId != null ? ' (profile: $profileId)' : ''}');

      final model = CollectionModel.fromEntity(collection, profileId: profileId ?? '');
      await _collectionDao.insert(model);

      logger.info('Collection created successfully');
      return Right(collection);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error creating collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to create collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error creating collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Collection>> updateCollection(
    Collection collection,
  ) async {
    try {
      logger.info('Updating collection: ${collection.id}${profileId != null ? ' (profile: $profileId)' : ''}');

      final model = CollectionModel.fromEntity(collection, profileId: profileId ?? '');
      await _collectionDao.update(model);

      logger.info('Collection updated successfully');
      return Right(collection);
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Collection not found', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Collection not found',
        entityType: 'Collection',
        entityId: collection.id,
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error updating collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to update collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error updating collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCollection(String collectionId) async {
    try {
      logger.info('Deleting collection: $collectionId');

      // Delete all videos from the collection first
      await _collectionVideoDao.deleteByCollectionId(collectionId);

      // Then delete the collection itself
      await _collectionDao.delete(collectionId);

      logger.info('Collection deleted successfully');
      return const Right(null);
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Collection not found', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Collection not found',
        entityType: 'Collection',
        entityId: collectionId,
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Collection>>> getAllCollections() async {
    try {
      logger.info('Getting all collections${profileId != null ? ' (profile: $profileId)' : ''}');

      final models = await _collectionDao.getAll(profileId: profileId);
      final collections = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${collections.length} collections');
      return Right(collections);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting collections', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get collections',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting collections', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Collection>> getCollectionById(
    String collectionId,
  ) async {
    try {
      logger.info('Getting collection by ID: $collectionId${profileId != null ? ' (profile: $profileId)' : ''}');

      // Get the collection
      final collectionModel = await _collectionDao.getById(collectionId, profileId: profileId);
      if (collectionModel == null) {
        logger.warning('Collection not found: $collectionId');
        return Left(NotFoundFailure(
          message: 'Collection not found',
          entityType: 'Collection',
          entityId: collectionId,
        ));
      }

      // Get videos for the collection
      final videoModels =
          await _collectionVideoDao.getByCollectionId(collectionId);
      final videos = videoModels.map((model) => model.toEntity()).toList();

      // Combine collection and videos
      final collection = collectionModel.toEntity().copyWith(videos: videos);

      logger.info('Retrieved collection with ${videos.length} videos');
      return Right(collection);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, CollectionVideo>> addVideoToCollection(
    CollectionVideo collectionVideo,
  ) async {
    try {
      logger.info(
        'Adding video ${collectionVideo.videoId} to collection ${collectionVideo.collectionId}',
      );

      final model = CollectionVideoModel.fromEntity(collectionVideo);
      await _collectionVideoDao.insert(model);

      logger.info('Video added to collection successfully');
      return Right(collectionVideo);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error adding video to collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to add video to collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error adding video to collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> removeVideoFromCollection({
    required String collectionId,
    required String videoId,
  }) async {
    try {
      logger.info('Removing video $videoId from collection $collectionId');

      await _collectionVideoDao.deleteByCollectionAndVideo(
        collectionId,
        videoId,
      );

      logger.info('Video removed from collection successfully');
      return const Right(null);
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Video not found in collection', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Video not found in collection',
        entityType: 'CollectionVideo',
        entityId: '$collectionId-$videoId',
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error(
        'Database error removing video from collection',
        e,
        stackTrace,
      );
      return Left(DatabaseFailure(
        message: 'Failed to remove video from collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error(
        'Unknown error removing video from collection',
        e,
        stackTrace,
      );
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isVideoInCollection({
    required String collectionId,
    required String videoId,
  }) async {
    try {
      logger.debug('Checking if video $videoId is in collection $collectionId');

      final isInCollection = await _collectionVideoDao.isVideoInCollection(
        collectionId,
        videoId,
      );

      return Right(isInCollection);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error checking video in collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to check video in collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error checking video in collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Collection>>> getCollectionsForVideo(
    String videoId,
  ) async {
    try {
      logger.info('Getting collections for video: $videoId${profileId != null ? ' (profile: $profileId)' : ''}');

      // Get all collection-video associations for this video
      final collectionVideoModels =
          await _collectionVideoDao.getCollectionsForVideo(videoId);

      // Get unique collection IDs
      final collectionIds = collectionVideoModels
          .map((cv) => cv.collectionId)
          .toSet()
          .toList();

      // Fetch all collections
      final collections = <Collection>[];
      for (final collectionId in collectionIds) {
        final collectionModel = await _collectionDao.getById(collectionId, profileId: profileId);
        if (collectionModel != null) {
          collections.add(collectionModel.toEntity());
        }
      }

      logger.info('Video is in ${collections.length} collections');
      return Right(collections);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting collections for video', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get collections for video',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting collections for video', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<CollectionVideo>>> getVideosInCollection(
    String collectionId,
  ) async {
    try {
      logger.info('Getting videos in collection: $collectionId');

      final videoModels =
          await _collectionVideoDao.getByCollectionId(collectionId);
      final videos = videoModels.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${videos.length} videos');
      return Right(videos);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting videos in collection', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get videos in collection',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting videos in collection', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getCollectionsCount() async {
    try {
      logger.debug('Getting collections count${profileId != null ? ' (profile: $profileId)' : ''}');

      final count = await _collectionDao.getCount(profileId: profileId);

      return Right(count);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting collections count', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get collections count',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting collections count', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalVideosCount() async {
    try {
      logger.debug('Getting total videos count');

      final count = await _collectionVideoDao.getTotalVideosCount();

      return Right(count);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting total videos count', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get total videos count',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting total videos count', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
