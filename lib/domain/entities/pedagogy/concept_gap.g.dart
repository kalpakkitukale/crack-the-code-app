// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_gap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConceptGapImpl _$$ConceptGapImplFromJson(Map<String, dynamic> json) =>
    _$ConceptGapImpl(
      id: json['id'] as String,
      conceptId: json['conceptId'] as String,
      conceptName: json['conceptName'] as String,
      gradeLevel: (json['gradeLevel'] as num).toInt(),
      currentMastery: (json['currentMastery'] as num).toDouble(),
      priorityScore: (json['priorityScore'] as num).toInt(),
      blockedConcepts: (json['blockedConcepts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendedVideoIds: (json['recommendedVideoIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      estimatedFixMinutes: (json['estimatedFixMinutes'] as num).toInt(),
      subject: json['subject'] as String?,
      chapterId: json['chapterId'] as String?,
    );

Map<String, dynamic> _$$ConceptGapImplToJson(_$ConceptGapImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conceptId': instance.conceptId,
      'conceptName': instance.conceptName,
      'gradeLevel': instance.gradeLevel,
      'currentMastery': instance.currentMastery,
      'priorityScore': instance.priorityScore,
      'blockedConcepts': instance.blockedConcepts,
      'recommendedVideoIds': instance.recommendedVideoIds,
      'estimatedFixMinutes': instance.estimatedFixMinutes,
      'subject': instance.subject,
      'chapterId': instance.chapterId,
    };
