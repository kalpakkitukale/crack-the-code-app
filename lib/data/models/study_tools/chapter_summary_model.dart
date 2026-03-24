/// Chapter Summary model for database and JSON serialization
library;

import 'dart:convert';

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_summary.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart';

/// Model class for ChapterSummary with database and JSON conversion
class ChapterSummaryModel {
  final String id;
  final String chapterId;
  final String subjectId;
  final String title;
  final String content;
  final String keyPointsJson;
  final String learningObjectivesJson;
  final String source;
  final String segment;
  final int estimatedReadTimeMinutes;
  final int createdAt;
  final int updatedAt;

  const ChapterSummaryModel({
    required this.id,
    required this.chapterId,
    required this.subjectId,
    required this.title,
    required this.content,
    required this.keyPointsJson,
    required this.learningObjectivesJson,
    required this.source,
    required this.segment,
    required this.estimatedReadTimeMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get key points as list
  List<String> get keyPoints {
    try {
      final decoded = jsonDecode(keyPointsJson) as List<dynamic>;
      return decoded.cast<String>();
    } catch (_) {
      return [];
    }
  }

  /// Get learning objectives as list
  List<String> get learningObjectives {
    try {
      final decoded = jsonDecode(learningObjectivesJson) as List<dynamic>;
      return decoded.cast<String>();
    } catch (_) {
      return [];
    }
  }

  /// Convert from database map
  factory ChapterSummaryModel.fromMap(Map<String, dynamic> map) {
    return ChapterSummaryModel(
      id: map[ChapterSummariesTable.columnId] as String,
      chapterId: map[ChapterSummariesTable.columnChapterId] as String,
      subjectId: map[ChapterSummariesTable.columnSubjectId] as String,
      title: map[ChapterSummariesTable.columnTitle] as String,
      content: map[ChapterSummariesTable.columnContent] as String,
      keyPointsJson: map[ChapterSummariesTable.columnKeyPoints] as String? ?? '[]',
      learningObjectivesJson: map[ChapterSummariesTable.columnLearningObjectives] as String? ?? '[]',
      source: map[ChapterSummariesTable.columnSource] as String? ?? 'manual',
      segment: map[ChapterSummariesTable.columnSegment] as String,
      estimatedReadTimeMinutes: map[ChapterSummariesTable.columnEstimatedReadTime] as int? ?? 0,
      createdAt: map[ChapterSummariesTable.columnCreatedAt] as int,
      updatedAt: map[ChapterSummariesTable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      ChapterSummariesTable.columnId: id,
      ChapterSummariesTable.columnChapterId: chapterId,
      ChapterSummariesTable.columnSubjectId: subjectId,
      ChapterSummariesTable.columnTitle: title,
      ChapterSummariesTable.columnContent: content,
      ChapterSummariesTable.columnKeyPoints: keyPointsJson,
      ChapterSummariesTable.columnLearningObjectives: learningObjectivesJson,
      ChapterSummariesTable.columnSource: source,
      ChapterSummariesTable.columnSegment: segment,
      ChapterSummariesTable.columnEstimatedReadTime: estimatedReadTimeMinutes,
      ChapterSummariesTable.columnCreatedAt: createdAt,
      ChapterSummariesTable.columnUpdatedAt: updatedAt,
    };
  }

  /// Convert to domain entity
  ChapterSummary toEntity() {
    return ChapterSummary(
      id: id,
      chapterId: chapterId,
      subjectId: subjectId,
      title: title,
      content: content,
      keyPoints: keyPoints,
      learningObjectives: learningObjectives,
      source: source == 'ai' ? SummarySource.ai : SummarySource.manual,
      segment: segment,
      estimatedReadTimeMinutes: estimatedReadTimeMinutes,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  /// Create from domain entity
  factory ChapterSummaryModel.fromEntity(ChapterSummary summary) {
    return ChapterSummaryModel(
      id: summary.id,
      chapterId: summary.chapterId,
      subjectId: summary.subjectId,
      title: summary.title,
      content: summary.content,
      keyPointsJson: jsonEncode(summary.keyPoints),
      learningObjectivesJson: jsonEncode(summary.learningObjectives),
      source: summary.source == SummarySource.ai ? 'ai' : 'manual',
      segment: summary.segment,
      estimatedReadTimeMinutes: summary.estimatedReadTimeMinutes,
      createdAt: summary.createdAt.millisecondsSinceEpoch,
      updatedAt: summary.updatedAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading from asset files)
  factory ChapterSummaryModel.fromJson(
    Map<String, dynamic> json,
    String chapterId,
    String subjectId,
    String segment,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keyPoints = json['keyPoints'] as List<dynamic>?;
    final learningObjectives = json['learningObjectives'] as List<dynamic>?;

    return ChapterSummaryModel(
      id: json['id'] as String? ?? 'chsum_${chapterId}_$now',
      chapterId: chapterId,
      subjectId: subjectId,
      title: json['title'] as String? ?? 'Chapter Summary',
      content: json['content'] as String? ?? '',
      keyPointsJson: keyPoints != null ? jsonEncode(keyPoints) : '[]',
      learningObjectivesJson: learningObjectives != null ? jsonEncode(learningObjectives) : '[]',
      source: json['source'] as String? ?? 'manual',
      segment: segment,
      estimatedReadTimeMinutes: json['estimatedReadTimeMinutes'] as int? ?? 0,
      createdAt: json['createdAt'] as int? ?? now,
      updatedAt: json['updatedAt'] as int? ?? now,
    );
  }
}
