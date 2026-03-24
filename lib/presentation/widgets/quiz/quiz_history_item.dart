import 'package:flutter/material.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/extensions/datetime_extensions.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/utils/semantic_colors.dart';
import 'package:streamshaala/domain/entities/pedagogy/recommendation_status.dart';
import 'package:streamshaala/domain/entities/quiz/quiz.dart';
import 'package:streamshaala/presentation/widgets/quiz/assessment_type_badge.dart';
import 'package:streamshaala/presentation/widgets/quiz/quiz_breadcrumb.dart';
import 'package:streamshaala/presentation/widgets/quiz/recommendations_indicator.dart';

/// QuizHistoryItem - Individual quiz history list item
///
/// Displays quiz attempt information with:
/// - Subject icon and name
/// - Date/time (relative + absolute)
/// - Color-coded score badge
/// - Quiz level indicator
/// - Time spent
/// - View details button
class QuizHistoryItem extends StatelessWidget {
  final String quizName;
  final String subjectName;
  final QuizLevel quizLevel;
  final DateTime completedAt;
  final double scorePercentage;
  final int correctAnswers;
  final int totalQuestions;
  final Duration timeSpent;
  final VoidCallback onViewDetails;
  final VoidCallback? onViewRecommendations;
  // Breadcrumb metadata
  final String? chapterName;
  final String? topicName;
  final String? videoTitle;
  // Recommendation metadata
  final AssessmentType? assessmentType;
  final bool hasRecommendations;
  final int? recommendationCount;
  final RecommendationStatus? recommendationStatus;

  const QuizHistoryItem({
    super.key,
    required this.quizName,
    required this.subjectName,
    required this.quizLevel,
    required this.completedAt,
    required this.scorePercentage,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    required this.onViewDetails,
    this.onViewRecommendations,
    this.chapterName,
    this.topicName,
    this.videoTitle,
    this.assessmentType,
    this.hasRecommendations = false,
    this.recommendationCount,
    this.recommendationStatus,
  });

  @override
  Widget build(BuildContext context) {
    final String semanticLabel = '$subjectName quiz. '
        '${_getLevelDisplayName()}. '
        '${assessmentType != null ? "${assessmentType!.displayName}. " : ""}'
        'Score: ${scorePercentage.toStringAsFixed(0)} percent. '
        '$correctAnswers out of $totalQuestions correct. '
        'Completed ${completedAt.relativeTime}. '
        'Tap to view details.';

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingXs,
          horizontal: 0,
        ),
        child: InkWell(
          onTap: onViewDetails,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Subject icon, name, and score badge
              Row(
                children: [
                  // Subject icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getSubjectColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Icon(
                      _getSubjectIcon(),
                      color: _getSubjectColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),

                  // Quiz name and breadcrumb
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges row: Quiz level chip and assessment type
                        Wrap(
                          spacing: AppTheme.spacingXs,
                          runSpacing: AppTheme.spacingXs,
                          children: [
                            // Quiz level chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingSm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusRound,
                                ),
                              ),
                              child: Text(
                                _getLevelDisplayName(),
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Assessment type badge (if available)
                            if (assessmentType != null)
                              AssessmentTypeBadge(
                                type: assessmentType!,
                                compact: true,
                                showIcon: true,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        // Breadcrumb showing quiz context hierarchy
                        QuizBreadcrumbCompact(
                          level: quizLevel,
                          subjectName: subjectName,
                          chapterName: chapterName,
                          topicName: topicName,
                          videoTitle: videoTitle,
                        ),
                        // Recommendations indicator (if available)
                        if (hasRecommendations &&
                            recommendationCount != null &&
                            recommendationStatus != null) ...[
                          const SizedBox(height: AppTheme.spacingXs),
                          GestureDetector(
                            onTap: onViewRecommendations,
                            child: RecommendationsIndicatorCompact(
                              recommendationCount: recommendationCount!,
                              status: recommendationStatus!,
                              assessmentType:
                                  assessmentType ?? AssessmentType.practice,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),

                  // Score badge
                  _buildScoreBadge(context),
                ],
              ),

              const SizedBox(height: AppTheme.spacingMd),
              const Divider(height: 1),
              const SizedBox(height: AppTheme.spacingMd),

              // Footer: Date, time spent, and view details
              Row(
                children: [
                  // Date with relative and absolute time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppTheme.spacingXs),
                            Text(
                              completedAt.relativeTime,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          completedAt.formatDateTime,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Time spent
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppTheme.spacingXs),
                          Text(
                            _formatDuration(timeSpent),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Details',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: context.colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  /// Build color-coded score badge
  Widget _buildScoreBadge(BuildContext context) {
    final color = _getScoreColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${scorePercentage.toInt()}%',
            style: context.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$correctAnswers/$totalQuestions',
            style: context.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// Get score color based on percentage
  Color _getScoreColor() {
    return SemanticColors.getScoreColor(scorePercentage);
  }

  /// Get subject color based on name
  Color _getSubjectColor() {
    return SemanticColors.getSubjectColor(subjectName);
  }

  /// Get subject icon based on name
  IconData _getSubjectIcon() {
    return SemanticColors.getSubjectIcon(subjectName);
  }

  /// Get quiz level display name
  String _getLevelDisplayName() {
    switch (quizLevel) {
      case QuizLevel.video:
        return 'Video Quiz';
      case QuizLevel.topic:
        return 'Topic Quiz';
      case QuizLevel.chapter:
        return 'Chapter Quiz';
      case QuizLevel.subject:
        return 'Subject Quiz';
    }
  }

  /// Format duration for display
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
