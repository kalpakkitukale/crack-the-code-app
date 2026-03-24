/// Comprehensive tests for CollectionRepositoryImpl
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/data/repositories/collection_repository_impl.dart';
import 'package:crack_the_code/domain/entities/user/collection.dart';
import 'package:crack_the_code/domain/entities/user/collection_video.dart';
import 'package:crack_the_code/data/models/user/collection_model.dart';
import 'package:crack_the_code/data/models/user/collection_video_model.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('CollectionRepositoryImpl', () {
    late MockCollectionDao mockCollectionDao;
    late MockCollectionVideoDao mockCollectionVideoDao;
    late CollectionRepositoryImpl repository;

    setUp(() {
      mockCollectionDao = MockCollectionDao();
      mockCollectionVideoDao = MockCollectionVideoDao();
      repository = CollectionRepositoryImpl(mockCollectionDao, mockCollectionVideoDao);
    });

    tearDown(() {
      mockCollectionDao.clear();
      mockCollectionVideoDao.clear();
    });

    // Helper to create test collection
    Collection createCollection({
      String id = 'collection-1',
      String name = 'My Collection',
      String? description,
    }) {
      final now = DateTime(2024, 1, 15, 10, 0);
      return Collection(
        id: id,
        name: name,
        description: description,
        createdAt: now,
        updatedAt: now,
        videos: [],
      );
    }

    // Helper to create test collection video
    CollectionVideo createCollectionVideo({
      String id = 'cv-1',
      String collectionId = 'collection-1',
      String videoId = 'video-1',
      String videoTitle = 'Test Video',
    }) {
      final now = DateTime(2024, 1, 15, 10, 0);
      return CollectionVideo(
        id: id,
        collectionId: collectionId,
        videoId: videoId,
        videoTitle: videoTitle,
        thumbnailUrl: 'https://example.com/thumb.jpg',
        duration: 600,
        channelName: 'Test Channel',
        addedAt: now,
      );
    }

    group('createCollection', () {
      test('success_createsCollectionInDao', () async {
        final collection = createCollection();

        final result = await repository.createCollection(collection);

        expect(result.isRight(), true);
        expect(mockCollectionDao.all.length, 1);
        expect(mockCollectionDao.all.first.name, 'My Collection');
      });

      test('withProfileId_createsCollectionWithProfileId', () async {
        repository.profileId = 'profile-123';
        final collection = createCollection();

        await repository.createCollection(collection);

        expect(mockCollectionDao.all.first.profileId, 'profile-123');
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final collection = createCollection();
        mockCollectionDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.createCollection(collection);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to create collection'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('unknownException_returnsUnknownFailure', () async {
        final collection = createCollection();
        mockCollectionDao.setNextException(Exception('Unknown error'));

        final result = await repository.createCollection(collection);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('unexpected error'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('updateCollection', () {
      test('success_updatesCollectionInDao', () async {
        final collection = createCollection();
        final model = CollectionModel.fromEntity(collection, profileId: '');
        await mockCollectionDao.insert(model);

        final updated = collection.copyWith(name: 'Updated Collection');
        final result = await repository.updateCollection(updated);

        expect(result.isRight(), true);
        expect(mockCollectionDao.all.first.name, 'Updated Collection');
      });

      test('notFound_returnsNotFoundFailure', () async {
        final collection = createCollection(id: 'non-existent');

        final result = await repository.updateCollection(collection);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Collection not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final collection = createCollection();
        mockCollectionDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.updateCollection(collection);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to update collection'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('deleteCollection', () {
      test('success_deletesCollectionAndVideos', () async {
        final collection = createCollection();
        final model = CollectionModel.fromEntity(collection, profileId: '');
        await mockCollectionDao.insert(model);

        // Add videos to collection
        final video1 = createCollectionVideo(id: 'cv-1', videoId: 'v1');
        final video2 = createCollectionVideo(id: 'cv-2', videoId: 'v2');
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(video1));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(video2));

        final result = await repository.deleteCollection('collection-1');

        expect(result.isRight(), true);
        expect(mockCollectionDao.all.length, 0);
        expect(mockCollectionVideoDao.all.length, 0);
      });

      test('notFound_returnsNotFoundFailure', () async {
        final result = await repository.deleteCollection('non-existent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Collection not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.deleteCollection('collection-1');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to delete collection'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getAllCollections', () {
      test('success_returnsAllCollections', () async {
        final c1 = createCollection(id: 'c1', name: 'Collection 1');
        final c2 = createCollection(id: 'c2', name: 'Collection 2');
        await mockCollectionDao.insert(CollectionModel.fromEntity(c1, profileId: ''));
        await mockCollectionDao.insert(CollectionModel.fromEntity(c2, profileId: ''));

        final result = await repository.getAllCollections();

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 2);
          },
        );
      });

      test('emptyList_returnsEmptyList', () async {
        final result = await repository.getAllCollections();

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 0);
          },
        );
      });

      test('withProfileId_returnsOnlyProfileCollections', () async {
        repository.profileId = 'profile-1';
        final c1 = createCollection(id: 'c1');
        await repository.createCollection(c1);

        repository.profileId = 'profile-2';
        final c2 = createCollection(id: 'c2');
        await repository.createCollection(c2);

        repository.profileId = 'profile-1';
        final result = await repository.getAllCollections();

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 1);
            expect(collections.first.id, 'c1');
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getAllCollections();

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get collections'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getCollectionById', () {
      test('success_returnsCollectionWithVideos', () async {
        final collection = createCollection();
        final model = CollectionModel.fromEntity(collection, profileId: '');
        await mockCollectionDao.insert(model);

        // Add videos
        final video1 = createCollectionVideo(id: 'cv-1', videoId: 'v1');
        final video2 = createCollectionVideo(id: 'cv-2', videoId: 'v2');
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(video1));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(video2));

        final result = await repository.getCollectionById('collection-1');

        result.fold(
          (_) => fail('Should succeed'),
          (collection) {
            expect(collection.id, 'collection-1');
            expect(collection.videos.length, 2);
          },
        );
      });

      test('notFound_returnsNotFoundFailure', () async {
        final result = await repository.getCollectionById('non-existent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Collection not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('withProfileId_filtersCollectionByProfile', () async {
        repository.profileId = 'profile-1';
        final collection = createCollection();
        await repository.createCollection(collection);

        repository.profileId = 'profile-2';
        final result = await repository.getCollectionById('collection-1');

        expect(result.isLeft(), true);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getCollectionById('collection-1');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get collection'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('addVideoToCollection', () {
      test('success_addsVideoToCollection', () async {
        final video = createCollectionVideo();

        final result = await repository.addVideoToCollection(video);

        expect(result.isRight(), true);
        expect(mockCollectionVideoDao.all.length, 1);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final video = createCollectionVideo();
        mockCollectionVideoDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.addVideoToCollection(video);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to add video to collection'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('unknownException_returnsUnknownFailure', () async {
        final video = createCollectionVideo();
        mockCollectionVideoDao.setNextException(Exception('Unknown error'));

        final result = await repository.addVideoToCollection(video);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('unexpected error'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('removeVideoFromCollection', () {
      test('success_removesVideoFromCollection', () async {
        final video = createCollectionVideo();
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(video));

        final result = await repository.removeVideoFromCollection(
          collectionId: 'collection-1',
          videoId: 'video-1',
        );

        expect(result.isRight(), true);
        expect(mockCollectionVideoDao.all.length, 0);
      });

      test('notFound_returnsNotFoundFailure', () async {
        final result = await repository.removeVideoFromCollection(
          collectionId: 'collection-1',
          videoId: 'non-existent',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Video not found in collection'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionVideoDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.removeVideoFromCollection(
          collectionId: 'collection-1',
          videoId: 'video-1',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to remove video from collection'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('isVideoInCollection', () {
      test('true_videoIsInCollection', () async {
        final video = createCollectionVideo();
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(video));

        final result = await repository.isVideoInCollection(
          collectionId: 'collection-1',
          videoId: 'video-1',
        );

        result.fold(
          (_) => fail('Should succeed'),
          (isInCollection) {
            expect(isInCollection, true);
          },
        );
      });

      test('false_videoNotInCollection', () async {
        final result = await repository.isVideoInCollection(
          collectionId: 'collection-1',
          videoId: 'video-1',
        );

        result.fold(
          (_) => fail('Should succeed'),
          (isInCollection) {
            expect(isInCollection, false);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionVideoDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.isVideoInCollection(
          collectionId: 'collection-1',
          videoId: 'video-1',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to check video in collection'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getCollectionsForVideo', () {
      test('success_returnsCollectionsContainingVideo', () async {
        // Create collections
        final c1 = createCollection(id: 'c1', name: 'Collection 1');
        final c2 = createCollection(id: 'c2', name: 'Collection 2');
        await mockCollectionDao.insert(CollectionModel.fromEntity(c1, profileId: ''));
        await mockCollectionDao.insert(CollectionModel.fromEntity(c2, profileId: ''));

        // Add video to both collections
        final v1 = createCollectionVideo(id: 'cv-1', collectionId: 'c1', videoId: 'v1');
        final v2 = createCollectionVideo(id: 'cv-2', collectionId: 'c2', videoId: 'v1');
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v1));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v2));

        final result = await repository.getCollectionsForVideo('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 2);
          },
        );
      });

      test('emptyList_videoNotInAnyCollection', () async {
        final result = await repository.getCollectionsForVideo('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 0);
          },
        );
      });

      test('withProfileId_filtersCollectionsByProfile', () async {
        repository.profileId = 'profile-1';
        final c1 = createCollection(id: 'c1');
        await repository.createCollection(c1);

        repository.profileId = 'profile-2';
        final c2 = createCollection(id: 'c2');
        await repository.createCollection(c2);

        // Add same video to both collections
        final v1 = createCollectionVideo(id: 'cv-1', collectionId: 'c1', videoId: 'v1');
        final v2 = createCollectionVideo(id: 'cv-2', collectionId: 'c2', videoId: 'v1');
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v1));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v2));

        repository.profileId = 'profile-1';
        final result = await repository.getCollectionsForVideo('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 1);
            expect(collections.first.id, 'c1');
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionVideoDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getCollectionsForVideo('v1');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get collections for video'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getVideosInCollection', () {
      test('success_returnsVideosInCollection', () async {
        final v1 = createCollectionVideo(id: 'cv-1', videoId: 'v1');
        final v2 = createCollectionVideo(id: 'cv-2', videoId: 'v2');
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v1));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v2));

        final result = await repository.getVideosInCollection('collection-1');

        result.fold(
          (_) => fail('Should succeed'),
          (videos) {
            expect(videos.length, 2);
          },
        );
      });

      test('emptyList_collectionHasNoVideos', () async {
        final result = await repository.getVideosInCollection('collection-1');

        result.fold(
          (_) => fail('Should succeed'),
          (videos) {
            expect(videos.length, 0);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionVideoDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getVideosInCollection('collection-1');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get videos in collection'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getCollectionsCount', () {
      test('success_returnsCount', () async {
        final c1 = createCollection(id: 'c1');
        final c2 = createCollection(id: 'c2');
        await mockCollectionDao.insert(CollectionModel.fromEntity(c1, profileId: ''));
        await mockCollectionDao.insert(CollectionModel.fromEntity(c2, profileId: ''));

        final result = await repository.getCollectionsCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 2);
          },
        );
      });

      test('withProfileId_countsOnlyProfileCollections', () async {
        repository.profileId = 'profile-1';
        await repository.createCollection(createCollection(id: 'c1'));

        repository.profileId = 'profile-2';
        await repository.createCollection(createCollection(id: 'c2'));
        await repository.createCollection(createCollection(id: 'c3'));

        repository.profileId = 'profile-1';
        final result = await repository.getCollectionsCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 1);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getCollectionsCount();

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get collections count'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('getTotalVideosCount', () {
      test('success_returnsCount', () async {
        final v1 = createCollectionVideo(id: 'cv-1', videoId: 'v1');
        final v2 = createCollectionVideo(id: 'cv-2', videoId: 'v2');
        final v3 = createCollectionVideo(id: 'cv-3', collectionId: 'c2', videoId: 'v3');
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v1));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v2));
        await mockCollectionVideoDao.insert(CollectionVideoModel.fromEntity(v3));

        final result = await repository.getTotalVideosCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 3);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockCollectionVideoDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getTotalVideosCount();

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Failed to get total videos count'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    group('Multi-Profile Isolation', () {
      test('collectionsAreIsolatedByProfile', () async {
        repository.profileId = 'profile-1';
        await repository.createCollection(createCollection(id: 'c1'));

        repository.profileId = 'profile-2';
        await repository.createCollection(createCollection(id: 'c2'));

        repository.profileId = 'profile-1';
        final result = await repository.getAllCollections();

        result.fold(
          (_) => fail('Should succeed'),
          (collections) {
            expect(collections.length, 1);
            expect(collections.first.id, 'c1');
          },
        );
      });

      test('getCollectionById_respectsProfileId', () async {
        repository.profileId = 'profile-1';
        await repository.createCollection(createCollection(id: 'c1'));

        repository.profileId = 'profile-2';
        final result = await repository.getCollectionById('c1');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Collection not found'));
          },
          (_) => fail('Should fail'),
        );
      });
    });
  });
}
