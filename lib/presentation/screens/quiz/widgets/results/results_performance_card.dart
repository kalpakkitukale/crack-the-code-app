import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';

/// Card displaying performance summary with score breakdown.
class ResultsPerformanceCard extends StatelessWidget {
  final QuizResult result;
  final bool enhanced;

  const ResultsPerformanceCard({
    super.key,
    required this.result,
    this.enhanced = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          enhanced ? AppTheme.spacingLg : AppTheme.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppTheme.spacingLg),
            _PerformanceRow(
              label: 'Score',
              value: result.scoreDisplay,
              color: _getPerformanceColor(),
              icon: Icons.stars,
            ),
            const Divider(height: AppTheme.spacingLg),
            _PerformanceRow(
              label: 'Accuracy',
              value: result.percentageDisplay,
              color: _getPerformanceColor(),
              icon: Icons.percent,
            ),
            const Divider(height: AppTheme.spacingLg),
            _PerformanceRow(
              label: 'Grade',
              value: result.grade,
              color: _getPerformanceColor(),
              icon: Icons.grade,
            ),
            const Divider(height: AppTheme.spacingLg),
            _PerformanceRow(
              label: 'Status',
              value: result.passed ? 'Passed' : 'Needs Improvement',
              color: result.passed ? AppTheme.successColor : AppTheme.warningColor,
              icon: result.passed ? Icons.check_circle : Icons.refresh,
            ),
            const Divider(height: AppTheme.spacingLg),
            _PerformanceRow(
              label: 'Time Taken',
              value: result.formattedTimeTaken,
              color: context.colorScheme.primary,
              icon: Icons.access_time,
            ),
            const Divider(height: AppTheme.spacingLg),
            _PerformanceRow(
              label: 'Completed',
              value: _formatDateTime(result.evaluatedAt),
              color: context.colorScheme.onSurfaceVariant,
              icon: Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.analytics_outlined,
          color: context.colorScheme.primary,
          size: enhanced ? 28 : 24,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text(
          'Performance Summary',
          style:
              (enhanced ? context.textTheme.titleLarge : context.textTheme.titleMedium)
                  ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getPerformanceColor() {
    if (result.isExcellent) {
      return AppTheme.readinessReady;
    } else if (result.isGood) {
      return AppTheme.successColor;
    } else if (result.isAverage) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class _PerformanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _PerformanceRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
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
}
