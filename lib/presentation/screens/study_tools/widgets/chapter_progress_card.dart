/// ChapterProgressCard widget for Chapter Study Hub
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Progress card showing chapter completion status
class ChapterProgressCard extends ConsumerWidget {
  final String chapterId;
  final String subjectId;
  final int videosWatched;
  final int totalVideos;
  final int flashcardsMastered;
  final int totalFlashcards;

  const ChapterProgressCard({
    super.key,
    required this.chapterId,
    required this.subjectId,
    this.videosWatched = 0,
    this.totalVideos = 0,
    this.flashcardsMastered = 0,
    this.totalFlashcards = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isJunior = SegmentConfig.isJunior;

    // Calculate overall completion
    int totalItems = totalVideos + totalFlashcards;
    int completedItems = videosWatched + flashcardsMastered;
    double completionPercentage = totalItems > 0
        ? (completedItems / totalItems * 100)
        : 0.0;

    return Container(
      padding: EdgeInsets.all(isJunior ? AppTheme.spacingLg : AppTheme.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: isJunior ? 28 : 24,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Your Progress',
                style: (isJunior
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.titleSmall)?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              // Percentage indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getProgressColor(completionPercentage),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${completionPercentage.toInt()}%',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(_getProgressColor(completionPercentage)),
              minHeight: isJunior ? 12 : 8,
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.play_circle_outline,
                  label: 'Videos',
                  value: '$videosWatched/$totalVideos',
                  color: Colors.blue,
                  isJunior: isJunior,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.style_outlined,
                  label: 'Cards',
                  value: '$flashcardsMastered/$totalFlashcards',
                  color: Colors.purple,
                  isJunior: isJunior,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    if (percentage >= 25) return Colors.amber;
    return Colors.grey;
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isJunior;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: isJunior ? 20 : 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: (isJunior
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.bodyMedium)?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
