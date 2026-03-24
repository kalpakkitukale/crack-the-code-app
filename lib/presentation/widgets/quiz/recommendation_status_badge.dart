/// Badge widget for displaying recommendation status
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendation_status.dart';

/// Displays recommendation status with color-coded styling
class RecommendationStatusBadge extends StatelessWidget {
  final RecommendationStatus status;
  final bool compact;
  final bool showIcon;

  const RecommendationStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final icon = _getStatusIcon(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppTheme.spacing6 : AppTheme.spacingSm + AppTheme.spacingXs,
        vertical: compact ? AppTheme.spacingXxs + 1 : AppTheme.spacingXs + 1,
      ),
      decoration: BoxDecoration(
        color: AppTheme.getStatusBackgroundColor(status, brightness),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: AppTheme.getStatusBorderColor(status),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              size: compact ? AppTheme.spacing12 : AppTheme.spacing12 + 2,
              color: AppTheme.getStatusIconColor(status),
            ),
            SizedBox(width: compact ? AppTheme.spacingXxs + 1 : AppTheme.spacingXs + 1),
          ],
          Text(
            status.displayText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.getStatusTextColor(status),
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.none:
        return Icons.check_circle;
      case RecommendationStatus.available:
        return Icons.fiber_new;
      case RecommendationStatus.viewed:
        return Icons.visibility;
      case RecommendationStatus.inProgress:
        return Icons.play_circle_outline;
      case RecommendationStatus.completed:
        return Icons.check_circle;
      case RecommendationStatus.outdated:
        return Icons.schedule;
    }
  }
}

/// Progress indicator for learning path completion
class LearningPathProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final bool showPercentage;

  const LearningPathProgressIndicator({
    super.key,
    required this.progress,
    this.color,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final percentage = (progress * 100).round();

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: effectiveColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
              minHeight: AppTheme.spacing6,
            ),
          ),
        ),
        if (showPercentage) ...[
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            '$percentage%',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: effectiveColor,
            ),
          ),
        ],
      ],
    );
  }
}
