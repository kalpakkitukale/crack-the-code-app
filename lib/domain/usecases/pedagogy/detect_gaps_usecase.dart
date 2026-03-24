/// DetectGapsUseCase - Detects concept gaps for a student
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/services/gap_analysis_service.dart';

/// Parameters for detect gaps use case
class DetectGapsParams {
  final String studentId;
  final String targetConceptId;

  const DetectGapsParams({
    required this.studentId,
    required this.targetConceptId,
  });
}

/// Use case for detecting concept gaps
class DetectGapsUseCase {
  final GapAnalysisService _service;

  const DetectGapsUseCase(this._service);

  Future<Either<Failure, List<ConceptGap>>> call(DetectGapsParams params) async {
    try {
      final gaps = await _service.detectGaps(
        studentId: params.studentId,
        targetConceptId: params.targetConceptId,
      );
      return Right(gaps);
    } catch (e) {
      return Left(GapAnalysisFailure(
        message: 'Failed to detect gaps: ${e.toString()}',
      ));
    }
  }
}

/// Failure specific to gap analysis
class GapAnalysisFailure extends Failure {
  const GapAnalysisFailure({required super.message});
}
