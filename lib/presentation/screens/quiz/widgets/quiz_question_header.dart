import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';

/// Displays question metadata including number, difficulty, points, and type.
class QuizQuestionHeader extends StatelessWidget {
  final Question question;
  final int questionIndex;
  final int totalQuestions;

  const QuizQuestionHeader({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacingSm,
      runSpacing: AppTheme.spacingXs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _QuestionNumberBadge(questionIndex: questionIndex),
        _DifficultyChip(difficulty: question.difficulty),
        _PointsChip(points: question.points),
        _QuestionTypeIndicator(questionType: question.questionType),
      ],
    );
  }
}

class _QuestionNumberBadge extends StatelessWidget {
  final int questionIndex;

  const _QuestionNumberBadge({required this.questionIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Text(
        'Question ${questionIndex + 1}',
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final String difficulty;

  const _DifficultyChip({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    IconData iconData;

    switch (difficulty.toLowerCase()) {
      case 'basic':
      case 'easy':
        chipColor = AppTheme.successColor;
        iconData = Icons.sentiment_satisfied_alt;
        break;
      case 'intermediate':
      case 'medium':
        chipColor = AppTheme.warningColor;
        iconData = Icons.sentiment_neutral;
        break;
      case 'advanced':
      case 'hard':
        chipColor = AppTheme.errorColor;
        iconData = Icons.sentiment_dissatisfied;
        break;
      default:
        chipColor = context.colorScheme.primary;
        iconData = Icons.help_outline;
    }

    return Chip(
      avatar: Icon(iconData, size: 16, color: chipColor),
      label: Text(
        difficulty,
        style: context.textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _PointsChip extends StatelessWidget {
  final int points;

  const _PointsChip({required this.points});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        '$points ${points == 1 ? 'point' : 'points'}',
        style: context.textTheme.labelSmall,
      ),
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _QuestionTypeIndicator extends StatelessWidget {
  final QuestionType questionType;

  const _QuestionTypeIndicator({required this.questionType});

  @override
  Widget build(BuildContext context) {
    final (iconData, label) = _getTypeInfo();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, size: 16, color: context.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  (IconData, String) _getTypeInfo() {
    switch (questionType) {
      case QuestionType.mcq:
        return (Icons.radio_button_checked, 'Multiple Choice');
      case QuestionType.trueFalse:
        return (Icons.toggle_on, 'True/False');
      case QuestionType.fillBlank:
        return (Icons.text_fields, 'Fill in Blank');
      case QuestionType.match:
        return (Icons.compare_arrows, 'Matching');
      case QuestionType.numerical:
        return (Icons.numbers, 'Numerical');
    }
  }
}

/// Standalone function to get question type label.
String getQuestionTypeLabel(QuestionType type) {
  switch (type) {
    case QuestionType.mcq:
      return 'Multiple Choice';
    case QuestionType.trueFalse:
      return 'True/False';
    case QuestionType.fillBlank:
      return 'Fill in Blank';
    case QuestionType.match:
      return 'Matching';
    case QuestionType.numerical:
      return 'Numerical';
  }
}
