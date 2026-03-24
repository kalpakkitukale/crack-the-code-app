import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/presentation/providers/user/quiz_provider.dart';

/// Collection of quiz-related dialog utilities.
class QuizDialogs {
  /// Show dialog asking user if they want to resume an existing session.
  static void showResumeDialog({
    required BuildContext context,
    required QuizSession session,
    required VoidCallback onResume,
    required VoidCallback onStartFresh,
  }) {
    final answeredCount = session.answers.length;
    final totalQuestions = session.questions.length;
    final timeElapsed = DateTime.now().difference(session.startTime);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Resume Quiz?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You have an incomplete quiz attempt.'),
            const SizedBox(height: 12),
            Text(
              'Progress: $answeredCount/$totalQuestions questions answered',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Time elapsed: ${_formatDuration(timeElapsed)}',
              style: TextStyle(
                fontSize: 14,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Would you like to continue where you left off?',
              style: TextStyle(color: context.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onStartFresh();
            },
            child: const Text('Start Over'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onResume();
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  /// Show pause/exit quiz dialog.
  static void showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pause Quiz'),
        content: const Text(
          'Your progress has been saved. You can resume this quiz later from where you left off.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Quiz'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Exit Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Show time up dialog.
  static void showTimeUpDialog({
    required BuildContext context,
    required VoidCallback onSubmit,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Time Up!'),
        content: const Text(
            'Your quiz time has expired. The quiz will be submitted automatically.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSubmit();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show submit confirmation dialog.
  static Future<bool?> showSubmitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: const Text(
          'Are you sure you want to submit the quiz? You cannot change your answers after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  /// Show exit confirmation dialog.
  static Future<bool?> showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Your progress will be saved and you can resume later. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  /// Show clear all answers confirmation dialog.
  static void showClearAllConfirmation({
    required BuildContext context,
    required WidgetRef ref,
    required QuizSession session,
    required VoidCallback onCleared,
  }) {
    final answeredCount = session.answers.length;
    final totalQuestions = session.questions.length;

    if (answeredCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No answers to clear'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: context.colorScheme.error),
            const SizedBox(width: AppTheme.spacingSm),
            const Text('Clear All Answers?'),
          ],
        ),
        content: Text(
          'You have answered $answeredCount of $totalQuestions questions.\n\n'
          'Are you sure you want to clear all your answers? You can undo within 10 seconds.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(quizProvider.notifier).clearAllAnswers();
              onCleared();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All answers cleared'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () async {
                        await ref
                            .read(quizProvider.notifier)
                            .undoClearAllAnswers();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Answers restored'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Show restore answers confirmation dialog.
  static void showRestoreConfirmation({
    required BuildContext context,
    required WidgetRef ref,
    required QuizSession session,
    required VoidCallback onRestored,
  }) {
    if (session.answersBackup == null || session.answersBackup!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No backup available to restore'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final backupCount = session.answersBackup!.length;
    final currentAnswersCount = session.answers.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.restore, color: context.colorScheme.primary),
            const SizedBox(width: AppTheme.spacingSm),
            const Text('Restore Answers?'),
          ],
        ),
        content: Text(
          currentAnswersCount > 0
              ? 'You currently have $currentAnswersCount answer(s).\n\n'
                  'Do you want to restore $backupCount answer(s) from your previous attempt? This will replace your current answers.'
              : 'Do you want to restore $backupCount answer(s) from your previous attempt?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(quizProvider.notifier).restoreAnswers();
              onRestored();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$backupCount answer(s) restored successfully'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  static String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
