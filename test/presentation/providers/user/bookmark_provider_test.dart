/// Test suite for BookmarkNotifier and BookmarkState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/bookmark.dart';
import 'package:crack_the_code/domain/repositories/bookmark_repository.dart';
import 'package:crack_the_code/domain/usecases/bookmark/add_bookmark_usecase.dart';
import 'package:crack_the_code/domain/usecases/bookmark/get_all_bookmarks_usecase.dart';
import 'package:crack_the_code/domain/usecases/bookmark/remove_bookmark_usecase.dart';
import 'package:crack_the_code/presentation/providers/user/bookmark_provider.dart';

void main() {
  group('BookmarkState', () {
    test('initial_hasEmptyBookmarksAndIsLoading', () {
      final state = BookmarkState.initial();

      expect(state.bookmarks, isEmpty);
      expect(state.isLoading, true);
      expect(state.error, isNull);
    });

    test('copyWith_updatesSpecifiedFields', () {
      final initial = BookmarkState.initial();
      final bookmarks = [_createTestBookmark('1')];

      final updated = initial.copyWith(
        bookmarks: bookmarks,
        isLoading: false,
      );

      expect(updated.bookmarks, bookmarks);
      expect(updated.isLoading, false);
      expect(updated.error, isNull);
    });

    test('isBookmarked_returnsTrueWhenBookmarkExists', () {
      final state = BookmarkState(
        bookmarks: [
          _createTestBookmark('video-1'),
          _createTestBookmark('video-2'),
        ],
      );

      expect(state.isBookmarked('video-1'), true);
      expect(state.isBookmarked('video-2'), true);
      expect(state.isBookmarked('video-3'), false);
    });

    test('bookmarkedVideoIds_returnsSetOfVideoIds', () {
      final state = BookmarkState(
        bookmarks: [
          _createTestBookmark('video-1'),
          _createTestBookmark('video-2'),
          _createTestBookmark('video-3'),
        ],
      );

      expect(state.bookmarkedVideoIds, {'video-1', 'video-2', 'video-3'});
    });

    test('bookmarkedVideoIds_emptyWhenNoBookmarks', () {
      final state = BookmarkState(bookmarks: const []);

      expect(state.bookmarkedVideoIds, isEmpty);
    });
  });

  group('BookmarkNotifier', () {
    late MockAddBookmarkUseCase mockAddUseCase;
    late MockRemoveBookmarkUseCase mockRemoveUseCase;
    late MockGetAllBookmarksUseCase mockGetAllUseCase;

    setUp(() {
      mockAddUseCase = MockAddBookmarkUseCase();
      mockRemoveUseCase = MockRemoveBookmarkUseCase();
      mockGetAllUseCase = MockGetAllBookmarksUseCase();
    });

    BookmarkNotifier createNotifier({bool autoLoad = false}) {
      if (autoLoad) {
        return BookmarkNotifier(
          mockAddUseCase,
          mockRemoveUseCase,
          mockGetAllUseCase,
        );
      }

      // Create without auto-loading by setting success result first
      mockGetAllUseCase.setSuccess([]);
      final notifier = BookmarkNotifier(
        mockAddUseCase,
        mockRemoveUseCase,
        mockGetAllUseCase,
      );
      return notifier;
    }

    group('loadBookmarks', () {
      test('success_updatesStateWithBookmarks', () async {
        final bookmarks = [
          _createTestBookmark('video-1'),
          _createTestBookmark('video-2'),
        ];
        mockGetAllUseCase.setSuccess(bookmarks);

        final notifier = createNotifier(autoLoad: true);

        // Wait for async load
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.bookmarks, bookmarks);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
      });

      test('failure_setsErrorState', () async {
        mockGetAllUseCase.setFailure('Failed to load bookmarks');

        final notifier = createNotifier(autoLoad: true);

        // Wait for async load
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.bookmarks, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, 'Failed to load bookmarks');
      });
    });

    group('addBookmark', () {
      test('success_addsBookmarkToState', () async {
        final bookmark = _createTestBookmark('new-video');
        mockGetAllUseCase.setSuccess([]);
        mockAddUseCase.setSuccess(bookmark);

        final notifier = createNotifier();
        await Future.delayed(const Duration(milliseconds: 50));

        await notifier.addBookmark(bookmark);

        expect(notifier.state.bookmarks.length, 1);
        expect(notifier.state.bookmarks.first.videoId, 'new-video');
        expect(notifier.state.error, isNull);
      });

      test('failure_setsErrorButKeepsExistingBookmarks', () async {
        final existingBookmark = _createTestBookmark('existing');
        mockGetAllUseCase.setSuccess([existingBookmark]);

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 50));

        mockAddUseCase.setFailure('Failed to add');

        await notifier.addBookmark(_createTestBookmark('new'));

        expect(notifier.state.bookmarks.length, 1);
        expect(notifier.state.bookmarks.first.videoId, 'existing');
        expect(notifier.state.error, 'Failed to add');
      });
    });

    group('removeBookmark', () {
      test('success_removesBookmarkFromState', () async {
        final bookmark = _createTestBookmark('to-remove');
        mockGetAllUseCase.setSuccess([bookmark]);
        mockRemoveUseCase.setSuccess();

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 50));

        await notifier.removeBookmark('to-remove');

        expect(notifier.state.bookmarks, isEmpty);
        expect(notifier.state.error, isNull);
      });

      test('failure_setsErrorButKeepsBookmark', () async {
        final bookmark = _createTestBookmark('keep-me');
        mockGetAllUseCase.setSuccess([bookmark]);
        mockRemoveUseCase.setFailure('Failed to remove');

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 50));

        await notifier.removeBookmark('keep-me');

        expect(notifier.state.bookmarks.length, 1);
        expect(notifier.state.error, 'Failed to remove');
      });
    });

    group('toggleBookmark', () {
      test('addsBookmark_whenNotBookmarked', () async {
        mockGetAllUseCase.setSuccess([]);
        final bookmark = _createTestBookmark('toggle-video');
        mockAddUseCase.setSuccess(bookmark);

        final notifier = createNotifier();
        await Future.delayed(const Duration(milliseconds: 50));

        await notifier.toggleBookmark(bookmark);

        expect(notifier.state.isBookmarked('toggle-video'), true);
      });

      test('removesBookmark_whenAlreadyBookmarked', () async {
        final bookmark = _createTestBookmark('toggle-video');
        mockGetAllUseCase.setSuccess([bookmark]);
        mockRemoveUseCase.setSuccess();

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 50));

        await notifier.toggleBookmark(bookmark);

        expect(notifier.state.isBookmarked('toggle-video'), false);
      });
    });

    group('isBookmarked', () {
      test('returnsTrue_whenVideoIsBookmarked', () async {
        mockGetAllUseCase.setSuccess([_createTestBookmark('my-video')]);

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notifier.isBookmarked('my-video'), true);
      });

      test('returnsFalse_whenVideoIsNotBookmarked', () async {
        mockGetAllUseCase.setSuccess([]);

        final notifier = createNotifier();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notifier.isBookmarked('other-video'), false);
      });
    });

    group('refresh', () {
      test('reloadsBookmarks', () async {
        mockGetAllUseCase.setSuccess([_createTestBookmark('initial')]);

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notifier.state.bookmarks.length, 1);

        // Update mock to return different data
        mockGetAllUseCase.setSuccess([
          _createTestBookmark('refreshed-1'),
          _createTestBookmark('refreshed-2'),
        ]);

        await notifier.refresh();

        expect(notifier.state.bookmarks.length, 2);
      });
    });
  });
}

/// Create a test bookmark
Bookmark _createTestBookmark(String videoId) {
  return Bookmark(
    id: 'bookmark-$videoId',
    videoId: videoId,
    title: 'Test Video $videoId',
    thumbnailUrl: 'https://example.com/thumb/$videoId.jpg',
    duration: 300,
    channelName: 'Test Channel',
    createdAt: DateTime.now(),
  );
}

/// Mock AddBookmarkUseCase
class MockAddBookmarkUseCase implements AddBookmarkUseCase {
  Either<Failure, Bookmark>? _result;
  Bookmark? lastAddedBookmark;
  int callCount = 0;

  @override
  BookmarkRepository get repository =>
      throw UnimplementedError('Mock does not use repository');

  void setSuccess(Bookmark bookmark) {
    _result = Right(bookmark);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, Bookmark>> call(Bookmark params) async {
    callCount++;
    lastAddedBookmark = params;
    return _result ?? Right(params);
  }
}

/// Mock RemoveBookmarkUseCase
class MockRemoveBookmarkUseCase implements RemoveBookmarkUseCase {
  Either<Failure, void>? _result;
  String? lastRemovedVideoId;
  int callCount = 0;

  @override
  BookmarkRepository get repository =>
      throw UnimplementedError('Mock does not use repository');

  void setSuccess() {
    _result = const Right(null);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, void>> call(String params) async {
    callCount++;
    lastRemovedVideoId = params;
    return _result ?? const Right(null);
  }
}

/// Mock GetAllBookmarksUseCase
class MockGetAllBookmarksUseCase implements GetAllBookmarksUseCase {
  Either<Failure, List<Bookmark>>? _result;
  int callCount = 0;

  @override
  BookmarkRepository get repository =>
      throw UnimplementedError('Mock does not use repository');

  void setSuccess(List<Bookmark> bookmarks) {
    _result = Right(bookmarks);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, List<Bookmark>>> call([void params]) async {
    callCount++;
    return _result ?? const Right([]);
  }
}
