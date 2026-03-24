// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_checkpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoCheckpointImpl _$$VideoCheckpointImplFromJson(
  Map<String, dynamic> json,
) => _$VideoCheckpointImpl(
  id: json['id'] as String,
  videoId: json['videoId'] as String,
  timestampSeconds: (json['timestampSeconds'] as num).toInt(),
  questionId: json['questionId'] as String,
  replayStartSeconds: (json['replayStartSeconds'] as num).toInt(),
  replayEndSeconds: (json['replayEndSeconds'] as num).toInt(),
  completed: json['completed'] as bool? ?? false,
  answeredCorrectly: json['answeredCorrectly'] as bool?,
  answeredAt: json['answeredAt'] == null
      ? null
      : DateTime.parse(json['answeredAt'] as String),
);

Map<String, dynamic> _$$VideoCheckpointImplToJson(
  _$VideoCheckpointImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'videoId': instance.videoId,
  'timestampSeconds': instance.timestampSeconds,
  'questionId': instance.questionId,
  'replayStartSeconds': instance.replayStartSeconds,
  'replayEndSeconds': instance.replayEndSeconds,
  'completed': instance.completed,
  'answeredCorrectly': instance.answeredCorrectly,
  'answeredAt': instance.answeredAt?.toIso8601String(),
};
