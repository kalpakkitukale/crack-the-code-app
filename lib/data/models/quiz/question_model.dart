/// Question data model for database operations
library;

import 'dart:convert';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';

/// Question model for SQLite database
class QuestionModel {
  final String id;
  final String questionText;
  final String questionType;
  final String options; // JSON string
  final String correctAnswer;
  final String explanation;
  final String hints; // JSON string
  final String difficulty;
  final String conceptTags; // JSON string
  final String topicIds; // JSON string
  final String? videoTimestamp;
  final int points;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.hints,
    required this.difficulty,
    required this.conceptTags,
    required this.topicIds,
    this.videoTimestamp,
    required this.points,
  });

  /// Convert from database map
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as String,
      questionText: map['question_text'] as String,
      questionType: map['question_type'] as String,
      options: map['options'] as String,
      correctAnswer: map['correct_answer'] as String,
      explanation: map['explanation'] as String,
      hints: map['hints'] as String,
      difficulty: map['difficulty'] as String,
      conceptTags: map['concept_tags'] as String,
      topicIds: map['topic_ids'] as String? ?? '[]',
      videoTimestamp: map['video_timestamp'] as String?,
      points: map['points'] as int,
    );
  }

  /// Convert from JSON (for asset loading)
  /// All quiz JSON files use letter format (A, B, C, D) for correctAnswer
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      questionType: json['questionType'] as String,
      options: jsonEncode(json['options']),
      correctAnswer: json['correctAnswer'] as String,  // Already in letter format (A, B, C, D)
      explanation: json['explanation'] as String,
      hints: jsonEncode(json['hints']),
      difficulty: json['difficulty'] as String,
      conceptTags: jsonEncode(json['conceptTags']),
      topicIds: jsonEncode(json['topicIds'] ?? []),
      videoTimestamp: json['videoTimestamp'] as String?,
      points: json['points'] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'hints': hints,
      'difficulty': difficulty,
      'concept_tags': conceptTags,
      'topic_ids': topicIds,
      'video_timestamp': videoTimestamp,
      'points': points,
    };
  }

  /// Convert to domain entity
  Question toEntity() {
    return Question(
      id: id,
      questionText: questionText,
      questionType: _parseQuestionType(questionType),
      options: _parseStringList(options),
      correctAnswer: correctAnswer,
      explanation: explanation,
      hints: _parseStringList(hints),
      difficulty: difficulty,
      conceptTags: _parseStringList(conceptTags),
      topicIds: _parseStringList(topicIds),
      videoTimestamp: videoTimestamp,
      points: points,
    );
  }

  /// Create from domain entity
  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      questionText: question.questionText,
      questionType: _questionTypeToString(question.questionType),
      options: jsonEncode(question.options),
      correctAnswer: question.correctAnswer,
      explanation: question.explanation,
      hints: jsonEncode(question.hints),
      difficulty: question.difficulty,
      conceptTags: jsonEncode(question.conceptTags),
      topicIds: jsonEncode(question.topicIds),
      videoTimestamp: question.videoTimestamp,
      points: question.points,
    );
  }

  /// Parse JSON string to List<String> with error logging
  static List<String> _parseStringList(String jsonString) {
    if (jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      logger.warning('Failed to parse string list JSON: $e');
      return [];
    }
  }

  /// Parse question type string to enum
  static QuestionType _parseQuestionType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'mcq':
        return QuestionType.mcq;
      case 'truefalse':
      case 'true_false':
        return QuestionType.trueFalse;
      case 'fillblank':
      case 'fill_blank':
        return QuestionType.fillBlank;
      case 'match':
        return QuestionType.match;
      case 'numerical':
        return QuestionType.numerical;
      default:
        return QuestionType.mcq;
    }
  }

  /// Convert question type enum to string
  static String _questionTypeToString(QuestionType type) {
    switch (type) {
      case QuestionType.mcq:
        return 'mcq';
      case QuestionType.trueFalse:
        return 'trueFalse';
      case QuestionType.fillBlank:
        return 'fillBlank';
      case QuestionType.match:
        return 'match';
      case QuestionType.numerical:
        return 'numerical';
    }
  }
}
