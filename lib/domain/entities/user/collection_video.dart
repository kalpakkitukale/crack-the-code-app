/// CollectionVideo entity representing a video within a collection
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_video.freezed.dart';

@freezed
class CollectionVideo with _$CollectionVideo {
  const factory CollectionVideo({
    required String id,
    required String collectionId,
    required String videoId,
    required String videoTitle,
    String? thumbnailUrl,
    int? duration,
    String? channelName,
    required DateTime addedAt,
  }) = _CollectionVideo;

  const CollectionVideo._();

  /// Get formatted duration
  String? get formattedDuration {
    if (duration == null) return null;

    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    final seconds = duration! % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Check if video was recently added (within last 24 hours)
  bool get isRecentlyAdded {
    final now = DateTime.now();
    final dayAgo = now.subtract(const Duration(hours: 24));
    return addedAt.isAfter(dayAgo);
  }
}
