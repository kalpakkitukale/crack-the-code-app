/// GenerateLearningPathUseCase - Generates personalized learning paths
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/domain/services/learning_path_generator.dart';

/// Parameters for generating foundation path
class GenerateFoundationPathParams {
  final String studentId;
  final String targetConceptId;
  final List<ConceptGap> gaps;
  final String? subjectId;

  const GenerateFoundationPathParams({
    required this.studentId,
    required this.targetConceptId,
    required this.gaps,
    this.subjectId,
  });
}

/// Parameters for generating path from analysis
class GeneratePathFromAnalysisParams {
  final String studentId;
  final String subjectId;
  final String subjectName;
  final int targetGrade;
  final List<ConceptGap> gaps;

  const GeneratePathFromAnalysisParams({
    required this.studentId,
    required this.subjectId,
    required this.subjectName,
    required this.targetGrade,
    required this.gaps,
  });
}

/// Use case for generating foundation learning paths
class GenerateFoundationPathUseCase {
  final LearningPathGenerator _generator;

  const GenerateFoundationPathUseCase(this._generator);

  Future<Either<Failure, LearningPath>> call(
    GenerateFoundationPathParams params,
  ) async {
    try {
      final path = await _generator.generateFoundationPath(
        studentId: params.studentId,
        targetConceptId: params.targetConceptId,
        gaps: params.gaps,
        subjectId: params.subjectId,
      );
      return Right(path);
    } catch (e) {
      return Left(PathGenerationFailure(
        message: 'Failed to generate foundation path: ${e.toString()}',
      ));
    }
  }
}

/// Use case for generating paths from gap analysis
class GeneratePathFromAnalysisUseCase {
  final LearningPathGenerator _generator;

  const GeneratePathFromAnalysisUseCase(this._generator);

  Future<Either<Failure, LearningPath>> call(
    GeneratePathFromAnalysisParams params,
  ) async {
    try {
      final path = await _generator.generatePathFromAnalysis(
        studentId: params.studentId,
        subjectId: params.subjectId,
        subjectName: params.subjectName,
        targetGrade: params.targetGrade,
        gaps: params.gaps,
      );
      return Right(path);
    } catch (e) {
      return Left(PathGenerationFailure(
        message: 'Failed to generate learning path: ${e.toString()}',
      ));
    }
  }
}

/// Failure specific to path generation
class PathGenerationFailure extends Failure {
  const PathGenerationFailure({required super.message});
}
