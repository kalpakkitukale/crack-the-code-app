/// Class level data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:crack_the_code/data/models/content/stream_model.dart';
import 'package:crack_the_code/domain/entities/content/class_level.dart';

part 'class_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClassModel {
  final String id;
  final String name;
  final List<StreamModel> streams;

  const ClassModel({
    required this.id,
    required this.name,
    required this.streams,
  });

  /// Convert from JSON
  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ClassModelToJson(this);

  /// Convert to domain entity
  ClassLevel toEntity() {
    return ClassLevel(
      id: id,
      name: name,
      streams: streams.map((s) => s.toEntity()).toList(),
    );
  }

  /// Create from domain entity
  factory ClassModel.fromEntity(ClassLevel classLevel) {
    return ClassModel(
      id: classLevel.id,
      name: classLevel.name,
      streams: classLevel.streams.map((s) => StreamModel.fromEntity(s)).toList(),
    );
  }
}
