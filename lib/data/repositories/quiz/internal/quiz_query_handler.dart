/// Handler for quiz query operations
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_dao.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';

/// Handles quiz query operations (getQuizByEntityId, getQuizzesByLevel, etc.)
class QuizQueryHandler {
  final QuizDao _quizDao;

  QuizQueryHandler({required QuizDao quizDao}) : _quizDao = quizDao;

  /// Get a quiz by its entity ID
  Future<Either<Failure, Quiz?>> getQuizByEntityId(String entityId) async {
    try {
      logger.debug('Getting quiz by entity ID: $entityId');

      final quizModel = await _quizDao.getByEntityId(entityId);

      if (quizModel == null) {
        return const Right(null);
      }

      return Right(quizModel.toEntity());
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting quiz', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get quiz',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting quiz', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Get all quizzes for a specific level
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevel(QuizLevel level) async {
    try {
      logger.debug('Getting quizzes by level: $level');

      final levelString = level.toString().split('.').last;
      final quizModels = await _quizDao.getByLevel(levelString);

      final quizzes = quizModels.map((m) => m.toEntity()).toList();

      logger.debug('Retrieved ${quizzes.length} quizzes for level: $level');
      return Right(quizzes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting quizzes by level', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get quizzes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting quizzes by level', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Get quizzes for a specific level and entity
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevelAndEntity(
    QuizLevel level,
    String entityId,
  ) async {
    try {
      logger.debug(
        'Getting quizzes by level: $level and entityId: $entityId',
      );

      final levelString = level.toString().split('.').last;
      final quizModels = await _quizDao.getByLevelAndEntity(
        levelString,
        entityId,
      );

      final quizzes = quizModels.map((m) => m.toEntity()).toList();

      logger.debug(
        'Retrieved ${quizzes.length} quizzes for level: $level and entityId: $entityId',
      );
      return Right(quizzes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error(
        'Database error getting quizzes by level and entity',
        e,
        stackTrace,
      );
      return Left(DatabaseFailure(
        message: 'Failed to get quizzes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error(
        'Unknown error getting quizzes by level and entity',
        e,
        stackTrace,
      );
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
