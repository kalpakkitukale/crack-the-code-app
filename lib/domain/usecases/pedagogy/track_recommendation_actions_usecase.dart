/// Use case for tracking user interactions with recommendations
library;

import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:streamshaala/domain/repositories/recommendations_history_repository.dart';

/// Use case for tracking various user actions on recommendations
class TrackRecommendationActionsUseCase {
  final RecommendationsHistoryRepository _historyRepository;
  final QuizAttemptDao _quizAttemptDao;

  const TrackRecommendationActionsUseCase({
    required RecommendationsHistoryRepository historyRepository,
    required QuizAttemptDao quizAttemptDao,
  })  : _historyRepository = historyRepository,
        _quizAttemptDao = quizAttemptDao;

  /// Track that user started learning path from recommendations
  Future<void> startLearningPath({
    required String recommendationsId,
    required String quizAttemptId,
    required String learningPathId,
  }) async {
    try {
      // Update recommendations history
      await _historyRepository.updateLearningPathStatus(
        id: recommendationsId,
        learningPathId: learningPathId,
        started: true,
      );

      // Update quiz attempt
      await _quizAttemptDao.updateRecommendationStatus(
        attemptId: quizAttemptId,
        status: 'inProgress',
      );

      await _quizAttemptDao.updateLearningPathProgress(
        attemptId: quizAttemptId,
        learningPathId: learningPathId,
        progress: 0.0,
      );

      logger.info(
        'Tracked learning path start: $learningPathId for recommendations: $recommendationsId',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to track learning path start', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  /// Track learning path progress update
  Future<void> updateLearningPathProgress({
    required String quizAttemptId,
    required String learningPathId,
    required double progress,
  }) async {
    try {
      await _quizAttemptDao.updateLearningPathProgress(
        attemptId: quizAttemptId,
        learningPathId: learningPathId,
        progress: progress,
      );

      logger.debug(
        'Updated learning path progress: ${(progress * 100).toStringAsFixed(0)}% for quiz: $quizAttemptId',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to update learning path progress', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  /// Track that user completed learning path from recommendations
  Future<void> completeLearningPath({
    required String recommendationsId,
    required String quizAttemptId,
    required String learningPathId,
  }) async {
    try {
      // Update recommendations history
      await _historyRepository.updateLearningPathStatus(
        id: recommendationsId,
        completed: true,
      );

      // Update quiz attempt
      await _quizAttemptDao.updateRecommendationStatus(
        attemptId: quizAttemptId,
        status: 'completed',
      );

      await _quizAttemptDao.updateLearningPathProgress(
        attemptId: quizAttemptId,
        learningPathId: learningPathId,
        progress: 1.0,
      );

      logger.info(
        '✅ Tracked learning path completion: $learningPathId for recommendations: $recommendationsId',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to track learning path completion', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  /// Track that user viewed a video from recommendations
  Future<void> trackVideoViewed({
    required String recommendationsId,
    required String videoId,
  }) async {
    try {
      await _historyRepository.trackVideoViewed(recommendationsId, videoId);

      logger.debug(
        'Tracked video view: $videoId for recommendations: $recommendationsId',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to track video view', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  /// Track that user dismissed a specific recommendation
  Future<void> dismissRecommendation({
    required String recommendationsId,
    required String conceptId,
  }) async {
    try {
      await _historyRepository.dismissRecommendation(
        recommendationsId,
        conceptId,
      );

      logger.debug(
        'Dismissed recommendation: $conceptId from $recommendationsId',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to dismiss recommendation', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  /// Mark recommendations as viewed (increments view count)
  Future<void> markAsViewed(String recommendationsId) async {
    try {
      await _historyRepository.markAsViewed(recommendationsId);

      logger.debug('Marked recommendations as viewed: $recommendationsId');
    } catch (e, stackTrace) {
      logger.error('Failed to mark recommendations as viewed', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  /// Update quiz attempt recommendation status without learning path
  /// (e.g., user viewed recommendations but didn't start learning path)
  Future<void> updateRecommendationStatus({
    required String quizAttemptId,
    required String status,
  }) async {
    try {
      await _quizAttemptDao.updateRecommendationStatus(
        attemptId: quizAttemptId,
        status: status,
      );

      logger.debug(
        'Updated recommendation status for quiz: $quizAttemptId to $status',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to update recommendation status', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }
}
