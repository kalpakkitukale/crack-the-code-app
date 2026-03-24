import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/presentation/providers/user/quiz_provider.dart';

/// Displays multiple choice question answers with radio button selection.
class MultipleChoiceAnswers extends ConsumerWidget {
  final Question question;
  final bool enhanced;

  const MultipleChoiceAnswers({
    super.key,
    required this.question,
    this.enhanced = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizProvider).activeSession;
    final savedAnswer = session?.answers[question.id];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final optionKey = String.fromCharCode(65 + index); // A, B, C, D...
        final isSelected = savedAnswer == optionKey;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
          child: _AnswerOption(
            key: ValueKey(
                'answer_${session?.id ?? 'no_session'}_${question.id}_$optionKey'),
            optionKey: optionKey,
            optionText: option,
            isSelected: isSelected,
            enhanced: enhanced,
            savedAnswer: savedAnswer,
            onTap: () => _handleOptionTap(ref, context, optionKey),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _handleOptionTap(
      WidgetRef ref, BuildContext context, String optionKey) async {
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
          answer: optionKey,
          questionIndex: currentIndex,
        );
  }
}

class _AnswerOption extends StatelessWidget {
  final String optionKey;
  final String optionText;
  final bool isSelected;
  final bool enhanced;
  final String? savedAnswer;
  final VoidCallback onTap;

  const _AnswerOption({
    super.key,
    required this.optionKey,
    required this.optionText,
    required this.isSelected,
    required this.enhanced,
    required this.savedAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? context.colorScheme.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding:
              EdgeInsets.all(enhanced ? AppTheme.spacingMd : AppTheme.spacingSm),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: optionKey,
                groupValue: savedAnswer,
                onChanged: null, // Disable - let InkWell handle all clicks
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _OptionLetterBadge(
                optionKey: optionKey,
                isSelected: isSelected,
                enhanced: enhanced,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  optionText,
                  style: enhanced
                      ? context.textTheme.bodyLarge
                      : context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionLetterBadge extends StatelessWidget {
  final String optionKey;
  final bool isSelected;
  final bool enhanced;

  const _OptionLetterBadge({
    required this.optionKey,
    required this.isSelected,
    required this.enhanced,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: enhanced ? 32 : 24,
      height: enhanced ? 32 : 24,
      decoration: BoxDecoration(
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          optionKey,
          style: context.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? context.colorScheme.onPrimary
                : context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
