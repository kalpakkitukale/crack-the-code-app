/// Data model for LearningPath persistence
library;

import 'dart:convert';

import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';

/// Database model for learning paths
class LearningPathModel {
  final String id;
  final String studentId;
  final String subjectId;
  final String? targetConceptId;
  final String nodesJson; // JSON array of PathNode objects
  final int currentNodeIndex;
  final String completedNodeIds; // JSON array ['node1', 'node2']
  final String status; // active, completed, paused, abandoned
  final int createdAt; // Unix timestamp in milliseconds
  final int lastUpdatedAt; // Unix timestamp in milliseconds
  final int? completedAt; // Unix timestamp in milliseconds
  final String? metadataJson; // JSON object

  const LearningPathModel({
    required this.id,
    required this.studentId,
    required this.subjectId,
    this.targetConceptId,
    required this.nodesJson,
    required this.currentNodeIndex,
    required this.completedNodeIds,
    required this.status,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.completedAt,
    this.metadataJson,
  });

  /// Convert from domain entity to database model
  factory LearningPathModel.fromEntity(LearningPath path) {
    // Serialize nodes to JSON
    final nodesJson = jsonEncode(
      path.nodes.map((node) => _pathNodeToJson(node)).toList(),
    );

    // Extract completed node IDs
    final completedIds = path.nodes
        .where((node) => node.completed)
        .map((node) => node.id)
        .toList();

    return LearningPathModel(
      id: path.id,
      studentId: path.studentId,
      subjectId: path.subjectId,
      targetConceptId: path.metadata?['targetConceptId'] as String?,
      nodesJson: nodesJson,
      currentNodeIndex: path.currentNodeIndex,
      completedNodeIds: jsonEncode(completedIds),
      status: path.status.name,
      createdAt: path.createdAt.millisecondsSinceEpoch,
      lastUpdatedAt: path.lastUpdated.millisecondsSinceEpoch,
      completedAt: path.status == PathStatus.completed
          ? (path.metadata?['completedAt'] as int? ??
              DateTime.now().millisecondsSinceEpoch)
          : null,
      metadataJson: path.metadata != null ? jsonEncode(path.metadata) : null,
    );
  }

  /// Convert from database model to domain entity
  LearningPath toEntity() {
    // Deserialize nodes from JSON
    final nodesList = jsonDecode(nodesJson) as List<dynamic>;
    final nodes =
        nodesList.map((json) => _pathNodeFromJson(json as Map<String, dynamic>)).toList();

    // Parse metadata
    Map<String, dynamic>? metadata;
    if (metadataJson != null && metadataJson!.isNotEmpty) {
      metadata = jsonDecode(metadataJson!) as Map<String, dynamic>;
    }

    // Add completion info to metadata
    if (completedAt != null) {
      metadata ??= {};
      metadata['completedAt'] = completedAt;
    }

    return LearningPath(
      id: id,
      studentId: studentId,
      subjectId: subjectId,
      nodes: nodes,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(lastUpdatedAt),
      status: PathStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => PathStatus.active,
      ),
      currentNodeIndex: currentNodeIndex,
      metadata: metadata,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'subject_id': subjectId,
      'target_concept_id': targetConceptId,
      'nodes': nodesJson,
      'current_node_index': currentNodeIndex,
      'completed_node_ids': completedNodeIds,
      'status': status,
      'created_at': createdAt,
      'last_updated': lastUpdatedAt,
      'completed_at': completedAt,
      'metadata': metadataJson,
    };
  }

  /// Convert from database map
  factory LearningPathModel.fromMap(Map<String, dynamic> map) {
    return LearningPathModel(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      subjectId: map['subject_id'] as String,
      targetConceptId: map['target_concept_id'] as String?,
      nodesJson: map['nodes'] as String,
      currentNodeIndex: map['current_node_index'] as int,
      completedNodeIds: map['completed_node_ids'] as String,
      status: map['status'] as String,
      createdAt: map['created_at'] as int,
      lastUpdatedAt: map['last_updated'] as int,
      completedAt: map['completed_at'] as int?,
      metadataJson: map['metadata'] as String?,
    );
  }

  /// Serialize PathNode to JSON
  static Map<String, dynamic> _pathNodeToJson(PathNode node) {
    return {
      'id': node.id,
      'title': node.title,
      'description': node.description,
      'type': node.type.name,
      'entityId': node.entityId,
      'estimatedDuration': node.estimatedDuration,
      'difficulty': node.difficulty,
      'completed': node.completed,
      'locked': node.locked,
      'completedAt': node.completedAt?.millisecondsSinceEpoch,
      'scorePercentage': node.scorePercentage,
      'prerequisites': node.prerequisites,
    };
  }

  /// Deserialize PathNode from JSON
  static PathNode _pathNodeFromJson(Map<String, dynamic> json) {
    return PathNode(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: PathNodeType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => PathNodeType.video,
      ),
      entityId: json['entityId'] as String,
      estimatedDuration: json['estimatedDuration'] as int,
      difficulty: json['difficulty'] as String,
      completed: json['completed'] as bool? ?? false,
      locked: json['locked'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'] as int)
          : null,
      scorePercentage: (json['scorePercentage'] as num?)?.toDouble(),
      prerequisites: (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningPathModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LearningPathModel{id: $id, studentId: $studentId, status: $status}';
  }
}
