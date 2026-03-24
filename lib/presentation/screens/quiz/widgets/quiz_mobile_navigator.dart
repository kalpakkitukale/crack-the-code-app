import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';

/// Shows the mobile question navigator bottom sheet.
void showMobileQuestionNavigator({
  required BuildContext context,
  required QuizSession session,
  required bool isNavigating,
  required void Function(int index) onQuestionTap,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => QuizMobileNavigator(
      session: session,
      isNavigating: isNavigating,
      onQuestionTap: (index) {
        Navigator.of(context).pop();
        onQuestionTap(index);
      },
    ),
  );
}

/// Bottom sheet showing all quiz questions for quick navigation on mobile.
class QuizMobileNavigator extends StatelessWidget {
  final QuizSession session;
  final bool isNavigating;
  final void Function(int index) onQuestionTap;

  const QuizMobileNavigator({
    super.key,
    required this.session,
    required this.isNavigating,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLg),
          ),
        ),
        child: Column(
          children: [
            _HandleBar(),
            _Header(),
            _StatusSummary(session: session),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(height: 1),
            _QuestionGrid(
              session: session,
              isNavigating: isNavigating,
              scrollController: scrollController,
              onQuestionTap: onQuestionTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _HandleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spacingSm),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Text(
            'Jump to Question',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _StatusSummary extends StatelessWidget {
  final QuizSession session;

  const _StatusSummary({required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Wrap(
        spacing: AppTheme.spacingXs,
        runSpacing: AppTheme.spacingXs,
        alignment: WrapAlignment.center,
        children: [
          _StatusChip(
            label: 'Answered',
            count: session.answeredCount,
            color: AppTheme.successColor,
            icon: Icons.check_circle,
          ),
          _StatusChip(
            label: 'Current',
            count: 1,
            color: context.colorScheme.primary,
            icon: Icons.radio_button_checked,
          ),
          _StatusChip(
            label: 'Unanswered',
            count: session.unansweredCount,
            color: context.colorScheme.onSurfaceVariant,
            icon: Icons.radio_button_unchecked,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        '$count $label',
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _QuestionGrid extends StatelessWidget {
  final QuizSession session;
  final bool isNavigating;
  final ScrollController scrollController;
  final void Function(int index) onQuestionTap;

  const _QuestionGrid({
    required this.session,
    required this.isNavigating,
    required this.scrollController,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: AppTheme.spacingSm,
          mainAxisSpacing: AppTheme.spacingSm,
          childAspectRatio: 1,
        ),
        itemCount: session.questions.length,
        itemBuilder: (context, index) {
          final question = session.questions[index];
          final isAnswered = session.answers.containsKey(question.id);
          final isCurrent = index == session.currentQuestionIndex;

          return _QuestionTile(
            index: index,
            isAnswered: isAnswered,
            isCurrent: isCurrent,
            isNavigating: isNavigating,
            onTap: () => onQuestionTap(index),
          );
        },
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final int index;
  final bool isAnswered;
  final bool isCurrent;
  final bool isNavigating;
  final VoidCallback onTap;

  const _QuestionTile({
    required this.index,
    required this.isAnswered,
    required this.isCurrent,
    required this.isNavigating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isNavigating ? null : onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Container(
        decoration: BoxDecoration(
          color: isAnswered
              ? AppTheme.successColor.withValues(alpha: 0.1)
              : isCurrent
                  ? context.colorScheme.primary.withValues(alpha: 0.1)
                  : context.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isCurrent
                ? context.colorScheme.primary
                : isAnswered
                    ? AppTheme.successColor
                    : context.colorScheme.outline,
            width: isCurrent ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Center(
          child: isAnswered
              ? Icon(
                  Icons.check,
                  color: AppTheme.successColor,
                  size: 20,
                )
              : Text(
                  '${index + 1}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurface,
                  ),
                ),
        ),
      ),
    );
  }
}
