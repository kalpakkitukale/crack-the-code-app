// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubjectProgressImpl _$$SubjectProgressImplFromJson(
  Map<String, dynamic> json,
) => _$SubjectProgressImpl(
  subjectId: json['subjectId'] as String,
  subjectName: json['subjectName'] as String,
  description: json['description'] as String?,
  boardId: json['boardId'] as String?,
  totalVideos: (json['totalVideos'] as num).toInt(),
  completedVideos: (json['completedVideos'] as num).toInt(),
  inProgressVideos: (json['inProgressVideos'] as num).toInt(),
  totalChapters: (json['totalChapters'] as num).toInt(),
  completedChapters: (json['completedChapters'] as num).toInt(),
  totalWatchTimeSeconds: (json['totalWatchTimeSeconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SubjectProgressImplToJson(
  _$SubjectProgressImpl instance,
) => <String, dynamic>{
  'subjectId': instance.subjectId,
  'subjectName': instance.subjectName,
  'description': instance.description,
  'boardId': instance.boardId,
  'totalVideos': instance.totalVideos,
  'completedVideos': instance.completedVideos,
  'inProgressVideos': instance.inProgressVideos,
  'totalChapters': instance.totalChapters,
  'completedChapters': instance.completedChapters,
  'totalWatchTimeSeconds': instance.totalWatchTimeSeconds,
};
