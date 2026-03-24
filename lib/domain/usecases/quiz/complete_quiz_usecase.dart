/// Use case for completing a quiz and getting results
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/repositories/quiz_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Parameters for completing a quiz
class CompleteQuizParams {
  final String sessionId;

  const CompleteQuizParams({
    required this.sessionId,
  });
}

/// Complete a quiz session and generate comprehensive results
///
/// This evaluates all answers, calculates score, identifies weak/strong areas,
/// and generates personalized recommendations
class CompleteQuizUseCase
    implements BaseUseCase<QuizResult, CompleteQuizParams> {
  final QuizRepository repository;

  const CompleteQuizUseCase(this.repository);

  @override
  Future<Either<Failure, QuizResult>> call(CompleteQuizParams params) async {
    // Validate parameters
    if (params.sessionId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Session ID cannot be empty',
          fieldErrors: {'sessionId': 'Session ID cannot be empty'},
        ),
      );
    }

    // Complete the quiz through repository
    return await repository.completeQuiz(params.sessionId);
  }
}
