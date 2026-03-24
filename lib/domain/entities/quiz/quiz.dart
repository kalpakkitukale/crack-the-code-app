/// Quiz entity representing a quiz configuration
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz.freezed.dart';

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String id,
    required QuizLevel level,
    required String entityId,
    required List<String> questionIds,
    required int timeLimit,
    @Default(0.75) double passingScore,
    String? title,
    Map<String, dynamic>? config,
  }) = _Quiz;

  const Quiz._();

  /// Get number of questions in quiz
  int get questionCount => questionIds.length;

  /// Check if quiz is timed
  bool get isTimed => timeLimit > 0;

  /// Get time limit in minutes
  int get timeLimitMinutes => (timeLimit / 60).ceil();

  /// Get required correct answers to pass
  int get requiredCorrectAnswers => (questionCount * passingScore).ceil();

  /// Check if score passes the quiz
  bool isPassingScore(double score) => score >= passingScore;
}

/// Quiz level enum
enum QuizLevel {
  video,     // 5 questions
  topic,     // 10 questions
  chapter,   // 20 questions
  subject    // 50 questions
}
