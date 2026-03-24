/// Collection data model for database operations
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/domain/entities/user/collection.dart';

/// Collection model for SQLite database
class CollectionModel {
  final String id;
  final String profileId;
  final String name;
  final String? description;
  final int createdAt;
  final int updatedAt;

  const CollectionModel({
    required this.id,
    this.profileId = '',
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from database map
  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map[CollectionsTable.columnId] as String,
      profileId: map[CollectionsTable.columnProfileId] as String? ?? '',
      name: map[CollectionsTable.columnName] as String,
      description: map[CollectionsTable.columnDescription] as String?,
      createdAt: map[CollectionsTable.columnCreatedAt] as int,
      updatedAt: map[CollectionsTable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      CollectionsTable.columnId: id,
      CollectionsTable.columnProfileId: profileId,
      CollectionsTable.columnName: name,
      CollectionsTable.columnDescription: description,
      CollectionsTable.columnCreatedAt: createdAt,
      CollectionsTable.columnUpdatedAt: updatedAt,
    };
  }

  /// Convert to domain entity (without videos)
  Collection toEntity() {
    return Collection(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      videos: [],
    );
  }

  /// Create from domain entity
  factory CollectionModel.fromEntity(Collection collection, {String profileId = ''}) {
    return CollectionModel(
      id: collection.id,
      profileId: profileId,
      name: collection.name,
      description: collection.description,
      createdAt: collection.createdAt.millisecondsSinceEpoch,
      updatedAt: collection.updatedAt.millisecondsSinceEpoch,
    );
  }
}
