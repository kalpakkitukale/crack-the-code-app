// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterProgressImpl _$$ChapterProgressImplFromJson(
  Map<String, dynamic> json,
) => _$ChapterProgressImpl(
  chapterId: json['chapterId'] as String,
  chapterName: json['chapterName'] as String,
  description: json['description'] as String?,
  totalVideos: (json['totalVideos'] as num).toInt(),
  completedVideos: (json['completedVideos'] as num).toInt(),
  inProgressVideos: (json['inProgressVideos'] as num).toInt(),
  totalWatchTimeSeconds: (json['totalWatchTimeSeconds'] as num?)?.toInt() ?? 0,
  lastWatchedAt: json['lastWatchedAt'] == null
      ? null
      : DateTime.parse(json['lastWatchedAt'] as String),
);

Map<String, dynamic> _$$ChapterProgressImplToJson(
  _$ChapterProgressImpl instance,
) => <String, dynamic>{
  'chapterId': instance.chapterId,
  'chapterName': instance.chapterName,
  'description': instance.description,
  'totalVideos': instance.totalVideos,
  'completedVideos': instance.completedVideos,
  'inProgressVideos': instance.inProgressVideos,
  'totalWatchTimeSeconds': instance.totalWatchTimeSeconds,
  'lastWatchedAt': instance.lastWatchedAt?.toIso8601String(),
};
