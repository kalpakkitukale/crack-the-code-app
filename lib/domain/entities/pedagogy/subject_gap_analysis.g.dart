// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_gap_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubjectGapAnalysisImpl _$$SubjectGapAnalysisImplFromJson(
  Map<String, dynamic> json,
) => _$SubjectGapAnalysisImpl(
  studentId: json['studentId'] as String,
  subjectId: json['subjectId'] as String,
  subjectName: json['subjectName'] as String,
  targetGrade: (json['targetGrade'] as num).toInt(),
  overallReadiness: (json['overallReadiness'] as num).toDouble(),
  gradeBreakdown: (json['gradeBreakdown'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
  ),
  gaps: (json['gaps'] as List<dynamic>)
      .map((e) => ConceptGap.fromJson(e as Map<String, dynamic>))
      .toList(),
  estimatedFixMinutes: (json['estimatedFixMinutes'] as num).toInt(),
  analyzedAt: json['analyzedAt'] == null
      ? null
      : DateTime.parse(json['analyzedAt'] as String),
);

Map<String, dynamic> _$$SubjectGapAnalysisImplToJson(
  _$SubjectGapAnalysisImpl instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'subjectId': instance.subjectId,
  'subjectName': instance.subjectName,
  'targetGrade': instance.targetGrade,
  'overallReadiness': instance.overallReadiness,
  'gradeBreakdown': instance.gradeBreakdown.map(
    (k, e) => MapEntry(k.toString(), e),
  ),
  'gaps': instance.gaps,
  'estimatedFixMinutes': instance.estimatedFixMinutes,
  'analyzedAt': instance.analyzedAt?.toIso8601String(),
};
