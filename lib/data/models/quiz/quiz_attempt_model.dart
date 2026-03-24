/// QuizAttemptModel - Data model for quiz attempts
///
/// Handles database mapping and conversion for QuizAttempt entity.
library;

import 'dart:convert';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/pedagogy/recommendation_status.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt_status.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';

/// Data model for quiz attempts with database serialization
class QuizAttemptModel {
  final String id;
  final String quizId;
  final String studentId;
  final Map<String, String> answers;
  final double score;
  final bool passed;
  final DateTime completedAt;
  final int timeTaken;
  final DateTime? startTime;
  final int attemptNumber;
  final bool syncedToServer;
  final int syncRetryCount;
  final Map<String, dynamic>? analytics;
  final String? subjectId;
  final String? subjectName;
  final String? chapterId;
  final String? chapterName;
  final String? topicId;
  final String? topicName;
  final String? videoTitle;
  final String? quizLevel;
  final int? totalQuestions;
  final int? correctAnswers;
  final List<Question>? questions;
  final QuizAttemptStatus status;
  // NEW: Recommendation and assessment fields (v11)
  final AssessmentType assessmentType;
  final bool hasRecommendations;
  final int? recommendationCount;
  final DateTime? recommendationsGeneratedAt;
  final RecommendationStatus recommendationStatus;
  final String? recommendationsHistoryId;
  final String? learningPathId;
  final double? learningPathProgress;

  const QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.answers,
    required this.score,
    required this.passed,
    required this.completedAt,
    required this.timeTaken,
    this.startTime,
    this.attemptNumber = 1,
    this.syncedToServer = false,
    this.syncRetryCount = 0,
    this.analytics,
    this.subjectId,
    this.subjectName,
    this.chapterId,
    this.chapterName,
    this.topicId,
    this.topicName,
    this.videoTitle,
    this.quizLevel,
    this.totalQuestions,
    this.correctAnswers,
    this.questions,
    required this.status,
    // NEW: Recommendation and assessment parameters (v11)
    this.assessmentType = AssessmentType.practice,
    this.hasRecommendations = false,
    this.recommendationCount,
    this.recommendationsGeneratedAt,
    this.recommendationStatus = RecommendationStatus.none,
    this.recommendationsHistoryId,
    this.learningPathId,
    this.learningPathProgress,
  });

  /// Convert model to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quiz_id': quizId,
      'student_id': studentId,
      'answers': jsonEncode(answers),
      'score': score,
      'passed': passed ? 1 : 0,
      'completed_at': completedAt.millisecondsSinceEpoch,
      'time_taken': timeTaken,
      'start_time': startTime?.millisecondsSinceEpoch,
      'attempt_number': attemptNumber,
      'synced_to_server': syncedToServer ? 1 : 0,
      'sync_retry_count': syncRetryCount,
      'analytics': analytics != null ? jsonEncode(analytics) : null,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'chapter_id': chapterId,
      'chapter_name': chapterName,
      'topic_id': topicId,
      'topic_name': topicName,
      'video_title': videoTitle,
      'quiz_level': quizLevel,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'questions_data': questions != null ? _serializeQuestions(questions!) : null,
      'status': status.value,
      // NEW: Recommendation and assessment fields (v11)
      'assessment_type': assessmentType.name,
      'has_recommendations': hasRecommendations ? 1 : 0,
      'recommendation_count': recommendationCount,
      'recommendations_generated_at': recommendationsGeneratedAt?.millisecondsSinceEpoch,
      'recommendation_status': recommendationStatus.name,
      'recommendations_history_id': recommendationsHistoryId,
      'learning_path_id': learningPathId,
      'learning_path_progress': learningPathProgress,
    };
  }

  /// Create model from database map
  factory QuizAttemptModel.fromMap(Map<String, dynamic> map) {
    return QuizAttemptModel(
      id: map['id'] as String,
      quizId: map['quiz_id'] as String,
      studentId: map['student_id'] as String,
      answers: Map<String, String>.from(
        jsonDecode(map['answers'] as String) as Map,
      ),
      score: (map['score'] as num).toDouble(),
      passed: (map['passed'] as int) == 1,
      completedAt: DateTime.fromMillisecondsSinceEpoch(
        map['completed_at'] as int,
      ),
      timeTaken: map['time_taken'] as int,
      startTime: map['start_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int)
          : null,
      attemptNumber: map['attempt_number'] as int? ?? 1,
      syncedToServer: (map['synced_to_server'] as int?) == 1,
      syncRetryCount: map['sync_retry_count'] as int? ?? 0,
      analytics: map['analytics'] != null
          ? jsonDecode(map['analytics'] as String) as Map<String, dynamic>
          : null,
      subjectId: map['subject_id'] as String?,
      subjectName: map['subject_name'] as String?,
      chapterId: map['chapter_id'] as String?,
      chapterName: map['chapter_name'] as String?,
      topicId: map['topic_id'] as String?,
      topicName: map['topic_name'] as String?,
      videoTitle: map['video_title'] as String?,
      quizLevel: map['quiz_level'] as String?,
      totalQuestions: map['total_questions'] as int?,
      correctAnswers: map['correct_answers'] as int?,
      questions: map['questions_data'] != null
          ? _deserializeQuestions(map['questions_data'] as String)
          : null,
      status: map['status'] != null
          ? QuizAttemptStatus.fromString(map['status'] as String)
          : QuizAttemptStatus.completed,
      // NEW: Recommendation and assessment fields (v11)
      assessmentType: map['assessment_type'] != null
          ? _parseAssessmentType(map['assessment_type'] as String)
          : AssessmentType.practice,
      hasRecommendations: (map['has_recommendations'] as int?) == 1,
      recommendationCount: map['recommendation_count'] as int?,
      recommendationsGeneratedAt: map['recommendations_generated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['recommendations_generated_at'] as int)
          : null,
      recommendationStatus: map['recommendation_status'] != null
          ? _parseRecommendationStatus(map['recommendation_status'] as String)
          : RecommendationStatus.none,
      recommendationsHistoryId: map['recommendations_history_id'] as String?,
      learningPathId: map['learning_path_id'] as String?,
      learningPathProgress: (map['learning_path_progress'] as num?)?.toDouble(),
    );
  }

  /// Convert model to domain entity
  QuizAttempt toEntity() {
    return QuizAttempt(
      id: id,
      quizId: quizId,
      studentId: studentId,
      answers: answers,
      score: score,
      passed: passed,
      completedAt: completedAt,
      timeTaken: timeTaken,
      startTime: startTime,
      attemptNumber: attemptNumber,
      syncedToServer: syncedToServer,
      syncRetryCount: syncRetryCount,
      analytics: analytics,
      subjectId: subjectId,
      subjectName: subjectName,
      chapterId: chapterId,
      chapterName: chapterName,
      topicId: topicId,
      topicName: topicName,
      videoTitle: videoTitle,
      quizLevel: quizLevel,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      questions: questions,
      status: status,
      // NEW: Recommendation and assessment fields (v11)
      assessmentType: assessmentType,
      hasRecommendations: hasRecommendations,
      recommendationCount: recommendationCount,
      recommendationsGeneratedAt: recommendationsGeneratedAt,
      recommendationStatus: recommendationStatus,
      recommendationsHistoryId: recommendationsHistoryId,
      learningPathId: learningPathId,
      learningPathProgress: learningPathProgress,
    );
  }

  /// Create model from domain entity
  factory QuizAttemptModel.fromEntity(QuizAttempt entity) {
    return QuizAttemptModel(
      id: entity.id,
      quizId: entity.quizId,
      studentId: entity.studentId,
      answers: entity.answers,
      score: entity.score,
      passed: entity.passed,
      completedAt: entity.completedAt,
      timeTaken: entity.timeTaken,
      startTime: entity.startTime,
      attemptNumber: entity.attemptNumber,
      syncedToServer: entity.syncedToServer,
      syncRetryCount: entity.syncRetryCount,
      analytics: entity.analytics,
      subjectId: entity.subjectId,
      subjectName: entity.subjectName,
      chapterId: entity.chapterId,
      chapterName: entity.chapterName,
      topicId: entity.topicId,
      topicName: entity.topicName,
      videoTitle: entity.videoTitle,
      quizLevel: entity.quizLevel,
      totalQuestions: entity.totalQuestions,
      correctAnswers: entity.correctAnswers,
      questions: entity.questions,
      status: entity.status,
      // NEW: Recommendation and assessment fields (v11)
      assessmentType: entity.assessmentType,
      hasRecommendations: entity.hasRecommendations,
      recommendationCount: entity.recommendationCount,
      recommendationsGeneratedAt: entity.recommendationsGeneratedAt,
      recommendationStatus: entity.recommendationStatus,
      recommendationsHistoryId: entity.recommendationsHistoryId,
      learningPathId: entity.learningPathId,
      learningPathProgress: entity.learningPathProgress,
    );
  }

  /// Serialize questions to JSON string
  static String _serializeQuestions(List<Question> questions) {
    final jsonList = questions.map((q) => {
      'id': q.id,
      'questionText': q.questionText,
      'questionType': q.questionType.name,
      'options': q.options,
      'correctAnswer': q.correctAnswer,
      'explanation': q.explanation,
      'hints': q.hints,
      'difficulty': q.difficulty,
      'conceptTags': q.conceptTags,
      'topicIds': q.topicIds,
      'videoTimestamp': q.videoTimestamp,
      'points': q.points,
    }).toList();
    return jsonEncode(jsonList);
  }

  /// Deserialize questions from JSON string with error handling
  static List<Question> _deserializeQuestions(String jsonString) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final questions = <Question>[];

      for (final json in jsonList) {
        try {
          questions.add(Question(
            id: json['id'] as String? ?? 'unknown_${questions.length}',
            questionText: json['questionText'] as String? ?? '',
            questionType: _parseQuestionType(json['questionType'] as String? ?? 'mcq'),
            options: _safeStringList(json['options']),
            correctAnswer: json['correctAnswer'] as String? ?? '',
            explanation: json['explanation'] as String? ?? '',
            hints: _safeStringList(json['hints']),
            difficulty: json['difficulty'] as String? ?? 'medium',
            conceptTags: _safeStringList(json['conceptTags']),
            topicIds: _safeStringList(json['topicIds']),
            videoTimestamp: json['videoTimestamp'] as String?,
            points: json['points'] as int? ?? 1,
          ));
        } catch (e) {
          logger.warning('Failed to parse question in quiz attempt: $e');
          // Skip malformed question but continue parsing others
        }
      }

      return questions;
    } catch (e, stackTrace) {
      logger.error('Failed to deserialize questions JSON', e, stackTrace);
      return []; // Return empty list on complete parse failure
    }
  }

  /// Safely convert dynamic to List<String>
  static List<String> _safeStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').toList();
    }
    return [];
  }

  /// Parse question type from string
  static QuestionType _parseQuestionType(String typeStr) {
    switch (typeStr) {
      case 'mcq':
        return QuestionType.mcq;
      case 'trueFalse':
        return QuestionType.trueFalse;
      case 'fillBlank':
        return QuestionType.fillBlank;
      case 'match':
        return QuestionType.match;
      case 'numerical':
        return QuestionType.numerical;
      default:
        return QuestionType.mcq;
    }
  }

  /// Parse assessment type from string
  static AssessmentType _parseAssessmentType(String typeStr) {
    switch (typeStr) {
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

  /// Parse recommendation status from string
  static RecommendationStatus _parseRecommendationStatus(String statusStr) {
    switch (statusStr) {
      case 'none':
        return RecommendationStatus.none;
      case 'available':
        return RecommendationStatus.available;
      case 'viewed':
        return RecommendationStatus.viewed;
      case 'inProgress':
        return RecommendationStatus.inProgress;
      case 'completed':
        return RecommendationStatus.completed;
      case 'outdated':
        return RecommendationStatus.outdated;
      default:
        return RecommendationStatus.none;
    }
  }

  /// Create a copy with modified fields
  QuizAttemptModel copyWith({
    String? id,
    String? quizId,
    String? studentId,
    Map<String, String>? answers,
    double? score,
    bool? passed,
    DateTime? completedAt,
    int? timeTaken,
    DateTime? startTime,
    int? attemptNumber,
    bool? syncedToServer,
    int? syncRetryCount,
    Map<String, dynamic>? analytics,
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
    List<Question>? questions,
    QuizAttemptStatus? status,
    // NEW: Recommendation and assessment parameters (v11)
    AssessmentType? assessmentType,
    bool? hasRecommendations,
    int? recommendationCount,
    DateTime? recommendationsGeneratedAt,
    RecommendationStatus? recommendationStatus,
    String? recommendationsHistoryId,
    String? learningPathId,
    double? learningPathProgress,
  }) {
    return QuizAttemptModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      studentId: studentId ?? this.studentId,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      passed: passed ?? this.passed,
      completedAt: completedAt ?? this.completedAt,
      timeTaken: timeTaken ?? this.timeTaken,
      startTime: startTime ?? this.startTime,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      syncedToServer: syncedToServer ?? this.syncedToServer,
      syncRetryCount: syncRetryCount ?? this.syncRetryCount,
      analytics: analytics ?? this.analytics,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      chapterId: chapterId ?? this.chapterId,
      chapterName: chapterName ?? this.chapterName,
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      videoTitle: videoTitle ?? this.videoTitle,
      quizLevel: quizLevel ?? this.quizLevel,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      questions: questions ?? this.questions,
      status: status ?? this.status,
      // NEW: Recommendation and assessment fields (v11)
      assessmentType: assessmentType ?? this.assessmentType,
      hasRecommendations: hasRecommendations ?? this.hasRecommendations,
      recommendationCount: recommendationCount ?? this.recommendationCount,
      recommendationsGeneratedAt: recommendationsGeneratedAt ?? this.recommendationsGeneratedAt,
      recommendationStatus: recommendationStatus ?? this.recommendationStatus,
      recommendationsHistoryId: recommendationsHistoryId ?? this.recommendationsHistoryId,
      learningPathId: learningPathId ?? this.learningPathId,
      learningPathProgress: learningPathProgress ?? this.learningPathProgress,
    );
  }

  @override
  String toString() {
    return 'QuizAttemptModel(id: $id, quizId: $quizId, studentId: $studentId, '
        'score: ${(score * 100).toStringAsFixed(1)}%, passed: $passed, '
        'completedAt: $completedAt)';
  }
}
