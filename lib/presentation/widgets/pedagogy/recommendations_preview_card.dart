import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/entities/pedagogy/quiz_recommendation.dart';

/// Preview card showing top 3 recommendations from quiz results
///
/// Displays a compact summary of personalized learning recommendations
/// with option to navigate to full recommendations screen.
class RecommendationsPreviewCard extends StatelessWidget {
  final RecommendationsBundle bundle;
  final AssessmentType assessmentType;
  final VoidCallback? onViewAll;

  const RecommendationsPreviewCard({
    super.key,
    required this.bundle,
    required this.assessmentType,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get top 3 recommendations
    final topRecommendations = bundle.top3;

    if (topRecommendations.isEmpty) {
      // Perfect score - show congratulatory message
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                bundle.subtitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                bundle.encouragementMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with assessment badge and title
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: assessmentType.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Assessment type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: assessmentType.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    assessmentType.iconFilled,
                    color: assessmentType.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: assessmentType.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${bundle.totalCount} ${bundle.totalCount == 1 ? 'area' : 'areas'} to strengthen • ${bundle.formattedTotalTime}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top 3 recommendations
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            itemCount: topRecommendations.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingMd),
            itemBuilder: (context, index) {
              final recommendation = topRecommendations[index];
              return _RecommendationPreviewItem(
                recommendation: recommendation,
                assessmentType: assessmentType,
              );
            },
          ),

          // View all button
          if (bundle.totalCount > 3)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                0,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
              ),
              child: OutlinedButton(
                onPressed: onViewAll,
                style: OutlinedButton.styleFrom(
                  foregroundColor: assessmentType.primaryColor,
                  side: BorderSide(color: assessmentType.borderColor),
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('View All ${bundle.totalCount} Recommendations'),
                    const SizedBox(width: AppTheme.spacingSm),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                0,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
              ),
              child: FilledButton(
                onPressed: onViewAll,
                style: FilledButton.styleFrom(
                  backgroundColor: assessmentType.primaryColor,
                  minimumSize: const Size(double.infinity, 44),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Start Learning'),
                    SizedBox(width: AppTheme.spacingSm),
                    Icon(Icons.play_arrow, size: 18),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Individual recommendation preview item
class _RecommendationPreviewItem extends StatelessWidget {
  final QuizRecommendation recommendation;
  final AssessmentType assessmentType;

  const _RecommendationPreviewItem({
    required this.recommendation,
    required this.assessmentType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryVideo = recommendation.primaryVideo;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with severity badge and concept name
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: Row(
              children: [
                // Severity badge
                _SeverityBadge(severity: recommendation.severity),
                const SizedBox(width: AppTheme.spacingSm),
                // Concept name and mastery
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.conceptName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Mastery bar
                          Expanded(
                            child: LinearProgressIndicator(
                              value: recommendation.masteryPercentage / 100,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                _getMasteryColor(
                                  recommendation.masteryPercentage,
                                  colorScheme,
                                ),
                              ),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(
                            '${recommendation.masteryPercentage.toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Time estimate
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.formattedTimeEstimate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Video thumbnail (if available)
          if (primaryVideo != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingSm,
                0,
                AppTheme.spacingSm,
                AppTheme.spacingSm,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: primaryVideo.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      // Play overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withValues(alpha: 0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    primaryVideo.title,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    primaryVideo.durationDisplay,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Play button
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getMasteryColor(double mastery, ColorScheme colorScheme) {
    if (mastery < 30) return colorScheme.error;
    if (mastery < 50) return Colors.orange;
    if (mastery < 70) return Colors.amber;
    return colorScheme.primary;
  }
}

/// Severity badge widget
class _SeverityBadge extends StatelessWidget {
  final GapSeverity severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, icon) = _getSeverityStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            severity.displayName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getSeverityStyle() {
    switch (severity) {
      case GapSeverity.critical:
        return (const Color(0xFFD32F2F), Icons.error_outline);
      case GapSeverity.severe:
        return (const Color(0xFFEF6C00), Icons.warning_amber_outlined);
      case GapSeverity.moderate:
        return (const Color(0xFFFFA000), Icons.info_outline);
      case GapSeverity.mild:
        return (const Color(0xFF1976D2), Icons.lightbulb_outline);
    }
  }
}
