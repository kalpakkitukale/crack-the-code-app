/// Use case for submitting an answer to a quiz question
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/domain/repositories/quiz_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Parameters for submitting an answer
class SubmitAnswerParams {
  final String sessionId;
  final String questionId;
  final String answer;
  final int? currentQuestionIndex;

  const SubmitAnswerParams({
    required this.sessionId,
    required this.questionId,
    required this.answer,
    this.currentQuestionIndex,
  });
}

/// Submit an answer for a quiz question
///
/// This updates the quiz session with the student's answer
/// and returns the updated session state
class SubmitAnswerUseCase
    implements BaseUseCase<QuizSession, SubmitAnswerParams> {
  final QuizRepository repository;

  const SubmitAnswerUseCase(this.repository);

  @override
  Future<Either<Failure, QuizSession>> call(SubmitAnswerParams params) async {
    // Validate parameters
    if (params.sessionId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Session ID cannot be empty',
          fieldErrors: {'sessionId': 'Session ID cannot be empty'},
        ),
      );
    }

    if (params.questionId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Question ID cannot be empty',
          fieldErrors: {'questionId': 'Question ID cannot be empty'},
        ),
      );
    }

    if (params.answer.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Answer cannot be empty',
          fieldErrors: {'answer': 'Answer cannot be empty'},
        ),
      );
    }

    // Submit the answer through repository
    return await repository.submitAnswer(
      sessionId: params.sessionId,
      questionId: params.questionId,
      answer: params.answer,
      currentQuestionIndex: params.currentQuestionIndex,
    );
  }
}
