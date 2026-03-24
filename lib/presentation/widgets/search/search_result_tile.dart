import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/search/search_result.dart';

/// A tile widget for displaying search results
class SearchResultTile extends StatelessWidget {
  final SearchResult result;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm + 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getBadgeColor(result.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(
                _getIcon(result.type),
                color: _getBadgeColor(result.type),
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      _buildBadge(result.type, theme),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Subtitle
                  Text(
                    result.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Additional info for videos
                  if (result.type == SearchResultType.video &&
                      (result.duration != null || result.channelName != null))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          if (result.duration != null) ...[
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              result.duration!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                          if (result.duration != null && result.channelName != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '|',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          if (result.channelName != null)
                            Expanded(
                              child: Text(
                                result.channelName!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(SearchResultType type, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _getBadgeColor(type),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      ),
      child: Text(
        type.displayName,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getIcon(SearchResultType type) {
    switch (type) {
      case SearchResultType.subject:
        return Icons.book;
      case SearchResultType.chapter:
        return Icons.library_books;
      case SearchResultType.topic:
        return Icons.topic;
      case SearchResultType.video:
        return Icons.play_circle;
    }
  }

  Color _getBadgeColor(SearchResultType type) {
    switch (type) {
      case SearchResultType.subject:
        return const Color(0xFF2196F3); // Blue
      case SearchResultType.chapter:
        return const Color(0xFF4CAF50); // Green
      case SearchResultType.topic:
        return const Color(0xFFFF9800); // Orange
      case SearchResultType.video:
        return const Color(0xFFF44336); // Red
    }
  }
}

/// Skeleton loading widget for search results
class SearchResultTileSkeleton extends StatelessWidget {
  const SearchResultTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm + 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),

          // Content placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 150,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
