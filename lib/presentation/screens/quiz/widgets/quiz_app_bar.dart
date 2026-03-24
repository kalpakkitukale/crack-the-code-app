import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/presentation/widgets/quiz/assessment_context_indicator.dart';
import 'package:streamshaala/presentation/screens/quiz/widgets/quiz_timer_widget.dart';

/// App bar for the quiz taking screen with timer and assessment info.
class QuizAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final QuizSession session;
  final AssessmentType assessmentType;
  final String entityId;
  final int remainingSeconds;
  final bool compact;
  final bool hasBackup;
  final VoidCallback onPause;
  final VoidCallback onClearAll;
  final VoidCallback? onRestore;

  const QuizAppBar({
    super.key,
    required this.session,
    required this.assessmentType,
    required this.entityId,
    required this.remainingSeconds,
    this.compact = false,
    this.hasBackup = false,
    required this.onPause,
    required this.onClearAll,
    this.onRestore,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: compact ? _buildCompactTitle(context) : _buildFullTitle(context),
      actions: [
        if (remainingSeconds > 0) ...[
          QuizTimerWidget(remainingSeconds: remainingSeconds),
          const SizedBox(width: AppTheme.spacingSm),
        ],
        IconButton(
          icon: const Icon(Icons.pause_circle_outline),
          tooltip: 'Pause Quiz',
          onPressed: onPause,
        ),
        IconButton(
          icon: const Icon(Icons.clear_all),
          tooltip: 'Clear All Answers',
          color: context.colorScheme.error,
          onPressed: onClearAll,
        ),
        if (hasBackup && onRestore != null)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onSelected: (value) {
              if (value == 'restore_answers') {
                onRestore!();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'restore_answers',
                  child: Row(
                    children: [
                      Icon(Icons.restore, color: context.colorScheme.primary),
                      const SizedBox(width: AppTheme.spacingSm),
                      const Text('Restore Answers'),
                    ],
                  ),
                ),
              ];
            },
          ),
        const SizedBox(width: AppTheme.spacingSm),
      ],
    );
  }

  Widget _buildCompactTitle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          assessmentType.icon,
          color: assessmentType.primaryColor,
          size: 20,
        ),
        const SizedBox(width: AppTheme.spacingXs),
        Text(
          'Q${session.currentQuestionIndex + 1}/${session.questions.length}',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFullTitle(BuildContext context) {
    return Row(
      children: [
        Icon(
          assessmentType.icon,
          color: assessmentType.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${assessmentType.displayName}: $entityId',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                assessmentType.subtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AssessmentContextIndicator(
          assessmentType: assessmentType,
          displayMode: AssessmentContextDisplayMode.badge,
        ),
      ],
    );
  }
}
