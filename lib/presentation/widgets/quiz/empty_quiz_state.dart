import 'package:flutter/material.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// EmptyQuizState - Empty state widget for quiz screens
///
/// Displays a friendly empty state with:
/// - Illustration or icon
/// - Message
/// - Optional subtitle
/// - Call-to-action button
/// - Optional secondary action
class EmptyQuizState extends StatelessWidget {
  final EmptyStateType type;
  final String? customMessage;
  final String? customSubtitle;
  final String? customActionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  const EmptyQuizState({
    super.key,
    required this.type,
    this.customMessage,
    this.customSubtitle,
    this.customActionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyStateConfig(type);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration/Icon
            _buildIllustration(context, config),

            const SizedBox(height: AppTheme.spacingXl),

            // Message
            Text(
              customMessage ?? config.message,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacingMd),

            // Subtitle
            Text(
              customSubtitle ?? config.subtitle,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Primary action button
            if (onAction != null)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(config.actionIcon),
                label: Text(customActionLabel ?? config.actionLabel),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, AppTheme.minTouchTarget),
                  backgroundColor: config.color,
                  foregroundColor: context.colorScheme.onSecondary,
                ),
              ),

            // Secondary action button
            if (onSecondaryAction != null) ...[
              const SizedBox(height: AppTheme.spacingMd),
              TextButton.icon(
                onPressed: onSecondaryAction,
                icon: const Icon(Icons.explore),
                label: Text(
                  secondaryActionLabel ?? 'Explore Content',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build illustration based on empty state type
  Widget _buildIllustration(BuildContext context, _EmptyStateConfig config) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          ...List.generate(3, (index) {
            final size = 200.0 - (index * 40);
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: config.color.withValues(alpha: 0.1 - (index * 0.03)),
                  width: 2,
                ),
              ),
            );
          }),

          // Icon
          Icon(
            config.icon,
            size: 80,
            color: config.color,
          ),
        ],
      ),
    );
  }

  /// Get empty state configuration based on type
  _EmptyStateConfig _getEmptyStateConfig(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noHistory:
        return _EmptyStateConfig(
          icon: Icons.history_edu,
          color: AppTheme.primaryBlue,
          message: 'No quiz history yet',
          subtitle: 'Take your first quiz to see your progress and results here',
          actionLabel: 'Take First Quiz',
          actionIcon: Icons.quiz,
        );

      case EmptyStateType.noFilteredResults:
        return _EmptyStateConfig(
          icon: Icons.search_off,
          color: AppTheme.warningColor,
          message: 'No quizzes found',
          subtitle:
              'Try adjusting your filters to see more results, or clear all filters',
          actionLabel: 'Clear Filters',
          actionIcon: Icons.clear_all,
        );

      case EmptyStateType.noStatistics:
        return _EmptyStateConfig(
          icon: Icons.analytics,
          color: AppTheme.primaryGreen,
          message: 'No statistics available',
          subtitle: 'Complete some quizzes to see your performance statistics',
          actionLabel: 'Start Learning',
          actionIcon: Icons.play_arrow,
        );

      case EmptyStateType.noAchievements:
        return _EmptyStateConfig(
          icon: Icons.emoji_events,
          color: const Color(0xFFFFD700),
          message: 'No achievements yet',
          subtitle: 'Complete quizzes to unlock badges and achievements',
          actionLabel: 'View Achievements',
          actionIcon: Icons.workspace_premium,
        );

      case EmptyStateType.error:
        return _EmptyStateConfig(
          icon: Icons.error_outline,
          color: AppTheme.errorColor,
          message: 'Something went wrong',
          subtitle: 'Unable to load quiz data. Please try again',
          actionLabel: 'Retry',
          actionIcon: Icons.refresh,
        );

      case EmptyStateType.offline:
        return _EmptyStateConfig(
          icon: Icons.cloud_off,
          color: const Color(0xFF757575),
          message: 'You are offline',
          subtitle: 'Connect to the internet to access your quiz history',
          actionLabel: 'Retry Connection',
          actionIcon: Icons.wifi,
        );

      case EmptyStateType.comingSoon:
        return _EmptyStateConfig(
          icon: Icons.upcoming,
          color: const Color(0xFF9C27B0),
          message: 'Coming Soon',
          subtitle: 'This feature is under development and will be available soon',
          actionLabel: 'Go Back',
          actionIcon: Icons.arrow_back,
        );
    }
  }
}

/// EmptyQuizStateCompact - Compact version for smaller spaces
class EmptyQuizStateCompact extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;

  const EmptyQuizStateCompact({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: effectiveColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: effectiveColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// EmptyQuizStateInline - Inline version for list views
class EmptyQuizStateInline extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyQuizStateInline({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (onAction != null) ...[
            const SizedBox(width: AppTheme.spacingMd),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel ?? 'Action'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state types
enum EmptyStateType {
  noHistory,
  noFilteredResults,
  noStatistics,
  noAchievements,
  error,
  offline,
  comingSoon,
}

/// Empty state configuration
class _EmptyStateConfig {
  final IconData icon;
  final Color color;
  final String message;
  final String subtitle;
  final String actionLabel;
  final IconData actionIcon;

  const _EmptyStateConfig({
    required this.icon,
    required this.color,
    required this.message,
    required this.subtitle,
    required this.actionLabel,
    required this.actionIcon,
  });
}
