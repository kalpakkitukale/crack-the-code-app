/// Handler for quiz history and attempt operations
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:crack_the_code/data/services/quiz_history_filter.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_filter.dart';

/// Handles quiz history operations (getAttemptHistory, getQuizHistory, etc.)
class QuizHistoryHandler {
  final QuizAttemptDao _attemptDao;
  final QuizHistoryFilter _historyFilter;

  /// Optional profile ID for multi-profile support
  String? profileId;

  QuizHistoryHandler({
    required QuizAttemptDao attemptDao,
    QuizHistoryFilter? historyFilter,
  })  : _attemptDao = attemptDao,
        _historyFilter = historyFilter ?? QuizHistoryFilter();

  /// Get quiz attempt history for a student
  Future<Either<Failure, List<QuizAttempt>>> getAttemptHistory({
    required String studentId,
    String? entityId,
    int? limit,
  }) async {
    try {
      // Use profileId if set, otherwise fall back to provided studentId
      final effectiveStudentId = profileId ?? studentId;
      logger.info(
          'Getting attempt history for student: $effectiveStudentId from quiz_attempts table');

      // Get quiz attempts directly from quiz_attempts table
      final attemptModels = await _attemptDao.getFiltered(
        studentId: effectiveStudentId,
        limit: limit,
      );

      // Convert models to entities
      final attempts = <QuizAttempt>[];
      for (final model in attemptModels) {
        // If entityId filter is specified, check subject_id field
        if (entityId != null && model.subjectId != entityId) {
          continue;
        }

        attempts.add(model.toEntity());
      }

      logger.info(
          'Retrieved ${attempts.length} quiz attempts from quiz_attempts table');
      return Right(attempts);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting attempt history', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get quiz history',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting attempt history', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Get filtered quiz history for a student
  Future<Either<Failure, List<QuizAttempt>>> getQuizHistory({
    required String studentId,
    QuizFilters? filters,
    int? limit,
    int? offset,
  }) async {
    try {
      logger.info('Getting quiz history for student: $studentId with filters');

      // Get base attempt history
      final baseResult = await getAttemptHistory(studentId: studentId);

      return baseResult.fold(
        (failure) => Left(failure),
        (attempts) {
          final filteredAttempts = _historyFilter.applyFilters(
            attempts: attempts,
            filters: filters,
            limit: limit,
            offset: offset,
          );

          logger.info(
              'Retrieved ${filteredAttempts.length} filtered quiz attempts');
          return Right(filteredAttempts);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Error getting quiz history', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get quiz history',
        details: e.toString(),
      ));
    }
  }

  /// Get recent quizzes for a student
  Future<Either<Failure, List<QuizAttempt>>> getRecentQuizzes(
    String studentId, {
    int limit = 10,
  }) async {
    try {
      logger.debug('Getting recent quizzes for student: $studentId');

      final result = await getAttemptHistory(studentId: studentId);

      return result.fold(
        (failure) => Left(failure),
        (attempts) => Right(_historyFilter.getRecentQuizzes(
          attempts: attempts,
          limit: limit,
        )),
      );
    } catch (e, stackTrace) {
      logger.error('Error getting recent quizzes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get recent quizzes',
        details: e.toString(),
      ));
    }
  }

  /// Get the count of quiz history entries
  Future<Either<Failure, int>> getQuizHistoryCount({
    required String studentId,
    QuizFilters? filters,
  }) async {
    try {
      logger.debug('Getting quiz history count for student: $studentId');

      final result = await getQuizHistory(
        studentId: studentId,
        filters: filters,
      );

      return result.fold(
        (failure) => Left(failure),
        (attempts) => Right(attempts.length),
      );
    } catch (e, stackTrace) {
      logger.error('Error getting quiz history count', e, stackTrace);
      return Left(UnknownFailure(
        message: 'Failed to get quiz history count',
        details: e.toString(),
      ));
    }
  }
}
