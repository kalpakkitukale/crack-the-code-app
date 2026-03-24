/// Chapter Summary entity for chapter-level summaries
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart';

part 'chapter_summary.freezed.dart';
part 'chapter_summary.g.dart';

/// Chapter Summary entity
/// Represents a curated overview of an entire chapter with key points and learning objectives
@freezed
class ChapterSummary with _$ChapterSummary {
  const factory ChapterSummary({
    required String id,
    required String chapterId,
    required String subjectId,
    required String title,
    required String content,
    @Default([]) List<String> keyPoints,
    @Default([]) List<String> learningObjectives,
    @Default(SummarySource.manual) SummarySource source,
    required String segment,
    @Default(0) int estimatedReadTimeMinutes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChapterSummary;

  const ChapterSummary._();

  factory ChapterSummary.fromJson(Map<String, dynamic> json) =>
      _$ChapterSummaryFromJson(json);

  /// Check if summary has key points
  bool get hasKeyPoints => keyPoints.isNotEmpty;

  /// Get the number of key points
  int get keyPointCount => keyPoints.length;

  /// Check if summary has learning objectives
  bool get hasLearningObjectives => learningObjectives.isNotEmpty;

  /// Get the number of learning objectives
  int get learningObjectiveCount => learningObjectives.length;

  /// Check if this is an AI-generated summary
  bool get isAiGenerated => source == SummarySource.ai;

  /// Get preview of content (first 150 characters)
  String get preview {
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  /// Get word count
  int get wordCount {
    return content
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  /// Calculate estimated read time if not provided
  int get calculatedReadTimeMinutes {
    if (estimatedReadTimeMinutes > 0) return estimatedReadTimeMinutes;
    // Average reading speed: 200 words per minute
    return (wordCount / 200).ceil();
  }
}
