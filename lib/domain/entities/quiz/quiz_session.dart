/// QuizSession entity representing an active quiz session
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'question.dart';

part 'quiz_session.freezed.dart';

@freezed
class QuizSession with _$QuizSession {
  const factory QuizSession({
    required String id,
    required String quizId,
    required String studentId,
    required List<Question> questions,
    required DateTime startTime,
    required QuizSessionState state,
    @Default(0) int currentQuestionIndex,
    @Default({}) Map<String, String> answers,
    DateTime? endTime,
    /// PHASE 4: Backup of answers for undo/restore functionality
    /// This stores the previous state of answers before clearAllAnswers() is called
    Map<String, String>? answersBackup,
    /// Assessment type for this quiz session (readiness, knowledge, or practice)
    /// Defaults to practice for backward compatibility
    @Default(AssessmentType.practice) AssessmentType assessmentType,
  }) = _QuizSession;

  const QuizSession._();

  /// Get current question
  Question? get currentQuestion {
    if (currentQuestionIndex >= 0 && currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  /// Check if quiz is in progress
  bool get isInProgress => state == QuizSessionState.inProgress;

  /// Check if quiz is completed
  bool get isCompleted => state == QuizSessionState.completed;

  /// Check if quiz is paused
  bool get isPaused => state == QuizSessionState.paused;

  /// Get number of answered questions
  int get answeredCount => answers.length;

  /// Get number of unanswered questions
  int get unansweredCount => questions.length - answeredCount;

  /// Get progress percentage
  double get progressPercentage =>
      questions.isEmpty ? 0.0 : (answeredCount / questions.length) * 100;

  /// Check if all questions are answered
  bool get allQuestionsAnswered => answeredCount == questions.length;

  /// Get elapsed time in seconds
  int get elapsedSeconds {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inSeconds;
  }

  /// Check if answer exists for current question
  bool get hasAnswerForCurrentQuestion {
    final question = currentQuestion;
    return question != null && answers.containsKey(question.id);
  }

  /// Get answer for a specific question
  String? getAnswer(String questionId) => answers[questionId];

  /// Check if this is the last question
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  /// Check if this is the first question
  bool get isFirstQuestion => currentQuestionIndex == 0;
}

/// Quiz session state enum
enum QuizSessionState {
  notStarted,
  inProgress,
  paused,
  completed,
  reviewing
}
