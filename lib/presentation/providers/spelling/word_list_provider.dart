import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/domain/entities/spelling/word_list.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// State for word lists
class WordListState {
  final List<WordList> wordLists;
  final bool isLoading;
  final String? error;
  final int? selectedGrade;

  const WordListState({
    this.wordLists = const [],
    this.isLoading = false,
    this.error,
    this.selectedGrade,
  });

  WordListState copyWith({
    List<WordList>? wordLists,
    bool? isLoading,
    String? error,
    int? selectedGrade,
  }) {
    return WordListState(
      wordLists: wordLists ?? this.wordLists,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedGrade: selectedGrade ?? this.selectedGrade,
    );
  }
}

/// Provider for word lists
class WordListNotifier extends StateNotifier<WordListState> {
  WordListNotifier() : super(const WordListState());

  Future<void> loadWordLists({int? gradeLevel}) async {
    state = state.copyWith(isLoading: true, error: null, selectedGrade: gradeLevel);

    try {
      final result = await injectionContainer.getWordListsUseCase(
        gradeLevel: gradeLevel,
      );

      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error.toString()),
        (wordLists) => state = state.copyWith(isLoading: false, wordLists: wordLists),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final wordListProvider = StateNotifierProvider<WordListNotifier, WordListState>(
  (ref) => WordListNotifier(),
);

/// State for words in a specific list
class WordsState {
  final List<Word> words;
  final bool isLoading;
  final String? error;
  final String? currentWordListId;

  const WordsState({
    this.words = const [],
    this.isLoading = false,
    this.error,
    this.currentWordListId,
  });

  WordsState copyWith({
    List<Word>? words,
    bool? isLoading,
    String? error,
    String? currentWordListId,
  }) {
    return WordsState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentWordListId: currentWordListId ?? this.currentWordListId,
    );
  }
}

class WordsNotifier extends StateNotifier<WordsState> {
  WordsNotifier() : super(const WordsState());

  Future<void> loadWords(String wordListId) async {
    state = state.copyWith(isLoading: true, error: null, currentWordListId: wordListId);

    try {
      final result = await injectionContainer.getWordsForListUseCase(wordListId);

      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error.toString()),
        (words) => state = state.copyWith(isLoading: false, words: words),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final wordsProvider = StateNotifierProvider<WordsNotifier, WordsState>(
  (ref) => WordsNotifier(),
);
