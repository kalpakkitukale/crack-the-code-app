/// Bookmark repository interface for managing saved videos
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';

/// Repository interface for bookmark operations
abstract class BookmarkRepository {
  /// Add a bookmark
  Future<Either<Failure, Bookmark>> addBookmark(Bookmark bookmark);

  /// Remove a bookmark by video ID
  Future<Either<Failure, void>> removeBookmark(String videoId);

  /// Get all bookmarks sorted by created date (newest first)
  Future<Either<Failure, List<Bookmark>>> getAllBookmarks();

  /// Check if a video is bookmarked
  Future<Either<Failure, bool>> isBookmarked(String videoId);

  /// Get bookmark by video ID
  Future<Either<Failure, Bookmark?>> getBookmarkByVideoId(String videoId);

  /// Get bookmarks count
  Future<Either<Failure, int>> getBookmarksCount();

  /// Clear all bookmarks
  Future<Either<Failure, void>> clearAllBookmarks();

  /// Get recent bookmarks (limit to specific count)
  Future<Either<Failure, List<Bookmark>>> getRecentBookmarks(int limit);
}
