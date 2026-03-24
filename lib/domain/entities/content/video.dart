/// Video entity representing an educational video
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';
part 'video.g.dart';

@freezed
class Video with _$Video {
  const factory Video({
    required String id,
    required String title,
    required String description,
    required String youtubeId,
    required String youtubeUrl,
    required String thumbnailUrl,
    required int duration,
    required String durationDisplay,
    required String channelName,
    required String channelId,
    required String language,
    required String topicId,
    required String difficulty,
    required List<String> examRelevance,
    required double rating,
    required int viewCount,
    required List<String> tags,
    required DateTime dateAdded,
    required DateTime lastUpdated,
  }) = _Video;

  const Video._();

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  /// Check if video is in Hindi
  bool get isHindi => language.toLowerCase() == 'hindi';

  /// Check if video is in English
  bool get isEnglish => language.toLowerCase() == 'english';

  /// Check if video is relevant for a specific exam
  bool isRelevantForExam(String exam) {
    return examRelevance.any((e) => e.toLowerCase() == exam.toLowerCase());
  }

  /// Get formatted duration (HH:MM:SS or MM:SS)
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Get formatted view count (1.2M, 850K, etc.)
  String get formattedViewCount {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(0)}K';
    } else {
      return viewCount.toString();
    }
  }

  /// Check if video is highly rated (>= 4.5)
  bool get isHighlyRated => rating >= 4.5;

  /// Check if video is popular (>= 1M views)
  bool get isPopular => viewCount >= 1000000;

  /// Check if video has a specific tag
  bool hasTag(String tag) {
    return tags.any((t) => t.toLowerCase() == tag.toLowerCase());
  }
}
