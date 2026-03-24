/// Repository interface for RecommendationsHistory persistence operations
library;

import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/domain/entities/pedagogy/recommendations_history.dart';

/// Abstract repository for managing recommendations history
abstract class RecommendationsHistoryRepository {
  /// Save recommendations history to database
  Future<void> saveRecommendations(RecommendationsHistory history);

  /// Update existing recommendations history
  Future<void> updateRecommendations(RecommendationsHistory history);

  /// Get recommendations by quiz attempt ID
  Future<RecommendationsHistory?> getByQuizAttempt(String quizAttemptId);

  /// Get recommendations by ID
  Future<RecommendationsHistory?> getById(String id);

  /// Get filtered recommendations history for a user
  ///
  /// Parameters:
  /// - [userId]: Required user ID
  /// - [assessmentType]: Optional filter by assessment type (readiness, knowledge, practice)
  /// - [subjectId]: Optional filter by subject
  /// - [hasRecommendations]: Optional filter to only include entries with recommendations
  /// - [limit]: Maximum number of results to return (default: 50)
  /// - [offset]: Number of results to skip for pagination (default: 0)
  Future<List<RecommendationsHistory>> getHistory({
    required String userId,
    AssessmentType? assessmentType,
    String? subjectId,
    bool? hasRecommendations,
    int limit = 50,
    int offset = 0,
  });

  /// Mark recommendations as viewed (increments view count, updates timestamps)
  Future<void> markAsViewed(String id);

  /// Update learning path status for recommendations
  ///
  /// Parameters:
  /// - [id]: Recommendations history ID
  /// - [learningPathId]: Optional learning path ID to associate
  /// - [started]: Set to true to mark learning path as started
  /// - [completed]: Set to true to mark learning path as completed
  Future<void> updateLearningPathStatus({
    required String id,
    String? learningPathId,
    bool? started,
    bool? completed,
  });

  /// Track that a video from recommendations was viewed
  Future<void> trackVideoViewed(String id, String videoId);

  /// Dismiss a specific recommendation
  Future<void> dismissRecommendation(String id, String conceptId);

  /// Cleanup old recommendations (older than specified days)
  ///
  /// Returns the number of deleted records
  Future<int> cleanupOldRecommendations({int daysOld = 90});
}
