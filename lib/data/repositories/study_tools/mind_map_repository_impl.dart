/// Mind Map repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/mind_map_dao.dart';
import 'package:streamshaala/data/models/study_tools/mind_map_node_model.dart';
import 'package:streamshaala/domain/entities/study_tools/mind_map_node.dart';
import 'package:streamshaala/domain/repositories/study_tools/mind_map_repository.dart';

/// Implementation of MindMapRepository using JSON-first loading with database caching
class MindMapRepositoryImpl implements MindMapRepository {
  final MindMapDao _mindMapDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  /// Subject ID for JSON lookup (set by provider)
  String? subjectId;

  MindMapRepositoryImpl(this._mindMapDao, this._jsonDataSource);

  @override
  Future<Either<Failure, MindMap?>> getMindMap(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.info('Getting mind map for chapter: $chapterId');

      // 1. Check database cache first
      var models = await _mindMapDao.getByChapterId(chapterId, segment);

      // 2. If empty and subject ID is set, load from JSON
      if (models.isEmpty && subjectId != null) {
        final jsonModels = await _jsonDataSource.loadMindMap(
          subjectId: subjectId!,
          chapterId: chapterId,
          segment: segment,
        );

        if (jsonModels.isNotEmpty) {
          // Cache to database
          await _mindMapDao.insertAll(jsonModels);
          models = jsonModels;
          logger.info('Mind map loaded from JSON and cached: ${models.length} nodes');
        }
      }

      if (models.isEmpty) {
        return const Right(null);
      }

      final nodes = models.map((model) => model.toEntity()).toList();
      final mindMap = MindMap(
        chapterId: chapterId,
        segment: segment,
        nodes: nodes,
      );

      logger.info('Retrieved mind map with ${nodes.length} nodes');
      return Right(mindMap);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting mind map', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get mind map',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting mind map', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<MindMapNode>>> getNodes(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.info('Getting mind map nodes for chapter: $chapterId');

      // Ensure nodes are loaded
      final result = await getMindMap(chapterId, segment);
      return result.fold(
        (failure) => Left(failure),
        (mindMap) => Right(mindMap?.nodes ?? []),
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting nodes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get mind map nodes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting nodes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<MindMapNode>>> getRootNodes(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.info('Getting root nodes for chapter: $chapterId');

      // Ensure nodes are loaded
      await getMindMap(chapterId, segment);

      final models = await _mindMapDao.getRootNodes(chapterId, segment);
      final nodes = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${nodes.length} root nodes');
      return Right(nodes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting root nodes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get root nodes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting root nodes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<MindMapNode>>> getChildren(String parentId) async {
    try {
      logger.debug('Getting children for node: $parentId');

      final models = await _mindMapDao.getChildren(parentId);
      final nodes = models.map((model) => model.toEntity()).toList();

      return Right(nodes);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting children', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get child nodes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting children', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, MindMapNode>> saveNode(MindMapNode node) async {
    try {
      logger.info('Saving mind map node: ${node.label}');

      final model = MindMapNodeModel.fromEntity(node);
      await _mindMapDao.insert(model);

      logger.info('Node saved successfully');
      return Right(node);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving node', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save mind map node',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving node', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveNodes(List<MindMapNode> nodes) async {
    try {
      logger.info('Saving ${nodes.length} mind map nodes');

      final models = nodes.map((n) => MindMapNodeModel.fromEntity(n)).toList();
      await _mindMapDao.insertAll(models);

      logger.info('Nodes saved successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving nodes', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save mind map nodes',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving nodes', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasMindMap(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.debug('Checking if chapter has mind map: $chapterId');

      // Check database first
      final existsInDb = await _mindMapDao.hasMindMap(chapterId, segment);
      if (existsInDb) {
        return const Right(true);
      }

      // Check JSON cache if subject ID is set
      if (subjectId != null) {
        final cached = _jsonDataSource.getMindMapFromCache(
          subjectId: subjectId!,
          chapterId: chapterId,
        );
        if (cached != null && cached.isNotEmpty) {
          return const Right(true);
        }

        // Try loading from JSON
        final jsonModels = await _jsonDataSource.loadMindMap(
          subjectId: subjectId!,
          chapterId: chapterId,
          segment: segment,
        );
        return Right(jsonModels.isNotEmpty);
      }

      return const Right(false);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error checking mind map', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to check mind map',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error checking mind map', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMindMap(String chapterId) async {
    try {
      logger.info('Deleting mind map for chapter: $chapterId');

      await _mindMapDao.deleteByChapterId(chapterId);

      logger.info('Mind map deleted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting mind map', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete mind map',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting mind map', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
