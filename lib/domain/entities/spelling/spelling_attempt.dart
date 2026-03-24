/// Records a single spelling attempt for a word
class SpellingAttempt {
  final String id;
  final String wordId;
  final String word;
  final String userInput;
  final bool isCorrect;
  final String activityType; // dictation, unscramble, fill_blank, word_match, spelling_bee, flashcard
  final int timeSpentMs;
  final DateTime attemptedAt;
  final String? profileId;
  final int attemptNumber; // nth attempt for this word

  const SpellingAttempt({
    required this.id,
    required this.wordId,
    required this.word,
    required this.userInput,
    required this.isCorrect,
    required this.activityType,
    this.timeSpentMs = 0,
    required this.attemptedAt,
    this.profileId,
    this.attemptNumber = 1,
  });

  /// Calculate similarity between user input and correct word (0.0 to 1.0)
  double get similarity {
    if (userInput.toLowerCase() == word.toLowerCase()) return 1.0;
    final distance = _levenshteinDistance(userInput.toLowerCase(), word.toLowerCase());
    final maxLen = word.length > userInput.length ? word.length : userInput.length;
    if (maxLen == 0) return 1.0;
    return 1.0 - (distance / maxLen);
  }

  static int _levenshteinDistance(String s, String t) {
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    final List<List<int>> d = List.generate(
      s.length + 1,
      (i) => List.generate(t.length + 1, (j) => 0),
    );
    for (int i = 0; i <= s.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= t.length; j++) {
      d[0][j] = j;
    }
    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return d[s.length][t.length];
  }

  @override
  String toString() =>
      'SpellingAttempt(word: $word, input: $userInput, correct: $isCorrect)';
}
