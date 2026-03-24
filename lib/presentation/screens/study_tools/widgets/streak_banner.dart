/// Streak Banner widget for flashcard study
library;

import 'package:flutter/material.dart';

/// Banner showing current study streak
class StreakBanner extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final int cardsStudiedToday;
  final int todayAccuracy;

  const StreakBanner({
    super.key,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.cardsStudiedToday = 0,
    this.todayAccuracy = 0,
  });

  @override
  Widget build(BuildContext context) {
    final hasStreak = currentStreak > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hasStreak
              ? [Colors.orange, Colors.deepOrange]
              : [Colors.grey.shade400, Colors.grey.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (hasStreak ? Colors.orange : Colors.grey).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Flame icon
          Icon(
            Icons.local_fire_department,
            size: 36,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          // Streak count
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$currentStreak',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                currentStreak == 1 ? 'Day Streak' : 'Day Streak',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Mini stats
          _MiniStat(
            label: 'Today',
            value: '$cardsStudiedToday',
          ),
          const SizedBox(width: 16),
          _MiniStat(
            label: 'Accuracy',
            value: '$todayAccuracy%',
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

/// Compact streak indicator for app bars
class CompactStreakIndicator extends StatelessWidget {
  final int streak;

  const CompactStreakIndicator({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
