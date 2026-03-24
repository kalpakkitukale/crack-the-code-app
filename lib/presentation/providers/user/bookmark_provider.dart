import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/user/bookmark.dart';
import 'package:crack_the_code/domain/usecases/bookmark/add_bookmark_usecase.dart';
import 'package:crack_the_code/domain/usecases/bookmark/get_all_bookmarks_usecase.dart';
import 'package:crack_the_code/domain/usecases/bookmark/remove_bookmark_usecase.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Bookmark Provider
/// Manages user bookmarks using real repository

class BookmarkState {
  final List<Bookmark> bookmarks;
  final bool isLoading;
  final String? error;

  /// Memoized set of bookmarked video IDs for O(1) lookups
  /// Cached to avoid recreating Set on every access
  Set<String>? _bookmarkedVideoIdsCache;

  BookmarkState({
    required this.bookmarks,
    this.isLoading = false,
    this.error,
  });

  factory BookmarkState.initial() => BookmarkState(
        bookmarks: const [],
        isLoading: true,
      );

  BookmarkState copyWith({
    List<Bookmark>? bookmarks,
    bool? isLoading,
    String? error,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool isBookmarked(String videoId) {
    return bookmarkedVideoIds.contains(videoId);
  }

  /// Memoized set of bookmarked video IDs
  /// Only recreated when bookmarks list changes
  Set<String> get bookmarkedVideoIds {
    _bookmarkedVideoIdsCache ??= bookmarks.map((b) => b.videoId).toSet();
    return _bookmarkedVideoIdsCache!;
  }
}

class BookmarkNotifier extends StateNotifier<BookmarkState> {
  final AddBookmarkUseCase _addBookmarkUseCase;
  final RemoveBookmarkUseCase _removeBookmarkUseCase;
  final GetAllBookmarksUseCase _getAllBookmarksUseCase;

  BookmarkNotifier(
    this._addBookmarkUseCase,
    this._removeBookmarkUseCase,
    this._getAllBookmarksUseCase,
  ) : super(BookmarkState.initial()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    logger.info('Loading bookmarks from repository');
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getAllBookmarksUseCase.call();

    result.fold(
      (failure) {
        logger.error('Failed to load bookmarks: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (bookmarks) {
        logger.info('Successfully loaded ${bookmarks.length} bookmarks');
        state = state.copyWith(
          bookmarks: bookmarks,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    logger.info('Adding bookmark: ${bookmark.videoId}');

    final result = await _addBookmarkUseCase.call(bookmark);

    result.fold(
      (failure) {
        logger.error('Failed to add bookmark: ${failure.message}');
        state = state.copyWith(error: failure.message);
      },
      (addedBookmark) {
        logger.info('Bookmark added successfully');
        // Add to local state
        final updatedBookmarks = [...state.bookmarks, addedBookmark];
        state = state.copyWith(
          bookmarks: updatedBookmarks,
          error: null,
        );
      },
    );
  }

  Future<void> removeBookmark(String videoId) async {
    logger.info('Removing bookmark: $videoId');

    final result = await _removeBookmarkUseCase.call(videoId);

    result.fold(
      (failure) {
        logger.error('Failed to remove bookmark: ${failure.message}');
        state = state.copyWith(error: failure.message);
      },
      (_) {
        logger.info('Bookmark removed successfully');
        // Remove from local state
        final updatedBookmarks = state.bookmarks.where((b) => b.videoId != videoId).toList();
        state = state.copyWith(
          bookmarks: updatedBookmarks,
          error: null,
        );
      },
    );
  }

  Future<void> toggleBookmark(Bookmark bookmark) async {
    if (isBookmarked(bookmark.videoId)) {
      await removeBookmark(bookmark.videoId);
    } else {
      await addBookmark(bookmark);
    }
  }

  bool isBookmarked(String videoId) {
    return state.isBookmarked(videoId);
  }

  Future<void> refresh() async {
    logger.info('Refreshing bookmarks');
    await loadBookmarks();
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, BookmarkState>((ref) {
  return BookmarkNotifier(
    injectionContainer.addBookmarkUseCase,
    injectionContainer.removeBookmarkUseCase,
    injectionContainer.getAllBookmarksUseCase,
  );
});
