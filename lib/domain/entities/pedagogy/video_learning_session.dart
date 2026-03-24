/// VideoLearningSession entity tracking complete video learning flow
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crack_the_code/domain/entities/pedagogy/video_checkpoint.dart';

part 'video_learning_session.freezed.dart';
part 'video_learning_session.g.dart';

@freezed
class VideoLearningSession with _$VideoLearningSession {
  const factory VideoLearningSession({
    required String id,
    required String studentId,
    required String videoId,
    required String conceptId,

    // Pre-Quiz state
    @Default(false) bool preQuizCompleted,
    double? preQuizScore,
    @Default([]) List<String> preQuizGaps,

    // Checkpoints state
    @Default([]) List<VideoCheckpoint> checkpoints,
    @Default(0) int currentCheckpointIndex,
    @Default(0) int checkpointsCorrect,
    @Default(0) int checkpointsAttempted,

    // Video watching state
    @Default(0) int watchDurationSeconds,
    @Default(false) bool videoCompleted,

    // Post-Quiz state
    @Default(false) bool postQuizCompleted,
    double? postQuizScore,

    // Session timestamps
    required DateTime startedAt,
    DateTime? completedAt,
  }) = _VideoLearningSession;

  const VideoLearningSession._();

  factory VideoLearningSession.fromJson(Map<String, dynamic> json) =>
      _$VideoLearningSessionFromJson(json);

  /// Calculate learning gain (post-quiz - pre-quiz score)
  double? get learningGain {
    if (preQuizScore == null || postQuizScore == null) return null;
    return postQuizScore! - preQuizScore!;
  }

  /// Check if learning gain is positive
  bool get hasPositiveLearningGain {
    final gain = learningGain;
    return gain != null && gain > 0;
  }

  /// Get checkpoint performance percentage
  double get checkpointPerformance {
    if (checkpointsAttempted == 0) return 0;
    return (checkpointsCorrect / checkpointsAttempted) * 100;
  }

  /// Check if session is complete (all phases done)
  bool get isComplete =>
      preQuizCompleted && videoCompleted && postQuizCompleted;

  /// Check if pre-quiz passed (>= 70%)
  bool get preQuizPassed => preQuizScore != null && preQuizScore! >= 70;

  /// Check if post-quiz passed (>= 70%)
  bool get postQuizPassed => postQuizScore != null && postQuizScore! >= 70;

  /// Get current checkpoint (if any)
  VideoCheckpoint? get currentCheckpoint {
    if (currentCheckpointIndex >= checkpoints.length) return null;
    return checkpoints[currentCheckpointIndex];
  }

  /// Check if there are more checkpoints
  bool get hasMoreCheckpoints => currentCheckpointIndex < checkpoints.length;

  /// Get session duration in minutes
  int get sessionDurationMinutes {
    if (completedAt == null) {
      return DateTime.now().difference(startedAt).inMinutes;
    }
    return completedAt!.difference(startedAt).inMinutes;
  }

  /// Get session status
  VideoSessionStatus get status {
    if (completedAt != null) return VideoSessionStatus.completed;
    if (postQuizCompleted) return VideoSessionStatus.postQuizDone;
    if (videoCompleted) return VideoSessionStatus.videoWatched;
    if (preQuizCompleted) return VideoSessionStatus.preQuizDone;
    return VideoSessionStatus.started;
  }
}

enum VideoSessionStatus {
  started,
  preQuizDone,
  videoWatched,
  postQuizDone,
  completed;

  String get displayName {
    switch (this) {
      case VideoSessionStatus.started:
        return 'Started';
      case VideoSessionStatus.preQuizDone:
        return 'Pre-Quiz Complete';
      case VideoSessionStatus.videoWatched:
        return 'Video Watched';
      case VideoSessionStatus.postQuizDone:
        return 'Post-Quiz Complete';
      case VideoSessionStatus.completed:
        return 'Completed';
    }
  }
}
