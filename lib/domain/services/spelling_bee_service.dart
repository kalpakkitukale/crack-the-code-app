import 'dart:math';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_bee_round.dart';

/// Service for managing Spelling Bee competitions
class SpellingBeeService {
  final Random _random = Random();

  /// Generate rounds for a spelling bee from available words
  List<SpellingBeeRound> generateRounds(List<Word> words, int roundCount) {
    if (words.isEmpty) return [];

    // Sort by difficulty, then shuffle within difficulty groups
    final easy = words.where((w) => w.difficulty == 'easy').toList()..shuffle(_random);
    final medium = words.where((w) => w.difficulty == 'medium').toList()..shuffle(_random);
    final hard = words.where((w) => w.difficulty == 'hard').toList()..shuffle(_random);

    // Build rounds with progressive difficulty
    final selectedWords = <Word>[];
    final easyCount = (roundCount * 0.3).ceil();
    final mediumCount = (roundCount * 0.4).ceil();
    final hardCount = roundCount - easyCount - mediumCount;

    selectedWords.addAll(easy.take(easyCount));
    selectedWords.addAll(medium.take(mediumCount));
    selectedWords.addAll(hard.take(hardCount));

    // If not enough words, fill from available pool
    if (selectedWords.length < roundCount) {
      final remaining = words.where((w) => !selectedWords.contains(w)).toList()..shuffle(_random);
      selectedWords.addAll(remaining.take(roundCount - selectedWords.length));
    }

    return List.generate(
      selectedWords.length.clamp(0, roundCount),
      (i) => SpellingBeeRound(
        roundNumber: i + 1,
        wordId: selectedWords[i].id,
        word: selectedWords[i].word,
        definition: selectedWords[i].definition,
        partOfSpeech: selectedWords[i].partOfSpeech,
        exampleSentence: selectedWords[i].exampleSentences.isNotEmpty
            ? selectedWords[i].exampleSentences.first
            : null,
        etymology: selectedWords[i].etymology,
        difficulty: selectedWords[i].difficulty,
      ),
    );
  }

  /// Calculate score for a completed spelling bee
  SpellingBeeScore calculateScore(List<SpellingBeeRound> rounds) {
    final completed = rounds.where((r) => r.isCompleted).toList();
    final correct = completed.where((r) => r.isCorrect).toList();
    final totalHints = completed.fold<int>(0, (sum, r) => sum + r.hintsUsed);

    int basePoints = 0;
    int streakBonus = 0;
    int currentStreak = 0;

    for (final round in completed) {
      if (round.isCorrect) {
        // Base points by difficulty
        final diffPoints = switch (round.difficulty) {
          'easy' => 10,
          'medium' => 20,
          'hard' => 30,
          _ => 10,
        };

        // Hint penalty
        final hintPenalty = round.hintsUsed * 3;
        basePoints += (diffPoints - hintPenalty).clamp(0, diffPoints);

        // Streak bonus
        currentStreak++;
        if (currentStreak >= 3) {
          streakBonus += currentStreak * 5;
        }
      } else {
        currentStreak = 0;
      }
    }

    return SpellingBeeScore(
      totalRounds: rounds.length,
      completedRounds: completed.length,
      correctRounds: correct.length,
      basePoints: basePoints,
      streakBonus: streakBonus,
      totalPoints: basePoints + streakBonus,
      totalHintsUsed: totalHints,
      accuracy: completed.isNotEmpty ? correct.length / completed.length : 0.0,
      isPerfect: correct.length == rounds.length && totalHints == 0,
    );
  }
}

/// Score for a completed spelling bee
class SpellingBeeScore {
  final int totalRounds;
  final int completedRounds;
  final int correctRounds;
  final int basePoints;
  final int streakBonus;
  final int totalPoints;
  final int totalHintsUsed;
  final double accuracy;
  final bool isPerfect;

  const SpellingBeeScore({
    required this.totalRounds,
    required this.completedRounds,
    required this.correctRounds,
    required this.basePoints,
    required this.streakBonus,
    required this.totalPoints,
    required this.totalHintsUsed,
    required this.accuracy,
    required this.isPerfect,
  });
}
