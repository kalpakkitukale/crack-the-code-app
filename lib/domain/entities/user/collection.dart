/// Collection entity for organizing videos into playlists
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crack_the_code/domain/entities/user/collection_video.dart';

part 'collection.freezed.dart';

@freezed
class Collection with _$Collection {
  const factory Collection({
    required String id,
    required String name,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<CollectionVideo> videos,
  }) = _Collection;

  const Collection._();

  /// Get total number of videos
  int get videoCount => videos.length;

  /// Check if collection is empty
  bool get isEmpty => videos.isEmpty;

  /// Check if collection has videos
  bool get hasVideos => videos.isNotEmpty;

  /// Get total duration of all videos in seconds
  int get totalDuration {
    return videos.fold(0, (sum, video) => sum + (video.duration ?? 0));
  }

  /// Get formatted total duration
  String get formattedTotalDuration {
    final hours = totalDuration ~/ 3600;
    final minutes = (totalDuration % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours hr ${minutes} min';
    } else if (minutes > 0) {
      return '$minutes min';
    } else {
      return '${totalDuration} sec';
    }
  }

  /// Check if collection was recently updated (within last 24 hours)
  bool get isRecentlyUpdated {
    final now = DateTime.now();
    final dayAgo = now.subtract(const Duration(hours: 24));
    return updatedAt.isAfter(dayAgo);
  }

  /// Find video by ID
  CollectionVideo? findVideo(String videoId) {
    try {
      return videos.firstWhere((v) => v.videoId == videoId);
    } catch (e) {
      return null;
    }
  }

  /// Check if collection contains a specific video
  bool containsVideo(String videoId) {
    return videos.any((v) => v.videoId == videoId);
  }

  /// Get videos sorted by added date (newest first)
  List<CollectionVideo> get videosSortedByDate {
    final sortedVideos = List<CollectionVideo>.from(videos);
    sortedVideos.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return sortedVideos;
  }
}
