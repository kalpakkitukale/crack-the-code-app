// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlossaryTermImpl _$$GlossaryTermImplFromJson(Map<String, dynamic> json) =>
    _$GlossaryTermImpl(
      id: json['id'] as String,
      term: json['term'] as String,
      definition: json['definition'] as String,
      pronunciation: json['pronunciation'] as String?,
      exampleUsage: json['exampleUsage'] as String?,
      chapterId: json['chapterId'] as String,
      segment: json['segment'] as String,
      difficulty:
          $enumDecodeNullable(_$TermDifficultyEnumMap, json['difficulty']) ??
          TermDifficulty.medium,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GlossaryTermImplToJson(_$GlossaryTermImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'term': instance.term,
      'definition': instance.definition,
      'pronunciation': instance.pronunciation,
      'exampleUsage': instance.exampleUsage,
      'chapterId': instance.chapterId,
      'segment': instance.segment,
      'difficulty': _$TermDifficultyEnumMap[instance.difficulty]!,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TermDifficultyEnumMap = {
  TermDifficulty.easy: 'easy',
  TermDifficulty.medium: 'medium',
  TermDifficulty.hard: 'hard',
};
