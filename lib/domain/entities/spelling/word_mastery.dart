/// Tracks mastery level for a specific word
enum MasteryLevel {
  /// Word is new, never practiced
  newWord,
  /// Currently learning, has been attempted
  learning,
  /// Word has been learned, needs periodic review
  reviewing,
  /// Word is fully mastered (3+ correct in a row)
  mastered,
}

class WordMastery {
  final String wordId;
  final String word;
  final MasteryLevel level;
  final int correctStreak;
  final int totalAttempts;
  final int correctAttempts;
  final DateTime? lastAttemptedAt;
  final DateTime? nextReviewAt;
  final double easeFactor; // SM-2 ease factor
  final int interval; // SM-2 interval in days
  final String? profileId;

  const WordMastery({
    required this.wordId,
    required this.word,
    this.level = MasteryLevel.newWord,
    this.correctStreak = 0,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.lastAttemptedAt,
    this.nextReviewAt,
    this.easeFactor = 2.5,
    this.interval = 0,
    this.profileId,
  });

  double get accuracy =>
      totalAttempts > 0 ? correctAttempts / totalAttempts : 0.0;

  bool get isDueForReview {
    if (nextReviewAt == null) return true;
    return DateTime.now().isAfter(nextReviewAt!);
  }

  WordMastery copyWith({
    MasteryLevel? level,
    int? correctStreak,
    int? totalAttempts,
    int? correctAttempts,
    DateTime? lastAttemptedAt,
    DateTime? nextReviewAt,
    double? easeFactor,
    int? interval,
  }) {
    return WordMastery(
      wordId: wordId,
      word: word,
      level: level ?? this.level,
      correctStreak: correctStreak ?? this.correctStreak,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctAttempts: correctAttempts ?? this.correctAttempts,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      profileId: profileId,
    );
  }

  @override
  String toString() =>
      'WordMastery(word: $word, level: ${level.name}, streak: $correctStreak, accuracy: ${(accuracy * 100).toStringAsFixed(0)}%)';
}
