/// Pre-Assessment state management provider
///
/// Manages subject-level diagnostic assessment for gap detection
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';
import 'package:streamshaala/domain/entities/pedagogy/pre_assessment.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/domain/services/gap_analysis_service.dart';
import 'package:streamshaala/domain/services/learning_path_generator.dart';
import 'package:streamshaala/domain/services/pre_assessment_service.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// Pre-Assessment state
class PreAssessmentState {
  final PreAssessment? activeAssessment;
  final PreAssessmentResult? result;
  final LearningPath? recommendedPath;
  final List<ConceptGap> identifiedGaps;
  final bool isLoading;
  final String? error;

  const PreAssessmentState({
    this.activeAssessment,
    this.result,
    this.recommendedPath,
    this.identifiedGaps = const [],
    this.isLoading = false,
    this.error,
  });

  factory PreAssessmentState.initial() => const PreAssessmentState();

  PreAssessmentState copyWith({
    PreAssessment? activeAssessment,
    PreAssessmentResult? result,
    LearningPath? recommendedPath,
    List<ConceptGap>? identifiedGaps,
    bool? isLoading,
    String? error,
    bool clearAssessment = false,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return PreAssessmentState(
      activeAssessment: clearAssessment ? null : activeAssessment ?? this.activeAssessment,
      result: clearResult ? null : result ?? this.result,
      recommendedPath: recommendedPath ?? this.recommendedPath,
      identifiedGaps: identifiedGaps ?? this.identifiedGaps,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Check if there's an active assessment
  bool get hasActiveAssessment => activeAssessment != null;

  /// Get current phase
  PreAssessmentPhase? get currentPhase => activeAssessment?.currentPhase;

  /// Get progress percentage
  double get progressPercentage {
    if (activeAssessment == null) return 0.0;
    final total = activeAssessment!.questionIds.length;
    if (total == 0) return 0.0;
    return (activeAssessment!.currentQuestionIndex / total) * 100;
  }

  /// Check if assessment is complete
  bool get isComplete => result != null;
}

/// Pre-Assessment state notifier
class PreAssessmentNotifier extends StateNotifier<PreAssessmentState> {
  final PreAssessmentService _preAssessmentService;
  final GapAnalysisService _gapAnalysisService;
  final LearningPathGenerator _learningPathGenerator;

  PreAssessmentNotifier({
    required PreAssessmentService preAssessmentService,
    required GapAnalysisService gapAnalysisService,
    required LearningPathGenerator learningPathGenerator,
  })  : _preAssessmentService = preAssessmentService,
        _gapAnalysisService = gapAnalysisService,
        _learningPathGenerator = learningPathGenerator,
        super(PreAssessmentState.initial());

  /// Start a new pre-assessment for a subject
  Future<void> startAssessment({
    required String studentId,
    required String subjectId,
    required String subjectName,
    required int targetGrade,
  }) async {
    try {
      logger.info('Starting pre-assessment for $subjectId grade $targetGrade');
      state = state.copyWith(isLoading: true, clearError: true, clearAssessment: true);

      // Generate screening questions (Phase 1)
      final questionIds = await _preAssessmentService.generateAssessmentQuestions(
        subjectName: subjectName,
        targetGrade: targetGrade,
        phase: PreAssessmentPhase.quickScreening,
      );

      if (questionIds.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'No assessment questions available for this subject',
        );
        return;
      }

      final assessment = PreAssessment(
        id: 'pre_assessment_${studentId}_${subjectId}_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        subjectId: subjectId,
        targetGrade: targetGrade,
        currentPhase: PreAssessmentPhase.quickScreening,
        questionIds: questionIds,
        answers: {},
        currentQuestionIndex: 0,
        startedAt: DateTime.now(),
      );

      state = state.copyWith(
        activeAssessment: assessment,
        isLoading: false,
        clearError: true,
      );

      logger.info('Pre-assessment started with ${questionIds.length} questions');
    } catch (e, stackTrace) {
      logger.error('Failed to start pre-assessment', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to start assessment: $e',
      );
    }
  }

  /// Submit answer for current question
  Future<void> submitAnswer({
    required String questionId,
    required String answer,
  }) async {
    if (state.activeAssessment == null) {
      logger.warning('Cannot submit answer: No active assessment');
      return;
    }

    try {
      final currentAssessment = state.activeAssessment!;
      final updatedAnswers = Map<String, String>.from(currentAssessment.answers);
      updatedAnswers[questionId] = answer;

      final newIndex = currentAssessment.currentQuestionIndex + 1;
      final isPhaseComplete = newIndex >= currentAssessment.questionIds.length;

      if (isPhaseComplete) {
        await _handlePhaseCompletion(updatedAnswers);
      } else {
        final updatedAssessment = currentAssessment.copyWith(
          answers: updatedAnswers,
          currentQuestionIndex: newIndex,
        );
        state = state.copyWith(activeAssessment: updatedAssessment);
      }

      logger.debug('Answer submitted for $questionId');
    } catch (e, stackTrace) {
      logger.error('Failed to submit answer', e, stackTrace);
      state = state.copyWith(error: 'Failed to submit answer: $e');
    }
  }

  /// Handle phase completion and transition
  Future<void> _handlePhaseCompletion(Map<String, String> answers) async {
    final currentAssessment = state.activeAssessment!;

    try {
      state = state.copyWith(isLoading: true);

      // Analyze phase results - calculate grade scores from answers
      final phaseResults = _analyzePhaseResults(answers, currentAssessment);

      switch (currentAssessment.currentPhase) {
        case PreAssessmentPhase.quickScreening:
          // Check if we need deep dive
          if (_needsDeepDive(phaseResults)) {
            await _moveToDeepDive(currentAssessment, answers, phaseResults);
          } else {
            await _completeAssessment(answers, phaseResults);
          }

        case PreAssessmentPhase.deepDive:
          // Move to boundary detection if needed
          if (_needsBoundaryDetection(phaseResults)) {
            await _moveToBoundaryDetection(currentAssessment, answers, phaseResults);
          } else {
            await _completeAssessment(answers, phaseResults);
          }

        case PreAssessmentPhase.boundaryDetection:
          await _completeAssessment(answers, phaseResults);
      }
    } catch (e, stackTrace) {
      logger.error('Failed to handle phase completion', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to process assessment: $e',
      );
    }
  }

  /// Analyze phase results and return grade scores
  Map<int, double> _analyzePhaseResults(Map<String, String> answers, PreAssessment assessment) {
    // For now, return mock scores based on answer count
    // In a real implementation, this would compare answers to correct answers
    final totalQuestions = assessment.questionIds.length;
    final answeredQuestions = answers.length;
    final mockScore = (answeredQuestions / totalQuestions) * 100;

    // Return scores for each grade level up to target - 1
    final gradeScores = <int, double>{};
    for (int grade = 1; grade < assessment.targetGrade; grade++) {
      gradeScores[grade] = mockScore;
    }
    return gradeScores;
  }

  /// Check if deep dive phase is needed
  bool _needsDeepDive(Map<int, double> gradeScores) {
    // If any grade scored below 70%, need deeper assessment
    return gradeScores.values.any((score) => score < 70.0);
  }

  /// Check if boundary detection is needed
  bool _needsBoundaryDetection(Map<int, double> gradeScores) {
    // If there's significant variation, find exact boundary
    final scores = gradeScores.values.toList();
    if (scores.isEmpty) return false;
    final max = scores.reduce((a, b) => a > b ? a : b);
    final min = scores.reduce((a, b) => a < b ? a : b);
    return (max - min) > 30.0;
  }

  /// Move to deep dive phase
  Future<void> _moveToDeepDive(
    PreAssessment current,
    Map<String, String> answers,
    Map<int, double> phaseResults,
  ) async {
    final deepDiveQuestionIds = await _preAssessmentService.generateAssessmentQuestions(
      subjectName: 'Subject', // TODO: Get from context
      targetGrade: current.targetGrade,
      phase: PreAssessmentPhase.deepDive,
      phaseOneResults: phaseResults,
    );

    final updatedAssessment = current.copyWith(
      currentPhase: PreAssessmentPhase.deepDive,
      questionIds: deepDiveQuestionIds,
      answers: answers, // Keep previous answers
      currentQuestionIndex: 0,
    );

    state = state.copyWith(
      activeAssessment: updatedAssessment,
      isLoading: false,
    );

    logger.info('Moving to deep dive phase with ${deepDiveQuestionIds.length} questions');
  }

  /// Move to boundary detection phase
  Future<void> _moveToBoundaryDetection(
    PreAssessment current,
    Map<String, String> answers,
    Map<int, double> phaseResults,
  ) async {
    final boundaryQuestionIds = await _preAssessmentService.generateAssessmentQuestions(
      subjectName: 'Subject', // TODO: Get from context
      targetGrade: current.targetGrade,
      phase: PreAssessmentPhase.boundaryDetection,
      phaseOneResults: phaseResults,
    );

    final updatedAssessment = current.copyWith(
      currentPhase: PreAssessmentPhase.boundaryDetection,
      questionIds: boundaryQuestionIds,
      answers: answers,
      currentQuestionIndex: 0,
    );

    state = state.copyWith(
      activeAssessment: updatedAssessment,
      isLoading: false,
    );

    logger.info('Moving to boundary detection with ${boundaryQuestionIds.length} questions');
  }

  /// Complete the assessment and generate results
  Future<void> _completeAssessment(
    Map<String, String> answers,
    Map<int, double> gradeScores,
  ) async {
    final currentAssessment = state.activeAssessment!;

    try {
      // Calculate overall readiness
      final overallReadiness = gradeScores.isEmpty
          ? 0.0
          : gradeScores.values.reduce((a, b) => a + b) / gradeScores.length;

      // Detect gaps based on assessment
      final analysis = await _gapAnalysisService.analyzeSubjectReadiness(
        studentId: currentAssessment.studentId,
        subjectId: currentAssessment.subjectId,
        subjectName: 'Subject', // TODO: Get from context
        targetGrade: currentAssessment.targetGrade,
      );

      final gaps = analysis.gaps;

      // Generate recommended path if there are gaps
      LearningPath? recommendedPath;
      if (gaps.isNotEmpty) {
        recommendedPath = await _learningPathGenerator.generateFoundationPath(
          studentId: currentAssessment.studentId,
          targetConceptId: '${currentAssessment.subjectId}_grade_${currentAssessment.targetGrade}',
          gaps: gaps,
        );
      }

      // Calculate estimated fix time
      final estimatedMinutes = gaps.fold<int>(
        0,
        (sum, gap) => sum + gap.estimatedFixMinutes,
      );

      final result = PreAssessmentResult(
        assessmentId: currentAssessment.id,
        overallReadiness: overallReadiness,
        gradeScores: gradeScores,
        identifiedGaps: gaps,
        recommendedPath: recommendedPath,
        estimatedFixMinutes: estimatedMinutes,
        generatedAt: DateTime.now(),
      );

      final completedAssessment = currentAssessment.copyWith(
        answers: answers,
        completedAt: DateTime.now(),
        result: result,
      );

      state = state.copyWith(
        activeAssessment: completedAssessment,
        result: result,
        recommendedPath: recommendedPath,
        identifiedGaps: gaps,
        isLoading: false,
      );

      logger.info(
        'Pre-assessment completed. Readiness: ${overallReadiness.toStringAsFixed(1)}%, '
        'Gaps: ${gaps.length}',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to complete assessment', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to complete assessment: $e',
      );
    }
  }

  /// Navigate to specific question
  void navigateToQuestion(int index) {
    if (state.activeAssessment == null) return;
    if (index < 0 || index >= state.activeAssessment!.questionIds.length) return;

    final updated = state.activeAssessment!.copyWith(currentQuestionIndex: index);
    state = state.copyWith(activeAssessment: updated);
  }

  /// Clear assessment and start fresh
  void clearAssessment() {
    state = PreAssessmentState.initial();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for pre-assessment state management
final preAssessmentProvider = StateNotifierProvider<PreAssessmentNotifier, PreAssessmentState>((ref) {
  final container = injectionContainer;

  return PreAssessmentNotifier(
    preAssessmentService: container.preAssessmentService,
    gapAnalysisService: container.gapAnalysisService,
    learningPathGenerator: container.learningPathGenerator,
  );
});
