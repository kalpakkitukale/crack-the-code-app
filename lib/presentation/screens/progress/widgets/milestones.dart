import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';

/// Milestones Widget
/// Shows achievements and progress milestones
class Milestones extends ConsumerWidget {
  const Milestones({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressState = ref.watch(progressProvider);

    final milestones = _calculateMilestones(progressState);

    if (milestones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              children: [
                ...milestones.map((milestone) => _buildMilestoneItem(
                      context,
                      milestone,
                      colorScheme,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _calculateMilestones(dynamic progressState) {
    final milestones = <Map<String, dynamic>>[];

    final videosWatched = progressState.watchHistory.length;
    final currentStreak = progressState.currentStreak;
    final completedVideos = progressState.watchHistory.where((dynamic p) => p.completed == true).length;

    // Video milestones
    final videoMilestones = [5, 10, 25, 50, 100, 250, 500];
    for (final milestone in videoMilestones) {
      if (videosWatched >= milestone) {
        milestones.add({
          'icon': Icons.video_library,
          'title': '$milestone Videos Watched',
          'description': 'Watched $milestone videos',
          'color': Colors.blue,
          'achieved': true,
        });
      } else if (milestones.where((m) => m['icon'] == Icons.video_library).isEmpty) {
        // Show next video milestone
        final progress = (videosWatched / milestone * 100).toInt();
        milestones.add({
          'icon': Icons.video_library,
          'title': '$milestone Videos',
          'description': '$videosWatched / $milestone videos',
          'color': Colors.blue,
          'achieved': false,
          'progress': progress / 100,
        });
        break;
      }
    }

    // Streak milestones
    final streakMilestones = [3, 7, 14, 30, 60, 100];
    for (final milestone in streakMilestones) {
      if (currentStreak >= milestone) {
        milestones.add({
          'icon': Icons.local_fire_department,
          'title': '$milestone Day Streak',
          'description': 'Maintained $milestone day streak',
          'color': Colors.deepOrange,
          'achieved': true,
        });
      } else if (milestones.where((m) => m['icon'] == Icons.local_fire_department).isEmpty) {
        // Show next streak milestone
        final progress = (currentStreak / milestone * 100).toInt();
        milestones.add({
          'icon': Icons.local_fire_department,
          'title': '$milestone Day Streak',
          'description': '$currentStreak / $milestone days',
          'color': Colors.deepOrange,
          'achieved': false,
          'progress': progress / 100,
        });
        break;
      }
    }

    // Completion milestones
    final completionMilestones = [5, 10, 25, 50, 100];
    for (final milestone in completionMilestones) {
      if (completedVideos >= milestone) {
        milestones.add({
          'icon': Icons.check_circle,
          'title': '$milestone Videos Completed',
          'description': 'Completed $milestone videos',
          'color': Colors.green,
          'achieved': true,
        });
      } else if (milestones.where((m) => m['icon'] == Icons.check_circle).isEmpty) {
        // Show next completion milestone
        final progress = (completedVideos / milestone * 100).toInt();
        milestones.add({
          'icon': Icons.check_circle,
          'title': '$milestone Completions',
          'description': '$completedVideos / $milestone videos',
          'color': Colors.green,
          'achieved': false,
          'progress': progress / 100,
        });
        break;
      }
    }

    // Show max 3 most recent or next milestones
    return milestones.take(3).toList();
  }

  Widget _buildMilestoneItem(
    BuildContext context,
    Map<String, dynamic> milestone,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final isAchieved = milestone['achieved'] as bool;
    final color = milestone['color'] as Color;
    final progress = milestone['progress'] as double?;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: isAchieved ? color.withValues(alpha: 0.2) : colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(
              milestone['icon'] as IconData,
              color: isAchieved ? color : colorScheme.onSurface.withValues(alpha: 0.4),
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isAchieved
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    if (isAchieved)
                      Icon(
                        Icons.verified,
                        color: color,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  milestone['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                // Progress bar for unachieved milestones
                if (!isAchieved && progress != null) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
