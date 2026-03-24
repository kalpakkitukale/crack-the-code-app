/// CuratedVideo entity representing top-ranked videos per topic
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'curated_video.freezed.dart';

@freezed
class CuratedVideo with _$CuratedVideo {
  const factory CuratedVideo({
    required String id,
    required String videoId,
    required String topicId,
    required int rank,
    required double qualityScore,
    required CurationMetrics metrics,
    required DateTime curatedAt,
    required DateTime lastUpdated,
    @Default(true) bool isActive,
    String? curatedBy,
    String? notes,
  }) = _CuratedVideo;

  const CuratedVideo._();

  /// Check if this is the top-ranked video
  bool get isTopRanked => rank == 1;

  /// Check if this is in top 3
  bool get isInTopThree => rank <= 3;

  /// Get rank display (1st, 2nd, 3rd)
  String get rankDisplay {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${rank}th';
    }
  }

  /// Get quality rating (1-5 stars)
  int get qualityRating => (qualityScore / 20).ceil().clamp(1, 5);

  /// Get quality rating stars
  String get qualityStars => '★' * qualityRating + '☆' * (5 - qualityRating);

  /// Check if curation is recent (within 30 days)
  bool get isRecentlyCurated {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return curatedAt.isAfter(thirtyDaysAgo);
  }

  /// Get days since curation
  int get daysSinceCuration => DateTime.now().difference(curatedAt).inDays;

  /// Get formatted curation date
  String get formattedCurationDate {
    final now = DateTime.now();
    final difference = now.difference(curatedAt);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
    return '${(difference.inDays / 30).floor()} months ago';
  }
}

/// Curation metrics for video quality assessment
@freezed
class CurationMetrics with _$CurationMetrics {
  const factory CurationMetrics({
    required double contentQuality,
    required double audioQuality,
    required double videoQuality,
    required double explanationClarity,
    required double studentEngagement,
    @Default(0) int studentViews,
    @Default(0) int studentLikes,
    @Default(0) int studentCompletions,
    @Default(0.0) double averageWatchPercentage,
    @Default(0.0) double averageQuizScore,
  }) = _CurationMetrics;

  const CurationMetrics._();

  /// Get overall quality score (0-100)
  double get overallQuality {
    return (contentQuality +
            audioQuality +
            videoQuality +
            explanationClarity +
            studentEngagement) /
        5;
  }

  /// Get engagement rate
  double get engagementRate {
    if (studentViews == 0) return 0.0;
    return (studentLikes / studentViews) * 100;
  }

  /// Get completion rate
  double get completionRate {
    if (studentViews == 0) return 0.0;
    return (studentCompletions / studentViews) * 100;
  }

  /// Get quality category
  QualityCategory get qualityCategory {
    if (overallQuality >= 90) return QualityCategory.excellent;
    if (overallQuality >= 75) return QualityCategory.good;
    if (overallQuality >= 60) return QualityCategory.average;
    return QualityCategory.poor;
  }

  /// Check if metrics indicate high quality
  bool get isHighQuality => overallQuality >= 80;

  /// Check if engagement is strong
  bool get hasStrongEngagement =>
      engagementRate >= 70 && completionRate >= 80;

  /// Get weakest aspect
  String get weakestAspect {
    final scores = {
      'Content': contentQuality,
      'Audio': audioQuality,
      'Video': videoQuality,
      'Clarity': explanationClarity,
      'Engagement': studentEngagement,
    };
    return scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  /// Get strongest aspect
  String get strongestAspect {
    final scores = {
      'Content': contentQuality,
      'Audio': audioQuality,
      'Video': videoQuality,
      'Clarity': explanationClarity,
      'Engagement': studentEngagement,
    };
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

/// Quality category enum
enum QualityCategory {
  excellent,
  good,
  average,
  poor;

  String get displayName {
    switch (this) {
      case QualityCategory.excellent:
        return 'Excellent';
      case QualityCategory.good:
        return 'Good';
      case QualityCategory.average:
        return 'Average';
      case QualityCategory.poor:
        return 'Poor';
    }
  }

  String get emoji {
    switch (this) {
      case QualityCategory.excellent:
        return '🌟';
      case QualityCategory.good:
        return '👍';
      case QualityCategory.average:
        return '👌';
      case QualityCategory.poor:
        return '⚠️';
    }
  }
}
