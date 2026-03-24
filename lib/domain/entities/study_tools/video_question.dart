/// Video Question entity for Q&A section
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_question.freezed.dart';
part 'video_question.g.dart';

/// Status of a question
enum QuestionStatus {
  pending,   // Awaiting answer
  answered,  // Has been answered
  rejected,  // Question was rejected/inappropriate
}

@freezed
class VideoQuestion with _$VideoQuestion {
  const factory VideoQuestion({
    required String id,
    required String videoId,
    required String profileId,
    required String question,
    String? answer,
    @Default(QuestionStatus.pending) QuestionStatus status,
    int? timestampSeconds,
    @Default(0) int upvotes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VideoQuestion;

  const VideoQuestion._();

  factory VideoQuestion.fromJson(Map<String, dynamic> json) =>
      _$VideoQuestionFromJson(json);

  /// Check if question has been answered
  bool get isAnswered => status == QuestionStatus.answered && answer != null;

  /// Check if question is pending
  bool get isPending => status == QuestionStatus.pending;

  /// Check if question was rejected
  bool get isRejected => status == QuestionStatus.rejected;

  /// Check if question has timestamp reference
  bool get hasTimestamp => timestampSeconds != null;

  /// Get formatted timestamp (HH:MM:SS or MM:SS)
  String? get formattedTimestamp {
    if (timestampSeconds == null) return null;

    final hours = timestampSeconds! ~/ 3600;
    final minutes = (timestampSeconds! % 3600) ~/ 60;
    final seconds = timestampSeconds! % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Get question preview (first 80 characters)
  String get questionPreview {
    if (question.length <= 80) return question;
    return '${question.substring(0, 80)}...';
  }

  /// Check if question is popular (based on upvotes)
  bool get isPopular => upvotes >= 5;

  /// Get time since creation
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);

  /// Check if question was asked recently (within 24 hours)
  bool get isRecent => timeSinceCreation.inHours < 24;
}
