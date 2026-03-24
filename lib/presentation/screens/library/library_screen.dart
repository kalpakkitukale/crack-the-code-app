import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/widgets/cards/video_card.dart';
import 'package:crack_the_code/core/widgets/error/error_state_widget.dart';
import 'package:crack_the_code/core/widgets/empty/empty_state_widget.dart';
import 'package:crack_the_code/presentation/providers/user/bookmark_provider.dart';

/// Library Screen (Middle & Senior segments)
/// Consolidated view of Bookmarks, Notes, and Collections
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load data on screen init
    Future.microtask(() {
      ref.read(bookmarkProvider.notifier).loadBookmarks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabView(),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabView(),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabView(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final settings = SegmentConfig.settings;

    return AppBar(
      title: Text(
        'My Library',
        style: TextStyle(
          fontSize: SegmentConfig.isCrackTheCode ? 22 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Toggle grid/list view
        IconButton(
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          tooltip: _isGridView ? 'List View' : 'Grid View',
          iconSize: SegmentConfig.isCrackTheCode ? 28 : 24,
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelStyle: TextStyle(
          fontSize: settings.fontScale * 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.bookmark_outline),
            text: 'Bookmarks',
          ),
          Tab(
            icon: Icon(Icons.note_outlined),
            text: 'Notes',
          ),
          Tab(
            icon: Icon(Icons.folder_outlined),
            text: 'Collections',
          ),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildBookmarksTab(),
        _buildNotesTab(),
        _buildCollectionsTab(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BOOKMARKS TAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBookmarksTab() {
    final bookmarkState = ref.watch(bookmarkProvider);

    // Loading state
    if (bookmarkState.isLoading && bookmarkState.bookmarks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (bookmarkState.error != null && bookmarkState.bookmarks.isEmpty) {
      return ErrorStateWidget(
        message: bookmarkState.error!,
        onRetry: () => ref.read(bookmarkProvider.notifier).refresh(),
      );
    }

    // Empty state
    if (bookmarkState.bookmarks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.bookmark_outline,
        title: 'No Bookmarks Yet',
        message: 'Bookmark videos to watch them later',
        actionLabel: 'Browse Videos',
        onAction: () => context.go('/browse'),
      );
    }

    // Success state
    final bookmarks = bookmarkState.bookmarks;
    return RefreshIndicator(
      onRefresh: () => ref.read(bookmarkProvider.notifier).refresh(),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: _isGridView
            ? _buildBookmarksGrid(bookmarks)
            : _buildBookmarksList(bookmarks),
      ),
    );
  }

  Widget _buildBookmarksGrid(List<dynamic> bookmarks) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return VideoCard(
          videoId: bookmark.videoId ?? '',
          title: bookmark.title ?? 'Untitled',
          channelName: bookmark.channelName,
          thumbnailUrl: bookmark.thumbnailUrl,
          durationSeconds: bookmark.durationSeconds,
          isGridView: true,
        );
      },
    );
  }

  Widget _buildBookmarksList(List<dynamic> bookmarks) {
    return ListView.separated(
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return VideoCard(
          videoId: bookmark.videoId ?? '',
          title: bookmark.title ?? 'Untitled',
          channelName: bookmark.channelName,
          thumbnailUrl: bookmark.thumbnailUrl,
          durationSeconds: bookmark.durationSeconds,
          isGridView: false,
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // NOTES TAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildNotesTab() {
    // TODO: Implement notes list when notes screen is ready
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined,
            size: 64,
            color: context.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Notes Coming Soon',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Take notes while watching videos\nand access them here',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // COLLECTIONS TAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildCollectionsTab() {
    // TODO: Implement collections list when collections provider is ready
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: context.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Collections Coming Soon',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Organize your bookmarks into\ncustom collections',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
