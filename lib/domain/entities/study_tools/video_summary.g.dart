// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoSummaryImpl _$$VideoSummaryImplFromJson(Map<String, dynamic> json) =>
    _$VideoSummaryImpl(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      content: json['content'] as String,
      keyPoints:
          (json['keyPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      source:
          $enumDecodeNullable(_$SummarySourceEnumMap, json['source']) ??
          SummarySource.manual,
      segment: json['segment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VideoSummaryImplToJson(_$VideoSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'content': instance.content,
      'keyPoints': instance.keyPoints,
      'source': _$SummarySourceEnumMap[instance.source]!,
      'segment': instance.segment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$SummarySourceEnumMap = {
  SummarySource.manual: 'manual',
  SummarySource.ai: 'ai',
};
