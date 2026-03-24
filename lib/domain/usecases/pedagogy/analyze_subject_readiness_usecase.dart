/// AnalyzeSubjectReadinessUseCase - Analyzes student readiness for a subject
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/pedagogy/subject_gap_analysis.dart';
import 'package:crack_the_code/domain/services/gap_analysis_service.dart';

/// Parameters for analyze subject readiness use case
class AnalyzeSubjectReadinessParams {
  final String studentId;
  final String subjectId;
  final String subjectName;
  final int targetGrade;

  const AnalyzeSubjectReadinessParams({
    required this.studentId,
    required this.subjectId,
    required this.subjectName,
    required this.targetGrade,
  });
}

/// Use case for analyzing subject readiness
class AnalyzeSubjectReadinessUseCase {
  final GapAnalysisService _service;

  const AnalyzeSubjectReadinessUseCase(this._service);

  Future<Either<Failure, SubjectGapAnalysis>> call(
    AnalyzeSubjectReadinessParams params,
  ) async {
    try {
      final analysis = await _service.analyzeSubjectReadiness(
        studentId: params.studentId,
        subjectId: params.subjectId,
        subjectName: params.subjectName,
        targetGrade: params.targetGrade,
      );
      return Right(analysis);
    } catch (e) {
      return Left(SubjectAnalysisFailure(
        message: 'Failed to analyze subject readiness: ${e.toString()}',
      ));
    }
  }
}

/// Failure specific to subject analysis
class SubjectAnalysisFailure extends Failure {
  const SubjectAnalysisFailure({required super.message});
}
