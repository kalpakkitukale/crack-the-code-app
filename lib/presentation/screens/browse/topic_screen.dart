import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/core/widgets/cards/video_card.dart';
import 'package:streamshaala/core/widgets/error/error_state_widget.dart';
import 'package:streamshaala/domain/entities/content/video.dart';
import 'package:streamshaala/presentation/screens/browse/widgets/breadcrumb_bar.dart';
import 'package:streamshaala/presentation/providers/content/video_provider.dart';
import 'package:streamshaala/presentation/providers/content/board_provider.dart';
import 'package:streamshaala/presentation/providers/content/subject_provider.dart';
import 'package:streamshaala/presentation/providers/content/chapter_provider.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/presentation/widgets/quiz/chapter_complete_dialog.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';

/// Sort options for videos
enum VideoSortOption {
  title('Title'),
  duration('Duration'),
  rating('Rating'),
  views('Most Viewed'),
  newest('Newest');

  final String label;
  const VideoSortOption(this.label);
}

/// Topic/Video List Screen
/// Displays videos for a selected chapter
class TopicScreen extends ConsumerStatefulWidget {
  final String boardId;
  final String subjectId;
  final String chapterId;
  final String? filterKeyword;

  const TopicScreen({
    super.key,
    required this.boardId,
    required this.subjectId,
    required this.chapterId,
    this.filterKeyword,
  });

  @override
  ConsumerState<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends ConsumerState<TopicScreen> {
  bool _isGridView = true;
  String? _activeFilter;
  bool _hasShownChapterCompleteDialog = false;
  int _previousCompletedCount = -1; // Track to detect new completions
  VideoSortOption _sortBy = VideoSortOption.title;

  @override
  void initState() {
    super.initState();
    // Set initial filter from navigation parameter
    _activeFilter = widget.filterKeyword;

    // Load videos on screen init
    Future.microtask(() {
      ref.read(videoProvider.notifier).loadVideos(
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
      );
    });
  }

  /// Filter videos based on keyword matching tags
  List<Video> _filterVideos(List<Video> videos) {
    if (_activeFilter == null || _activeFilter!.isEmpty) {
      return videos;
    }

    final lowerFilter = _activeFilter!.toLowerCase();
    return videos.where((video) {
      // Check if filter matches any tag
      for (final tag in video.tags) {
        if (tag.toLowerCase().contains(lowerFilter) ||
            lowerFilter.contains(tag.toLowerCase())) {
          return true;
        }
      }
      // Also check title
      if (video.title.toLowerCase().contains(lowerFilter)) {
        return true;
      }
      return false;
    }).toList();
  }

  /// Sort videos based on selected option
  List<Video> _sortVideos(List<Video> videos) {
    final sorted = List<Video>.from(videos);
    switch (_sortBy) {
      case VideoSortOption.title:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case VideoSortOption.duration:
        sorted.sort((a, b) => a.duration.compareTo(b.duration));
      case VideoSortOption.rating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
      case VideoSortOption.views:
        sorted.sort((a, b) => b.viewCount.compareTo(a.viewCount));
      case VideoSortOption.newest:
        sorted.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    }
    return sorted;
  }

  void _clearFilter() {
    setState(() {
      _activeFilter = null;
    });
  }

  /// Navigate to Mind Map screen for this chapter
  void _navigateToMindMap() {
    context.push(RouteConstants.getMindMapPath(widget.chapterId));
  }

  /// Navigate to Glossary screen for this chapter
  void _navigateToGlossary() {
    context.push(RouteConstants.getGlossaryPath(widget.chapterId));
  }

  /// Check if chapter is complete and show dialog if just completed
  void _checkChapterCompletion(List<String> videoIds) {
    if (_hasShownChapterCompleteDialog || videoIds.isEmpty) return;

    final completionStatus = ref.read(
      chapterCompletionProvider(
        ChapterCompletionParams(
          chapterId: widget.chapterId,
          videoIds: videoIds,
        ),
      ),
    );

    // Only show dialog when:
    // 1. Chapter is complete
    // 2. We haven't shown the dialog yet
    // 3. We detected a NEW completion (previous count was less than total)
    if (completionStatus.isComplete &&
        !_hasShownChapterCompleteDialog &&
        (_previousCompletedCount < completionStatus.totalCount &&
            _previousCompletedCount != -1)) {
      _hasShownChapterCompleteDialog = true;
      _showChapterCompleteDialog(completionStatus.totalCount);
    }

    // Update previous count for next check
    _previousCompletedCount = completionStatus.completedCount;
  }

  void _showChapterCompleteDialog(int videoCount) {
    // Delay slightly to ensure smooth UI
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => ChapterCompleteDialog(
          chapterName: _getChapterName(),
          videoCount: videoCount,
          onTakeQuiz: () {
            Navigator.of(dialogContext).pop();
            _navigateToChapterQuiz();
          },
          onLater: () {
            Navigator.of(dialogContext).pop();
          },
        ),
      );
    });
  }

  void _navigateToChapterQuiz() {
    final studentId = ref.read(effectiveUserIdProvider);
    // Navigate to chapter-level quiz
    final quizPath = RouteConstants.getQuizPath(widget.chapterId, studentId);
    logger.info('Starting chapter quiz for: ${widget.chapterId}');
    context.push(quizPath);
  }

  // Helper methods to get display names
  String _getBoardName() {
    final boardState = ref.read(boardProvider);
    final board = boardState.boards.firstWhere(
      (b) => b.id == widget.boardId,
      orElse: () => boardState.boards.first,
    );
    return board.name.toUpperCase();
  }

  String _getSubjectName() {
    final subjectState = ref.read(subjectProvider);
    try {
      final subject = subjectState.subjects.firstWhere(
        (s) => s.id == widget.subjectId,
      );
      return subject.name;
    } catch (e) {
      return widget.subjectId;
    }
  }

  String _getChapterName() {
    final chapterState = ref.read(chapterProvider);
    try {
      final chapter = chapterState.chapters.firstWhere(
        (c) => c.id == widget.chapterId,
      );
      return chapter.name;
    } catch (e) {
      return widget.chapterId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoProvider);

    // Watch progress to detect chapter completion
    ref.watch(progressProvider);

    // Check for chapter completion when videos are loaded
    if (videoState.videos.isNotEmpty) {
      final videoIds = videoState.videos.map((v) => v.youtubeId).toList();
      // Use addPostFrameCallback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _checkChapterCompletion(videoIds);
        }
      });
    }

    // Loading state (first load)
    if (videoState.isLoading && videoState.videos.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: true, videoCount: 0, totalCount: 0),
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    // Error state
    if (videoState.error != null && videoState.videos.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(videoCount: 0, totalCount: 0),
            SliverFillRemaining(
              child: ErrorStateWidget(
                message: videoState.error!,
                onRetry: () => ref.read(videoProvider.notifier).refresh(),
              ),
            ),
          ],
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
    final videoState = ref.watch(videoProvider);
    final allVideos = videoState.videos;
    final filteredVideos = _sortVideos(_filterVideos(allVideos));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(videoProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(
              showLoading: videoState.isLoading,
              videoCount: filteredVideos.length,
              totalCount: allVideos.length,
            ),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(
                    label: _getBoardName(),
                    onTap: () => context.go('/browse'),
                  ),
                  BreadcrumbItem(
                    label: _getSubjectName(),
                    onTap: () {
                      // CRITICAL FIX: Navigate to proper route instead of pop()
                      // This works from both normal flow AND search flow
                      context.go('/browse/board/${widget.boardId}/subject/${widget.subjectId}/chapters');
                    },
                  ),
                  BreadcrumbItem(
                    label: _getChapterName(),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Filter chip when active
            if (_activeFilter != null) _buildFilterChip(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                100, // Bottom navigation bar + extra spacing
              ),
              sliver: filteredVideos.isEmpty
                  ? _buildEmptyFilterState()
                  : _isGridView
                      ? _buildGridView(1, filteredVideos)
                      : _buildListView(filteredVideos),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    final videoState = ref.watch(videoProvider);
    final allVideos = videoState.videos;
    final filteredVideos = _sortVideos(_filterVideos(allVideos));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(videoProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(
              showLoading: videoState.isLoading,
              videoCount: filteredVideos.length,
              totalCount: allVideos.length,
            ),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(
                    label: _getBoardName(),
                    onTap: () => context.go('/browse'),
                  ),
                  BreadcrumbItem(
                    label: _getSubjectName(),
                    onTap: () {
                      // CRITICAL FIX: Navigate to proper route instead of pop()
                      // This works from both normal flow AND search flow
                      context.go('/browse/board/${widget.boardId}/subject/${widget.subjectId}/chapters');
                    },
                  ),
                  BreadcrumbItem(
                    label: _getChapterName(),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Filter chip when active
            if (_activeFilter != null) _buildFilterChip(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                100, // Bottom navigation bar + extra spacing
              ),
              sliver: filteredVideos.isEmpty
                  ? _buildEmptyFilterState()
                  : _isGridView
                      ? _buildGridView(2, filteredVideos)
                      : _buildListView(filteredVideos),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final videoState = ref.watch(videoProvider);
    final allVideos = videoState.videos;
    final filteredVideos = _sortVideos(_filterVideos(allVideos));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(videoProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(
              showLoading: videoState.isLoading,
              videoCount: filteredVideos.length,
              totalCount: allVideos.length,
            ),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(
                    label: _getBoardName(),
                    onTap: () => context.go('/browse'),
                  ),
                  BreadcrumbItem(
                    label: _getSubjectName(),
                    onTap: () {
                      // CRITICAL FIX: Navigate to proper route instead of pop()
                      // This works from both normal flow AND search flow
                      context.go('/browse/board/${widget.boardId}/subject/${widget.subjectId}/chapters');
                    },
                  ),
                  BreadcrumbItem(
                    label: _getChapterName(),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Filter chip when active
            if (_activeFilter != null) _buildFilterChip(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingXl,
                AppTheme.spacingLg,
                AppTheme.spacingXl,
                100, // Bottom navigation bar + extra spacing
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: filteredVideos.isEmpty
                        ? _buildEmptyFilterStateBox()
                        : _isGridView
                            ? _buildDesktopGrid(filteredVideos)
                            : _buildDesktopList(filteredVideos),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildGridView(int columns, List videos) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        // Aspect ratio: width / height. Higher value = shorter/wider cards
        // 0.9 for single column provides compact cards without white space
        childAspectRatio: columns == 1 ? 0.9 : 0.85,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final video = videos[index];
          final progressState = ref.watch(progressProvider);
          return VideoCard(
            videoId: video.youtubeId,
            title: video.title,
            channelName: video.channelName,
            durationSeconds: video.duration,
            thumbnailUrl: video.thumbnailUrl,
            isGridView: true,
            progress: progressState.getProgressPercent(video.youtubeId),
            onTap: () => _onVideoSelected(video.youtubeId, topicId: video.topicId),
            onQuizTap: () => _onQuizTap(video.topicId, video.title),
          );
        },
        childCount: videos.length,
      ),
    );
  }

  Widget _buildListView(List videos) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final video = videos[index];
          final progressState = ref.watch(progressProvider);
          return VideoCard(
            videoId: video.youtubeId,
            title: video.title,
            channelName: video.channelName,
            durationSeconds: video.duration,
            thumbnailUrl: video.thumbnailUrl,
            progress: progressState.getProgressPercent(video.youtubeId),
            isGridView: false,
            onTap: () => _onVideoSelected(video.youtubeId, topicId: video.topicId),
            onQuizTap: () => _onQuizTap(video.topicId, video.title),
          );
        },
        childCount: videos.length,
      ),
    );
  }

  Widget _buildDesktopGrid(List videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // Aspect ratio: width / height. Lower value = taller cards
        // 0.8 gives enough height for thumbnail (16:9) + title + channel name
        childAspectRatio: 0.8,
        crossAxisSpacing: AppTheme.spacingLg,
        mainAxisSpacing: AppTheme.spacingLg,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        final progressState = ref.watch(progressProvider);
        return VideoCard(
          videoId: video.youtubeId,
          title: video.title,
          channelName: video.channelName,
          durationSeconds: video.duration,
          thumbnailUrl: video.thumbnailUrl,
          progress: progressState.getProgressPercent(video.youtubeId),
          isGridView: true,
          onTap: () => _onVideoSelected(video.youtubeId, topicId: video.topicId),
          onQuizTap: () => _onQuizTap(video.topicId, video.title),
        );
      },
    );
  }

  Widget _buildDesktopList(List videos) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        final progressState = ref.watch(progressProvider);
        return VideoCard(
          videoId: video.youtubeId,
          title: video.title,
          channelName: video.channelName,
          durationSeconds: video.duration,
          thumbnailUrl: video.thumbnailUrl,
          progress: progressState.getProgressPercent(video.youtubeId),
          isGridView: false,
          onTap: () => _onVideoSelected(video.youtubeId, topicId: video.topicId),
          onQuizTap: () => _onQuizTap(video.topicId, video.title),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar({
    bool showLoading = false,
    required int videoCount,
    int? totalCount,
  }) {
    final isFiltered = _activeFilter != null && totalCount != null && totalCount != videoCount;
    final countText = isFiltered
        ? '$videoCount of $totalCount videos'
        : '$videoCount videos';

    return SliverAppBar(
      floating: true,
      snap: true,
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Videos',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                countText,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          if (showLoading) ...[
            const SizedBox(width: 12),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
      actions: [
        // Mind Map Button
        IconButton(
          onPressed: () => _navigateToMindMap(),
          icon: const Icon(Icons.account_tree_outlined),
          tooltip: 'Mind Map',
        ),
        // Glossary Button
        IconButton(
          onPressed: () => _navigateToGlossary(),
          icon: const Icon(Icons.menu_book_outlined),
          tooltip: 'Glossary',
        ),
        IconButton(
          onPressed: () => setState(() => _isGridView = !_isGridView),
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          tooltip: _isGridView ? 'List View' : 'Grid View',
        ),
        PopupMenuButton<VideoSortOption>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort by ${_sortBy.label}',
          onSelected: (value) {
            setState(() => _sortBy = value);
          },
          itemBuilder: (context) => VideoSortOption.values
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
        const SizedBox(width: 8),
      ],
    );
  }

  /// Build filter chip widget showing active search filter
  Widget _buildFilterChip() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 16,
              color: context.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Filtered by:',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(
                _activeFilter!,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: context.colorScheme.primary,
              deleteIcon: Icon(
                Icons.close,
                size: 16,
                color: context.colorScheme.onPrimary,
              ),
              onDeleted: _clearFilter,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _clearFilter,
              child: const Text('Show all'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state when filter has no results (for sliver)
  Widget _buildEmptyFilterState() {
    return SliverFillRemaining(
      child: _buildEmptyFilterContent(),
    );
  }

  /// Build empty state when filter has no results (for box)
  Widget _buildEmptyFilterStateBox() {
    return _buildEmptyFilterContent();
  }

  Widget _buildEmptyFilterContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: context.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No videos match "$_activeFilter"',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Try clearing the filter to see all videos in this chapter.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            FilledButton.icon(
              onPressed: _clearFilter,
              icon: const Icon(Icons.clear),
              label: const Text('Clear filter'),
            ),
          ],
        ),
      ),
    );
  }

  void _onVideoSelected(String youtubeId, {String? topicId}) {
    // Pass topicId as query parameter for quiz loading
    context.push(RouteConstants.getVideoPathWithTopic(youtubeId, topicId: topicId));
  }

  void _onQuizTap(String topicId, String videoTitle) {
    // Navigate after frame to avoid provider mutation during build
    Future.microtask(() {
      if (!mounted) return;
      final studentId = ref.read(effectiveUserIdProvider);
      // Use topicId to load topic-level quiz (videos share quizzes at topic level)
      final quizPath = RouteConstants.getQuizPath(topicId, studentId);
      logger.info('Starting quiz for topic: $topicId (video: $videoTitle)');
      context.push(quizPath);
    });
  }
}
