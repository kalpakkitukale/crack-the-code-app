import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

class WordOfTheDayState {
  final Word? word;
  final bool isLoading;
  final String? error;

  const WordOfTheDayState({this.word, this.isLoading = false, this.error});

  WordOfTheDayState copyWith({Word? word, bool? isLoading, String? error}) {
    return WordOfTheDayState(
      word: word ?? this.word,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WordOfTheDayNotifier extends StateNotifier<WordOfTheDayState> {
  WordOfTheDayNotifier() : super(const WordOfTheDayState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await injectionContainer.getWordOfTheDayUseCase();
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error.toString()),
        (word) => state = state.copyWith(isLoading: false, word: word),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final wordOfTheDayProvider =
    StateNotifierProvider<WordOfTheDayNotifier, WordOfTheDayState>(
  (ref) => WordOfTheDayNotifier(),
);
