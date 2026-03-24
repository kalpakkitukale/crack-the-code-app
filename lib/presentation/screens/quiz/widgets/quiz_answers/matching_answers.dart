import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';

/// Displays matching question pairs with visual connections.
/// For MVP, uses a simplified display approach. In production, this would support drag-and-drop.
class MatchingAnswers extends StatelessWidget {
  final Question question;
  final bool enhanced;

  const MatchingAnswers({
    super.key,
    required this.question,
    this.enhanced = false,
  });

  @override
  Widget build(BuildContext context) {
    final pairs = question.options; // Assuming format: ["A:1", "B:2", "C:3"]

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InstructionsBanner(),
        const SizedBox(height: AppTheme.spacingMd),
        ...pairs.map((pair) => _MatchingPair(pair: pair)).toList(),
      ],
    );
  }
}

class _InstructionsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              'Match the items on the left with the correct items on the right',
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchingPair extends StatelessWidget {
  final String pair;

  const _MatchingPair({required this.pair});

  @override
  Widget build(BuildContext context) {
    final parts = pair.split(':');
    if (parts.length < 2) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _PairItem(
              text: parts[0],
              isLeft: true,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
            child: Icon(Icons.arrow_forward, size: 20),
          ),
          Expanded(
            flex: 2,
            child: _PairItem(
              text: parts[1],
              isLeft: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _PairItem extends StatelessWidget {
  final String text;
  final bool isLeft;

  const _PairItem({
    required this.text,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: isLeft
            ? context.colorScheme.surface
            : context.colorScheme.surfaceContainerHighest,
        border: Border.all(color: context.colorScheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Text(text),
    );
  }
}
