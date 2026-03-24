import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';

/// Quiz Progress Widget - PHASE 4
/// Shows quiz statistics and recent quiz performance
class QuizProgress extends ConsumerWidget {
  const QuizProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final quizStatsAsync = ref.watch(quizStatisticsProvider);
    final recentQuizzesAsync = ref.watch(recentQuizzesProvider(3));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz Performance',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(RouteConstants.quizHistory);
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Quiz Statistics Cards
        quizStatsAsync.when(
          data: (stats) {
            // Show empty state if no quizzes taken
            if (stats.totalAttempts == 0) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Column(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 48,
                        color: colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'No Quizzes Yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Start taking quizzes to track your progress',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to home screen where users can browse subjects/chapters to take quizzes
                          // This is more intuitive than landing directly on board selection page
                          context.go(RouteConstants.home);
                        },
                        icon: const Icon(Icons.quiz),
                        label: const Text('Take a Quiz'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Platform-specific spacing offset
                final double offsetY = kIsWeb
                    ? -16.0
                    : (Platform.isIOS ? -28.0 : -4.0);

                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppTheme.spacingMd,
                    crossAxisSpacing: AppTheme.spacingMd,
                    childAspectRatio: constraints.maxWidth > 600 ? 2.0 : 1.5,
                    children: [
                      _buildStatCard(
                        icon: Icons.quiz,
                        label: 'Quizzes Taken',
                        value: stats.totalAttempts.toString(),
                        color: Colors.purple,
                        colorScheme: colorScheme,
                      ),
                      _buildStatCard(
                        icon: Icons.grade,
                        label: 'Avg Score',
                        value: '${stats.averageScore.toStringAsFixed(0)}%',
                        color: Colors.blue,
                        colorScheme: colorScheme,
                      ),
                      _buildStatCard(
                        icon: Icons.check_circle,
                        label: 'Pass Rate',
                        value: '${stats.passRate.toStringAsFixed(0)}%',
                        color: Colors.green,
                        colorScheme: colorScheme,
                      ),
                      _buildStatCard(
                        icon: Icons.local_fire_department,
                        label: 'Quiz Streak',
                        value: '${stats.currentStreak} ${stats.currentStreak == 1 ? "day" : "days"}',
                        color: Colors.orange,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingXl),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Error Loading Quiz Stats',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Please try again later',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spacingLg),

        // Recent Quizzes Section
        quizStatsAsync.maybeWhen(
          data: (stats) {
            if (stats.totalAttempts > 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Quizzes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  recentQuizzesAsync.when(
                    data: (quizzes) {
                      if (quizzes.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: quizzes.map((quiz) {
                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: AppTheme.spacingSm,
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: quiz.passed
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  quiz.passed
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: quiz.passed
                                      ? Colors.green
                                      : Colors.red,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                quiz.topicName ?? quiz.chapterName ?? 'Quiz',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${quiz.subjectName ?? "Unknown Subject"} • ${(quiz.score * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              trailing: Text(
                                '${quiz.correctAnswers}/${quiz.totalQuestions}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.spacingMd),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
