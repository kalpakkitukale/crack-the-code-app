// Content Filter Indicator Widget
// Shows when content filtering is active for parental controls

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/services/content_filter_service.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Content Filter Indicator
/// Shows a subtle indicator when content filtering is active
/// Can be added to app bars or screen headers
class ContentFilterIndicator extends ConsumerWidget {
  /// Whether to show as a compact chip or expanded banner
  final bool compact;

  const ContentFilterIndicator({
    super.key,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show for Junior segment with parental controls
    if (!SegmentConfig.settings.showParentalControls) {
      return const SizedBox.shrink();
    }

    final filterService = ref.watch(contentFilterServiceProvider);

    // Don't show if filtering is not active
    if (!filterService.isFilteringActive) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return _buildCompactIndicator(context, filterService);
    } else {
      return _buildExpandedIndicator(context, filterService);
    }
  }

  Widget _buildCompactIndicator(
      BuildContext context, ContentFilterService filterService) {
    return Tooltip(
      message: filterService.filterStatusMessage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 14,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(width: 4),
            Text(
              'Filtered',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedIndicator(
      BuildContext context, ContentFilterService filterService) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt,
            size: 18,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Content Filter Active',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                Text(
                  filterService.filterStatusMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.info_outline,
            size: 16,
            color: AppTheme.primaryBlue.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

/// Filter Badge for use in lists or cards
/// Shows a small badge when content is being filtered
class ContentFilterBadge extends ConsumerWidget {
  final int? filteredCount;
  final int? totalCount;

  const ContentFilterBadge({
    super.key,
    this.filteredCount,
    this.totalCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show for Junior segment
    if (!SegmentConfig.settings.showParentalControls) {
      return const SizedBox.shrink();
    }

    final filterService = ref.watch(contentFilterServiceProvider);

    if (!filterService.isFilteringActive) {
      return const SizedBox.shrink();
    }

    // Show filtered count if provided
    String label;
    if (filteredCount != null && totalCount != null && filteredCount != totalCount) {
      label = '$filteredCount of $totalCount';
    } else {
      label = 'Filtered';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.primaryBlue,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Empty state widget for when all content is filtered
class ContentFilteredEmptyState extends StatelessWidget {
  final String contentType;
  final VoidCallback? onAdjustFilters;

  const ContentFilteredEmptyState({
    super.key,
    this.contentType = 'content',
    this.onAdjustFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.filter_alt_outlined,
                size: 40,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $contentType available',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Content filters are limiting what\'s shown.\nAsk a parent to adjust the settings.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAdjustFilters != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onAdjustFilters,
                icon: const Icon(Icons.settings),
                label: const Text('Adjust Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
