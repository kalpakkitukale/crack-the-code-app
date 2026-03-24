import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Chapter list tile widget to display chapter information
class ChapterListTile extends StatelessWidget {
  final int chapterNumber;
  final String name;
  final int? topicCount;
  final int? videoCount;
  final double? completionPercentage;
  final VoidCallback? onTap;
  final VoidCallback? onQuizTap;
  final VoidCallback? onStudyHubTap;
  final bool isLocked;

  const ChapterListTile({
    super.key,
    required this.chapterNumber,
    required this.name,
    this.topicCount,
    this.videoCount,
    this.completionPercentage,
    this.onTap,
    this.onQuizTap,
    this.onStudyHubTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
            children: [
              // Chapter number badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isLocked
                      ? colorScheme.surfaceVariant
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Center(
                  child: isLocked
                      ? Icon(
                          Icons.lock_outline,
                          color: colorScheme.onSurfaceVariant,
                        )
                      : Text(
                          '$chapterNumber',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),

              // Chapter details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter name
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isLocked
                            ? colorScheme.onSurface.withValues(alpha: 0.5)
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Topic and video count - wrapped to prevent overflow
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (topicCount != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.topic_outlined,
                                size: 14,
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$topicCount ${topicCount == 1 ? 'Topic' : 'Topics'}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        if (videoCount != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 14,
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$videoCount ${videoCount == 1 ? 'Video' : 'Videos'}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                      ],
                    ),

                    // Progress bar
                    if (completionPercentage != null &&
                        completionPercentage! > 0 &&
                        !isLocked) ...[
                      const SizedBox(height: AppTheme.spacingSm),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radiusRound),
                              child: LinearProgressIndicator(
                                value: completionPercentage! / 100,
                                minHeight: 6,
                                backgroundColor: colorScheme.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getProgressColor(colorScheme),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${completionPercentage!.toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getProgressColor(colorScheme),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Study Hub button
              if (onStudyHubTap != null && !isLocked)
                IconButton(
                  icon: Icon(
                    Icons.school,
                    color: colorScheme.tertiary,
                  ),
                  onPressed: onStudyHubTap,
                  tooltip: 'Study Hub',
                ),

              // Quiz button
              if (onQuizTap != null && !isLocked)
                IconButton(
                  icon: Icon(
                    Icons.quiz,
                    color: colorScheme.primary,
                  ),
                  onPressed: onQuizTap,
                  tooltip: 'Take Quiz',
                ),

              // Trailing icon
              Icon(
                isLocked ? Icons.lock_outline : Icons.chevron_right,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Color _getProgressColor(ColorScheme colorScheme) {
    if (completionPercentage == null) return colorScheme.primary;
    if (completionPercentage! >= 100) return AppTheme.successColor;
    if (completionPercentage! >= 50) return colorScheme.primary;
    return AppTheme.warningColor;
  }
}

/// Compact chapter tile for smaller spaces
class CompactChapterTile extends StatelessWidget {
  final int chapterNumber;
  final String name;
  final double? completionPercentage;
  final VoidCallback? onTap;

  const CompactChapterTile({
    super.key,
    required this.chapterNumber,
    required this.name,
    this.completionPercentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = completionPercentage != null && completionPercentage! >= 100;

    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingXs,
      ),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted
              ? AppTheme.successColor.withValues(alpha: 0.1)
              : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Center(
          child: isCompleted
              ? Icon(
                  Icons.check,
                  size: 18,
                  color: AppTheme.successColor,
                )
              : Text(
                  '$chapterNumber',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
        ),
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      trailing: completionPercentage != null
          ? Text(
              '${completionPercentage!.toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            )
          : null,
    );
  }
}
