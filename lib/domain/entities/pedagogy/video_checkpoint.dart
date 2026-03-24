/// VideoCheckpoint entity for in-video learning checkpoints
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_checkpoint.freezed.dart';
part 'video_checkpoint.g.dart';

@freezed
class VideoCheckpoint with _$VideoCheckpoint {
  const factory VideoCheckpoint({
    required String id,
    required String videoId,
    required int timestampSeconds,
    required String questionId,
    required int replayStartSeconds,
    required int replayEndSeconds,
    @Default(false) bool completed,
    bool? answeredCorrectly,
    DateTime? answeredAt,
  }) = _VideoCheckpoint;

  const VideoCheckpoint._();

  factory VideoCheckpoint.fromJson(Map<String, dynamic> json) =>
      _$VideoCheckpointFromJson(json);

  /// Check if checkpoint needs replay (answered incorrectly)
  bool get needsReplay => answeredCorrectly == false;

  /// Get formatted timestamp (MM:SS)
  String get formattedTimestamp {
    final minutes = timestampSeconds ~/ 60;
    final seconds = timestampSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get replay section duration
  int get replaySectionDuration => replayEndSeconds - replayStartSeconds;

  /// Get formatted replay range
  String get formattedReplayRange {
    final startMin = replayStartSeconds ~/ 60;
    final startSec = replayStartSeconds % 60;
    final endMin = replayEndSeconds ~/ 60;
    final endSec = replayEndSeconds % 60;
    return '${startMin.toString().padLeft(2, '0')}:${startSec.toString().padLeft(2, '0')} - '
        '${endMin.toString().padLeft(2, '0')}:${endSec.toString().padLeft(2, '0')}';
  }
}
