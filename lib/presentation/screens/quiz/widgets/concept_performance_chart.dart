import 'package:flutter/material.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'dart:math' as math;

/// Concept Performance Chart Widget
///
/// Displays visual representation of performance across different concepts.
/// Shows horizontal bar chart with concept names and accuracy percentages.
class ConceptPerformanceChart extends StatelessWidget {
  final Map<String, ConceptScore> conceptScores;
  final double height;

  const ConceptPerformanceChart({
    super.key,
    required this.conceptScores,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (conceptScores.isEmpty) {
      return _buildEmptyState(context);
    }

    // Sort concepts by percentage (lowest first to highlight areas needing improvement)
    final sortedConcepts = conceptScores.entries.toList()
      ..sort((a, b) => a.value.percentage.compareTo(b.value.percentage));

    return Container(
      height: height,
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: math.min(sortedConcepts.length, 5), // Show max 5 concepts
        separatorBuilder: (context, index) => const SizedBox(
          height: AppTheme.spacingSm,
        ),
        itemBuilder: (context, index) {
          final entry = sortedConcepts[index];
          return _buildConceptBar(
            context: context,
            concept: entry.key,
            score: entry.value,
          );
        },
      ),
    );
  }

  /// Build empty state when no concept data available
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48,
              color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'No concept analysis available',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual concept bar
  Widget _buildConceptBar({
    required BuildContext context,
    required String concept,
    required ConceptScore score,
  }) {
    final percentage = score.percentage;
    final color = _getColorForPercentage(percentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Concept name and score
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                concept,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              '${score.correct}/${score.total}',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Text(
                '${percentage.toInt()}%',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Progress bar
        Stack(
          children: [
            // Background bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
            ),

            // Progress bar
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
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
        ),
      ],
    );
  }

  /// Get color based on performance percentage
  Color _getColorForPercentage(double percentage) {
    if (percentage >= 80) {
      return AppTheme.successColor;
    } else if (percentage >= 60) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }
}

/// Alternative chart widget - Circular concept performance
///
/// Shows concepts in a circular/radial format (pie chart style)
class ConceptPerformancePieChart extends StatelessWidget {
  final Map<String, ConceptScore> conceptScores;
  final double size;

  const ConceptPerformancePieChart({
    super.key,
    required this.conceptScores,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (conceptScores.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            Icons.pie_chart_outline,
            size: size * 0.3,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return CustomPaint(
      size: Size(size, size),
      painter: _ConceptPiePainter(
        conceptScores: conceptScores,
      ),
    );
  }
}

/// Custom painter for pie chart
class _ConceptPiePainter extends CustomPainter {
  final Map<String, ConceptScore> conceptScores;

  _ConceptPiePainter({required this.conceptScores});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2; // Start from top

    for (final entry in conceptScores.entries) {
      final percentage = entry.value.percentage;
      final sweepAngle = (percentage / 100) * 2 * math.pi;

      final paint = Paint()
        ..color = _getColorForPercentage(percentage)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw white circle in center to create donut effect
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Color _getColorForPercentage(double percentage) {
    if (percentage >= 80) {
      return AppTheme.successColor;
    } else if (percentage >= 60) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }
}

/// Simple mini chart for concept overview (used in cards)
class ConceptMiniChart extends StatelessWidget {
  final ConceptScore score;
  final double height;

  const ConceptMiniChart({
    super.key,
    required this.score,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = score.percentage;
    final color = _getColorForPercentage(percentage);

    return Container(
      height: height,
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            percentage >= 80
                ? Icons.check_circle
                : percentage >= 60
                    ? Icons.info
                    : Icons.trending_up,
            size: 20,
            color: color,
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // Progress bar
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // Percentage
          Text(
            '${percentage.toInt()}%',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage >= 80) {
      return AppTheme.successColor;
    } else if (percentage >= 60) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }
}
