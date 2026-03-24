// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterSummaryImpl _$$ChapterSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ChapterSummaryImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      subjectId: json['subjectId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      keyPoints:
          (json['keyPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      learningObjectives:
          (json['learningObjectives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      source:
          $enumDecodeNullable(_$SummarySourceEnumMap, json['source']) ??
          SummarySource.manual,
      segment: json['segment'] as String,
      estimatedReadTimeMinutes:
          (json['estimatedReadTimeMinutes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChapterSummaryImplToJson(
  _$ChapterSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'chapterId': instance.chapterId,
  'subjectId': instance.subjectId,
  'title': instance.title,
  'content': instance.content,
  'keyPoints': instance.keyPoints,
  'learningObjectives': instance.learningObjectives,
  'source': _$SummarySourceEnumMap[instance.source]!,
  'segment': instance.segment,
  'estimatedReadTimeMinutes': instance.estimatedReadTimeMinutes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$SummarySourceEnumMap = {
  SummarySource.manual: 'manual',
  SummarySource.ai: 'ai',
};
