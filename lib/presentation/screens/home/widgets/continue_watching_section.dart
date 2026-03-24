import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/cards/video_card.dart';
import 'package:streamshaala/core/widgets/empty/empty_state_widget.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';
import 'package:streamshaala/presentation/providers/user/bookmark_provider.dart';

/// Continue watching section displaying videos in progress
class ContinueWatchingSection extends ConsumerWidget {
  const ContinueWatchingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Use select() to only rebuild when specific fields change
    final watchHistory = ref.watch(progressProvider.select((s) => s.watchHistory));
    final isLoadingHistory = ref.watch(progressProvider.select((s) => s.isLoadingHistory));
    final bookmarks = ref.watch(bookmarkProvider.select((s) => s.bookmarks));

    // Filter for videos in progress (not completed)
    final continueWatchingProgress = watchHistory
        .where((p) => !p.completed && p.watchDuration > 0)
        .take(5)
        .toList();

    // Show skeleton while loading
    if (isLoadingHistory) {
      return _buildSkeletonSection(theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Continue Watching',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (continueWatchingProgress.isNotEmpty)
              TextButton(
                onPressed: () => context.go(RouteConstants.progress),
                child: const Text('See All'),
              ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Videos carousel
        if (continueWatchingProgress.isEmpty)
          SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 48,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Videos in Progress',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start watching a video to see it here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go(RouteConstants.browse),
                    icon: const Icon(Icons.explore),
                    label: const Text('Browse Videos'),
                    style: ElevatedButton.styleFrom(
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
          SizedBox(
            height: 310,  // Increased from 280 to prevent card overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: continueWatchingProgress.length,
              itemBuilder: (context, index) {
                final progress = continueWatchingProgress[index];
                final isBookmarked = bookmarks.any((b) => b.videoId == progress.videoId);

                return SizedBox(
                  width: 300,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < continueWatchingProgress.length - 1
                          ? AppTheme.spacingMd
                          : 0,
                    ),
                    child: VideoCard(
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
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSkeletonSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Watching',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        SizedBox(
          height: 310,  // Match the main section height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 300,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < 2 ? AppTheme.spacingMd : 0,
                  ),
                  child: const VideoCardSkeleton(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
