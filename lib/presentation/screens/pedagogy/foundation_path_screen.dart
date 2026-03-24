import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/services/haptic_service.dart';
import 'package:streamshaala/core/utils/semantic_colors.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/domain/entities/pedagogy/learning_path_context.dart';
import 'package:streamshaala/presentation/widgets/path/node_completion_animation.dart';
import 'package:streamshaala/presentation/widgets/path/milestone_dialog.dart';
import 'package:streamshaala/presentation/providers/pedagogy/path_analytics_provider.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';

/// Foundation Path Screen - Shows personalized learning journey
class FoundationPathScreen extends ConsumerStatefulWidget {
  final String? pathId;
  final LearningPath? initialPath;

  /// Constructor for loading path by ID (legacy)
  const FoundationPathScreen({
    super.key,
    required String this.pathId,
  }) : initialPath = null;

  /// Constructor for direct path passing (recommended)
  const FoundationPathScreen.withPath({
    super.key,
    required this.initialPath,
  }) : pathId = null;

  @override
  ConsumerState<FoundationPathScreen> createState() => _FoundationPathScreenState();
}

class _FoundationPathScreenState extends ConsumerState<FoundationPathScreen> {
  LearningPath? _path;
  int _currentNodeIndex = 0;
  final Map<String, bool> _completedNodes = {};
  double _previousProgress = 0.0; // For milestone tracking

  @override
  void initState() {
    super.initState();
    _loadPath();
  }

  Future<void> _loadPath() async {
    // If initialPath is provided, use it directly
    if (widget.initialPath != null) {
      setState(() {
        _path = widget.initialPath;
        _currentNodeIndex = widget.initialPath!.currentNodeIndex;
        // Initialize completed nodes map based on node.completed status
        for (final node in widget.initialPath!.nodes) {
          if (node.completed) {
            _completedNodes[node.id] = true;
          }
        }
      });

      // Track analytics: path started or resumed
      final analytics = ref.read(pathAnalyticsServiceProvider);
      if (widget.initialPath!.hasStarted) {
        await analytics.trackPathResumed(widget.initialPath!);
      } else {
        await analytics.trackPathStarted(widget.initialPath!);
      }

      return;
    }

    // Otherwise, load by pathId (legacy behavior)
    // In a real implementation, load from repository
    // For now, we'll show a placeholder
    if (widget.pathId != null) {
      // TODO: Load path from repository by ID
      // final path = await ref.read(learningPathRepositoryProvider).getPath(widget.pathId!);
      // setState(() {
      //   _path = path;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_path?.metadata?['title'] as String? ?? 'Foundation Path'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showPathInfo(context),
          ),
        ],
      ),
      body: _path == null ? _buildPlaceholder() : _buildPathContent(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.route,
            size: 64,
            color: context.colorScheme.primary,
          ),
          SizedBox(height: AppTheme.spacingMd),
          Text(
            'Your Learning Path',
            style: context.textTheme.headlineSmall,
          ),
          SizedBox(height: AppTheme.spacingSm),
          Text(
            widget.pathId != null
                ? 'Loading path: ${widget.pathId}'
                : 'Preparing your learning journey...',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          SizedBox(height: AppTheme.spacingLg),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildPathContent() {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout();
          case DeviceType.tablet:
            return _buildTabletLayout();
          case DeviceType.desktop:
            return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: _buildNodeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          children: [
            _buildProgressHeader(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildNodeList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SafeArea(
      child: Row(
        children: [
          // Side panel with path overview
          Container(
            width: 350,
            padding: EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerLowest,
              border: Border(
                right: BorderSide(
                  color: context.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: _buildPathOverview(),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingLg),
              child: _buildNodeList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    final completed = _completedNodes.values.where((v) => v).length;
    final total = _path?.nodes.length ?? 0;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}% Complete',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completed/$total modules',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          // Animated progress bar
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            tween: Tween(begin: _previousProgress, end: progress),
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: context.colorScheme.surfaceContainerHigh,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    value >= 1.0 ? AppTheme.successColor : context.colorScheme.primary,
                  ),
                ),
              );
            },
          ),
          if (_path != null && _path!.estimatedTimeRemaining > 0) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppTheme.spacingXs),
                Text(
                  '${_path!.formattedEstimatedTime} remaining',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPathOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _path?.metadata?['title'] as String? ?? 'Foundation Path',
          style: context.textTheme.headlineSmall,
        ),
        SizedBox(height: AppTheme.spacingSm),
        Text(
          _path?.metadata?['description'] as String? ?? 'Your personalized learning journey',
          style: context.textTheme.bodyMedium,
        ),
        Divider(height: AppTheme.spacingLg * 2),
        Text(
          'Estimated Time',
          style: context.textTheme.titleSmall,
        ),
        SizedBox(height: AppTheme.spacingXs),
        Text(
          '${_path?.metadata?['estimatedDuration'] ?? _path?.estimatedTimeRemaining ?? 0} minutes',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppTheme.spacingMd),
        Text(
          'Modules',
          style: context.textTheme.titleSmall,
        ),
        SizedBox(height: AppTheme.spacingXs),
        Text(
          '${_path?.nodes.length ?? 0} learning modules',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNodeList() {
    if (_path == null || _path!.nodes.isEmpty) {
      return _buildEmptyPathView();
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      itemCount: _path!.nodes.length,
      itemBuilder: (context, index) {
        final node = _path!.nodes[index];
        final isCompleted = _completedNodes[node.id] ?? false;
        final isCurrent = index == _currentNodeIndex;
        final isLocked = index > _currentNodeIndex && !isCompleted;

        return _buildNodeCard(node, isCompleted, isCurrent, isLocked, index);
      },
    );
  }

  Widget _buildNodeCard(
    PathNode node,
    bool isCompleted,
    bool isCurrent,
    bool isLocked,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator with completion animation
          Column(
            children: [
              NodeCompletionAnimation(
                isCompleted: isCompleted,
                glowColor: AppTheme.successColor,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successColor
                        : isCurrent
                            ? context.colorScheme.primary
                            : context.colorScheme.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? AppTheme.successColor
                          : isCurrent
                              ? context.colorScheme.primary
                              : context.colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check
                        : isLocked
                            ? Icons.lock
                            : _getNodeIcon(node.type),
                    color: isCompleted || isCurrent
                        ? Colors.white
                        : context.colorScheme.outline,
                    size: 20,
                  ),
                ),
              ),
              if (index < (_path?.nodes.length ?? 0) - 1)
                Container(
                  width: 2,
                  height: 60,
                  color: isCompleted
                      ? AppTheme.successColor
                      : context.colorScheme.outline.withValues(alpha: 0.3),
                ),
            ],
          ),
          const SizedBox(width: AppTheme.spacingMd),
          // Node card
          Expanded(
            child: Semantics(
              label: '${node.title}. ${_getNodeTypeLabel(node.type)}. ${node.description}. '
                     'Estimated duration: ${node.estimatedDuration} minutes. '
                     '${isCompleted ? "Completed." : isCurrent ? "Current step. Tap to continue." : isLocked ? "Locked. Complete previous steps to unlock." : "Tap to start."}',
              button: !isLocked,
              enabled: !isLocked,
              child: Card(
                elevation: isCurrent ? 4 : 1,
                color: isLocked
                    ? context.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
                    : null,
                child: InkWell(
                  onTap: isLocked ? null : () => _onNodeTap(node),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: Padding(
                    padding: EdgeInsets.all(AppTheme.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                node.title,
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                  color: isLocked
                                      ? context.colorScheme.outline
                                      : null,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                _getNodeTypeLabel(node.type),
                                style: context.textTheme.labelSmall,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacingXs),
                        Text(
                          node.description,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacingSm),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: context.colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${node.estimatedDuration} min',
                              style: context.textTheme.labelSmall,
                            ),
                            const Spacer(),
                            if (isCurrent && !isCompleted)
                              FilledButton.tonal(
                                onPressed: () => _onNodeTap(node),
                                child: const Text('Continue'),
                              ),
                            if (isCompleted)
                              const Icon(Icons.check_circle, color: AppTheme.successColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNodeIcon(PathNodeType type) {
    switch (type) {
      case PathNodeType.video:
        return Icons.play_circle_outline;
      case PathNodeType.quiz:
        return Icons.quiz_outlined;
      case PathNodeType.practice:
        return Icons.edit_note;
      case PathNodeType.revision:
        return Icons.refresh;
      case PathNodeType.assessment:
        return Icons.assignment;
    }
  }

  String _getNodeTypeLabel(PathNodeType type) {
    switch (type) {
      case PathNodeType.video:
        return 'Video';
      case PathNodeType.quiz:
        return 'Quiz';
      case PathNodeType.practice:
        return 'Practice';
      case PathNodeType.revision:
        return 'Review';
      case PathNodeType.assessment:
        return 'Test';
    }
  }

  Future<void> _onNodeTap(PathNode node) async {
    if (_path == null) return;

    // Create path context for this node
    final pathContext = LearningPathContext(
      pathId: _path!.id,
      nodeId: node.id,
      nodeType: node.type,
    );

    // Navigate based on node type and wait for result
    Object? result;

    switch (node.type) {
      case PathNodeType.video:
        result = await context.push<CompletionResult>(
          RouteConstants.getVideoPath(node.entityId),
          extra: pathContext,
        );
        break;

      case PathNodeType.quiz:
      case PathNodeType.practice:
      case PathNodeType.assessment:
        // Foundation Path quizzes are readiness/diagnostic assessments
        final studentId = ref.read(effectiveUserIdProvider);
        result = await context.push<CompletionResult>(
          RouteConstants.getQuizPathWithType(
            node.entityId,
            studentId,
            assessmentType: 'readiness',
          ),
          extra: pathContext,
        );
        break;

      case PathNodeType.revision:
        result = await context.push<CompletionResult>(
          '/revision/${node.id}',
          extra: pathContext,
        );
        break;
    }

    // Handle completion result
    if (result is CompletionResult && result.completed) {
      _handleNodeCompletion(node, result);
    }
  }

  /// Handle node completion and update local state
  void _handleNodeCompletion(PathNode node, CompletionResult result) {
    if (_path == null) return;

    // Haptic feedback for success
    HapticService.success();

    // Calculate progress before and after completion
    final total = _path!.nodes.length;
    final completedBefore = _completedNodes.values.where((v) => v).length;
    final progressBefore = total > 0 ? completedBefore / total : 0.0;

    setState(() {
      _completedNodes[node.id] = true;
    });

    final completedAfter = _completedNodes.values.where((v) => v).length;
    final progressAfter = total > 0 ? completedAfter / total : 0.0;

    // Track analytics: node completed
    final analytics = ref.read(pathAnalyticsServiceProvider);
    final timeSpent = result.timeSpent != null ? Duration(seconds: result.timeSpent!) : null;
    analytics.trackNodeCompleted(
      _path!.id,
      node,
      timeSpent: timeSpent,
      score: result.score,
      metadata: result.metadata,
    );

    // Check for milestone achievement
    _checkMilestone(progressBefore, progressAfter);

    // Update previous progress for animation
    _previousProgress = progressBefore;

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: AppTheme.spacingSm + AppTheme.spacingXs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${node.title} completed!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (result.score != null)
                    Text(
                      'Score: ${(result.score! * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'CONTINUE',
          textColor: Colors.white,
          onPressed: () {
            _scrollToNextNode();
          },
        ),
      ),
    );

    // Auto-advance to next node after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _autoAdvanceToNext(node);
      }
    });
  }

  /// Check if a milestone was reached and show celebration
  void _checkMilestone(double oldProgress, double newProgress) {
    if (_path == null) return;

    final milestones = [0.25, 0.50, 0.75, 1.0];

    for (final milestone in milestones) {
      if (oldProgress < milestone && newProgress >= milestone) {
        // Trigger haptic feedback for milestone
        HapticService.vibrate();

        // Track analytics: milestone reached
        final analytics = ref.read(pathAnalyticsServiceProvider);
        final milestonePercentage = (milestone * 100).toInt();
        analytics.trackMilestoneReached(_path!.id, milestonePercentage, _path!);

        // Track path completed if 100% milestone
        if (milestone == 1.0) {
          final completionTime = Duration(
            milliseconds: DateTime.now().difference(_path!.createdAt).inMilliseconds,
          );
          analytics.trackPathCompleted(_path!, completionTime);
        }

        // Show milestone dialog after a short delay
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _showMilestoneDialog(milestone);
          }
        });
        break;
      }
    }
  }

  /// Show milestone celebration dialog
  void _showMilestoneDialog(double milestone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MilestoneDialog(
        percentage: (milestone * 100).toInt(),
        path: _path!,
        onContinue: () {
          Navigator.pop(context);
          if (milestone < 1.0) {
            _scrollToNextNode();
          } else {
            // Path complete - return to previous screen
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                context.pop();
              }
            });
          }
        },
      ),
    );
  }

  /// Scroll to the next uncompleted node
  void _scrollToNextNode() {
    if (_path == null) return;

    // Find next uncompleted node
    for (int i = 0; i < _path!.nodes.length; i++) {
      final node = _path!.nodes[i];
      if (!(_completedNodes[node.id] ?? false)) {
        setState(() {
          _currentNodeIndex = i;
        });
        break;
      }
    }
  }

  /// Auto-advance to next node after completion
  Future<void> _autoAdvanceToNext(PathNode completedNode) async {
    if (_path == null) return;

    final completedIndex = _path!.nodes.indexWhere((n) => n.id == completedNode.id);
    if (completedIndex == -1 || completedIndex >= _path!.nodes.length - 1) {
      // Last node - show path completion
      _showPathCompletionCelebration();
      return;
    }

    final nextNode = _path!.nodes[completedIndex + 1];

    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great progress!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You\'ve completed ${completedNode.title}.'),
            const SizedBox(height: AppTheme.spacingSm + AppTheme.spacingXs),
            Builder(
              builder: (context) => Text(
                'Next up: ${nextNode.title}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Builder(
              builder: (context) => Text(
                nextNode.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (shouldContinue == true && mounted) {
      setState(() {
        _currentNodeIndex = completedIndex + 1;
      });
    }
  }

  /// Show path completion celebration
  void _showPathCompletionCelebration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.amber, size: 32),
            const SizedBox(width: AppTheme.spacingSm + AppTheme.spacingXs),
            const Text('Path Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Congratulations! You\'ve completed your Foundation Path.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'You\'re now ready to tackle more advanced topics!',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Return to previous screen
            },
            icon: const Icon(Icons.check),
            label: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPathView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 64,
            color: context.colorScheme.primary,
          ),
          SizedBox(height: AppTheme.spacingMd),
          Text(
            'No gaps found!',
            style: context.textTheme.headlineSmall,
          ),
          SizedBox(height: AppTheme.spacingSm),
          Text(
            'You\'re ready to continue learning.',
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showPathInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This Path',
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: AppTheme.spacingMd),
            const Text(
              'This personalized learning path is designed to fill gaps in your '
              'foundational knowledge. Complete each module in order to build a '
              'strong understanding before moving to new concepts.',
            ),
            SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 20),
                SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Text(
                    'Tip: Watch videos carefully and take the quizzes seriously '
                    'to get the most out of your learning.',
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
