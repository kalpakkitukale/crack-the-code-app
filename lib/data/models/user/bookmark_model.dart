/// Bookmark data model for database operations
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';

/// Bookmark model for SQLite database
class BookmarkModel {
  final String id;
  final String videoId;
  final String profileId;
  final String title;
  final String? thumbnailUrl;
  final int? duration;
  final String? channelName;
  final int createdAt;

  const BookmarkModel({
    required this.id,
    required this.videoId,
    this.profileId = '',
    required this.title,
    this.thumbnailUrl,
    this.duration,
    this.channelName,
    required this.createdAt,
  });

  /// Convert from database map
  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map[BookmarksTable.columnId] as String,
      videoId: map[BookmarksTable.columnVideoId] as String,
      profileId: map[BookmarksTable.columnProfileId] as String? ?? '',
      title: map[BookmarksTable.columnTitle] as String,
      thumbnailUrl: map[BookmarksTable.columnThumbnailUrl] as String?,
      duration: map[BookmarksTable.columnDuration] as int?,
      channelName: map[BookmarksTable.columnChannelName] as String?,
      createdAt: map[BookmarksTable.columnCreatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      BookmarksTable.columnId: id,
      BookmarksTable.columnVideoId: videoId,
      BookmarksTable.columnProfileId: profileId,
      BookmarksTable.columnTitle: title,
      BookmarksTable.columnThumbnailUrl: thumbnailUrl,
      BookmarksTable.columnDuration: duration,
      BookmarksTable.columnChannelName: channelName,
      BookmarksTable.columnCreatedAt: createdAt,
    };
  }

  /// Convert to domain entity
  Bookmark toEntity() {
    return Bookmark(
      id: id,
      videoId: videoId,
      title: title,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      channelName: channelName,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }

  /// Create from domain entity
  factory BookmarkModel.fromEntity(Bookmark bookmark) {
    return BookmarkModel(
      id: bookmark.id,
      videoId: bookmark.videoId,
      title: bookmark.title,
      thumbnailUrl: bookmark.thumbnailUrl,
      duration: bookmark.duration,
      channelName: bookmark.channelName,
      createdAt: bookmark.createdAt.millisecondsSinceEpoch,
    );
  }
}
