import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/models/assessment_type.dart';

/// Displays quiz progress as a linear progress bar.
/// Uses assessment type color accent with success color when near completion.
class QuizProgressBar extends StatelessWidget {
  final double progressPercentage;
  final AssessmentType assessmentType;

  const QuizProgressBar({
    super.key,
    required this.progressPercentage,
    required this.assessmentType,
  });

  @override
  Widget build(BuildContext context) {
    final progress = progressPercentage / 100;

    return SizedBox(
      height: 4,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          progress >= 0.8 ? AppTheme.successColor : assessmentType.primaryColor,
        ),
      ),
    );
  }
}
