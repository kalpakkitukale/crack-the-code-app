/// Subject data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:streamshaala/data/models/content/chapter_model.dart';
import 'package:streamshaala/domain/entities/content/subject.dart';

part 'subject_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubjectModel {
  final String id;
  final String name;
  final String? icon;
  final String? color;
  final String boardId;
  final String classId;
  final String streamId;
  final int totalChapters;
  final List<ChapterModel> chapters;
  final List<String> keywords;

  const SubjectModel({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.boardId,
    required this.classId,
    required this.streamId,
    required this.totalChapters,
    required this.chapters,
    this.keywords = const [],
  });

  /// Convert from JSON
  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);

  /// Convert to domain entity
  Subject toEntity() {
    return Subject(
      id: id,
      name: name,
      icon: icon,
      color: color,
      boardId: boardId,
      classId: classId,
      streamId: streamId,
      totalChapters: totalChapters,
      chapters: chapters.map((c) => c.toEntity()).toList(),
      keywords: keywords,
    );
  }

  /// Create from domain entity
  factory SubjectModel.fromEntity(Subject subject) {
    return SubjectModel(
      id: subject.id,
      name: subject.name,
      icon: subject.icon,
      color: subject.color,
      boardId: subject.boardId,
      classId: subject.classId,
      streamId: subject.streamId,
      totalChapters: subject.totalChapters,
      chapters: subject.chapters.map((c) => ChapterModel.fromEntity(c)).toList(),
      keywords: subject.keywords,
    );
  }
}
