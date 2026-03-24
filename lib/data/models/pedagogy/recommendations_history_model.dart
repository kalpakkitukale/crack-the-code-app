/// RecommendationsHistoryModel - Data model for recommendations history
library;

import 'dart:convert';
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/domain/entities/pedagogy/recommendations_history.dart';
import 'package:streamshaala/domain/entities/pedagogy/quiz_recommendation.dart';

/// Data model for recommendations history with database serialization
class RecommendationsHistoryModel {
  final String id;
  final String quizAttemptId;
  final String userId;
  final String subjectId;
  final String? topicId;
  final AssessmentType assessmentType;
  final String recommendationsJson;
  final int totalRecommendations;
  final int criticalGaps;
  final int severeGaps;
  final int estimatedMinutes;
  final int generatedAt;
  final int? viewedAt;
  final int? lastAccessedAt;
  final int viewCount;
  final String? learningPathId;
  final bool learningPathStarted;
  final int? learningPathStartedAt;
  final bool learningPathCompleted;
  final int? learningPathCompletedAt;
  final String? viewedVideoIds;
  final String? dismissedRecommendationIds;

  const RecommendationsHistoryModel({
    required this.id,
    required this.quizAttemptId,
    required this.userId,
    required this.subjectId,
    this.topicId,
    required this.assessmentType,
    required this.recommendationsJson,
    required this.totalRecommendations,
    required this.criticalGaps,
    required this.severeGaps,
    required this.estimatedMinutes,
    required this.generatedAt,
    this.viewedAt,
    this.lastAccessedAt,
    this.viewCount = 0,
    this.learningPathId,
    this.learningPathStarted = false,
    this.learningPathStartedAt,
    this.learningPathCompleted = false,
    this.learningPathCompletedAt,
    this.viewedVideoIds,
    this.dismissedRecommendationIds,
  });

  /// Convert model to database map
  Map<String, dynamic> toMap() {
    return {
      RecommendationsHistoryTable.columnId: id,
      RecommendationsHistoryTable.columnQuizAttemptId: quizAttemptId,
      RecommendationsHistoryTable.columnUserId: userId,
      RecommendationsHistoryTable.columnSubjectId: subjectId,
      RecommendationsHistoryTable.columnTopicId: topicId,
      RecommendationsHistoryTable.columnAssessmentType: assessmentType.name,
      RecommendationsHistoryTable.columnRecommendationsJson: recommendationsJson,
      RecommendationsHistoryTable.columnTotalRecommendations: totalRecommendations,
      RecommendationsHistoryTable.columnCriticalGaps: criticalGaps,
      RecommendationsHistoryTable.columnSevereGaps: severeGaps,
      RecommendationsHistoryTable.columnEstimatedMinutes: estimatedMinutes,
      RecommendationsHistoryTable.columnGeneratedAt: generatedAt,
      RecommendationsHistoryTable.columnViewedAt: viewedAt,
      RecommendationsHistoryTable.columnLastAccessedAt: lastAccessedAt,
      RecommendationsHistoryTable.columnViewCount: viewCount,
      RecommendationsHistoryTable.columnLearningPathId: learningPathId,
      RecommendationsHistoryTable.columnLearningPathStarted: learningPathStarted ? 1 : 0,
      RecommendationsHistoryTable.columnLearningPathStartedAt: learningPathStartedAt,
      RecommendationsHistoryTable.columnLearningPathCompleted: learningPathCompleted ? 1 : 0,
      RecommendationsHistoryTable.columnLearningPathCompletedAt: learningPathCompletedAt,
      RecommendationsHistoryTable.columnViewedVideoIds: viewedVideoIds,
      RecommendationsHistoryTable.columnDismissedRecommendationIds: dismissedRecommendationIds,
    };
  }

  /// Create model from database map
  factory RecommendationsHistoryModel.fromMap(Map<String, dynamic> map) {
    return RecommendationsHistoryModel(
      id: map[RecommendationsHistoryTable.columnId] as String,
      quizAttemptId: map[RecommendationsHistoryTable.columnQuizAttemptId] as String,
      userId: map[RecommendationsHistoryTable.columnUserId] as String,
      subjectId: map[RecommendationsHistoryTable.columnSubjectId] as String,
      topicId: map[RecommendationsHistoryTable.columnTopicId] as String?,
      assessmentType: _parseAssessmentType(map[RecommendationsHistoryTable.columnAssessmentType] as String),
      recommendationsJson: map[RecommendationsHistoryTable.columnRecommendationsJson] as String,
      totalRecommendations: map[RecommendationsHistoryTable.columnTotalRecommendations] as int,
      criticalGaps: map[RecommendationsHistoryTable.columnCriticalGaps] as int,
      severeGaps: map[RecommendationsHistoryTable.columnSevereGaps] as int,
      estimatedMinutes: map[RecommendationsHistoryTable.columnEstimatedMinutes] as int,
      generatedAt: map[RecommendationsHistoryTable.columnGeneratedAt] as int,
      viewedAt: map[RecommendationsHistoryTable.columnViewedAt] as int?,
      lastAccessedAt: map[RecommendationsHistoryTable.columnLastAccessedAt] as int?,
      viewCount: map[RecommendationsHistoryTable.columnViewCount] as int? ?? 0,
      learningPathId: map[RecommendationsHistoryTable.columnLearningPathId] as String?,
      learningPathStarted: (map[RecommendationsHistoryTable.columnLearningPathStarted] as int?) == 1,
      learningPathStartedAt: map[RecommendationsHistoryTable.columnLearningPathStartedAt] as int?,
      learningPathCompleted: (map[RecommendationsHistoryTable.columnLearningPathCompleted] as int?) == 1,
      learningPathCompletedAt: map[RecommendationsHistoryTable.columnLearningPathCompletedAt] as int?,
      viewedVideoIds: map[RecommendationsHistoryTable.columnViewedVideoIds] as String?,
      dismissedRecommendationIds: map[RecommendationsHistoryTable.columnDismissedRecommendationIds] as String?,
    );
  }

  /// Convert model to domain entity
  RecommendationsHistory toEntity() {
    // Parse recommendations from JSON
    List<QuizRecommendation> recommendations;
    try {
      final List<dynamic> jsonList = jsonDecode(recommendationsJson) as List<dynamic>;
      recommendations = jsonList
          .map((json) => QuizRecommendation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      recommendations = [];
    }

    // Parse viewed video IDs
    List<String> parsedViewedVideoIds;
    try {
      if (viewedVideoIds != null && viewedVideoIds!.isNotEmpty) {
        parsedViewedVideoIds = List<String>.from(jsonDecode(viewedVideoIds!) as List);
      } else {
        parsedViewedVideoIds = [];
      }
    } catch (e) {
      parsedViewedVideoIds = [];
    }

    // Parse dismissed recommendation IDs
    List<String> parsedDismissedIds;
    try {
      if (dismissedRecommendationIds != null && dismissedRecommendationIds!.isNotEmpty) {
        parsedDismissedIds = List<String>.from(jsonDecode(dismissedRecommendationIds!) as List);
      } else {
        parsedDismissedIds = [];
      }
    } catch (e) {
      parsedDismissedIds = [];
    }

    return RecommendationsHistory(
      id: id,
      quizAttemptId: quizAttemptId,
      userId: userId,
      subjectId: subjectId,
      topicId: topicId,
      assessmentType: assessmentType,
      recommendations: recommendations,
      totalRecommendations: totalRecommendations,
      criticalGaps: criticalGaps,
      severeGaps: severeGaps,
      estimatedMinutesToFix: estimatedMinutes,
      generatedAt: DateTime.fromMillisecondsSinceEpoch(generatedAt),
      viewedAt: viewedAt != null ? DateTime.fromMillisecondsSinceEpoch(viewedAt!) : null,
      lastAccessedAt: lastAccessedAt != null ? DateTime.fromMillisecondsSinceEpoch(lastAccessedAt!) : null,
      viewCount: viewCount,
      learningPathId: learningPathId,
      learningPathStarted: learningPathStarted,
      learningPathStartedAt: learningPathStartedAt != null ? DateTime.fromMillisecondsSinceEpoch(learningPathStartedAt!) : null,
      learningPathCompleted: learningPathCompleted,
      learningPathCompletedAt: learningPathCompletedAt != null ? DateTime.fromMillisecondsSinceEpoch(learningPathCompletedAt!) : null,
      viewedVideoIds: parsedViewedVideoIds,
      dismissedRecommendationIds: parsedDismissedIds,
    );
  }

  /// Create model from domain entity
  factory RecommendationsHistoryModel.fromEntity(RecommendationsHistory entity) {
    // Encode recommendations to JSON
    final recommendationsJson = jsonEncode(
      entity.recommendations.map((r) => r.toJson()).toList(),
    );

    // Encode viewed video IDs
    final viewedVideoIdsJson = entity.viewedVideoIds.isNotEmpty
        ? jsonEncode(entity.viewedVideoIds)
        : null;

    // Encode dismissed recommendation IDs
    final dismissedIdsJson = entity.dismissedRecommendationIds.isNotEmpty
        ? jsonEncode(entity.dismissedRecommendationIds)
        : null;

    return RecommendationsHistoryModel(
      id: entity.id,
      quizAttemptId: entity.quizAttemptId,
      userId: entity.userId,
      subjectId: entity.subjectId,
      topicId: entity.topicId,
      assessmentType: entity.assessmentType,
      recommendationsJson: recommendationsJson,
      totalRecommendations: entity.totalRecommendations,
      criticalGaps: entity.criticalGaps,
      severeGaps: entity.severeGaps,
      estimatedMinutes: entity.estimatedMinutesToFix,
      generatedAt: entity.generatedAt.millisecondsSinceEpoch,
      viewedAt: entity.viewedAt?.millisecondsSinceEpoch,
      lastAccessedAt: entity.lastAccessedAt?.millisecondsSinceEpoch,
      viewCount: entity.viewCount,
      learningPathId: entity.learningPathId,
      learningPathStarted: entity.learningPathStarted,
      learningPathStartedAt: entity.learningPathStartedAt?.millisecondsSinceEpoch,
      learningPathCompleted: entity.learningPathCompleted,
      learningPathCompletedAt: entity.learningPathCompletedAt?.millisecondsSinceEpoch,
      viewedVideoIds: viewedVideoIdsJson,
      dismissedRecommendationIds: dismissedIdsJson,
    );
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

  @override
  String toString() {
    return 'RecommendationsHistoryModel(id: $id, quizAttemptId: $quizAttemptId, '
        'totalRecommendations: $totalRecommendations, assessmentType: ${assessmentType.name})';
  }
}
