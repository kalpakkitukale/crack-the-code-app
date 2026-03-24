// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationsHistoryImpl _$$RecommendationsHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationsHistoryImpl(
  id: json['id'] as String,
  quizAttemptId: json['quizAttemptId'] as String,
  userId: json['userId'] as String,
  subjectId: json['subjectId'] as String,
  topicId: json['topicId'] as String?,
  assessmentType: $enumDecode(_$AssessmentTypeEnumMap, json['assessmentType']),
  recommendations: (json['recommendations'] as List<dynamic>)
      .map((e) => QuizRecommendation.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalRecommendations: (json['totalRecommendations'] as num).toInt(),
  criticalGaps: (json['criticalGaps'] as num).toInt(),
  severeGaps: (json['severeGaps'] as num).toInt(),
  estimatedMinutesToFix: (json['estimatedMinutesToFix'] as num).toInt(),
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  viewedAt: json['viewedAt'] == null
      ? null
      : DateTime.parse(json['viewedAt'] as String),
  lastAccessedAt: json['lastAccessedAt'] == null
      ? null
      : DateTime.parse(json['lastAccessedAt'] as String),
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  learningPathId: json['learningPathId'] as String?,
  learningPathStarted: json['learningPathStarted'] as bool? ?? false,
  learningPathStartedAt: json['learningPathStartedAt'] == null
      ? null
      : DateTime.parse(json['learningPathStartedAt'] as String),
  learningPathCompleted: json['learningPathCompleted'] as bool? ?? false,
  learningPathCompletedAt: json['learningPathCompletedAt'] == null
      ? null
      : DateTime.parse(json['learningPathCompletedAt'] as String),
  viewedVideoIds:
      (json['viewedVideoIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  dismissedRecommendationIds:
      (json['dismissedRecommendationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$RecommendationsHistoryImplToJson(
  _$RecommendationsHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'quizAttemptId': instance.quizAttemptId,
  'userId': instance.userId,
  'subjectId': instance.subjectId,
  'topicId': instance.topicId,
  'assessmentType': _$AssessmentTypeEnumMap[instance.assessmentType]!,
  'recommendations': instance.recommendations,
  'totalRecommendations': instance.totalRecommendations,
  'criticalGaps': instance.criticalGaps,
  'severeGaps': instance.severeGaps,
  'estimatedMinutesToFix': instance.estimatedMinutesToFix,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'viewedAt': instance.viewedAt?.toIso8601String(),
  'lastAccessedAt': instance.lastAccessedAt?.toIso8601String(),
  'viewCount': instance.viewCount,
  'learningPathId': instance.learningPathId,
  'learningPathStarted': instance.learningPathStarted,
  'learningPathStartedAt': instance.learningPathStartedAt?.toIso8601String(),
  'learningPathCompleted': instance.learningPathCompleted,
  'learningPathCompletedAt': instance.learningPathCompletedAt
      ?.toIso8601String(),
  'viewedVideoIds': instance.viewedVideoIds,
  'dismissedRecommendationIds': instance.dismissedRecommendationIds,
};

const _$AssessmentTypeEnumMap = {
  AssessmentType.readiness: 'readiness',
  AssessmentType.knowledge: 'knowledge',
  AssessmentType.practice: 'practice',
};
