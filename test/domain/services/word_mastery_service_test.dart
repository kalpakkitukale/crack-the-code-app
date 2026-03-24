/// Tests for WordMasteryService SM-2 spaced repetition logic
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/domain/services/word_mastery_service.dart';
import 'package:streamshaala/domain/entities/spelling/word_mastery.dart';

void main() {
  late WordMasteryService service;

  setUp(() {
    service = WordMasteryService();
  });

  group('WordMasteryService', () {
    group('updateMastery on correct answer', () {
      test('increments correct streak', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, true);
        expect(updated.correctStreak, 1);
        expect(updated.totalAttempts, 1);
        expect(updated.correctAttempts, 1);
      });

      test('first correct progresses to reviewing (streak >= 1)', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, true);
        expect(updated.level, MasteryLevel.reviewing);
      });

      test('second correct stays at reviewing', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        mastery = service.updateMastery(mastery, true);
        mastery = service.updateMastery(mastery, true);
        expect(mastery.level, MasteryLevel.reviewing);
        expect(mastery.correctStreak, 2);
      });

      test('reaches mastered after 3 consecutive correct', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        mastery = service.updateMastery(mastery, true);
        mastery = service.updateMastery(mastery, true);
        mastery = service.updateMastery(mastery, true);
        expect(mastery.level, MasteryLevel.mastered);
        expect(mastery.correctStreak, 3);
      });

      test('stays mastered after 4+ consecutive correct', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        for (int i = 0; i < 5; i++) {
          mastery = service.updateMastery(mastery, true);
        }
        expect(mastery.level, MasteryLevel.mastered);
        expect(mastery.correctStreak, 5);
      });

      test('tracks total and correct attempts accurately', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        mastery = service.updateMastery(mastery, true);
        mastery = service.updateMastery(mastery, false);
        mastery = service.updateMastery(mastery, true);
        expect(mastery.totalAttempts, 3);
        expect(mastery.correctAttempts, 2);
      });
    });

    group('updateMastery on incorrect answer', () {
      test('resets correct streak to 0', () {
        final mastery = WordMastery(
          wordId: 'w1',
          word: 'cat',
          level: MasteryLevel.reviewing,
          correctStreak: 2,
          totalAttempts: 2,
          correctAttempts: 2,
        );
        final updated = service.updateMastery(mastery, false);
        expect(updated.correctStreak, 0);
        expect(updated.totalAttempts, 3);
        expect(updated.correctAttempts, 2);
      });

      test('demotes mastered word to reviewing on error', () {
        final mastery = WordMastery(
          wordId: 'w1',
          word: 'cat',
          level: MasteryLevel.mastered,
          correctStreak: 5,
          totalAttempts: 5,
          correctAttempts: 5,
        );
        final updated = service.updateMastery(mastery, false);
        expect(updated.level, MasteryLevel.reviewing);
        expect(updated.correctStreak, 0);
      });

      test('incorrect on new word moves to learning', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, false);
        expect(updated.level, MasteryLevel.learning);
        expect(updated.correctStreak, 0);
        expect(updated.totalAttempts, 1);
        expect(updated.correctAttempts, 0);
      });

      test('incorrect after one correct goes to learning (streak 0)', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        mastery = service.updateMastery(mastery, true);
        expect(mastery.level, MasteryLevel.reviewing);
        mastery = service.updateMastery(mastery, false);
        // streak is 0, correctAttempts > 0, so learning
        expect(mastery.level, MasteryLevel.learning);
        expect(mastery.correctStreak, 0);
      });
    });

    group('Spaced repetition intervals', () {
      test('sets nextReviewAt in future after correct', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, true);
        expect(updated.nextReviewAt, isNotNull);
        expect(updated.nextReviewAt!.isAfter(DateTime.now().subtract(const Duration(seconds: 1))), true);
      });

      test('first correct sets interval to 1 day', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, true);
        // streak 1, quality 4, _calculateInterval: quality >= 3, streak <= 1 => 1
        expect(updated.interval, 1);
      });

      test('second correct sets interval to 3 days', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        mastery = service.updateMastery(mastery, true);
        mastery = service.updateMastery(mastery, true);
        // streak 2 => interval 3
        expect(mastery.interval, 3);
      });

      test('interval increases with more consecutive correct', () {
        var mastery = WordMastery(wordId: 'w1', word: 'cat');
        mastery = service.updateMastery(mastery, true);
        final interval1 = mastery.interval;
        mastery = service.updateMastery(mastery, true);
        final interval2 = mastery.interval;
        mastery = service.updateMastery(mastery, true);
        final interval3 = mastery.interval;
        expect(interval2, greaterThanOrEqualTo(interval1));
        expect(interval3, greaterThanOrEqualTo(interval2));
      });

      test('interval resets to 1 on incorrect answer', () {
        final mastery = WordMastery(
          wordId: 'w1',
          word: 'cat',
          level: MasteryLevel.reviewing,
          interval: 10,
          correctStreak: 3,
          totalAttempts: 3,
          correctAttempts: 3,
        );
        final updated = service.updateMastery(mastery, false);
        // quality < 3 => interval resets to 1
        expect(updated.interval, 1);
      });

      test('sets lastAttemptedAt on update', () {
        final before = DateTime.now().subtract(const Duration(seconds: 1));
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, true);
        expect(updated.lastAttemptedAt, isNotNull);
        expect(updated.lastAttemptedAt!.isAfter(before), true);
      });
    });

    group('Ease factor (SM-2)', () {
      test('ease factor starts at 2.5', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        expect(mastery.easeFactor, 2.5);
      });

      test('ease factor increases on correct', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, true);
        expect(updated.easeFactor, greaterThanOrEqualTo(2.5));
      });

      test('ease factor decreases on incorrect but stays above 1.3', () {
        final mastery = WordMastery(wordId: 'w1', word: 'cat');
        final updated = service.updateMastery(mastery, false);
        expect(updated.easeFactor, greaterThanOrEqualTo(1.3));
      });
    });

    group('getDueForReview', () {
      test('returns empty list for no masteries', () {
        final result = service.getDueForReview([]);
        expect(result, isEmpty);
      });

      test('excludes new words', () {
        final masteries = [
          WordMastery(wordId: 'w1', word: 'cat', level: MasteryLevel.newWord),
        ];
        final result = service.getDueForReview(masteries);
        expect(result, isEmpty);
      });

      test('includes words with past review date', () {
        final masteries = [
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.learning,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result.length, 1);
        expect(result.first.wordId, 'w1');
      });

      test('includes words with null review date (not new)', () {
        final masteries = [
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.learning,
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result.length, 1);
      });

      test('excludes words with future review date', () {
        final masteries = [
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.learning,
            nextReviewAt: DateTime.now().add(const Duration(days: 5)),
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result, isEmpty);
      });

      test('prioritizes reviewing over learning', () {
        final masteries = [
          WordMastery(
            wordId: 'w2',
            word: 'dog',
            level: MasteryLevel.learning,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.reviewing,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result.first.wordId, 'w1');
        expect(result.last.wordId, 'w2');
      });

      test('prioritizes reviewing over mastered', () {
        final masteries = [
          WordMastery(
            wordId: 'w2',
            word: 'dog',
            level: MasteryLevel.mastered,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.reviewing,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result.first.wordId, 'w1');
      });

      test('prioritizes learning over mastered', () {
        final masteries = [
          WordMastery(
            wordId: 'w2',
            word: 'dog',
            level: MasteryLevel.mastered,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.learning,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result.first.wordId, 'w1');
      });

      test('returns multiple due words sorted by priority', () {
        final masteries = [
          WordMastery(
            wordId: 'w3',
            word: 'fox',
            level: MasteryLevel.mastered,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          WordMastery(
            wordId: 'w1',
            word: 'cat',
            level: MasteryLevel.reviewing,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          WordMastery(
            wordId: 'w2',
            word: 'dog',
            level: MasteryLevel.learning,
            nextReviewAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ];
        final result = service.getDueForReview(masteries);
        expect(result.length, 3);
        expect(result[0].level, MasteryLevel.reviewing);
        expect(result[1].level, MasteryLevel.learning);
        expect(result[2].level, MasteryLevel.mastered);
      });
    });
  });
}
