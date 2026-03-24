/// Quiz state management provider
///
/// This provider manages quiz session state, quiz history, and quiz operations
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/quiz/quiz.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_filter.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_statistics.dart';
import 'package:streamshaala/domain/entities/quiz/subject_statistics.dart';
import 'package:streamshaala/domain/repositories/quiz_repository.dart';
import 'package:streamshaala/domain/usecases/quiz/complete_quiz_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/get_active_session_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/get_quiz_history_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/load_quiz_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/resume_session_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/submit_answer_usecase.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// Quiz state class
class QuizState {
  final QuizSession? activeSession;
  final QuizResult? lastResult;
  final List<QuizAttempt> history;
  final bool isLoading;
  final String? error;

  const QuizState({
    this.activeSession,
    this.lastResult,
    required this.history,
    required this.isLoading,
    this.error,
  });

  factory QuizState.initial() => const QuizState(
        history: [],
        isLoading: false,
      );

  QuizState copyWith({
    QuizSession? activeSession,
    QuizResult? lastResult,
    List<QuizAttempt>? history,
    bool? isLoading,
    String? error,
    bool clearActiveSession = false,
    bool clearLastResult = false,
    bool clearError = false,
  }) {
    return QuizState(
      activeSession: clearActiveSession ? null : activeSession ?? this.activeSession,
      lastResult: clearLastResult ? null : lastResult ?? this.lastResult,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Check if there's an active quiz session
  bool get hasActiveSession => activeSession != null;

  /// Get current quiz ID from active session
  String? get currentQuizId => activeSession?.quizId;

  /// Get current question index
  int get currentQuestionIndex => activeSession?.currentQuestionIndex ?? 0;

  /// Get total questions count
  int get totalQuestions => activeSession?.questions.length ?? 0;

  /// Get quiz progress percentage (0-100)
  double get progressPercentage {
    if (totalQuestions == 0) return 0.0;
    return (currentQuestionIndex / totalQuestions) * 100;
  }
}

/// Quiz state notifier - manages quiz operations
class QuizNotifier extends StateNotifier<QuizState> {
  final LoadQuizUseCase _loadQuizUseCase;
  final SubmitAnswerUseCase _submitAnswerUseCase;
  final CompleteQuizUseCase _completeQuizUseCase;
  final ResumeSessionUseCase _resumeSessionUseCase;
  final GetQuizHistoryUseCase _getQuizHistoryUseCase;
  final GetActiveSessionUseCase _getActiveSessionUseCase;
  final QuizRepository _repository; // PHASE 4: Direct repository access

  QuizNotifier({
    required LoadQuizUseCase loadQuizUseCase,
    required SubmitAnswerUseCase submitAnswerUseCase,
    required CompleteQuizUseCase completeQuizUseCase,
    required ResumeSessionUseCase resumeSessionUseCase,
    required GetQuizHistoryUseCase getQuizHistoryUseCase,
    required GetActiveSessionUseCase getActiveSessionUseCase,
    required QuizRepository repository, // PHASE 4: Direct repository access
  })  : _loadQuizUseCase = loadQuizUseCase,
        _submitAnswerUseCase = submitAnswerUseCase,
        _completeQuizUseCase = completeQuizUseCase,
        _resumeSessionUseCase = resumeSessionUseCase,
        _getQuizHistoryUseCase = getQuizHistoryUseCase,
        _getActiveSessionUseCase = getActiveSessionUseCase,
        _repository = repository, // PHASE 4: Direct repository access
        super(QuizState.initial());

  /// Safely update state only if still mounted
  void _safeSetState(QuizState newState) {
    if (mounted) {
      state = newState;
    }
  }

  @override
  void dispose() {
    logger.debug('QuizNotifier: Disposing...');
    super.dispose();
  }

  /// Load a quiz for a specific entity (video/topic/chapter/subject)
  Future<void> loadQuiz({
    required String entityId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  }) async {
    try {
      logger.info('Loading quiz for entity: $entityId, student: $studentId, type: ${assessmentType.queryValue}');

      // CRITICAL FIX: Clear activeSession when starting to load a new quiz
      // This prevents the UI from showing OLD session data while new quiz loads
      // Without this, user can click answer on old session before new one is ready
      // causing the "question swap" bug where answer goes to wrong question
      _safeSetState(state.copyWith(
        isLoading: true,
        clearError: true,
        clearActiveSession: true,  // Clear old session immediately
      ));

      final result = await _loadQuizUseCase(
        LoadQuizParams(
          entityId: entityId,
          studentId: studentId,
          assessmentType: assessmentType,
        ),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to load quiz: ${failure.message}');
          _safeSetState(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (session) {
          logger.info('Quiz loaded successfully for entity: $entityId');

          // CRITICAL FIX: Reset currentQuestionIndex to 0 when loading a quiz
          // This ensures UI and backend are synchronized from the start
          // The database session may have a stale index from a previous session
          final sessionWithCorrectIndex = session.copyWith(currentQuestionIndex: 0);

          _safeSetState(state.copyWith(
            activeSession: sessionWithCorrectIndex,
            isLoading: false,
            clearError: true,
            clearLastResult: true,
          ));
        },
      );
    } catch (e) {
      logger.error('Error loading quiz: $e');
      _safeSetState(state.copyWith(
        isLoading: false,
        error: 'Failed to load quiz: $e',
      ));
    }
  }

  /// Submit an answer to the current question
  Future<void> submitAnswer({
    required String questionId,
    required String answer,
    int? questionIndex,
  }) async {
    if (state.activeSession == null) {
      logger.warning('Cannot submit answer: No active session');
      return;
    }

    try {
      logger.info('Submitting answer for question: $questionId');
      final sessionId = state.activeSession!.id;
      final currentSessionIndex = state.activeSession!.currentQuestionIndex;
      _safeSetState(state.copyWith(clearError: true));

      final result = await _submitAnswerUseCase(
        SubmitAnswerParams(
          sessionId: sessionId,
          questionId: questionId,
          answer: answer,
          // Use the explicitly passed index if available, otherwise fall back to session index
          currentQuestionIndex: questionIndex ?? currentSessionIndex,
        ),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to submit answer: ${failure.message}');
          _safeSetState(state.copyWith(error: failure.message));
        },
        (updatedSession) {
          logger.info('Answer submitted successfully');

          // CRITICAL FIX: Maintain the current question index from the UI state
          // Use the explicitly passed index if available, otherwise use the current UI state
          final currentIndex = questionIndex ?? currentSessionIndex;
          final sessionWithCorrectIndex = updatedSession.copyWith(
            currentQuestionIndex: currentIndex,
          );

          _safeSetState(state.copyWith(
            activeSession: sessionWithCorrectIndex,
            clearError: true,
          ));

          logger.info('Question position maintained at index: $currentIndex');
        },
      );
    } catch (e) {
      logger.error('Error submitting answer: $e');
      _safeSetState(state.copyWith(error: 'Failed to submit answer: $e'));
    }
  }

  /// Clear the answer for a specific question
  Future<void> clearAnswer({
    required String questionId,
  }) async {
    if (state.activeSession == null) {
      logger.warning('Cannot clear answer: No active session');
      return;
    }

    try {
      logger.info('Clearing answer for question: $questionId');
      state = state.copyWith(clearError: true);

      // Remove answer from the session by creating a new map without it
      final currentSession = state.activeSession!;
      final updatedAnswers = Map<String, String>.from(currentSession.answers);
      updatedAnswers.remove(questionId);

      // Create updated session with answer removed
      final updatedSession = currentSession.copyWith(answers: updatedAnswers);

      // Update state locally (repository update happens via submitAnswer when user selects new answer)
      state = state.copyWith(
        activeSession: updatedSession,
        clearError: true,
      );

      logger.info('Answer cleared successfully');
    } catch (e) {
      logger.error('Error clearing answer: $e');
      state = state.copyWith(error: 'Failed to clear answer: $e');
    }
  }

  /// Clear all answers for the current quiz session
  /// PHASE 4: Persists cleared state to database
  Future<void> clearAllAnswers() async {
    if (state.activeSession == null) {
      logger.warning('Cannot clear all answers: No active session');
      return;
    }

    try {
      logger.info('Clearing all answers for session: ${state.activeSession!.id}');
      state = state.copyWith(clearError: true);

      // Call repository method to clear all answers directly in database
      final result = await _repository.clearAllAnswers(state.activeSession!.id);

      result.fold(
        (failure) {
          logger.error('Failed to clear all answers: ${failure.message}');
          state = state.copyWith(error: 'Failed to clear all answers: ${failure.message}');
        },
        (updatedSession) {
          // Update state with cleared session
          state = state.copyWith(
            activeSession: updatedSession.copyWith(answersBackup: null), // Do not persist cleared answers
            clearError: true,
          );
          logger.info('All answers cleared and persisted to database successfully');
        },
      );
    } catch (e) {
      logger.error('Error clearing all answers: $e');
      state = state.copyWith(error: 'Failed to clear all answers: $e');
    }
  }

  /// PHASE 4: Undo the last clearAllAnswers operation
  /// Restores answers from backup (10-second undo window via snackbar)
  Future<void> undoClearAllAnswers() async {
    if (state.activeSession == null) {
      logger.warning('Cannot undo: No active session');
      return;
    }

    if (state.activeSession!.answersBackup == null) {
      logger.warning('Cannot undo: No backup available');
      return;
    }

    try {
      logger.info('Undoing clear all answers for session: ${state.activeSession!.id}');
      state = state.copyWith(clearError: true);

      final currentSession = state.activeSession!;
      final updatedSession = currentSession.copyWith(
        answers: Map<String, String>.from(currentSession.answersBackup!),
        answersBackup: null, // Clear backup after restore
      );

      state = state.copyWith(
        activeSession: updatedSession,
        clearError: true,
      );

      logger.info('Answers restored from backup successfully');
    } catch (e) {
      logger.error('Error undoing clear all answers: $e');
      state = state.copyWith(error: 'Failed to undo clear all answers: $e');
    }
  }

  /// PHASE 4: Restore answers from persistent backup
  /// Unlike undo, this persists until quiz submission
  Future<void> restoreAnswers() async {
    if (state.activeSession == null) {
      logger.warning('Cannot restore: No active session');
      return;
    }

    if (state.activeSession!.answersBackup == null) {
      logger.warning('Cannot restore: No backup available');
      return;
    }

    try {
      logger.info('Restoring answers for session: ${state.activeSession!.id}');
      state = state.copyWith(clearError: true);

      final currentSession = state.activeSession!;
      final updatedSession = currentSession.copyWith(
        answers: Map<String, String>.from(currentSession.answersBackup!),
        // Keep backup for potential future restore
      );

      state = state.copyWith(
        activeSession: updatedSession,
        clearError: true,
      );

      logger.info('Answers restored successfully');
    } catch (e) {
      logger.error('Error restoring answers: $e');
      state = state.copyWith(error: 'Failed to restore answers: $e');
    }
  }

  /// Complete the current quiz and get results
  Future<void> completeQuiz() async {
    if (state.activeSession == null) {
      logger.warning('Cannot complete quiz: No active session');
      return;
    }

    try {
      final sessionId = state.activeSession!.id;
      logger.info('Completing quiz: $sessionId');
      _safeSetState(state.copyWith(isLoading: true, clearError: true));

      final result = await _completeQuizUseCase(
        CompleteQuizParams(sessionId: sessionId),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to complete quiz: ${failure.message}');
          _safeSetState(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (quizResult) {
          logger.info(
            'Quiz completed: Score ${quizResult.correctAnswers}/${quizResult.totalQuestions}',
          );

          // Note: History is loaded separately via loadHistory() method
          // QuizResult doesn't contain the full attempt, just the results

          _safeSetState(state.copyWith(
            lastResult: quizResult,
            isLoading: false,
            clearError: true,
            clearActiveSession: true,
          ));
        },
      );
    } catch (e) {
      logger.error('Error completing quiz: $e');
      _safeSetState(state.copyWith(
        isLoading: false,
        error: 'Failed to complete quiz: $e',
      ));
    }
  }

  /// Resume a paused quiz session
  Future<void> resumeSession(String sessionId) async {
    try {
      logger.info('Resuming quiz session: $sessionId');

      // CRITICAL FIX: Clear activeSession when resuming to prevent stale data
      _safeSetState(state.copyWith(
        isLoading: true,
        clearError: true,
        clearActiveSession: true,
      ));

      final result = await _resumeSessionUseCase(
        ResumeSessionParams(sessionId: sessionId),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to resume session: ${failure.message}');
          _safeSetState(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (session) {
          logger.info('Session resumed successfully');
          _safeSetState(state.copyWith(
            activeSession: session,
            isLoading: false,
            clearError: true,
            clearLastResult: true,
          ));
        },
      );
    } catch (e) {
      logger.error('Error resuming session: $e');
      _safeSetState(state.copyWith(
        isLoading: false,
        error: 'Failed to resume session: $e',
      ));
    }
  }

  /// Load quiz history for a student
  Future<void> loadHistory({
    required String studentId,
    String? entityId,
    int? limit,
  }) async {
    try {
      logger.info('Loading quiz history for student: $studentId');
      _safeSetState(state.copyWith(isLoading: true, clearError: true));

      final result = await _getQuizHistoryUseCase(
        GetQuizHistoryParams(
          studentId: studentId,
          entityId: entityId,
          limit: limit,
        ),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to load history: ${failure.message}');
          _safeSetState(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (history) {
          logger.info('Loaded ${history.length} quiz attempts');
          _safeSetState(state.copyWith(
            history: history,
            isLoading: false,
            clearError: true,
          ));
        },
      );
    } catch (e) {
      logger.error('Error loading history: $e');
      _safeSetState(state.copyWith(
        isLoading: false,
        error: 'Failed to load history: $e',
      ));
    }
  }

  /// Check for and load active session for a student
  Future<void> checkActiveSession(String studentId) async {
    try {
      logger.info('Checking for active session for student: $studentId');

      final result = await _getActiveSessionUseCase(
        GetActiveSessionParams(studentId: studentId),
      );

      result.fold(
        (failure) {
          logger.error('Failed to check active session: ${failure.message}');
        },
        (session) {
          if (session != null) {
            logger.info('Found active session: ${session.id}');
            state = state.copyWith(
              activeSession: session,
              clearError: true,
            );
          } else {
            logger.info('No active session found');
          }
        },
      );
    } catch (e) {
      logger.error('Error checking active session: $e');
    }
  }

  /// Clear the current active session (without saving)
  void clearActiveSession() {
    logger.info('Clearing active session');
    state = state.copyWith(clearActiveSession: true);
  }

  /// Clear the last quiz result
  void clearLastResult() {
    logger.info('Clearing last result');
    state = state.copyWith(clearLastResult: true);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Navigate to a specific question by index
  void navigateToQuestion(int index) {
    if (state.activeSession == null) {
      logger.warning('Cannot navigate: No active session');
      return;
    }

    if (index < 0 || index >= state.activeSession!.questions.length) {
      logger.warning('Cannot navigate: Invalid question index $index');
      return;
    }

    logger.info('Navigating to question index: $index');

    // Update the session with the new current question index
    final updatedSession = state.activeSession!.copyWith(
      currentQuestionIndex: index,
    );

    state = state.copyWith(activeSession: updatedSession);
  }
}

/// Provider for quiz state management
final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  final container = injectionContainer;

  return QuizNotifier(
    loadQuizUseCase: container.loadQuizUseCase,
    submitAnswerUseCase: container.submitAnswerUseCase,
    completeQuizUseCase: container.completeQuizUseCase,
    resumeSessionUseCase: container.resumeSessionUseCase,
    getQuizHistoryUseCase: container.getQuizHistoryUseCase,
    getActiveSessionUseCase: container.getActiveSessionUseCase,
    repository: container.quizRepository, // PHASE 4: Direct repository access
  );
});
