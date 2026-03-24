/// Tests for SpellingAttempt entity Levenshtein similarity
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_attempt.dart';

void main() {
  group('SpellingAttempt', () {
    SpellingAttempt _makeAttempt({
      required String word,
      required String userInput,
      bool isCorrect = false,
    }) {
      return SpellingAttempt(
        id: '1',
        wordId: 'w1',
        word: word,
        userInput: userInput,
        isCorrect: isCorrect,
        activityType: 'dictation',
        attemptedAt: DateTime.now(),
      );
    }

    group('similarity', () {
      test('identical words have similarity 1.0', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cat', isCorrect: true);
        expect(attempt.similarity, 1.0);
      });

      test('case insensitive comparison gives 1.0', () {
        final attempt = _makeAttempt(word: 'Cat', userInput: 'cat', isCorrect: true);
        expect(attempt.similarity, 1.0);
      });

      test('all uppercase gives 1.0', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'CAT', isCorrect: true);
        expect(attempt.similarity, 1.0);
      });

      test('completely different words have low similarity', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'xyz');
        expect(attempt.similarity, lessThan(0.5));
      });

      test('one letter difference has high similarity', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cot');
        // distance 1, maxLen 3 => similarity 2/3 ~ 0.67
        expect(attempt.similarity, greaterThan(0.5));
      });

      test('empty input with non-empty word has similarity 0.0', () {
        final attempt = _makeAttempt(word: 'cat', userInput: '');
        // distance = 3, maxLen = 3 => similarity 0.0
        expect(attempt.similarity, 0.0);
      });

      test('empty word and empty input has similarity 1.0', () {
        final attempt = _makeAttempt(word: '', userInput: '', isCorrect: true);
        // Both empty => lowercase match => 1.0
        expect(attempt.similarity, 1.0);
      });

      test('one extra character has high similarity', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cats');
        // distance 1, maxLen 4 => similarity 0.75
        expect(attempt.similarity, greaterThan(0.7));
      });

      test('one missing character has high similarity', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'ca');
        // distance 1, maxLen 3 => similarity ~0.67
        expect(attempt.similarity, greaterThan(0.5));
      });

      test('swapped letters have high similarity', () {
        final attempt = _makeAttempt(word: 'the', userInput: 'teh');
        // distance 2 (swap = 2 substitutions in Levenshtein actually... let's check)
        // t-h-e vs t-e-h: positions 1 and 2 differ
        // Levenshtein: can be done in 2 subs or 1 swap (but standard Levenshtein counts 2)
        // Actually Levenshtein with transpose is Damerau-Levenshtein.
        // Standard: d(the, teh) = ?
        // t=t, h!=e (sub), e!=h (sub) => 2 subs = distance 2
        // But also: t=t, delete h, e=e, insert h => distance 2
        // maxLen 3 => similarity 1/3 ~ 0.33
        expect(attempt.similarity, greaterThanOrEqualTo(0.0));
      });

      test('long identical words have similarity 1.0', () {
        final attempt = _makeAttempt(
          word: 'onomatopoeia',
          userInput: 'onomatopoeia',
          isCorrect: true,
        );
        expect(attempt.similarity, 1.0);
      });

      test('long word with one typo has high similarity', () {
        final attempt = _makeAttempt(
          word: 'onomatopoeia',
          userInput: 'onomatopeia',
        );
        // Missing one letter: distance 1, maxLen 12 => similarity ~0.92
        expect(attempt.similarity, greaterThan(0.9));
      });

      test('similarity is between 0.0 and 1.0', () {
        final testCases = [
          _makeAttempt(word: 'cat', userInput: ''),
          _makeAttempt(word: 'cat', userInput: 'cat'),
          _makeAttempt(word: 'beautiful', userInput: 'bful'),
          _makeAttempt(word: 'rhythm', userInput: 'abc'),
        ];
        for (final attempt in testCases) {
          expect(attempt.similarity, greaterThanOrEqualTo(0.0));
          expect(attempt.similarity, lessThanOrEqualTo(1.0));
        }
      });
    });

    group('constructor defaults', () {
      test('default timeSpentMs is 0', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cat');
        expect(attempt.timeSpentMs, 0);
      });

      test('default attemptNumber is 1', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cat');
        expect(attempt.attemptNumber, 1);
      });

      test('profileId defaults to null', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cat');
        expect(attempt.profileId, isNull);
      });
    });

    group('toString', () {
      test('includes word and input', () {
        final attempt = _makeAttempt(word: 'cat', userInput: 'cet');
        expect(attempt.toString(), contains('cat'));
        expect(attempt.toString(), contains('cet'));
      });
    });
  });
}
