import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/widgets/empty/empty_state_widget.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';
import 'package:crack_the_code/presentation/widgets/error_state_widget.dart';
import 'package:crack_the_code/presentation/widgets/skeletons/video_card_skeleton.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';

/// Watch History Widget
/// Shows recently watched videos with timestamps using real data
class WatchHistory extends ConsumerWidget {
  final int? limit;

  const WatchHistory({
    super.key,
    this.limit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Use select() to only rebuild when specific fields change
    final watchHistory = ref.watch(progressProvider.select((s) => s.watchHistory));
    final isLoadingHistory = ref.watch(progressProvider.select((s) => s.isLoadingHistory));
    final error = ref.watch(progressProvider.select((s) => s.error));

    // Show loading state
    if (isLoadingHistory && watchHistory.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watch History',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ...List.generate(
            limit ?? 5,
            (index) => const VideoListItemSkeleton(),
          ),
        ],
      );
    }

    // Show error state
    if (error != null && watchHistory.isEmpty) {
      return ErrorStateWidget(
        failure: DatabaseFailure(message: error),
        onRetry: () {
          ref.read(progressProvider.notifier).refresh();
        },
      );
    }

    final history = watchHistory;
    final displayHistory = limit != null && history.length > limit!
        ? history.take(limit!).toList()
        : history;

    // Show empty state
    if (displayHistory.isEmpty) {
      return EmptyStates.compactNoData(
        message: 'Start watching videos to build your history',
        icon: Icons.history,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Watch History',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                // Refresh button to trigger metadata migration
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(progressProvider.notifier).refresh();
                  },
                  tooltip: 'Refresh history',
                ),
                if (limit != null && history.length > limit!)
                  TextButton(
                    onPressed: () {
                      context.go('/progress/all-history');
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        ...displayHistory.map((progress) => _buildHistoryCard(
              context,
              progress,
            )),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    Progress progress,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use the standardized progress fraction from the Progress entity
    final progressValue = progress.progressFraction;

    // Format duration
    String formatDuration(int seconds) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      if (minutes > 60) {
        final hours = minutes ~/ 60;
        final mins = minutes % 60;
        return '${hours}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
      }
      return '${minutes}:${secs.toString().padLeft(2, '0')}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: InkWell(
        onTap: () {
          // Navigate to video player - use push to maintain navigation stack
          context.push(RouteConstants.getVideoPath(progress.videoId));
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail with cached network image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    child: CachedNetworkImage(
                      imageUrl: progress.thumbnailUrl ?? '',
                      width: 100,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 56,
                        color: colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 56,
                        color: colorScheme.surfaceVariant,
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                progress.completed
                                    ? Icons.check_circle
                                    : Icons.play_circle_outline,
                                size: 28,
                                color: progress.completed
                                    ? Colors.green
                                    : colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            // Duration badge
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  formatDuration(progress.totalDuration),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),

                  // Video Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.title ?? 'Untitled Video',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (progress.channelName != null)
                          Text(
                            progress.channelName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          progress.timeSinceLastWatched,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Progress bar
              if (progressValue > 0 && progressValue < 1) ...[
                const SizedBox(height: AppTheme.spacingSm),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 4,
                          backgroundColor: colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      '${(progressValue * 100).toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
