enum PuzzleType { wordDecode, ruleQuiz, soundMatch }

class DailyPuzzle {
  final DateTime date;
  final PuzzleType type;
  final int seed;

  DailyPuzzle({required this.date})
      : type = PuzzleType.values[date.day % 3],
        seed = '${date.year}${date.month}${date.day}'.hashCode;
}

class DecoderProgress {
  final Map<String, int> completedDates; // "2026-03-28" → score
  final int currentStreak;
  final int bestScore;

  const DecoderProgress({
    this.completedDates = const {},
    this.currentStreak = 0,
    this.bestScore = 0,
  });

  bool isCompletedToday() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return completedDates.containsKey(today);
  }

  int? todayScore() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return completedDates[today];
  }

  DecoderProgress withScore(String date, int score) {
    final updated = Map<String, int>.from(completedDates);
    updated[date] = score;
    return DecoderProgress(
      completedDates: updated,
      currentStreak: currentStreak + 1,
      bestScore: score > bestScore ? score : bestScore,
    );
  }

  factory DecoderProgress.fromJson(Map<String, dynamic> json) {
    return DecoderProgress(
      completedDates: (json['completedDates'] as Map?)
              ?.map((k, v) => MapEntry(k.toString(), v as int)) ?? {},
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'completedDates': completedDates,
    'currentStreak': currentStreak,
    'bestScore': bestScore,
  };
}
