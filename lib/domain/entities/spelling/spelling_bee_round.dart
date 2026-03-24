/// Represents a round in a spelling bee competition
class SpellingBeeRound {
  final int roundNumber;
  final String wordId;
  final String word;
  final String definition;
  final String? partOfSpeech;
  final String? exampleSentence;
  final String? etymology;
  final String difficulty;
  final bool isCompleted;
  final bool isCorrect;
  final String? userAnswer;
  final int hintsUsed;
  final int timeSpentMs;

  const SpellingBeeRound({
    required this.roundNumber,
    required this.wordId,
    required this.word,
    required this.definition,
    this.partOfSpeech,
    this.exampleSentence,
    this.etymology,
    required this.difficulty,
    this.isCompleted = false,
    this.isCorrect = false,
    this.userAnswer,
    this.hintsUsed = 0,
    this.timeSpentMs = 0,
  });

  SpellingBeeRound copyWith({
    bool? isCompleted,
    bool? isCorrect,
    String? userAnswer,
    int? hintsUsed,
    int? timeSpentMs,
  }) {
    return SpellingBeeRound(
      roundNumber: roundNumber,
      wordId: wordId,
      word: word,
      definition: definition,
      partOfSpeech: partOfSpeech,
      exampleSentence: exampleSentence,
      etymology: etymology,
      difficulty: difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      isCorrect: isCorrect ?? this.isCorrect,
      userAnswer: userAnswer ?? this.userAnswer,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      timeSpentMs: timeSpentMs ?? this.timeSpentMs,
    );
  }
}
