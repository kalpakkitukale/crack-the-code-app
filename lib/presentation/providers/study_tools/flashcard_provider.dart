/// Riverpod providers for flashcards
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/local/database/dao/flashcard_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/study_tools/flashcard_repository_impl.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard_progress.dart';
import 'package:streamshaala/domain/repositories/study_tools/flashcard_repository.dart';
import 'package:streamshaala/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'flashcard_provider.g.dart';

/// Provider for FlashcardDao
@riverpod
FlashcardDao flashcardDao(FlashcardDaoRef ref) {
  return FlashcardDao(DatabaseHelper());
}

/// Provider for FlashcardRepository
@riverpod
FlashcardRepository flashcardRepository(FlashcardRepositoryRef ref) {
  final dao = ref.watch(flashcardDaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return FlashcardRepositoryImpl(dao, jsonDataSource);
}

/// Provider for flashcard deck by topic ID
@riverpod
Future<FlashcardDeck?> topicFlashcards(TopicFlashcardsRef ref, String topicId) async {
  final repository = ref.watch(flashcardRepositoryProvider);
  final segment = SegmentConfig.current.name;

  final result = await repository.getDeckByTopicId(topicId, segment);
  return result.fold(
    (failure) => null,
    (deck) => deck,
  );
}

/// Provider for flashcard deck by ID
@riverpod
Future<FlashcardDeck?> flashcardDeck(FlashcardDeckRef ref, String deckId) async {
  final repository = ref.watch(flashcardRepositoryProvider);

  final result = await repository.getDeckById(deckId);
  return result.fold(
    (failure) => null,
    (deck) => deck,
  );
}

/// Provider for flashcard decks by chapter ID with subject context
@riverpod
Future<List<FlashcardDeck>> chapterFlashcards(
  ChapterFlashcardsRef ref,
  String chapterId, {
  String? subjectId,
}) async {
  final repository = ref.watch(flashcardRepositoryProvider) as FlashcardRepositoryImpl;
  final segment = SegmentConfig.current.name;

  // Set context for JSON lookup
  repository.subjectId = subjectId;

  final result = await repository.getDecksByChapterId(chapterId, segment);
  return result.fold(
    (failure) => [],
    (decks) => decks,
  );
}

/// Provider for deck progress
@riverpod
Future<DeckProgress> deckProgress(DeckProgressRef ref, String deckId) async {
  final repository = ref.watch(flashcardRepositoryProvider);

  final result = await repository.getDeckProgress(deckId);
  return result.fold(
    (failure) => DeckProgress(
      deckId: deckId,
      profileId: '',
      totalCards: 0,
      reviewedCards: 0,
      masteredCards: 0,
      dueCards: 0,
      averageAccuracy: 0,
    ),
    (progress) => progress,
  );
}

/// Provider for due cards
@riverpod
Future<List<FlashcardProgress>> dueCards(DueCardsRef ref) async {
  final repository = ref.watch(flashcardRepositoryProvider);

  final result = await repository.getDueCards();
  return result.fold(
    (failure) => [],
    (cards) => cards,
  );
}

/// Notifier for flashcard study session
@riverpod
class FlashcardStudySession extends _$FlashcardStudySession {
  String? _subjectId;

  @override
  FlashcardStudyState build(String deckId) {
    return const FlashcardStudyState();
  }

  /// Set the subject ID for JSON lookup
  void setSubjectId(String subjectId) {
    _subjectId = subjectId;
  }

  /// Initialize the study session
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    final repository = ref.read(flashcardRepositoryProvider) as FlashcardRepositoryImpl;

    // Set context for JSON lookup
    repository.subjectId = _subjectId;

    final result = await repository.getDeckById(deckId);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (deck) async {
        if (deck == null || deck.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            error: 'No cards in deck',
          );
          return;
        }

        // Load progress for all cards
        final progressMap = <String, FlashcardProgress>{};
        for (final card in deck.sortedCards) {
          final progressResult = await repository.getCardProgress(card.id);
          progressResult.fold(
            (_) {},
            (progress) {
              if (progress != null) {
                progressMap[card.id] = progress;
              }
            },
          );
        }

        state = state.copyWith(
          isLoading: false,
          cards: deck.sortedCards,
          cardProgressMap: progressMap,
          currentIndex: 0,
          isFlipped: false,
          knownCount: 0,
          unknownCount: 0,
          incorrectCardIds: {},
          startTime: DateTime.now(),
        );
      },
    );
  }

  /// Initialize with subject context
  Future<void> initializeWithSubjectId(String subjectId) async {
    _subjectId = subjectId;
    await initialize();
  }

  /// Flip the current card
  void flipCard() {
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  /// Mark current card as known and move to next
  Future<void> markKnown() async {
    await _recordResult(true);
  }

  /// Mark current card as unknown and move to next
  Future<void> markUnknown() async {
    await _recordResult(false);
  }

  Future<void> _recordResult(bool known) async {
    if (state.currentIndex >= state.cards.length) return;

    final card = state.cards[state.currentIndex];
    final repository = ref.read(flashcardRepositoryProvider);

    // Record the review
    final progressResult = await repository.recordReview(card.id, known);

    // Update progress map with new progress
    final updatedProgressMap = Map<String, FlashcardProgress>.from(state.cardProgressMap);
    progressResult.fold(
      (_) {},
      (progress) => updatedProgressMap[card.id] = progress,
    );

    // Track incorrect cards
    final updatedIncorrectIds = Set<String>.from(state.incorrectCardIds);
    if (!known) {
      updatedIncorrectIds.add(card.id);
    }

    // Update state
    final newKnownCount = known ? state.knownCount + 1 : state.knownCount;
    final newUnknownCount = known ? state.unknownCount : state.unknownCount + 1;
    final newIndex = state.currentIndex + 1;

    if (newIndex >= state.cards.length) {
      // Session complete
      state = state.copyWith(
        knownCount: newKnownCount,
        unknownCount: newUnknownCount,
        isComplete: true,
        endTime: DateTime.now(),
        cardProgressMap: updatedProgressMap,
        incorrectCardIds: updatedIncorrectIds,
      );
    } else {
      // Move to next card
      state = state.copyWith(
        currentIndex: newIndex,
        isFlipped: false,
        knownCount: newKnownCount,
        unknownCount: newUnknownCount,
        cardProgressMap: updatedProgressMap,
        incorrectCardIds: updatedIncorrectIds,
      );
    }
  }

  /// Reset the session with all cards
  void reset() {
    state = state.copyWith(
      currentIndex: 0,
      isFlipped: false,
      knownCount: 0,
      unknownCount: 0,
      isComplete: false,
      incorrectCardIds: {},
      startTime: DateTime.now(),
      endTime: null,
    );
  }

  /// Reset the session with only incorrect cards
  void resetWithMistakes() {
    if (state.incorrectCardIds.isEmpty) {
      reset();
      return;
    }

    // Filter cards to only include incorrect ones
    final incorrectCards = state.cards
        .where((card) => state.incorrectCardIds.contains(card.id))
        .toList();

    state = state.copyWith(
      cards: incorrectCards,
      currentIndex: 0,
      isFlipped: false,
      knownCount: 0,
      unknownCount: 0,
      isComplete: false,
      incorrectCardIds: {},
      startTime: DateTime.now(),
      endTime: null,
    );
  }
}

/// State class for flashcard study session
class FlashcardStudyState {
  final bool isLoading;
  final String? error;
  final List<Flashcard> cards;
  final int currentIndex;
  final bool isFlipped;
  final int knownCount;
  final int unknownCount;
  final bool isComplete;
  final DateTime? startTime;
  final DateTime? endTime;
  final Map<String, FlashcardProgress> cardProgressMap;
  final Set<String> incorrectCardIds;

  const FlashcardStudyState({
    this.isLoading = false,
    this.error,
    this.cards = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
    this.knownCount = 0,
    this.unknownCount = 0,
    this.isComplete = false,
    this.startTime,
    this.endTime,
    this.cardProgressMap = const {},
    this.incorrectCardIds = const {},
  });

  FlashcardStudyState copyWith({
    bool? isLoading,
    String? error,
    List<Flashcard>? cards,
    int? currentIndex,
    bool? isFlipped,
    int? knownCount,
    int? unknownCount,
    bool? isComplete,
    DateTime? startTime,
    DateTime? endTime,
    Map<String, FlashcardProgress>? cardProgressMap,
    Set<String>? incorrectCardIds,
  }) {
    return FlashcardStudyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      knownCount: knownCount ?? this.knownCount,
      unknownCount: unknownCount ?? this.unknownCount,
      isComplete: isComplete ?? this.isComplete,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      cardProgressMap: cardProgressMap ?? this.cardProgressMap,
      incorrectCardIds: incorrectCardIds ?? this.incorrectCardIds,
    );
  }

  /// Get progress for a specific card
  FlashcardProgress? getProgressForCard(String cardId) {
    return cardProgressMap[cardId];
  }

  /// Get current card
  Flashcard? get currentCard {
    if (currentIndex < cards.length) {
      return cards[currentIndex];
    }
    return null;
  }

  /// Get total cards
  int get totalCards => cards.length;

  /// Get progress percentage
  double get progressPercentage {
    if (totalCards == 0) return 0;
    return currentIndex / totalCards;
  }

  /// Get accuracy percentage
  double get accuracyPercentage {
    final total = knownCount + unknownCount;
    if (total == 0) return 0;
    return (knownCount / total) * 100;
  }

  /// Get session duration
  Duration get duration {
    if (startTime == null) return Duration.zero;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }
}
