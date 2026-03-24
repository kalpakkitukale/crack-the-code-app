/// Video Summary data model for database operations
library;

import 'dart:convert';
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart';

/// Video Summary model for SQLite database
class VideoSummaryModel {
  final String id;
  final String videoId;
  final String content;
  final String keyPointsJson;
  final String source;
  final String segment;
  final int createdAt;
  final int updatedAt;

  const VideoSummaryModel({
    required this.id,
    required this.videoId,
    required this.content,
    required this.keyPointsJson,
    required this.source,
    required this.segment,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from database map
  factory VideoSummaryModel.fromMap(Map<String, dynamic> map) {
    return VideoSummaryModel(
      id: map[VideoSummariesTable.columnId] as String,
      videoId: map[VideoSummariesTable.columnVideoId] as String,
      content: map[VideoSummariesTable.columnContent] as String,
      keyPointsJson: map[VideoSummariesTable.columnKeyPoints] as String? ?? '[]',
      source: map[VideoSummariesTable.columnSource] as String? ?? 'manual',
      segment: map[VideoSummariesTable.columnSegment] as String,
      createdAt: map[VideoSummariesTable.columnCreatedAt] as int,
      updatedAt: map[VideoSummariesTable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      VideoSummariesTable.columnId: id,
      VideoSummariesTable.columnVideoId: videoId,
      VideoSummariesTable.columnContent: content,
      VideoSummariesTable.columnKeyPoints: keyPointsJson,
      VideoSummariesTable.columnSource: source,
      VideoSummariesTable.columnSegment: segment,
      VideoSummariesTable.columnCreatedAt: createdAt,
      VideoSummariesTable.columnUpdatedAt: updatedAt,
    };
  }

  /// Get key points as list
  List<String> get keyPoints {
    try {
      final decoded = jsonDecode(keyPointsJson) as List<dynamic>;
      return decoded.cast<String>();
    } catch (_) {
      return [];
    }
  }

  /// Convert to domain entity
  VideoSummary toEntity() {
    return VideoSummary(
      id: id,
      videoId: videoId,
      content: content,
      keyPoints: keyPoints,
      source: source == 'ai' ? SummarySource.ai : SummarySource.manual,
      segment: segment,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  /// Create from domain entity
  factory VideoSummaryModel.fromEntity(VideoSummary summary) {
    return VideoSummaryModel(
      id: summary.id,
      videoId: summary.videoId,
      content: summary.content,
      keyPointsJson: jsonEncode(summary.keyPoints),
      source: summary.source == SummarySource.ai ? 'ai' : 'manual',
      segment: summary.segment,
      createdAt: summary.createdAt.millisecondsSinceEpoch,
      updatedAt: summary.updatedAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading from asset files)
  factory VideoSummaryModel.fromJson(Map<String, dynamic> json) {
    final keyPoints = json['keyPoints'] as List<dynamic>?;
    final now = DateTime.now().millisecondsSinceEpoch;

    return VideoSummaryModel(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      content: json['content'] as String,
      keyPointsJson: keyPoints != null ? jsonEncode(keyPoints) : '[]',
      source: json['source'] as String? ?? 'manual',
      segment: json['segment'] as String? ?? 'junior',
      createdAt: json['createdAt'] as int? ?? now,
      updatedAt: json['updatedAt'] as int? ?? now,
    );
  }
}
