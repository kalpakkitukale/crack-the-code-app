/// Video Question data model for database operations
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/domain/entities/study_tools/video_question.dart';

/// Video Question model for SQLite database
class VideoQuestionModel {
  final String id;
  final String videoId;
  final String profileId;
  final String question;
  final String? answer;
  final String status;
  final int? timestampSeconds;
  final int upvotes;
  final int createdAt;
  final int updatedAt;

  const VideoQuestionModel({
    required this.id,
    required this.videoId,
    this.profileId = '',
    required this.question,
    this.answer,
    required this.status,
    this.timestampSeconds,
    required this.upvotes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from database map
  factory VideoQuestionModel.fromMap(Map<String, dynamic> map) {
    return VideoQuestionModel(
      id: map[VideoQATable.columnId] as String,
      videoId: map[VideoQATable.columnVideoId] as String,
      profileId: map[VideoQATable.columnProfileId] as String? ?? '',
      question: map[VideoQATable.columnQuestion] as String,
      answer: map[VideoQATable.columnAnswer] as String?,
      status: map[VideoQATable.columnStatus] as String? ?? 'pending',
      timestampSeconds: map[VideoQATable.columnTimestampSeconds] as int?,
      upvotes: map[VideoQATable.columnUpvotes] as int? ?? 0,
      createdAt: map[VideoQATable.columnCreatedAt] as int,
      updatedAt: map[VideoQATable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      VideoQATable.columnId: id,
      VideoQATable.columnVideoId: videoId,
      VideoQATable.columnProfileId: profileId,
      VideoQATable.columnQuestion: question,
      VideoQATable.columnAnswer: answer,
      VideoQATable.columnStatus: status,
      VideoQATable.columnTimestampSeconds: timestampSeconds,
      VideoQATable.columnUpvotes: upvotes,
      VideoQATable.columnCreatedAt: createdAt,
      VideoQATable.columnUpdatedAt: updatedAt,
    };
  }

  /// Get status as enum
  QuestionStatus get statusEnum {
    switch (status) {
      case 'answered':
        return QuestionStatus.answered;
      case 'rejected':
        return QuestionStatus.rejected;
      default:
        return QuestionStatus.pending;
    }
  }

  /// Convert to domain entity
  VideoQuestion toEntity() {
    return VideoQuestion(
      id: id,
      videoId: videoId,
      profileId: profileId,
      question: question,
      answer: answer,
      status: statusEnum,
      timestampSeconds: timestampSeconds,
      upvotes: upvotes,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  /// Create from domain entity
  factory VideoQuestionModel.fromEntity(VideoQuestion question) {
    return VideoQuestionModel(
      id: question.id,
      videoId: question.videoId,
      profileId: question.profileId,
      question: question.question,
      answer: question.answer,
      status: question.status.name,
      timestampSeconds: question.timestampSeconds,
      upvotes: question.upvotes,
      createdAt: question.createdAt.millisecondsSinceEpoch,
      updatedAt: question.updatedAt.millisecondsSinceEpoch,
    );
  }

  /// Create a copy with a new profile ID
  VideoQuestionModel copyWithProfileId(String profileId) {
    return VideoQuestionModel(
      id: id,
      videoId: videoId,
      profileId: profileId,
      question: question,
      answer: answer,
      status: status,
      timestampSeconds: timestampSeconds,
      upvotes: upvotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from JSON (for loading from asset files - FAQs)
  factory VideoQuestionModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().millisecondsSinceEpoch;

    return VideoQuestionModel(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      profileId: json['profileId'] as String? ?? '',
      question: json['question'] as String,
      answer: json['answer'] as String?,
      status: json['status'] as String? ?? 'answered',
      timestampSeconds: json['timestampSeconds'] as int?,
      upvotes: json['upvotes'] as int? ?? 0,
      createdAt: json['createdAt'] as int? ?? now,
      updatedAt: json['updatedAt'] as int? ?? now,
    );
  }
}
