import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/presentation/providers/user/quiz_history_provider.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';

/// Recommended Quizzes Section for home screen
/// Shows quizzes that need practice based on low scores
class RecommendedQuizzesSection extends ConsumerWidget {
  const RecommendedQuizzesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isJunior = SegmentConfig.isJunior;
    final recentQuizzes = ref.watch(recentQuizzesProvider(20));

    return recentQuizzes.when(
      data: (quizzes) {
        // Filter quizzes that need improvement (score < 75%)
        final needsPractice = quizzes
            .where((q) => !q.passed || q.score < 0.75)
            .toList();

        // Also get unique topics (avoid showing same topic multiple times)
        final uniqueTopics = <String, QuizAttempt>{};
        for (final quiz in needsPractice) {
          final key = quiz.topicId ?? quiz.quizId;
          if (!uniqueTopics.containsKey(key)) {
            uniqueTopics[key] = quiz;
          }
        }

        final recommendations = uniqueTopics.values.take(3).toList();

        if (recommendations.isEmpty) {
          // No weak areas - show encouragement or nothing
          return const SizedBox.shrink();
        }

        return _buildSection(context, theme, isJunior, recommendations, ref);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ThemeData theme,
    bool isJunior,
    List<QuizAttempt> recommendations,
    WidgetRef ref,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade50,
              Colors.amber.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade400, Colors.amber.shade500],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_fix_high,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isJunior ? 'Practice Time!' : 'Recommended Practice',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        Text(
                          isJunior
                              ? 'These topics need more practice'
                              : 'Improve your weak areas',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Motivation icon
                  if (isJunior)
                    const Text('💪', style: TextStyle(fontSize: 24)),
                ],
              ),

              const SizedBox(height: 16),

              // Recommendation tiles
              ...recommendations.map((quiz) => _buildRecommendationTile(
                    context,
                    theme,
                    isJunior,
                    quiz,
                    ref,
                  )),

              const SizedBox(height: 12),

              // View all button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(RouteConstants.practice),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.orange.shade300, width: 2),
                  ),
                  icon: Icon(Icons.fitness_center, color: Colors.orange.shade700),
                  label: Text(
                    isJunior ? 'See All Practice' : 'View All Weak Areas',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
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

  Widget _buildRecommendationTile(
    BuildContext context,
    ThemeData theme,
    bool isJunior,
    QuizAttempt quiz,
    WidgetRef ref,
  ) {
    final scorePercent = (quiz.score * 100).toInt();
    final topicName = quiz.topicName ?? quiz.chapterName ?? 'Topic';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to quiz
            final entityId = quiz.topicId ?? quiz.quizId;
            final studentId = ref.read(effectiveUserIdProvider);
            context.push(RouteConstants.getQuizPath(entityId, studentId));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Score indicator
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getScoreColor(scorePercent).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _getScoreColor(scorePercent).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$scorePercent%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _getScoreColor(scorePercent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Topic info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topicName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isJunior ? 'Needs practice' : 'Room for improvement',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Practice button
                FilledButton(
                  onPressed: () {
                    final entityId = quiz.topicId ?? quiz.quizId;
                    final studentId = ref.read(effectiveUserIdProvider);
                    context.push(RouteConstants.getQuizPath(entityId, studentId));
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isJunior ? 'Try!' : 'Practice',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 75) return Colors.green.shade600;
    if (score >= 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}
