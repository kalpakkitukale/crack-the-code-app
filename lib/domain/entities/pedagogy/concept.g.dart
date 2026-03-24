// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConceptImpl _$$ConceptImplFromJson(Map<String, dynamic> json) =>
    _$ConceptImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      gradeLevel: (json['gradeLevel'] as num).toInt(),
      subject: json['subject'] as String,
      chapterId: json['chapterId'] as String,
      prerequisiteIds: (json['prerequisiteIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dependentIds: (json['dependentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      videoIds: (json['videoIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      questionIds: (json['questionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 15,
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ConceptImplToJson(_$ConceptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gradeLevel': instance.gradeLevel,
      'subject': instance.subject,
      'chapterId': instance.chapterId,
      'prerequisiteIds': instance.prerequisiteIds,
      'dependentIds': instance.dependentIds,
      'videoIds': instance.videoIds,
      'questionIds': instance.questionIds,
      'estimatedMinutes': instance.estimatedMinutes,
      'difficulty': instance.difficulty,
      'keywords': instance.keywords,
    };
