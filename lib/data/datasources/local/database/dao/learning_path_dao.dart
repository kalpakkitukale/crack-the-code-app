/// Data Access Object for learning paths
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'dart:convert';

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/pedagogy/learning_path_model.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';

/// DAO for managing learning path persistence
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class LearningPathDao extends BaseDao {
  LearningPathDao(super.dbHelper);

  static const String _tableName = LearningPathsTable.tableName;

  /// Insert a new learning path
  Future<void> insert(LearningPathModel path) async {
    await executeWithErrorHandling(
      operationName: 'insert learning path',
      operation: () async {
        await insertRow(
          table: _tableName,
          values: path.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Inserted learning path: ${path.id}');
      },
    );
  }

  /// Update an existing learning path
  Future<void> update(LearningPathModel path) async {
    await executeWithErrorHandling(
      operationName: 'update learning path',
      operation: () async {
        await updateRows(
          table: _tableName,
          values: path.toMap(),
          where: '${LearningPathsTable.columnId} = ?',
          whereArgs: [path.id],
        );
        logger.debug('Updated learning path: ${path.id}');
      },
    );
  }

  /// Get a learning path by ID
  Future<LearningPathModel?> getById(String id) async {
    return await executeWithErrorHandling(
      operationName: 'get learning path by ID',
      operation: () async {
        final results = await queryRows(
          table: _tableName,
          where: '${LearningPathsTable.columnId} = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (results.isEmpty) return null;
        return LearningPathModel.fromMap(results.first);
      },
    );
  }

  /// Get all learning paths for a student
  Future<List<LearningPathModel>> getByStudent({
    required String studentId,
    String? status,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get learning paths for student',
      operation: () async {
        final where = status != null
            ? '${LearningPathsTable.columnStudentId} = ? AND ${LearningPathsTable.columnStatus} = ?'
            : '${LearningPathsTable.columnStudentId} = ?';
        final whereArgs = status != null ? [studentId, status] : [studentId];

        final results = await queryRows(
          table: _tableName,
          where: where,
          whereArgs: whereArgs,
          orderBy: '${LearningPathsTable.columnLastUpdated} DESC',
        );

        return results.map((map) => LearningPathModel.fromMap(map)).toList();
      },
    );
  }

  /// Get active learning path for a specific subject
  Future<LearningPathModel?> getActivePathForSubject({
    required String studentId,
    required String subjectId,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get active path for subject',
      operation: () async {
        final results = await queryRows(
          table: _tableName,
          where:
              '${LearningPathsTable.columnStudentId} = ? AND ${LearningPathsTable.columnSubjectId} = ? AND ${LearningPathsTable.columnStatus} = ?',
          whereArgs: [studentId, subjectId, 'active'],
          orderBy: '${LearningPathsTable.columnLastUpdated} DESC',
          limit: 1,
        );

        if (results.isEmpty) return null;
        return LearningPathModel.fromMap(results.first);
      },
    );
  }

  /// Update node completion status
  /// This is a critical operation that loads the path JSON, updates the specific node, and saves it back
  Future<void> updateNodeCompletion({
    required String pathId,
    required String nodeId,
    required bool completed,
    DateTime? completedAt,
    double? scorePercentage,
  }) async {
    await executeWithErrorHandling(
      operationName: 'update node completion',
      operation: () async {
        await transaction((txn) async {
          // 1. Load current path
          final results = await txn.query(
            _tableName,
            where: '${LearningPathsTable.columnId} = ?',
            whereArgs: [pathId],
            limit: 1,
          );

          if (results.isEmpty) {
            throw DatabaseException(
              message: 'Learning path not found: $pathId',
              details: pathId,
            );
          }

          final pathMap = results.first;
          final nodesJson = pathMap[LearningPathsTable.columnNodes] as String;

          // 2. Parse nodes JSON
          final nodesList = jsonDecode(nodesJson) as List<dynamic>;

          // 3. Find and update the specific node
          bool nodeFound = false;
          for (var i = 0; i < nodesList.length; i++) {
            final node = nodesList[i] as Map<String, dynamic>;
            if (node['id'] == nodeId) {
              node['completed'] = completed;
              if (completedAt != null) {
                node['completedAt'] = completedAt.millisecondsSinceEpoch;
              }
              if (scorePercentage != null) {
                node['scorePercentage'] = scorePercentage;
              }
              nodeFound = true;
              break;
            }
          }

          if (!nodeFound) {
            throw DatabaseException(
              message: 'Node not found in path: $nodeId',
              details: nodeId,
            );
          }

          // 4. Update completed_node_ids array
          final completedIdsJson =
              pathMap[LearningPathsTable.columnCompletedNodeIds] as String;
          final completedIds = (jsonDecode(completedIdsJson) as List<dynamic>)
              .map((e) => e as String)
              .toList();

          if (completed && !completedIds.contains(nodeId)) {
            completedIds.add(nodeId);
          } else if (!completed && completedIds.contains(nodeId)) {
            completedIds.remove(nodeId);
          }

          // 5. Save updated data
          final updatedMap = {
            LearningPathsTable.columnNodes: jsonEncode(nodesList),
            LearningPathsTable.columnCompletedNodeIds: jsonEncode(completedIds),
            LearningPathsTable.columnLastUpdated:
                DateTime.now().millisecondsSinceEpoch,
          };

          await txn.update(
            _tableName,
            updatedMap,
            where: '${LearningPathsTable.columnId} = ?',
            whereArgs: [pathId],
          );
        });

        logger.debug('Updated node completion: $nodeId in path $pathId');
      },
    );
  }

  /// Update path status
  Future<void> updatePathStatus(String pathId, PathStatus status) async {
    await executeWithErrorHandling(
      operationName: 'update path status',
      operation: () async {
        await updateRows(
          table: _tableName,
          values: {
            LearningPathsTable.columnStatus: status.name,
            LearningPathsTable.columnLastUpdated:
                DateTime.now().millisecondsSinceEpoch,
          },
          where: '${LearningPathsTable.columnId} = ?',
          whereArgs: [pathId],
        );
        logger.debug('Updated path status: $pathId to ${status.name}');
      },
    );
  }

  /// Mark path as completed
  Future<void> markCompleted(String pathId) async {
    await executeWithErrorHandling(
      operationName: 'mark path as completed',
      operation: () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        await updateRows(
          table: _tableName,
          values: {
            LearningPathsTable.columnStatus: PathStatus.completed.name,
            LearningPathsTable.columnCompletedAt: now,
            LearningPathsTable.columnLastUpdated: now,
          },
          where: '${LearningPathsTable.columnId} = ?',
          whereArgs: [pathId],
        );
        logger.debug('Marked path as completed: $pathId');
      },
    );
  }

  /// Delete a learning path
  Future<void> delete(String id) async {
    await executeWithErrorHandling(
      operationName: 'delete learning path',
      operation: () async {
        await deleteRows(
          table: _tableName,
          where: '${LearningPathsTable.columnId} = ?',
          whereArgs: [id],
        );
        logger.debug('Deleted learning path: $id');
      },
    );
  }
}
