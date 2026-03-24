import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/extensions/collection_extensions.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/presentation/providers/pedagogy/mastery_provider.dart';

/// Concept Map Screen
/// Visual representation of concept relationships and mastery
class ConceptMapScreen extends ConsumerStatefulWidget {
  final String studentId;

  const ConceptMapScreen({
    super.key,
    required this.studentId,
  });

  @override
  ConsumerState<ConceptMapScreen> createState() => _ConceptMapScreenState();
}

class _ConceptMapScreenState extends ConsumerState<ConceptMapScreen> {
  final Graph _graph = Graph()..isTree = false;
  late BuchheimWalkerConfiguration _builder;
  String? _selectedConceptId;

  @override
  void initState() {
    super.initState();
    _builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 60
      ..levelSeparation = 80
      ..subtreeSeparation = 80
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  Widget build(BuildContext context) {
    final isJunior = SegmentConfig.isCrackTheCode;
    final masteryState = ref.watch(masteryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isJunior ? 'Learning Map' : 'Concept Map',
          style: context.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showLegend(context),
            tooltip: 'Show legend',
          ),
        ],
      ),
      body: masteryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : masteryState.conceptMasteries.isEmpty
              ? _buildEmptyState(context, isJunior)
              : Column(
                  children: [
                    // Stats summary
                    _buildStatsSummary(context, masteryState, isJunior),

                    // Graph view
                    Expanded(
                      child: InteractiveViewer(
                        constrained: false,
                        boundaryMargin: const EdgeInsets.all(100),
                        minScale: 0.3,
                        maxScale: 2.5,
                        child: _buildGraph(context, masteryState, isJunior),
                      ),
                    ),

                    // Selected concept details
                    if (_selectedConceptId != null)
                      _buildConceptDetails(
                        context,
                        masteryState,
                        _selectedConceptId!,
                        isJunior,
                      ),
                  ],
                ),
    );
  }

  Widget _buildStatsSummary(
    BuildContext context,
    MasteryState state,
    bool isJunior,
  ) {
    final values = state.conceptMasteries.values.toList();
    final total = values.length;
    final mastered = values.where((m) => m.masteryScore >= 0.8).length;
    final learning = values.where((m) => m.masteryScore >= 0.4 && m.masteryScore < 0.8).length;
    final needsWork = total - mastered - learning;

    return Container(
      padding: EdgeInsets.all(isJunior ? 16 : 12),
      color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatChip(
            context,
            icon: Icons.star,
            label: isJunior ? 'Mastered' : 'Mastered',
            count: mastered,
            color: Colors.green,
            isJunior: isJunior,
          ),
          _buildStatChip(
            context,
            icon: Icons.trending_up,
            label: isJunior ? 'Learning' : 'In Progress',
            count: learning,
            color: Colors.orange,
            isJunior: isJunior,
          ),
          _buildStatChip(
            context,
            icon: Icons.help_outline,
            label: isJunior ? 'New' : 'Needs Work',
            count: needsWork,
            color: Colors.red,
            isJunior: isJunior,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required bool isJunior,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isJunior ? 20 : 16),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildGraph(
    BuildContext context,
    MasteryState state,
    bool isJunior,
  ) {
    // Build nodes and edges from mastery data
    _graph.nodes.clear();
    _graph.edges.clear();

    final concepts = state.conceptMasteries.values.toList();
    final nodeMap = <String, Node>{};

    // Create nodes
    for (final concept in concepts) {
      final node = Node.Id(concept.conceptId);
      nodeMap[concept.conceptId] = node;
      _graph.addNode(node);
    }

    // Create edges based on concept relationships
    // Group by subject prefix and create connections
    final groupedConcepts = <String, List<String>>{};
    for (final concept in concepts) {
      final prefix = concept.conceptId.split('_').first;
      groupedConcepts.putIfAbsent(prefix, () => []).add(concept.conceptId);
    }

    // Connect concepts within same group sequentially
    for (final group in groupedConcepts.values) {
      for (int i = 0; i < group.length - 1; i++) {
        final source = nodeMap[group[i]];
        final target = nodeMap[group[i + 1]];
        if (source != null && target != null) {
          _graph.addEdge(source, target);
        }
      }
    }

    return GraphView(
      graph: _graph,
      algorithm: BuchheimWalkerAlgorithm(
        _builder,
        TreeEdgeRenderer(_builder),
      ),
      paint: Paint()
        ..color = context.colorScheme.outline.withValues(alpha: 0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
      builder: (Node node) {
        final conceptId = node.key?.value as String?;
        if (conceptId == null) return const SizedBox();

        final mastery = state.conceptMasteries[conceptId] ??
            state.conceptMasteries.firstValueOrNull;
        final masteryScore = mastery?.masteryScore ?? 0.0;

        return _buildConceptNode(
          context,
          conceptId,
          masteryScore,
          isJunior,
        );
      },
    );
  }

  Widget _buildConceptNode(
    BuildContext context,
    String conceptId,
    double masteryScore,
    bool isJunior,
  ) {
    final isSelected = _selectedConceptId == conceptId;
    final color = _getMasteryColor(masteryScore);
    final displayName = conceptId.split('_').skip(1).join(' ').toUpperCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConceptId = isSelected ? null : conceptId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isJunior ? 16 : 12,
          vertical: isJunior ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.3)
              : context.colorScheme.surface,
          borderRadius: BorderRadius.circular(isJunior ? 16 : 12),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mastery indicator
            Container(
              width: isJunior ? 40 : 32,
              height: isJunior ? 40 : 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  '${(masteryScore * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: isJunior ? 12 : 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Concept name
            SizedBox(
              width: isJunior ? 80 : 60,
              child: Text(
                displayName.length > 12
                    ? '${displayName.substring(0, 10)}...'
                    : displayName,
                style: TextStyle(
                  fontSize: isJunior ? 11 : 9,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptDetails(
    BuildContext context,
    MasteryState state,
    String conceptId,
    bool isJunior,
  ) {
    final mastery = state.conceptMasteries[conceptId] ??
        state.conceptMasteries.firstValueOrNull;
    final masteryScore = mastery?.masteryScore ?? 0.0;

    final color = _getMasteryColor(masteryScore);
    final displayName = conceptId.replaceAll('_', ' ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Concept info
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Text(
                      '${(masteryScore * 100).toInt()}%',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName.toUpperCase(),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mastery != null
                            ? 'Last reviewed: ${_formatDate(mastery.lastAssessed)}'
                            : 'Not yet reviewed',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedConceptId = null;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Mastery progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: masteryScore,
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                color: color,
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to practice
                    },
                    icon: const Icon(Icons.quiz),
                    label: Text(isJunior ? 'Practice' : 'Practice'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // Navigate to related videos
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(isJunior ? 'Watch' : 'Review'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isJunior) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: isJunior ? 100 : 80,
              color: context.colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              isJunior ? 'Start Learning!' : 'No Concepts Yet',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isJunior
                  ? 'Watch videos and take quizzes to build your learning map!'
                  : 'Complete quizzes to start building your concept map.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLegend(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legend',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLegendItem(context, Colors.green, 'Mastered (80%+)'),
            _buildLegendItem(context, Colors.orange, 'Learning (40-79%)'),
            _buildLegendItem(context, Colors.red, 'Needs Work (<40%)'),
            const SizedBox(height: 16),
            Text(
              'Tap on a concept to see details and practice options.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.3),
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: context.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Color _getMasteryColor(double mastery) {
    if (mastery >= 0.8) return Colors.green;
    if (mastery >= 0.4) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${diff.inDays ~/ 7} weeks ago';
  }
}
