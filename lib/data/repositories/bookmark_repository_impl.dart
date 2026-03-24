/// Bookmark repository implementation
///
/// Refactored to use RepositoryErrorHandler mixin for centralized error handling.
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/data/datasources/local/database/dao/bookmark_dao.dart';
import 'package:streamshaala/data/models/user/bookmark_model.dart';
import 'package:streamshaala/data/repositories/base_repository.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';
import 'package:streamshaala/domain/repositories/bookmark_repository.dart';

/// Implementation of BookmarkRepository using local database
///
/// Uses [RepositoryErrorHandler] mixin for standardized error handling,
/// reducing boilerplate and ensuring consistent exception-to-failure conversion.
class BookmarkRepositoryImpl
    with RepositoryErrorHandler
    implements BookmarkRepository {
  final BookmarkDao _bookmarkDao;

  /// Optional profile ID for multi-profile support
  /// When set, all operations are scoped to this profile
  String? profileId;

  BookmarkRepositoryImpl(this._bookmarkDao, {this.profileId});

  @override
  Future<Either<Failure, Bookmark>> addBookmark(Bookmark bookmark) {
    return executeWithErrorHandling(
      operationName: 'addBookmark',
      entityType: 'Bookmark',
      entityId: bookmark.videoId,
      operation: () async {
        logInfo('Adding bookmark for video: ${bookmark.videoId}',
            profileId: profileId);

        final model = BookmarkModel(
          id: profileId != null ? '${bookmark.videoId}_$profileId' : bookmark.id,
          videoId: bookmark.videoId,
          profileId: profileId ?? '',
          title: bookmark.title,
          thumbnailUrl: bookmark.thumbnailUrl,
          duration: bookmark.duration,
          channelName: bookmark.channelName,
          createdAt: bookmark.createdAt.millisecondsSinceEpoch,
        );
        await _bookmarkDao.insert(model);

        logInfo('Bookmark added successfully', profileId: profileId);
        return bookmark;
      },
    );
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String videoId) {
    return executeVoidWithErrorHandling(
      operationName: 'removeBookmark',
      entityType: 'Bookmark',
      entityId: videoId,
      operation: () async {
        logInfo('Removing bookmark for video: $videoId', profileId: profileId);
        await _bookmarkDao.deleteByVideoId(videoId, profileId: profileId);
        logInfo('Bookmark removed successfully', profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getAllBookmarks() {
    return executeWithErrorHandling(
      operationName: 'getAllBookmarks',
      operation: () async {
        logInfo('Getting all bookmarks', profileId: profileId);

        final models = await _bookmarkDao.getAll(profileId: profileId);
        final bookmarks = models.map((model) => model.toEntity()).toList();

        logInfo('Retrieved ${bookmarks.length} bookmarks', profileId: profileId);
        return bookmarks;
      },
    );
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(String videoId) {
    return executeWithErrorHandling(
      operationName: 'isBookmarked',
      operation: () async {
        logDebug('Checking if video is bookmarked: $videoId',
            profileId: profileId);
        return await _bookmarkDao.isBookmarked(videoId, profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, Bookmark?>> getBookmarkByVideoId(String videoId) {
    return executeWithErrorHandling(
      operationName: 'getBookmarkByVideoId',
      entityType: 'Bookmark',
      entityId: videoId,
      operation: () async {
        logDebug('Getting bookmark by video ID: $videoId', profileId: profileId);
        final model =
            await _bookmarkDao.getByVideoId(videoId, profileId: profileId);
        return model?.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, int>> getBookmarksCount() {
    return executeWithErrorHandling(
      operationName: 'getBookmarksCount',
      operation: () async {
        logDebug('Getting bookmarks count', profileId: profileId);
        return await _bookmarkDao.getCount(profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, void>> clearAllBookmarks() {
    return executeVoidWithErrorHandling(
      operationName: 'clearAllBookmarks',
      operation: () async {
        logWarning('Clearing all bookmarks', profileId: profileId);
        await _bookmarkDao.deleteAll();
        logInfo('All bookmarks cleared successfully', profileId: profileId);
      },
    );
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getRecentBookmarks(int limit) {
    return executeWithErrorHandling(
      operationName: 'getRecentBookmarks',
      operation: () async {
        logInfo('Getting $limit recent bookmarks', profileId: profileId);

        final models =
            await _bookmarkDao.getRecent(limit, profileId: profileId);
        final bookmarks = models.map((model) => model.toEntity()).toList();

        logInfo('Retrieved ${bookmarks.length} recent bookmarks',
            profileId: profileId);
        return bookmarks;
      },
    );
  }
}
