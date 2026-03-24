import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';

/// Bottom navigation buttons for quiz (Previous, Next/Submit).
class QuizNavigationButtons extends StatelessWidget {
  final QuizSession session;
  final bool isSubmitting;
  final bool isNavigating;
  final bool enhanced;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const QuizNavigationButtons({
    super.key,
    required this.session,
    required this.isSubmitting,
    required this.isNavigating,
    this.enhanced = false,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.all(enhanced ? AppTheme.spacingLg : AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(color: context.colorScheme.outline),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Wrap(
          spacing: AppTheme.spacingSm,
          runSpacing: AppTheme.spacingXs,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!session.isFirstQuestion)
              _PreviousButton(
                enhanced: enhanced,
                isEnabled: !isSubmitting && !isNavigating,
                onPressed: onPrevious,
              ),
            if (session.hasAnswerForCurrentQuestion && !isSubmitting)
              _AnswerReadyChip(),
            session.isLastQuestion
                ? _SubmitButton(
                    isEnabled: session.hasAnswerForCurrentQuestion &&
                        !isSubmitting &&
                        !isNavigating,
                    isSubmitting: isSubmitting,
                    onPressed: onSubmit,
                  )
                : _NextButton(
                    enhanced: enhanced,
                    isEnabled: session.hasAnswerForCurrentQuestion &&
                        !isSubmitting &&
                        !isNavigating,
                    isSubmitting: isSubmitting,
                    onPressed: onNext,
                  ),
          ],
        ),
      ),
    );
  }
}

class _PreviousButton extends StatelessWidget {
  final bool enhanced;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _PreviousButton({
    required this.enhanced,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: const Icon(Icons.arrow_back),
      label: Text(enhanced ? 'Previous' : 'Prev'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppTheme.minTouchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool enhanced;
  final bool isEnabled;
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _NextButton({
    required this.enhanced,
    required this.isEnabled,
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: isSubmitting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.arrow_forward),
      label: Text(isSubmitting ? 'Saving...' : 'Next'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppTheme.minTouchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isEnabled;
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.isEnabled,
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: isSubmitting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check_circle),
      label: Text(isSubmitting ? 'Submitting...' : 'Submit Quiz'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppTheme.minTouchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
        backgroundColor: AppTheme.successColor,
        foregroundColor: context.colorScheme.onSecondary,
      ),
    );
  }
}

class _AnswerReadyChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.edit, size: 16, color: AppTheme.successColor),
      label: Text(
        'Answer ready',
        style: TextStyle(
          color: AppTheme.successColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: AppTheme.successColor.withValues(alpha: 0.1),
      side: BorderSide(
        color: AppTheme.successColor.withValues(alpha: 0.5),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
