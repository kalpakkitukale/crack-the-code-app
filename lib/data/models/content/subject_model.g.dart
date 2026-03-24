// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) => SubjectModel(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
  boardId: json['boardId'] as String,
  classId: json['classId'] as String,
  streamId: json['streamId'] as String,
  totalChapters: (json['totalChapters'] as num).toInt(),
  chapters: (json['chapters'] as List<dynamic>)
      .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$SubjectModelToJson(SubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'boardId': instance.boardId,
      'classId': instance.classId,
      'streamId': instance.streamId,
      'totalChapters': instance.totalChapters,
      'chapters': instance.chapters.map((e) => e.toJson()).toList(),
      'keywords': instance.keywords,
    };
