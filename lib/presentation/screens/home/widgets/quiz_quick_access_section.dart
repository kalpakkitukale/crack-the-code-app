import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/constants/route_constants.dart';

/// Quiz Quick Access Section
/// Provides quick navigation to quiz history and statistics
class QuizQuickAccessSection extends StatelessWidget {
  const QuizQuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz Performance',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Quick Access Cards in Row
        Row(
          children: [
            // Quiz History Card
            Expanded(
              child: _QuickAccessCard(
                icon: Icons.history,
                title: 'Quiz History',
                subtitle: 'View all quizzes',
                gradientColors: [
                  context.colorScheme.primaryContainer,
                  context.colorScheme.primaryContainer.withValues(alpha: 0.7),
                ],
                iconColor: context.colorScheme.primary,
                onTap: () => context.push(RouteConstants.quizHistory),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Quiz Statistics Card
            Expanded(
              child: _QuickAccessCard(
                icon: Icons.analytics_outlined,
                title: 'Statistics',
                subtitle: 'Track progress',
                gradientColors: [
                  context.colorScheme.secondaryContainer,
                  context.colorScheme.secondaryContainer.withValues(alpha: 0.7),
                ],
                iconColor: context.colorScheme.secondary,
                onTap: () => context.push(RouteConstants.quizStatistics),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Quick Access Card Widget
class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Title and Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
