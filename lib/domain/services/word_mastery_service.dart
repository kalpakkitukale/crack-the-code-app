import 'dart:math';
import 'package:streamshaala/domain/entities/spelling/word_mastery.dart';

/// Service for calculating word mastery using SM-2 spaced repetition
class WordMasteryService {
  static const int _masteryThreshold = 3; // correct streak to master

  /// Update mastery after a spelling attempt
  WordMastery updateMastery(WordMastery current, bool isCorrect) {
    final now = DateTime.now();
    final newTotalAttempts = current.totalAttempts + 1;
    final newCorrectAttempts = current.correctAttempts + (isCorrect ? 1 : 0);
    final newCorrectStreak = isCorrect ? current.correctStreak + 1 : 0;

    // Calculate SM-2 values
    final quality = isCorrect ? (newCorrectStreak >= 2 ? 5 : 4) : (current.similarity >= 0.7 ? 2 : 1);
    final newEaseFactor = _calculateEaseFactor(current.easeFactor, quality);
    final newInterval = _calculateInterval(current.interval, newEaseFactor, quality, newCorrectStreak);

    // Determine mastery level
    MasteryLevel newLevel;
    if (newCorrectStreak >= _masteryThreshold) {
      newLevel = MasteryLevel.mastered;
    } else if (current.level == MasteryLevel.mastered && !isCorrect) {
      newLevel = MasteryLevel.reviewing;
    } else if (newTotalAttempts > 0 && newCorrectAttempts > 0) {
      newLevel = newCorrectStreak >= 1 ? MasteryLevel.reviewing : MasteryLevel.learning;
    } else {
      newLevel = MasteryLevel.learning;
    }

    return current.copyWith(
      level: newLevel,
      correctStreak: newCorrectStreak,
      totalAttempts: newTotalAttempts,
      correctAttempts: newCorrectAttempts,
      lastAttemptedAt: now,
      nextReviewAt: now.add(Duration(days: newInterval)),
      easeFactor: newEaseFactor,
      interval: newInterval,
    );
  }

  double _calculateEaseFactor(double currentEF, int quality) {
    final newEF = currentEF + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    return max(1.3, newEF);
  }

  int _calculateInterval(int currentInterval, double easeFactor, int quality, int streak) {
    if (quality < 3) return 1; // Reset on poor quality
    if (streak <= 1) return 1;
    if (streak == 2) return 3;
    return (currentInterval * easeFactor).round();
  }

  /// Get words that are due for review
  List<WordMastery> getDueForReview(List<WordMastery> masteries) {
    final now = DateTime.now();
    return masteries
        .where((m) => m.level != MasteryLevel.newWord)
        .where((m) => m.nextReviewAt == null || now.isAfter(m.nextReviewAt!))
        .toList()
      ..sort((a, b) {
        // Prioritize: reviewing > learning > mastered
        final levelPriority = {
          MasteryLevel.reviewing: 0,
          MasteryLevel.learning: 1,
          MasteryLevel.mastered: 2,
          MasteryLevel.newWord: 3,
        };
        return (levelPriority[a.level] ?? 3).compareTo(levelPriority[b.level] ?? 3);
      });
  }
}

// Extension to add similarity property (used in mastery calculation)
extension on WordMastery {
  double get similarity => accuracy;
}
