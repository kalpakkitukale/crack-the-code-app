import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/presentation/screens/quiz/widgets/quiz_question_header.dart';

/// Sidebar showing all questions with their answered/current state.
/// Used in tablet and desktop layouts.
class QuizNavigationSidebar extends StatelessWidget {
  final QuizSession session;
  final bool enhanced;
  final bool isNavigating;
  final void Function(int index) onQuestionTap;

  const QuizNavigationSidebar({
    super.key,
    required this.session,
    this.enhanced = false,
    this.isNavigating = false,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        border: Border(
          right: BorderSide(color: context.colorScheme.outline),
        ),
      ),
      child: Column(
        children: [
          _SidebarHeader(session: session),
          const Divider(height: 1),
          _QuestionList(
            session: session,
            enhanced: enhanced,
            isNavigating: isNavigating,
            onQuestionTap: onQuestionTap,
          ),
          if (enhanced) ...[
            const Divider(height: 1),
            _SidebarLegend(),
          ],
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final QuizSession session;

  const _SidebarHeader({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            '${session.answeredCount} of ${session.questions.length} answered',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionList extends StatelessWidget {
  final QuizSession session;
  final bool enhanced;
  final bool isNavigating;
  final void Function(int index) onQuestionTap;

  const _QuestionList({
    required this.session,
    required this.enhanced,
    required this.isNavigating,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        itemCount: session.questions.length,
        itemBuilder: (context, index) {
          final question = session.questions[index];
          final isAnswered = session.answers.containsKey(question.id);
          final isCurrent = index == session.currentQuestionIndex;

          return _QuestionListItem(
            index: index,
            question: question,
            isAnswered: isAnswered,
            isCurrent: isCurrent,
            enhanced: enhanced,
            isNavigating: isNavigating,
            onTap: () => onQuestionTap(index),
          );
        },
      ),
    );
  }
}

class _QuestionListItem extends StatelessWidget {
  final int index;
  final Question question;
  final bool isAnswered;
  final bool isCurrent;
  final bool enhanced;
  final bool isNavigating;
  final VoidCallback onTap;

  const _QuestionListItem({
    required this.index,
    required this.question,
    required this.isAnswered,
    required this.isCurrent,
    required this.enhanced,
    required this.isNavigating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
      child: Material(
        color: isCurrent
            ? context.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: InkWell(
          onTap: isNavigating ? null : onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: AppTheme.spacingXs,
            ),
            child: Row(
              children: [
                _QuestionStatusIndicator(
                  index: index,
                  isAnswered: isAnswered,
                  isCurrent: isCurrent,
                  enhanced: enhanced,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                if (enhanced) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          getQuestionTypeLabel(question.questionType),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Text(
                    'Q${index + 1}',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionStatusIndicator extends StatelessWidget {
  final int index;
  final bool isAnswered;
  final bool isCurrent;
  final bool enhanced;

  const _QuestionStatusIndicator({
    required this.index,
    required this.isAnswered,
    required this.isCurrent,
    required this.enhanced,
  });

  @override
  Widget build(BuildContext context) {
    final size = enhanced ? 32.0 : 24.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isAnswered
            ? AppTheme.successColor
            : isCurrent
                ? context.colorScheme.primary
                : context.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isAnswered
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : Text(
                '${index + 1}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isCurrent
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _SidebarLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      child: Column(
        children: [
          _LegendItem(
            color: AppTheme.successColor,
            label: 'Answered',
            icon: Icons.check_circle,
          ),
          const SizedBox(height: AppTheme.spacingXs),
          _LegendItem(
            color: context.colorScheme.primary,
            label: 'Current',
            icon: Icons.radio_button_checked,
          ),
          const SizedBox(height: AppTheme.spacingXs),
          _LegendItem(
            color: context.colorScheme.onSurfaceVariant,
            label: 'Not Answered',
            icon: Icons.radio_button_unchecked,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppTheme.spacingXs),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
