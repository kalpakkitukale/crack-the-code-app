/// BookmarkRepositoryImpl tests - Comprehensive coverage
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/data/repositories/bookmark_repository_impl.dart';
import 'package:crack_the_code/data/models/user/bookmark_model.dart';
import 'package:crack_the_code/domain/entities/user/bookmark.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('BookmarkRepositoryImpl', () {
    late MockBookmarkDao mockDao;
    late BookmarkRepositoryImpl repository;

    setUp(() {
      mockDao = MockBookmarkDao();
      repository = BookmarkRepositoryImpl(mockDao);
    });

    tearDown(() {
      mockDao.clear();
    });

    // Helper to create a test bookmark
    Bookmark createBookmark({
      String id = 'bookmark-1',
      String videoId = 'video-1',
      String title = 'Test Video',
    }) {
      return Bookmark(
        id: id,
        videoId: videoId,
        title: title,
        thumbnailUrl: 'https://example.com/thumb.jpg',
        duration: 300,
        channelName: 'Test Channel',
        createdAt: DateTime(2024, 1, 15, 10, 0),
      );
    }

    // =========================================================================
    // ADD BOOKMARK TESTS
    // =========================================================================
    group('addBookmark', () {
      test('success_addsBookmarkToDao', () async {
        final bookmark = createBookmark();

        final result = await repository.addBookmark(bookmark);

        expect(result.isRight(), true);
        expect(mockDao.all.length, 1);
        expect(mockDao.all.first.videoId, 'video-1');
        expect(mockDao.all.first.title, 'Test Video');
      });

      test('success_returnsBookmarkEntity', () async {
        final bookmark = createBookmark();

        final result = await repository.addBookmark(bookmark);

        result.fold(
          (failure) => fail('Should succeed'),
          (savedBookmark) {
            expect(savedBookmark.id, bookmark.id);
            expect(savedBookmark.videoId, bookmark.videoId);
            expect(savedBookmark.title, bookmark.title);
          },
        );
      });

      test('withProfileId_createsProfileSpecificId', () async {
        repository.profileId = 'profile-123';
        final bookmark = createBookmark();

        await repository.addBookmark(bookmark);

        expect(mockDao.all.first.id, 'video-1_profile-123');
        expect(mockDao.all.first.profileId, 'profile-123');
      });

      test('duplicate_returnsDuplicateFailure', () async {
        final bookmark = createBookmark();
        await repository.addBookmark(bookmark);

        // Try to add same bookmark again
        final result = await repository.addBookmark(bookmark);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('already exists'));
          },
          (_) => fail('Should fail with duplicate'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final bookmark = createBookmark();
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.addBookmark(bookmark);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Database operation failed'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('unknownException_returnsUnknownFailure', () async {
        final bookmark = createBookmark();
        mockDao.setNextException(Exception('Unknown error'));

        final result = await repository.addBookmark(bookmark);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('unexpected error'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    // =========================================================================
    // REMOVE BOOKMARK TESTS
    // =========================================================================
    group('removeBookmark', () {
      test('success_removesBookmarkFromDao', () async {
        final bookmark = createBookmark();
        await repository.addBookmark(bookmark);
        expect(mockDao.all.length, 1);

        final result = await repository.removeBookmark('video-1');

        expect(result.isRight(), true);
        expect(mockDao.all.length, 0);
      });

      test('withProfileId_removesOnlyMatchingProfile', () async {
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));

        repository.profileId = 'profile-2';
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v1'));

        // Remove from profile-1
        repository.profileId = 'profile-1';
        await repository.removeBookmark('v1');

        // profile-2 bookmark should still exist
        expect(mockDao.all.length, 1);
        expect(mockDao.all.first.profileId, 'profile-2');
      });

      test('notFound_returnsNotFoundFailure', () async {
        final result = await repository.removeBookmark('non-existent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        await repository.addBookmark(createBookmark());
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.removeBookmark('video-1');

        expect(result.isLeft(), true);
      });
    });

    // =========================================================================
    // GET ALL BOOKMARKS TESTS
    // =========================================================================
    group('getAllBookmarks', () {
      test('empty_returnsEmptyList', () async {
        final result = await repository.getAllBookmarks();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks, isEmpty);
          },
        );
      });

      test('withBookmarks_returnsAllBookmarks', () async {
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));
        await repository.addBookmark(createBookmark(id: 'b3', videoId: 'v3'));

        final result = await repository.getAllBookmarks();

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 3);
          },
        );
      });

      test('sortsBy_createdDate_newestFirst', () async {
        await repository.addBookmark(
          createBookmark(id: 'b1', videoId: 'v1').copyWith(
            createdAt: DateTime(2024, 1, 1),
          ),
        );
        await repository.addBookmark(
          createBookmark(id: 'b2', videoId: 'v2').copyWith(
            createdAt: DateTime(2024, 1, 15),
          ),
        );
        await repository.addBookmark(
          createBookmark(id: 'b3', videoId: 'v3').copyWith(
            createdAt: DateTime(2024, 1, 10),
          ),
        );

        final result = await repository.getAllBookmarks();

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks[0].videoId, 'v2'); // Jan 15 (newest)
            expect(bookmarks[1].videoId, 'v3'); // Jan 10
            expect(bookmarks[2].videoId, 'v1'); // Jan 1 (oldest)
          },
        );
      });

      test('withProfileId_returnsOnlyProfileBookmarks', () async {
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));

        repository.profileId = 'profile-2';
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));

        repository.profileId = 'profile-1';
        final result = await repository.getAllBookmarks();

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 1);
            expect(bookmarks.first.videoId, 'v1');
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getAllBookmarks();

        expect(result.isLeft(), true);
      });
    });

    // =========================================================================
    // IS BOOKMARKED TESTS
    // =========================================================================
    group('isBookmarked', () {
      test('exists_returnsTrue', () async {
        await repository.addBookmark(createBookmark(videoId: 'video-1'));

        final result = await repository.isBookmarked('video-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (isBookmarked) {
            expect(isBookmarked, true);
          },
        );
      });

      test('notExists_returnsFalse', () async {
        final result = await repository.isBookmarked('video-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (isBookmarked) {
            expect(isBookmarked, false);
          },
        );
      });

      test('withProfileId_checksProfileScope', () async {
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(videoId: 'v1'));

        repository.profileId = 'profile-2';
        final result = await repository.isBookmarked('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (isBookmarked) {
            expect(isBookmarked, false); // Different profile
          },
        );
      });
    });

    // =========================================================================
    // GET BOOKMARK BY VIDEO ID TESTS
    // =========================================================================
    group('getBookmarkByVideoId', () {
      test('exists_returnsBookmark', () async {
        await repository.addBookmark(createBookmark(videoId: 'video-1'));

        final result = await repository.getBookmarkByVideoId('video-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (bookmark) {
            expect(bookmark, isNotNull);
            expect(bookmark!.videoId, 'video-1');
          },
        );
      });

      test('notExists_returnsNull', () async {
        final result = await repository.getBookmarkByVideoId('video-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (bookmark) {
            expect(bookmark, isNull);
          },
        );
      });
    });

    // =========================================================================
    // GET BOOKMARKS COUNT TESTS
    // =========================================================================
    group('getBookmarksCount', () {
      test('empty_returnsZero', () async {
        final result = await repository.getBookmarksCount();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 0);
          },
        );
      });

      test('withBookmarks_returnsCount', () async {
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));
        await repository.addBookmark(createBookmark(id: 'b3', videoId: 'v3'));

        final result = await repository.getBookmarksCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 3);
          },
        );
      });

      test('withProfileId_countsOnlyProfile', () async {
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));

        repository.profileId = 'profile-2';
        await repository.addBookmark(createBookmark(id: 'b3', videoId: 'v3'));

        repository.profileId = 'profile-1';
        final result = await repository.getBookmarksCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 2);
          },
        );
      });
    });

    // =========================================================================
    // CLEAR ALL BOOKMARKS TESTS
    // =========================================================================
    group('clearAllBookmarks', () {
      test('success_removesAllBookmarks', () async {
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));
        expect(mockDao.all.length, 2);

        final result = await repository.clearAllBookmarks();

        expect(result.isRight(), true);
        expect(mockDao.all.length, 0);
      });

      test('empty_succeeds', () async {
        final result = await repository.clearAllBookmarks();

        expect(result.isRight(), true);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.clearAllBookmarks();

        expect(result.isLeft(), true);
      });
    });

    // =========================================================================
    // GET RECENT BOOKMARKS TESTS
    // =========================================================================
    group('getRecentBookmarks', () {
      test('limitsResultsToSpecifiedCount', () async {
        for (int i = 0; i < 10; i++) {
          await repository.addBookmark(
            createBookmark(id: 'b$i', videoId: 'v$i'),
          );
        }

        final result = await repository.getRecentBookmarks(5);

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 5);
          },
        );
      });

      test('returnsNewestFirst', () async {
        await repository.addBookmark(
          createBookmark(id: 'b1', videoId: 'v1').copyWith(
            createdAt: DateTime(2024, 1, 1),
          ),
        );
        await repository.addBookmark(
          createBookmark(id: 'b2', videoId: 'v2').copyWith(
            createdAt: DateTime(2024, 1, 15),
          ),
        );
        await repository.addBookmark(
          createBookmark(id: 'b3', videoId: 'v3').copyWith(
            createdAt: DateTime(2024, 1, 10),
          ),
        );

        final result = await repository.getRecentBookmarks(2);

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 2);
            expect(bookmarks[0].videoId, 'v2'); // Jan 15 (newest)
            expect(bookmarks[1].videoId, 'v3'); // Jan 10
          },
        );
      });

      test('lessThanLimit_returnsAll', () async {
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));

        final result = await repository.getRecentBookmarks(10);

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 2);
          },
        );
      });

      test('withProfileId_returnsOnlyProfileBookmarks', () async {
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));

        repository.profileId = 'profile-2';
        await repository.addBookmark(createBookmark(id: 'b3', videoId: 'v3'));

        repository.profileId = 'profile-1';
        final result = await repository.getRecentBookmarks(10);

        result.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 2);
            expect(bookmarks.every((b) => b.videoId != 'v3'), true);
          },
        );
      });
    });

    // =========================================================================
    // MULTI-PROFILE ISOLATION TESTS
    // =========================================================================
    group('Multi-Profile Isolation', () {
      test('differentProfiles_haveIsolatedBookmarks', () async {
        // Profile 1 bookmarks
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(id: 'b1', videoId: 'v1'));
        await repository.addBookmark(createBookmark(id: 'b2', videoId: 'v2'));

        // Profile 2 bookmarks
        repository.profileId = 'profile-2';
        await repository.addBookmark(createBookmark(id: 'b3', videoId: 'v3'));

        // Check profile 1
        repository.profileId = 'profile-1';
        final result1 = await repository.getAllBookmarks();
        result1.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 2);
            expect(bookmarks.every((b) => b.videoId != 'v3'), true);
          },
        );

        // Check profile 2
        repository.profileId = 'profile-2';
        final result2 = await repository.getAllBookmarks();
        result2.fold(
          (_) => fail('Should succeed'),
          (bookmarks) {
            expect(bookmarks.length, 1);
            expect(bookmarks.first.videoId, 'v3');
          },
        );
      });

      test('sameVideo_differentProfiles_bothExist', () async {
        repository.profileId = 'profile-1';
        await repository.addBookmark(createBookmark(videoId: 'video-1'));

        repository.profileId = 'profile-2';
        await repository.addBookmark(createBookmark(videoId: 'video-1'));

        // Total should be 2
        expect(mockDao.all.length, 2);

        // Profile 1 check
        repository.profileId = 'profile-1';
        final result1 = await repository.isBookmarked('video-1');
        expect(result1.getOrElse(() => false), true);

        // Profile 2 check
        repository.profileId = 'profile-2';
        final result2 = await repository.isBookmarked('video-1');
        expect(result2.getOrElse(() => false), true);
      });
    });
  });
}
