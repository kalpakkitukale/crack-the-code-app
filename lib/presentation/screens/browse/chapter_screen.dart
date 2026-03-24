import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/widgets/cards/chapter_list_tile.dart';
import 'package:streamshaala/core/widgets/error/error_state_widget.dart';
import 'package:streamshaala/presentation/screens/browse/widgets/breadcrumb_bar.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';
import 'package:streamshaala/presentation/providers/content/chapter_provider.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';
import 'package:streamshaala/presentation/providers/user/subject_progress_provider.dart';

/// Sort options for chapters
enum ChapterSortOption {
  number('Chapter Order'),
  name('Name'),
  videoCount('Video Count');

  final String label;
  const ChapterSortOption(this.label);
}

/// Chapter List Screen
/// Displays chapters for a selected subject
class ChapterScreen extends ConsumerStatefulWidget {
  final String boardId;
  final String subjectId;

  const ChapterScreen({
    super.key,
    required this.boardId,
    required this.subjectId,
  });

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  ChapterSortOption _sortBy = ChapterSortOption.number;

  @override
  void initState() {
    super.initState();
    // Load chapters on screen init
    Future.microtask(() {
      ref.read(chapterProvider.notifier).loadChapters(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chapterState = ref.watch(chapterProvider);

    // Loading state (first load)
    if (chapterState.isLoading && chapterState.chapters.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: true),
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    // Error state
    if (chapterState.error != null && chapterState.chapters.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverFillRemaining(
              child: ErrorStateWidget(
                message: chapterState.error!,
                onRetry: () => ref.read(chapterProvider.notifier).refresh(),
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
    final chapterState = ref.watch(chapterProvider);
    final chapters = _sortChapters(chapterState.chapters);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(chapterProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: chapterState.isLoading),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(
                    label: 'Boards',
                    onTap: () => context.go('/browse'),
                  ),
                  BreadcrumbItem(
                    label: widget.boardId.toUpperCase(),
                    onTap: () => context.go('/browse/board/${widget.boardId}/subjects'),
                  ),
                  BreadcrumbItem(label: widget.subjectId),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                80 + AppTheme.spacingMd, // Navigation bar height (80) + spacing
              ),
              sliver: _buildChapterList(chapters),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    final chapterState = ref.watch(chapterProvider);
    final chapters = _sortChapters(chapterState.chapters);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(chapterProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: chapterState.isLoading),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(
                    label: 'Boards',
                    onTap: () => context.go('/browse'),
                  ),
                  BreadcrumbItem(
                    label: widget.boardId.toUpperCase(),
                    onTap: () => context.go('/browse/board/${widget.boardId}/subjects'),
                  ),
                  BreadcrumbItem(label: widget.subjectId),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                80 + AppTheme.spacingLg, // Navigation bar height (80) + spacing
              ),
              sliver: _buildChapterList(chapters),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final chapterState = ref.watch(chapterProvider);
    final chapters = _sortChapters(chapterState.chapters);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(chapterProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: chapterState.isLoading),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(
                    label: 'Boards',
                    onTap: () => context.go('/browse'),
                  ),
                  BreadcrumbItem(
                    label: widget.boardId.toUpperCase(),
                    onTap: () => context.go('/browse/board/${widget.boardId}/subjects'),
                  ),
                  BreadcrumbItem(label: widget.subjectId),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXl,
                vertical: AppTheme.spacingLg,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) => _buildChapterCard(chapters[index]),
                    ),
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

  /// Sort chapters based on selected option
  List<Chapter> _sortChapters(List<Chapter> chapters) {
    final sorted = List<Chapter>.from(chapters);
    switch (_sortBy) {
      case ChapterSortOption.number:
        sorted.sort((a, b) => a.number.compareTo(b.number));
      case ChapterSortOption.name:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case ChapterSortOption.videoCount:
        sorted.sort((a, b) => b.totalVideoCount.compareTo(a.totalVideoCount));
    }
    return sorted;
  }

  Widget _buildChapterList(List chapters) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildChapterCard(chapters[index]),
        childCount: chapters.length,
      ),
    );
  }

  Widget _buildChapterCard(chapter) {
    // Get chapter progress from the provider
    final chapterProgressAsync = ref.watch(chapterProgressBySubjectProvider(widget.subjectId));

    // Look up this chapter's completion percentage (progressPercentage is 0-1.0, widget expects 0-100)
    final completionPercentage = chapterProgressAsync.when(
      data: (progressList) {
        final chapterProgress = progressList.where((p) => p.chapterId == chapter.id).firstOrNull;
        return (chapterProgress?.progressPercentage ?? 0.0) * 100.0;
      },
      loading: () => 0.0,
      error: (_, __) => 0.0,
    );

    return ChapterListTile(
      chapterNumber: chapter.number,
      name: chapter.name,
      topicCount: chapter.topics.length,
      videoCount: chapter.totalVideoCount,
      completionPercentage: completionPercentage,
      onTap: () => _onChapterSelected(chapter.id),
      onQuizTap: () => _onQuizTap(chapter.id, chapter.name),
      onStudyHubTap: () => _onStudyHubTap(chapter.id),
    );
  }

  SliverAppBar _buildSliverAppBar({bool showLoading = false}) {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chapters',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.subjectId.toUpperCase(),
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
        PopupMenuButton<ChapterSortOption>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort by ${_sortBy.label}',
          onSelected: (value) {
            setState(() => _sortBy = value);
          },
          itemBuilder: (context) => ChapterSortOption.values
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

  void _onChapterSelected(String chapterId) {
    context.push('/browse/board/${widget.boardId}/subject/${widget.subjectId}/chapter/$chapterId/videos');
  }

  void _onQuizTap(String chapterId, String chapterName) {
    // Navigate after frame to avoid provider mutation during build
    Future.microtask(() {
      final studentId = ref.read(effectiveUserIdProvider);
      context.push('/quiz/$chapterId/$studentId');
    });
  }

  void _onStudyHubTap(String chapterId) {
    // Navigate to Study Hub for this chapter
    Future.microtask(() {
      context.push(RouteConstants.getStudyHubPath(
        chapterId,
        subjectId: widget.subjectId,
      ));
    });
  }
}
