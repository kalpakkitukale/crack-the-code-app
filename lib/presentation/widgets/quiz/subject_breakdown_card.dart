import 'package:flutter/material.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/utils/semantic_colors.dart';

/// SubjectBreakdownCard - Subject performance breakdown card
///
/// Displays performance statistics for a specific subject:
/// - Subject name with themed icon and color
/// - Total attempts
/// - Average score
/// - Best score
/// - Progress indicator
/// - View details button
class SubjectBreakdownCard extends StatelessWidget {
  final String subjectName;
  final int totalAttempts;
  final double averageScore;
  final double bestScore;
  final Color? subjectColor;
  final IconData? subjectIcon;
  final VoidCallback? onViewDetails;

  const SubjectBreakdownCard({
    super.key,
    required this.subjectName,
    required this.totalAttempts,
    required this.averageScore,
    required this.bestScore,
    this.subjectColor,
    this.subjectIcon,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = subjectColor ?? _getSubjectColor(subjectName);
    final effectiveIcon = subjectIcon ?? _getSubjectIcon(subjectName);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewDetails,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                effectiveColor.withValues(alpha: 0.05),
                context.colorScheme.surface,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with subject icon and name
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: effectiveColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Subject icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: effectiveColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: Icon(
                        effectiveIcon,
                        color: effectiveColor,
                        size: 28,
                        semanticLabel: subjectName,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),

                    // Subject name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subjectName,
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: effectiveColor,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXs),
                          Text(
                            '$totalAttempts ${totalAttempts == 1 ? 'attempt' : 'attempts'}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // View details button
                    if (onViewDetails != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 20),
                        onPressed: onViewDetails,
                        tooltip: 'View Details',
                        color: effectiveColor,
                      ),
                  ],
                ),
              ),

              // Performance statistics
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Average score
                    _buildStatRow(
                      context: context,
                      label: 'Average Score',
                      value: '${averageScore.toStringAsFixed(1)}%',
                      icon: Icons.analytics,
                      color: effectiveColor,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Progress bar for average score
                    _buildProgressBar(
                      context: context,
                      progress: averageScore / 100,
                      color: effectiveColor,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    const Divider(height: 1),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Best score
                    _buildStatRow(
                      context: context,
                      label: 'Best Score',
                      value: '${bestScore.toStringAsFixed(1)}%',
                      icon: Icons.emoji_events,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Performance indicator
                    _buildPerformanceIndicator(context, averageScore),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build stat row with icon, label, and value
  Widget _buildStatRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Build progress bar
  Widget _buildProgressBar({
    required BuildContext context,
    required double progress,
    required Color color,
  }) {
    return Stack(
      children: [
        // Background
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          ),
        ),
        // Progress
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusRound),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build performance indicator chip
  Widget _buildPerformanceIndicator(BuildContext context, double score) {
    String label;
    IconData icon;
    Color color;

    if (score >= 90) {
      label = 'Excellent';
      icon = Icons.star;
      color = const Color(0xFF2E7D32); // Deep green
    } else if (score >= 75) {
      label = 'Good';
      icon = Icons.thumb_up;
      color = AppTheme.successColor;
    } else if (score >= 60) {
      label = 'Average';
      icon = Icons.trending_up;
      color = AppTheme.warningColor;
    } else {
      label = 'Needs Practice';
      icon = Icons.school;
      color = AppTheme.errorColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppTheme.spacingXs),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Get subject color based on name
  static Color _getSubjectColor(String subjectName) {
    return SemanticColors.getSubjectColor(subjectName);
  }

  /// Get subject icon based on name
  static IconData _getSubjectIcon(String subjectName) {
    return SemanticColors.getSubjectIcon(subjectName);
  }
}

/// SubjectBreakdownCardCompact - Compact version for grid layouts
class SubjectBreakdownCardCompact extends StatelessWidget {
  final String subjectName;
  final int totalAttempts;
  final double averageScore;
  final VoidCallback? onTap;

  const SubjectBreakdownCardCompact({
    super.key,
    required this.subjectName,
    required this.totalAttempts,
    required this.averageScore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = SubjectBreakdownCard._getSubjectColor(subjectName);
    final icon = SubjectBreakdownCard._getSubjectIcon(subjectName);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Subject name
              Text(
                subjectName,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingXs),

              // Average score
              Text(
                '${averageScore.toStringAsFixed(0)}%',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),

              // Attempts count
              Text(
                '$totalAttempts ${totalAttempts == 1 ? 'attempt' : 'attempts'}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
