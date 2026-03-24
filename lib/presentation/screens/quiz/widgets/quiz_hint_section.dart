import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';

/// Displays hints for the current question with progressive reveal.
class QuizHintSection extends StatefulWidget {
  final Question question;
  final bool enhanced;

  const QuizHintSection({
    super.key,
    required this.question,
    this.enhanced = false,
  });

  @override
  State<QuizHintSection> createState() => _QuizHintSectionState();
}

class _QuizHintSectionState extends State<QuizHintSection> {
  bool _showHint = false;
  int _currentHintIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!_showHint) {
      return _HintButton(
        hintCount: widget.question.hintCount,
        enhanced: widget.enhanced,
        onPressed: () => setState(() {
          _showHint = true;
          _currentHintIndex = 0;
        }),
      );
    }

    final currentHint = widget.question.getHint(_currentHintIndex);
    if (currentHint == null) return const SizedBox.shrink();

    return _HintCard(
      hint: currentHint,
      currentIndex: _currentHintIndex,
      totalHints: widget.question.hintCount,
      enhanced: widget.enhanced,
      onNextHint: _currentHintIndex < widget.question.hintCount - 1
          ? () => setState(() => _currentHintIndex++)
          : null,
    );
  }

  /// Reset hint state when question changes
  void resetHints() {
    setState(() {
      _showHint = false;
      _currentHintIndex = 0;
    });
  }
}

class _HintButton extends StatelessWidget {
  final int hintCount;
  final bool enhanced;
  final VoidCallback onPressed;

  const _HintButton({
    required this.hintCount,
    required this.enhanced,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.lightbulb_outline),
        label: Text('Need a hint? ($hintCount available)'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(
              enhanced ? AppTheme.spacingMd : AppTheme.spacingSm),
        ),
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  final String hint;
  final int currentIndex;
  final int totalHints;
  final bool enhanced;
  final VoidCallback? onNextHint;

  const _HintCard({
    required this.hint,
    required this.currentIndex,
    required this.totalHints,
    required this.enhanced,
    this.onNextHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.1),
        border: Border.all(
          color: AppTheme.warningColor.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: AppTheme.warningColor,
                size: enhanced ? 24 : 20,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Hint ${currentIndex + 1} of $totalHints',
                style: context.textTheme.titleSmall?.copyWith(
                  color: AppTheme.warningColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (onNextHint != null)
                TextButton(
                  onPressed: onNextHint,
                  child: const Text('Next Hint'),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            hint,
            style: enhanced
                ? context.textTheme.bodyMedium
                : context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
