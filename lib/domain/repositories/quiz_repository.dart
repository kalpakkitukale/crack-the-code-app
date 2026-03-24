/// Quiz repository interface
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_filter.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_statistics.dart';
import 'package:crack_the_code/domain/entities/quiz/subject_statistics.dart';

/// Abstract repository for quiz operations
abstract class QuizRepository {
  /// Load a quiz with its questions by entity ID (e.g., video ID, topic ID)
  Future<Either<Failure, QuizSession>> loadQuiz({
    required String entityId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  });

  /// Load a quiz by quiz ID
  Future<Either<Failure, QuizSession>> loadQuizById({
    required String quizId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  });

  /// Resume an existing quiz session
  Future<Either<Failure, QuizSession>> resumeSession(String sessionId);

  /// Submit an answer for a question
  Future<Either<Failure, QuizSession>> submitAnswer({
    required String sessionId,
    required String questionId,
    required String answer,
    int? currentQuestionIndex,
  });

  /// Clear all answers from a quiz session
  /// This directly updates the session in the database without validation
  Future<Either<Failure, QuizSession>> clearAllAnswers(String sessionId);

  /// Complete the quiz and get results
  Future<Either<Failure, QuizResult>> completeQuiz(String sessionId);

  /// Pause the current quiz session
  Future<Either<Failure, QuizSession>> pauseSession(String sessionId);

  /// Get quiz attempt history for a student
  Future<Either<Failure, List<QuizAttempt>>> getAttemptHistory({
    required String studentId,
    String? entityId,
    int? limit,
  });

  /// Get the active session for a student (if any)
  Future<Either<Failure, QuizSession?>> getActiveSession(String studentId);

  /// Delete a quiz session
  Future<Either<Failure, void>> deleteSession(String sessionId);

  /// Get quiz by entity ID (without starting a session)
  Future<Either<Failure, Quiz?>> getQuizByEntityId(String entityId);

  /// Get quizzes by level
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevel(QuizLevel level);

  /// Get quizzes filtered by both level and entity ID
  ///
  /// Filters quizzes to return only those matching the specified level
  /// (chapter/topic/video/subject) and entity ID (the specific chapter/topic/video).
  /// This ensures topic quizzes are scoped to their parent chapter,
  /// and video quizzes are scoped to their parent topic.
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevelAndEntity(
    QuizLevel level,
    String entityId,
  );

  // ==================== PHASE 4: QUIZ HISTORY AND STATISTICS ====================

  /// Get filtered and sorted quiz history for a student
  ///
  /// Supports comprehensive filtering by subject, level, date range, performance,
  /// and sorting options. Includes pagination support via limit and offset.
  ///
  /// Returns [List<QuizAttempt>] with quiz attempt details including score,
  /// time taken, and pass/fail status.
  Future<Either<Failure, List<QuizAttempt>>> getQuizHistory({
    required String studentId,
    QuizFilters? filters,
    int? limit,
    int? offset,
  });

  /// Get comprehensive statistics for a student across all quizzes
  ///
  /// Aggregates performance data including:
  /// - Total attempts and average score
  /// - Current and longest streak
  /// - Subject-level breakdown
  /// - Weak and strong topics identification
  /// - Pass/fail rates
  ///
  /// Returns [QuizStatistics] with complete performance analysis.
  Future<Either<Failure, QuizStatistics>> getQuizStatistics(String studentId);

  /// Get detailed statistics for a specific subject
  ///
  /// Provides subject-specific performance metrics including:
  /// - Average, best, and worst scores
  /// - Pass/fail rates
  /// - Topic-level performance breakdown
  /// - Time investment analysis
  ///
  /// Returns [SubjectStatistics] for the specified subject.
  Future<Either<Failure, SubjectStatistics>> getSubjectStatistics(
    String studentId,
    String subjectId,
  );

  /// Get recent quiz attempts for a student
  ///
  /// Convenience method to fetch the most recent quizzes without filters.
  /// Ordered by completion date (newest first).
  ///
  /// [limit] defaults to 10 if not specified.
  ///
  /// Returns [List<QuizAttempt>] of recent quiz attempts.
  Future<Either<Failure, List<QuizAttempt>>> getRecentQuizzes(
    String studentId, {
    int limit = 10,
  });

  /// Get quiz streak data for calendar visualization
  ///
  /// Returns a map of dates to quiz counts for tracking daily activity.
  /// Used to calculate current streak and display activity calendars.
  ///
  /// Map key: DateTime (date only, time set to midnight)
  /// Map value: Number of quizzes completed on that date
  ///
  /// Returns [Map<DateTime, int>] with quiz counts by date.
  Future<Either<Failure, Map<DateTime, int>>> getQuizStreakData(
    String studentId,
  );

  /// Get score trend data over a specified number of days
  ///
  /// Provides historical score data for trend analysis and charts.
  /// Calculates daily average scores over the specified period.
  ///
  /// [days] specifies how many days of history to return.
  ///
  /// Map key: Date string in 'yyyy-MM-dd' format
  /// Map value: Average score percentage (0-100) for that day
  ///
  /// Returns [Map<String, double>] with daily average scores.
  Future<Either<Failure, Map<String, double>>> getScoreTrendData(
    String studentId, {
    required int days,
  });

  /// Get performance comparison across quiz levels
  ///
  /// Compares student performance across different quiz levels
  /// (video, topic, chapter, subject) to identify strengths and weaknesses.
  ///
  /// Map key: QuizLevel
  /// Map value: Average score percentage (0-100) for that level
  ///
  /// Returns [Map<QuizLevel, double>] with level-wise performance.
  Future<Either<Failure, Map<QuizLevel, double>>> getPerformanceByLevel(
    String studentId,
  );

  /// Get total count of quiz attempts matching filters
  ///
  /// Used for pagination and displaying total available results.
  /// More efficient than loading all attempts when only count is needed.
  ///
  /// Returns [int] count of matching quiz attempts.
  Future<Either<Failure, int>> getQuizHistoryCount({
    required String studentId,
    QuizFilters? filters,
  });
}
