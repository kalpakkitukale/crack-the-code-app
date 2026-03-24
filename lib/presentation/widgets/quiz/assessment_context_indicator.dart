import 'package:flutter/material.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// A visual indicator widget that displays the current assessment type context.
///
/// This widget clearly communicates to users whether they are taking a:
/// - Readiness Check (PRE-assessment): Diagnostic before learning
/// - Knowledge Check (POST-assessment): Validation after learning
///
/// The widget adapts to different display modes:
/// - [AssessmentContextDisplayMode.badge]: Compact chip for app bars
/// - [AssessmentContextDisplayMode.header]: Full header with description
/// - [AssessmentContextDisplayMode.banner]: Prominent banner for emphasis
class AssessmentContextIndicator extends StatelessWidget {
  /// The type of assessment being displayed.
  final AssessmentType assessmentType;

  /// The subject name for context (optional).
  final String? subjectName;

  /// Display mode for the indicator.
  final AssessmentContextDisplayMode displayMode;

  /// Whether to show the helper text.
  final bool showHelperText;

  /// Whether the widget is in a dark context (e.g., on colored background).
  final bool isDarkContext;

  /// Callback when the info button is tapped (for expandable details).
  final VoidCallback? onInfoTap;

  const AssessmentContextIndicator({
    super.key,
    required this.assessmentType,
    this.subjectName,
    this.displayMode = AssessmentContextDisplayMode.badge,
    this.showHelperText = false,
    this.isDarkContext = false,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (displayMode) {
      case AssessmentContextDisplayMode.badge:
        return _buildBadge(context);
      case AssessmentContextDisplayMode.header:
        return _buildHeader(context);
      case AssessmentContextDisplayMode.banner:
        return _buildBanner(context);
      case AssessmentContextDisplayMode.minimal:
        return _buildMinimal(context);
    }
  }

  /// Builds a compact badge for use in app bars or tight spaces.
  Widget _buildBadge(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? assessmentType.backgroundColorDark
        : assessmentType.backgroundColor;
    final textColor = isDarkContext
        ? Colors.white
        : assessmentType.primaryColor;
    final borderColor = isDarkContext
        ? Colors.white.withValues(alpha: 0.3)
        : assessmentType.borderColor;

    return Semantics(
      label: assessmentType.semanticLabel,
      child: Tooltip(
        message: assessmentType.description,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingSm,
            vertical: AppTheme.spacingXs,
          ),
          decoration: BoxDecoration(
            color: isDarkContext
                ? Colors.white.withValues(alpha: 0.15)
                : bgColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusRound),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                assessmentType.icon,
                size: 14,
                color: textColor,
              ),
              const SizedBox(width: AppTheme.spacingXs),
              Text(
                assessmentType.shortLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a minimal inline indicator.
  Widget _buildMinimal(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDarkContext
        ? Colors.white.withValues(alpha: 0.9)
        : assessmentType.primaryColor;

    return Semantics(
      label: assessmentType.semanticLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            assessmentType.icon,
            size: 16,
            color: textColor,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Text(
            assessmentType.displayName,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a full header section with title, subtitle, and optional helper text.
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? assessmentType.backgroundColorDark
        : assessmentType.backgroundColor;

    return Semantics(
      label: assessmentType.semanticLabel,
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: assessmentType.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Icon in colored circle
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: assessmentType.primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    assessmentType.iconFilled,
                    size: 20,
                    color: assessmentType.primaryColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                // Title and subject
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessmentType.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: assessmentType.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subjectName != null)
                        Text(
                          subjectName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                // Info button
                if (onInfoTap != null)
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: assessmentType.primaryColor,
                      size: 20,
                    ),
                    onPressed: onInfoTap,
                    tooltip: 'More information',
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            // Subtitle
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              assessmentType.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            // Helper text
            if (showHelperText) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: assessmentType.primaryColor,
                    ),
                    const SizedBox(width: AppTheme.spacingXs),
                    Expanded(
                      child: Text(
                        assessmentType.helperText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a prominent banner for maximum visibility.
  Widget _buildBanner(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: assessmentType.semanticLabel,
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              assessmentType.primaryColor,
              assessmentType.primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              Icon(
                assessmentType.iconFilled,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      assessmentType.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      assessmentType.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (onInfoTap != null)
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onInfoTap,
                  tooltip: 'What is this?',
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Display modes for the assessment context indicator.
enum AssessmentContextDisplayMode {
  /// Compact badge for app bars and tight spaces.
  badge,

  /// Full header with icon, title, subtitle, and optional helper text.
  header,

  /// Prominent banner stretching full width.
  banner,

  /// Minimal inline text with icon.
  minimal,
}

/// A dialog that explains the assessment type in detail.
class AssessmentInfoDialog extends StatelessWidget {
  final AssessmentType assessmentType;

  const AssessmentInfoDialog({
    super.key,
    required this.assessmentType,
  });

  /// Shows the dialog with an appropriate animation.
  static Future<void> show(BuildContext context, AssessmentType type) {
    return showDialog(
      context: context,
      builder: (context) => AssessmentInfoDialog(assessmentType: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: assessmentType.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              assessmentType.iconFilled,
              color: assessmentType.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Text(assessmentType.displayName),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessmentType.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: assessmentType.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: assessmentType.borderColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What to expect:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: assessmentType.primaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                _buildExpectationItem(
                  context,
                  assessmentType == AssessmentType.readiness
                      ? 'Questions cover foundational concepts'
                      : 'Questions test recently learned material',
                ),
                _buildExpectationItem(
                  context,
                  assessmentType == AssessmentType.readiness
                      ? 'Results show your starting point'
                      : 'Results confirm your understanding',
                ),
                _buildExpectationItem(
                  context,
                  assessmentType == AssessmentType.readiness
                      ? 'Get personalized learning recommendations'
                      : 'Identify topics for review if needed',
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }

  Widget _buildExpectationItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: assessmentType.primaryColor,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// An optional intro screen shown before starting an assessment.
///
/// This provides users with full context about what they're about to do.
class AssessmentIntroSheet extends StatelessWidget {
  final AssessmentType assessmentType;
  final String subjectName;
  final int questionCount;
  final int? estimatedMinutes;
  final VoidCallback onStart;
  final VoidCallback onCancel;

  const AssessmentIntroSheet({
    super.key,
    required this.assessmentType,
    required this.subjectName,
    required this.questionCount,
    this.estimatedMinutes,
    required this.onStart,
    required this.onCancel,
  });

  /// Shows the intro sheet as a modal bottom sheet.
  static Future<bool?> show(
    BuildContext context, {
    required AssessmentType assessmentType,
    required String subjectName,
    required int questionCount,
    int? estimatedMinutes,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLg),
        ),
      ),
      builder: (context) => AssessmentIntroSheet(
        assessmentType: assessmentType,
        subjectName: subjectName,
        questionCount: questionCount,
        estimatedMinutes: estimatedMinutes,
        onStart: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: assessmentType.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    assessmentType.iconFilled,
                    size: 32,
                    color: assessmentType.primaryColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessmentType.displayName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: assessmentType.primaryColor,
                        ),
                      ),
                      Text(
                        subjectName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Description
            Text(
              assessmentType.introMessage,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Quick stats
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest
                    : assessmentType.backgroundColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.quiz_outlined,
                    '$questionCount',
                    'Questions',
                  ),
                  if (estimatedMinutes != null)
                    _buildStatItem(
                      context,
                      Icons.timer_outlined,
                      '$estimatedMinutes',
                      'Minutes',
                    ),
                  _buildStatItem(
                    context,
                    Icons.emoji_events_outlined,
                    assessmentType == AssessmentType.readiness
                        ? 'Learn'
                        : 'Verify',
                    'Goal',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Action buttons
            ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: Text('Start ${assessmentType.shortLabel}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: assessmentType.primaryColor,
                foregroundColor: theme.colorScheme.onSecondary,
                minimumSize: const Size(double.infinity, AppTheme.minTouchTarget),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            TextButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: assessmentType.primaryColor,
        ),
        const SizedBox(height: AppTheme.spacingXs),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: assessmentType.primaryColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
