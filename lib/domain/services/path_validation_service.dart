/// Path Validation Service
///
/// Validates learning paths to ensure they are still relevant
/// and appropriate for the student's current level.
library;

import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/domain/repositories/learning_path_repository.dart';

/// Result of path validation
class PathValidation {
  final bool isValid;
  final String? reason;
  final PathValidationSuggestion? suggestion;

  const PathValidation({
    required this.isValid,
    this.reason,
    this.suggestion,
  });

  /// Create a valid path validation
  factory PathValidation.valid() => const PathValidation(isValid: true);

  /// Create an invalid path validation
  factory PathValidation.invalid({
    required String reason,
    PathValidationSuggestion? suggestion,
  }) =>
      PathValidation(
        isValid: false,
        reason: reason,
        suggestion: suggestion,
      );
}

/// Suggestions for what to do with invalid paths
enum PathValidationSuggestion {
  /// Generate a new path based on current knowledge
  generateNewPath,

  /// Archive this path as no longer needed
  archivePath,

  /// Update the path with new content
  updatePath,

  /// Pause the path temporarily
  pausePath,
}

/// Service for validating learning path relevance
class PathValidationService {
  final LearningPathRepository _pathRepository;

  PathValidationService({
    required LearningPathRepository pathRepository,
  }) : _pathRepository = pathRepository;

  /// Validate if a path is still relevant for the student
  ///
  /// Returns [PathValidation] with validity status and suggestions.
  Future<PathValidation> validatePath(String pathId) async {
    try {
      logger.debug('Validating learning path: $pathId');

      final pathResult = await _pathRepository.getPathById(pathId);

      return pathResult.fold(
        (failure) {
          logger.error('Failed to load path for validation: ${failure.message}');
          return PathValidation.invalid(
            reason: 'Path not found',
            suggestion: PathValidationSuggestion.archivePath,
          );
        },
        (path) async {
          if (path == null) {
            return PathValidation.invalid(
              reason: 'Path not found',
              suggestion: PathValidationSuggestion.archivePath,
            );
          }

          // Run validation checks
          return await _runValidationChecks(path);
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to validate path', e, stackTrace);
      return PathValidation.invalid(
        reason: 'Validation failed: $e',
      );
    }
  }

  /// Run all validation checks on a path
  Future<PathValidation> _runValidationChecks(LearningPath path) async {
    // Check 1: Is path too old? (>30 days)
    final ageCheck = _checkPathAge(path);
    if (!ageCheck.isValid) return ageCheck;

    // Check 2: Is path completed?
    if (path.status == PathStatus.completed) {
      return PathValidation.invalid(
        reason: 'Path already completed',
        suggestion: PathValidationSuggestion.archivePath,
      );
    }

    // Check 3: Is path abandoned?
    if (path.status == PathStatus.abandoned) {
      return PathValidation.invalid(
        reason: 'Path was abandoned',
        suggestion: PathValidationSuggestion.archivePath,
      );
    }

    // Check 4: Validate nodes are accessible
    final nodesCheck = _checkNodesAccessibility(path);
    if (!nodesCheck.isValid) return nodesCheck;

    // All checks passed
    logger.info('Path ${path.id} is valid');
    return PathValidation.valid();
  }

  /// Check if path is too old
  PathValidation _checkPathAge(LearningPath path) {
    final age = DateTime.now().difference(path.createdAt).inDays;

    if (age > 30 && path.progressPercentage < 25) {
      return PathValidation.invalid(
        reason: 'Path is outdated ($age days old, ${path.progressPercentage.toStringAsFixed(0)}% complete)',
        suggestion: PathValidationSuggestion.generateNewPath,
      );
    }

    if (age > 90) {
      return PathValidation.invalid(
        reason: 'Path is very old ($age days)',
        suggestion: PathValidationSuggestion.generateNewPath,
      );
    }

    return PathValidation.valid();
  }

  /// Check if nodes are still accessible and valid
  PathValidation _checkNodesAccessibility(LearningPath path) {
    // Check for empty path
    if (path.nodes.isEmpty) {
      return PathValidation.invalid(
        reason: 'Path has no nodes',
        suggestion: PathValidationSuggestion.archivePath,
      );
    }

    // Check for locked nodes that should be accessible
    final currentIndex = path.currentNodeIndex;
    if (currentIndex < path.nodes.length) {
      final currentNode = path.nodes[currentIndex];
      if (currentNode.locked) {
        return PathValidation.invalid(
          reason: 'Current node is locked',
          suggestion: PathValidationSuggestion.updatePath,
        );
      }
    }

    return PathValidation.valid();
  }

  /// Validate multiple paths and return only valid ones
  Future<List<LearningPath>> validateAndFilterPaths(
    List<LearningPath> paths,
  ) async {
    final validPaths = <LearningPath>[];

    for (final path in paths) {
      final validation = await validatePath(path.id);

      if (validation.isValid) {
        validPaths.add(path);
      } else {
        logger.info(
          'Filtered out invalid path ${path.id}: ${validation.reason}',
        );

        // Handle suggestion
        if (validation.suggestion != null) {
          await _handleValidationSuggestion(path, validation.suggestion!);
        }
      }
    }

    return validPaths;
  }

  /// Handle validation suggestion for invalid path
  Future<void> _handleValidationSuggestion(
    LearningPath path,
    PathValidationSuggestion suggestion,
  ) async {
    switch (suggestion) {
      case PathValidationSuggestion.archivePath:
        logger.info('Archiving invalid path: ${path.id}');
        // Mark as abandoned
        await _pathRepository.updatePathStatus(
          path.id,
          PathStatus.abandoned,
        );
        break;

      case PathValidationSuggestion.pausePath:
        logger.info('Pausing invalid path: ${path.id}');
        await _pathRepository.updatePathStatus(
          path.id,
          PathStatus.paused,
        );
        break;

      case PathValidationSuggestion.generateNewPath:
      case PathValidationSuggestion.updatePath:
        // These require user action, just log
        logger.info(
          'Path ${path.id} needs ${suggestion.name}',
        );
        break;
    }
  }

  /// Quick validation check without side effects
  ///
  /// Returns true if path passes basic validity checks.
  /// Use this for quick filtering without automatic status updates.
  bool isPathValid(LearningPath path) {
    // Check age
    final age = DateTime.now().difference(path.createdAt).inDays;
    if (age > 90) return false;

    // Check status
    if (path.status == PathStatus.completed ||
        path.status == PathStatus.abandoned) {
      return false;
    }

    // Check nodes
    if (path.nodes.isEmpty) return false;

    return true;
  }
}
