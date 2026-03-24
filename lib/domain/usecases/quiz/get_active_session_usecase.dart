/// Use case for getting the active quiz session for a student
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/domain/repositories/quiz_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Parameters for getting active session
class GetActiveSessionParams {
  final String studentId;

  const GetActiveSessionParams({
    required this.studentId,
  });
}

/// Get the currently active quiz session for a student
///
/// Returns null if no active session exists.
/// An active session is one that is in progress or paused.
class GetActiveSessionUseCase
    implements BaseUseCase<QuizSession?, GetActiveSessionParams> {
  final QuizRepository repository;

  const GetActiveSessionUseCase(this.repository);

  @override
  Future<Either<Failure, QuizSession?>> call(
    GetActiveSessionParams params,
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

    // Get active session through repository
    return await repository.getActiveSession(params.studentId);
  }
}
