/// QuizRepositoryImpl tests - Key method coverage
library;

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/data/repositories/quiz_repository_impl.dart';
import 'package:crack_the_code/data/datasources/json/quiz_json_datasource.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/question_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_session_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:crack_the_code/data/models/quiz/question_model.dart';
import 'package:crack_the_code/data/models/quiz/quiz_model.dart';
import 'package:crack_the_code/data/models/quiz/quiz_session_model.dart';
import 'package:crack_the_code/data/models/quiz/quiz_attempt_model.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt_status.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_filter.dart';

void main() {
  group('QuizRepositoryImpl', () {
    late MockQuestionDao mockQuestionDao;
    late MockQuizDao mockQuizDao;
    late MockQuizSessionDao mockSessionDao;
    late MockQuizAttemptDao mockAttemptDao;
    late MockQuizJsonDataSource mockJsonDataSource;
    late QuizRepositoryImpl repository;

    setUp(() {
      mockQuestionDao = MockQuestionDao();
      mockQuizDao = MockQuizDao();
      mockSessionDao = MockQuizSessionDao();
      mockAttemptDao = MockQuizAttemptDao();
      mockJsonDataSource = MockQuizJsonDataSource();

      repository = QuizRepositoryImpl(
        questionDao: mockQuestionDao,
        quizDao: mockQuizDao,
        quizSessionDao: mockSessionDao,
        quizAttemptDao: mockAttemptDao,
        jsonDataSource: mockJsonDataSource,
      );
    });

    tearDown(() {
      mockQuestionDao.clear();
      mockQuizDao.clear();
      mockSessionDao.clear();
      mockAttemptDao.clear();
      mockJsonDataSource.clear();
    });

    // =========================================================================
    // LOAD QUIZ BY ID TESTS
    // =========================================================================
    group('loadQuizById', () {
      test('success_createsNewSession', () async {
        // Setup
        final quiz = _createTestQuiz('quiz-1');
        final questions = [
          _createTestQuestion('q1'),
          _createTestQuestion('q2'),
        ];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        // Execute
        final result = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );

        // Verify
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session.quizId, 'quiz-1');
            expect(session.studentId, 'student-1');
            expect(session.state, QuizSessionState.notStarted);
            expect(session.questions.isNotEmpty, true);
          },
        );
      });

      test('quizNotFound_returnsNotFoundFailure', () async {
        final result = await repository.loadQuizById(
          quizId: 'non-existent',
          studentId: 'student-1',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NotFoundFailure>());
            expect(failure.message, contains('Quiz not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('withAssessmentType_storesCorrectType', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final result = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
          assessmentType: AssessmentType.readiness,
        );

        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session.assessmentType, AssessmentType.readiness);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockQuizDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<DatabaseFailure>());
          },
          (_) => fail('Should fail'),
        );
      });
    });

    // =========================================================================
    // RESUME SESSION TESTS
    // =========================================================================
    group('resumeSession', () {
      test('success_returnsSessionWithQuestions', () async {
        // Setup: Create a session with questions
        final quiz = _createTestQuiz('quiz-1');
        final questions = [
          _createTestQuestion('q1'),
          _createTestQuestion('q2'),
        ];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        // First create a session
        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final sessionId = loadResult.getOrElse(() => throw Exception('Failed to load')).id;

        // Resume the session
        final result = await repository.resumeSession(sessionId);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session.id, sessionId);
            expect(session.questions.isNotEmpty, true);
          },
        );
      });

      test('sessionNotFound_returnsNotFoundFailure', () async {
        final result = await repository.resumeSession('non-existent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NotFoundFailure>());
          },
          (_) => fail('Should fail'),
        );
      });
    });

    // =========================================================================
    // SUBMIT ANSWER TESTS
    // =========================================================================
    group('submitAnswer', () {
      test('success_addsAnswerToSession', () async {
        // Setup
        final quiz = _createTestQuiz('quiz-1');
        final questions = [
          _createTestQuestion('q1'),
          _createTestQuestion('q2'),
        ];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        // Submit answer
        final result = await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q1',
          answer: 'A',
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (updatedSession) {
            expect(updatedSession.answers.containsKey('q1'), true);
            expect(updatedSession.answers['q1'], 'A');
            expect(updatedSession.state, QuizSessionState.inProgress);
          },
        );
      });

      test('sessionNotFound_returnsNotFoundFailure', () async {
        final result = await repository.submitAnswer(
          sessionId: 'non-existent',
          questionId: 'q1',
          answer: 'A',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NotFoundFailure>());
          },
          (_) => fail('Should fail'),
        );
      });

      test('multipleAnswers_accumulatesCorrectly', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [
          _createTestQuestion('q1'),
          _createTestQuestion('q2'),
          _createTestQuestion('q3'),
        ];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        // Submit multiple answers
        await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q1',
          answer: 'A',
        );
        await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q2',
          answer: 'B',
        );
        final result = await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q3',
          answer: 'C',
        );

        result.fold(
          (failure) => fail('Should succeed'),
          (updatedSession) {
            expect(updatedSession.answers.length, 3);
            expect(updatedSession.answers['q1'], 'A');
            expect(updatedSession.answers['q2'], 'B');
            expect(updatedSession.answers['q3'], 'C');
          },
        );
      });
    });

    // =========================================================================
    // CLEAR ALL ANSWERS TESTS
    // =========================================================================
    group('clearAllAnswers', () {
      test('success_clearsAllAnswers', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1'), _createTestQuestion('q2')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        // Submit some answers
        await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q1',
          answer: 'A',
        );
        await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q2',
          answer: 'B',
        );

        // Clear all answers
        final result = await repository.clearAllAnswers(session.id);

        result.fold(
          (failure) => fail('Should succeed'),
          (clearedSession) {
            expect(clearedSession.answers, isEmpty);
          },
        );
      });
    });

    // =========================================================================
    // COMPLETE QUIZ TESTS
    // =========================================================================
    group('completeQuiz', () {
      test('success_returnsQuizResultWithScore', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [
          _createTestQuestion('q1', correctAnswer: 'A'),
          _createTestQuestion('q2', correctAnswer: 'B'),
        ];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        // Submit answers (both correct)
        await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q1',
          answer: 'A',
        );
        await repository.submitAnswer(
          sessionId: session.id,
          questionId: 'q2',
          answer: 'B',
        );

        // Complete quiz
        final result = await repository.completeQuiz(session.id);

        result.fold(
          (failure) => fail('Should succeed: ${failure.message}'),
          (quizResult) {
            expect(quizResult.totalQuestions, 2);
            expect(quizResult.correctAnswers, 2);
            expect(quizResult.scorePercentage, 100.0);
            expect(quizResult.passed, true);
          },
        );
      });

      test('partialCorrect_calculatesScoreCorrectly', () async {
        final quiz = _createTestQuiz('quiz-1', questionIds: ['q1', 'q2', 'q3', 'q4']);
        final questions = [
          _createTestQuestion('q1', correctAnswer: 'A'),
          _createTestQuestion('q2', correctAnswer: 'B'),
          _createTestQuestion('q3', correctAnswer: 'C'),
          _createTestQuestion('q4', correctAnswer: 'D'),
        ];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        // Submit 2 correct, 2 wrong
        await repository.submitAnswer(sessionId: session.id, questionId: 'q1', answer: 'A');
        await repository.submitAnswer(sessionId: session.id, questionId: 'q2', answer: 'X');
        await repository.submitAnswer(sessionId: session.id, questionId: 'q3', answer: 'C');
        await repository.submitAnswer(sessionId: session.id, questionId: 'q4', answer: 'X');

        final result = await repository.completeQuiz(session.id);

        result.fold(
          (failure) => fail('Should succeed'),
          (quizResult) {
            expect(quizResult.totalQuestions, 4);
            expect(quizResult.correctAnswers, 2);
            expect(quizResult.scorePercentage, 50.0);
          },
        );
      });
    });

    // =========================================================================
    // PAUSE SESSION TESTS
    // =========================================================================
    group('pauseSession', () {
      test('success_setsPausedState', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        final result = await repository.pauseSession(session.id);

        result.fold(
          (failure) => fail('Should succeed'),
          (pausedSession) {
            expect(pausedSession.state, QuizSessionState.paused);
          },
        );
      });
    });

    // =========================================================================
    // GET ACTIVE SESSION TESTS
    // =========================================================================
    group('getActiveSession', () {
      test('noActiveSession_returnsNull', () async {
        final result = await repository.getActiveSession('student-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session, isNull);
          },
        );
      });

      test('withActiveSession_returnsSession', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        // Create a session (which becomes active)
        await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );

        final result = await repository.getActiveSession('student-1');

        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session, isNotNull);
            expect(session!.studentId, 'student-1');
          },
        );
      });
    });

    // =========================================================================
    // DELETE SESSION TESTS
    // =========================================================================
    group('deleteSession', () {
      test('success_deletesSession', () async {
        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final loadResult = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );
        final session = loadResult.getOrElse(() => throw Exception('Failed'));

        final result = await repository.deleteSession(session.id);

        expect(result.isRight(), true);

        // Verify session is deleted
        final activeResult = await repository.getActiveSession('student-1');
        activeResult.fold(
          (failure) => fail('Should succeed'),
          (activeSession) {
            expect(activeSession, isNull);
          },
        );
      });
    });

    // =========================================================================
    // GET QUIZ BY ENTITY ID TESTS
    // =========================================================================
    group('getQuizByEntityId', () {
      test('exists_returnsQuiz', () async {
        final quiz = _createTestQuiz('quiz-1', entityId: 'entity-1');
        mockQuizDao.addQuiz(quiz);

        final result = await repository.getQuizByEntityId('entity-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (quiz) {
            expect(quiz, isNotNull);
            expect(quiz!.entityId, 'entity-1');
          },
        );
      });

      test('notExists_returnsNull', () async {
        final result = await repository.getQuizByEntityId('non-existent');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (quiz) {
            expect(quiz, isNull);
          },
        );
      });
    });

    // =========================================================================
    // GET QUIZZES BY LEVEL TESTS
    // =========================================================================
    group('getQuizzesByLevel', () {
      test('returnsQuizzesMatchingLevel', () async {
        mockQuizDao.addQuiz(_createTestQuiz('quiz-1', level: 'chapter'));
        mockQuizDao.addQuiz(_createTestQuiz('quiz-2', level: 'chapter'));
        mockQuizDao.addQuiz(_createTestQuiz('quiz-3', level: 'topic'));

        final result = await repository.getQuizzesByLevel(QuizLevel.chapter);

        result.fold(
          (failure) => fail('Should succeed'),
          (quizzes) {
            expect(quizzes.length, 2);
            expect(quizzes.every((q) => q.level == QuizLevel.chapter), true);
          },
        );
      });

      test('noMatches_returnsEmptyList', () async {
        mockQuizDao.addQuiz(_createTestQuiz('quiz-1', level: 'chapter'));

        final result = await repository.getQuizzesByLevel(QuizLevel.subject);

        result.fold(
          (failure) => fail('Should succeed'),
          (quizzes) {
            expect(quizzes, isEmpty);
          },
        );
      });
    });

    // =========================================================================
    // PROFILE ID SCOPING TESTS
    // =========================================================================
    group('Profile ID Scoping', () {
      test('withProfileId_usesProfileIdForSession', () async {
        repository.profileId = 'profile-123';

        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final result = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1', // This should be overridden
        );

        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session.studentId, 'profile-123');
          },
        );
      });

      test('withoutProfileId_usesProvidedStudentId', () async {
        repository.profileId = null;

        final quiz = _createTestQuiz('quiz-1');
        final questions = [_createTestQuestion('q1')];
        mockQuizDao.addQuiz(quiz);
        mockQuestionDao.addQuestions(questions);

        final result = await repository.loadQuizById(
          quizId: 'quiz-1',
          studentId: 'student-1',
        );

        result.fold(
          (failure) => fail('Should succeed'),
          (session) {
            expect(session.studentId, 'student-1');
          },
        );
      });
    });

    // =========================================================================
    // GET ATTEMPT HISTORY TESTS
    // =========================================================================
    group('getAttemptHistory', () {
      test('returnsAttempts', () async {
        mockAttemptDao.addAttempt(_createTestAttempt('attempt-1', 'student-1'));
        mockAttemptDao.addAttempt(_createTestAttempt('attempt-2', 'student-1'));

        final result = await repository.getAttemptHistory(studentId: 'student-1');

        result.fold(
          (failure) => fail('Should succeed'),
          (attempts) {
            expect(attempts.length, 2);
          },
        );
      });

      test('emptyHistory_returnsEmptyList', () async {
        final result = await repository.getAttemptHistory(studentId: 'student-1');

        result.fold(
          (failure) => fail('Should succeed'),
          (attempts) {
            expect(attempts, isEmpty);
          },
        );
      });
    });

    // =========================================================================
    // GET QUIZ STATISTICS TESTS
    // =========================================================================
    group('getQuizStatistics', () {
      test('withAttempts_returnsStatistics', () async {
        mockAttemptDao.addAttempt(_createTestAttempt('a1', 'student-1', score: 0.8));
        mockAttemptDao.addAttempt(_createTestAttempt('a2', 'student-1', score: 0.9));

        final result = await repository.getQuizStatistics('student-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (stats) {
            expect(stats.totalAttempts, 2);
            expect(stats.averageScore, greaterThan(0));
          },
        );
      });

      test('noAttempts_returnsZeroStats', () async {
        final result = await repository.getQuizStatistics('student-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should succeed'),
          (stats) {
            expect(stats.totalAttempts, 0);
            expect(stats.averageScore, 0.0);
          },
        );
      });
    });
  });
}

// =============================================================================
// TEST HELPERS
// =============================================================================

QuizModel _createTestQuiz(
  String id, {
  String entityId = 'entity-1',
  String level = 'chapter',
  List<String>? questionIds,
}) {
  return QuizModel(
    id: id,
    level: level,
    entityId: entityId,
    questionIds: jsonEncode(questionIds ?? ['q1', 'q2']),
    timeLimit: 300,
    passingScore: 0.75,
    title: 'Test Quiz',
    config: null,
  );
}

QuestionModel _createTestQuestion(
  String id, {
  String correctAnswer = 'A',
}) {
  return QuestionModel(
    id: id,
    questionText: 'Test Question $id',
    questionType: 'mcq',
    options: jsonEncode(['A', 'B', 'C', 'D']),
    correctAnswer: correctAnswer,
    explanation: 'Test explanation',
    hints: jsonEncode([]),
    difficulty: 'medium',
    topicIds: jsonEncode(['topic-1']),
    conceptTags: jsonEncode(['concept-1']),
    points: 1,
  );
}

QuizAttemptModel _createTestAttempt(
  String id,
  String studentId, {
  double score = 0.8,
}) {
  return QuizAttemptModel(
    id: id,
    quizId: 'quiz-1',
    studentId: studentId,
    answers: const {},
    score: score,
    passed: score >= 0.75,
    completedAt: DateTime.now(),
    timeTaken: 120,
    startTime: DateTime.now().subtract(const Duration(minutes: 2)),
    totalQuestions: 5,
    correctAnswers: (score * 5).round(),
    questions: const [],
    status: QuizAttemptStatus.completed,
  );
}

// =============================================================================
// MOCK IMPLEMENTATIONS
// =============================================================================

class MockQuestionDao implements QuestionDao {
  final List<QuestionModel> _questions = [];
  Exception? _nextException;

  void addQuestions(List<QuestionModel> questions) {
    _questions.addAll(questions);
  }

  void clear() {
    _questions.clear();
    _nextException = null;
  }

  void setNextException(Exception e) {
    _nextException = e;
  }

  void _checkException() {
    if (_nextException != null) {
      final e = _nextException;
      _nextException = null;
      throw e!;
    }
  }

  @override
  Future<List<QuestionModel>> getByIds(List<String> ids) async {
    _checkException();
    return _questions.where((q) => ids.contains(q.id)).toList();
  }

  @override
  Future<List<String>> getAllIds() async {
    _checkException();
    return _questions.map((q) => q.id).toList();
  }

  @override
  Future<void> insertBatch(List<QuestionModel> questions) async {
    _checkException();
    _questions.addAll(questions);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQuizDao implements QuizDao {
  final List<QuizModel> _quizzes = [];
  Exception? _nextException;

  void addQuiz(QuizModel quiz) {
    _quizzes.add(quiz);
  }

  void clear() {
    _quizzes.clear();
    _nextException = null;
  }

  void setNextException(Exception e) {
    _nextException = e;
  }

  void _checkException() {
    if (_nextException != null) {
      final e = _nextException;
      _nextException = null;
      throw e!;
    }
  }

  @override
  Future<QuizModel?> getById(String id) async {
    _checkException();
    try {
      return _quizzes.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<QuizModel?> getByEntityId(String entityId) async {
    _checkException();
    try {
      return _quizzes.firstWhere((q) => q.entityId == entityId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<QuizModel>> getByLevel(String level) async {
    _checkException();
    return _quizzes.where((q) => q.level == level).toList();
  }

  @override
  Future<List<QuizModel>> getByLevelAndEntity(String level, String entityId) async {
    _checkException();
    return _quizzes.where((q) => q.level == level && q.entityId == entityId).toList();
  }

  @override
  Future<void> insert(QuizModel quiz) async {
    _checkException();
    _quizzes.add(quiz);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQuizSessionDao implements QuizSessionDao {
  final List<QuizSessionModel> _sessions = [];
  Exception? _nextException;

  void clear() {
    _sessions.clear();
    _nextException = null;
  }

  void setNextException(Exception e) {
    _nextException = e;
  }

  void _checkException() {
    if (_nextException != null) {
      final e = _nextException;
      _nextException = null;
      throw e!;
    }
  }

  @override
  Future<void> insert(QuizSessionModel session) async {
    _checkException();
    _sessions.add(session);
  }

  @override
  Future<QuizSessionModel?> getById(String id) async {
    _checkException();
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> update(QuizSessionModel session) async {
    _checkException();
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
    }
  }

  @override
  Future<void> delete(String id) async {
    _checkException();
    _sessions.removeWhere((s) => s.id == id);
  }

  @override
  Future<QuizSessionModel?> getActiveSession(String studentId) async {
    _checkException();
    try {
      return _sessions.firstWhere(
        (s) => s.studentId == studentId && s.state != 'completed',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQuizAttemptDao implements QuizAttemptDao {
  final List<QuizAttemptModel> _attempts = [];
  Exception? _nextException;

  void addAttempt(QuizAttemptModel attempt) {
    _attempts.add(attempt);
  }

  void clear() {
    _attempts.clear();
    _nextException = null;
  }

  void setNextException(Exception e) {
    _nextException = e;
  }

  void _checkException() {
    if (_nextException != null) {
      final e = _nextException;
      _nextException = null;
      throw e!;
    }
  }

  @override
  Future<void> insert(QuizAttemptModel attempt) async {
    _checkException();
    _attempts.add(attempt);
  }

  @override
  Future<List<QuizAttemptModel>> getFiltered({
    required String studentId,
    QuizFilters? filters,
    int? limit,
    int? offset,
  }) async {
    _checkException();
    var results = _attempts.where((a) => a.studentId == studentId).toList();
    if (offset != null && offset > 0) {
      results = results.skip(offset).toList();
    }
    if (limit != null) {
      results = results.take(limit).toList();
    }
    return results;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockQuizJsonDataSource implements QuizJsonDataSource {
  ({QuizModel quiz, List<QuestionModel> questions})? _quizData;
  Exception? _nextException;

  void setQuizData(({QuizModel quiz, List<QuestionModel> questions}) data) {
    _quizData = data;
  }

  void clear() {
    _quizData = null;
    _nextException = null;
  }

  void setNextException(Exception e) {
    _nextException = e;
  }

  void _checkException() {
    if (_nextException != null) {
      final e = _nextException;
      _nextException = null;
      throw e!;
    }
  }

  @override
  Future<({QuizModel quiz, List<QuestionModel> questions})> loadQuizByEntityId(String entityId) async {
    _checkException();
    if (_quizData != null) {
      return _quizData!;
    }
    throw Exception('Quiz not found');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
