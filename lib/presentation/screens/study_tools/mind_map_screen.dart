/// Mind Map Screen for visualizing chapter concepts
/// Enhanced with GraphView for professional visualization
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/domain/entities/study_tools/mind_map_node.dart';
import 'package:streamshaala/presentation/providers/study_tools/mind_map_provider.dart';

/// Mind Map Screen
/// Displays an interactive mind map for a chapter using GraphView
class MindMapScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const MindMapScreen({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends ConsumerState<MindMapScreen> {
  final TransformationController _transformationController =
      TransformationController();

  // GraphView components
  Graph graph = Graph();
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  // Track collapsed nodes
  final Set<String> _collapsedNodes = {};

  // Store graph nodes for reference
  final Map<String, Node> _graphNodes = {};

  // Track current mind map to avoid rebuilding unnecessarily
  String? _currentMindMapId;

  @override
  void initState() {
    super.initState();
    // Configure the tree layout
    builder
      ..siblingSeparation = 50
      ..levelSeparation = 120
      ..subtreeSeparation = 80
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  /// Build the graph from MindMap data - only if changed
  void _buildGraphIfNeeded(MindMap mindMap) {
    final mapId = '${mindMap.chapterId}_${mindMap.nodeCount}';
    if (_currentMindMapId == mapId) {
      return;
    }

    _currentMindMapId = mapId;
    _rebuildGraph(mindMap);
  }

  /// Rebuild the graph based on current collapsed state
  void _rebuildGraph(MindMap mindMap) {
    graph = Graph();
    _graphNodes.clear();

    // Get visible nodes (not hidden by collapsed parents)
    final visibleNodeIds = _getVisibleNodeIds(mindMap);

    // Create nodes for visible nodes only
    for (final nodeId in visibleNodeIds) {
      final node = Node.Id(nodeId);
      _graphNodes[nodeId] = node;
      graph.addNode(node);
    }

    // Create edges (parent -> child connections) for visible nodes only
    for (final nodeId in visibleNodeIds) {
      final mindMapNode = mindMap.getNodeById(nodeId);
      final parentGraphNode = _graphNodes[nodeId];

      if (mindMapNode != null && parentGraphNode != null) {
        // Only add edges to visible children
        final childrenIds = mindMap.getChildrenIds(nodeId);
        for (final childId in childrenIds) {
          if (visibleNodeIds.contains(childId)) {
            final childGraphNode = _graphNodes[childId];
            if (childGraphNode != null) {
              graph.addEdge(parentGraphNode, childGraphNode);
            }
          }
        }
      }
    }
  }

  /// Get all visible node IDs (not hidden by collapsed ancestors)
  Set<String> _getVisibleNodeIds(MindMap mindMap) {
    final visible = <String>{};

    final rootNode = mindMap.rootNode;
    if (rootNode == null) return visible;

    void traverse(String nodeId) {
      visible.add(nodeId);

      // If this node is collapsed, don't add its children
      if (_collapsedNodes.contains(nodeId)) {
        return;
      }

      final childrenIds = mindMap.getChildrenIds(nodeId);
      for (final childId in childrenIds) {
        traverse(childId);
      }
    }

    traverse(rootNode.id);
    return visible;
  }

  /// Toggle node expand/collapse
  void _toggleNodeExpanded(String nodeId, MindMap mindMap) {
    setState(() {
      final hasChildren = mindMap.hasChildren(nodeId);
      if (!hasChildren) return;

      if (_collapsedNodes.contains(nodeId)) {
        // EXPANDING: Remove this node from collapsed
        _collapsedNodes.remove(nodeId);

        // Add all direct children (that have children) to collapsed
        // This ensures only one level expands at a time
        final childrenIds = mindMap.getChildrenIds(nodeId);
        for (final childId in childrenIds) {
          if (mindMap.hasChildren(childId)) {
            _collapsedNodes.add(childId);
          }
        }
      } else {
        // COLLAPSING: Add this node to collapsed (hides all descendants)
        _collapsedNodes.add(nodeId);
      }
      _rebuildGraph(mindMap);

      // If only root is visible, center the view
      final visibleCount = _getVisibleNodeIds(mindMap).length;
      if (visibleCount == 1) {
        _transformationController.value = Matrix4.identity();
      }
    });
  }

  /// Expand all nodes
  void _expandAll(MindMap mindMap) {
    setState(() {
      _collapsedNodes.clear();
      _rebuildGraph(mindMap);
    });
  }

  /// Collapse all nodes (except root)
  void _collapseAll(MindMap mindMap) {
    setState(() {
      _collapsedNodes.clear();
      // Collapse all nodes that have children (except root)
      for (final node in mindMap.nodes) {
        if (mindMap.hasChildren(node.id) && !node.isRoot) {
          _collapsedNodes.add(node.id);
        }
      }
      _rebuildGraph(mindMap);
    });
  }

  /// Collapse to level (show only up to specified depth)
  void _collapseToLevel(MindMap mindMap, int level) {
    setState(() {
      _collapsedNodes.clear();

      void traverse(String nodeId, int currentLevel) {
        final hasChildren = mindMap.hasChildren(nodeId);

        // Collapse nodes at or beyond target level if they have children
        if (currentLevel >= level && hasChildren) {
          _collapsedNodes.add(nodeId);
        }

        if (hasChildren) {
          final childrenIds = mindMap.getChildrenIds(nodeId);
          for (final childId in childrenIds) {
            traverse(childId, currentLevel + 1);
          }
        }
      }

      final rootNode = mindMap.rootNode;
      if (rootNode != null) {
        traverse(rootNode.id, 0);
      }

      _rebuildGraph(mindMap);

      // Center view if only root visible
      final visibleCount = _getVisibleNodeIds(mindMap).length;
      if (visibleCount == 1) {
        _transformationController.value = Matrix4.identity();
      }
    });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final newScale = (currentScale * 1.2).clamp(0.1, 3.0);
    _transformationController.value = Matrix4.identity()..scale(newScale);
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final newScale = (currentScale / 1.2).clamp(0.1, 3.0);
    _transformationController.value = Matrix4.identity()..scale(newScale);
  }

  @override
  Widget build(BuildContext context) {
    final mindMapAsync = ref.watch(chapterMindMapProvider(widget.chapterId));
    final isJunior = SegmentConfig.isJunior;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Map'),
        actions: [
          // Expand/Collapse menu
          mindMapAsync.whenOrNull(
                data: (mindMap) => mindMap != null
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.unfold_more),
                        tooltip: 'Expand/Collapse',
                        onSelected: (value) {
                          switch (value) {
                            case 'expand_all':
                              _expandAll(mindMap);
                              break;
                            case 'collapse_all':
                              _collapseAll(mindMap);
                              break;
                            case 'level_1':
                              _collapseToLevel(mindMap, 1);
                              break;
                            case 'level_2':
                              _collapseToLevel(mindMap, 2);
                              break;
                            case 'level_3':
                              _collapseToLevel(mindMap, 3);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'expand_all',
                            child: Row(
                              children: [
                                Icon(Icons.unfold_more, size: 20),
                                SizedBox(width: 8),
                                Text('Expand All'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'collapse_all',
                            child: Row(
                              children: [
                                Icon(Icons.unfold_less, size: 20),
                                SizedBox(width: 8),
                                Text('Collapse All'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'level_1',
                            child: Row(
                              children: [
                                Icon(Icons.looks_one, size: 20),
                                SizedBox(width: 8),
                                Text('Show Level 1'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'level_2',
                            child: Row(
                              children: [
                                Icon(Icons.looks_two, size: 20),
                                SizedBox(width: 8),
                                Text('Show Level 2'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'level_3',
                            child: Row(
                              children: [
                                Icon(Icons.looks_3, size: 20),
                                SizedBox(width: 8),
                                Text('Show Level 3'),
                              ],
                            ),
                          ),
                        ],
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: mindMapAsync.when(
        loading: () => const _MindMapShimmer(),
        error: (error, _) => _buildErrorState(context, error.toString()),
        data: (mindMap) {
          if (mindMap == null || mindMap.isEmpty) {
            return _buildEmptyState(context);
          }

          _buildGraphIfNeeded(mindMap);
          return _buildMindMapView(context, mindMap, isJunior);
        },
      ),
      floatingActionButton: _buildZoomControls(),
    );
  }

  Widget _buildMindMapView(BuildContext context, MindMap mindMap, bool isJunior) {
    return Column(
      children: [
        // Legend bar
        _buildLegendBar(context),

        // Mind map graph
        Expanded(
          child: RepaintBoundary(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(300),
              minScale: 0.1,
              maxScale: 3.0,
              transformationController: _transformationController,
              child: RepaintBoundary(
                child: GraphView(
                  key: ValueKey('mindmap_${mindMap.chapterId}_${_collapsedNodes.length}'),
                  graph: graph,
                  algorithm: BuchheimWalkerAlgorithm(
                    builder,
                    TreeEdgeRenderer(builder),
                  ),
                  animated: false,
                  paint: Paint()
                    ..color = Colors.grey.shade400
                    ..strokeWidth = 2
                    ..style = PaintingStyle.stroke,
                  builder: (Node node) {
                    final nodeId = node.key?.value as String?;
                    if (nodeId == null) return const SizedBox();

                    final mindMapNode = mindMap.getNodeById(nodeId);
                    if (mindMapNode == null) return const SizedBox();

                    return _buildNodeWidget(mindMapNode, mindMap, isJunior);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Node count info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${graph.nodeCount()} nodes visible',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const Spacer(),
          // Legend
          _buildLegendItem(context, _getNodeColor(MindMapNodeType.root), 'Root'),
          const SizedBox(width: 12),
          _buildLegendItem(context, _getNodeColor(MindMapNodeType.mainTopic), 'Main'),
          const SizedBox(width: 12),
          _buildLegendItem(context, _getNodeColor(MindMapNodeType.subTopic), 'Sub'),
          const SizedBox(width: 12),
          _buildLegendItem(context, _getNodeColor(MindMapNodeType.detail), 'Detail'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildNodeWidget(MindMapNode node, MindMap mindMap, bool isJunior) {
    final color = _getNodeColor(node.nodeType);
    final isRoot = node.nodeType == MindMapNodeType.root || node.isRoot;
    final hasChildren = mindMap.hasChildren(node.id);
    final childCount = mindMap.getChildrenIds(node.id).length;
    final isCollapsed = _collapsedNodes.contains(node.id);
    final hasDescription = node.hasDescription && node.description != node.label;

    return GestureDetector(
      onTap: hasDescription ? () => _showNodeDetails(node) : null,
      onDoubleTap: hasChildren ? () => _toggleNodeExpanded(node.id, mindMap) : null,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isRoot ? 220 : 200,
          minWidth: 120,
        ),
        decoration: BoxDecoration(
          gradient: isRoot
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.8)],
                )
              : null,
          color: isRoot ? null : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(isRoot ? 16 : 12),
          border: Border.all(
            color: color,
            width: isRoot ? 0 : 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(isRoot ? 16 : 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Node type indicator
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isRoot ? Colors.white : color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isRoot ? Colors.white : color).withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Label
                    Expanded(
                      child: Text(
                        node.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isJunior ? (isRoot ? 16 : 14) : (isRoot ? 14 : 12),
                          color: isRoot
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Expand/Collapse button
                    if (hasChildren) ...[
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _toggleNodeExpanded(node.id, mindMap),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isRoot
                                ? Colors.white.withValues(alpha: 0.25)
                                : color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$childCount',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isRoot ? Colors.white : color,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                isCollapsed
                                    ? Icons.add_circle_outline
                                    : Icons.remove_circle_outline,
                                size: 14,
                                color: isRoot ? Colors.white : color,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Description preview
                if (hasDescription) ...[
                  const SizedBox(height: 8),
                  Text(
                    node.description!,
                    style: TextStyle(
                      fontSize: isJunior ? 11 : 10,
                      color: isRoot
                          ? Colors.white.withValues(alpha: 0.9)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _zoomIn,
            icon: const Icon(Icons.add),
            tooltip: 'Zoom In',
          ),
          const Divider(height: 1),
          IconButton(
            onPressed: _zoomOut,
            icon: const Icon(Icons.remove),
            tooltip: 'Zoom Out',
          ),
          const Divider(height: 1),
          IconButton(
            onPressed: _resetZoom,
            icon: const Icon(Icons.fit_screen),
            tooltip: 'Fit to Screen',
          ),
        ],
      ),
    );
  }

  void _showNodeDetails(MindMapNode node) {
    final color = _getNodeColor(node.nodeType);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                node.label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(node.description ?? 'No description available'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getNodeColor(MindMapNodeType type) {
    return switch (type) {
      MindMapNodeType.root => const Color(0xFF3F51B5),      // Indigo
      MindMapNodeType.mainTopic => const Color(0xFF4CAF50), // Green
      MindMapNodeType.subTopic => const Color(0xFFFF9800),  // Orange
      MindMapNodeType.detail => const Color(0xFF9C27B0),    // Purple
      MindMapNodeType.example => const Color(0xFF00BCD4),   // Cyan
    };
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Mind Map Available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'A mind map for this chapter has not been created yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Failed to load mind map',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for mind map
class _MindMapShimmer extends StatelessWidget {
  const _MindMapShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          children: [
            const SkeletonBox(height: 40, width: double.infinity),
            const SizedBox(height: AppTheme.spacingXl),
            const SkeletonBox(height: 50, width: 150),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SkeletonBox(height: 40, width: 120),
                SizedBox(width: AppTheme.spacingMd),
                SkeletonBox(height: 40, width: 120),
                SizedBox(width: AppTheme.spacingMd),
                SkeletonBox(height: 40, width: 120),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
