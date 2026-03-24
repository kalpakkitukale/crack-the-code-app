/// Tests for SpellingCheckerService
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/domain/services/spelling_checker_service.dart';

void main() {
  late SpellingCheckerService checker;

  setUp(() {
    checker = SpellingCheckerService();
  });

  group('SpellingCheckerService', () {
    group('Exact match', () {
      test('returns correct for exact match', () {
        final result = checker.check('cat', 'cat');
        expect(result.isCorrect, true);
        expect(result.similarity, 1.0);
      });

      test('returns correct for case-insensitive match with 0.99 similarity', () {
        final result = checker.check('Cat', 'cat');
        expect(result.isCorrect, true);
        expect(result.similarity, 0.99);
      });

      test('returns correct for all-uppercase match', () {
        final result = checker.check('CAT', 'cat');
        expect(result.isCorrect, true);
        expect(result.similarity, 0.99);
      });

      test('exact match has similarity 1.0', () {
        final result = checker.check('beautiful', 'beautiful');
        expect(result.isCorrect, true);
        expect(result.similarity, 1.0);
      });
    });

    group('Incorrect spelling', () {
      test('detects completely wrong word', () {
        final result = checker.check('xyz', 'cat');
        expect(result.isCorrect, false);
        expect(result.similarity, lessThan(0.5));
      });

      test('detects close misspelling', () {
        final result = checker.check('cet', 'cat');
        expect(result.isCorrect, false);
        expect(result.similarity, greaterThan(0.5));
      });

      test('detects one letter off', () {
        final result = checker.check('bat', 'cat');
        expect(result.isCorrect, false);
        // 'bat' vs 'cat': Levenshtein distance 1, max length 3 => similarity ~0.67
        expect(result.similarity, greaterThanOrEqualTo(0.5));
      });

      test('detects longer wrong word', () {
        final result = checker.check('catastrophe', 'cat');
        expect(result.isCorrect, false);
      });
    });

    group('Mistake detection', () {
      test('detects swapped letters', () {
        final result = checker.check('teh', 'the');
        expect(result.isCorrect, false);
        expect(
          result.mistakes.any((m) => m.type == MistakeType.swappedLetters),
          true,
        );
      });

      test('detects extra letter', () {
        final result = checker.check('caat', 'cat');
        expect(result.isCorrect, false);
        expect(
          result.mistakes.any((m) => m.type == MistakeType.extraLetter),
          true,
        );
      });

      test('detects missing letter', () {
        final result = checker.check('ct', 'cat');
        expect(result.isCorrect, false);
        expect(
          result.mistakes.any((m) => m.type == MistakeType.missingLetter),
          true,
        );
      });

      test('detects doubling error - missing double', () {
        final result = checker.check('runing', 'running');
        expect(result.isCorrect, false);
        expect(
          result.mistakes.any((m) => m.type == MistakeType.doublingError),
          true,
        );
      });

      test('detects doubling error - extra double', () {
        final result = checker.check('runninng', 'running');
        expect(result.isCorrect, false);
        expect(
          result.mistakes.any((m) => m.type == MistakeType.doublingError),
          true,
        );
      });

      test('detects vowel confusion', () {
        // Same length, vowel swapped: 'cet' vs 'cat' (e vs a)
        final result = checker.check('cet', 'cat');
        expect(result.isCorrect, false);
        expect(
          result.mistakes.any((m) => m.type == MistakeType.vowelConfusion),
          true,
        );
      });

      test('does not detect vowel confusion for different lengths', () {
        // vowelConfusion requires same length
        final result = checker.check('ce', 'cat');
        expect(
          result.mistakes.any((m) => m.type == MistakeType.vowelConfusion),
          false,
        );
      });

      test('swapped letters requires same length', () {
        final result = checker.check('te', 'the');
        expect(
          result.mistakes.any((m) => m.type == MistakeType.swappedLetters),
          false,
        );
      });
    });

    group('Similarity scores', () {
      test('identical words have similarity 1.0', () {
        final result = checker.check('beautiful', 'beautiful');
        expect(result.similarity, 1.0);
      });

      test('empty input has similarity 0.0', () {
        final result = checker.check('', 'cat');
        expect(result.isCorrect, false);
        expect(result.similarity, 0.0);
      });

      test('one letter missing from end has high similarity', () {
        // 'knif' vs 'knife': distance 1, max 5 => similarity 0.8
        final result = checker.check('knif', 'knife');
        expect(result.similarity, greaterThan(0.7));
      });

      test('completely different words have low similarity', () {
        final result = checker.check('abcdef', 'xyz');
        expect(result.similarity, lessThan(0.3));
      });

      test('similarity is symmetric in calculation', () {
        final r1 = checker.check('abc', 'abd');
        final r2 = checker.check('abd', 'abc');
        // Both should have same Levenshtein distance
        expect(r1.similarity, r2.similarity);
      });
    });

    group('Feedback messages', () {
      test('correct exact match gives Perfect feedback', () {
        final result = checker.check('cat', 'cat');
        expect(result.feedback, contains('Perfect'));
      });

      test('correct case-insensitive match mentions capitalization', () {
        final result = checker.check('Cat', 'cat');
        expect(result.feedback, contains('capitalization'));
      });

      test('high similarity gives Almost feedback', () {
        // 'knif' vs 'knife': similarity 0.8 => "Almost!"
        final result = checker.check('knif', 'knife');
        expect(result.feedback, contains('Almost'));
      });

      test('medium similarity gives Good try feedback', () {
        // 'kt' vs 'knife': similarity ~0.2 => low
        // Need something with 0.5-0.8 similarity
        // 'kife' vs 'knife': distance 1, max 5 => 0.8 (too high)
        // 'kn' vs 'knife': distance 3, max 5 => 0.4 (too low)
        // 'knfe' vs 'knife': distance 1, max 5 => 0.8
        // 'kif' vs 'knife': distance 2, max 5 => 0.6
        final result = checker.check('kif', 'knife');
        expect(result.feedback, contains('Good try'));
      });

      test('low similarity gives try again feedback', () {
        final result = checker.check('xyz', 'cat');
        expect(result.feedback, contains('try again'));
      });
    });

    group('Edge cases', () {
      test('handles leading/trailing whitespace in input', () {
        final result = checker.check(' cat ', 'cat');
        expect(result.isCorrect, true);
      });

      test('handles whitespace in correct word', () {
        final result = checker.check('cat', ' cat ');
        expect(result.isCorrect, true);
      });

      test('handles single character word', () {
        final result = checker.check('a', 'a');
        expect(result.isCorrect, true);
        expect(result.similarity, 1.0);
      });

      test('handles long words', () {
        final result = checker.check('onomatopoeia', 'onomatopoeia');
        expect(result.isCorrect, true);
        expect(result.similarity, 1.0);
      });

      test('incorrect result includes correctWord', () {
        final result = checker.check('cet', 'cat');
        expect(result.correctWord, 'cat');
      });

      test('correct result does not include correctWord', () {
        final result = checker.check('cat', 'cat');
        expect(result.correctWord, isNull);
      });

      test('incorrect result includes mistakes list', () {
        final result = checker.check('ct', 'cat');
        expect(result.mistakes, isNotEmpty);
      });

      test('correct result has empty mistakes list', () {
        final result = checker.check('cat', 'cat');
        expect(result.mistakes, isEmpty);
      });
    });
  });
}
