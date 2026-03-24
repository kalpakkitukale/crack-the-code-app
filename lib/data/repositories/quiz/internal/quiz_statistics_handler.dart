/// Handler for quiz statistics operations
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_dao.dart';
import 'package:crack_the_code/data/services/quiz_statistics_calculator.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_statistics.dart';
import 'package:crack_the_code/domain/entities/quiz/subject_statistics.dart';

/// Handler function type for getting attempt history
typedef GetAttemptHistoryFn = Future<Either<Failure, List<QuizAttempt>>>
    Function({
  required String studentId,
  String? entityId,
  int? limit,
});

/// Handles quiz statistics operations
class QuizStatisticsHandler {
  final QuizDao _quizDao;
  final QuizStatisticsCalculator _statisticsCalculator;
  final GetAttemptHistoryFn _getAttemptHistory;

  QuizStatisticsHandler({
    required QuizDao quizDao,
    required GetAttemptHistoryFn getAttemptHistory,
    QuizStatisticsCalculator? statisticsCalculator,
  })  : _quizDao = quizDao,
        _getAttemptHistory = getAttemptHistory,
        _statisticsCalculator =
            statisticsCalculator ?? QuizStatisticsCalculator();

  /// Get overall quiz statistics for a student
  Future<Either<Failure, QuizStatistics>> getQuizStatistics(
      String studentId) async {
    try {
      logger.info('Getting quiz statistics for student: $studentId');

      // Get all quiz attempts
      final attemptsResult = await _getAttemptHistory(studentId: studentId);

      return attemptsResult.fold(
        (failure) => Left(failure),
        (attempts) {
          // Build streak data and calculate statistics
          final streakData = _statisticsCalculator.buildStreakMap(attempts);
          final statistics = _statisticsCalculator.calculateQuizStatistics(
            attempts: attempts,
            streakData: streakData,
          );
          return Right(statistics);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Error getting quiz statistics', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get quiz statistics',
        details: e.toString(),
      ));
    }
  }

  /// Get statistics for a specific subject
  Future<Either<Failure, SubjectStatistics>> getSubjectStatistics(
    String studentId,
    String subjectId,
  ) async {
    try {
      logger.info(
          'Getting subject statistics for student: $studentId, subject: $subjectId');

      // Get all attempts for this subject
      final attemptsResult = await _getAttemptHistory(
        studentId: studentId,
        entityId: subjectId,
      );

      return attemptsResult.fold(
        (failure) => Left(failure),
        (attempts) {
          final statistics = _statisticsCalculator.calculateSubjectStatistics(
            subjectId: subjectId,
            attempts: attempts,
          );
          return Right(statistics);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Error getting subject statistics', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get subject statistics',
        details: e.toString(),
      ));
    }
  }

  /// Get quiz streak data for calendar display
  Future<Either<Failure, Map<DateTime, int>>> getQuizStreakData(
    String studentId,
  ) async {
    try {
      logger.debug('Getting quiz streak data for student: $studentId');

      final result = await _getAttemptHistory(studentId: studentId);

      return result.fold(
        (failure) => Left(failure),
        (attempts) => Right(_statisticsCalculator.buildStreakMap(attempts)),
      );
    } catch (e, stackTrace) {
      logger.error('Error getting quiz streak data', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get quiz streak data',
        details: e.toString(),
      ));
    }
  }

  /// Get score trend data over time
  Future<Either<Failure, Map<String, double>>> getScoreTrendData(
    String studentId, {
    required int days,
  }) async {
    try {
      logger.debug(
          'Getting score trend data for student: $studentId, days: $days');

      final result = await _getAttemptHistory(studentId: studentId);

      return result.fold(
        (failure) => Left(failure),
        (attempts) => Right(_statisticsCalculator.calculateScoreTrend(
          attempts: attempts,
          days: days,
        )),
      );
    } catch (e, stackTrace) {
      logger.error('Error getting score trend data', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get score trend data',
        details: e.toString(),
      ));
    }
  }

  /// Get performance breakdown by quiz level
  Future<Either<Failure, Map<QuizLevel, double>>> getPerformanceByLevel(
    String studentId,
  ) async {
    try {
      logger.debug('Getting performance by level for student: $studentId');

      final result = await _getAttemptHistory(studentId: studentId);

      return result.fold(
        (failure) => Left(failure),
        (attempts) async {
          // Build quiz cache for performance calculation
          final quizCache = <String, Quiz>{};
          for (final attempt in attempts) {
            if (!quizCache.containsKey(attempt.quizId)) {
              final quizModel = await _quizDao.getById(attempt.quizId);
              if (quizModel != null) {
                quizCache[attempt.quizId] = quizModel.toEntity();
              }
            }
          }

          final performanceMap =
              _statisticsCalculator.calculatePerformanceByLevel(
            attempts: attempts,
            quizCache: quizCache,
          );
          return Right(performanceMap);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Error getting performance by level', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get performance by level',
        details: e.toString(),
      ));
    }
  }
}
