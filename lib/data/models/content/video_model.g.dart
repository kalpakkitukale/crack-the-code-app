// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  youtubeId: json['youtubeId'] as String,
  youtubeUrl: json['youtubeUrl'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  duration: (json['duration'] as num).toInt(),
  durationDisplay: json['durationDisplay'] as String,
  channelName: json['channelName'] as String,
  channelId: json['channelId'] as String,
  language: json['language'] as String,
  topicId: json['topicId'] as String,
  difficulty: json['difficulty'] as String,
  examRelevance: (json['examRelevance'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  rating: (json['rating'] as num).toDouble(),
  viewCount: (json['viewCount'] as num).toInt(),
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  dateAdded: json['dateAdded'] as String,
  lastUpdated: json['lastUpdated'] as String,
);

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'youtubeId': instance.youtubeId,
      'youtubeUrl': instance.youtubeUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'duration': instance.duration,
      'durationDisplay': instance.durationDisplay,
      'channelName': instance.channelName,
      'channelId': instance.channelId,
      'language': instance.language,
      'topicId': instance.topicId,
      'difficulty': instance.difficulty,
      'examRelevance': instance.examRelevance,
      'rating': instance.rating,
      'viewCount': instance.viewCount,
      'tags': instance.tags,
      'dateAdded': instance.dateAdded,
      'lastUpdated': instance.lastUpdated,
    };
