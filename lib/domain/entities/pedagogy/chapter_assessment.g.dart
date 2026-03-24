// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterAssessmentImpl _$$ChapterAssessmentImplFromJson(
  Map<String, dynamic> json,
) => _$ChapterAssessmentImpl(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  chapterId: json['chapterId'] as String,
  chapterName: json['chapterName'] as String,
  subjectId: json['subjectId'] as String,
  gradeLevel: (json['gradeLevel'] as num).toInt(),
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
      : ChapterAssessmentResult.fromJson(
          json['result'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$ChapterAssessmentImplToJson(
  _$ChapterAssessmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'chapterId': instance.chapterId,
  'chapterName': instance.chapterName,
  'subjectId': instance.subjectId,
  'gradeLevel': instance.gradeLevel,
  'questionIds': instance.questionIds,
  'answers': instance.answers,
  'currentQuestionIndex': instance.currentQuestionIndex,
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'result': instance.result,
};

_$ChapterAssessmentResultImpl _$$ChapterAssessmentResultImplFromJson(
  Map<String, dynamic> json,
) => _$ChapterAssessmentResultImpl(
  assessmentId: json['assessmentId'] as String,
  chapterId: json['chapterId'] as String,
  overallScore: (json['overallScore'] as num).toDouble(),
  conceptScores: (json['conceptScores'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  identifiedGaps: (json['identifiedGaps'] as List<dynamic>)
      .map((e) => ConceptGap.fromJson(e as Map<String, dynamic>))
      .toList(),
  estimatedFixMinutes: (json['estimatedFixMinutes'] as num).toInt(),
  recommendedVideoIds:
      (json['recommendedVideoIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] == null
      ? null
      : DateTime.parse(json['generatedAt'] as String),
);

Map<String, dynamic> _$$ChapterAssessmentResultImplToJson(
  _$ChapterAssessmentResultImpl instance,
) => <String, dynamic>{
  'assessmentId': instance.assessmentId,
  'chapterId': instance.chapterId,
  'overallScore': instance.overallScore,
  'conceptScores': instance.conceptScores,
  'identifiedGaps': instance.identifiedGaps,
  'estimatedFixMinutes': instance.estimatedFixMinutes,
  'recommendedVideoIds': instance.recommendedVideoIds,
  'generatedAt': instance.generatedAt?.toIso8601String(),
};
