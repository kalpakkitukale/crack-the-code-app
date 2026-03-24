/// Path Analytics Service
///
/// Tracks learning path events for analytics and metrics.
/// Currently logs events locally - can be extended to send to analytics platforms.
library;

import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';

/// Service for tracking learning path analytics events
class PathAnalyticsService {
  /// Track when a learning path is started
  Future<void> trackPathStarted(LearningPath path) async {
    try {
      logger.info('📊 Analytics: Path Started', {
        'event': 'path_started',
        'path_id': path.id,
        'subject_id': path.subjectId,
        'student_id': path.studentId,
        'total_nodes': path.totalNodes,
        'estimated_duration': path.estimatedTimeRemaining,
      });

      // TODO: Send to analytics platform (Firebase Analytics, Mixpanel, etc.)
      // await _analyticsRepository.logEvent(
      //   event: 'path_started',
      //   properties: {...},
      // );
    } catch (e, stackTrace) {
      logger.error('Failed to track path started', e, stackTrace);
    }
  }

  /// Track when a learning path is resumed
  Future<void> trackPathResumed(LearningPath path) async {
    try {
      logger.info('📊 Analytics: Path Resumed', {
        'event': 'path_resumed',
        'path_id': path.id,
        'subject_id': path.subjectId,
        'student_id': path.studentId,
        'progress_percentage': path.progressPercentage,
        'completed_nodes': path.completedNodes,
        'total_nodes': path.totalNodes,
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track path resumed', e, stackTrace);
    }
  }

  /// Track when a learning path is completed
  Future<void> trackPathCompleted(
    LearningPath path,
    Duration completionTime,
  ) async {
    try {
      final avgScore = _calculateAverageScore(path);

      logger.info('📊 Analytics: Path Completed', {
        'event': 'path_completed',
        'path_id': path.id,
        'subject_id': path.subjectId,
        'student_id': path.studentId,
        'total_nodes': path.totalNodes,
        'completion_time_seconds': completionTime.inSeconds,
        'completion_time_minutes': completionTime.inMinutes,
        'average_score': avgScore,
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track path completed', e, stackTrace);
    }
  }

  /// Track when a learning path is abandoned
  Future<void> trackPathAbandoned(
    LearningPath path, {
    String? reason,
  }) async {
    try {
      logger.info('📊 Analytics: Path Abandoned', {
        'event': 'path_abandoned',
        'path_id': path.id,
        'subject_id': path.subjectId,
        'student_id': path.studentId,
        'progress_percentage': path.progressPercentage,
        'completed_nodes': path.completedNodes,
        'total_nodes': path.totalNodes,
        'reason': reason,
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track path abandoned', e, stackTrace);
    }
  }

  /// Track when a node is completed
  Future<void> trackNodeCompleted(
    String pathId,
    PathNode node, {
    Duration? timeSpent,
    double? score,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.info('📊 Analytics: Node Completed', {
        'event': 'node_completed',
        'path_id': pathId,
        'node_id': node.id,
        'node_type': node.type.name,
        'node_title': node.title,
        'time_spent_seconds': timeSpent?.inSeconds,
        'score': score,
        'skipped': metadata?['skipped'] ?? false,
        'auto_completed': metadata?['autoCompleted'] ?? false,
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track node completed', e, stackTrace);
    }
  }

  /// Track when a node is started
  Future<void> trackNodeStarted(
    String pathId,
    PathNode node,
  ) async {
    try {
      logger.info('📊 Analytics: Node Started', {
        'event': 'node_started',
        'path_id': pathId,
        'node_id': node.id,
        'node_type': node.type.name,
        'node_title': node.title,
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track node started', e, stackTrace);
    }
  }

  /// Track when a milestone is reached (25%, 50%, 75%, 100%)
  Future<void> trackMilestoneReached(
    String pathId,
    int percentage,
    LearningPath path,
  ) async {
    try {
      logger.info('📊 Analytics: Milestone Reached', {
        'event': 'milestone_reached',
        'path_id': pathId,
        'milestone_percentage': percentage,
        'subject_id': path.subjectId,
        'student_id': path.studentId,
        'total_nodes': path.totalNodes,
        'completed_nodes': path.completedNodes,
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track milestone reached', e, stackTrace);
    }
  }

  /// Track when a path is accessed from home screen
  Future<void> trackPathAccessedFromHome(String pathId) async {
    try {
      logger.info('📊 Analytics: Path Accessed From Home', {
        'event': 'path_accessed_from_home',
        'path_id': pathId,
        'source': 'home_screen',
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track path accessed from home', e, stackTrace);
    }
  }

  /// Track when a path is accessed from recommendations
  Future<void> trackPathAccessedFromRecommendations(String pathId) async {
    try {
      logger.info('📊 Analytics: Path Accessed From Recommendations', {
        'event': 'path_accessed_from_recommendations',
        'path_id': pathId,
        'source': 'recommendations_screen',
      });
    } catch (e, stackTrace) {
      logger.error('Failed to track path accessed from recommendations', e, stackTrace);
    }
  }

  /// Calculate average score across all completed nodes
  double _calculateAverageScore(LearningPath path) {
    final nodesWithScores = path.nodes.where(
      (node) => node.completed && node.scorePercentage != null,
    );

    if (nodesWithScores.isEmpty) return 0.0;

    final totalScore = nodesWithScores.fold<double>(
      0.0,
      (sum, node) => sum + node.scorePercentage!,
    );

    return totalScore / nodesWithScores.length;
  }
}
