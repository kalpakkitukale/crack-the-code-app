/// Topic data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:crack_the_code/domain/entities/content/topic.dart';

part 'topic_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TopicModel {
  final String id;
  final String name;
  final String difficulty;
  final int videoCount;
  final List<String> keywords;

  const TopicModel({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.videoCount,
    this.keywords = const [],
  });

  /// Convert from JSON
  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$TopicModelToJson(this);

  /// Convert to domain entity
  Topic toEntity() {
    return Topic(
      id: id,
      name: name,
      difficulty: difficulty,
      videoCount: videoCount,
      keywords: keywords,
    );
  }

  /// Create from domain entity
  factory TopicModel.fromEntity(Topic topic) {
    return TopicModel(
      id: topic.id,
      name: topic.name,
      difficulty: topic.difficulty,
      videoCount: topic.videoCount,
      keywords: topic.keywords,
    );
  }
}
