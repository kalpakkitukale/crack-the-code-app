import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';

/// Statistics Overview Widget
/// Shows key metrics in cards using real data from ProgressStats
class StatsOverview extends ConsumerWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use select() to only rebuild when specific fields change
    final stats = ref.watch(progressProvider.select((s) => s.statistics));
    final isLoading = ref.watch(progressProvider.select((s) => s.isLoading));
    final currentStreak = ref.watch(progressProvider.select((s) => s.currentStreak));
    final longestStreak = ref.watch(progressProvider.select((s) => s.longestStreak));

    // Show loading state
    if (isLoading && stats == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingXl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Calculate values from real data
    final totalVideos = stats?.totalVideosWatched ?? 0;
    final studyTime = stats?.formattedTotalWatchTime ?? '0 min';
    final completedVideos = stats?.completedVideos ?? 0;
    final inProgressVideos = stats?.inProgressVideos ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.0, // Removes extra line height spacing
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            // Platform-specific spacing offset
            // iOS needs more aggressive offset due to text rendering differences
            final double offsetY = kIsWeb
                ? -16.0
                : (Platform.isIOS ? -28.0 : -4.0);

            // Use flexible grid that adapts to available width
            return Transform.translate(
              offset: Offset(0, offsetY),
              child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppTheme.spacingMd,
              crossAxisSpacing: AppTheme.spacingMd,
              childAspectRatio: constraints.maxWidth > 600 ? 2.0 : 1.5,
              children: [
                _buildStatCard(
                  icon: Icons.play_circle_outline,
                  label: 'Videos Watched',
                  value: totalVideos.toString(),
                  color: Colors.blue,
                  colorScheme: colorScheme,
                ),
                _buildStatCard(
                  icon: Icons.access_time,
                  label: 'Study Time',
                  value: studyTime,
                  color: Colors.green,
                  colorScheme: colorScheme,
                ),
                _buildStatCard(
                  icon: Icons.check_circle_outline,
                  label: 'Completed',
                  value: completedVideos.toString(),
                  color: Colors.purple,
                  colorScheme: colorScheme,
                ),
                _buildStatCard(
                  icon: Icons.pending_outlined,
                  label: 'In Progress',
                  value: inProgressVideos.toString(),
                  color: Colors.orange,
                  colorScheme: colorScheme,
                ),
                _buildStatCard(
                  icon: Icons.local_fire_department,
                  label: 'Current Streak',
                  value: '$currentStreak ${currentStreak == 1 ? "day" : "days"}',
                  color: Colors.deepOrange,
                  colorScheme: colorScheme,
                ),
                _buildStatCard(
                  icon: Icons.emoji_events,
                  label: 'Best Streak',
                  value: '$longestStreak ${longestStreak == 1 ? "day" : "days"}',
                  color: Colors.amber,
                  colorScheme: colorScheme,
                ),
              ],
            ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
