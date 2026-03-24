// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizRecommendationImpl _$$QuizRecommendationImplFromJson(
  Map<String, dynamic> json,
) => _$QuizRecommendationImpl(
  gap: ConceptGap.fromJson(json['gap'] as Map<String, dynamic>),
  recommendedVideos: (json['recommendedVideos'] as List<dynamic>)
      .map((e) => Video.fromJson(e as Map<String, dynamic>))
      .toList(),
  topicName: json['topicName'] as String,
  estimatedFixMinutes: (json['estimatedFixMinutes'] as num).toInt(),
  dismissed: json['dismissed'] as bool? ?? false,
  acted: json['acted'] as bool? ?? false,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
);

Map<String, dynamic> _$$QuizRecommendationImplToJson(
  _$QuizRecommendationImpl instance,
) => <String, dynamic>{
  'gap': instance.gap,
  'recommendedVideos': instance.recommendedVideos,
  'topicName': instance.topicName,
  'estimatedFixMinutes': instance.estimatedFixMinutes,
  'dismissed': instance.dismissed,
  'acted': instance.acted,
  'generatedAt': instance.generatedAt.toIso8601String(),
};

_$RecommendationsBundleImpl _$$RecommendationsBundleImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationsBundleImpl(
  quizResultId: json['quizResultId'] as String,
  assessmentType: $enumDecode(_$AssessmentTypeEnumMap, json['assessmentType']),
  recommendations: (json['recommendations'] as List<dynamic>)
      .map((e) => QuizRecommendation.fromJson(e as Map<String, dynamic>))
      .toList(),
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  totalEstimatedMinutes: (json['totalEstimatedMinutes'] as num).toInt(),
  subjectName: json['subjectName'] as String?,
  quizScore: (json['quizScore'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$RecommendationsBundleImplToJson(
  _$RecommendationsBundleImpl instance,
) => <String, dynamic>{
  'quizResultId': instance.quizResultId,
  'assessmentType': _$AssessmentTypeEnumMap[instance.assessmentType]!,
  'recommendations': instance.recommendations,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'totalEstimatedMinutes': instance.totalEstimatedMinutes,
  'subjectName': instance.subjectName,
  'quizScore': instance.quizScore,
};

const _$AssessmentTypeEnumMap = {
  AssessmentType.readiness: 'readiness',
  AssessmentType.knowledge: 'knowledge',
  AssessmentType.practice: 'practice',
};
