import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/widgets/loaders/shimmer_loading.dart';
import 'package:crack_the_code/core/widgets/error/error_widget.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';

/// Quick stats section displaying user progress metrics
class QuickStatsSection extends ConsumerWidget {
  const QuickStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use select() to only rebuild when these specific fields change
    final isLoading = ref.watch(progressProvider.select((s) => s.isLoading));
    final error = ref.watch(progressProvider.select((s) => s.error));
    final stats = ref.watch(progressProvider.select((s) => s.statistics));

    // Show skeleton while loading
    if (isLoading) {
      return _buildSkeletonStats(context);
    }

    // Handle error state
    if (error != null) {
      return DataErrorWidget(
        errorMessage: 'Unable to load statistics',
        onRetry: () => ref.read(progressProvider.notifier).refresh(),
      );
    }

    // Handle no stats available
    if (stats == null) {
      return _buildEmptyStats(context);
    }

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final columns = deviceType == DeviceType.mobile ? 2 : 4;

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppTheme.spacingMd,
          crossAxisSpacing: AppTheme.spacingMd,
          childAspectRatio: deviceType == DeviceType.mobile ? 1.0 : 1.4,
          children: [
            _StatCard(
              icon: Icons.check_circle_outline,
              title: 'Completed',
              value: '${stats.completedVideos}',
              subtitle: 'Videos',
              color: AppTheme.successColor,
            ),
            _StatCard(
              icon: Icons.access_time,
              title: 'Study Time',
              value: stats.formattedTotalWatchTime,
              subtitle: 'Total',
              color: AppTheme.primaryGreen,
            ),
            _StatCard(
              icon: Icons.play_circle_outline,
              title: 'Watched',
              value: '${stats.totalVideosWatched}',
              subtitle: 'Videos',
              color: AppTheme.primaryBlue,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonStats(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final columns = deviceType == DeviceType.mobile ? 2 : 4;

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppTheme.spacingMd,
          crossAxisSpacing: AppTheme.spacingMd,
          childAspectRatio: deviceType == DeviceType.mobile ? 1.0 : 1.4,
          children: List.generate(
            4,
            (index) => const Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ShimmerLoading(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 40, height: 40),
                      SizedBox(height: 8),
                      SkeletonLine(width: 60, height: 16),
                      SizedBox(height: 4),
                      SkeletonLine(width: 40, height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyStats(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Start watching videos to see your stats',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Value - Make it prominent
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Title
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
