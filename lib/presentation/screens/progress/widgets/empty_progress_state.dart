import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';

/// Empty Progress State Widget
/// Shows when user has no progress data yet
class EmptyProgressState extends StatelessWidget {
  const EmptyProgressState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Title
            Text(
              'Start Your Learning Journey',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Description
            Text(
              'Watch videos to start tracking your progress.\nYour stats, streaks, and achievements will appear here.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Benefits list
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What you\'ll track:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    _buildBenefit(
                      icon: Icons.video_library,
                      text: 'Videos watched and study time',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    _buildBenefit(
                      icon: Icons.local_fire_department,
                      text: 'Daily learning streaks',
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    _buildBenefit(
                      icon: Icons.school,
                      text: 'Subject progress and completion',
                      color: Colors.green,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    _buildBenefit(
                      icon: Icons.emoji_events,
                      text: 'Achievements and milestones',
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Action buttons
            Column(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    // Navigate to browse - use push to maintain navigation stack
                    context.push(RouteConstants.browse);
                  },
                  icon: const Icon(Icons.explore),
                  label: const Text('Browse Videos'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingXl,
                      vertical: AppTheme.spacingMd,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to search - use push to maintain navigation stack
                    context.push(RouteConstants.search);
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search Videos'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingXl,
                      vertical: AppTheme.spacingMd,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
