// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreAssessmentImpl _$$PreAssessmentImplFromJson(
  Map<String, dynamic> json,
) => _$PreAssessmentImpl(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  subjectId: json['subjectId'] as String,
  targetGrade: (json['targetGrade'] as num).toInt(),
  currentPhase: $enumDecode(_$PreAssessmentPhaseEnumMap, json['currentPhase']),
  questionIds:
      (json['questionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  answers:
      (json['answers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  currentQuestionIndex: (json['currentQuestionIndex'] as num?)?.toInt() ?? 0,
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  result: json['result'] == null
      ? null
      : PreAssessmentResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PreAssessmentImplToJson(_$PreAssessmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'subjectId': instance.subjectId,
      'targetGrade': instance.targetGrade,
      'currentPhase': _$PreAssessmentPhaseEnumMap[instance.currentPhase]!,
      'questionIds': instance.questionIds,
      'answers': instance.answers,
      'currentQuestionIndex': instance.currentQuestionIndex,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'result': instance.result,
    };

const _$PreAssessmentPhaseEnumMap = {
  PreAssessmentPhase.quickScreening: 'quickScreening',
  PreAssessmentPhase.deepDive: 'deepDive',
  PreAssessmentPhase.boundaryDetection: 'boundaryDetection',
};

_$PreAssessmentResultImpl _$$PreAssessmentResultImplFromJson(
  Map<String, dynamic> json,
) => _$PreAssessmentResultImpl(
  assessmentId: json['assessmentId'] as String,
  overallReadiness: (json['overallReadiness'] as num).toDouble(),
  gradeScores: (json['gradeScores'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
  ),
  identifiedGaps: (json['identifiedGaps'] as List<dynamic>)
      .map((e) => ConceptGap.fromJson(e as Map<String, dynamic>))
      .toList(),
  estimatedFixMinutes: (json['estimatedFixMinutes'] as num).toInt(),
  generatedAt: json['generatedAt'] == null
      ? null
      : DateTime.parse(json['generatedAt'] as String),
);

Map<String, dynamic> _$$PreAssessmentResultImplToJson(
  _$PreAssessmentResultImpl instance,
) => <String, dynamic>{
  'assessmentId': instance.assessmentId,
  'overallReadiness': instance.overallReadiness,
  'gradeScores': instance.gradeScores.map((k, e) => MapEntry(k.toString(), e)),
  'identifiedGaps': instance.identifiedGaps,
  'estimatedFixMinutes': instance.estimatedFixMinutes,
  'generatedAt': instance.generatedAt?.toIso8601String(),
};
