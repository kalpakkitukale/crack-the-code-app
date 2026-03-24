/// Recommendations state management provider
///
/// Manages quiz-based recommendations for personalized learning paths
library;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/pedagogy/quiz_recommendation.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendations_history.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/usecases/pedagogy/generate_quiz_recommendations_usecase.dart';
import 'package:crack_the_code/domain/repositories/recommendations_history_repository.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Recommendations state
class RecommendationsState {
  final RecommendationsBundle? bundle;
  final Map<String, bool> dismissedRecommendations;
  final Map<String, String> actedRecommendations; // conceptId -> action type
  final bool isLoading;
  final String? error;

  const RecommendationsState({
    this.bundle,
    this.dismissedRecommendations = const {},
    this.actedRecommendations = const {},
    this.isLoading = false,
    this.error,
  });

  factory RecommendationsState.initial() => const RecommendationsState();

  RecommendationsState copyWith({
    RecommendationsBundle? bundle,
    Map<String, bool>? dismissedRecommendations,
    Map<String, String>? actedRecommendations,
    bool? isLoading,
    String? error,
    bool clearBundle = false,
    bool clearError = false,
  }) {
    return RecommendationsState(
      bundle: clearBundle ? null : bundle ?? this.bundle,
      dismissedRecommendations: dismissedRecommendations ?? this.dismissedRecommendations,
      actedRecommendations: actedRecommendations ?? this.actedRecommendations,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Check if there are recommendations available
  bool get hasRecommendations => bundle != null && bundle!.hasRecommendations;

  /// Get active (non-dismissed) recommendations
  List<QuizRecommendation> get activeRecommendations {
    if (bundle == null) return [];
    return bundle!.recommendations
        .where((r) => !dismissedRecommendations.containsKey(r.gap.conceptId))
        .toList();
  }

  /// Get top 3 active recommendations
  List<QuizRecommendation> get top3Active {
    return activeRecommendations.take(3).toList();
  }

  /// Check if user has acted on any recommendation
  bool get hasActed => actedRecommendations.isNotEmpty;

  /// Get action type for a concept (guidedPath, browseVideos, or null)
  String? getActionType(String conceptId) => actedRecommendations[conceptId];

  /// Check if specific concept is dismissed
  bool isConceptDismissed(String conceptId) =>
      dismissedRecommendations.containsKey(conceptId);

  /// Check if specific concept has been acted upon
  bool hasActedOnConcept(String conceptId) =>
      actedRecommendations.containsKey(conceptId);
}

/// Recommendations state notifier
class RecommendationsNotifier extends StateNotifier<RecommendationsState> {
  final GenerateQuizRecommendationsUseCase _generateRecommendationsUseCase;
  final RecommendationsHistoryRepository _historyRepository;
  final QuizAttemptDao _quizAttemptDao;

  RecommendationsNotifier({
    required GenerateQuizRecommendationsUseCase generateRecommendationsUseCase,
    required RecommendationsHistoryRepository historyRepository,
    required QuizAttemptDao quizAttemptDao,
  })  : _generateRecommendationsUseCase = generateRecommendationsUseCase,
        _historyRepository = historyRepository,
        _quizAttemptDao = quizAttemptDao,
        super(RecommendationsState.initial());

  /// Generate recommendations from quiz result
  Future<void> generateFromQuizResult({
    required QuizResult quizResult,
    required String studentId,
    required AssessmentType assessmentType,
  }) async {
    try {
      logger.info(
        '🎯 [RecommendationsProvider] === GENERATION STARTED ===\n'
        '   Quiz ID: ${quizResult.sessionId}\n'
        '   Student ID: $studentId\n'
        '   Assessment Type: ${assessmentType.name}\n'
        '   Score: ${quizResult.scorePercentage}%\n'
        '   Weak Areas: ${quizResult.weakAreas?.length ?? 0}',
      );

      state = state.copyWith(isLoading: true, clearError: true);
      logger.info('🎯 [RecommendationsProvider] State updated: isLoading=true');

      final params = GenerateQuizRecommendationsParams(
        quizResult: quizResult,
        studentId: studentId,
        assessmentType: assessmentType,
      );

      logger.info('🎯 [RecommendationsProvider] Calling use case...');
      final result = await _generateRecommendationsUseCase(params);
      logger.info('🎯 [RecommendationsProvider] Use case returned result');

      // CRITICAL FIX: Properly handle async database operations
      await result.fold(
        (failure) async {
          logger.error('❌ [RecommendationsProvider] FAILED: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (bundle) async {
          logger.info(
            '✅ [RecommendationsProvider] SUCCESS!\n'
            '   Total Recommendations: ${bundle.totalCount}\n'
            '   Has Recommendations: ${bundle.hasRecommendations}\n'
            '   Critical: ${bundle.criticalCount}, Severe: ${bundle.severeCount}',
          );

          // CRITICAL FIX: Save recommendations to database
          try {
            if (bundle.hasRecommendations) {
              logger.info('💾 [RecommendationsProvider] Bundle has recommendations, starting save...');

              // Create recommendations history record
              final historyId = const Uuid().v4();
              logger.info('💾 [RecommendationsProvider] Generated history ID: $historyId');

              final history = RecommendationsHistory(
                id: historyId,
                quizAttemptId: quizResult.sessionId,
                userId: studentId,
                subjectId: bundle.subjectName ?? 'unknown',
                topicId: null,
                assessmentType: assessmentType,
                recommendations: bundle.recommendations,
                totalRecommendations: bundle.totalCount,
                criticalGaps: bundle.criticalCount,
                severeGaps: bundle.severeCount,
                estimatedMinutesToFix: bundle.totalEstimatedMinutes,
                generatedAt: bundle.generatedAt,
              );
              logger.info('💾 [RecommendationsProvider] Created history object');

              // Save to database
              logger.info('💾 [RecommendationsProvider] Calling repository.saveRecommendations...');
              await _historyRepository.saveRecommendations(history);
              logger.info('✅ [RecommendationsProvider] SAVED to recommendations_history: $historyId');

              // Update quiz attempt with recommendations flag
              logger.info('💾 [RecommendationsProvider] Updating quiz_attempts metadata...');
              await _quizAttemptDao.updateRecommendationMetadata(
                attemptId: quizResult.sessionId,
                hasRecommendations: true,
                recommendationCount: bundle.totalCount,
                recommendationsHistoryId: historyId,
                assessmentType: assessmentType.name,
              );
              logger.info('✅ [RecommendationsProvider] UPDATED quiz_attempts table');
              logger.info('🎉 [RecommendationsProvider] === DATABASE SAVE COMPLETE ===');
            } else {
              logger.warning('⚠️ [RecommendationsProvider] Bundle has NO recommendations (empty)');
            }
          } catch (e, stackTrace) {
            logger.error('❌ [RecommendationsProvider] DATABASE SAVE FAILED!', e, stackTrace);
            // Don't fail the whole operation if DB save fails, but log it prominently
          }

          logger.info('🎯 [RecommendationsProvider] Updating state with bundle...');
          state = state.copyWith(
            bundle: bundle,
            isLoading: false,
            clearError: true,
          );
          logger.info('✅ [RecommendationsProvider] State updated: isLoading=false, bundle set');
        },
      );

      logger.info('🎯 [RecommendationsProvider] === GENERATION COMPLETE ===');
    } catch (e, stackTrace) {
      logger.error('❌ [RecommendationsProvider] EXCEPTION in generateFromQuizResult', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate recommendations: $e',
      );
    }
  }

  /// Load recommendations from database for a specific quiz attempt
  ///
  /// Returns true if recommendations were found and loaded, false otherwise
  Future<bool> loadFromDatabase({
    required String quizAttemptId,
  }) async {
    try {
      logger.info('🔍 [RecommendationsProvider] Loading recommendations from database for quiz: $quizAttemptId');
      state = state.copyWith(isLoading: true, clearError: true);

      // Get recommendations history from database
      final history = await _historyRepository.getByQuizAttempt(quizAttemptId);

      if (history == null) {
        logger.warning('⚠️ [RecommendationsProvider] No recommendations found in database for quiz: $quizAttemptId');
        state = state.copyWith(isLoading: false);
        return false;
      }

      logger.info('✅ [RecommendationsProvider] Found recommendations in database: ${history.totalRecommendations} recommendations');

      // Convert history to bundle format
      final bundle = RecommendationsBundle(
        quizResultId: history.quizAttemptId,
        recommendations: history.recommendations,
        assessmentType: history.assessmentType,
        generatedAt: history.generatedAt,
        subjectName: history.subjectId,
        quizScore: null, // Not available in history
        totalEstimatedMinutes: history.estimatedMinutesToFix,
      );

      state = state.copyWith(
        bundle: bundle,
        isLoading: false,
        clearError: true,
      );

      logger.info('✅ [RecommendationsProvider] Loaded recommendations from database successfully');
      return true;
    } catch (e, stackTrace) {
      logger.error('❌ [RecommendationsProvider] Failed to load recommendations from database', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load recommendations: $e',
      );
      return false;
    }
  }

  /// Load recommendations from database by history ID (more reliable for viewing from history)
  ///
  /// Returns true if recommendations were found and loaded, false otherwise
  Future<bool> loadByHistoryId({
    required String historyId,
  }) async {
    try {
      logger.info('🔍 [RecommendationsProvider] Loading recommendations by history ID: $historyId');
      state = state.copyWith(isLoading: true, clearError: true);

      // Get recommendations history from database by ID
      final history = await _historyRepository.getById(historyId);

      if (history == null) {
        logger.warning('⚠️ [RecommendationsProvider] No recommendations found for history ID: $historyId');
        state = state.copyWith(isLoading: false);
        return false;
      }

      logger.info('✅ [RecommendationsProvider] Found recommendations by history ID: ${history.totalRecommendations} recommendations');

      // Convert history to bundle format
      final bundle = RecommendationsBundle(
        quizResultId: history.quizAttemptId,
        recommendations: history.recommendations,
        assessmentType: history.assessmentType,
        generatedAt: history.generatedAt,
        subjectName: history.subjectId,
        quizScore: null, // Not available in history
        totalEstimatedMinutes: history.estimatedMinutesToFix,
      );

      state = state.copyWith(
        bundle: bundle,
        isLoading: false,
        clearError: true,
      );

      logger.info('✅ [RecommendationsProvider] Loaded recommendations by history ID successfully');
      return true;
    } catch (e, stackTrace) {
      logger.error('❌ [RecommendationsProvider] Failed to load recommendations by history ID', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load recommendations: $e',
      );
      return false;
    }
  }

  /// Dismiss a specific recommendation
  void dismissRecommendation(String conceptId) {
    if (state.bundle == null) {
      logger.warning('Cannot dismiss recommendation: No bundle loaded');
      return;
    }

    logger.debug('Dismissing recommendation for concept: $conceptId');

    final updatedDismissed = Map<String, bool>.from(state.dismissedRecommendations);
    updatedDismissed[conceptId] = true;

    state = state.copyWith(dismissedRecommendations: updatedDismissed);
  }

  /// Mark recommendation as acted upon
  ///
  /// [actionType] should be one of: 'guidedPath', 'browseVideos'
  void markAsActed(String conceptId, String actionType) {
    if (state.bundle == null) {
      logger.warning('Cannot mark as acted: No bundle loaded');
      return;
    }

    logger.debug('Marking concept $conceptId as acted with type: $actionType');

    final updatedActed = Map<String, String>.from(state.actedRecommendations);
    updatedActed[conceptId] = actionType;

    state = state.copyWith(actedRecommendations: updatedActed);
  }

  /// Mark all recommendations as acted upon
  void markAllAsActed(String actionType) {
    if (state.bundle == null) {
      logger.warning('Cannot mark all as acted: No bundle loaded');
      return;
    }

    logger.debug('Marking all recommendations as acted with type: $actionType');

    final updatedActed = Map<String, String>.from(state.actedRecommendations);
    for (final recommendation in state.bundle!.recommendations) {
      updatedActed[recommendation.gap.conceptId] = actionType;
    }

    state = state.copyWith(actedRecommendations: updatedActed);
  }

  /// Undo dismissal of a recommendation
  void undoDismissal(String conceptId) {
    logger.debug('Undoing dismissal for concept: $conceptId');

    final updatedDismissed = Map<String, bool>.from(state.dismissedRecommendations);
    updatedDismissed.remove(conceptId);

    state = state.copyWith(dismissedRecommendations: updatedDismissed);
  }

  /// Clear all recommendations and reset state
  void clearRecommendations() {
    logger.debug('Clearing recommendations state');
    state = RecommendationsState.initial();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Refresh recommendations (regenerate from current bundle's quiz result)
  Future<void> refresh() async {
    if (state.bundle == null) {
      logger.warning('Cannot refresh: No bundle loaded');
      return;
    }

    // Note: This would require storing the original quiz result
    // For now, we just clear the error
    logger.debug('Refreshing recommendations');
    state = state.copyWith(clearError: true);
  }
}

/// Provider for recommendations state management
final recommendationsProvider =
    StateNotifierProvider<RecommendationsNotifier, RecommendationsState>((ref) {
  final container = injectionContainer;

  return RecommendationsNotifier(
    generateRecommendationsUseCase: container.generateQuizRecommendationsUseCase,
    historyRepository: container.recommendationsHistoryRepository,
    quizAttemptDao: container.quizAttemptDao,
  );
});
