/// Mind Map Node data model for database operations
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/study_tools/mind_map_node.dart';

/// Mind Map Node model for SQLite database
class MindMapNodeModel {
  final String id;
  final String chapterId;
  final String label;
  final String? description;
  final String? parentId;
  final double positionX;
  final double positionY;
  final String? color;
  final String nodeType;
  final String segment;
  final int orderIndex;
  final int createdAt;

  const MindMapNodeModel({
    required this.id,
    required this.chapterId,
    required this.label,
    this.description,
    this.parentId,
    required this.positionX,
    required this.positionY,
    this.color,
    this.nodeType = 'detail',
    required this.segment,
    required this.orderIndex,
    required this.createdAt,
  });

  /// Convert from database map
  factory MindMapNodeModel.fromMap(Map<String, dynamic> map) {
    return MindMapNodeModel(
      id: map[MindMapNodesTable.columnId] as String,
      chapterId: map[MindMapNodesTable.columnChapterId] as String,
      label: map[MindMapNodesTable.columnLabel] as String,
      description: map[MindMapNodesTable.columnDescription] as String?,
      parentId: map[MindMapNodesTable.columnParentId] as String?,
      positionX: (map[MindMapNodesTable.columnPositionX] as num?)?.toDouble() ?? 0.0,
      positionY: (map[MindMapNodesTable.columnPositionY] as num?)?.toDouble() ?? 0.0,
      color: map[MindMapNodesTable.columnColor] as String?,
      segment: map[MindMapNodesTable.columnSegment] as String,
      orderIndex: map[MindMapNodesTable.columnOrderIndex] as int? ?? 0,
      createdAt: map[MindMapNodesTable.columnCreatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      MindMapNodesTable.columnId: id,
      MindMapNodesTable.columnChapterId: chapterId,
      MindMapNodesTable.columnLabel: label,
      MindMapNodesTable.columnDescription: description,
      MindMapNodesTable.columnParentId: parentId,
      MindMapNodesTable.columnPositionX: positionX,
      MindMapNodesTable.columnPositionY: positionY,
      MindMapNodesTable.columnColor: color,
      MindMapNodesTable.columnSegment: segment,
      MindMapNodesTable.columnOrderIndex: orderIndex,
      MindMapNodesTable.columnCreatedAt: createdAt,
    };
  }

  /// Convert to domain entity
  MindMapNode toEntity() {
    return MindMapNode(
      id: id,
      chapterId: chapterId,
      label: label,
      description: description,
      parentId: parentId,
      positionX: positionX,
      positionY: positionY,
      color: color,
      nodeType: _parseNodeType(nodeType),
      segment: segment,
      orderIndex: orderIndex,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }

  /// Create from domain entity
  factory MindMapNodeModel.fromEntity(MindMapNode node) {
    return MindMapNodeModel(
      id: node.id,
      chapterId: node.chapterId,
      label: node.label,
      description: node.description,
      parentId: node.parentId,
      positionX: node.positionX,
      positionY: node.positionY,
      color: node.color,
      nodeType: node.nodeType.name,
      segment: node.segment,
      orderIndex: node.orderIndex,
      createdAt: node.createdAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading from asset files)
  factory MindMapNodeModel.fromJson(Map<String, dynamic> json, String chapterId, String segment) {
    final now = DateTime.now().millisecondsSinceEpoch;

    return MindMapNodeModel(
      id: json['id'] as String,
      chapterId: chapterId,
      label: json['label'] as String,
      description: json['description'] as String?,
      parentId: json['parentId'] as String?,
      positionX: (json['positionX'] as num?)?.toDouble() ?? 0.0,
      positionY: (json['positionY'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
      nodeType: json['nodeType'] as String? ?? 'detail',
      segment: segment,
      orderIndex: json['orderIndex'] as int? ?? 0,
      createdAt: json['createdAt'] as int? ?? now,
    );
  }

  /// Parse nodeType string to enum
  static MindMapNodeType _parseNodeType(String type) {
    return switch (type.toLowerCase()) {
      'root' => MindMapNodeType.root,
      'maintopic' || 'main_topic' => MindMapNodeType.mainTopic,
      'subtopic' || 'sub_topic' => MindMapNodeType.subTopic,
      'detail' => MindMapNodeType.detail,
      'example' => MindMapNodeType.example,
      _ => MindMapNodeType.detail,
    };
  }
}
