// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_mastery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConceptMasteryImpl _$$ConceptMasteryImplFromJson(Map<String, dynamic> json) =>
    _$ConceptMasteryImpl(
      id: json['id'] as String,
      conceptId: json['conceptId'] as String,
      studentId: json['studentId'] as String,
      masteryScore: (json['masteryScore'] as num).toDouble(),
      level: $enumDecode(_$MasteryLevelEnumMap, json['level']),
      lastAssessed: DateTime.parse(json['lastAssessed'] as String),
      totalAttempts: (json['totalAttempts'] as num).toInt(),
      isGap: json['isGap'] as bool? ?? false,
      nextReviewDate: json['nextReviewDate'] == null
          ? null
          : DateTime.parse(json['nextReviewDate'] as String),
      reviewStreak: (json['reviewStreak'] as num?)?.toInt() ?? 0,
      preQuizScore: (json['preQuizScore'] as num?)?.toDouble(),
      checkpointScore: (json['checkpointScore'] as num?)?.toDouble(),
      postQuizScore: (json['postQuizScore'] as num?)?.toDouble(),
      practiceScore: (json['practiceScore'] as num?)?.toDouble(),
      spacedRepScore: (json['spacedRepScore'] as num?)?.toDouble(),
      gradeLevel: (json['gradeLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ConceptMasteryImplToJson(
  _$ConceptMasteryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'conceptId': instance.conceptId,
  'studentId': instance.studentId,
  'masteryScore': instance.masteryScore,
  'level': _$MasteryLevelEnumMap[instance.level]!,
  'lastAssessed': instance.lastAssessed.toIso8601String(),
  'totalAttempts': instance.totalAttempts,
  'isGap': instance.isGap,
  'nextReviewDate': instance.nextReviewDate?.toIso8601String(),
  'reviewStreak': instance.reviewStreak,
  'preQuizScore': instance.preQuizScore,
  'checkpointScore': instance.checkpointScore,
  'postQuizScore': instance.postQuizScore,
  'practiceScore': instance.practiceScore,
  'spacedRepScore': instance.spacedRepScore,
  'gradeLevel': instance.gradeLevel,
};

const _$MasteryLevelEnumMap = {
  MasteryLevel.notLearned: 'notLearned',
  MasteryLevel.learning: 'learning',
  MasteryLevel.familiar: 'familiar',
  MasteryLevel.proficient: 'proficient',
  MasteryLevel.mastered: 'mastered',
};
