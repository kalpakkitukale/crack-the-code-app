/// Implementation of RecommendationsHistoryRepository
library;

import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/recommendations_history_dao.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendations_history.dart';
import 'package:crack_the_code/domain/repositories/recommendations_history_repository.dart';

/// Concrete implementation of RecommendationsHistoryRepository
class RecommendationsHistoryRepositoryImpl
    implements RecommendationsHistoryRepository {
  final RecommendationsHistoryDao _dao;

  const RecommendationsHistoryRepositoryImpl({
    required RecommendationsHistoryDao dao,
  }) : _dao = dao;

  @override
  Future<void> saveRecommendations(RecommendationsHistory history) async {
    try {
      logger.debug('Saving recommendations history: ${history.id}');
      await _dao.insert(history);
      logger.info(
        '✅ Saved recommendations history for quiz: ${history.quizAttemptId}',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to save recommendations history', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateRecommendations(RecommendationsHistory history) async {
    try {
      logger.debug('Updating recommendations history: ${history.id}');
      await _dao.update(history);
      logger.info('✅ Updated recommendations history: ${history.id}');
    } catch (e, stackTrace) {
      logger.error('Failed to update recommendations history', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<RecommendationsHistory?> getByQuizAttempt(
    String quizAttemptId,
  ) async {
    try {
      final history = await _dao.getByQuizAttempt(quizAttemptId);
      if (history != null) {
        logger.debug(
          'Retrieved recommendations for quiz: $quizAttemptId (${history.totalRecommendations} recommendations)',
        );
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

  @override
  Future<RecommendationsHistory?> getById(String id) async {
    try {
      return await _dao.getById(id);
    } catch (e, stackTrace) {
      logger.error('Failed to get recommendations by ID', e, stackTrace);
      return null;
    }
  }

  @override
  Future<List<RecommendationsHistory>> getHistory({
    required String userId,
    AssessmentType? assessmentType,
    String? subjectId,
    bool? hasRecommendations,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final history = await _dao.getFiltered(
        userId: userId,
        assessmentType: assessmentType,
        subjectId: subjectId,
        hasRecommendations: hasRecommendations,
        limit: limit,
        offset: offset,
      );

      logger.debug(
        'Retrieved ${history.length} recommendations history entries for user: $userId',
      );

      return history;
    } catch (e, stackTrace) {
      logger.error('Failed to get recommendations history', e, stackTrace);
      return [];
    }
  }

  @override
  Future<void> markAsViewed(String id) async {
    try {
      await _dao.markAsViewed(id);
      logger.debug('Marked recommendations as viewed: $id');
    } catch (e, stackTrace) {
      logger.error('Failed to mark recommendations as viewed', e, stackTrace);
      // Don't rethrow - this is a tracking operation, not critical
    }
  }

  @override
  Future<void> updateLearningPathStatus({
    required String id,
    String? learningPathId,
    bool? started,
    bool? completed,
  }) async {
    try {
      await _dao.updateLearningPathStatus(
        id: id,
        learningPathId: learningPathId,
        started: started,
        completed: completed,
      );

      final statusMsg = completed == true
          ? 'completed'
          : started == true
              ? 'started'
              : 'updated';
      logger.info('Learning path $statusMsg for recommendations: $id');
    } catch (e, stackTrace) {
      logger.error('Failed to update learning path status', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  @override
  Future<void> trackVideoViewed(String id, String videoId) async {
    try {
      await _dao.trackVideoViewed(id, videoId);
      logger.debug('Tracked video view: $videoId for recommendations: $id');
    } catch (e, stackTrace) {
      logger.error('Failed to track video view', e, stackTrace);
      // Don't rethrow - this is a tracking operation
    }
  }

  @override
  Future<void> dismissRecommendation(String id, String conceptId) async {
    try {
      await _dao.dismissRecommendation(id, conceptId);
      logger.debug('Dismissed recommendation: $conceptId from $id');
    } catch (e, stackTrace) {
      logger.error('Failed to dismiss recommendation', e, stackTrace);
      // Don't rethrow - this is a user action, should not block UI
    }
  }

  @override
  Future<int> cleanupOldRecommendations({int daysOld = 90}) async {
    try {
      final deleted = await _dao.deleteOlderThan(daysOld: daysOld);
      if (deleted > 0) {
        logger.info(
          'Cleaned up $deleted old recommendations (>$daysOld days)',
        );
      }
      return deleted;
    } catch (e, stackTrace) {
      logger.error('Failed to cleanup old recommendations', e, stackTrace);
      return 0;
    }
  }
}
