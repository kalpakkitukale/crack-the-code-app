import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';
import 'package:crack_the_code/core/utils/ui_enhancements.dart';

/// Quick Actions Widget
/// Shows actionable buttons for quick navigation
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use select() to only rebuild when watchHistory changes
    final watchHistory = ref.watch(
      progressProvider.select((s) => s.watchHistory),
    );

    // Watch quiz data
    final quizStatsAsync = ref.watch(quizStatisticsProvider);

    // Get in-progress and recent videos
    final inProgressVideos = watchHistory
        .where((p) => !p.completed && p.watchDuration > 0)
        .toList();

    final lastWatchedVideo = watchHistory.isNotEmpty
        ? watchHistory.first
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Video Actions
        if (lastWatchedVideo != null || inProgressVideos.isNotEmpty)
          Row(
            children: [
              // Resume Learning button
              if (inProgressVideos.isNotEmpty)
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: Icons.play_circle_filled,
                    label: 'Resume Learning',
                    subtitle: '${inProgressVideos.length} in progress',
                    color: Colors.blue,
                    colorScheme: colorScheme,
                    onTap: () {
                      // Navigate to first in-progress video - use push to maintain navigation stack
                      context.push(RouteConstants.getVideoPath(inProgressVideos.first.videoId));
                    },
                  ),
                ),

              if (inProgressVideos.isNotEmpty && lastWatchedVideo != null)
                const SizedBox(width: AppTheme.spacingMd),

              // Continue Watching button
              if (lastWatchedVideo != null)
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    icon: Icons.history,
                    label: 'Continue Watching',
                    subtitle: 'Last watched',
                    color: Colors.green,
                    colorScheme: colorScheme,
                    onTap: () {
                      // Navigate to video - use push to maintain navigation stack
                      context.push(RouteConstants.getVideoPath(lastWatchedVideo.videoId));
                    },
                  ),
                ),
            ],
          ),

        // Spacing between video and quiz actions
        if (lastWatchedVideo != null || inProgressVideos.isNotEmpty)
          const SizedBox(height: AppTheme.spacingMd),

        // Quiz Actions
        Row(
          children: [
            // Take Quiz button
            Expanded(
              child: _buildActionCard(
                context: context,
                icon: Icons.quiz_outlined,
                label: 'Take a Quiz',
                subtitle: 'Test your knowledge',
                color: Colors.purple,
                colorScheme: colorScheme,
                onTap: () {
                  // Navigate to home screen where users can browse subjects/chapters to take quizzes
                  // This is more intuitive than landing directly on board selection page
                  context.go(RouteConstants.home);
                },
              ),
            ),

            const SizedBox(width: AppTheme.spacingMd),

            // Quiz History button with stats
            Expanded(
              child: quizStatsAsync.when(
                data: (stats) => _buildActionCard(
                  context: context,
                  icon: Icons.analytics_outlined,
                  label: 'Quiz History',
                  subtitle: stats.totalAttempts > 0
                      ? '${stats.totalAttempts} completed'
                      : 'No quizzes yet',
                  color: Colors.orange,
                  colorScheme: colorScheme,
                  onTap: () {
                    // Navigate to quiz history - use push to maintain navigation stack
                    context.push(RouteConstants.quizHistory);
                  },
                ),
                loading: () => _buildActionCard(
                  context: context,
                  icon: Icons.analytics_outlined,
                  label: 'Quiz History',
                  subtitle: 'Loading...',
                  color: Colors.orange,
                  colorScheme: colorScheme,
                  onTap: () {
                    context.push(RouteConstants.quizHistory);
                  },
                ),
                error: (_, __) => _buildActionCard(
                  context: context,
                  icon: Icons.analytics_outlined,
                  label: 'Quiz History',
                  subtitle: 'View your stats',
                  color: Colors.orange,
                  colorScheme: colorScheme,
                  onTap: () {
                    context.push(RouteConstants.quizHistory);
                  },
                ),
              ),
            ),
          ],
        ),

        // Empty state when no progress at all
        if (lastWatchedVideo == null &&
            inProgressVideos.isEmpty &&
            !quizStatsAsync.hasValue)
          Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacingMd),
            child: EmptyStateHelpers.createEmptyState(
              icon: Icons.school_outlined,
              title: 'Start Your Learning Journey',
              message: 'Browse videos and take quizzes to track your progress',
              theme: theme,
              action: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to home screen where users can browse content
                  context.go(RouteConstants.home);
                },
                icon: const Icon(Icons.explore),
                label: const Text('Browse Videos'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: ShadowElevations.medium,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
