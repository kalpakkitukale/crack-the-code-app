/// Mastery tracking state management provider
///
/// Manages concept mastery tracking and spaced repetition scheduling
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_mastery.dart';
import 'package:streamshaala/domain/services/gap_analysis_service.dart';
import 'package:streamshaala/domain/services/mastery_calculation_service.dart';
import 'package:streamshaala/domain/services/spaced_repetition_service.dart';
import 'package:streamshaala/data/datasources/local/database/dao/concept_mastery_dao.dart';
import 'package:streamshaala/data/models/pedagogy/concept_mastery_model.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// Mastery state
class MasteryState {
  final Map<String, ConceptMastery> conceptMasteries;
  final List<ConceptGap> currentGaps;
  final List<ConceptMastery> reviewsDue;
  final double overallMastery;
  final int reviewStreak;
  final bool isLoading;
  final String? error;

  const MasteryState({
    this.conceptMasteries = const {},
    this.currentGaps = const [],
    this.reviewsDue = const [],
    this.overallMastery = 0.0,
    this.reviewStreak = 0,
    this.isLoading = false,
    this.error,
  });

  factory MasteryState.initial() => const MasteryState();

  MasteryState copyWith({
    Map<String, ConceptMastery>? conceptMasteries,
    List<ConceptGap>? currentGaps,
    List<ConceptMastery>? reviewsDue,
    double? overallMastery,
    int? reviewStreak,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MasteryState(
      conceptMasteries: conceptMasteries ?? this.conceptMasteries,
      currentGaps: currentGaps ?? this.currentGaps,
      reviewsDue: reviewsDue ?? this.reviewsDue,
      overallMastery: overallMastery ?? this.overallMastery,
      reviewStreak: reviewStreak ?? this.reviewStreak,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Get mastery for a specific concept
  ConceptMastery? getMastery(String conceptId) => conceptMasteries[conceptId];

  /// Get all gaps count
  int get gapsCount => currentGaps.length;

  /// Get reviews due count
  int get reviewsDueCount => reviewsDue.length;

  /// Check if there are gaps
  bool get hasGaps => currentGaps.isNotEmpty;

  /// Check if reviews are due
  bool get hasReviewsDue => reviewsDue.isNotEmpty;

  /// Get mastered concepts count
  int get masteredCount => conceptMasteries.values
      .where((m) => m.level == MasteryLevel.mastered)
      .length;

  /// Get learning concepts count
  int get learningCount => conceptMasteries.values
      .where((m) => m.level == MasteryLevel.learning || m.level == MasteryLevel.familiar)
      .length;
}

/// Mastery state notifier
class MasteryNotifier extends StateNotifier<MasteryState> {
  final ConceptMasteryDao _masteryDao;
  final MasteryCalculationService _masteryService;
  final SpacedRepetitionService _spacedRepService;
  final GapAnalysisService _gapService;

  MasteryNotifier({
    required ConceptMasteryDao masteryDao,
    required MasteryCalculationService masteryService,
    required SpacedRepetitionService spacedRepService,
    required GapAnalysisService gapService,
  })  : _masteryDao = masteryDao,
        _masteryService = masteryService,
        _spacedRepService = spacedRepService,
        _gapService = gapService,
        super(MasteryState.initial());

  /// Safely update state only if still mounted
  void _safeSetState(MasteryState newState) {
    if (mounted) {
      state = newState;
    }
  }

  @override
  void dispose() {
    logger.debug('MasteryNotifier: Disposing...');
    super.dispose();
  }

  /// Load mastery data for a student
  Future<void> loadMastery(String studentId) async {
    try {
      logger.info('Loading mastery data for student: $studentId');
      _safeSetState(state.copyWith(isLoading: true, clearError: true));

      // Load all concept masteries using getByStudent (correct method name)
      final masteryModels = await _masteryDao.getByStudent(studentId);

      if (!mounted) return;

      final masteryMap = <String, ConceptMastery>{};

      for (final model in masteryModels) {
        final mastery = _modelToEntity(model);
        masteryMap[mastery.conceptId] = mastery;
      }

      // Calculate overall mastery
      double overallMastery = 0.0;
      if (masteryModels.isNotEmpty) {
        overallMastery = masteryModels.fold<double>(
          0.0,
          (sum, m) => sum + m.masteryScore,
        ) / masteryModels.length;
      }

      // Load gaps
      final gapModels = masteryModels.where((m) => m.masteryScore < 60).toList();
      final conceptGaps = gapModels.map((m) => ConceptGap(
        id: 'gap_${m.conceptId}',
        conceptId: m.conceptId,
        conceptName: m.conceptId, // Would need concept lookup for name
        gradeLevel: m.gradeLevel ?? 0,
        currentMastery: m.masteryScore,
        priorityScore: _calculatePriority(m.masteryScore),
        blockedConcepts: [],
        recommendedVideoIds: [],
        estimatedFixMinutes: 15,
      )).toList();

      // Load reviews due
      final reviewModels = await _masteryDao.getReviewsDue(
        studentId: studentId,
        beforeDate: DateTime.now(),
      );

      if (!mounted) return;

      final reviewsDue = reviewModels.map(_modelToEntity).toList();

      _safeSetState(state.copyWith(
        conceptMasteries: masteryMap,
        currentGaps: conceptGaps,
        reviewsDue: reviewsDue,
        overallMastery: overallMastery,
        isLoading: false,
      ));

      logger.info(
        'Mastery loaded: ${masteryModels.length} concepts, ${gapModels.length} gaps, '
        '${reviewsDue.length} reviews due',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to load mastery data', e, stackTrace);
      _safeSetState(state.copyWith(
        isLoading: false,
        error: 'Failed to load mastery data: $e',
      ));
    }
  }

  /// Update mastery after quiz/video completion
  Future<void> updateMastery({
    required String studentId,
    required String conceptId,
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
  }) async {
    try {
      logger.info('Updating mastery for concept: $conceptId');

      // Get current mastery
      var currentMastery = state.getMastery(conceptId);
      final previousScore = currentMastery?.masteryScore ?? 0.0;

      // Calculate new mastery
      final newScore = _masteryService.calculateMastery(
        preQuizScore: preQuizScore,
        checkpointScore: checkpointScore,
        postQuizScore: postQuizScore,
        practiceScore: practiceScore,
        spacedRepScore: spacedRepScore,
        previousMastery: previousScore,
      );

      final newLevel = _masteryService.getMasteryLevel(newScore);
      final isGap = _masteryService.isGap(newScore);

      // Create or update mastery model for database
      final model = ConceptMasteryModel(
        id: currentMastery?.id ?? 'mastery_${studentId}_$conceptId',
        conceptId: conceptId,
        studentId: studentId,
        masteryScore: newScore,
        level: newLevel,
        lastAssessed: DateTime.now(),
        totalAttempts: (currentMastery?.totalAttempts ?? 0) + 1,
        isGap: isGap,
        nextReviewDate: isGap ? null : _calculateNextReview(newLevel),
        reviewStreak: _calculateReviewStreak(currentMastery, newScore > previousScore),
        gradeLevel: null,
      );

      // Save to database
      await _masteryDao.upsert(model);

      if (!mounted) return;

      // Create entity for state
      final updatedMastery = ConceptMastery(
        id: model.id,
        conceptId: conceptId,
        studentId: studentId,
        masteryScore: newScore,
        level: newLevel,
        lastAssessed: DateTime.now(),
        totalAttempts: model.totalAttempts,
        isGap: isGap,
        nextReviewDate: model.nextReviewDate,
        reviewStreak: model.reviewStreak,
      );

      // Update local state
      final updatedMap = Map<String, ConceptMastery>.from(state.conceptMasteries);
      updatedMap[conceptId] = updatedMastery;

      // Update gaps list
      final updatedGaps = state.currentGaps.where((g) => g.conceptId != conceptId).toList();
      if (isGap) {
        updatedGaps.add(ConceptGap(
          id: 'gap_$conceptId',
          conceptId: conceptId,
          conceptName: conceptId,
          gradeLevel: 0,
          currentMastery: newScore,
          priorityScore: _calculatePriority(newScore),
          blockedConcepts: [],
          recommendedVideoIds: [],
          estimatedFixMinutes: 15,
        ));
      }

      // Recalculate overall mastery
      final overallMastery = updatedMap.values.fold<double>(
        0.0,
        (sum, m) => sum + m.masteryScore,
      ) / updatedMap.length;

      _safeSetState(state.copyWith(
        conceptMasteries: updatedMap,
        currentGaps: updatedGaps,
        overallMastery: overallMastery,
      ));

      logger.info(
        'Mastery updated: $conceptId - ${previousScore.toStringAsFixed(1)}% -> '
        '${newScore.toStringAsFixed(1)}% (${newLevel.name})',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to update mastery', e, stackTrace);
      _safeSetState(state.copyWith(error: 'Failed to update mastery: $e'));
    }
  }

  /// Complete a spaced repetition review
  Future<void> completeReview({
    required String studentId,
    required String conceptId,
    required bool answeredCorrectly,
    required double scorePercentage,
  }) async {
    try {
      logger.info('Completing review for concept: $conceptId, correct: $answeredCorrectly');

      // Record the review using the spaced repetition service
      await _spacedRepService.recordReview(
        studentId: studentId,
        conceptId: conceptId,
        scorePercentage: scorePercentage,
      );

      if (!mounted) return;

      // Update local state - remove from reviews due
      final updatedReviews = state.reviewsDue
          .where((r) => r.conceptId != conceptId)
          .toList();

      // Update mastery score if needed
      final currentMastery = state.getMastery(conceptId);
      if (currentMastery != null) {
        final newScore = answeredCorrectly
            ? (currentMastery.masteryScore + 5).clamp(0.0, 100.0)
            : (currentMastery.masteryScore - 2).clamp(0.0, 100.0);

        final updatedMastery = currentMastery.copyWith(
          masteryScore: newScore,
          lastAssessed: DateTime.now(),
          reviewStreak: answeredCorrectly
              ? (currentMastery.reviewStreak ?? 0) + 1
              : 0,
        );

        final updatedMap = Map<String, ConceptMastery>.from(state.conceptMasteries);
        updatedMap[conceptId] = updatedMastery;

        _safeSetState(state.copyWith(
          conceptMasteries: updatedMap,
          reviewsDue: updatedReviews,
        ));
      } else {
        _safeSetState(state.copyWith(reviewsDue: updatedReviews));
      }

      logger.info('Review completed for $conceptId');
    } catch (e, stackTrace) {
      logger.error('Failed to complete review', e, stackTrace);
      _safeSetState(state.copyWith(error: 'Failed to complete review: $e'));
    }
  }

  /// Get gaps for a specific subject
  Future<List<ConceptGap>> getGapsForSubject(String studentId, String subjectId, String subjectName, int targetGrade) async {
    try {
      final analysis = await _gapService.analyzeSubjectReadiness(
        studentId: studentId,
        subjectId: subjectId,
        subjectName: subjectName,
        targetGrade: targetGrade,
      );
      return analysis.gaps;
    } catch (e, stackTrace) {
      logger.error('Failed to get gaps for subject', e, stackTrace);
      return [];
    }
  }

  /// Convert model to entity
  ConceptMastery _modelToEntity(ConceptMasteryModel model) {
    return ConceptMastery(
      id: model.id,
      conceptId: model.conceptId,
      studentId: model.studentId,
      masteryScore: model.masteryScore,
      level: model.level,
      lastAssessed: model.lastAssessed,
      totalAttempts: model.totalAttempts,
      isGap: model.isGap,
      nextReviewDate: model.nextReviewDate,
      reviewStreak: model.reviewStreak,
    );
  }

  /// Convert level string to enum
  MasteryLevel _levelFromString(String level) {
    return MasteryLevel.values.firstWhere(
      (e) => e.name == level,
      orElse: () => MasteryLevel.notLearned,
    );
  }

  /// Calculate priority score from mastery score
  int _calculatePriority(double masteryScore) {
    int score = 0;
    if (masteryScore < 20) score += 40;
    else if (masteryScore < 40) score += 30;
    else if (masteryScore < 60) score += 20;
    return score;
  }

  /// Calculate next review date based on mastery level
  DateTime _calculateNextReview(MasteryLevel level) {
    final now = DateTime.now();
    switch (level) {
      case MasteryLevel.notLearned:
        return now.add(const Duration(days: 1));
      case MasteryLevel.learning:
        return now.add(const Duration(days: 3));
      case MasteryLevel.familiar:
        return now.add(const Duration(days: 7));
      case MasteryLevel.proficient:
        return now.add(const Duration(days: 14));
      case MasteryLevel.mastered:
        return now.add(const Duration(days: 30));
    }
  }

  /// Calculate review streak
  int _calculateReviewStreak(ConceptMastery? current, bool improved) {
    if (current == null) return improved ? 1 : 0;
    if (!improved) return 0;
    return (current.reviewStreak ?? 0) + 1;
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for mastery state management
final masteryProvider = StateNotifierProvider<MasteryNotifier, MasteryState>((ref) {
  final container = injectionContainer;

  return MasteryNotifier(
    masteryDao: container.conceptMasteryDao,
    masteryService: container.masteryCalculationService,
    spacedRepService: container.spacedRepetitionService,
    gapService: container.gapAnalysisService,
  );
});
