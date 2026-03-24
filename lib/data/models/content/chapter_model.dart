/// Chapter data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:streamshaala/data/models/content/topic_model.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';

part 'chapter_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChapterModel {
  final String id;
  final int number;
  final String name;
  final String? description;
  final List<TopicModel> topics;
  final List<String> keywords;

  const ChapterModel({
    required this.id,
    required this.number,
    required this.name,
    this.description,
    required this.topics,
    this.keywords = const [],
  });

  /// Convert from JSON
  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);

  /// Convert to domain entity
  Chapter toEntity() {
    return Chapter(
      id: id,
      number: number,
      name: name,
      description: description,
      topics: topics.map((t) => t.toEntity()).toList(),
      keywords: keywords,
    );
  }

  /// Create from domain entity
  factory ChapterModel.fromEntity(Chapter chapter) {
    return ChapterModel(
      id: chapter.id,
      number: chapter.number,
      name: chapter.name,
      description: chapter.description,
      topics: chapter.topics.map((t) => TopicModel.fromEntity(t)).toList(),
      keywords: chapter.keywords,
    );
  }
}
