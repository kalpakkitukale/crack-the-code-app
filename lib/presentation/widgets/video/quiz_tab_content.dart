import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';

/// Quiz tab content for the video player screen
/// Shows option to take quiz and previous quiz attempts for the topic
class QuizTabContent extends ConsumerWidget {
  final String topicId;
  final String? topicName;
  final VoidCallback onStartQuiz;

  const QuizTabContent({
    super.key,
    required this.topicId,
    this.topicName,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isJunior = SegmentConfig.isCrackTheCode;

    // Load recent quiz attempts
    final historyAsync = ref.watch(recentQuizzesProvider(20));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Start Quiz Card
          _buildStartQuizCard(context, theme, isJunior),

          const SizedBox(height: 24),

          // Quiz Info Section
          _buildQuizInfoSection(context, theme, isJunior),

          const SizedBox(height: 24),

          // Previous Attempts Section
          Text(
            'Your Quiz Attempts',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          historyAsync.when(
            data: (attempts) {
              // Filter attempts for this topic
              final topicAttempts = attempts
                  .where((a) => a.topicId == topicId || a.quizId.contains(topicId))
                  .toList();

              if (topicAttempts.isEmpty) {
                return _buildNoAttemptsState(context, theme, isJunior);
              }
              return _buildAttemptsList(context, theme, topicAttempts);
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => _buildNoAttemptsState(context, theme, isJunior),
          ),
        ],
      ),
    );
  }

  Widget _buildStartQuizCard(BuildContext context, ThemeData theme, bool isJunior) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isJunior
                ? [Colors.green.shade400, Colors.green.shade600]
                : [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isJunior ? Icons.star : Icons.quiz,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isJunior ? 'Topic Quiz' : 'Knowledge Check',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isJunior
                          ? 'Show what you learned!'
                          : 'Test your understanding of this topic',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Button
              FilledButton(
                onPressed: onStartQuiz,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: isJunior ? Colors.green.shade700 : theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isJunior ? 'Start!' : 'Start Quiz',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInfoSection(BuildContext context, ThemeData theme, bool isJunior) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'About This Quiz',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            context,
            Icons.help_outline,
            'Questions',
            '5-10 questions',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.timer_outlined,
            'Time',
            isJunior ? '10 minutes' : '15 minutes',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.check_circle_outline,
            'Pass Score',
            '75% or higher',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.replay,
            'Attempts',
            'Unlimited retries',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNoAttemptsState(BuildContext context, ThemeData theme, bool isJunior) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            isJunior ? Icons.emoji_events_outlined : Icons.history,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            isJunior ? 'No quizzes yet!' : 'No attempts yet',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isJunior
                ? 'Take the quiz to earn stars!'
                : 'Take the quiz to track your progress',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsList(BuildContext context, ThemeData theme, List<QuizAttempt> attempts) {
    return Column(
      children: attempts.take(5).map((attempt) {
        return _buildAttemptTile(context, theme, attempt);
      }).toList(),
    );
  }

  Widget _buildAttemptTile(BuildContext context, ThemeData theme, QuizAttempt attempt) {
    final passed = attempt.passed;
    final scorePercent = (attempt.score * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: passed
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: passed
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: passed ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            passed ? Icons.check : Icons.refresh,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          '$scorePercent%',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: passed ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
        subtitle: Text(
          _formatDate(attempt.completedAt),
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (passed)
              const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
        onTap: () {
          // Navigate to quiz review
          context.push('/quiz/review', extra: attempt);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} min ago';
      }
      return '${diff.inHours} hours ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    return '${date.day}/${date.month}/${date.year}';
  }
}
