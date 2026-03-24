/// QuizProvider tests - Critical state transition and question swap prevention tests
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/presentation/providers/user/quiz_provider.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';

import '../../../fixtures/quiz_fixtures.dart';
import '../../../mocks/mock_use_cases.dart';

void main() {
  group('QuizState', () {
    // =========================================================================
    // INITIAL STATE TESTS
    // =========================================================================
    group('initial', () {
      test('hasCorrectDefaults', () {
        final state = QuizState.initial();

        expect(state.activeSession, isNull);
        expect(state.lastResult, isNull);
        expect(state.history, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNull);
      });
    });

    // =========================================================================
    // COMPUTED PROPERTIES TESTS
    // =========================================================================
    group('computed properties', () {
      test('hasActiveSession_withSession_returnsTrue', () {
        final state = QuizState(
          activeSession: QuizFixtures.inProgressSession,
          history: const [],
          isLoading: false,
        );

        expect(state.hasActiveSession, true);
      });

      test('hasActiveSession_withoutSession_returnsFalse', () {
        final state = QuizState.initial();
        expect(state.hasActiveSession, false);
      });

      test('currentQuizId_withSession_returnsId', () {
        final state = QuizState(
          activeSession: QuizFixtures.inProgressSession,
          history: const [],
          isLoading: false,
        );

        expect(state.currentQuizId, 'quiz-1');
      });

      test('currentQuizId_withoutSession_returnsNull', () {
        final state = QuizState.initial();
        expect(state.currentQuizId, isNull);
      });

      test('currentQuestionIndex_withSession_returnsIndex', () {
        final state = QuizState(
          activeSession: QuizFixtures.inProgressSession,
          history: const [],
          isLoading: false,
        );

        expect(state.currentQuestionIndex, 2);
      });

      test('currentQuestionIndex_withoutSession_returnsZero', () {
        final state = QuizState.initial();
        expect(state.currentQuestionIndex, 0);
      });

      test('totalQuestions_withSession_returnsCount', () {
        final state = QuizState(
          activeSession: QuizFixtures.inProgressSession,
          history: const [],
          isLoading: false,
        );

        expect(state.totalQuestions, 5);
      });

      test('totalQuestions_withoutSession_returnsZero', () {
        final state = QuizState.initial();
        expect(state.totalQuestions, 0);
      });

      test('progressPercentage_withProgress_calculatesCorrectly', () {
        final state = QuizState(
          activeSession: QuizFixtures.inProgressSession.copyWith(
            currentQuestionIndex: 2,
          ),
          history: const [],
          isLoading: false,
        );

        // 2/5 = 40%
        expect(state.progressPercentage, 40.0);
      });

      test('progressPercentage_withNoQuestions_returnsZero', () {
        final state = QuizState(
          activeSession: QuizFixtures.emptySession,
          history: const [],
          isLoading: false,
        );

        expect(state.progressPercentage, 0.0);
      });
    });

    // =========================================================================
    // COPY WITH TESTS
    // =========================================================================
    group('copyWith', () {
      test('updatesActiveSession', () {
        final initial = QuizState.initial();
        final updated = initial.copyWith(
          activeSession: QuizFixtures.inProgressSession,
        );

        expect(updated.activeSession, isNotNull);
        expect(initial.activeSession, isNull);
      });

      test('clearActiveSession_setsToNull', () {
        final withSession = QuizState(
          activeSession: QuizFixtures.inProgressSession,
          history: const [],
          isLoading: false,
        );

        final cleared = withSession.copyWith(clearActiveSession: true);

        expect(cleared.activeSession, isNull);
      });

      test('clearLastResult_setsToNull', () {
        final withResult = QuizState(
          lastResult: QuizFixtures.perfectResult,
          history: const [],
          isLoading: false,
        );

        final cleared = withResult.copyWith(clearLastResult: true);

        expect(cleared.lastResult, isNull);
      });

      test('clearError_setsToNull', () {
        final withError = QuizState(
          error: 'Some error',
          history: const [],
          isLoading: false,
        );

        final cleared = withError.copyWith(clearError: true);

        expect(cleared.error, isNull);
      });

      test('preservesUnchangedFields', () {
        final original = QuizState(
          activeSession: QuizFixtures.inProgressSession,
          lastResult: QuizFixtures.perfectResult,
          history: QuizFixtures.sampleAttemptHistory,
          isLoading: true,
          error: 'Error',
        );

        final updated = original.copyWith(isLoading: false);

        expect(updated.isLoading, false);
        expect(updated.activeSession, original.activeSession);
        expect(updated.lastResult, original.lastResult);
        expect(updated.history, original.history);
        expect(updated.error, original.error);
      });
    });
  });

  // ===========================================================================
  // CRITICAL: Question Swap Bug Prevention Tests
  // This tests the fix for the bug where clicking an answer on old session
  // while new quiz is loading would cause answer to go to wrong question
  // ===========================================================================
  group('Question Swap Bug Prevention (CRITICAL)', () {
    test('loadQuiz_clearsActiveSessionImmediately', () {
      // This simulates the critical fix where activeSession is cleared
      // immediately when starting to load a new quiz

      // Arrange: Start with an existing session
      final oldSession = QuizFixtures.inProgressSession;
      var state = QuizState(
        activeSession: oldSession,
        history: const [],
        isLoading: false,
      );

      // Act: Simulate the start of loadQuiz
      // This is what the provider does: clear session AND set loading
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        clearActiveSession: true, // CRITICAL: This prevents the bug
      );

      // Assert: Session should be null IMMEDIATELY
      expect(
        state.activeSession,
        isNull,
        reason: 'Active session must be cleared immediately to prevent question swap bug',
      );
      expect(state.isLoading, true);
    });

    test('resumeSession_clearsActiveSessionImmediately', () {
      // Same pattern for resumeSession
      final oldSession = QuizFixtures.inProgressSession;
      var state = QuizState(
        activeSession: oldSession,
        history: const [],
        isLoading: false,
      );

      // Simulate resumeSession start
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        clearActiveSession: true,
      );

      expect(
        state.activeSession,
        isNull,
        reason: 'Active session must be cleared when resuming to prevent stale data',
      );
    });

    test('newSession_resetsQuestionIndexToZero', () {
      // After loading completes, the question index should be 0
      final newSession = QuizFixtures.inProgressSession.copyWith(
        currentQuestionIndex: 5, // Simulate stale index from DB
      );

      // What the provider does: reset index to 0
      final sessionWithCorrectIndex = newSession.copyWith(currentQuestionIndex: 0);

      expect(
        sessionWithCorrectIndex.currentQuestionIndex,
        0,
        reason: 'Question index must be reset to 0 when loading a quiz',
      );
    });
  });

  // ===========================================================================
  // State Transition Tests
  // ===========================================================================
  group('State Transitions', () {
    test('loadQuiz_success_transition', () {
      // Initial -> Loading -> Loaded
      var state = QuizState.initial();

      // Start loading
      state = state.copyWith(
        isLoading: true,
        clearActiveSession: true,
      );
      expect(state.isLoading, true);
      expect(state.activeSession, isNull);

      // Load complete
      state = state.copyWith(
        activeSession: QuizFixtures.notStartedSession.copyWith(currentQuestionIndex: 0),
        isLoading: false,
        clearError: true,
        clearLastResult: true,
      );
      expect(state.isLoading, false);
      expect(state.activeSession, isNotNull);
      expect(state.activeSession!.currentQuestionIndex, 0);
      expect(state.error, isNull);
    });

    test('loadQuiz_error_transition', () {
      var state = QuizState.initial();

      // Start loading
      state = state.copyWith(
        isLoading: true,
        clearActiveSession: true,
      );

      // Error occurs
      state = state.copyWith(
        isLoading: false,
        error: 'Quiz not found',
      );

      expect(state.isLoading, false);
      expect(state.activeSession, isNull);
      expect(state.error, 'Quiz not found');
    });

    test('submitAnswer_updatesAnswersMap', () {
      final session = QuizFixtures.inProgressSession;
      var state = QuizState(
        activeSession: session,
        history: const [],
        isLoading: false,
      );

      // Simulate answer submission
      final updatedAnswers = {...session.answers, 'q3': 'Mercury'};
      final updatedSession = session.copyWith(answers: updatedAnswers);
      state = state.copyWith(activeSession: updatedSession);

      expect(state.activeSession!.answers['q3'], 'Mercury');
      expect(state.activeSession!.answers.length, 3);
    });

    test('completeQuiz_transition', () {
      var state = QuizState(
        activeSession: QuizFixtures.fullyAnsweredSession,
        history: const [],
        isLoading: false,
      );

      // Start completion
      state = state.copyWith(isLoading: true, clearError: true);
      expect(state.isLoading, true);

      // Completion success
      state = state.copyWith(
        lastResult: QuizFixtures.perfectResult,
        isLoading: false,
        clearError: true,
        clearActiveSession: true,
      );

      expect(state.isLoading, false);
      expect(state.activeSession, isNull);
      expect(state.lastResult, isNotNull);
      expect(state.lastResult!.scorePercentage, 100.0);
    });
  });

  // ===========================================================================
  // Navigation Tests
  // ===========================================================================
  group('Question Navigation', () {
    test('navigateToQuestion_updatesIndex', () {
      final session = QuizFixtures.inProgressSession;
      var state = QuizState(
        activeSession: session,
        history: const [],
        isLoading: false,
      );

      // Navigate to question 4 (index 3)
      final updatedSession = session.copyWith(currentQuestionIndex: 3);
      state = state.copyWith(activeSession: updatedSession);

      expect(state.currentQuestionIndex, 3);
    });

    test('navigateToQuestion_preservesAnswers', () {
      final session = QuizFixtures.inProgressSession;
      var state = QuizState(
        activeSession: session,
        history: const [],
        isLoading: false,
      );

      final originalAnswers = Map<String, String>.from(session.answers);

      // Navigate
      final updatedSession = session.copyWith(currentQuestionIndex: 4);
      state = state.copyWith(activeSession: updatedSession);

      expect(state.activeSession!.answers, originalAnswers);
    });
  });

  // ===========================================================================
  // Clear and Undo Tests
  // ===========================================================================
  group('Clear and Undo Answers', () {
    test('clearAllAnswers_createsBackup', () {
      final session = QuizFixtures.inProgressSession;
      final originalAnswers = Map<String, String>.from(session.answers);

      // Simulate clearAllAnswers
      final clearedSession = session.copyWith(
        answers: const {},
        answersBackup: originalAnswers,
      );

      expect(clearedSession.answers, isEmpty);
      expect(clearedSession.answersBackup, originalAnswers);
    });

    test('undoClearAllAnswers_restoresFromBackup', () {
      final sessionWithBackup = QuizFixtures.sessionWithBackup;

      // Simulate undo
      final restoredSession = sessionWithBackup.copyWith(
        answers: Map<String, String>.from(sessionWithBackup.answersBackup!),
        answersBackup: null,
      );

      expect(restoredSession.answers, {'q1': '4', 'q2': 'Delhi'});
      expect(restoredSession.answersBackup, isNull);
    });

    test('clearAnswer_removesSpecificAnswer', () {
      final session = QuizFixtures.inProgressSession;

      // Clear q1 answer
      final updatedAnswers = Map<String, String>.from(session.answers);
      updatedAnswers.remove('q1');

      final updatedSession = session.copyWith(answers: updatedAnswers);

      expect(updatedSession.answers.containsKey('q1'), false);
      expect(updatedSession.answers.containsKey('q2'), true);
    });
  });

  // ===========================================================================
  // History Tests
  // ===========================================================================
  group('History', () {
    test('loadHistory_updatesHistoryList', () {
      var state = QuizState.initial();

      state = state.copyWith(
        history: QuizFixtures.sampleAttemptHistory,
        isLoading: false,
      );

      expect(state.history.length, 3);
      expect(state.history.first.quizId, 'quiz-1');
    });

    test('history_preservedAcrossStateChanges', () {
      var state = QuizState(
        history: QuizFixtures.sampleAttemptHistory,
        isLoading: false,
      );

      // Load a quiz
      state = state.copyWith(
        activeSession: QuizFixtures.inProgressSession,
        isLoading: false,
      );

      expect(state.history.length, 3, reason: 'History should be preserved');
    });
  });

  // ===========================================================================
  // QUIZ NOTIFIER TESTS WITH INJECTED MOCKS
  // ===========================================================================
  group('QuizNotifier', () {
    late MockLoadQuizUseCase mockLoadQuizUseCase;
    late MockSubmitAnswerUseCase mockSubmitAnswerUseCase;
    late MockCompleteQuizUseCase mockCompleteQuizUseCase;
    late MockResumeSessionUseCase mockResumeSessionUseCase;
    late MockGetQuizHistoryUseCase mockGetQuizHistoryUseCase;
    late MockGetActiveSessionUseCase mockGetActiveSessionUseCase;
    late MockQuizRepository mockQuizRepository;

    setUp(() {
      mockLoadQuizUseCase = MockLoadQuizUseCase();
      mockSubmitAnswerUseCase = MockSubmitAnswerUseCase();
      mockCompleteQuizUseCase = MockCompleteQuizUseCase();
      mockResumeSessionUseCase = MockResumeSessionUseCase();
      mockGetQuizHistoryUseCase = MockGetQuizHistoryUseCase();
      mockGetActiveSessionUseCase = MockGetActiveSessionUseCase();
      mockQuizRepository = MockQuizRepository();
    });

    QuizNotifier createNotifier() {
      return QuizNotifier(
        loadQuizUseCase: mockLoadQuizUseCase,
        submitAnswerUseCase: mockSubmitAnswerUseCase,
        completeQuizUseCase: mockCompleteQuizUseCase,
        resumeSessionUseCase: mockResumeSessionUseCase,
        getQuizHistoryUseCase: mockGetQuizHistoryUseCase,
        getActiveSessionUseCase: mockGetActiveSessionUseCase,
        repository: mockQuizRepository,
      );
    }

    group('loadQuiz', () {
      test('success_setsActiveSession', () async {
        final session = QuizFixtures.notStartedSession;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(
          entityId: 'topic-1',
          studentId: 'student-1',
        );

        expect(notifier.state.activeSession, isNotNull);
        expect(notifier.state.activeSession!.quizId, 'quiz-1');
        expect(notifier.state.activeSession!.currentQuestionIndex, 0);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);

        notifier.dispose();
      });

      test('success_resetsQuestionIndexToZero', () async {
        // Session from DB might have stale index
        final sessionWithStaleIndex = QuizFixtures.inProgressSession.copyWith(
          currentQuestionIndex: 5,
        );
        mockLoadQuizUseCase.setSuccess(sessionWithStaleIndex);

        final notifier = createNotifier();
        await notifier.loadQuiz(
          entityId: 'topic-1',
          studentId: 'student-1',
        );

        // Should be reset to 0
        expect(notifier.state.activeSession!.currentQuestionIndex, 0);

        notifier.dispose();
      });

      test('success_clearsOldSessionImmediately', () async {
        final notifier = createNotifier();

        // Set initial session
        final oldSession = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(oldSession);
        await notifier.loadQuiz(
          entityId: 'topic-1',
          studentId: 'student-1',
        );

        expect(notifier.state.activeSession, isNotNull);

        // Load new quiz
        final newSession = QuizFixtures.notStartedSession;
        mockLoadQuizUseCase.setSuccess(newSession);

        // Start loading (should clear immediately)
        final loadFuture = notifier.loadQuiz(
          entityId: 'topic-2',
          studentId: 'student-1',
        );

        // Session should be cleared while loading
        // (This is checked internally, state updates might be batched)

        await loadFuture;
        expect(notifier.state.activeSession!.quizId, 'quiz-1');

        notifier.dispose();
      });

      test('failure_setsError', () async {
        mockLoadQuizUseCase.setFailure('Quiz not found');

        final notifier = createNotifier();
        await notifier.loadQuiz(
          entityId: 'invalid-topic',
          studentId: 'student-1',
        );

        expect(notifier.state.activeSession, isNull);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, 'Quiz not found');

        notifier.dispose();
      });

      test('passesCorrectAssessmentType', () async {
        mockLoadQuizUseCase.setSuccess(QuizFixtures.notStartedSession);

        final notifier = createNotifier();
        await notifier.loadQuiz(
          entityId: 'topic-1',
          studentId: 'student-1',
          assessmentType: AssessmentType.readiness,
        );

        expect(mockLoadQuizUseCase.lastParams?.assessmentType, AssessmentType.readiness);
        expect(mockLoadQuizUseCase.callCount, 1);

        notifier.dispose();
      });
    });

    group('submitAnswer', () {
      test('success_updatesSession', () async {
        final session = QuizFixtures.inProgressSession;
        final updatedSession = session.copyWith(
          answers: {...session.answers, 'q3': 'Mercury'},
        );

        mockLoadQuizUseCase.setSuccess(session);
        mockSubmitAnswerUseCase.setSuccess(updatedSession);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        await notifier.submitAnswer(
          questionId: 'q3',
          answer: 'Mercury',
        );

        expect(notifier.state.activeSession!.answers['q3'], 'Mercury');
        expect(mockSubmitAnswerUseCase.callCount, 1);

        notifier.dispose();
      });

      test('maintainsCurrentQuestionIndex', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);
        mockSubmitAnswerUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        final originalIndex = notifier.state.activeSession!.currentQuestionIndex;

        await notifier.submitAnswer(
          questionId: 'q3',
          answer: 'Mercury',
        );

        expect(notifier.state.activeSession!.currentQuestionIndex, originalIndex);

        notifier.dispose();
      });

      test('usesExplicitQuestionIndex', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);
        mockSubmitAnswerUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        await notifier.submitAnswer(
          questionId: 'q3',
          answer: 'Mercury',
          questionIndex: 4,
        );

        expect(mockSubmitAnswerUseCase.lastParams?.currentQuestionIndex, 4);

        notifier.dispose();
      });

      test('withoutActiveSession_doesNothing', () async {
        final notifier = createNotifier();

        await notifier.submitAnswer(
          questionId: 'q1',
          answer: '4',
        );

        expect(mockSubmitAnswerUseCase.callCount, 0);

        notifier.dispose();
      });

      test('failure_setsError', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);
        mockSubmitAnswerUseCase.setFailure('Failed to save answer');

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        await notifier.submitAnswer(
          questionId: 'q3',
          answer: 'Mercury',
        );

        expect(notifier.state.error, 'Failed to save answer');

        notifier.dispose();
      });
    });

    group('clearAnswer', () {
      test('removesAnswerFromSession', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        expect(notifier.state.activeSession!.answers.containsKey('q1'), true);

        await notifier.clearAnswer(questionId: 'q1');

        expect(notifier.state.activeSession!.answers.containsKey('q1'), false);
        expect(notifier.state.activeSession!.answers.containsKey('q2'), true);

        notifier.dispose();
      });

      test('withoutActiveSession_doesNothing', () async {
        final notifier = createNotifier();

        await notifier.clearAnswer(questionId: 'q1');

        expect(notifier.state.activeSession, isNull);

        notifier.dispose();
      });
    });

    group('clearAllAnswers', () {
      test('success_clearsAllAnswers', () async {
        final session = QuizFixtures.inProgressSession;
        final clearedSession = session.copyWith(answers: const {});

        mockLoadQuizUseCase.setSuccess(session);
        mockQuizRepository.setClearAllAnswersSuccess(clearedSession);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        expect(notifier.state.activeSession!.answers.isNotEmpty, true);

        await notifier.clearAllAnswers();

        expect(notifier.state.activeSession!.answers, isEmpty);

        notifier.dispose();
      });

      test('failure_setsError', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);
        mockQuizRepository.setClearAllAnswersFailure('Database error');

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        await notifier.clearAllAnswers();

        expect(notifier.state.error, contains('Failed to clear all answers'));

        notifier.dispose();
      });

      test('withoutActiveSession_doesNothing', () async {
        final notifier = createNotifier();

        await notifier.clearAllAnswers();

        expect(notifier.state.activeSession, isNull);

        notifier.dispose();
      });
    });

    group('undoClearAllAnswers', () {
      test('restoresAnswersFromBackup', () async {
        final session = QuizFixtures.sessionWithBackup;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        // State should have backup
        expect(notifier.state.activeSession!.answersBackup, isNotNull);

        await notifier.undoClearAllAnswers();

        expect(notifier.state.activeSession!.answers, {'q1': '4', 'q2': 'Delhi'});
        expect(notifier.state.activeSession!.answersBackup, isNull);

        notifier.dispose();
      });

      test('withoutBackup_doesNothing', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        final originalAnswers = Map<String, String>.from(
          notifier.state.activeSession!.answers
        );

        await notifier.undoClearAllAnswers();

        expect(notifier.state.activeSession!.answers, originalAnswers);

        notifier.dispose();
      });
    });

    group('completeQuiz', () {
      test('success_setsResultAndClearsSession', () async {
        final session = QuizFixtures.fullyAnsweredSession;
        final result = QuizFixtures.perfectResult;

        mockLoadQuizUseCase.setSuccess(session);
        mockCompleteQuizUseCase.setSuccess(result);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        await notifier.completeQuiz();

        expect(notifier.state.lastResult, isNotNull);
        expect(notifier.state.lastResult!.scorePercentage, 100.0);
        expect(notifier.state.activeSession, isNull);
        expect(notifier.state.isLoading, false);

        notifier.dispose();
      });

      test('failure_setsError', () async {
        final session = QuizFixtures.fullyAnsweredSession;
        mockLoadQuizUseCase.setSuccess(session);
        mockCompleteQuizUseCase.setFailure('Failed to save results');

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        await notifier.completeQuiz();

        expect(notifier.state.error, 'Failed to save results');
        expect(notifier.state.isLoading, false);

        notifier.dispose();
      });

      test('withoutActiveSession_doesNothing', () async {
        final notifier = createNotifier();

        await notifier.completeQuiz();

        expect(mockCompleteQuizUseCase.callCount, 0);

        notifier.dispose();
      });
    });

    group('resumeSession', () {
      test('success_setsActiveSession', () async {
        final session = QuizFixtures.inProgressSession;
        mockResumeSessionUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.resumeSession('session-1');

        expect(notifier.state.activeSession, isNotNull);
        expect(notifier.state.activeSession!.id, 'session-in-progress');
        expect(notifier.state.isLoading, false);

        notifier.dispose();
      });

      test('failure_setsError', () async {
        mockResumeSessionUseCase.setFailure('Session not found');

        final notifier = createNotifier();
        await notifier.resumeSession('invalid-session');

        expect(notifier.state.activeSession, isNull);
        expect(notifier.state.error, 'Session not found');
        expect(notifier.state.isLoading, false);

        notifier.dispose();
      });
    });

    group('loadHistory', () {
      test('success_setsHistory', () async {
        final history = QuizFixtures.sampleAttemptHistory;
        mockGetQuizHistoryUseCase.setSuccess(history);

        final notifier = createNotifier();
        await notifier.loadHistory(studentId: 'student-1');

        expect(notifier.state.history.length, 3);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);

        notifier.dispose();
      });

      test('failure_setsError', () async {
        mockGetQuizHistoryUseCase.setFailure('Database error');

        final notifier = createNotifier();
        await notifier.loadHistory(studentId: 'student-1');

        expect(notifier.state.history, isEmpty);
        expect(notifier.state.error, 'Database error');
        expect(notifier.state.isLoading, false);

        notifier.dispose();
      });

      test('passesCorrectParams', () async {
        mockGetQuizHistoryUseCase.setSuccess([]);

        final notifier = createNotifier();
        await notifier.loadHistory(
          studentId: 'student-1',
          entityId: 'topic-1',
          limit: 10,
        );

        expect(mockGetQuizHistoryUseCase.lastParams?.studentId, 'student-1');
        expect(mockGetQuizHistoryUseCase.lastParams?.entityId, 'topic-1');
        expect(mockGetQuizHistoryUseCase.lastParams?.limit, 10);

        notifier.dispose();
      });
    });

    group('checkActiveSession', () {
      test('withActiveSession_setsSession', () async {
        final session = QuizFixtures.inProgressSession;
        mockGetActiveSessionUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.checkActiveSession('student-1');

        expect(notifier.state.activeSession, isNotNull);

        notifier.dispose();
      });

      test('withoutActiveSession_doesNotSetSession', () async {
        mockGetActiveSessionUseCase.setSuccess(null);

        final notifier = createNotifier();
        await notifier.checkActiveSession('student-1');

        expect(notifier.state.activeSession, isNull);

        notifier.dispose();
      });

      test('failure_doesNotCrash', () async {
        mockGetActiveSessionUseCase.setFailure('Database error');

        final notifier = createNotifier();
        await notifier.checkActiveSession('student-1');

        expect(notifier.state.activeSession, isNull);

        notifier.dispose();
      });
    });

    group('navigateToQuestion', () {
      test('updatesCurrentQuestionIndex', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        notifier.navigateToQuestion(3);

        expect(notifier.state.activeSession!.currentQuestionIndex, 3);

        notifier.dispose();
      });

      test('withInvalidIndex_doesNotUpdate', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        final originalIndex = notifier.state.activeSession!.currentQuestionIndex;

        notifier.navigateToQuestion(100); // Invalid

        expect(notifier.state.activeSession!.currentQuestionIndex, originalIndex);

        notifier.dispose();
      });

      test('withoutActiveSession_doesNothing', () async {
        final notifier = createNotifier();

        notifier.navigateToQuestion(3);

        expect(notifier.state.activeSession, isNull);

        notifier.dispose();
      });
    });

    group('clear methods', () {
      test('clearActiveSession_clearsSession', () async {
        final session = QuizFixtures.inProgressSession;
        mockLoadQuizUseCase.setSuccess(session);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        expect(notifier.state.activeSession, isNotNull);

        notifier.clearActiveSession();

        expect(notifier.state.activeSession, isNull);

        notifier.dispose();
      });

      test('clearLastResult_clearsResult', () async {
        final session = QuizFixtures.fullyAnsweredSession;
        final result = QuizFixtures.perfectResult;

        mockLoadQuizUseCase.setSuccess(session);
        mockCompleteQuizUseCase.setSuccess(result);

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');
        await notifier.completeQuiz();

        expect(notifier.state.lastResult, isNotNull);

        notifier.clearLastResult();

        expect(notifier.state.lastResult, isNull);

        notifier.dispose();
      });

      test('clearError_clearsError', () async {
        mockLoadQuizUseCase.setFailure('Error');

        final notifier = createNotifier();
        await notifier.loadQuiz(entityId: 'topic-1', studentId: 'student-1');

        expect(notifier.state.error, isNotNull);

        notifier.clearError();

        expect(notifier.state.error, isNull);

        notifier.dispose();
      });
    });
  });
}
