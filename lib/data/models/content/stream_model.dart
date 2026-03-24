/// Stream data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:crack_the_code/domain/entities/content/stream.dart' as entity;

part 'stream_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamModel {
  final String id;
  final String name;
  final List<String> subjects;

  const StreamModel({
    required this.id,
    required this.name,
    required this.subjects,
  });

  /// Convert from JSON
  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      _$StreamModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$StreamModelToJson(this);

  /// Convert to domain entity
  entity.Stream toEntity() {
    return entity.Stream(
      id: id,
      name: name,
      subjects: subjects,
    );
  }

  /// Create from domain entity
  factory StreamModel.fromEntity(entity.Stream stream) {
    return StreamModel(
      id: stream.id,
      name: stream.name,
      subjects: stream.subjects,
    );
  }
}
