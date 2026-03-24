/// Use case for loading a quiz by entity ID
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/domain/repositories/quiz_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Parameters for loading a quiz
class LoadQuizParams {
  final String entityId;
  final String studentId;
  final AssessmentType assessmentType;

  const LoadQuizParams({
    required this.entityId,
    required this.studentId,
    this.assessmentType = AssessmentType.practice,
  });
}

/// Load a quiz for a specific content entity (video, topic, etc.)
class LoadQuizUseCase implements BaseUseCase<QuizSession, LoadQuizParams> {
  final QuizRepository repository;

  const LoadQuizUseCase(this.repository);

  @override
  Future<Either<Failure, QuizSession>> call(LoadQuizParams params) async {
    // Validate parameters
    if (params.entityId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Entity ID cannot be empty',
          fieldErrors: {'entityId': 'Entity ID cannot be empty'},
        ),
      );
    }

    if (params.studentId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Student ID cannot be empty',
          fieldErrors: {'studentId': 'Student ID cannot be empty'},
        ),
      );
    }

    // Load the quiz through repository
    return await repository.loadQuiz(
      entityId: params.entityId,
      studentId: params.studentId,
      assessmentType: params.assessmentType,
    );
  }
}
