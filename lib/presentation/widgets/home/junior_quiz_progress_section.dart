import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';

/// Kid-friendly quiz progress section for Junior home screen
/// Shows quiz stats, recent attempts, and encourages quiz taking
class JuniorQuizProgressSection extends ConsumerWidget {
  const JuniorQuizProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentQuizzes = ref.watch(recentQuizzesProvider(5));
    final stats = ref.watch(quizStatisticsProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with fun icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade400, Colors.purple.shade600],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Quiz Adventures',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade800,
                          ),
                        ),
                        Text(
                          'Keep up the great work!',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.purple.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trophy animation hint
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.9, end: 1.1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: const Text('🏆', style: TextStyle(fontSize: 28)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Stats Row
              stats.when(
                data: (data) => _buildStatsRow(context, data),
                loading: () => _buildStatsRowLoading(context),
                error: (e, _) => _buildStatsRowEmpty(context),
              ),

              const SizedBox(height: 20),

              // Recent Quizzes
              recentQuizzes.when(
                data: (quizzes) {
                  if (quizzes.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildRecentQuizzes(context, quizzes);
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => _buildEmptyState(context),
              ),

              const SizedBox(height: 16),

              // View All Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/quiz-history'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.purple.shade300, width: 2),
                  ),
                  icon: Icon(Icons.history, color: Colors.purple.shade700),
                  label: Text(
                    'See All My Quizzes',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, dynamic stats) {
    // Use safe defaults if stats is null or has missing fields
    final totalAttempts = stats?.totalAttempts ?? 0;
    final averageScore = stats?.averageScore ?? 0.0;
    final currentStreak = stats?.currentStreak ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.check_circle_rounded,
            color: Colors.green,
            value: '$totalAttempts',
            label: 'Quizzes',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            icon: Icons.emoji_events_rounded,
            color: Colors.amber.shade700,
            value: '${averageScore.toInt()}%',
            label: 'Avg Score',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            value: '$currentStreak',
            label: 'Day Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRowLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.check_circle_rounded,
            color: Colors.green,
            value: '-',
            label: 'Quizzes',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem(
            icon: Icons.emoji_events_rounded,
            color: Colors.amber.shade700,
            value: '-',
            label: 'Avg Score',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem(
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            value: '-',
            label: 'Day Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRowEmpty(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.check_circle_rounded,
            color: Colors.green,
            value: '0',
            label: 'Quizzes',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem(
            icon: Icons.emoji_events_rounded,
            color: Colors.amber.shade700,
            value: '0%',
            label: 'Avg Score',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem(
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            value: '0',
            label: 'Day Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentQuizzes(BuildContext context, List<QuizAttempt> quizzes) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, size: 18, color: Colors.purple.shade600),
            const SizedBox(width: 6),
            Text(
              'Recent Quizzes',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.purple.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...quizzes.take(3).map((quiz) => _buildQuizItem(context, quiz)),
      ],
    );
  }

  Widget _buildQuizItem(BuildContext context, QuizAttempt quiz) {
    final passed = quiz.passed;
    final scorePercent = (quiz.score * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: passed ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: passed ? Colors.green.shade200 : Colors.orange.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: passed ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              passed ? Icons.check_circle_rounded : Icons.refresh_rounded,
              color: passed ? Colors.green.shade700 : Colors.orange.shade700,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Quiz info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.topicName ?? quiz.chapterName ?? 'Quiz',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$scorePercent% - ${_formatDate(quiz.completedAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Emoji indicator
          Text(
            passed ? '⭐' : '💪',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Animated mascot area
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.quiz_outlined,
                size: 48,
                color: Colors.purple.shade400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No quizzes yet!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Watch a video and take a quiz\nto start your adventure!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.purple.shade600,
            ),
          ),
          const SizedBox(height: 16),
          // Encouragement row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎯', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Earn stars by taking quizzes!',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber.shade700,
                ),
              ),
              const SizedBox(width: 8),
              const Text('⭐', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${date.day}/${date.month}';
  }
}
