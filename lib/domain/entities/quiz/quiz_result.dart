/// QuizResult entity representing quiz evaluation results
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';

part 'quiz_result.freezed.dart';

@freezed
class QuizResult with _$QuizResult {
  const factory QuizResult({
    required String sessionId,
    required int totalQuestions,
    required int correctAnswers,
    required double scorePercentage,
    required bool passed,
    required Map<String, bool> questionResults,
    required Duration timeTaken,
    required DateTime evaluatedAt,
    @Default(false) bool evaluatedOffline,
    Map<String, ConceptScore>? conceptAnalysis,
    List<String>? weakAreas,
    List<String>? strongAreas,
    String? recommendation,
    // Questions data for detailed review (populated from quiz attempts)
    List<Question>? questions,
    // Student's answers for detailed review (populated from quiz attempts)
    Map<String, String>? answers,
    // Breadcrumb metadata for quiz context display
    String? quizLevel,
    String? subjectName,
    String? chapterName,
    String? topicName,
    String? videoTitle,
  }) = _QuizResult;

  const QuizResult._();

  /// Get number of incorrect answers
  int get incorrectAnswers => totalQuestions - correctAnswers;

  /// Get accuracy percentage
  double get accuracy => scorePercentage;

  /// Get formatted score display (e.g., "17/20")
  String get scoreDisplay => '$correctAnswers/$totalQuestions';

  /// Get formatted percentage display (e.g., "85%")
  String get percentageDisplay => '${scorePercentage.toStringAsFixed(0)}%';

  /// Check if result is excellent (>= 90%)
  bool get isExcellent => scorePercentage >= 90.0;

  /// Check if result is good (>= 75%)
  bool get isGood => scorePercentage >= 75.0 && scorePercentage < 90.0;

  /// Check if result is average (>= 60%)
  bool get isAverage => scorePercentage >= 60.0 && scorePercentage < 75.0;

  /// Check if result is poor (< 60%)
  bool get isPoor => scorePercentage < 60.0;

  /// Get grade based on score
  String get grade {
    if (scorePercentage >= 90) return 'A';
    if (scorePercentage >= 80) return 'B';
    if (scorePercentage >= 70) return 'C';
    if (scorePercentage >= 60) return 'D';
    return 'F';
  }

  /// Get time taken in minutes
  int get timeTakenMinutes => timeTaken.inMinutes;

  /// Get formatted time taken
  String get formattedTimeTaken {
    final minutes = timeTaken.inMinutes;
    final seconds = timeTaken.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  /// Check if student has weak areas
  bool get hasWeakAreas => weakAreas != null && weakAreas!.isNotEmpty;

  /// Check if student has strong areas
  bool get hasStrongAreas => strongAreas != null && strongAreas!.isNotEmpty;

  /// Check if concept analysis is available
  bool get hasConceptAnalysis => conceptAnalysis != null && conceptAnalysis!.isNotEmpty;
}

/// Concept score tracking
@freezed
class ConceptScore with _$ConceptScore {
  const factory ConceptScore({
    required String concept,
    required int total,
    required int correct,
  }) = _ConceptScore;

  const ConceptScore._();

  /// Get score percentage for this concept
  double get percentage => total > 0 ? (correct / total) * 100 : 0.0;

  /// Get incorrect count
  int get incorrect => total - correct;

  /// Check if concept is mastered (>= 80%)
  bool get isMastered => percentage >= 80.0;

  /// Check if concept needs improvement (< 60%)
  bool get needsImprovement => percentage < 60.0;
}
