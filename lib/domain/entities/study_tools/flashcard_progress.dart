/// Flashcard Progress entity for spaced repetition
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_progress.freezed.dart';
part 'flashcard_progress.g.dart';

@freezed
class FlashcardProgress with _$FlashcardProgress {
  const factory FlashcardProgress({
    required String id,
    required String cardId,
    required String profileId,
    @Default(false) bool known,
    @Default(2.5) double easeFactor,
    @Default(1) int intervalDays,
    DateTime? nextReviewDate,
    @Default(0) int reviewCount,
    @Default(0) int correctCount,
    DateTime? lastReviewedAt,
  }) = _FlashcardProgress;

  const FlashcardProgress._();

  factory FlashcardProgress.fromJson(Map<String, dynamic> json) =>
      _$FlashcardProgressFromJson(json);

  /// Check if card has been reviewed
  bool get hasBeenReviewed => reviewCount > 0;

  /// Check if card is due for review
  bool get isDueForReview {
    if (nextReviewDate == null) return true;
    return DateTime.now().isAfter(nextReviewDate!);
  }

  /// Get accuracy percentage (0-100)
  double get accuracyPercentage {
    if (reviewCount == 0) return 0.0;
    return (correctCount / reviewCount) * 100;
  }

  /// Check if card is well-learned (high accuracy)
  bool get isWellLearned => accuracyPercentage >= 80 && reviewCount >= 3;

  /// Check if card needs more practice
  bool get needsPractice => accuracyPercentage < 60 || reviewCount < 2;

  /// Get mastery level based on ease factor and reviews
  MasteryLevel get masteryLevel {
    if (reviewCount == 0) return MasteryLevel.notStarted;
    if (accuracyPercentage < 40) return MasteryLevel.struggling;
    if (accuracyPercentage < 60) return MasteryLevel.learning;
    if (accuracyPercentage < 80) return MasteryLevel.familiar;
    if (intervalDays >= 7) return MasteryLevel.mastered;
    return MasteryLevel.comfortable;
  }

  /// Get days until next review
  int? get daysUntilReview {
    if (nextReviewDate == null) return null;
    final difference = nextReviewDate!.difference(DateTime.now());
    return difference.inDays;
  }

  /// Get days since last review
  int? get daysSinceLastReview {
    if (lastReviewedAt == null) return null;
    final difference = DateTime.now().difference(lastReviewedAt!);
    return difference.inDays;
  }
}

/// Mastery level for flashcard learning
enum MasteryLevel {
  notStarted,  // Never reviewed
  struggling,  // Low accuracy (<40%)
  learning,    // Medium-low accuracy (40-60%)
  familiar,    // Medium-high accuracy (60-80%)
  comfortable, // High accuracy (>80%)
  mastered,    // High accuracy + long interval
}

/// Study session result for a deck
@freezed
class FlashcardStudySession with _$FlashcardStudySession {
  const factory FlashcardStudySession({
    required String deckId,
    required String profileId,
    required int totalCards,
    required int knownCards,
    required int unknownCards,
    required Duration duration,
    required DateTime completedAt,
  }) = _FlashcardStudySession;

  const FlashcardStudySession._();

  factory FlashcardStudySession.fromJson(Map<String, dynamic> json) =>
      _$FlashcardStudySessionFromJson(json);

  /// Get accuracy percentage (0-100)
  double get accuracyPercentage {
    if (totalCards == 0) return 0.0;
    return (knownCards / totalCards) * 100;
  }

  /// Get formatted duration (e.g., "5m 30s")
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Get average time per card in seconds
  double get averageTimePerCard {
    if (totalCards == 0) return 0.0;
    return duration.inSeconds / totalCards;
  }

  /// Check if session was successful (>= 70% accuracy)
  bool get isSuccessful => accuracyPercentage >= 70;
}

/// Deck progress summary combining all card progress
@freezed
class DeckProgress with _$DeckProgress {
  const factory DeckProgress({
    required String deckId,
    required String profileId,
    required int totalCards,
    required int reviewedCards,
    required int masteredCards,
    required int dueCards,
    required double averageAccuracy,
    DateTime? lastStudiedAt,
  }) = _DeckProgress;

  const DeckProgress._();

  factory DeckProgress.fromJson(Map<String, dynamic> json) =>
      _$DeckProgressFromJson(json);

  /// Get progress percentage (0-100)
  double get progressPercentage {
    if (totalCards == 0) return 0.0;
    return (reviewedCards / totalCards) * 100;
  }

  /// Get mastery percentage (0-100)
  double get masteryPercentage {
    if (totalCards == 0) return 0.0;
    return (masteredCards / totalCards) * 100;
  }

  /// Check if deck has been started
  bool get hasStarted => reviewedCards > 0;

  /// Check if deck is completed (all cards mastered)
  bool get isCompleted => masteredCards == totalCards && totalCards > 0;

  /// Get cards remaining to master
  int get cardsToMaster => totalCards - masteredCards;

  /// Check if there are cards due for review
  bool get hasDueCards => dueCards > 0;
}
