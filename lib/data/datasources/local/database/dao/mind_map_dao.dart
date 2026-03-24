/// Data Access Object for Mind Map operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/study_tools/mind_map_node_model.dart';

/// DAO for mind map nodes table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class MindMapDao extends BaseDao {
  MindMapDao(super.dbHelper);

  /// Insert a mind map node
  Future<void> insert(MindMapNodeModel node) async {
    await executeWithErrorHandling(
      operationName: 'insert mind map node',
      operation: () async {
        await insertRow(
          table: MindMapNodesTable.tableName,
          values: node.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Mind map node inserted: ${node.id}');
      },
    );
  }

  /// Insert multiple nodes at once
  Future<void> insertAll(List<MindMapNodeModel> nodes) async {
    await executeWithErrorHandling(
      operationName: 'insert mind map nodes',
      operation: () async {
        await batch(
          (batchHelper) {
            for (final node in nodes) {
              batchHelper.insert(
                MindMapNodesTable.tableName,
                node.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          },
          noResult: true,
        );
        logger.debug('Inserted ${nodes.length} mind map nodes');
      },
    );
  }

  /// Get all nodes for a chapter and segment
  Future<List<MindMapNodeModel>> getByChapterId(
      String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get mind map nodes',
      operation: () async {
        final maps = await queryRows(
          table: MindMapNodesTable.tableName,
          where:
              '${MindMapNodesTable.columnChapterId} = ? AND ${MindMapNodesTable.columnSegment} = ?',
          whereArgs: [chapterId, segment],
          orderBy: '${MindMapNodesTable.columnOrderIndex} ASC',
        );

        logger.debug(
            'Retrieved ${maps.length} mind map nodes for chapter: $chapterId');
        return maps.map((map) => MindMapNodeModel.fromMap(map)).toList();
      },
    );
  }

  /// Get root nodes for a chapter (nodes without parent)
  Future<List<MindMapNodeModel>> getRootNodes(
      String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'get root nodes',
      operation: () async {
        final maps = await queryRows(
          table: MindMapNodesTable.tableName,
          where:
              '${MindMapNodesTable.columnChapterId} = ? AND ${MindMapNodesTable.columnSegment} = ? AND (${MindMapNodesTable.columnParentId} IS NULL OR ${MindMapNodesTable.columnParentId} = "")',
          whereArgs: [chapterId, segment],
          orderBy: '${MindMapNodesTable.columnOrderIndex} ASC',
        );

        return maps.map((map) => MindMapNodeModel.fromMap(map)).toList();
      },
    );
  }

  /// Get child nodes for a parent
  Future<List<MindMapNodeModel>> getChildren(String parentId) async {
    return await executeWithErrorHandling(
      operationName: 'get child nodes',
      operation: () async {
        final maps = await queryRows(
          table: MindMapNodesTable.tableName,
          where: '${MindMapNodesTable.columnParentId} = ?',
          whereArgs: [parentId],
          orderBy: '${MindMapNodesTable.columnOrderIndex} ASC',
        );

        return maps.map((map) => MindMapNodeModel.fromMap(map)).toList();
      },
    );
  }

  /// Delete all nodes for a chapter
  Future<void> deleteByChapterId(String chapterId) async {
    await executeWithErrorHandling(
      operationName: 'delete mind map nodes',
      operation: () async {
        await deleteRows(
          table: MindMapNodesTable.tableName,
          where: '${MindMapNodesTable.columnChapterId} = ?',
          whereArgs: [chapterId],
        );
        logger.debug('Mind map nodes deleted for chapter: $chapterId');
      },
    );
  }

  /// Check if chapter has a mind map
  Future<bool> hasMindMap(String chapterId, String segment) async {
    return await executeWithErrorHandling(
      operationName: 'check for mind map',
      operation: () async {
        final query =
            'SELECT COUNT(*) FROM ${MindMapNodesTable.tableName} WHERE ${MindMapNodesTable.columnChapterId} = ? AND ${MindMapNodesTable.columnSegment} = ?';
        final count = await firstIntValue(query, [chapterId, segment]) ?? 0;
        return count > 0;
      },
    );
  }

  /// Delete all nodes
  Future<void> deleteAll() async {
    await executeWithErrorHandling(
      operationName: 'delete all mind map nodes',
      operation: () async {
        await deleteRows(table: MindMapNodesTable.tableName);
        logger.debug('All mind map nodes deleted');
      },
    );
  }
}
