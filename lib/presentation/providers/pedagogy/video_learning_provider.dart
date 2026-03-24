/// Video learning state management provider
///
/// Manages video learning sessions including pre-quiz, checkpoints, and post-quiz
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/pedagogy/video_checkpoint.dart';
import 'package:crack_the_code/domain/entities/pedagogy/video_learning_session.dart';

/// Video learning state
class VideoLearningState {
  final VideoLearningSession? activeSession;
  final bool showingPreQuiz;
  final bool showingCheckpoint;
  final bool showingPostQuiz;
  final VideoCheckpoint? currentCheckpoint;
  final double? learningGain;
  final bool isLoading;
  final String? error;

  const VideoLearningState({
    this.activeSession,
    this.showingPreQuiz = false,
    this.showingCheckpoint = false,
    this.showingPostQuiz = false,
    this.currentCheckpoint,
    this.learningGain,
    this.isLoading = false,
    this.error,
  });

  factory VideoLearningState.initial() => const VideoLearningState();

  VideoLearningState copyWith({
    VideoLearningSession? activeSession,
    bool? showingPreQuiz,
    bool? showingCheckpoint,
    bool? showingPostQuiz,
    VideoCheckpoint? currentCheckpoint,
    double? learningGain,
    bool? isLoading,
    String? error,
    bool clearSession = false,
    bool clearCheckpoint = false,
    bool clearError = false,
  }) {
    return VideoLearningState(
      activeSession: clearSession ? null : activeSession ?? this.activeSession,
      showingPreQuiz: showingPreQuiz ?? this.showingPreQuiz,
      showingCheckpoint: showingCheckpoint ?? this.showingCheckpoint,
      showingPostQuiz: showingPostQuiz ?? this.showingPostQuiz,
      currentCheckpoint: clearCheckpoint ? null : currentCheckpoint ?? this.currentCheckpoint,
      learningGain: learningGain ?? this.learningGain,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Check if there's an active session
  bool get hasActiveSession => activeSession != null;

  /// Check if pre-quiz is completed
  bool get isPreQuizCompleted => activeSession?.preQuizCompleted ?? false;

  /// Check if post-quiz is completed
  bool get isPostQuizCompleted => activeSession?.postQuizCompleted ?? false;

  /// Get current checkpoint index
  int get currentCheckpointIndex => activeSession?.currentCheckpointIndex ?? 0;

  /// Get total checkpoints
  int get totalCheckpoints => activeSession?.checkpoints.length ?? 0;

  /// Check if all checkpoints are completed
  bool get allCheckpointsCompleted {
    if (activeSession == null) return false;
    return activeSession!.checkpoints.every((c) => c.completed);
  }

  /// Get video session progress (0-100)
  double get sessionProgress {
    if (activeSession == null) return 0.0;
    int completed = 0;
    int total = 3; // Pre-quiz + video + post-quiz

    if (activeSession!.preQuizCompleted) completed++;
    if (allCheckpointsCompleted) completed++;
    if (activeSession!.postQuizCompleted) completed++;

    return (completed / total) * 100;
  }
}

/// Video learning state notifier
class VideoLearningNotifier extends StateNotifier<VideoLearningState> {
  VideoLearningNotifier() : super(VideoLearningState.initial());

  /// Start a new video learning session
  Future<void> startVideoSession({
    required String videoId,
    required String conceptId,
    required String studentId,
  }) async {
    try {
      logger.info('Starting video session: $videoId for concept: $conceptId');
      state = state.copyWith(isLoading: true, clearError: true, clearSession: true);

      // Create session with empty checkpoints (will be populated from video data)
      final session = VideoLearningSession(
        id: 'video_session_${studentId}_${videoId}_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        videoId: videoId,
        conceptId: conceptId,
        preQuizCompleted: false,
        checkpoints: [],
        currentCheckpointIndex: 0,
        postQuizCompleted: false,
        startedAt: DateTime.now(),
      );

      state = state.copyWith(
        activeSession: session,
        showingPreQuiz: true, // Start with pre-quiz
        isLoading: false,
      );

      logger.info('Video session started');
    } catch (e, stackTrace) {
      logger.error('Failed to start video session', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to start video session: $e',
      );
    }
  }

  /// Complete pre-quiz
  Future<void> completePreQuiz({
    required double score,
    List<String>? gaps,
  }) async {
    if (state.activeSession == null) {
      logger.warning('Cannot complete pre-quiz: No active session');
      return;
    }

    try {
      logger.info('Completing pre-quiz with score: $score');

      final updatedSession = state.activeSession!.copyWith(
        preQuizCompleted: true,
        preQuizScore: score,
        preQuizGaps: gaps ?? [],
      );

      state = state.copyWith(
        activeSession: updatedSession,
        showingPreQuiz: false,
      );

      logger.info('Pre-quiz completed. Gaps identified: ${gaps?.length ?? 0}');
    } catch (e, stackTrace) {
      logger.error('Failed to complete pre-quiz', e, stackTrace);
      state = state.copyWith(error: 'Failed to complete pre-quiz: $e');
    }
  }

  /// Skip pre-quiz
  void skipPreQuiz() {
    if (state.activeSession == null) return;

    logger.info('Skipping pre-quiz');
    final updatedSession = state.activeSession!.copyWith(
      preQuizCompleted: true,
    );

    state = state.copyWith(
      activeSession: updatedSession,
      showingPreQuiz: false,
    );
  }

  /// Trigger checkpoint at current video position
  void triggerCheckpoint(VideoCheckpoint checkpoint) {
    if (state.activeSession == null) {
      logger.warning('Cannot trigger checkpoint: No active session');
      return;
    }

    state = state.copyWith(
      showingCheckpoint: true,
      currentCheckpoint: checkpoint,
    );

    logger.info('Checkpoint triggered at ${checkpoint.timestampSeconds}s');
  }

  /// Submit checkpoint answer
  Future<void> submitCheckpointAnswer({
    required String answer,
    required bool isCorrect,
  }) async {
    if (state.activeSession == null || state.currentCheckpoint == null) {
      logger.warning('Cannot submit checkpoint answer: No active checkpoint');
      return;
    }

    try {
      logger.info('Submitting checkpoint answer. Correct: $isCorrect');

      final currentCheckpoint = state.currentCheckpoint!;
      final updatedCheckpoint = currentCheckpoint.copyWith(
        completed: true,
        answeredCorrectly: isCorrect,
      );

      // Update checkpoints list
      final updatedCheckpoints = state.activeSession!.checkpoints.map((cp) {
        if (cp.id == currentCheckpoint.id) return updatedCheckpoint;
        return cp;
      }).toList();

      final updatedSession = state.activeSession!.copyWith(
        checkpoints: updatedCheckpoints,
        currentCheckpointIndex: state.activeSession!.currentCheckpointIndex + 1,
      );

      state = state.copyWith(
        activeSession: updatedSession,
        showingCheckpoint: false,
        clearCheckpoint: true,
      );

      logger.info('Checkpoint answer submitted');
    } catch (e, stackTrace) {
      logger.error('Failed to submit checkpoint answer', e, stackTrace);
      state = state.copyWith(error: 'Failed to submit answer: $e');
    }
  }

  /// Replay section after wrong checkpoint answer
  void requestReplay() {
    if (state.currentCheckpoint == null) return;

    logger.info(
      'Replay requested: ${state.currentCheckpoint!.replayStartSeconds}s - '
      '${state.currentCheckpoint!.replayEndSeconds}s',
    );

    state = state.copyWith(
      showingCheckpoint: false,
      clearCheckpoint: true,
    );
  }

  /// Continue after wrong checkpoint answer (skip replay)
  void continueAfterWrongAnswer() {
    if (state.currentCheckpoint == null) return;

    logger.info('Continuing after wrong answer');

    final currentCheckpoint = state.currentCheckpoint!;
    final updatedCheckpoint = currentCheckpoint.copyWith(
      completed: true,
      answeredCorrectly: false,
    );

    final updatedCheckpoints = state.activeSession!.checkpoints.map((cp) {
      if (cp.id == currentCheckpoint.id) return updatedCheckpoint;
      return cp;
    }).toList();

    final updatedSession = state.activeSession!.copyWith(
      checkpoints: updatedCheckpoints,
      currentCheckpointIndex: state.activeSession!.currentCheckpointIndex + 1,
    );

    state = state.copyWith(
      activeSession: updatedSession,
      showingCheckpoint: false,
      clearCheckpoint: true,
    );
  }

  /// Start post-quiz
  void startPostQuiz() {
    if (state.activeSession == null) {
      logger.warning('Cannot start post-quiz: No active session');
      return;
    }

    logger.info('Starting post-quiz');
    state = state.copyWith(showingPostQuiz: true);
  }

  /// Complete post-quiz
  Future<void> completePostQuiz({required double score}) async {
    if (state.activeSession == null) {
      logger.warning('Cannot complete post-quiz: No active session');
      return;
    }

    try {
      logger.info('Completing post-quiz with score: $score');

      // Calculate learning gain
      final preScore = state.activeSession!.preQuizScore ?? 0;
      final gain = score - preScore;

      final updatedSession = state.activeSession!.copyWith(
        postQuizCompleted: true,
        postQuizScore: score,
        completedAt: DateTime.now(),
      );

      state = state.copyWith(
        activeSession: updatedSession,
        showingPostQuiz: false,
        learningGain: gain,
      );

      logger.info(
        'Post-quiz completed. Learning gain: ${gain.toStringAsFixed(1)}%',
      );
    } catch (e, stackTrace) {
      logger.error('Failed to complete post-quiz', e, stackTrace);
      state = state.copyWith(error: 'Failed to complete post-quiz: $e');
    }
  }

  /// Check if there's a checkpoint at a given timestamp
  bool hasCheckpointAt(int timestampSeconds) {
    if (state.activeSession == null) return false;
    return state.activeSession!.checkpoints.any(
      (cp) => cp.timestampSeconds == timestampSeconds && !cp.completed,
    );
  }

  /// Clear session
  void clearSession() {
    state = VideoLearningState.initial();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for video learning state management
final videoLearningProvider = StateNotifierProvider<VideoLearningNotifier, VideoLearningState>((ref) {
  return VideoLearningNotifier();
});
