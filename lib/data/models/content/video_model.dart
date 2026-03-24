/// Video data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';

part 'video_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoModel {
  final String id;
  final String title;
  final String description;
  final String youtubeId;
  final String youtubeUrl;
  final String thumbnailUrl;
  final int duration;
  final String durationDisplay;
  final String channelName;
  final String channelId;
  final String language;
  final String topicId;
  final String difficulty;
  final List<String> examRelevance;
  final double rating;
  final int viewCount;
  final List<String> tags;
  final String dateAdded;
  final String lastUpdated;

  const VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeId,
    required this.youtubeUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.durationDisplay,
    required this.channelName,
    required this.channelId,
    required this.language,
    required this.topicId,
    required this.difficulty,
    required this.examRelevance,
    required this.rating,
    required this.viewCount,
    required this.tags,
    required this.dateAdded,
    required this.lastUpdated,
  });

  /// Convert from JSON
  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);

  /// Convert to domain entity
  Video toEntity() {
    return Video(
      id: id,
      title: title,
      description: description,
      youtubeId: youtubeId,
      youtubeUrl: youtubeUrl,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      durationDisplay: durationDisplay,
      channelName: channelName,
      channelId: channelId,
      language: language,
      topicId: topicId,
      difficulty: difficulty,
      examRelevance: examRelevance,
      rating: rating,
      viewCount: viewCount,
      tags: tags,
      dateAdded: DateTime.parse(dateAdded),
      lastUpdated: DateTime.parse(lastUpdated),
    );
  }

  /// Create from domain entity
  factory VideoModel.fromEntity(Video video) {
    return VideoModel(
      id: video.id,
      title: video.title,
      description: video.description,
      youtubeId: video.youtubeId,
      youtubeUrl: video.youtubeUrl,
      thumbnailUrl: video.thumbnailUrl,
      duration: video.duration,
      durationDisplay: video.durationDisplay,
      channelName: video.channelName,
      channelId: video.channelId,
      language: video.language,
      topicId: video.topicId,
      difficulty: video.difficulty,
      examRelevance: video.examRelevance,
      rating: video.rating,
      viewCount: video.viewCount,
      tags: video.tags,
      dateAdded: video.dateAdded.toIso8601String(),
      lastUpdated: video.lastUpdated.toIso8601String(),
    );
  }
}
