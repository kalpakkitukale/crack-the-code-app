/// Widget for displaying recommendations summary and status
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendation_status.dart';
import 'package:crack_the_code/presentation/widgets/quiz/recommendation_status_badge.dart';

/// Displays a summary indicator for available recommendations
class RecommendationsIndicator extends StatelessWidget {
  final int totalRecommendations;
  final int criticalGaps;
  final int severeGaps;
  final int estimatedMinutes;
  final RecommendationStatus status;
  final AssessmentType assessmentType;
  final VoidCallback? onTap;

  const RecommendationsIndicator({
    super.key,
    required this.totalRecommendations,
    required this.criticalGaps,
    required this.severeGaps,
    required this.estimatedMinutes,
    required this.status,
    required this.assessmentType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = assessmentType.primaryColor;
    final bgColor = isDark
        ? assessmentType.backgroundColorDark
        : assessmentType.backgroundColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withOpacity(isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and status
              Row(
                children: [
                  Icon(
                    assessmentType == AssessmentType.readiness
                        ? Icons.analytics_outlined
                        : Icons.trending_up_outlined,
                    size: 20,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getHeaderText(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ),
                  RecommendationStatusBadge(
                    status: status,
                    compact: true,
                    showIcon: false,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Summary stats
              Row(
                children: [
                  Expanded(
                    child: _StatChip(
                      icon: Icons.lightbulb_outline,
                      label: '$totalRecommendations ${totalRecommendations == 1 ? 'area' : 'areas'}',
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatChip(
                      icon: Icons.access_time,
                      label: '${estimatedMinutes}min',
                      color: accentColor,
                    ),
                  ),
                ],
              ),

              // Critical gaps warning if any
              if (criticalGaps > 0 || severeGaps > 0) ...[
                const SizedBox(height: 8),
                _GapWarning(
                  criticalGaps: criticalGaps,
                  severeGaps: severeGaps,
                ),
              ],

              // Action prompt if recommendations available
              if (status == RecommendationStatus.available ||
                  status == RecommendationStatus.viewed) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _getActionText(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: accentColor,
                    ),
                  ],
                ),
              ],

              // Learning path progress if in progress
              if (status == RecommendationStatus.inProgress) ...[
                const SizedBox(height: 10),
                Text(
                  'Continue your learning path',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ],

              // Completed message
              if (status == RecommendationStatus.completed) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Learning path completed!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getHeaderText() {
    switch (assessmentType) {
      case AssessmentType.readiness:
        return 'Gap Analysis Available';
      case AssessmentType.knowledge:
        return 'Improvement Analysis';
      case AssessmentType.practice:
        return 'Practice Recommendations';
    }
  }

  String _getActionText() {
    switch (assessmentType) {
      case AssessmentType.readiness:
        return 'Start your learning journey';
      case AssessmentType.knowledge:
        return 'Review & improve';
      case AssessmentType.practice:
        return 'View recommendations';
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _GapWarning extends StatelessWidget {
  final int criticalGaps;
  final int severeGaps;

  const _GapWarning({
    required this.criticalGaps,
    required this.severeGaps,
  });

  @override
  Widget build(BuildContext context) {
    final hasMultiple = (criticalGaps + severeGaps) > 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _getWarningText(hasMultiple),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWarningText(bool hasMultiple) {
    if (criticalGaps > 0) {
      return '$criticalGaps critical gap${hasMultiple ? 's' : ''} need${hasMultiple ? '' : 's'} attention';
    } else {
      return '$severeGaps severe gap${hasMultiple ? 's' : ''} identified';
    }
  }
}

/// Compact version for list items
class RecommendationsIndicatorCompact extends StatelessWidget {
  final int recommendationCount;
  final RecommendationStatus status;
  final AssessmentType assessmentType;

  const RecommendationsIndicatorCompact({
    super.key,
    required this.recommendationCount,
    required this.status,
    required this.assessmentType,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = assessmentType.primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.lightbulb_outline,
          size: 14,
          color: accentColor,
        ),
        const SizedBox(width: 4),
        Text(
          '$recommendationCount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 6),
        RecommendationStatusBadge(
          status: status,
          compact: true,
          showIcon: false,
        ),
      ],
    );
  }
}
