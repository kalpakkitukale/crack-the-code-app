import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_provider.dart';

/// Displays true/false question with large tappable buttons.
class TrueFalseAnswers extends ConsumerWidget {
  final Question question;
  final bool enhanced;

  const TrueFalseAnswers({
    super.key,
    required this.question,
    this.enhanced = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizProvider).activeSession;
    final savedAnswer = session?.answers[question.id];

    return Row(
      children: [
        Expanded(
          child: _TrueFalseButton(
            key: ValueKey(
                'tf_answer_${session?.id ?? 'no_session'}_${question.id}_A'),
            label: 'True',
            icon: Icons.check_circle,
            color: AppTheme.successColor,
            isSelected: savedAnswer == 'A',
            enhanced: enhanced,
            onTap: () => _handleTap(ref, 'A'),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _TrueFalseButton(
            key: ValueKey(
                'tf_answer_${session?.id ?? 'no_session'}_${question.id}_B'),
            label: 'False',
            icon: Icons.cancel,
            color: AppTheme.errorColor,
            isSelected: savedAnswer == 'B',
            enhanced: enhanced,
            onTap: () => _handleTap(ref, 'B'),
          ),
        ),
      ],
    );
  }

  Future<void> _handleTap(WidgetRef ref, String answer) async {
    final currentSession = ref.read(quizProvider).activeSession;
    if (currentSession == null) return;

    final actualCurrentQuestion = currentSession.currentQuestion;
    if (actualCurrentQuestion == null ||
        actualCurrentQuestion.id != question.id) {
      return; // Stale tap
    }

    final currentIndex = currentSession.currentQuestionIndex;
    await ref.read(quizProvider.notifier).submitAnswer(
          questionId: question.id,
          answer: answer,
          questionIndex: currentIndex,
        );
  }
}

class _TrueFalseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool enhanced;
  final VoidCallback onTap;

  const _TrueFalseButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.enhanced,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding:
              EdgeInsets.all(enhanced ? AppTheme.spacingLg : AppTheme.spacingMd),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? color : context.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: enhanced ? 48 : 32,
                color: isSelected ? color : context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                label,
                style: (enhanced
                        ? context.textTheme.titleMedium
                        : context.textTheme.titleSmall)
                    ?.copyWith(
                  color: isSelected ? color : context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
