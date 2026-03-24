import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/cards/video_card.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';
import 'package:streamshaala/presentation/providers/user/bookmark_provider.dart';

/// Recently watched section displaying user's watch history
class RecentVideosSection extends ConsumerWidget {
  const RecentVideosSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Use select() to only rebuild when specific fields change
    final watchHistory = ref.watch(progressProvider.select((s) => s.watchHistory));
    final isLoadingHistory = ref.watch(progressProvider.select((s) => s.isLoadingHistory));
    final bookmarks = ref.watch(bookmarkProvider.select((s) => s.bookmarks));

    // Show skeleton while loading
    if (isLoadingHistory) {
      return _buildSkeletonSection(theme);
    }

    // Get recently watched videos (take first 4 from watch history)
    final recentVideos = watchHistory.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Watched',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (recentVideos.isNotEmpty)
              TextButton(
                onPressed: () => context.go(RouteConstants.progress),
                child: const Text('See All'),
              ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Videos list
        if (recentVideos.isEmpty)
          SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Watch History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Videos you watch will appear here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.go(RouteConstants.browse),
                    icon: const Icon(Icons.video_library),
                    label: const Text('Start Learning'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentVideos.length,
            itemBuilder: (context, index) {
              final progress = recentVideos[index];
              final isBookmarked = bookmarks.any((b) => b.videoId == progress.videoId);

              return VideoCard(
                videoId: progress.videoId,
                title: progress.title ?? 'Video ${progress.videoId}',
                channelName: progress.channelName ?? 'Educational Content',
                durationSeconds: progress.totalDuration,
                progress: progress.progressFraction,
                isBookmarked: isBookmarked,
                onTap: () => context.push(RouteConstants.getVideoPath(progress.videoId)),
                onBookmarkToggle: () async {
                  if (isBookmarked) {
                    await ref.read(bookmarkProvider.notifier).removeBookmark(progress.videoId);
                  } else {
                    final bookmark = Bookmark(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      videoId: progress.videoId,
                      title: progress.title ?? 'Video ${progress.videoId}',
                      thumbnailUrl: progress.thumbnailUrl,
                      duration: progress.totalDuration,
                      channelName: progress.channelName,
                      createdAt: DateTime.now(),
                    );
                    await ref.read(bookmarkProvider.notifier).addBookmark(bookmark);
                  }
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildSkeletonSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Watched',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: AppTheme.spacingMd),
            child: VideoCardSkeleton(),
          ),
        ),
      ],
    );
  }
}
