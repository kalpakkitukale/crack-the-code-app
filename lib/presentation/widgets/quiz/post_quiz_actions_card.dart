import 'package:flutter/material.dart';
import 'package:streamshaala/core/config/segment_config.dart';

/// Post-quiz action card providing clear next steps based on performance
/// Shows different options for passed vs not-passed scenarios
class PostQuizActionsCard extends StatelessWidget {
  final bool passed;
  final double scorePercentage;
  final VoidCallback? onReviewAnswers;
  final VoidCallback? onNextTopic;
  final VoidCallback? onTakeAnotherQuiz;
  final VoidCallback? onWatchVideos;
  final VoidCallback? onRetryQuiz;
  final VoidCallback? onContinuePath;
  final bool isInLearningPath;

  const PostQuizActionsCard({
    super.key,
    required this.passed,
    required this.scorePercentage,
    this.onReviewAnswers,
    this.onNextTopic,
    this.onTakeAnotherQuiz,
    this.onWatchVideos,
    this.onRetryQuiz,
    this.onContinuePath,
    this.isInLearningPath = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isJunior = SegmentConfig.isJunior;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: passed
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    passed ? Icons.celebration : Icons.lightbulb_outline,
                    color: passed ? Colors.green.shade700 : Colors.orange.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isJunior ? "What's Next?" : 'Recommended Next Steps',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        passed
                            ? (isJunior ? 'Great job! Keep learning!' : 'Continue your learning journey')
                            : (isJunior ? "Let's try again!" : 'Build on what you learned'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Actions based on pass/fail
            if (passed) ...[
              // Passed: Review, Next Topic/Continue Path, Another Quiz
              if (onReviewAnswers != null)
                _buildActionTile(
                  context,
                  icon: Icons.visibility_outlined,
                  label: isJunior ? 'See My Answers' : 'Review Answers',
                  subtitle: isJunior ? 'Check what you got right!' : 'See explanations for all questions',
                  onTap: onReviewAnswers!,
                  color: theme.colorScheme.primary,
                ),

              if (onReviewAnswers != null) const SizedBox(height: 10),

              if (isInLearningPath && onContinuePath != null)
                _buildActionTile(
                  context,
                  icon: Icons.arrow_forward_rounded,
                  label: isJunior ? 'Keep Going!' : 'Continue Path',
                  subtitle: isJunior ? 'Go to the next lesson' : 'Continue your learning path',
                  onTap: onContinuePath!,
                  color: Colors.green.shade600,
                  isPrimary: true,
                )
              else if (onNextTopic != null)
                _buildActionTile(
                  context,
                  icon: Icons.skip_next_rounded,
                  label: isJunior ? 'Next Lesson' : 'Next Topic',
                  subtitle: isJunior ? 'Learn something new!' : 'Continue to the next topic',
                  onTap: onNextTopic!,
                  color: Colors.green.shade600,
                  isPrimary: true,
                ),

              if ((isInLearningPath && onContinuePath != null) || onNextTopic != null)
                const SizedBox(height: 10),

              if (onTakeAnotherQuiz != null)
                _buildActionTile(
                  context,
                  icon: Icons.quiz_outlined,
                  label: isJunior ? 'More Quizzes!' : 'Take Another Quiz',
                  subtitle: isJunior ? 'Practice makes perfect' : 'Test another topic',
                  onTap: onTakeAnotherQuiz!,
                  color: Colors.purple.shade600,
                ),
            ] else ...[
              // Not Passed: Review, Watch Videos, Retry
              if (onReviewAnswers != null)
                _buildActionTile(
                  context,
                  icon: Icons.visibility_outlined,
                  label: isJunior ? 'See My Answers' : 'Review Answers',
                  subtitle: isJunior ? 'Learn from mistakes!' : 'Understand where you went wrong',
                  onTap: onReviewAnswers!,
                  color: theme.colorScheme.primary,
                ),

              if (onReviewAnswers != null) const SizedBox(height: 10),

              if (onWatchVideos != null)
                _buildActionTile(
                  context,
                  icon: Icons.play_circle_outline,
                  label: isJunior ? 'Watch Videos Again' : 'Review Topic Videos',
                  subtitle: isJunior ? 'Watch and learn more!' : 'Revisit the lesson content',
                  onTap: onWatchVideos!,
                  color: Colors.blue.shade600,
                  isPrimary: true,
                ),

              if (onWatchVideos != null) const SizedBox(height: 10),

              if (onRetryQuiz != null)
                _buildActionTile(
                  context,
                  icon: Icons.refresh_rounded,
                  label: isJunior ? 'Try Again!' : 'Retry Quiz',
                  subtitle: isJunior ? 'You can do it!' : 'Take the quiz again when ready',
                  onTap: onRetryQuiz!,
                  color: Colors.orange.shade600,
                ),
            ],

            // Encouragement message for juniors
            if (isJunior) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: passed
                      ? Colors.green.shade50
                      : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: passed
                        ? Colors.green.shade200
                        : Colors.amber.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      passed ? '🌟' : '💪',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        passed
                            ? 'Amazing work! You earned ${_getStarsEarned()} stars!'
                            : "Don't give up! Every try makes you smarter!",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: passed
                              ? Colors.green.shade800
                              : Colors.amber.shade900,
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

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: isPrimary
          ? color.withValues(alpha: 0.1)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPrimary
                  ? color.withValues(alpha: 0.4)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: isPrimary ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? color.withValues(alpha: 0.2)
                      : color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPrimary ? color : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: isPrimary
                    ? color
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getStarsEarned() {
    if (scorePercentage >= 90) return 3;
    if (scorePercentage >= 75) return 2;
    return 1;
  }
}
