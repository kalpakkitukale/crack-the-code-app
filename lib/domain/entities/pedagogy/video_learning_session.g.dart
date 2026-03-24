// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_learning_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoLearningSessionImpl _$$VideoLearningSessionImplFromJson(
  Map<String, dynamic> json,
) => _$VideoLearningSessionImpl(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  videoId: json['videoId'] as String,
  conceptId: json['conceptId'] as String,
  preQuizCompleted: json['preQuizCompleted'] as bool? ?? false,
  preQuizScore: (json['preQuizScore'] as num?)?.toDouble(),
  preQuizGaps:
      (json['preQuizGaps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  checkpoints:
      (json['checkpoints'] as List<dynamic>?)
          ?.map((e) => VideoCheckpoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentCheckpointIndex:
      (json['currentCheckpointIndex'] as num?)?.toInt() ?? 0,
  checkpointsCorrect: (json['checkpointsCorrect'] as num?)?.toInt() ?? 0,
  checkpointsAttempted: (json['checkpointsAttempted'] as num?)?.toInt() ?? 0,
  watchDurationSeconds: (json['watchDurationSeconds'] as num?)?.toInt() ?? 0,
  videoCompleted: json['videoCompleted'] as bool? ?? false,
  postQuizCompleted: json['postQuizCompleted'] as bool? ?? false,
  postQuizScore: (json['postQuizScore'] as num?)?.toDouble(),
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$VideoLearningSessionImplToJson(
  _$VideoLearningSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'videoId': instance.videoId,
  'conceptId': instance.conceptId,
  'preQuizCompleted': instance.preQuizCompleted,
  'preQuizScore': instance.preQuizScore,
  'preQuizGaps': instance.preQuizGaps,
  'checkpoints': instance.checkpoints,
  'currentCheckpointIndex': instance.currentCheckpointIndex,
  'checkpointsCorrect': instance.checkpointsCorrect,
  'checkpointsAttempted': instance.checkpointsAttempted,
  'watchDurationSeconds': instance.watchDurationSeconds,
  'videoCompleted': instance.videoCompleted,
  'postQuizCompleted': instance.postQuizCompleted,
  'postQuizScore': instance.postQuizScore,
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};
