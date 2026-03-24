/// Overall spelling statistics for a user
class SpellingStatistics {
  final int totalWordsLearned;
  final int totalWordsMastered;
  final int totalAttempts;
  final int totalCorrect;
  final int currentStreak; // consecutive days of practice
  final int longestStreak;
  final int spellingBeesCompleted;
  final int spellingBeesWon;
  final Map<String, int> weakPatterns; // pattern -> error count
  final Map<String, int> masteryByGrade; // grade -> mastered count
  final DateTime? lastPracticeDate;
  final int totalPracticeMinutes;

  const SpellingStatistics({
    this.totalWordsLearned = 0,
    this.totalWordsMastered = 0,
    this.totalAttempts = 0,
    this.totalCorrect = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.spellingBeesCompleted = 0,
    this.spellingBeesWon = 0,
    this.weakPatterns = const {},
    this.masteryByGrade = const {},
    this.lastPracticeDate,
    this.totalPracticeMinutes = 0,
  });

  double get overallAccuracy =>
      totalAttempts > 0 ? totalCorrect / totalAttempts : 0.0;

  double get spellingBeeWinRate =>
      spellingBeesCompleted > 0
          ? spellingBeesWon / spellingBeesCompleted
          : 0.0;
}
