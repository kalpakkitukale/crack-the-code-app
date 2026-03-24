/// Collection video data model for database operations
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/user/collection_video.dart';

/// Collection video model for SQLite database
class CollectionVideoModel {
  final String id;
  final String collectionId;
  final String videoId;
  final String videoTitle;
  final String? thumbnailUrl;
  final int? duration;
  final String? channelName;
  final int addedAt;

  const CollectionVideoModel({
    required this.id,
    required this.collectionId,
    required this.videoId,
    required this.videoTitle,
    this.thumbnailUrl,
    this.duration,
    this.channelName,
    required this.addedAt,
  });

  /// Convert from database map
  factory CollectionVideoModel.fromMap(Map<String, dynamic> map) {
    return CollectionVideoModel(
      id: map[CollectionVideosTable.columnId] as String,
      collectionId: map[CollectionVideosTable.columnCollectionId] as String,
      videoId: map[CollectionVideosTable.columnVideoId] as String,
      videoTitle: map[CollectionVideosTable.columnVideoTitle] as String,
      thumbnailUrl: map[CollectionVideosTable.columnThumbnailUrl] as String?,
      duration: map[CollectionVideosTable.columnDuration] as int?,
      channelName: map[CollectionVideosTable.columnChannelName] as String?,
      addedAt: map[CollectionVideosTable.columnAddedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      CollectionVideosTable.columnId: id,
      CollectionVideosTable.columnCollectionId: collectionId,
      CollectionVideosTable.columnVideoId: videoId,
      CollectionVideosTable.columnVideoTitle: videoTitle,
      CollectionVideosTable.columnThumbnailUrl: thumbnailUrl,
      CollectionVideosTable.columnDuration: duration,
      CollectionVideosTable.columnChannelName: channelName,
      CollectionVideosTable.columnAddedAt: addedAt,
    };
  }

  /// Convert to domain entity
  CollectionVideo toEntity() {
    return CollectionVideo(
      id: id,
      collectionId: collectionId,
      videoId: videoId,
      videoTitle: videoTitle,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      channelName: channelName,
      addedAt: DateTime.fromMillisecondsSinceEpoch(addedAt),
    );
  }

  /// Create from domain entity
  factory CollectionVideoModel.fromEntity(CollectionVideo video) {
    return CollectionVideoModel(
      id: video.id,
      collectionId: video.collectionId,
      videoId: video.videoId,
      videoTitle: video.videoTitle,
      thumbnailUrl: video.thumbnailUrl,
      duration: video.duration,
      channelName: video.channelName,
      addedAt: video.addedAt.millisecondsSinceEpoch,
    );
  }
}
