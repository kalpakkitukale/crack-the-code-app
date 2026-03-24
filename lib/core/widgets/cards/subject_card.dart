import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Assessment type enum for clarity in callbacks
enum AssessmentType {
  /// PRE-assessment: Gap analysis before learning
  preAssessment,

  /// POST-assessment: Knowledge validation after learning
  postAssessment,
}

/// Subject card widget with dual assessment support
///
/// Displays subject information with two distinct assessment paths:
/// - PRE-assessment (Gap Analysis): Primary CTA for new learners
/// - POST-assessment (Knowledge Check): Secondary CTA for validation
///
/// The card prioritizes the assessment-first learning approach while
/// maintaining accessibility to traditional content browsing.
class SubjectCard extends StatelessWidget {
  /// Subject display name (e.g., "Physics", "Chemistry")
  final String name;

  /// Subject icon (e.g., Icons.science)
  final IconData icon;

  /// Subject-specific accent color
  final Color? color;

  /// Total number of chapters in the subject
  final int? chapterCount;

  /// Number of available quizzes for post-assessment
  final int? quizCount;

  /// Learning progress (0.0 to 1.0)
  final double? progress;

  /// Callback when card body is tapped (browse chapters)
  final VoidCallback? onTap;

  /// Callback for POST-assessment (knowledge validation quiz)
  /// This is the secondary action for users who prefer video-first approach
  final VoidCallback? onQuizTap;

  /// Callback for PRE-assessment (gap analysis/readiness check)
  /// This is the PRIMARY action - recommended entry point for efficient learning
  final VoidCallback? onPreAssessmentTap;

  /// Whether to show the pre-assessment CTA
  /// Can be hidden after user has completed gap analysis
  final bool showPreAssessment;

  /// Custom label for pre-assessment button
  /// Defaults to "Start Readiness Check"
  final String? preAssessmentLabel;

  /// Whether this is a first-time interaction (shows enhanced CTA)
  final bool isNewUser;

  const SubjectCard({
    super.key,
    required this.name,
    required this.icon,
    this.color,
    this.chapterCount,
    this.quizCount,
    this.progress,
    this.onTap,
    this.onQuizTap,
    this.onPreAssessmentTap,
    this.showPreAssessment = true,
    this.preAssessmentLabel,
    this.isNewUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final subjectColor = color ?? colorScheme.primary;

    return Semantics(
      label: _buildSemanticLabel(),
      container: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isDark ? 0 : AppTheme.elevation1,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                subjectColor.withValues(alpha: isDark ? 0.15 : 0.08),
                subjectColor.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PRIMARY CTA: PRE-Assessment button at TOP (chronologically first)
              if (showPreAssessment && onPreAssessmentTap != null)
                _buildPreAssessmentButton(
                  context,
                  theme,
                  subjectColor,
                  isDark,
                ),

              // Main tappable content area (subject info)
              Expanded(
                child: _buildMainContent(
                  context,
                  theme,
                  colorScheme,
                  subjectColor,
                  isDark,
                ),
              ),

              // SECONDARY CTA: POST-Assessment badge at BOTTOM (chronologically last)
              if (onQuizTap != null)
                _buildPostAssessmentBadge(
                  theme,
                  colorScheme,
                  subjectColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the main card content (icon, title, info, progress)
  Widget _buildMainContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color subjectColor,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap!();
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppTheme.spacingXs),

            // Subject icon
            Flexible(
              child: _buildSubjectIcon(subjectColor, isDark),
            ),
            const SizedBox(height: 6),

            // Subject name
            Flexible(
              child: Text(
                name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Chapter count
            if (chapterCount != null) ...[
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  '$chapterCount ${chapterCount == 1 ? 'Chapter' : 'Chapters'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // Progress indicator (only show if has progress)
            if (progress != null && progress! > 0) ...[
              const SizedBox(height: 4),
              _buildProgressIndicator(theme, colorScheme, subjectColor),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the top row with POST-assessment badge
  Widget _buildTopRow(
    ThemeData theme,
    ColorScheme colorScheme,
    Color subjectColor,
  ) {
    if (onQuizTap == null) {
      return const SizedBox(height: 28); // Maintain layout spacing
    }

    return Align(
      alignment: Alignment.topRight,
      child: Semantics(
        label: 'Take knowledge check quiz. $quizCount quizzes available',
        button: true,
        child: Tooltip(
          message: 'Knowledge Check\n(After learning)',
          preferBelow: false,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onQuizTap!();
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusRound),
              child: Container(
                // Minimum touch target 48x48 with visual content inside
                constraints: const BoxConstraints(
                  minWidth: AppTheme.minTouchTarget,
                  minHeight: 28,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: subjectColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                        border: Border.all(
                          color: subjectColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fact_check_outlined,
                            size: 14,
                            color: subjectColor.withValues(alpha: 0.8),
                          ),
                          if (quizCount != null && quizCount! > 0) ...[
                            const SizedBox(width: 3),
                            Text(
                              '$quizCount',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: subjectColor.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the POST-assessment badge at bottom (secondary action - after learning)
  Widget _buildPostAssessmentBadge(
    ThemeData theme,
    ColorScheme colorScheme,
    Color subjectColor,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: subjectColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Semantics(
        label: 'Take knowledge check quiz after learning. $quizCount quizzes available',
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onQuizTap!();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXs,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 14,
                    color: subjectColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Knowledge Check',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subjectColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  if (quizCount != null && quizCount! > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: subjectColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: subjectColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$quizCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: subjectColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the subject icon with background
  Widget _buildSubjectIcon(Color subjectColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: subjectColor.withValues(alpha: isDark ? 0.2 : 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 28,
        color: subjectColor,
      ),
    );
  }

  /// Builds the circular progress indicator
  Widget _buildProgressIndicator(
    ThemeData theme,
    ColorScheme colorScheme,
    Color subjectColor,
  ) {
    return Flexible(
      child: SizedBox(
        height: 28,
        width: 28,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 2.5,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
            ),
            Center(
              child: Text(
                '${(progress! * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the primary PRE-assessment CTA button
  Widget _buildPreAssessmentButton(
    BuildContext context,
    ThemeData theme,
    Color subjectColor,
    bool isDark,
  ) {
    final buttonLabel = preAssessmentLabel ?? 'Start Readiness Check';

    return Semantics(
      label: '$buttonLabel. Recommended for identifying knowledge gaps before learning.',
      button: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // Gradient for visual emphasis
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              subjectColor,
              subjectColor.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              onPreAssessmentTap!();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSm,
                vertical: AppTheme.spacingXs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    size: 16,
                    color: _getContrastingTextColor(subjectColor),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      buttonLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _getContrastingTextColor(subjectColor),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Determines the best contrasting text color for the button
  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate relative luminance
    final luminance = backgroundColor.computeLuminance();
    // Use white text for dark backgrounds, dark text for light backgrounds
    // Threshold of 0.5 provides good contrast for most colors
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Builds the semantic label for screen readers
  String _buildSemanticLabel() {
    final buffer = StringBuffer('Subject: $name.');

    if (chapterCount != null) {
      buffer.write(' $chapterCount chapters.');
    }

    if (progress != null && progress! > 0) {
      buffer.write(' ${(progress! * 100).toInt()}% complete.');
    }

    if (showPreAssessment && onPreAssessmentTap != null) {
      buffer.write(' Start readiness check available.');
    }

    if (onQuizTap != null) {
      buffer.write(' Knowledge check quiz available.');
    }

    buffer.write(' Tap to browse chapters.');

    return buffer.toString();
  }
}

/// Helper class for subject colors
class SubjectColors {
  SubjectColors._();

  static const physics = Color(0xFF2196F3); // Blue
  static const chemistry = Color(0xFF4CAF50); // Green
  static const mathematics = Color(0xFFFF9800); // Orange
  static const biology = Color(0xFFE91E63); // Pink
  static const english = Color(0xFF9C27B0); // Purple
  static const history = Color(0xFF795548); // Brown
  static const geography = Color(0xFF00BCD4); // Cyan
  static const economics = Color(0xFFFFC107); // Amber
  static const computerScience = Color(0xFF607D8B); // Blue Grey
  static const accountancy = Color(0xFF3F51B5); // Indigo

  static Color getSubjectColor(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('physic')) return physics;
    if (name.contains('chemis')) return chemistry;
    if (name.contains('math')) return mathematics;
    if (name.contains('bio')) return biology;
    if (name.contains('english')) return english;
    if (name.contains('history')) return history;
    if (name.contains('geo')) return geography;
    if (name.contains('eco')) return economics;
    if (name.contains('computer')) return computerScience;
    if (name.contains('account')) return accountancy;
    return const Color(0xFF2196F3); // Default blue
  }

  static IconData getSubjectIcon(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('physic')) return Icons.science;
    if (name.contains('chemis')) return Icons.biotech;
    if (name.contains('math')) return Icons.calculate;
    if (name.contains('bio')) return Icons.eco;
    if (name.contains('english')) return Icons.menu_book;
    if (name.contains('history')) return Icons.history_edu;
    if (name.contains('geo')) return Icons.public;
    if (name.contains('eco')) return Icons.trending_up;
    if (name.contains('computer')) return Icons.computer;
    if (name.contains('account')) return Icons.account_balance;
    return Icons.school; // Default icon
  }
}

/// Horizontal subject card for list views with dual assessment support
class SubjectListTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color? color;
  final int? chapterCount;
  final int? videoCount;
  final int? quizCount;
  final double? progress;
  final VoidCallback? onTap;
  final VoidCallback? onQuizTap;
  final VoidCallback? onPreAssessmentTap;
  final bool showPreAssessment;

  const SubjectListTile({
    super.key,
    required this.name,
    required this.icon,
    this.color,
    this.chapterCount,
    this.videoCount,
    this.quizCount,
    this.progress,
    this.onTap,
    this.onQuizTap,
    this.onPreAssessmentTap,
    this.showPreAssessment = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final subjectColor = color ?? colorScheme.primary;

    return Semantics(
      label: _buildSemanticLabel(),
      container: true,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        elevation: isDark ? 0 : AppTheme.elevation1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content
            ListTile(
              onTap: onTap != null
                  ? () {
                      HapticFeedback.lightImpact();
                      onTap!();
                    }
                  : null,
              contentPadding: const EdgeInsets.all(AppTheme.spacingMd),
              leading: Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: subjectColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: subjectColor,
                ),
              ),
              title: Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppTheme.spacingXs),
                  Row(
                    children: [
                      if (chapterCount != null) ...[
                        Icon(
                          Icons.menu_book,
                          size: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$chapterCount ${chapterCount == 1 ? 'Chapter' : 'Chapters'}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      if (chapterCount != null && videoCount != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '|',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      if (videoCount != null) ...[
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
                    ],
                  ),
                  if (progress != null && progress! > 0) ...[
                    const SizedBox(height: AppTheme.spacingSm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress! * 100).toInt()}% complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // POST-assessment button (secondary)
                  if (onQuizTap != null)
                    Tooltip(
                      message: 'Knowledge Check\n(After learning)',
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onQuizTap!();
                        },
                        icon: Badge(
                          isLabelVisible: quizCount != null && quizCount! > 0,
                          label: Text('$quizCount'),
                          child: Icon(
                            Icons.fact_check_outlined,
                            color: subjectColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),

            // PRE-assessment action row
            if (showPreAssessment && onPreAssessmentTap != null)
              _buildPreAssessmentRow(theme, subjectColor, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildPreAssessmentRow(
    ThemeData theme,
    Color subjectColor,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: subjectColor.withValues(alpha: isDark ? 0.15 : 0.08),
        border: Border(
          top: BorderSide(
            color: subjectColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 18,
            color: subjectColor,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Readiness Check',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: subjectColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Identify knowledge gaps before learning',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: subjectColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onPreAssessmentTap!();
            },
            style: FilledButton.styleFrom(
              backgroundColor: subjectColor,
              foregroundColor: theme.colorScheme.onSecondary,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  String _buildSemanticLabel() {
    final buffer = StringBuffer('Subject: $name.');

    if (chapterCount != null) {
      buffer.write(' $chapterCount chapters.');
    }

    if (videoCount != null) {
      buffer.write(' $videoCount videos.');
    }

    if (progress != null && progress! > 0) {
      buffer.write(' ${(progress! * 100).toInt()}% complete.');
    }

    buffer.write(' Tap to browse chapters.');

    return buffer.toString();
  }
}

/// Compact subject card for smaller displays or grid layouts
/// Optimized for space while maintaining both assessment CTAs
class SubjectCardCompact extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color? color;
  final int? chapterCount;
  final VoidCallback? onTap;
  final VoidCallback? onPreAssessmentTap;

  const SubjectCardCompact({
    super.key,
    required this.name,
    required this.icon,
    this.color,
    this.chapterCount,
    this.onTap,
    this.onPreAssessmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final subjectColor = color ?? colorScheme.primary;

    return Semantics(
      label: 'Subject: $name. ${chapterCount ?? 0} chapters. Tap to browse or take readiness check.',
      container: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isDark ? 0 : AppTheme.elevation1,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  HapticFeedback.lightImpact();
                  onTap!();
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  subjectColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  subjectColor.withValues(alpha: isDark ? 0.05 : 0.02),
                ],
              ),
            ),
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: subjectColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: subjectColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (onPreAssessmentTap != null) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 28,
                    child: TextButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onPreAssessmentTap!();
                      },
                      icon: Icon(
                        Icons.psychology_outlined,
                        size: 14,
                        color: subjectColor,
                      ),
                      label: Text(
                        'Check',
                        style: TextStyle(
                          fontSize: 11,
                          color: subjectColor,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
