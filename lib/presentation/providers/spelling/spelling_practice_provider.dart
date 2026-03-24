import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_session.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_attempt.dart';
import 'package:crack_the_code/domain/entities/spelling/word_mastery.dart';
import 'package:crack_the_code/domain/services/spelling_checker_service.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// State for a spelling practice session
class SpellingPracticeState {
  final SpellingSession? session;
  final List<Word> words;
  final Word? currentWord;
  final bool isLoading;
  final String? error;
  final SpellingCheckResult? lastResult;
  final WordMastery? lastMasteryUpdate;
  final bool isSessionComplete;

  const SpellingPracticeState({
    this.session,
    this.words = const [],
    this.currentWord,
    this.isLoading = false,
    this.error,
    this.lastResult,
    this.lastMasteryUpdate,
    this.isSessionComplete = false,
  });

  SpellingPracticeState copyWith({
    SpellingSession? session,
    List<Word>? words,
    Word? currentWord,
    bool? isLoading,
    String? error,
    SpellingCheckResult? lastResult,
    WordMastery? lastMasteryUpdate,
    bool? isSessionComplete,
  }) {
    return SpellingPracticeState(
      session: session ?? this.session,
      words: words ?? this.words,
      currentWord: currentWord ?? this.currentWord,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastResult: lastResult,
      lastMasteryUpdate: lastMasteryUpdate,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
    );
  }
}

class SpellingPracticeNotifier extends StateNotifier<SpellingPracticeState> {
  final SpellingCheckerService _checker = SpellingCheckerService();

  SpellingPracticeNotifier() : super(const SpellingPracticeState());

  Future<void> startSession({
    required String wordListId,
    required String activityType,
    String? profileId,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSessionComplete: false);

    try {
      final result = await injectionContainer.getWordsForListUseCase(wordListId);

      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error.toString()),
        (words) {
          final session = SpellingSession(
            id: 'session_${DateTime.now().millisecondsSinceEpoch}',
            wordListId: wordListId,
            activityType: activityType,
            wordIds: words.map((w) => w.id).toList(),
            startedAt: DateTime.now(),
            profileId: profileId,
          );

          state = state.copyWith(
            isLoading: false,
            session: session,
            words: words,
            currentWord: words.isNotEmpty ? words.first : null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitAnswer(String userInput) async {
    final session = state.session;
    final currentWord = state.currentWord;
    if (session == null || currentWord == null) return;

    // Check spelling
    final result = _checker.check(userInput, currentWord.word);

    // Create attempt
    final attempt = SpellingAttempt(
      id: 'attempt_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      wordId: currentWord.id,
      word: currentWord.word,
      userInput: userInput,
      isCorrect: result.isCorrect,
      activityType: session.activityType,
      attemptedAt: DateTime.now(),
      profileId: session.profileId,
    );

    // Submit attempt and update mastery
    try {
      final masteryResult = await injectionContainer.submitSpellingAttemptUseCase(attempt);

      WordMastery? masteryUpdate;
      masteryResult.fold(
        (error) {
          // Log mastery update failure but continue session
          debugPrint('Mastery update failed: $error');
        },
        (mastery) => masteryUpdate = mastery,
      );

      // Update session
      final newCorrect = session.correctCount + (result.isCorrect ? 1 : 0);
      final newIncorrect = session.incorrectCount + (result.isCorrect ? 0 : 1);
      final newIndex = session.currentIndex + 1;
      final isComplete = newIndex >= session.totalWords;

      final updatedSession = session.copyWith(
        currentIndex: newIndex,
        correctCount: newCorrect,
        incorrectCount: newIncorrect,
        completedWordIds: [...session.completedWordIds, currentWord.id],
        incorrectWordIds: result.isCorrect
            ? session.incorrectWordIds
            : [...session.incorrectWordIds, currentWord.id],
        completedAt: isComplete ? DateTime.now() : null,
      );

      final nextWord = !isComplete && newIndex < state.words.length
          ? state.words[newIndex]
          : null;

      state = state.copyWith(
        session: updatedSession,
        currentWord: nextWord,
        lastResult: result,
        lastMasteryUpdate: masteryUpdate,
        isSessionComplete: isComplete,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void skipWord() {
    final session = state.session;
    if (session == null) return;

    final newIndex = session.currentIndex + 1;
    final isComplete = newIndex >= session.totalWords;

    final updatedSession = session.copyWith(
      currentIndex: newIndex,
      skippedCount: session.skippedCount + 1,
      completedAt: isComplete ? DateTime.now() : null,
    );

    final nextWord = !isComplete && newIndex < state.words.length
        ? state.words[newIndex]
        : null;

    state = state.copyWith(
      session: updatedSession,
      currentWord: nextWord,
      lastResult: null,
      isSessionComplete: isComplete,
    );
  }

  void clearLastResult() {
    state = state.copyWith(lastResult: null, lastMasteryUpdate: null);
  }
}

final spellingPracticeProvider =
    StateNotifierProvider<SpellingPracticeNotifier, SpellingPracticeState>(
  (ref) => SpellingPracticeNotifier(),
);
