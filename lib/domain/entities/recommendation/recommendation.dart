/// Recommendation entity for personalized learning suggestions
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation.freezed.dart';

@freezed
class Recommendation with _$Recommendation {
  const factory Recommendation({
    required String id,
    required String studentId,
    required RecommendationType type,
    required String entityId,
    required String entityType,
    required String title,
    required String description,
    required double confidenceScore,
    required List<String> reasons,
    required DateTime generatedAt,
    @Default(false) bool dismissed,
    @Default(false) bool acted,
    DateTime? dismissedAt,
    DateTime? actedAt,
    Map<String, dynamic>? metadata,
  }) = _Recommendation;

  const Recommendation._();

  /// Check if recommendation is fresh (< 24 hours)
  bool get isFresh {
    final twentyFourHoursAgo =
        DateTime.now().subtract(const Duration(hours: 24));
    return generatedAt.isAfter(twentyFourHoursAgo);
  }

  /// Check if recommendation is stale (> 7 days)
  bool get isStale {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return generatedAt.isBefore(sevenDaysAgo);
  }

  /// Get hours since generation
  int get hoursSinceGeneration =>
      DateTime.now().difference(generatedAt).inHours;

  /// Get confidence level
  ConfidenceLevel get confidenceLevel {
    if (confidenceScore >= 0.8) return ConfidenceLevel.high;
    if (confidenceScore >= 0.6) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }

  /// Get priority score (0-100)
  int get priorityScore {
    var score = (confidenceScore * 100).toInt();

    // Boost priority for certain types
    if (type == RecommendationType.weakAreaReview) score += 10;
    if (type == RecommendationType.nextTopic) score += 5;

    // Reduce for stale recommendations
    if (isStale) score -= 20;

    return score.clamp(0, 100);
  }

  /// Get formatted generation date
  String get formattedGenerationDate {
    final now = DateTime.now();
    final difference = now.difference(generatedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    }
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${(difference.inDays / 7).floor()} weeks ago';
  }

  /// Get primary reason
  String? get primaryReason => reasons.isNotEmpty ? reasons.first : null;

  /// Check if recommendation is active
  bool get isActive => !dismissed && !acted;
}

/// Recommendation type enum
enum RecommendationType {
  nextTopic,
  weakAreaReview,
  practiceQuiz,
  videoRewatch,
  conceptRevision,
  advancedTopic,
  peerComparison,
  streakMaintenance,
  achievementUnlock;

  String get displayName {
    switch (this) {
      case RecommendationType.nextTopic:
        return 'Next Topic';
      case RecommendationType.weakAreaReview:
        return 'Weak Area Review';
      case RecommendationType.practiceQuiz:
        return 'Practice Quiz';
      case RecommendationType.videoRewatch:
        return 'Video Rewatch';
      case RecommendationType.conceptRevision:
        return 'Concept Revision';
      case RecommendationType.advancedTopic:
        return 'Advanced Topic';
      case RecommendationType.peerComparison:
        return 'Peer Comparison';
      case RecommendationType.streakMaintenance:
        return 'Streak Maintenance';
      case RecommendationType.achievementUnlock:
        return 'Achievement Unlock';
    }
  }

  String get icon {
    switch (this) {
      case RecommendationType.nextTopic:
        return '➡️';
      case RecommendationType.weakAreaReview:
        return '⚠️';
      case RecommendationType.practiceQuiz:
        return '📝';
      case RecommendationType.videoRewatch:
        return '🔄';
      case RecommendationType.conceptRevision:
        return '📚';
      case RecommendationType.advancedTopic:
        return '🚀';
      case RecommendationType.peerComparison:
        return '👥';
      case RecommendationType.streakMaintenance:
        return '🔥';
      case RecommendationType.achievementUnlock:
        return '🏆';
    }
  }
}

/// Confidence level enum
enum ConfidenceLevel {
  high,
  medium,
  low;

  String get displayName {
    switch (this) {
      case ConfidenceLevel.high:
        return 'High Confidence';
      case ConfidenceLevel.medium:
        return 'Medium Confidence';
      case ConfidenceLevel.low:
        return 'Low Confidence';
    }
  }
}
