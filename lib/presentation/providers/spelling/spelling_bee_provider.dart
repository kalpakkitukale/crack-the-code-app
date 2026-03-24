import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_bee_round.dart';
import 'package:streamshaala/domain/services/spelling_bee_service.dart';
import 'package:streamshaala/domain/services/spelling_checker_service.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

class SpellingBeeState {
  final List<SpellingBeeRound> rounds;
  final int currentRoundIndex;
  final bool isLoading;
  final bool isComplete;
  final String? error;
  final SpellingBeeScore? score;
  final SpellingCheckResult? lastResult;
  final int hintsUsedThisRound;

  const SpellingBeeState({
    this.rounds = const [],
    this.currentRoundIndex = 0,
    this.isLoading = false,
    this.isComplete = false,
    this.error,
    this.score,
    this.lastResult,
    this.hintsUsedThisRound = 0,
  });

  SpellingBeeRound? get currentRound =>
      currentRoundIndex < rounds.length ? rounds[currentRoundIndex] : null;

  int get totalRounds => rounds.length;

  SpellingBeeState copyWith({
    List<SpellingBeeRound>? rounds,
    int? currentRoundIndex,
    bool? isLoading,
    bool? isComplete,
    String? error,
    SpellingBeeScore? score,
    SpellingCheckResult? lastResult,
    int? hintsUsedThisRound,
  }) {
    return SpellingBeeState(
      rounds: rounds ?? this.rounds,
      currentRoundIndex: currentRoundIndex ?? this.currentRoundIndex,
      isLoading: isLoading ?? this.isLoading,
      isComplete: isComplete ?? this.isComplete,
      error: error,
      score: score,
      lastResult: lastResult,
      hintsUsedThisRound: hintsUsedThisRound ?? this.hintsUsedThisRound,
    );
  }
}

class SpellingBeeNotifier extends StateNotifier<SpellingBeeState> {
  final SpellingBeeService _beeService = SpellingBeeService();
  final SpellingCheckerService _checker = SpellingCheckerService();

  SpellingBeeNotifier() : super(const SpellingBeeState());

  Future<void> startBee({required int gradeLevel, int roundCount = 5}) async {
    state = state.copyWith(isLoading: true, error: null, isComplete: false);

    try {
      final result = await injectionContainer.spellingRepository.getWordsByGrade(gradeLevel);

      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error.toString()),
        (words) {
          final rounds = _beeService.generateRounds(words, roundCount);
          state = state.copyWith(
            isLoading: false,
            rounds: rounds,
            currentRoundIndex: 0,
            hintsUsedThisRound: 0,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void submitAnswer(String userInput) {
    final round = state.currentRound;
    if (round == null) return;

    final result = _checker.check(userInput, round.word);

    final updatedRound = round.copyWith(
      isCompleted: true,
      isCorrect: result.isCorrect,
      userAnswer: userInput,
      hintsUsed: state.hintsUsedThisRound,
    );

    final updatedRounds = List<SpellingBeeRound>.from(state.rounds);
    updatedRounds[state.currentRoundIndex] = updatedRound;

    state = state.copyWith(rounds: updatedRounds, lastResult: result);
  }

  void nextRound() {
    final nextIndex = state.currentRoundIndex + 1;
    if (nextIndex >= state.totalRounds) {
      // Bee is complete
      final score = _beeService.calculateScore(state.rounds);
      state = state.copyWith(
        isComplete: true,
        score: score,
        lastResult: null,
        hintsUsedThisRound: 0,
      );
    } else {
      state = state.copyWith(
        currentRoundIndex: nextIndex,
        lastResult: null,
        hintsUsedThisRound: 0,
      );
    }
  }

  void useHint() {
    state = state.copyWith(hintsUsedThisRound: state.hintsUsedThisRound + 1);
  }
}

final spellingBeeProvider =
    StateNotifierProvider<SpellingBeeNotifier, SpellingBeeState>(
  (ref) => SpellingBeeNotifier(),
);
