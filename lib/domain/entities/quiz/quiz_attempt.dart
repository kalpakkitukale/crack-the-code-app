/// QuizAttempt entity representing a completed quiz attempt
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt_status.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendation_status.dart';

part 'quiz_attempt.freezed.dart';

@freezed
class QuizAttempt with _$QuizAttempt {
  const factory QuizAttempt({
    required String id,
    required String quizId,
    required String studentId,
    required Map<String, String> answers,
    required double score,
    required bool passed,
    required DateTime completedAt,
    required int timeTaken,
    DateTime? startTime,
    @Default(1) int attemptNumber,
    @Default(false) bool syncedToServer,
    @Default(0) int syncRetryCount,
    Map<String, dynamic>? analytics,
    // Additional metadata for Phase 4 statistics
    String? subjectId,
    String? subjectName,
    String? chapterId,
    String? chapterName,
    String? topicId,
    String? topicName,
    String? videoTitle,
    String? quizLevel,
    int? totalQuestions,
    int? correctAnswers,
    // Questions data for detailed review from history
    List<Question>? questions,
    // Quiz attempt status (completed, in progress, or abandoned)
    @Default(QuizAttemptStatus.completed) QuizAttemptStatus status,
    // NEW: Assessment type classification (readiness, knowledge, practice)
    @Default(AssessmentType.practice) AssessmentType assessmentType,
    // NEW: Recommendation metadata
    @Default(false) bool hasRecommendations,
    int? recommendationCount,
    DateTime? recommendationsGeneratedAt,
    @Default(RecommendationStatus.none)
    RecommendationStatus recommendationStatus,
    String? recommendationsHistoryId,
    // NEW: Learning path tracking
    String? learningPathId,
    double? learningPathProgress, // 0.0 to 1.0
  }) = _QuizAttempt;

  const QuizAttempt._();

  /// Get score as percentage
  double get scorePercentage => score * 100;

  /// Get formatted score display (e.g., "85%")
  String get scoreDisplay => '${scorePercentage.toStringAsFixed(0)}%';

  /// Get time taken in minutes
  int get timeTakenMinutes => (timeTaken / 60).ceil();

  /// Get formatted time taken (e.g., "12:45")
  String get formattedTimeTaken {
    final minutes = timeTaken ~/ 60;
    final seconds = timeTaken % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if this needs to be synced
  bool get needsSync => !syncedToServer;

  /// Check if sync has failed multiple times
  bool get syncFailed => syncRetryCount >= 3;

  /// Get number of questions answered
  int get answeredCount => answers.length;

  /// Check if this is a first attempt
  bool get isFirstAttempt => attemptNumber == 1;

  /// Check if this is a retry
  bool get isRetry => attemptNumber > 1;

  /// Check if recommendations are outdated (>30 days old)
  bool get areRecommendationsOutdated {
    if (recommendationsGeneratedAt == null) return false;
    final age = DateTime.now().difference(recommendationsGeneratedAt!);
    return age.inDays > 30;
  }

  /// Get learning path progress as percentage (0-100)
  int get learningPathProgressPercentage {
    if (learningPathProgress == null) return 0;
    return (learningPathProgress! * 100).round();
  }

  /// Check if learning path is in progress
  bool get hasActiveLearningPath {
    return learningPathId != null &&
        learningPathProgress != null &&
        learningPathProgress! < 1.0;
  }

  /// Check if learning path is completed
  bool get hasCompletedLearningPath {
    return learningPathProgress != null && learningPathProgress! >= 1.0;
  }
}
