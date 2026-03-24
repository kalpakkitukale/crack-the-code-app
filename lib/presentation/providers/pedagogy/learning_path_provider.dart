/// Learning Path state management provider
///
/// Manages learning path state, node completion, and progress tracking
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';
import 'package:crack_the_code/domain/repositories/learning_path_repository.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Node completion status
class NodeCompletionStatus {
  final String nodeId;
  final bool completed;
  final DateTime? completedAt;
  final double? score;
  final Map<String, dynamic>? metadata;

  const NodeCompletionStatus({
    required this.nodeId,
    required this.completed,
    this.completedAt,
    this.score,
    this.metadata,
  });

  NodeCompletionStatus copyWith({
    String? nodeId,
    bool? completed,
    DateTime? completedAt,
    double? score,
    Map<String, dynamic>? metadata,
  }) {
    return NodeCompletionStatus(
      nodeId: nodeId ?? this.nodeId,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Learning Path state
class LearningPathState {
  final LearningPath? currentPath;
  final Map<String, NodeCompletionStatus> nodeCompletions; // Quick lookup by nodeId
  final bool isLoading;
  final String? error;

  const LearningPathState({
    this.currentPath,
    this.nodeCompletions = const {},
    this.isLoading = false,
    this.error,
  });

  factory LearningPathState.initial() => const LearningPathState();

  LearningPathState copyWith({
    LearningPath? currentPath,
    Map<String, NodeCompletionStatus>? nodeCompletions,
    bool? isLoading,
    String? error,
    bool clearPath = false,
    bool clearError = false,
  }) {
    return LearningPathState(
      currentPath: clearPath ? null : currentPath ?? this.currentPath,
      nodeCompletions: nodeCompletions ?? this.nodeCompletions,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// Check if there's an active path loaded
  bool get hasActivePath => currentPath != null;

  /// Get progress percentage (0.0 - 100.0)
  double get progressPercentage => currentPath?.progressPercentage ?? 0.0;

  /// Get current node
  PathNode? get currentNode => currentPath?.currentNode;

  /// Get next node
  PathNode? get nextNode => currentPath?.nextNode;

  /// Get previous node
  PathNode? get previousNode => currentPath?.previousNode;

  /// Get total nodes count
  int get totalNodes => currentPath?.totalNodes ?? 0;

  /// Get completed nodes count
  int get completedNodes => currentPath?.completedNodes ?? 0;

  /// Get remaining nodes count
  int get remainingNodes => currentPath?.remainingNodes ?? 0;

  /// Check if path is completed
  bool get isPathCompleted => currentPath?.isCompleted ?? false;

  /// Get estimated time remaining
  int get estimatedTimeRemaining => currentPath?.estimatedTimeRemaining ?? 0;

  /// Check if specific node is completed
  bool isNodeCompleted(String nodeId) {
    return nodeCompletions[nodeId]?.completed ?? false;
  }

  /// Get completion status for a node
  NodeCompletionStatus? getNodeCompletion(String nodeId) {
    return nodeCompletions[nodeId];
  }
}

/// Learning Path state notifier
class LearningPathNotifier extends StateNotifier<LearningPathState> {
  final LearningPathRepository _repository;

  LearningPathNotifier({
    required LearningPathRepository repository,
  })  : _repository = repository,
        super(LearningPathState.initial());

  /// Load a learning path by ID
  Future<void> loadPath(String pathId) async {
    try {
      logger.debug('Loading learning path: $pathId');
      state = state.copyWith(isLoading: true, clearError: true);

      final result = await _repository.getPathById(pathId);

      result.fold(
        (failure) {
          logger.error('Failed to load path: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (path) {
          if (path == null) {
            logger.warning('Path not found: $pathId');
            state = state.copyWith(
              isLoading: false,
              error: 'Learning path not found',
            );
            return;
          }

          logger.info('Loaded path: ${path.id} (${path.progressPercentage.toStringAsFixed(0)}% complete)');
          _setPathState(path);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to load learning path', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load learning path: $e',
      );
    }
  }

  /// Load active learning path for a subject
  Future<void> loadActivePath(String studentId, String subjectId) async {
    try {
      logger.debug('Loading active path for subject: $subjectId');
      state = state.copyWith(isLoading: true, clearError: true);

      final result = await _repository.getActivePathForSubject(
        studentId: studentId,
        subjectId: subjectId,
      );

      result.fold(
        (failure) {
          logger.error('Failed to load active path: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (path) {
          if (path == null) {
            logger.info('No active path found for subject: $subjectId');
            state = state.copyWith(
              isLoading: false,
              clearPath: true,
            );
            return;
          }

          logger.info('Loaded active path: ${path.id}');
          _setPathState(path);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to load active path', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load active path: $e',
      );
    }
  }

  /// Set path from external source (e.g., from recommendations screen)
  Future<void> setPath(LearningPath path) async {
    try {
      logger.debug('Setting learning path: ${path.id}');
      state = state.copyWith(isLoading: true, clearError: true);

      // Save path to database first
      final result = await _repository.savePath(path);

      result.fold(
        (failure) {
          logger.error('Failed to save path: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (savedPath) {
          logger.info('Saved and set path: ${savedPath.id}');
          _setPathState(savedPath);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to set learning path', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to set learning path: $e',
      );
    }
  }

  /// Mark a node as complete
  Future<void> completeNode({
    required String nodeId,
    double? score,
    Map<String, dynamic>? metadata,
  }) async {
    if (state.currentPath == null) {
      logger.warning('Cannot complete node: No path loaded');
      return;
    }

    try {
      logger.debug('Completing node: $nodeId');

      // 1. Update local state immediately (optimistic update)
      final completion = NodeCompletionStatus(
        nodeId: nodeId,
        completed: true,
        completedAt: DateTime.now(),
        score: score,
        metadata: metadata,
      );

      final updatedCompletions = Map<String, NodeCompletionStatus>.from(state.nodeCompletions);
      updatedCompletions[nodeId] = completion;

      state = state.copyWith(nodeCompletions: updatedCompletions);

      // 2. Persist to repository (async)
      final result = await _repository.updateNodeCompletion(
        pathId: state.currentPath!.id,
        nodeId: nodeId,
        completed: true,
        completedAt: DateTime.now(),
        scorePercentage: score,
      );

      result.fold(
        (failure) {
          logger.error('Failed to persist node completion: ${failure.message}');
          state = state.copyWith(error: failure.message);
        },
        (updatedPath) {
          logger.info('✅ Node completed: $nodeId (${updatedPath.progressPercentage.toStringAsFixed(0)}% complete)');
          _setPathState(updatedPath);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to complete node', e, stackTrace);
      state = state.copyWith(error: 'Failed to mark node complete: $e');
    }
  }

  /// Advance to next node
  Future<void> advanceToNext() async {
    if (state.currentPath == null) {
      logger.warning('Cannot advance: No path loaded');
      return;
    }

    try {
      logger.debug('Advancing to next node');

      final result = await _repository.advanceToNextNode(state.currentPath!.id);

      result.fold(
        (failure) {
          logger.error('Failed to advance: ${failure.message}');
          state = state.copyWith(error: failure.message);
        },
        (updatedPath) {
          logger.info('Advanced to node index: ${updatedPath.currentNodeIndex}');
          _setPathState(updatedPath);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to advance to next node', e, stackTrace);
      state = state.copyWith(error: 'Failed to advance: $e');
    }
  }

  /// Update path status
  Future<void> updateStatus(PathStatus status) async {
    if (state.currentPath == null) {
      logger.warning('Cannot update status: No path loaded');
      return;
    }

    try {
      logger.debug('Updating path status to: ${status.name}');

      final result = await _repository.updatePathStatus(
        state.currentPath!.id,
        status,
      );

      result.fold(
        (failure) {
          logger.error('Failed to update status: ${failure.message}');
          state = state.copyWith(error: failure.message);
        },
        (updatedPath) {
          logger.info('Updated status to: ${status.name}');
          _setPathState(updatedPath);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to update path status', e, stackTrace);
      state = state.copyWith(error: 'Failed to update status: $e');
    }
  }

  /// Clear current path and reset state
  void clearPath() {
    logger.debug('Clearing learning path state');
    state = LearningPathState.initial();
  }

  /// Helper method to set path state with completion map
  void _setPathState(LearningPath path) {
    // Build node completions map from path nodes
    final completions = <String, NodeCompletionStatus>{};
    for (final node in path.nodes) {
      if (node.completed) {
        completions[node.id] = NodeCompletionStatus(
          nodeId: node.id,
          completed: true,
          completedAt: node.completedAt,
          score: node.scorePercentage,
        );
      }
    }

    state = state.copyWith(
      currentPath: path,
      nodeCompletions: completions,
      isLoading: false,
      clearError: true,
    );
  }
}

/// Global learning path provider
final learningPathProvider =
    StateNotifierProvider<LearningPathNotifier, LearningPathState>((ref) {
  final container = injectionContainer;

  return LearningPathNotifier(
    repository: container.learningPathRepository,
  );
});
