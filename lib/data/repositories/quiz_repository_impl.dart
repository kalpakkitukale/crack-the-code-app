/// Quiz repository implementation using facade pattern
///
/// This implementation delegates to specialized internal handlers for different
/// concerns while maintaining a single public interface. The handlers are:
/// - QuizSessionHandler: Session lifecycle (load, submit, complete)
/// - QuizQueryHandler: Quiz queries (getByEntityId, getByLevel)
/// - QuizHistoryHandler: Attempt history and filtering
/// - QuizStatisticsHandler: Statistics calculations
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/data/datasources/json/quiz_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/question_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_session_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:streamshaala/data/repositories/quiz/internal/quiz_internal.dart';
import 'package:streamshaala/data/services/quiz_history_filter.dart';
import 'package:streamshaala/data/services/quiz_statistics_calculator.dart';
import 'package:streamshaala/domain/entities/quiz/quiz.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_filter.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_statistics.dart';
import 'package:streamshaala/domain/entities/quiz/subject_statistics.dart';
import 'package:streamshaala/domain/repositories/quiz_repository.dart';

/// Implementation of QuizRepository using facade pattern
///
/// Delegates to specialized internal handlers for different concerns.
/// Total code reduced from ~1669 lines to ~350 lines through separation
/// of concerns.
class QuizRepositoryImpl implements QuizRepository {
  final QuizSessionHandler _sessionHandler;
  final QuizQueryHandler _queryHandler;
  final QuizHistoryHandler _historyHandler;
  final QuizStatisticsHandler _statisticsHandler;

  /// Optional profile ID for multi-profile support
  /// When set, all quiz sessions and attempts are scoped to this profile
  String? _profileId;

  set profileId(String? value) {
    _profileId = value;
    _sessionHandler.profileId = value;
    _historyHandler.profileId = value;
  }

  String? get profileId => _profileId;

  /// Create a QuizRepositoryImpl with all required dependencies
  QuizRepositoryImpl({
    required QuestionDao questionDao,
    required QuizDao quizDao,
    required QuizSessionDao quizSessionDao,
    required QuizAttemptDao quizAttemptDao,
    required QuizJsonDataSource jsonDataSource,
    QuizStatisticsCalculator? statisticsCalculator,
    QuizHistoryFilter? historyFilter,
  })  : _sessionHandler = QuizSessionHandler(
          questionDao: questionDao,
          quizDao: quizDao,
          sessionDao: quizSessionDao,
          attemptDao: quizAttemptDao,
          jsonDataSource: jsonDataSource,
        ),
        _queryHandler = QuizQueryHandler(quizDao: quizDao),
        _historyHandler = QuizHistoryHandler(
          attemptDao: quizAttemptDao,
          historyFilter: historyFilter,
        ),
        _statisticsHandler = QuizStatisticsHandler(
          quizDao: quizDao,
          statisticsCalculator: statisticsCalculator,
          getAttemptHistory: ({
            required String studentId,
            String? entityId,
            int? limit,
          }) =>
              QuizRepositoryImpl._getAttemptHistoryStatic(
            quizAttemptDao,
            historyFilter,
            studentId,
            entityId,
            limit,
          ),
        );

  /// Static method for statistics handler to use
  static Future<Either<Failure, List<QuizAttempt>>> _getAttemptHistoryStatic(
    QuizAttemptDao attemptDao,
    QuizHistoryFilter? historyFilter,
    String studentId,
    String? entityId,
    int? limit,
  ) async {
    final handler = QuizHistoryHandler(
      attemptDao: attemptDao,
      historyFilter: historyFilter,
    );
    return handler.getAttemptHistory(
      studentId: studentId,
      entityId: entityId,
      limit: limit,
    );
  }

  /// Process any pending quiz attempts from the retry queue
  /// Call this on app startup or when connectivity is restored
  Future<int> processRetryQueue() async {
    return _sessionHandler.processRetryQueue();
  }

  // ==================== SESSION OPERATIONS ====================

  @override
  Future<Either<Failure, QuizSession>> loadQuiz({
    required String entityId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  }) {
    return _sessionHandler.loadQuiz(
      entityId: entityId,
      studentId: studentId,
      assessmentType: assessmentType,
      getActiveSession: getActiveSession,
      deleteSession: deleteSession,
    );
  }

  @override
  Future<Either<Failure, QuizSession>> loadQuizById({
    required String quizId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  }) {
    return _sessionHandler.loadQuizById(
      quizId: quizId,
      studentId: studentId,
      assessmentType: assessmentType,
    );
  }

  @override
  Future<Either<Failure, QuizSession>> resumeSession(String sessionId) {
    return _sessionHandler.resumeSession(sessionId);
  }

  @override
  Future<Either<Failure, QuizSession>> submitAnswer({
    required String sessionId,
    required String questionId,
    required String answer,
    int? currentQuestionIndex,
  }) {
    return _sessionHandler.submitAnswer(
      sessionId: sessionId,
      questionId: questionId,
      answer: answer,
      currentQuestionIndex: currentQuestionIndex,
    );
  }

  @override
  Future<Either<Failure, QuizSession>> clearAllAnswers(String sessionId) {
    return _sessionHandler.clearAllAnswers(sessionId);
  }

  @override
  Future<Either<Failure, QuizResult>> completeQuiz(String sessionId) {
    return _sessionHandler.completeQuiz(sessionId);
  }

  @override
  Future<Either<Failure, QuizSession>> pauseSession(String sessionId) {
    return _sessionHandler.pauseSession(sessionId);
  }

  @override
  Future<Either<Failure, QuizSession?>> getActiveSession(String studentId) {
    return _sessionHandler.getActiveSession(studentId);
  }

  @override
  Future<Either<Failure, void>> deleteSession(String sessionId) {
    return _sessionHandler.deleteSession(sessionId);
  }

  // ==================== QUIZ QUERIES ====================

  @override
  Future<Either<Failure, Quiz?>> getQuizByEntityId(String entityId) {
    return _queryHandler.getQuizByEntityId(entityId);
  }

  @override
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevel(QuizLevel level) {
    return _queryHandler.getQuizzesByLevel(level);
  }

  @override
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevelAndEntity(
    QuizLevel level,
    String entityId,
  ) {
    return _queryHandler.getQuizzesByLevelAndEntity(level, entityId);
  }

  // ==================== HISTORY OPERATIONS ====================

  @override
  Future<Either<Failure, List<QuizAttempt>>> getAttemptHistory({
    required String studentId,
    String? entityId,
    int? limit,
  }) {
    return _historyHandler.getAttemptHistory(
      studentId: studentId,
      entityId: entityId,
      limit: limit,
    );
  }

  @override
  Future<Either<Failure, List<QuizAttempt>>> getQuizHistory({
    required String studentId,
    QuizFilters? filters,
    int? limit,
    int? offset,
  }) {
    return _historyHandler.getQuizHistory(
      studentId: studentId,
      filters: filters,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Either<Failure, List<QuizAttempt>>> getRecentQuizzes(
    String studentId, {
    int limit = 10,
  }) {
    return _historyHandler.getRecentQuizzes(studentId, limit: limit);
  }

  @override
  Future<Either<Failure, int>> getQuizHistoryCount({
    required String studentId,
    QuizFilters? filters,
  }) {
    return _historyHandler.getQuizHistoryCount(
      studentId: studentId,
      filters: filters,
    );
  }

  // ==================== STATISTICS OPERATIONS ====================

  @override
  Future<Either<Failure, QuizStatistics>> getQuizStatistics(String studentId) {
    return _statisticsHandler.getQuizStatistics(studentId);
  }

  @override
  Future<Either<Failure, SubjectStatistics>> getSubjectStatistics(
    String studentId,
    String subjectId,
  ) {
    return _statisticsHandler.getSubjectStatistics(studentId, subjectId);
  }

  @override
  Future<Either<Failure, Map<DateTime, int>>> getQuizStreakData(
    String studentId,
  ) {
    return _statisticsHandler.getQuizStreakData(studentId);
  }

  @override
  Future<Either<Failure, Map<String, double>>> getScoreTrendData(
    String studentId, {
    required int days,
  }) {
    return _statisticsHandler.getScoreTrendData(studentId, days: days);
  }

  @override
  Future<Either<Failure, Map<QuizLevel, double>>> getPerformanceByLevel(
    String studentId,
  ) {
    return _statisticsHandler.getPerformanceByLevel(studentId);
  }
}
