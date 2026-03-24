/// Use case for retrieving quiz attempt history
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/repositories/quiz_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Parameters for getting quiz history
class GetQuizHistoryParams {
  final String studentId;
  final String? entityId; // Optional: filter by specific entity
  final int? limit; // Optional: limit number of results

  const GetQuizHistoryParams({
    required this.studentId,
    this.entityId,
    this.limit,
  });
}

/// Get quiz attempt history for a student
///
/// This retrieves all past quiz attempts, optionally filtered by entity
/// and limited to a specific number of results
class GetQuizHistoryUseCase
    implements BaseUseCase<List<QuizAttempt>, GetQuizHistoryParams> {
  final QuizRepository repository;

  const GetQuizHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<QuizAttempt>>> call(
    GetQuizHistoryParams params,
  ) async {
    // Validate parameters
    if (params.studentId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Student ID cannot be empty',
          fieldErrors: {'studentId': 'Student ID cannot be empty'},
        ),
      );
    }

    // Validate limit if provided
    if (params.limit != null && params.limit! <= 0) {
      return Left(
        ValidationFailure(
          message: 'Limit must be greater than 0',
          fieldErrors: {'limit': 'Limit must be greater than 0'},
        ),
      );
    }

    // Get history through repository
    return await repository.getAttemptHistory(
      studentId: params.studentId,
      entityId: params.entityId,
      limit: params.limit,
    );
  }
}
