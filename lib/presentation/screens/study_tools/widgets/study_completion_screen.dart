/// Study Completion Screen widget for flashcard sessions
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/screens/study_tools/widgets/streak_banner.dart';

/// Comprehensive completion screen after flashcard study
class StudyCompletionScreen extends StatelessWidget {
  final int correctCount;
  final int incorrectCount;
  final int currentStreak;
  final int bestStreak;
  final Duration studyTime;
  final bool isJunior;
  final VoidCallback onDone;
  final VoidCallback onStudyAgain;
  final VoidCallback? onReviewMistakes;

  const StudyCompletionScreen({
    super.key,
    required this.correctCount,
    required this.incorrectCount,
    required this.currentStreak,
    required this.bestStreak,
    required this.studyTime,
    required this.isJunior,
    required this.onDone,
    required this.onStudyAgain,
    this.onReviewMistakes,
  });

  @override
  Widget build(BuildContext context) {
    final totalCards = correctCount + incorrectCount;
    final accuracy = totalCards > 0 ? (correctCount / totalCards * 100) : 0.0;
    final isExcellent = accuracy >= 80;
    final isGood = accuracy >= 60;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppTheme.spacingXl),

              // Trophy or thumbs up icon
              _CelebrationIcon(
                isExcellent: isExcellent,
                isGood: isGood,
                isJunior: isJunior,
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Title
              Text(
                isExcellent
                    ? 'Excellent!'
                    : isGood
                        ? 'Good Job!'
                        : 'Keep Practicing!',
                style: isJunior
                    ? Theme.of(context).textTheme.headlineLarge
                    : Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingSm),

              Text(
                _getEncouragingMessage(accuracy),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatBox(
                    value: '$correctCount',
                    label: 'Correct',
                    color: Colors.green,
                    isJunior: isJunior,
                  ),
                  _StatBox(
                    value: '$incorrectCount',
                    label: 'Incorrect',
                    color: Colors.red,
                    isJunior: isJunior,
                  ),
                  _StatBox(
                    value: '${accuracy.toInt()}%',
                    label: 'Accuracy',
                    color: _getAccuracyColor(accuracy),
                    isJunior: isJunior,
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Time spent
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Study time: ${_formatDuration(studyTime)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Streak banner
              StreakBanner(
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                cardsStudiedToday: totalCards,
                todayAccuracy: accuracy.toInt(),
              ),

              // New best streak indicator
              if (currentStreak > 0 && currentStreak >= bestStreak)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'New best streak!',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppTheme.spacingXl),

              // Action buttons
              Column(
                children: [
                  // Review mistakes button (if there are mistakes)
                  if (incorrectCount > 0 && onReviewMistakes != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onReviewMistakes,
                        icon: const Icon(Icons.refresh),
                        label: Text('Review $incorrectCount Mistakes'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isJunior ? 14 : 12,
                          ),
                        ),
                      ),
                    ),

                  if (incorrectCount > 0 && onReviewMistakes != null)
                    const SizedBox(height: AppTheme.spacingMd),

                  // Main buttons row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onDone,
                          icon: const Icon(Icons.check),
                          label: const Text('Done'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isJunior ? 14 : 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onStudyAgain,
                          icon: const Icon(Icons.replay),
                          label: const Text('Study Again'),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isJunior ? 14 : 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  String _getEncouragingMessage(double accuracy) {
    if (accuracy >= 90) return 'You\'re mastering this material!';
    if (accuracy >= 80) return 'Great progress! Keep it up!';
    if (accuracy >= 60) return 'You\'re getting there! Practice makes perfect.';
    if (accuracy >= 40) return 'Don\'t give up! Review the cards you missed.';
    return 'Every expert was once a beginner. Keep studying!';
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes min $seconds sec';
    }
    return '$seconds sec';
  }
}

class _CelebrationIcon extends StatelessWidget {
  final bool isExcellent;
  final bool isGood;
  final bool isJunior;

  const _CelebrationIcon({
    required this.isExcellent,
    required this.isGood,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isJunior ? 100.0 : 80.0;

    if (isExcellent) {
      return Icon(
        Icons.emoji_events,
        size: iconSize,
        color: Colors.amber,
      );
    }

    if (isGood) {
      return Icon(
        Icons.thumb_up,
        size: iconSize,
        color: Colors.green,
      );
    }

    return Icon(
      Icons.trending_up,
      size: iconSize,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isJunior;

  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isJunior ? 16 : 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: (isJunior
                    ? Theme.of(context).textTheme.headlineMedium
                    : Theme.of(context).textTheme.headlineSmall)
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
