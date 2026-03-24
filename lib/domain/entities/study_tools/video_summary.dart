/// Video Summary entity for video summaries
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_summary.freezed.dart';
part 'video_summary.g.dart';

/// Source of the summary content
enum SummarySource {
  manual,
  ai,
}

/// Style of summary presentation based on segment
enum SummaryStyle {
  visual,   // Junior: Visual bullets with icons
  standard, // Middle: Standard presentation
  exam,     // PreBoard: Exam-focused
  detailed, // Senior: Detailed with formulas
}

@freezed
class VideoSummary with _$VideoSummary {
  const factory VideoSummary({
    required String id,
    required String videoId,
    required String content,
    @Default([]) List<String> keyPoints,
    @Default(SummarySource.manual) SummarySource source,
    required String segment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VideoSummary;

  const VideoSummary._();

  factory VideoSummary.fromJson(Map<String, dynamic> json) =>
      _$VideoSummaryFromJson(json);

  /// Check if summary has key points
  bool get hasKeyPoints => keyPoints.isNotEmpty;

  /// Get the number of key points
  int get keyPointCount => keyPoints.length;

  /// Check if this is an AI-generated summary
  bool get isAiGenerated => source == SummarySource.ai;

  /// Get preview of content (first 150 characters)
  String get preview {
    if (content.length <= 150) return content;
    return '${content.substring(0, 150)}...';
  }

  /// Get word count
  int get wordCount {
    return content.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  /// Get estimated read time in minutes
  int get estimatedReadTimeMinutes {
    // Average reading speed: 200 words per minute
    return (wordCount / 200).ceil();
  }
}
