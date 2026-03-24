// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) => ChapterModel(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  topics: (json['topics'] as List<dynamic>)
      .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': instance.name,
      'description': instance.description,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
      'keywords': instance.keywords,
    };
