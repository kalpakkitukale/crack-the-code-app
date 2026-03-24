/// Progress data model for database operations
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';

/// Progress model for SQLite database
class ProgressModel {
  final String id;
  final String videoId;
  final String profileId;
  final String? title;
  final String? channelName;
  final String? thumbnailUrl;
  final int watchDuration;
  final int totalDuration;
  final bool completed;
  final int lastWatched;

  const ProgressModel({
    required this.id,
    required this.videoId,
    this.profileId = '',
    this.title,
    this.channelName,
    this.thumbnailUrl,
    required this.watchDuration,
    required this.totalDuration,
    required this.completed,
    required this.lastWatched,
  });

  /// Convert from database map
  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      id: map[ProgressTable.columnId] as String,
      videoId: map[ProgressTable.columnVideoId] as String,
      profileId: map[ProgressTable.columnProfileId] as String? ?? '',
      title: map[ProgressTable.columnTitle] as String?,
      channelName: map[ProgressTable.columnChannelName] as String?,
      thumbnailUrl: map[ProgressTable.columnThumbnailUrl] as String?,
      watchDuration: map[ProgressTable.columnWatchDuration] as int,
      totalDuration: map[ProgressTable.columnTotalDuration] as int,
      completed: (map[ProgressTable.columnCompleted] as int) == 1,
      lastWatched: map[ProgressTable.columnLastWatched] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      ProgressTable.columnId: id,
      ProgressTable.columnVideoId: videoId,
      ProgressTable.columnProfileId: profileId,
      ProgressTable.columnTitle: title,
      ProgressTable.columnChannelName: channelName,
      ProgressTable.columnThumbnailUrl: thumbnailUrl,
      ProgressTable.columnWatchDuration: watchDuration,
      ProgressTable.columnTotalDuration: totalDuration,
      ProgressTable.columnCompleted: completed ? 1 : 0,
      ProgressTable.columnLastWatched: lastWatched,
    };
  }

  /// Convert to domain entity
  Progress toEntity() {
    return Progress(
      id: id,
      videoId: videoId,
      title: title,
      channelName: channelName,
      thumbnailUrl: thumbnailUrl,
      watchDuration: watchDuration,
      totalDuration: totalDuration,
      completed: completed,
      lastWatched: DateTime.fromMillisecondsSinceEpoch(lastWatched),
    );
  }

  /// Create from domain entity
  factory ProgressModel.fromEntity(Progress progress) {
    return ProgressModel(
      id: progress.id,
      videoId: progress.videoId,
      title: progress.title,
      channelName: progress.channelName,
      thumbnailUrl: progress.thumbnailUrl,
      watchDuration: progress.watchDuration,
      totalDuration: progress.totalDuration,
      completed: progress.completed,
      lastWatched: progress.lastWatched.millisecondsSinceEpoch,
    );
  }
}
