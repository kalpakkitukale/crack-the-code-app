/// Context and completion models for learning path navigation
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';

part 'learning_path_context.freezed.dart';

/// Context passed to content screens when launched from learning path
///
/// This lightweight model tells content screens they're being viewed
/// as part of a learning path, so they can report completion back.
@freezed
class LearningPathContext with _$LearningPathContext {
  const factory LearningPathContext({
    required String pathId,
    required String nodeId,
    required PathNodeType nodeType,
    String? previousRoute, // For proper back navigation
  }) = _LearningPathContext;
}

/// Result returned when completing content from a learning path
///
/// Content screens return this when the user completes the activity
/// (watches a video, finishes a quiz, reviews concepts, etc.)
@freezed
class CompletionResult with _$CompletionResult {
  const factory CompletionResult({
    required bool completed,
    required String nodeId,
    double? score, // 0.0 - 100.0 for quizzes, 0.0 - 1.0 for videos
    int? timeSpent, // seconds
    Map<String, dynamic>? metadata, // Additional completion data
  }) = _CompletionResult;

  const CompletionResult._();

  /// Create a result for video completion
  factory CompletionResult.video({
    required String nodeId,
    required double watchedPercentage, // 0.0 - 100.0
    required int timeSpent,
    bool autoCompleted = false,
  }) {
    return CompletionResult(
      completed: true,
      nodeId: nodeId,
      score: watchedPercentage / 100, // Convert to 0.0 - 1.0
      timeSpent: timeSpent,
      metadata: {
        'type': 'video',
        'watchedPercentage': watchedPercentage,
        'autoCompleted': autoCompleted,
      },
    );
  }

  /// Create a result for quiz completion
  factory CompletionResult.quiz({
    required String nodeId,
    required double scorePercentage,
    required int timeSpent,
    required bool passed,
    int? correctAnswers,
    int? totalQuestions,
  }) {
    return CompletionResult(
      completed: true,
      nodeId: nodeId,
      score: scorePercentage,
      timeSpent: timeSpent,
      metadata: {
        'type': 'quiz',
        'passed': passed,
        'correctAnswers': correctAnswers,
        'totalQuestions': totalQuestions,
      },
    );
  }

  /// Create a result for revision completion
  factory CompletionResult.revision({
    required String nodeId,
    required int reviewedConceptsCount,
    required int timeSpent,
  }) {
    return CompletionResult(
      completed: true,
      nodeId: nodeId,
      timeSpent: timeSpent,
      metadata: {
        'type': 'revision',
        'reviewedConceptsCount': reviewedConceptsCount,
      },
    );
  }

  /// Get completion type
  String? get type => metadata?['type'] as String?;

  /// Check if video was auto-completed
  bool get wasAutoCompleted => metadata?['autoCompleted'] as bool? ?? false;

  /// Check if quiz was passed
  bool get quizPassed => metadata?['passed'] as bool? ?? false;
}
