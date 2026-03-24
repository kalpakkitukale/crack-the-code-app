import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';

/// Milestone celebration dialog
///
/// Shown when the user reaches 25%, 50%, 75%, or 100% completion
/// of their learning path.
class MilestoneDialog extends StatelessWidget {
  final int percentage; // 25, 50, 75, or 100
  final LearningPath path;
  final VoidCallback onContinue;

  const MilestoneDialog({
    super.key,
    required this.percentage,
    required this.path,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            _buildMilestoneIcon(),
            const SizedBox(height: AppTheme.spacingMd),

            // Title
            Text(
              _getMilestoneTitle(),
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingSm),

            // Message
            Text(
              _getMilestoneMessage(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Stats card
            _buildStatsCard(context),
            const SizedBox(height: AppTheme.spacingLg),

            // Continue button
            FilledButton.icon(
              onPressed: onContinue,
              icon: const Icon(Icons.arrow_forward),
              label: Text(_getContinueButtonText()),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: _getMilestoneColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneIcon() {
    final icon = _getMilestoneEmoji();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Text(
            icon,
            style: const TextStyle(fontSize: 64),
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          children: [
            _buildStat(
              context,
              'Modules completed',
              '${path.completedNodes}/${path.totalNodes}',
              Icons.check_circle,
            ),
            const Divider(height: AppTheme.spacingMd),
            _buildStat(
              context,
              'Average score',
              '${_calculateAvgScore()}%',
              Icons.star,
            ),
            const Divider(height: AppTheme.spacingMd),
            _buildStat(
              context,
              'Time remaining',
              path.formattedEstimatedTime,
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: context.colorScheme.primary,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _getMilestoneEmoji() {
    switch (percentage) {
      case 25:
        return '🥉'; // Bronze medal
      case 50:
        return '🥈'; // Silver medal
      case 75:
        return '🥇'; // Gold medal
      case 100:
        return '🏆'; // Trophy
      default:
        return '⭐'; // Star
    }
  }

  String _getMilestoneTitle() {
    switch (percentage) {
      case 25:
        return 'Great Start!';
      case 50:
        return 'Halfway There!';
      case 75:
        return 'Almost Done!';
      case 100:
        return 'Foundation Complete!';
      default:
        return 'Keep Going!';
    }
  }

  String _getMilestoneMessage() {
    switch (percentage) {
      case 25:
        return 'You\'re building a strong foundation. Keep up the momentum!';
      case 50:
        return 'Your dedication is paying off! You\'re making excellent progress.';
      case 75:
        return 'The finish line is in sight! You\'re doing amazing.';
      case 100:
        return 'Congratulations! You\'re ready for the next level.';
      default:
        return 'Keep up the excellent work!';
    }
  }

  String _getContinueButtonText() {
    return percentage == 100 ? 'Finish Path' : 'Continue Learning';
  }

  Color _getMilestoneColor() {
    switch (percentage) {
      case 25:
        return const Color(0xFFCD7F32); // Bronze
      case 50:
        return const Color(0xFFC0C0C0); // Silver
      case 75:
        return const Color(0xFFFFD700); // Gold
      case 100:
        return AppTheme.successColor;
      default:
        return AppTheme.successColor;
    }
  }

  int _calculateAvgScore() {
    final completedNodesWithScore = path.nodes
        .where((n) => n.completed && n.scorePercentage != null)
        .toList();

    if (completedNodesWithScore.isEmpty) return 0;

    final totalScore = completedNodesWithScore.fold<double>(
      0.0,
      (sum, node) => sum + (node.scorePercentage ?? 0.0),
    );

    return (totalScore / completedNodesWithScore.length).round();
  }
}
