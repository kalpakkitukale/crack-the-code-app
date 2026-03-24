import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/presentation/widgets/quiz/assessment_context_indicator.dart';

/// Widget providing contextual information about the assessment type.
/// Shown on the first question to help users understand the assessment purpose.
class QuizAssessmentContextHelper extends StatelessWidget {
  final AssessmentType assessmentType;
  final bool compact;

  const QuizAssessmentContextHelper({
    super.key,
    required this.assessmentType,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? assessmentType.backgroundColorDark
        : assessmentType.backgroundColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: compact ? AppTheme.spacingSm : AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: assessmentType.borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            assessmentType.icon,
            size: compact ? 16 : 20,
            color: assessmentType.primaryColor,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              assessmentType.helperText,
              style: (compact
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                color: assessmentType.primaryColor,
                fontStyle: FontStyle.italic,
              ),
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: compact ? 18 : 20,
              color: assessmentType.primaryColor.withValues(alpha: 0.7),
            ),
            onPressed: () => AssessmentInfoDialog.show(context, assessmentType),
            tooltip: 'What is ${assessmentType.displayName}?',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }
}
