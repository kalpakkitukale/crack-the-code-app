/// Tests for SpellingBeeService round generation and scoring
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/services/spelling_bee_service.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_bee_round.dart';

void main() {
  late SpellingBeeService service;

  final testWords = [
    const Word(
      id: 'w1', word: 'cat', phonetic: '/kæt/',
      definition: 'A small pet animal', partOfSpeech: 'noun',
      difficulty: 'easy', gradeLevel: 1,
    ),
    const Word(
      id: 'w2', word: 'bat', phonetic: '/bæt/',
      definition: 'A flying animal', partOfSpeech: 'noun',
      difficulty: 'easy', gradeLevel: 1,
    ),
    const Word(
      id: 'w3', word: 'knife', phonetic: '/naɪf/',
      definition: 'A cutting tool', partOfSpeech: 'noun',
      difficulty: 'medium', gradeLevel: 3,
    ),
    const Word(
      id: 'w4', word: 'write', phonetic: '/raɪt/',
      definition: 'To put words on paper', partOfSpeech: 'verb',
      difficulty: 'medium', gradeLevel: 3,
    ),
    const Word(
      id: 'w5', word: 'rhythm', phonetic: '/rɪðəm/',
      definition: 'A pattern of sounds', partOfSpeech: 'noun',
      difficulty: 'hard', gradeLevel: 6,
    ),
    const Word(
      id: 'w6', word: 'beautiful', phonetic: '/bjuːtɪfəl/',
      definition: 'Very pretty', partOfSpeech: 'adjective',
      difficulty: 'hard', gradeLevel: 4,
    ),
  ];

  setUp(() {
    service = SpellingBeeService();
  });

  group('SpellingBeeService', () {
    group('generateRounds', () {
      test('generates requested number of rounds', () {
        final rounds = service.generateRounds(testWords, 5);
        expect(rounds.length, 5);
      });

      test('generates fewer rounds if not enough words', () {
        final rounds = service.generateRounds(testWords.take(2).toList(), 5);
        expect(rounds.length, lessThanOrEqualTo(5));
        expect(rounds.length, lessThanOrEqualTo(2));
      });

      test('returns empty for empty word list', () {
        final rounds = service.generateRounds([], 5);
        expect(rounds, isEmpty);
      });

      test('returns empty for zero round count', () {
        final rounds = service.generateRounds(testWords, 0);
        expect(rounds, isEmpty);
      });

      test('rounds have correct word data', () {
        final rounds = service.generateRounds(testWords, 3);
        for (final round in rounds) {
          expect(round.word, isNotEmpty);
          expect(round.definition, isNotEmpty);
          expect(round.roundNumber, greaterThan(0));
          expect(round.wordId, isNotEmpty);
          expect(round.difficulty, isNotEmpty);
        }
      });

      test('rounds are numbered sequentially starting at 1', () {
        final rounds = service.generateRounds(testWords, 4);
        for (int i = 0; i < rounds.length; i++) {
          expect(rounds[i].roundNumber, i + 1);
        }
      });

      test('rounds start uncompleted and incorrect', () {
        final rounds = service.generateRounds(testWords, 3);
        for (final round in rounds) {
          expect(round.isCompleted, false);
          expect(round.isCorrect, false);
          expect(round.hintsUsed, 0);
        }
      });

      test('includes mix of difficulties when enough words', () {
        final rounds = service.generateRounds(testWords, 6);
        final difficulties = rounds.map((r) => r.difficulty).toSet();
        expect(difficulties.length, greaterThan(1));
      });

      test('word data matches source words', () {
        final rounds = service.generateRounds(testWords, 6);
        for (final round in rounds) {
          final sourceWord = testWords.firstWhere((w) => w.id == round.wordId);
          expect(round.word, sourceWord.word);
          expect(round.definition, sourceWord.definition);
          expect(round.difficulty, sourceWord.difficulty);
          expect(round.partOfSpeech, sourceWord.partOfSpeech);
        }
      });

      test('does not duplicate words within rounds', () {
        final rounds = service.generateRounds(testWords, 6);
        final wordIds = rounds.map((r) => r.wordId).toList();
        expect(wordIds.toSet().length, wordIds.length);
      });
    });

    group('calculateScore', () {
      test('calculates score for all correct', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w3', word: 'knife',
            definition: 'A tool', difficulty: 'medium',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 3, wordId: 'w5', word: 'rhythm',
            definition: 'Pattern', difficulty: 'hard',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.correctRounds, 3);
        expect(score.totalRounds, 3);
        expect(score.completedRounds, 3);
        expect(score.totalPoints, greaterThan(0));
        expect(score.accuracy, 1.0);
        expect(score.isPerfect, true);
      });

      test('calculates score with some incorrect', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w3', word: 'knife',
            definition: 'A tool', difficulty: 'medium',
            isCompleted: true, isCorrect: false,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.correctRounds, 1);
        expect(score.completedRounds, 2);
        expect(score.accuracy, 0.5);
        expect(score.isPerfect, false);
      });

      test('all incorrect gives zero base points', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: false,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w3', word: 'knife',
            definition: 'A tool', difficulty: 'medium',
            isCompleted: true, isCorrect: false,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.correctRounds, 0);
        expect(score.basePoints, 0);
        expect(score.totalPoints, 0);
        expect(score.accuracy, 0.0);
        expect(score.isPerfect, false);
      });

      test('hint penalty reduces score', () {
        final noHints = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true, hintsUsed: 0,
          ),
        ];
        final withHints = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true, hintsUsed: 2,
          ),
        ];
        final scoreNoHints = service.calculateScore(noHints);
        final scoreWithHints = service.calculateScore(withHints);
        // Hint penalty: 2 * 3 = 6 points deducted
        expect(scoreWithHints.totalPoints, lessThan(scoreNoHints.totalPoints));
      });

      test('hint penalty does not reduce below zero', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true, hintsUsed: 100,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.basePoints, greaterThanOrEqualTo(0));
        expect(score.totalPoints, greaterThanOrEqualTo(0));
      });

      test('easy words give 10 base points', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.basePoints, 10);
      });

      test('medium words give 20 base points', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w3', word: 'knife',
            definition: 'A tool', difficulty: 'medium',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.basePoints, 20);
      });

      test('hard words give 30 base points', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w5', word: 'rhythm',
            definition: 'Pattern', difficulty: 'hard',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.basePoints, 30);
      });

      test('harder words give more points', () {
        final easy = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final hard = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w5', word: 'rhythm',
            definition: 'Pattern', difficulty: 'hard',
            isCompleted: true, isCorrect: true,
          ),
        ];
        expect(
          service.calculateScore(hard).totalPoints,
          greaterThan(service.calculateScore(easy).totalPoints),
        );
      });

      test('streak bonus applied for 3+ consecutive correct', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w2', word: 'bat',
            definition: 'Animal', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 3, wordId: 'w3', word: 'knife',
            definition: 'Tool', difficulty: 'medium',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.streakBonus, greaterThan(0));
        // streak of 3 => bonus = 3 * 5 = 15
        expect(score.streakBonus, 15);
        expect(score.totalPoints, score.basePoints + score.streakBonus);
      });

      test('no streak bonus for fewer than 3 consecutive', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w2', word: 'bat',
            definition: 'Animal', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.streakBonus, 0);
      });

      test('streak resets after incorrect answer', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w2', word: 'bat',
            definition: 'Animal', difficulty: 'easy',
            isCompleted: true, isCorrect: false,
          ),
          const SpellingBeeRound(
            roundNumber: 3, wordId: 'w3', word: 'knife',
            definition: 'Tool', difficulty: 'medium',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 4, wordId: 'w4', word: 'write',
            definition: 'Writing', difficulty: 'medium',
            isCompleted: true, isCorrect: true,
          ),
        ];
        final score = service.calculateScore(rounds);
        // Streak was broken at round 2, so max streak is 2 (rounds 3-4) => no bonus
        expect(score.streakBonus, 0);
      });

      test('empty rounds returns zero score', () {
        final score = service.calculateScore([]);
        expect(score.totalRounds, 0);
        expect(score.totalPoints, 0);
        expect(score.accuracy, 0.0);
        expect(score.correctRounds, 0);
        // Note: isPerfect is true for empty rounds (0 == 0 correct, 0 hints)
        expect(score.isPerfect, true);
      });

      test('uncompleted rounds are not counted for accuracy', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w2', word: 'bat',
            definition: 'Animal', difficulty: 'easy',
            isCompleted: false, isCorrect: false,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.totalRounds, 2);
        expect(score.completedRounds, 1);
        expect(score.accuracy, 1.0);
        // Not perfect because not all rounds completed (totalHints is 0, but correct != total)
        expect(score.isPerfect, false);
      });

      test('isPerfect requires all correct and no hints', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true, hintsUsed: 1,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.correctRounds, 1);
        // Not perfect because hints were used
        expect(score.isPerfect, false);
      });

      test('tracks total hints used', () {
        final rounds = [
          const SpellingBeeRound(
            roundNumber: 1, wordId: 'w1', word: 'cat',
            definition: 'A pet', difficulty: 'easy',
            isCompleted: true, isCorrect: true, hintsUsed: 2,
          ),
          const SpellingBeeRound(
            roundNumber: 2, wordId: 'w2', word: 'bat',
            definition: 'Animal', difficulty: 'easy',
            isCompleted: true, isCorrect: true, hintsUsed: 1,
          ),
        ];
        final score = service.calculateScore(rounds);
        expect(score.totalHintsUsed, 3);
      });
    });
  });
}
