/// Implementation of LearningPathRepository
///
/// **Offline-First Architecture**
/// This repository uses SQLite for local storage, providing full
/// offline functionality. All operations save to the local database
/// immediately, ensuring data persistence even without internet connection.
///
/// Progress tracking, node completions, and path updates work seamlessly
/// offline. Future server sync can be added without changing this implementation.
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/learning_path_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/recommendations_history_dao.dart';
import 'package:streamshaala/data/models/pedagogy/learning_path_model.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/domain/repositories/learning_path_repository.dart';

/// Concrete implementation of LearningPathRepository
class LearningPathRepositoryImpl implements LearningPathRepository {
  final LearningPathDao _dao;
  final RecommendationsHistoryDao _recommendationsDao;

  const LearningPathRepositoryImpl({
    required LearningPathDao dao,
    required RecommendationsHistoryDao recommendationsDao,
  })  : _dao = dao,
        _recommendationsDao = recommendationsDao;

  @override
  Future<Either<Failure, LearningPath>> savePath(LearningPath path) async {
    try {
      logger.debug('Saving learning path: ${path.id}');
      final model = LearningPathModel.fromEntity(path);
      await _dao.insert(model);
      logger.info('✅ Saved learning path: ${path.id}');
      return Right(path);
    } catch (e, stackTrace) {
      logger.error('Failed to save learning path', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save learning path: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath>> updatePath(LearningPath path) async {
    try {
      logger.debug('Updating learning path: ${path.id}');
      final model = LearningPathModel.fromEntity(path);
      await _dao.update(model);
      logger.info('✅ Updated learning path: ${path.id}');
      return Right(path);
    } catch (e, stackTrace) {
      logger.error('Failed to update learning path', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to update learning path: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath?>> getPathById(String id) async {
    try {
      final model = await _dao.getById(id);
      if (model == null) {
        logger.debug('Learning path not found: $id');
        return const Right(null);
      }
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      logger.error('Failed to get learning path by ID', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get learning path: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LearningPath>>> getActivePaths(
    String studentId,
  ) async {
    try {
      final models = await _dao.getByStudent(
        studentId: studentId,
        status: PathStatus.active.name,
      );
      final paths = models.map((model) => model.toEntity()).toList();
      logger.debug('Retrieved ${paths.length} active paths for student: $studentId');
      return Right(paths);
    } catch (e, stackTrace) {
      logger.error('Failed to get active paths', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get active paths: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LearningPath>>> getAllPaths(
    String studentId,
  ) async {
    try {
      final models = await _dao.getByStudent(studentId: studentId);
      final paths = models.map((model) => model.toEntity()).toList();
      logger.debug('Retrieved ${paths.length} paths for student: $studentId');
      return Right(paths);
    } catch (e, stackTrace) {
      logger.error('Failed to get all paths', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get all paths: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath?>> getActivePathForSubject({
    required String studentId,
    required String subjectId,
  }) async {
    try {
      final model = await _dao.getActivePathForSubject(
        studentId: studentId,
        subjectId: subjectId,
      );
      if (model == null) {
        logger.debug('No active path found for subject: $subjectId');
        return const Right(null);
      }
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      logger.error('Failed to get active path for subject', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get active path for subject: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath>> updateNodeCompletion({
    required String pathId,
    required String nodeId,
    required bool completed,
    DateTime? completedAt,
    double? scorePercentage,
  }) async {
    try {
      logger.debug('Updating node completion: $nodeId in path $pathId');

      // 1. Update node in database
      await _dao.updateNodeCompletion(
        pathId: pathId,
        nodeId: nodeId,
        completed: completed,
        completedAt: completedAt ?? DateTime.now(),
        scorePercentage: scorePercentage,
      );

      // 2. Reload path to get updated state
      final model = await _dao.getById(pathId);
      if (model == null) {
        return Left(NotFoundFailure(
          message: 'Learning path not found',
          entityType: 'LearningPath',
          entityId: pathId,
        ));
      }

      final path = model.toEntity();

      // 3. Check if path is now complete
      if (path.isCompleted && path.status == PathStatus.active) {
        logger.info('🎉 Learning path completed: $pathId');
        await _dao.markCompleted(pathId);

        // 4. Update recommendations_history table if there's a linked recommendation
        final recommendationsHistoryId = path.metadata?['recommendationsHistoryId'] as String?;
        if (recommendationsHistoryId != null) {
          try {
            await _recommendationsDao.updateLearningPathStatus(
              id: recommendationsHistoryId,
              completed: true,
            );
            logger.debug('Updated recommendations history: $recommendationsHistoryId');
          } catch (e) {
            // Log but don't fail - path completion is more important
            logger.warning('Failed to update recommendations history', e);
          }
        }

        // Reload path to get the completed status
        final completedModel = await _dao.getById(pathId);
        return Right(completedModel!.toEntity());
      }

      // 5. Update recommendations_history with progress percentage
      final recommendationsHistoryId = path.metadata?['recommendationsHistoryId'] as String?;
      if (recommendationsHistoryId != null) {
        try {
          await _recommendationsDao.updateLearningPathStatus(
            id: recommendationsHistoryId,
            started: path.hasStarted,
            completed: false,
          );
          logger.debug('Updated progress in recommendations history: ${path.progressPercentage}%');
        } catch (e) {
          // Log but don't fail
          logger.warning('Failed to update recommendations history progress', e);
        }
      }

      logger.info('✅ Updated node completion: $nodeId (${path.progressPercentage.toStringAsFixed(0)}% complete)');
      return Right(path);
    } catch (e, stackTrace) {
      logger.error('Failed to update node completion', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to update node completion: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath>> advanceToNextNode(String pathId) async {
    try {
      logger.debug('Advancing to next node in path: $pathId');

      // Get current path
      final model = await _dao.getById(pathId);
      if (model == null) {
        return Left(NotFoundFailure(
          message: 'Learning path not found',
          entityType: 'LearningPath',
          entityId: pathId,
        ));
      }

      final path = model.toEntity();

      // Check if we can advance
      if (path.currentNodeIndex >= path.totalNodes - 1) {
        logger.debug('Already at last node, cannot advance');
        return Right(path);
      }

      // Create updated path with incremented index
      final updatedPath = LearningPath(
        id: path.id,
        studentId: path.studentId,
        subjectId: path.subjectId,
        nodes: path.nodes,
        createdAt: path.createdAt,
        lastUpdated: DateTime.now(),
        status: path.status,
        currentNodeIndex: path.currentNodeIndex + 1,
        metadata: path.metadata,
      );

      // Save updated path
      final updatedModel = LearningPathModel.fromEntity(updatedPath);
      await _dao.update(updatedModel);

      logger.info('✅ Advanced to next node (index: ${updatedPath.currentNodeIndex})');
      return Right(updatedPath);
    } catch (e, stackTrace) {
      logger.error('Failed to advance to next node', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to advance to next node: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath>> completePath(String pathId) async {
    try {
      logger.debug('Completing path: $pathId');

      await _dao.markCompleted(pathId);

      final model = await _dao.getById(pathId);
      if (model == null) {
        return Left(NotFoundFailure(
          message: 'Learning path not found',
          entityType: 'LearningPath',
          entityId: pathId,
        ));
      }

      final path = model.toEntity();

      // Update recommendations_history if linked
      final recommendationsHistoryId = path.metadata?['recommendationsHistoryId'] as String?;
      if (recommendationsHistoryId != null) {
        try {
          await _recommendationsDao.updateLearningPathStatus(
            id: recommendationsHistoryId,
            completed: true,
          );
        } catch (e) {
          logger.warning('Failed to update recommendations history', e);
        }
      }

      logger.info('✅ Path marked as completed: $pathId');
      return Right(path);
    } catch (e, stackTrace) {
      logger.error('Failed to complete path', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to complete path: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, LearningPath>> updatePathStatus(
    String pathId,
    PathStatus status,
  ) async {
    try {
      logger.debug('Updating path status: $pathId to ${status.name}');

      await _dao.updatePathStatus(pathId, status);

      final model = await _dao.getById(pathId);
      if (model == null) {
        return Left(NotFoundFailure(
          message: 'Learning path not found',
          entityType: 'LearningPath',
          entityId: pathId,
        ));
      }

      logger.info('✅ Updated path status to ${status.name}');
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      logger.error('Failed to update path status', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to update path status: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deletePath(String id) async {
    try {
      logger.debug('Deleting learning path: $id');
      await _dao.delete(id);
      logger.info('✅ Deleted learning path: $id');
      return const Right(null);
    } catch (e, stackTrace) {
      logger.error('Failed to delete learning path', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete learning path: ${e.toString()}',
        details: e,
      ));
    }
  }
}
