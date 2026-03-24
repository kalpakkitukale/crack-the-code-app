// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoQuestionImpl _$$VideoQuestionImplFromJson(Map<String, dynamic> json) =>
    _$VideoQuestionImpl(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      profileId: json['profileId'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String?,
      status:
          $enumDecodeNullable(_$QuestionStatusEnumMap, json['status']) ??
          QuestionStatus.pending,
      timestampSeconds: (json['timestampSeconds'] as num?)?.toInt(),
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VideoQuestionImplToJson(_$VideoQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'profileId': instance.profileId,
      'question': instance.question,
      'answer': instance.answer,
      'status': _$QuestionStatusEnumMap[instance.status]!,
      'timestampSeconds': instance.timestampSeconds,
      'upvotes': instance.upvotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$QuestionStatusEnumMap = {
  QuestionStatus.pending: 'pending',
  QuestionStatus.answered: 'answered',
  QuestionStatus.rejected: 'rejected',
};
