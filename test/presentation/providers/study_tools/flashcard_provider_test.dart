/// Test suite for FlashcardStudyState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard_progress.dart';
import 'package:crack_the_code/presentation/providers/study_tools/flashcard_provider.dart';

void main() {
  group('FlashcardStudyState', () {
    test('default_hasEmptyValues', () {
      const state = FlashcardStudyState();

      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.cards, isEmpty);
      expect(state.currentIndex, 0);
      expect(state.isFlipped, false);
      expect(state.knownCount, 0);
      expect(state.unknownCount, 0);
      expect(state.isComplete, false);
      expect(state.startTime, isNull);
      expect(state.endTime, isNull);
      expect(state.cardProgressMap, isEmpty);
      expect(state.incorrectCardIds, isEmpty);
    });

    group('currentCard', () {
      test('returnsNull_whenNoCards', () {
        const state = FlashcardStudyState();

        expect(state.currentCard, isNull);
      });

      test('returnsCardAtCurrentIndex', () {
        final cards = [
          _createTestCard('1'),
          _createTestCard('2'),
          _createTestCard('3'),
        ];

        final state = FlashcardStudyState(
          cards: cards,
          currentIndex: 1,
        );

        expect(state.currentCard?.id, 'card-2');
      });

      test('returnsNull_whenIndexOutOfBounds', () {
        final cards = [_createTestCard('1')];

        final state = FlashcardStudyState(
          cards: cards,
          currentIndex: 5,
        );

        expect(state.currentCard, isNull);
      });
    });

    group('totalCards', () {
      test('returnsZero_whenEmpty', () {
        const state = FlashcardStudyState();

        expect(state.totalCards, 0);
      });

      test('returnsCardCount', () {
        final cards = [
          _createTestCard('1'),
          _createTestCard('2'),
          _createTestCard('3'),
        ];

        final state = FlashcardStudyState(cards: cards);

        expect(state.totalCards, 3);
      });
    });

    group('progressPercentage', () {
      test('returnsZero_whenNoCards', () {
        const state = FlashcardStudyState();

        expect(state.progressPercentage, 0.0);
      });

      test('calculatesCorrectly', () {
        final cards = [
          _createTestCard('1'),
          _createTestCard('2'),
          _createTestCard('3'),
          _createTestCard('4'),
        ];

        final state = FlashcardStudyState(
          cards: cards,
          currentIndex: 2,
        );

        expect(state.progressPercentage, 0.5);
      });

      test('returnsOne_whenComplete', () {
        final cards = [
          _createTestCard('1'),
          _createTestCard('2'),
        ];

        final state = FlashcardStudyState(
          cards: cards,
          currentIndex: 2,
          isComplete: true,
        );

        expect(state.progressPercentage, 1.0);
      });
    });

    group('accuracyPercentage', () {
      test('returnsZero_whenNoAnswers', () {
        const state = FlashcardStudyState();

        expect(state.accuracyPercentage, 0.0);
      });

      test('calculatesCorrectly_allKnown', () {
        final state = FlashcardStudyState(
          knownCount: 5,
          unknownCount: 0,
        );

        expect(state.accuracyPercentage, 100.0);
      });

      test('calculatesCorrectly_allUnknown', () {
        final state = FlashcardStudyState(
          knownCount: 0,
          unknownCount: 5,
        );

        expect(state.accuracyPercentage, 0.0);
      });

      test('calculatesCorrectly_mixed', () {
        final state = FlashcardStudyState(
          knownCount: 3,
          unknownCount: 1,
        );

        expect(state.accuracyPercentage, 75.0);
      });
    });

    group('duration', () {
      test('returnsZero_whenNoStartTime', () {
        const state = FlashcardStudyState();

        expect(state.duration, Duration.zero);
      });

      test('calculatesDuration_withEndTime', () {
        final startTime = DateTime(2024, 1, 1, 10, 0, 0);
        final endTime = DateTime(2024, 1, 1, 10, 5, 30);

        final state = FlashcardStudyState(
          startTime: startTime,
          endTime: endTime,
        );

        expect(state.duration.inMinutes, 5);
        expect(state.duration.inSeconds, 330);
      });

      test('calculatesFromNow_whenNoEndTime', () {
        final startTime = DateTime.now().subtract(const Duration(minutes: 2));

        final state = FlashcardStudyState(
          startTime: startTime,
        );

        // Duration should be approximately 2 minutes
        expect(state.duration.inMinutes, greaterThanOrEqualTo(2));
      });
    });

    group('getProgressForCard', () {
      test('returnsNull_whenNoProgress', () {
        const state = FlashcardStudyState();

        expect(state.getProgressForCard('card-1'), isNull);
      });

      test('returnsProgress_whenExists', () {
        final progress = _createTestProgress('card-1');
        final progressMap = {'card-1': progress};

        final state = FlashcardStudyState(cardProgressMap: progressMap);

        expect(state.getProgressForCard('card-1'), progress);
      });

      test('returnsNull_forUnknownCard', () {
        final progress = _createTestProgress('card-1');
        final progressMap = {'card-1': progress};

        final state = FlashcardStudyState(cardProgressMap: progressMap);

        expect(state.getProgressForCard('card-2'), isNull);
      });
    });

    group('copyWith', () {
      test('updatesSpecifiedFields', () {
        const initial = FlashcardStudyState();

        final updated = initial.copyWith(
          isLoading: true,
          currentIndex: 5,
          knownCount: 3,
        );

        expect(updated.isLoading, true);
        expect(updated.currentIndex, 5);
        expect(updated.knownCount, 3);
        expect(updated.unknownCount, 0);
      });

      test('preservesUnspecifiedFields', () {
        final cards = [_createTestCard('1')];
        final state = FlashcardStudyState(
          cards: cards,
          currentIndex: 1,
          knownCount: 2,
        );

        final updated = state.copyWith(isFlipped: true);

        expect(updated.cards, cards);
        expect(updated.currentIndex, 1);
        expect(updated.knownCount, 2);
        expect(updated.isFlipped, true);
      });

      test('allowsClearingError', () {
        final state = FlashcardStudyState(error: 'Some error');

        final updated = state.copyWith(error: null);

        expect(updated.error, isNull);
      });

      test('updatesIncorrectCardIds', () {
        const state = FlashcardStudyState();

        final updated = state.copyWith(
          incorrectCardIds: {'card-1', 'card-2'},
        );

        expect(updated.incorrectCardIds.length, 2);
        expect(updated.incorrectCardIds.contains('card-1'), true);
      });
    });
  });

  group('FlashcardDeck Entity', () {
    test('isEmpty_returnsTrueForEmptyDeck', () {
      final deck = FlashcardDeck(
        id: 'deck-1',
        topicId: 'topic-1',
        name: 'Empty Deck',
        segment: 'junior',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        cards: const [],
      );

      expect(deck.isEmpty, true);
    });

    test('isEmpty_returnsFalseForNonEmptyDeck', () {
      final deck = FlashcardDeck(
        id: 'deck-1',
        topicId: 'topic-1',
        name: 'Test Deck',
        segment: 'junior',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        cards: [_createTestCard('1')],
      );

      expect(deck.isEmpty, false);
    });

    test('actualCardCount_returnsCorrectCount', () {
      final deck = FlashcardDeck(
        id: 'deck-1',
        topicId: 'topic-1',
        name: 'Test Deck',
        segment: 'junior',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        cards: [
          _createTestCard('1'),
          _createTestCard('2'),
          _createTestCard('3'),
        ],
      );

      expect(deck.actualCardCount, 3);
    });

    test('sortedCards_returnsCardsInOrder', () {
      final now = DateTime.now();
      final deck = FlashcardDeck(
        id: 'deck-1',
        topicId: 'topic-1',
        name: 'Test Deck',
        segment: 'junior',
        createdAt: now,
        updatedAt: now,
        cards: [
          Flashcard(id: 'c3', deckId: 'deck-1', front: 'Q3', back: 'A3', orderIndex: 3, createdAt: now),
          Flashcard(id: 'c1', deckId: 'deck-1', front: 'Q1', back: 'A1', orderIndex: 1, createdAt: now),
          Flashcard(id: 'c2', deckId: 'deck-1', front: 'Q2', back: 'A2', orderIndex: 2, createdAt: now),
        ],
      );

      final sorted = deck.sortedCards;
      expect(sorted[0].id, 'c1');
      expect(sorted[1].id, 'c2');
      expect(sorted[2].id, 'c3');
    });
  });

  group('DeckProgress', () {
    test('masteryPercentage_calculatesCorrectly', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 10,
        reviewedCards: 8,
        masteredCards: 5,
        dueCards: 3,
        averageAccuracy: 80.0,
      );

      expect(progress.masteryPercentage, 50.0);
    });

    test('masteryPercentage_returnsZeroForEmptyDeck', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 0,
        reviewedCards: 0,
        masteredCards: 0,
        dueCards: 0,
        averageAccuracy: 0.0,
      );

      expect(progress.masteryPercentage, 0.0);
    });

    test('progressPercentage_calculatesCorrectly', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 10,
        reviewedCards: 4,
        masteredCards: 2,
        dueCards: 3,
        averageAccuracy: 70.0,
      );

      expect(progress.progressPercentage, 40.0);
    });

    test('isCompleted_returnsTrueWhenAllMastered', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 5,
        reviewedCards: 5,
        masteredCards: 5,
        dueCards: 0,
        averageAccuracy: 90.0,
      );

      expect(progress.isCompleted, true);
    });

    test('isCompleted_returnsFalseWhenNotAllMastered', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 5,
        reviewedCards: 5,
        masteredCards: 3,
        dueCards: 2,
        averageAccuracy: 80.0,
      );

      expect(progress.isCompleted, false);
    });

    test('hasStarted_returnsTrueWhenReviewedCardsGreaterThanZero', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 10,
        reviewedCards: 1,
        masteredCards: 0,
        dueCards: 1,
        averageAccuracy: 50.0,
      );

      expect(progress.hasStarted, true);
    });

    test('cardsToMaster_calculatesCorrectly', () {
      const progress = DeckProgress(
        deckId: 'deck-1',
        profileId: 'profile-1',
        totalCards: 10,
        reviewedCards: 8,
        masteredCards: 3,
        dueCards: 5,
        averageAccuracy: 70.0,
      );

      expect(progress.cardsToMaster, 7);
    });
  });
}

/// Create a test flashcard
Flashcard _createTestCard(String id) {
  return Flashcard(
    id: 'card-$id',
    deckId: 'deck-1',
    front: 'Question $id',
    back: 'Answer $id',
    orderIndex: int.parse(id),
    createdAt: DateTime.now(),
  );
}

/// Create a test flashcard progress
FlashcardProgress _createTestProgress(String cardId) {
  return FlashcardProgress(
    id: 'progress-$cardId',
    cardId: cardId,
    profileId: 'profile-1',
    reviewCount: 5,
    correctCount: 4,
    lastReviewedAt: DateTime.now(),
    nextReviewDate: DateTime.now().add(const Duration(days: 1)),
    easeFactor: 2.5,
    intervalDays: 1,
  );
}
