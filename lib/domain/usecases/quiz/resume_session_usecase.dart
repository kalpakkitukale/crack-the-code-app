/// Use case for resuming a paused quiz session
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/domain/repositories/quiz_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Parameters for resuming a quiz session
class ResumeSessionParams {
  final String sessionId;

  const ResumeSessionParams({
    required this.sessionId,
  });
}

/// Resume a paused or in-progress quiz session
///
/// This restores the quiz state from the database, allowing the student
/// to continue from where they left off
class ResumeSessionUseCase
    implements BaseUseCase<QuizSession, ResumeSessionParams> {
  final QuizRepository repository;

  const ResumeSessionUseCase(this.repository);

  @override
  Future<Either<Failure, QuizSession>> call(ResumeSessionParams params) async {
    // Validate parameters
    if (params.sessionId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Session ID cannot be empty',
          fieldErrors: {'sessionId': 'Session ID cannot be empty'},
        ),
      );
    }

    // Resume the session through repository
    return await repository.resumeSession(params.sessionId);
  }
}
