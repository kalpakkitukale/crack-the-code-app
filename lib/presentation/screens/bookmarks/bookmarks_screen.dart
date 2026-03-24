import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/widgets/cards/video_card.dart';
import 'package:streamshaala/core/widgets/error/error_state_widget.dart';
import 'package:streamshaala/core/widgets/empty/empty_state_widget.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';
import 'package:streamshaala/presentation/providers/user/bookmark_provider.dart';

/// Sort options for bookmarks
enum BookmarkSortOption {
  recent('Recently Added'),
  name('Name'),
  channel('Channel');

  final String label;
  const BookmarkSortOption(this.label);
}

/// Bookmarks Screen
/// Displays all bookmarked videos
class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  bool _isGridView = true;
  BookmarkSortOption _sortBy = BookmarkSortOption.recent;

  @override
  void initState() {
    super.initState();
    // Load bookmarks on screen init
    Future.microtask(() {
      ref.read(bookmarkProvider.notifier).loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = ref.watch(bookmarkProvider);

    // Loading state (first load)
    if (bookmarkState.isLoading && bookmarkState.bookmarks.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(showLoading: true),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Error state
    if (bookmarkState.error != null && bookmarkState.bookmarks.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: ErrorStateWidget(
          message: bookmarkState.error!,
          onRetry: () => ref.read(bookmarkProvider.notifier).refresh(),
        ),
      );
    }

    // Success state
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout();
          case DeviceType.tablet:
            return _buildTabletLayout();
          case DeviceType.desktop:
            return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    final bookmarkState = ref.watch(bookmarkProvider);
    final bookmarks = _sortBookmarks(bookmarkState.bookmarks);

    return Scaffold(
      appBar: _buildAppBar(showLoading: bookmarkState.isLoading),
      body: bookmarks.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () => ref.read(bookmarkProvider.notifier).refresh(),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: _isGridView ? _buildGridView(1, bookmarks) : _buildListView(bookmarks),
              ),
            ),
    );
  }

  Widget _buildTabletLayout() {
    final bookmarkState = ref.watch(bookmarkProvider);
    final bookmarks = _sortBookmarks(bookmarkState.bookmarks);

    return Scaffold(
      appBar: _buildAppBar(showLoading: bookmarkState.isLoading),
      body: bookmarks.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () => ref.read(bookmarkProvider.notifier).refresh(),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: _isGridView ? _buildGridView(2, bookmarks) : _buildListView(bookmarks),
              ),
            ),
    );
  }

  Widget _buildDesktopLayout() {
    final bookmarkState = ref.watch(bookmarkProvider);
    final bookmarks = _sortBookmarks(bookmarkState.bookmarks);

    return Scaffold(
      appBar: _buildAppBar(showLoading: bookmarkState.isLoading),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: bookmarks.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => ref.read(bookmarkProvider.notifier).refresh(),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingXl),
                    child: _isGridView ? _buildGridView(3, bookmarks) : _buildListView(bookmarks),
                  ),
                ),
        ),
      ),
    );
  }

  /// Sort bookmarks based on selected option
  List<Bookmark> _sortBookmarks(List<Bookmark> bookmarks) {
    final sorted = List<Bookmark>.from(bookmarks);
    switch (_sortBy) {
      case BookmarkSortOption.recent:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case BookmarkSortOption.name:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case BookmarkSortOption.channel:
        sorted.sort((a, b) {
          final aChannel = a.channelName?.toLowerCase() ?? '';
          final bChannel = b.channelName?.toLowerCase() ?? '';
          return aChannel.compareTo(bChannel);
        });
    }
    return sorted;
  }

  AppBar _buildAppBar({bool showLoading = false}) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.bookmark, color: context.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Bookmarks',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (showLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else ...[
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
          PopupMenuButton<BookmarkSortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by ${_sortBy.label}',
            onSelected: (value) {
              setState(() => _sortBy = value);
            },
            itemBuilder: (context) => BookmarkSortOption.values
                .map((option) => PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          if (_sortBy == option)
                            Icon(Icons.check, size: 18, color: context.colorScheme.primary)
                          else
                            const SizedBox(width: 18),
                          const SizedBox(width: 8),
                          Text(option.label),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGridView(int columns, List<Bookmark> bookmarks) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        // Aspect ratio: width / height. Lower value = taller cards
        // 0.8 gives enough height for thumbnail (16:9) + title + channel name
        childAspectRatio: 0.8,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return VideoCard(
          videoId: bookmark.videoId,
          title: bookmark.title,
          thumbnailUrl: bookmark.thumbnailUrl ?? '',
          channelName: bookmark.channelName,
          durationSeconds: bookmark.duration,
          progress: 0.0,
          isGridView: true,
          isBookmarked: true,
          onTap: () => _onVideoTap(bookmark.videoId),
          onBookmarkToggle: () => _removeBookmark(bookmark.videoId),
        );
      },
    );
  }

  Widget _buildListView(List<Bookmark> bookmarks) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return Dismissible(
          key: Key(bookmark.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppTheme.spacingLg),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removeBookmark(bookmark.videoId),
          child: VideoCard(
            videoId: bookmark.videoId,
            title: bookmark.title,
            thumbnailUrl: bookmark.thumbnailUrl ?? '',
            channelName: bookmark.channelName,
            durationSeconds: bookmark.duration,
            progress: 0.0,
            isGridView: false,
            isBookmarked: true,
            onTap: () => _onVideoTap(bookmark.videoId),
            onBookmarkToggle: () => _removeBookmark(bookmark.videoId),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return EmptyStates.noBookmarks(
      onBrowseVideos: () => context.go('/home'),
    );
  }

  void _onVideoTap(String videoId) {
    // Navigate to video player
    // context.go('/video/$videoId');
  }

  void _removeBookmark(String videoId) {
    ref.read(bookmarkProvider.notifier).removeBookmark(videoId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bookmark removed'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
