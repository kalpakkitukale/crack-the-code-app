/// Historical record of recommendations for a quiz attempt
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crack_the_code/domain/entities/pedagogy/quiz_recommendation.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendation_status.dart';

part 'recommendations_history.freezed.dart';
part 'recommendations_history.g.dart';

@freezed
class RecommendationsHistory with _$RecommendationsHistory {
  const factory RecommendationsHistory({
    required String id,
    required String quizAttemptId,
    required String userId,
    required String subjectId,
    String? topicId,
    required AssessmentType assessmentType,
    // Recommendation data
    required List<QuizRecommendation> recommendations,
    required int totalRecommendations,
    required int criticalGaps,
    required int severeGaps,
    required int estimatedMinutesToFix,
    // Metadata
    required DateTime generatedAt,
    DateTime? viewedAt,
    DateTime? lastAccessedAt,
    @Default(0) int viewCount,
    // Learning path tracking
    String? learningPathId,
    @Default(false) bool learningPathStarted,
    DateTime? learningPathStartedAt,
    @Default(false) bool learningPathCompleted,
    DateTime? learningPathCompletedAt,
    // Video tracking
    @Default([]) List<String> viewedVideoIds,
    @Default([]) List<String> dismissedRecommendationIds,
  }) = _RecommendationsHistory;

  const RecommendationsHistory._();

  factory RecommendationsHistory.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsHistoryFromJson(json);

  /// Check if recommendations have been viewed
  bool get hasBeenViewed => viewedAt != null;

  /// Check if has learning path
  bool get hasLearningPath => learningPathId != null;

  /// Get age of recommendations
  Duration get age => DateTime.now().difference(generatedAt);

  /// Check if recommendations are outdated (>30 days)
  bool get isOutdated => age.inDays > 30;

  /// Check if recommendations are still relevant
  bool get isStillRelevant {
    // Outdated if >30 days
    if (isOutdated) return false;
    // Not relevant if learning path completed
    if (learningPathCompleted) return false;
    return true;
  }

  /// Get current status of recommendations
  RecommendationStatus get status {
    if (learningPathCompleted) return RecommendationStatus.completed;
    if (learningPathStarted) return RecommendationStatus.inProgress;
    if (isOutdated) return RecommendationStatus.outdated;
    if (hasBeenViewed) return RecommendationStatus.viewed;
    if (totalRecommendations > 0) return RecommendationStatus.available;
    return RecommendationStatus.none;
  }

  /// Get active (non-dismissed) recommendations
  List<QuizRecommendation> get activeRecommendations {
    return recommendations
        .where((r) => !dismissedRecommendationIds.contains(r.gap.conceptId))
        .toList();
  }

  /// Get count of active recommendations
  int get activeRecommendationCount => activeRecommendations.length;

  /// Check if a specific recommendation is dismissed
  bool isRecommendationDismissed(String conceptId) {
    return dismissedRecommendationIds.contains(conceptId);
  }

  /// Check if a specific video has been viewed
  bool isVideoViewed(String videoId) {
    return viewedVideoIds.contains(videoId);
  }

  /// Get all unique video IDs from recommendations
  List<String> get allVideoIds {
    return recommendations
        .expand((r) => r.recommendedVideos.map((v) => v.id))
        .toSet()
        .toList();
  }

  /// Get count of viewed videos
  int get viewedVideoCount => viewedVideoIds.length;

  /// Get formatted age string
  String get ageDisplay {
    if (age.inDays == 0) return 'Today';
    if (age.inDays == 1) return 'Yesterday';
    if (age.inDays < 7) return '${age.inDays} days ago';
    if (age.inDays < 30) return '${(age.inDays / 7).floor()} weeks ago';
    return '${(age.inDays / 30).floor()} months ago';
  }
}
