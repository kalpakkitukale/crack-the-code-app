/// Quiz data model for database operations
library;

import 'dart:convert';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';

/// Quiz model for SQLite database
class QuizModel {
  final String id;
  final String level;
  final String entityId;
  final String questionIds; // JSON string
  final int timeLimit;
  final double passingScore;
  final String? title;
  final String? config; // JSON string

  const QuizModel({
    required this.id,
    required this.level,
    required this.entityId,
    required this.questionIds,
    required this.timeLimit,
    required this.passingScore,
    this.title,
    this.config,
  });

  /// Convert from database map
  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] as String,
      level: map['level'] as String,
      entityId: map['entity_id'] as String,
      questionIds: map['question_ids'] as String,
      timeLimit: map['time_limit'] as int,
      passingScore: map['passing_score'] as double,
      title: map['title'] as String?,
      config: map['config'] as String?,
    );
  }

  /// Convert from JSON (for asset loading)
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      level: json['level'] as String,
      entityId: json['entityId'] as String,
      questionIds: jsonEncode(json['questionIds']),
      timeLimit: json['timeLimit'] as int,
      passingScore: (json['passingScore'] as num).toDouble(),
      title: json['title'] as String?,
      config: json['config'] != null ? jsonEncode(json['config']) : null,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'entity_id': entityId,
      'question_ids': questionIds,
      'time_limit': timeLimit,
      'passing_score': passingScore,
      'title': title,
      'config': config,
    };
  }

  /// Convert to domain entity
  Quiz toEntity() {
    return Quiz(
      id: id,
      level: _parseQuizLevel(level),
      entityId: entityId,
      questionIds: _parseStringList(questionIds),
      timeLimit: timeLimit,
      passingScore: passingScore,
      title: title,
      config: config != null ? _parseMap(config!) : null,
    );
  }

  /// Create from domain entity
  factory QuizModel.fromEntity(Quiz quiz) {
    return QuizModel(
      id: quiz.id,
      level: _quizLevelToString(quiz.level),
      entityId: quiz.entityId,
      questionIds: jsonEncode(quiz.questionIds),
      timeLimit: quiz.timeLimit,
      passingScore: quiz.passingScore,
      title: quiz.title,
      config: quiz.config != null ? jsonEncode(quiz.config) : null,
    );
  }

  /// Parse JSON string to List<String>
  static List<String> _parseStringList(String jsonString) {
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Parse JSON string to Map<String, dynamic>
  static Map<String, dynamic> _parseMap(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// Parse quiz level string to enum
  static QuizLevel _parseQuizLevel(String levelString) {
    switch (levelString.toLowerCase()) {
      case 'video':
        return QuizLevel.video;
      case 'topic':
        return QuizLevel.topic;
      case 'chapter':
        return QuizLevel.chapter;
      case 'subject':
        return QuizLevel.subject;
      default:
        return QuizLevel.video;
    }
  }

  /// Convert quiz level enum to string
  static String _quizLevelToString(QuizLevel level) {
    switch (level) {
      case QuizLevel.video:
        return 'video';
      case QuizLevel.topic:
        return 'topic';
      case QuizLevel.chapter:
        return 'chapter';
      case QuizLevel.subject:
        return 'subject';
    }
  }
}
