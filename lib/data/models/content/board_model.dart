/// Board data model for JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:streamshaala/data/models/content/class_model.dart';
import 'package:streamshaala/domain/entities/content/board.dart';

part 'board_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BoardModel {
  final String id;
  final String name;
  final String fullName;
  final String description;
  final String? icon;
  final List<ClassModel> classes;

  const BoardModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    this.icon,
    required this.classes,
  });

  /// Convert from JSON
  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$BoardModelToJson(this);

  /// Convert to domain entity
  Board toEntity() {
    return Board(
      id: id,
      name: name,
      fullName: fullName,
      description: description,
      icon: icon,
      classes: classes.map((c) => c.toEntity()).toList(),
    );
  }

  /// Create from domain entity
  factory BoardModel.fromEntity(Board board) {
    return BoardModel(
      id: board.id,
      name: board.name,
      fullName: board.fullName,
      description: board.description,
      icon: board.icon,
      classes: board.classes.map((c) => ClassModel.fromEntity(c)).toList(),
    );
  }
}
