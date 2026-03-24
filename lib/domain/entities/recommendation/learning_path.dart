/// LearningPath entity for personalized study progression
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_path.freezed.dart';

@freezed
class LearningPath with _$LearningPath {
  const factory LearningPath({
    required String id,
    required String studentId,
    required String subjectId,
    required List<PathNode> nodes,
    required DateTime createdAt,
    required DateTime lastUpdated,
    @Default(PathStatus.active) PathStatus status,
    @Default(0) int currentNodeIndex,
    Map<String, dynamic>? metadata,
  }) = _LearningPath;

  const LearningPath._();

  /// Get current node
  PathNode? get currentNode =>
      currentNodeIndex < nodes.length ? nodes[currentNodeIndex] : null;

  /// Get next node
  PathNode? get nextNode =>
      currentNodeIndex + 1 < nodes.length ? nodes[currentNodeIndex + 1] : null;

  /// Get previous node
  PathNode? get previousNode =>
      currentNodeIndex > 0 ? nodes[currentNodeIndex - 1] : null;

  /// Get total nodes count
  int get totalNodes => nodes.length;

  /// Get completed nodes count
  int get completedNodes => nodes.where((n) => n.completed).length;

  /// Get remaining nodes count
  int get remainingNodes => totalNodes - completedNodes;

  /// Get progress percentage
  double get progressPercentage =>
      totalNodes > 0 ? (completedNodes / totalNodes) * 100 : 0.0;

  /// Check if path is completed
  bool get isCompleted => completedNodes == totalNodes;

  /// Check if path has started
  bool get hasStarted => completedNodes > 0;

  /// Get estimated time remaining (in minutes)
  int get estimatedTimeRemaining {
    return nodes
        .where((n) => !n.completed)
        .fold(0, (sum, node) => sum + node.estimatedDuration);
  }

  /// Get formatted estimated time
  String get formattedEstimatedTime {
    final minutes = estimatedTimeRemaining;
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0
        ? '${hours}h ${remainingMinutes}m'
        : '${hours}h';
  }

  /// Get path difficulty
  PathDifficulty get difficulty {
    if (nodes.isEmpty) return PathDifficulty.beginner;

    final avgDifficulty = nodes
            .map((n) => _difficultyToInt(n.difficulty))
            .reduce((a, b) => a + b) /
        nodes.length;

    if (avgDifficulty >= 2.5) return PathDifficulty.advanced;
    if (avgDifficulty >= 1.5) return PathDifficulty.intermediate;
    return PathDifficulty.beginner;
  }

  int _difficultyToInt(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'advanced':
        return 3;
      case 'intermediate':
        return 2;
      default:
        return 1;
    }
  }

  /// Get weak areas in path
  List<String> get weakAreas {
    return nodes
        .where((n) => n.completed && n.scorePercentage != null && n.scorePercentage! < 60)
        .map((n) => n.title)
        .toList();
  }

  /// Get strong areas in path
  List<String> get strongAreas {
    return nodes
        .where((n) => n.completed && n.scorePercentage != null && n.scorePercentage! >= 80)
        .map((n) => n.title)
        .toList();
  }

  /// Check if has weak areas
  bool get hasWeakAreas => weakAreas.isNotEmpty;
}

/// Path node representing a learning step
@freezed
class PathNode with _$PathNode {
  const factory PathNode({
    required String id,
    required String title,
    required String description,
    required PathNodeType type,
    required String entityId,
    required int estimatedDuration,
    required String difficulty,
    @Default(false) bool completed,
    @Default(false) bool locked,
    DateTime? completedAt,
    double? scorePercentage,
    List<String>? prerequisites,
  }) = _PathNode;

  const PathNode._();

  /// Check if node is accessible
  bool get isAccessible => !locked;

  /// Get node icon
  String get icon {
    switch (type) {
      case PathNodeType.video:
        return '🎥';
      case PathNodeType.quiz:
        return '📝';
      case PathNodeType.practice:
        return '💪';
      case PathNodeType.revision:
        return '📚';
      case PathNodeType.assessment:
        return '✅';
    }
  }

  /// Get difficulty level
  DifficultyLevel get difficultyLevel {
    switch (difficulty.toLowerCase()) {
      case 'advanced':
        return DifficultyLevel.advanced;
      case 'intermediate':
        return DifficultyLevel.intermediate;
      default:
        return DifficultyLevel.basic;
    }
  }

  /// Check if passed (for quizzes)
  bool get passed => scorePercentage != null && scorePercentage! >= 75.0;

  /// Check if excellent (for quizzes)
  bool get excellent => scorePercentage != null && scorePercentage! >= 90.0;
}

/// Path node type enum
enum PathNodeType {
  video,
  quiz,
  practice,
  revision,
  assessment;

  String get displayName {
    switch (this) {
      case PathNodeType.video:
        return 'Video';
      case PathNodeType.quiz:
        return 'Quiz';
      case PathNodeType.practice:
        return 'Practice';
      case PathNodeType.revision:
        return 'Revision';
      case PathNodeType.assessment:
        return 'Assessment';
    }
  }
}

/// Path status enum
enum PathStatus {
  active,
  completed,
  paused,
  abandoned;

  String get displayName {
    switch (this) {
      case PathStatus.active:
        return 'Active';
      case PathStatus.completed:
        return 'Completed';
      case PathStatus.paused:
        return 'Paused';
      case PathStatus.abandoned:
        return 'Abandoned';
    }
  }
}

/// Path difficulty enum
enum PathDifficulty {
  beginner,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case PathDifficulty.beginner:
        return 'Beginner';
      case PathDifficulty.intermediate:
        return 'Intermediate';
      case PathDifficulty.advanced:
        return 'Advanced';
    }
  }
}

/// Difficulty level enum
enum DifficultyLevel {
  basic,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case DifficultyLevel.basic:
        return 'Basic';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
    }
  }
}
