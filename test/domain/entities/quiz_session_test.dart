/// QuizSession entity tests with state machine verification
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';

import '../../fixtures/quiz_fixtures.dart';

void main() {
  group('QuizSession', () {
    // =========================================================================
    // STATE MACHINE TESTS
    // =========================================================================
    /*
     * State Machine:
     *
     *   NOT_STARTED ──[loadQuiz]──> IN_PROGRESS
     *                                   │
     *                    ┌──────────────┼──────────────┐
     *                    │              │              │
     *              [submitAnswer]  [clearAnswers]  [timeout]
     *                    │              │              │
     *                    ▼              ▼              ▼
     *              IN_PROGRESS    IN_PROGRESS    COMPLETED
     *                    │
     *            [submitLastAnswer + complete]
     *                    │
     *                    ▼
     *              COMPLETED
     */

    group('State Machine', () {
      test('emptySession_isNotStarted', () {
        final session = QuizFixtures.emptySession;
        expect(session.state, QuizSessionState.notStarted);
        expect(session.isInProgress, false);
        expect(session.isCompleted, false);
      });

      test('notStartedSession_hasQuestions', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.state, QuizSessionState.notStarted);
        expect(session.questions.length, 5);
        expect(session.isInProgress, false);
      });

      test('inProgressSession_hasAnswers', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.state, QuizSessionState.inProgress);
        expect(session.isInProgress, true);
        expect(session.answers.isNotEmpty, true);
      });

      test('completedSession_hasEndTime', () {
        final session = QuizFixtures.completedSession;
        expect(session.state, QuizSessionState.completed);
        expect(session.isCompleted, true);
        expect(session.endTime, isNotNull);
      });

      test('pausedSession_isPaused', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          state: QuizSessionState.paused,
        );
        expect(session.isPaused, true);
        expect(session.isInProgress, false);
      });
    });

    // =========================================================================
    // NAVIGATION TESTS
    // =========================================================================
    group('Navigation', () {
      test('currentQuestion_returnsCorrectQuestion', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.currentQuestion, isNotNull);
        expect(session.currentQuestion!.id, 'q3'); // index 2
      });

      test('currentQuestion_atFirstIndex_returnsFirstQuestion', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.currentQuestionIndex, 0);
        expect(session.currentQuestion!.id, 'q1');
      });

      test('currentQuestion_withEmptyQuestions_returnsNull', () {
        final session = QuizFixtures.emptySession;
        expect(session.currentQuestion, isNull);
      });

      test('currentQuestion_withInvalidIndex_returnsNull', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          currentQuestionIndex: 100,
        );
        expect(session.currentQuestion, isNull);
      });

      test('isFirstQuestion_atIndexZero_returnsTrue', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.isFirstQuestion, true);
      });

      test('isFirstQuestion_atIndexOne_returnsFalse', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          currentQuestionIndex: 1,
        );
        expect(session.isFirstQuestion, false);
      });

      test('isLastQuestion_atLastIndex_returnsTrue', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          currentQuestionIndex: 4, // 5 questions, last index is 4
        );
        expect(session.isLastQuestion, true);
      });

      test('isLastQuestion_atFirstIndex_returnsFalse', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.isLastQuestion, false);
      });
    });

    // =========================================================================
    // ANSWER TRACKING TESTS
    // =========================================================================
    group('Answer Tracking', () {
      test('answeredCount_withNoAnswers_returnsZero', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.answeredCount, 0);
      });

      test('answeredCount_withSomeAnswers_returnsCount', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.answeredCount, 2);
      });

      test('answeredCount_withAllAnswered_returnsTotal', () {
        final session = QuizFixtures.fullyAnsweredSession;
        expect(session.answeredCount, 5);
      });

      test('unansweredCount_withNoAnswers_returnsTotal', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.unansweredCount, 5);
      });

      test('unansweredCount_withSomeAnswers_returnsRemaining', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.unansweredCount, 3);
      });

      test('unansweredCount_withAllAnswered_returnsZero', () {
        final session = QuizFixtures.fullyAnsweredSession;
        expect(session.unansweredCount, 0);
      });

      test('hasAnswerForCurrentQuestion_withAnswer_returnsTrue', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          currentQuestionIndex: 0, // q1 has answer
        );
        expect(session.hasAnswerForCurrentQuestion, true);
      });

      test('hasAnswerForCurrentQuestion_withoutAnswer_returnsFalse', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          currentQuestionIndex: 3, // q4 has no answer
        );
        expect(session.hasAnswerForCurrentQuestion, false);
      });

      test('getAnswer_existingQuestion_returnsAnswer', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.getAnswer('q1'), '4');
        expect(session.getAnswer('q2'), 'Delhi');
      });

      test('getAnswer_nonExistingQuestion_returnsNull', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.getAnswer('q99'), isNull);
      });

      test('allQuestionsAnswered_withAllAnswered_returnsTrue', () {
        final session = QuizFixtures.fullyAnsweredSession;
        expect(session.allQuestionsAnswered, true);
      });

      test('allQuestionsAnswered_withPartialAnswers_returnsFalse', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.allQuestionsAnswered, false);
      });
    });

    // =========================================================================
    // PROGRESS PERCENTAGE TESTS
    // =========================================================================
    group('Progress Percentage', () {
      test('withEmptyQuestions_returnsZero', () {
        final session = QuizFixtures.emptySession;
        expect(session.progressPercentage, 0.0);
      });

      test('withNoAnswers_returnsZero', () {
        final session = QuizFixtures.notStartedSession;
        expect(session.progressPercentage, 0.0);
      });

      test('withTwoOfFiveAnswered_returns40', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.progressPercentage, 40.0);
      });

      test('withAllAnswered_returns100', () {
        final session = QuizFixtures.fullyAnsweredSession;
        expect(session.progressPercentage, 100.0);
      });

      test('withCustomProgress_calculatesCorrectly', () {
        final session = QuizFixtures.sessionWithProgress(
          totalQuestions: 10,
          answeredQuestions: 7,
          currentIndex: 7,
        );
        expect(session.progressPercentage, 70.0);
      });
    });

    // =========================================================================
    // ELAPSED TIME TESTS
    // =========================================================================
    group('Elapsed Time', () {
      test('completedSession_calculatesFromEndTime', () {
        final session = QuizFixtures.completedSession;
        // 15 minutes elapsed (10:00 to 10:15)
        expect(session.elapsedSeconds, 15 * 60);
      });

      test('inProgressSession_calculatesFromNow', () {
        final now = DateTime.now();
        final session = QuizFixtures.inProgressSession.copyWith(
          startTime: now.subtract(const Duration(minutes: 5)),
        );
        // Should be approximately 5 minutes
        expect(session.elapsedSeconds, greaterThanOrEqualTo(5 * 60 - 1));
        expect(session.elapsedSeconds, lessThanOrEqualTo(5 * 60 + 1));
      });
    });

    // =========================================================================
    // ANSWERS BACKUP TESTS (PHASE 4 UNDO FEATURE)
    // =========================================================================
    group('Answers Backup (Undo Feature)', () {
      test('sessionWithBackup_hasBackup', () {
        final session = QuizFixtures.sessionWithBackup;
        expect(session.answersBackup, isNotNull);
        expect(session.answersBackup!.length, 2);
      });

      test('sessionWithBackup_hasEmptyAnswers', () {
        final session = QuizFixtures.sessionWithBackup;
        expect(session.answers, isEmpty);
      });

      test('sessionWithoutBackup_hasNullBackup', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.answersBackup, isNull);
      });

      test('copyWith_preservesBackup', () {
        final session = QuizFixtures.sessionWithBackup;
        final copied = session.copyWith(currentQuestionIndex: 1);

        expect(copied.answersBackup, session.answersBackup);
      });

      test('copyWith_canClearBackup', () {
        final session = QuizFixtures.sessionWithBackup;
        final cleared = session.copyWith(
          answers: session.answersBackup!, // Non-null assertion - we know sessionWithBackup has backup
          answersBackup: null,
        );

        expect(cleared.answers, {'q1': '4', 'q2': 'Delhi'});
        expect(cleared.answersBackup, isNull);
      });
    });

    // =========================================================================
    // ASSESSMENT TYPE TESTS
    // =========================================================================
    group('Assessment Type', () {
      test('defaultsToPractice', () {
        final session = QuizFixtures.inProgressSession;
        expect(session.assessmentType.queryValue, 'practice');
      });

      test('canBeSetToReadiness', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          assessmentType: AssessmentType.readiness,
        );
        expect(session.assessmentType.queryValue, 'readiness');
      });

      test('canBeSetToKnowledge', () {
        final session = QuizFixtures.inProgressSession.copyWith(
          assessmentType: AssessmentType.knowledge,
        );
        expect(session.assessmentType.queryValue, 'knowledge');
      });
    });

    // =========================================================================
    // COPYWIDTH TESTS
    // =========================================================================
    group('copyWith', () {
      test('updatesCurrentQuestionIndex', () {
        final session = QuizFixtures.inProgressSession;
        final updated = session.copyWith(currentQuestionIndex: 4);

        expect(updated.currentQuestionIndex, 4);
        expect(session.currentQuestionIndex, 2, reason: 'Original unchanged');
      });

      test('updatesAnswers', () {
        final session = QuizFixtures.inProgressSession;
        final newAnswers = {...session.answers, 'q3': 'Mercury'};
        final updated = session.copyWith(answers: newAnswers);

        expect(updated.answers.length, 3);
        expect(session.answers.length, 2, reason: 'Original unchanged');
      });

      test('updatesState', () {
        final session = QuizFixtures.inProgressSession;
        final updated = session.copyWith(state: QuizSessionState.completed);

        expect(updated.isCompleted, true);
        expect(session.isInProgress, true, reason: 'Original unchanged');
      });

      test('preservesAllFieldsWhenNoChanges', () {
        final original = QuizFixtures.completedSession;
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.quizId, original.quizId);
        expect(copy.studentId, original.studentId);
        expect(copy.questions, original.questions);
        expect(copy.answers, original.answers);
        expect(copy.startTime, original.startTime);
        expect(copy.endTime, original.endTime);
        expect(copy.state, original.state);
        expect(copy.currentQuestionIndex, original.currentQuestionIndex);
      });
    });
  });
}
