/// Repository interface for LearningPath persistence operations
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';

/// Abstract repository for managing learning paths
abstract class LearningPathRepository {
  /// Save a new learning path to the database
  Future<Either<Failure, LearningPath>> savePath(LearningPath path);

  /// Update an existing learning path
  Future<Either<Failure, LearningPath>> updatePath(LearningPath path);

  /// Get a learning path by ID
  Future<Either<Failure, LearningPath?>> getPathById(String id);

  /// Get all active learning paths for a student
  Future<Either<Failure, List<LearningPath>>> getActivePaths(String studentId);

  /// Get all learning paths for a student (regardless of status)
  Future<Either<Failure, List<LearningPath>>> getAllPaths(String studentId);

  /// Get active learning path for a specific subject
  Future<Either<Failure, LearningPath?>> getActivePathForSubject({
    required String studentId,
    required String subjectId,
  });

  /// Update node completion status
  ///
  /// This is a critical operation that:
  /// 1. Updates the specific node's completion status and score
  /// 2. Updates the completed_node_ids array
  /// 3. Checks if path is now complete and updates path status
  /// 4. Syncs progress with recommendations_history table
  Future<Either<Failure, LearningPath>> updateNodeCompletion({
    required String pathId,
    required String nodeId,
    required bool completed,
    DateTime? completedAt,
    double? scorePercentage,
  });

  /// Advance to the next node in the path
  Future<Either<Failure, LearningPath>> advanceToNextNode(String pathId);

  /// Mark the entire path as completed
  Future<Either<Failure, LearningPath>> completePath(String pathId);

  /// Update path status (active, paused, abandoned, completed)
  Future<Either<Failure, LearningPath>> updatePathStatus(
    String pathId,
    PathStatus status,
  );

  /// Delete a learning path
  Future<Either<Failure, void>> deletePath(String id);
}
