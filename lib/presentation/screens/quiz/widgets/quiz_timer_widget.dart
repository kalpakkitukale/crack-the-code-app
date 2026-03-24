import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';

/// Displays the remaining quiz time with visual indicators for low/critical time.
class QuizTimerWidget extends StatelessWidget {
  final int remainingSeconds;

  const QuizTimerWidget({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final isLowTime = remainingSeconds < 60;
    final isCriticalTime = remainingSeconds < 30;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: isCriticalTime
            ? AppTheme.errorColor.withValues(alpha: 0.1)
            : isLowTime
                ? AppTheme.warningColor.withValues(alpha: 0.1)
                : context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 16,
            color: isCriticalTime
                ? AppTheme.errorColor
                : isLowTime
                    ? AppTheme.warningColor
                    : context.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            timeString,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCriticalTime
                  ? AppTheme.errorColor
                  : isLowTime
                      ? AppTheme.warningColor
                      : context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
