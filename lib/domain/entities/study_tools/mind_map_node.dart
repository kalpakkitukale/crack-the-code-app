/// Mind Map Node entity for chapter mind maps
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mind_map_node.freezed.dart';
part 'mind_map_node.g.dart';

/// Node type for mind map visualization
enum MindMapNodeType {
  root,      // Central topic - Indigo #3F51B5
  mainTopic, // Main branches - Green #4CAF50
  subTopic,  // Sub branches - Orange #FF9800
  detail,    // Details - Purple #9C27B0
  example,   // Examples - Cyan #00BCD4
}

@freezed
class MindMapNode with _$MindMapNode {
  const factory MindMapNode({
    required String id,
    required String chapterId,
    required String label,
    String? description,
    String? parentId,
    @Default(0.0) double positionX,
    @Default(0.0) double positionY,
    String? color,
    @Default(MindMapNodeType.detail) MindMapNodeType nodeType,
    required String segment,
    @Default(0) int orderIndex,
    required DateTime createdAt,
  }) = _MindMapNode;

  const MindMapNode._();

  factory MindMapNode.fromJson(Map<String, dynamic> json) =>
      _$MindMapNodeFromJson(json);

  /// Check if this is a root node (no parent)
  bool get isRoot => parentId == null || parentId!.isEmpty;

  /// Check if this node has a description
  bool get hasDescription => description != null && description!.isNotEmpty;

  /// Check if this node has a custom color
  bool get hasCustomColor => color != null && color!.isNotEmpty;

  /// Get label preview (first 30 characters)
  String get labelPreview {
    if (label.length <= 30) return label;
    return '${label.substring(0, 30)}...';
  }
}

/// Complete Mind Map containing all nodes for a chapter
@freezed
class MindMap with _$MindMap {
  const factory MindMap({
    required String chapterId,
    required String segment,
    required List<MindMapNode> nodes,
  }) = _MindMap;

  const MindMap._();

  factory MindMap.fromJson(Map<String, dynamic> json) =>
      _$MindMapFromJson(json);

  /// Get all root nodes
  List<MindMapNode> get rootNodes =>
      nodes.where((node) => node.isRoot).toList();

  /// Get the main root node (first root)
  MindMapNode? get rootNode {
    try {
      return nodes.firstWhere((node) => node.isRoot);
    } catch (_) {
      return nodes.isNotEmpty ? nodes.first : null;
    }
  }

  /// Get children of a specific node
  List<MindMapNode> getChildren(String parentId) =>
      nodes.where((node) => node.parentId == parentId).toList();

  /// Get children IDs of a specific node
  List<String> getChildrenIds(String parentId) =>
      getChildren(parentId).map((n) => n.id).toList();

  /// Check if a node has children
  bool hasChildren(String nodeId) =>
      nodes.any((node) => node.parentId == nodeId);

  /// Get node by ID
  MindMapNode? getNodeById(String nodeId) {
    try {
      return nodes.firstWhere((node) => node.id == nodeId);
    } catch (_) {
      return null;
    }
  }

  /// Get total node count
  int get nodeCount => nodes.length;

  /// Get depth of the mind map (maximum level)
  int get depth {
    int maxDepth = 0;

    void calculateDepth(String? parentId, int currentDepth) {
      final children = parentId == null
          ? rootNodes
          : getChildren(parentId);

      if (children.isEmpty) {
        if (currentDepth > maxDepth) maxDepth = currentDepth;
        return;
      }

      for (final child in children) {
        calculateDepth(child.id, currentDepth + 1);
      }
    }

    calculateDepth(null, 0);
    return maxDepth;
  }

  /// Check if mind map is empty
  bool get isEmpty => nodes.isEmpty;

  /// Check if mind map has content
  bool get hasContent => nodes.isNotEmpty;
}
