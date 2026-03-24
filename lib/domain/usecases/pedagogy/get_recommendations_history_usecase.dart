/// Use case for retrieving recommendations history
library;

import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendations_history.dart';
import 'package:crack_the_code/domain/repositories/recommendations_history_repository.dart';

/// Use case for getting recommendations history with automatic view tracking
class GetRecommendationsHistoryUseCase {
  final RecommendationsHistoryRepository _repository;

  const GetRecommendationsHistoryUseCase({
    required RecommendationsHistoryRepository repository,
  }) : _repository = repository;

  /// Get recommendations for a specific quiz attempt
  ///
  /// Automatically marks the recommendations as viewed when accessed
  Future<RecommendationsHistory?> getByQuizAttempt(
    String quizAttemptId,
  ) async {
    try {
      final history = await _repository.getByQuizAttempt(quizAttemptId);

      if (history != null) {
        // Track that user accessed these recommendations
        await _repository.markAsViewed(history.id);
        logger.debug('Retrieved recommendations for quiz: $quizAttemptId');
      } else {
        logger.debug('No recommendations found for quiz: $quizAttemptId');
      }

      return history;
    } catch (e, stackTrace) {
      logger.error(
        'Failed to get recommendations by quiz attempt',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get recommendations by ID without automatic view tracking
  Future<RecommendationsHistory?> getById(String id) async {
    try {
      return await _repository.getById(id);
    } catch (e, stackTrace) {
      logger.error('Failed to get recommendations by ID', e, stackTrace);
      return null;
    }
  }

  /// Get all recommendations history for a user with filters
  ///
  /// Parameters:
  /// - [userId]: Required user ID
  /// - [filterByType]: Optional filter by assessment type
  /// - [filterBySubject]: Optional filter by subject ID
  /// - [onlyWithRecommendations]: If true, only returns entries that have recommendations
  /// - [limit]: Maximum number of results (default 50)
  /// - [offset]: Offset for pagination (default 0)
  Future<List<RecommendationsHistory>> getHistory({
    required String userId,
    AssessmentType? filterByType,
    String? filterBySubject,
    bool? onlyWithRecommendations,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final history = await _repository.getHistory(
        userId: userId,
        assessmentType: filterByType,
        subjectId: filterBySubject,
        hasRecommendations: onlyWithRecommendations,
        limit: limit,
        offset: offset,
      );

      logger.debug(
        'Retrieved ${history.length} recommendations history entries for user $userId',
      );

      return history;
    } catch (e, stackTrace) {
      logger.error('Failed to get recommendations history', e, stackTrace);
      return [];
    }
  }

  /// Get only readiness check recommendations
  Future<List<RecommendationsHistory>> getReadinessRecommendations({
    required String userId,
    String? filterBySubject,
    int limit = 50,
  }) {
    return getHistory(
      userId: userId,
      filterByType: AssessmentType.readiness,
      filterBySubject: filterBySubject,
      onlyWithRecommendations: true,
      limit: limit,
    );
  }

  /// Get only knowledge check recommendations
  Future<List<RecommendationsHistory>> getKnowledgeRecommendations({
    required String userId,
    String? filterBySubject,
    int limit = 50,
  }) {
    return getHistory(
      userId: userId,
      filterByType: AssessmentType.knowledge,
      filterBySubject: filterBySubject,
      onlyWithRecommendations: true,
      limit: limit,
    );
  }

  /// Get recent recommendations (last 30 days) that are still relevant
  Future<List<RecommendationsHistory>> getRecentRelevantRecommendations({
    required String userId,
    String? filterBySubject,
  }) async {
    try {
      final allHistory = await getHistory(
        userId: userId,
        filterBySubject: filterBySubject,
        onlyWithRecommendations: true,
        limit: 100,
      );

      // Filter to only include recommendations that are still relevant
      // (not outdated, not completed)
      final relevant = allHistory
          .where((history) => history.isStillRelevant)
          .toList();

      logger.debug(
        'Found ${relevant.length} relevant recommendations out of ${allHistory.length} total',
      );

      return relevant;
    } catch (e, stackTrace) {
      logger.error(
        'Failed to get recent relevant recommendations',
        e,
        stackTrace,
      );
      return [];
    }
  }
}
