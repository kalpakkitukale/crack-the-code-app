/// QuizSession data model for database operations
library;

import 'dart:convert';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';

/// QuizSession model for SQLite database
class QuizSessionModel {
  final String id;
  final String quizId;
  final String studentId;
  final int startTime;
  final String state;
  final int currentQuestionIndex;
  final String answers; // JSON string
  final String selectedQuestionIds; // JSON string array of question IDs
  final int? endTime;
  final String assessmentType; // Assessment type: readiness, knowledge, practice

  const QuizSessionModel({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.startTime,
    required this.state,
    required this.currentQuestionIndex,
    required this.answers,
    required this.selectedQuestionIds,
    this.endTime,
    this.assessmentType = 'practice',
  });

  /// Convert from database map
  factory QuizSessionModel.fromMap(Map<String, dynamic> map) {
    return QuizSessionModel(
      id: map['id'] as String,
      quizId: map['quiz_id'] as String,
      studentId: map['student_id'] as String,
      startTime: map['start_time'] as int,
      state: map['state'] as String,
      currentQuestionIndex: map['current_question_index'] as int,
      answers: map['answers'] as String,
      selectedQuestionIds: map['selected_question_ids'] as String? ?? '[]',
      endTime: map['end_time'] as int?,
      assessmentType: map['assessment_type'] as String? ?? 'practice',
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quiz_id': quizId,
      'student_id': studentId,
      'start_time': startTime,
      'state': state,
      'current_question_index': currentQuestionIndex,
      'answers': answers,
      'selected_question_ids': selectedQuestionIds,
      'end_time': endTime,
      'assessment_type': assessmentType,
    };
  }

  /// Convert to domain entity (requires questions list from repository)
  /// This is a partial conversion - full entity requires questions
  Map<String, dynamic> toPartialEntity() {
    return {
      'id': id,
      'quizId': quizId,
      'studentId': studentId,
      'startTime': DateTime.fromMillisecondsSinceEpoch(startTime),
      'state': _parseQuizState(state),
      'currentQuestionIndex': currentQuestionIndex,
      'answers': _parseAnswersMap(answers),
      'endTime': endTime != null ? DateTime.fromMillisecondsSinceEpoch(endTime!) : null,
      'assessmentType': _parseAssessmentType(assessmentType),
    };
  }

  /// Create from domain entity (without questions)
  factory QuizSessionModel.fromPartialEntity({
    required String id,
    required String quizId,
    required String studentId,
    required DateTime startTime,
    required QuizSessionState state,
    required int currentQuestionIndex,
    required Map<String, String> answers,
    required List<String> selectedQuestionIds,
    DateTime? endTime,
    AssessmentType assessmentType = AssessmentType.practice,
  }) {
    return QuizSessionModel(
      id: id,
      quizId: quizId,
      studentId: studentId,
      startTime: startTime.millisecondsSinceEpoch,
      state: _quizStateToString(state),
      currentQuestionIndex: currentQuestionIndex,
      answers: jsonEncode(answers),
      selectedQuestionIds: jsonEncode(selectedQuestionIds),
      endTime: endTime?.millisecondsSinceEpoch,
      assessmentType: _assessmentTypeToString(assessmentType),
    );
  }

  /// Parse JSON string to Map<String, String>
  static Map<String, String> _parseAnswersMap(String jsonString) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return {};
    }
  }

  /// Parse quiz state string to enum
  static QuizSessionState _parseQuizState(String stateString) {
    switch (stateString.toLowerCase()) {
      case 'notstarted':
      case 'not_started':
        return QuizSessionState.notStarted;
      case 'inprogress':
      case 'in_progress':
        return QuizSessionState.inProgress;
      case 'paused':
        return QuizSessionState.paused;
      case 'completed':
        return QuizSessionState.completed;
      case 'reviewing':
        return QuizSessionState.reviewing;
      default:
        return QuizSessionState.notStarted;
    }
  }

  /// Convert quiz state enum to string
  static String _quizStateToString(QuizSessionState state) {
    switch (state) {
      case QuizSessionState.notStarted:
        return 'notStarted';
      case QuizSessionState.inProgress:
        return 'inProgress';
      case QuizSessionState.paused:
        return 'paused';
      case QuizSessionState.completed:
        return 'completed';
      case QuizSessionState.reviewing:
        return 'reviewing';
    }
  }

  /// Parse assessment type string to enum
  static AssessmentType _parseAssessmentType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'readiness':
        return AssessmentType.readiness;
      case 'knowledge':
        return AssessmentType.knowledge;
      case 'practice':
        return AssessmentType.practice;
      default:
        return AssessmentType.practice;
    }
  }

  /// Convert assessment type enum to string
  static String _assessmentTypeToString(AssessmentType type) {
    switch (type) {
      case AssessmentType.readiness:
        return 'readiness';
      case AssessmentType.knowledge:
        return 'knowledge';
      case AssessmentType.practice:
        return 'practice';
    }
  }
}
