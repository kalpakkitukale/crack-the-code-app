/// Flashcard badges for difficulty and mastery display
library;

import 'package:flutter/material.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';

/// Badge showing card difficulty level
class DifficultyBadge extends StatelessWidget {
  final FlashcardDifficulty difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (difficulty) {
      FlashcardDifficulty.easy => (Colors.green, Icons.sentiment_satisfied, 'Easy'),
      FlashcardDifficulty.medium => (Colors.orange, Icons.sentiment_neutral, 'Medium'),
      FlashcardDifficulty.hard => (Colors.red, Icons.sentiment_dissatisfied, 'Hard'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge showing mastery status
class MasteryBadge extends StatelessWidget {
  final bool isMastered;
  final int reviewCount;
  final bool isNew;

  const MasteryBadge({
    super.key,
    this.isMastered = false,
    this.reviewCount = 0,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isNew || reviewCount == 0) {
      return _buildBadge(Icons.fiber_new, 'New', Colors.blue);
    }
    if (isMastered) {
      return _buildBadge(Icons.star, 'Mastered', Colors.amber);
    }
    return _buildBadge(Icons.repeat, '${reviewCount}x', Colors.purple);
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Review result for spaced repetition
enum ReviewResult {
  again,  // Wrong, show again soon
  hard,   // Got it but struggled
  good,   // Got it correctly
  easy,   // Too easy
}

/// 4-button rating system for spaced repetition
class RatingButtons extends StatelessWidget {
  final Function(ReviewResult) onRate;
  final bool isJunior;

  const RatingButtons({
    super.key,
    required this.onRate,
    this.isJunior = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _RatingButton(
          label: 'Again',
          icon: Icons.refresh,
          color: Colors.red,
          interval: '<1m',
          onPressed: () => onRate(ReviewResult.again),
          isJunior: isJunior,
        ),
        _RatingButton(
          label: 'Hard',
          icon: Icons.sentiment_dissatisfied,
          color: Colors.orange,
          interval: '6m',
          onPressed: () => onRate(ReviewResult.hard),
          isJunior: isJunior,
        ),
        _RatingButton(
          label: 'Good',
          icon: Icons.sentiment_neutral,
          color: Colors.blue,
          interval: '1d',
          onPressed: () => onRate(ReviewResult.good),
          isJunior: isJunior,
        ),
        _RatingButton(
          label: 'Easy',
          icon: Icons.sentiment_satisfied,
          color: Colors.green,
          interval: '4d',
          onPressed: () => onRate(ReviewResult.easy),
          isJunior: isJunior,
        ),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String interval;
  final VoidCallback onPressed;
  final bool isJunior;

  const _RatingButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.interval,
    required this.onPressed,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: isJunior ? 12 : 10,
          horizontal: isJunior ? 12 : 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isJunior ? 28 : 24),
          SizedBox(height: isJunior ? 6 : 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isJunior ? 14 : 12,
            ),
          ),
          Text(
            interval,
            style: TextStyle(
              fontSize: isJunior ? 10 : 9,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple 2-button rating for Junior segment
class SimpleRatingButtons extends StatelessWidget {
  final VoidCallback onKnow;
  final VoidCallback onDontKnow;
  final bool isJunior;

  const SimpleRatingButtons({
    super.key,
    required this.onKnow,
    required this.onDontKnow,
    this.isJunior = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Don't Know button
        Expanded(
          child: FilledButton.icon(
            onPressed: onDontKnow,
            icon: Icon(
              Icons.close,
              size: isJunior ? 28 : 24,
            ),
            label: Text(
              "Don't Know",
              style: isJunior
                  ? Theme.of(context).textTheme.titleMedium
                  : null,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              padding: EdgeInsets.symmetric(
                vertical: isJunior ? 16 : 12,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Know button
        Expanded(
          child: FilledButton.icon(
            onPressed: onKnow,
            icon: Icon(
              Icons.check,
              size: isJunior ? 28 : 24,
            ),
            label: Text(
              'I Know This',
              style: isJunior
                  ? Theme.of(context).textTheme.titleMedium
                  : null,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(
                vertical: isJunior ? 16 : 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
