/// Mind Map repository interface for managing chapter mind maps
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/study_tools/mind_map_node.dart';

/// Repository interface for mind map operations
abstract class MindMapRepository {
  /// Get complete mind map for a chapter
  Future<Either<Failure, MindMap?>> getMindMap(String chapterId, String segment);

  /// Get all nodes for a chapter
  Future<Either<Failure, List<MindMapNode>>> getNodes(
    String chapterId,
    String segment,
  );

  /// Get root nodes only
  Future<Either<Failure, List<MindMapNode>>> getRootNodes(
    String chapterId,
    String segment,
  );

  /// Get children of a specific node
  Future<Either<Failure, List<MindMapNode>>> getChildren(String parentId);

  /// Save a node
  Future<Either<Failure, MindMapNode>> saveNode(MindMapNode node);

  /// Save multiple nodes at once
  Future<Either<Failure, void>> saveNodes(List<MindMapNode> nodes);

  /// Check if a chapter has a mind map
  Future<Either<Failure, bool>> hasMindMap(String chapterId, String segment);

  /// Delete mind map for a chapter
  Future<Either<Failure, void>> deleteMindMap(String chapterId);
}
