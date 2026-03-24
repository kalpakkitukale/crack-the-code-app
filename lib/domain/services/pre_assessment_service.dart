/// PreAssessmentService - Generates and processes pre-assessment questions
library;

import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/json/concept_json_data_source.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/concept_mastery_dao.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/entities/pedagogy/pre_assessment.dart';
import 'package:crack_the_code/domain/services/gap_analysis_service.dart';
import 'package:crack_the_code/domain/services/mastery_calculation_service.dart';

/// Service for generating adaptive pre-assessment questions
class PreAssessmentService {
  final ConceptJsonDataSource _conceptDataSource;
  final ConceptMasteryDao _masteryDao;
  final GapAnalysisService _gapService;
  final MasteryCalculationService _masteryService;

  PreAssessmentService({
    required ConceptJsonDataSource conceptDataSource,
    required ConceptMasteryDao masteryDao,
    required GapAnalysisService gapService,
    required MasteryCalculationService masteryService,
  })  : _conceptDataSource = conceptDataSource,
        _masteryDao = masteryDao,
        _gapService = gapService,
        _masteryService = masteryService;

  /// Generate adaptive assessment questions
  /// Phase 1: One question per previous grade (quick screening)
  /// Phase 2: Deep dive into weak grades based on Phase 1
  /// Phase 3: Find exact boundary of knowledge
  Future<List<String>> generateAssessmentQuestions({
    required String subjectName,
    required int targetGrade,
    required PreAssessmentPhase phase,
    Map<int, double>? phaseOneResults,
  }) async {
    switch (phase) {
      case PreAssessmentPhase.quickScreening:
        return await _getScreeningQuestions(subjectName, targetGrade);

      case PreAssessmentPhase.deepDive:
        if (phaseOneResults == null) {
          throw ArgumentError('Phase 1 results required for deep dive');
        }
        return await _getDeepDiveQuestions(subjectName, phaseOneResults);

      case PreAssessmentPhase.boundaryDetection:
        if (phaseOneResults == null) {
          throw ArgumentError('Phase 1 results required for boundary detection');
        }
        return await _getBoundaryQuestions(subjectName, phaseOneResults, targetGrade);
    }
  }

  /// Phase 1: Quick Screening - One question from each grade
  Future<List<String>> _getScreeningQuestions(
    String subjectName,
    int targetGrade,
  ) async {
    final questionIds = <String>[];
    final concepts = await _conceptDataSource.loadConcepts();

    // Get one question from each grade (1 to targetGrade-1)
    for (int grade = 1; grade < targetGrade; grade++) {
      final gradeConcepts = concepts
          .where((c) => c.subject == subjectName && c.gradeLevel == grade)
          .toList();

      if (gradeConcepts.isNotEmpty) {
        // Pick a foundational concept for this grade
        final concept = gradeConcepts.firstWhere(
          (c) => c.isFoundational,
          orElse: () => gradeConcepts.first,
        );

        if (concept.questionIds.isNotEmpty) {
          questionIds.add(concept.questionIds.first);
        }
      }
    }

    logger.debug(
      'Generated ${questionIds.length} screening questions for $subjectName',
    );
    return questionIds;
  }

  /// Phase 2: Deep Dive - Focus on grades where Phase 1 score < 70%
  Future<List<String>> _getDeepDiveQuestions(
    String subjectName,
    Map<int, double> phaseOneResults,
  ) async {
    final questionIds = <String>[];
    final concepts = await _conceptDataSource.loadConcepts();

    // Identify weak grades (score < 70%)
    final weakGrades = phaseOneResults.entries
        .where((e) => e.value < 70)
        .map((e) => e.key)
        .toList()
      ..sort();

    // Get 3-4 questions from each weak grade
    for (final grade in weakGrades) {
      final gradeConcepts = concepts
          .where((c) => c.subject == subjectName && c.gradeLevel == grade)
          .toList();

      for (final concept in gradeConcepts.take(4)) {
        if (concept.questionIds.isNotEmpty) {
          // Get 1-2 questions per concept
          questionIds.addAll(concept.questionIds.take(2));
        }
      }
    }

    logger.debug(
      'Generated ${questionIds.length} deep dive questions for grades: $weakGrades',
    );
    return questionIds;
  }

  /// Phase 3: Boundary Detection - Find exact knowledge frontier
  Future<List<String>> _getBoundaryQuestions(
    String subjectName,
    Map<int, double> results,
    int targetGrade,
  ) async {
    final questionIds = <String>[];
    final concepts = await _conceptDataSource.loadConcepts();

    // Find the boundary grade (last grade with score >= 60%)
    int boundaryGrade = 1;
    for (int grade = 1; grade < targetGrade; grade++) {
      if ((results[grade] ?? 0) >= 60) {
        boundaryGrade = grade;
      }
    }

    // Get questions from boundary grade and one above
    final targetGrades = [boundaryGrade, boundaryGrade + 1]
        .where((g) => g < targetGrade)
        .toList();

    for (final grade in targetGrades) {
      final gradeConcepts = concepts
          .where((c) => c.subject == subjectName && c.gradeLevel == grade)
          .toList();

      for (final concept in gradeConcepts) {
        // Get harder questions to test boundaries
        if (concept.questionIds.length > 1) {
          questionIds.add(concept.questionIds.last);
        } else if (concept.questionIds.isNotEmpty) {
          questionIds.add(concept.questionIds.first);
        }
      }
    }

    logger.debug(
      'Generated ${questionIds.length} boundary questions around grade $boundaryGrade',
    );
    return questionIds.take(10).toList();
  }

  /// Process assessment answers and calculate scores
  Future<Map<int, double>> processPhaseAnswers({
    required String subjectName,
    required Map<String, String> answers,
    required List<String> questionIds,
  }) async {
    // In a real implementation, we would check answers against correct answers
    // For now, we'll simulate scoring based on question IDs to grade mapping

    final concepts = await _conceptDataSource.loadConcepts();
    final gradeScores = <int, List<double>>{};

    for (final questionId in questionIds) {
      // Find which concept this question belongs to
      for (final concept in concepts) {
        if (concept.questionIds.contains(questionId) &&
            concept.subject == subjectName) {
          final grade = concept.gradeLevel;
          final isCorrect = answers.containsKey(questionId);
          // Simplified: treat having an answer as correct
          // Real implementation would validate against correct answers

          gradeScores.putIfAbsent(grade, () => []);
          gradeScores[grade]!.add(isCorrect ? 100.0 : 0.0);
          break;
        }
      }
    }

    // Calculate average per grade
    final result = <int, double>{};
    for (final entry in gradeScores.entries) {
      final scores = entry.value;
      result[entry.key] = scores.reduce((a, b) => a + b) / scores.length;
    }

    return result;
  }

  /// Generate final assessment result
  Future<PreAssessmentResult> generateResult({
    required String assessmentId,
    required String studentId,
    required String subjectId,
    required String subjectName,
    required int targetGrade,
    required Map<int, double> gradeScores,
  }) async {
    // Calculate overall readiness
    double totalWeight = 0;
    double weightedSum = 0;

    for (final entry in gradeScores.entries) {
      // Weight recent grades more heavily
      final weight = (targetGrade - entry.key).toDouble();
      totalWeight += weight;
      weightedSum += entry.value * weight;
    }

    final overallReadiness = totalWeight > 0 ? weightedSum / totalWeight : 0.0;

    // Get gaps using gap analysis service
    final analysis = await _gapService.analyzeSubjectReadiness(
      studentId: studentId,
      subjectId: subjectId,
      subjectName: subjectName,
      targetGrade: targetGrade,
    );

    // Calculate estimated fix time
    final estimatedFixMinutes = analysis.gaps.fold<int>(
      0,
      (sum, gap) => sum + gap.estimatedFixMinutes,
    );

    return PreAssessmentResult(
      assessmentId: assessmentId,
      overallReadiness: overallReadiness,
      gradeScores: gradeScores,
      identifiedGaps: analysis.gaps,
      estimatedFixMinutes: estimatedFixMinutes,
      recommendedPath: analysis.recommendedPath,
      generatedAt: DateTime.now(),
    );
  }

  /// Get total question count for all phases
  Future<int> getTotalQuestionCount({
    required String subjectName,
    required int targetGrade,
  }) async {
    // Phase 1: One question per grade
    final phase1Count = targetGrade - 1;

    // Phase 2: Estimate 15-20 questions (depends on weak areas)
    const phase2Estimate = 15;

    // Phase 3: 5-10 boundary questions
    const phase3Estimate = 7;

    return phase1Count + phase2Estimate + phase3Estimate;
  }
}
