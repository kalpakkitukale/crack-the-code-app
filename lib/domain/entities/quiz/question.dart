/// Question entity representing a quiz question
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';

@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String questionText,
    required QuestionType questionType,
    required List<String> options,
    required String correctAnswer,
    required String explanation,
    required List<String> hints,
    required String difficulty,
    required List<String> conceptTags,
    @Default([]) List<String> topicIds,  // Topics this question belongs to
    String? videoTimestamp,
    @Default(1) int points,
  }) = _Question;

  const Question._();

  /// Check if answer is correct
  /// Handles both exact matches and case-insensitive matches
  /// Also handles answers with option prefixes (e.g., "A. answer" vs "answer")
  bool isCorrect(String answer) {
    String userAnswer = answer.trim().toLowerCase();
    final correct = correctAnswer.trim().toLowerCase();

    // Remove option prefix if present (e.g., "a. option text", "b. option text")
    // CRITICAL FIX: Only remove prefix if there's text AFTER the dot
    // Pattern matches: letter/digit + dot + space + at least one more character
    // This prevents removing standalone letters like "a", "b", "c", "d"
    final prefixPattern = RegExp(r'^[a-z0-9]\.\s+\S', caseSensitive: false);
    if (prefixPattern.hasMatch(userAnswer)) {
      // Remove only the "letter. " part, keeping the text after it
      userAnswer = userAnswer.replaceFirst(RegExp(r'^[a-z0-9]\.\s*', caseSensitive: false), '');
    }

    // Direct comparison (works for letter indices like "A", "B", "C", "D" and text answers)
    return userAnswer == correct;
  }

  /// Get hint by index (0-based)
  String? getHint(int index) {
    if (index >= 0 && index < hints.length) {
      return hints[index];
    }
    return null;
  }

  /// Check if question has hints
  bool get hasHints => hints.isNotEmpty;

  /// Get number of hints available
  int get hintCount => hints.length;

  /// Check if question is basic difficulty
  bool get isBasic => difficulty.toLowerCase() == 'basic';

  /// Check if question is intermediate difficulty
  bool get isIntermediate => difficulty.toLowerCase() == 'intermediate';

  /// Check if question is advanced difficulty
  bool get isAdvanced => difficulty.toLowerCase() == 'advanced';

  /// Check if question has video timestamp link
  bool get hasVideoLink => videoTimestamp != null && videoTimestamp!.isNotEmpty;
}

/// Question type enum
enum QuestionType {
  mcq,          // Multiple Choice Question
  trueFalse,    // True/False
  fillBlank,    // Fill in the Blank
  match,        // Match the Following
  numerical     // Numerical Answer
}
