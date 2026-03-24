/// Implementation of PathMetricsRepository
///
/// Provides analytics and metrics queries for learning paths using SQLite.
library;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/domain/repositories/path_metrics_repository.dart';

/// Concrete implementation of PathMetricsRepository
class PathMetricsRepositoryImpl implements PathMetricsRepository {
  final DatabaseHelper _databaseHelper;

  const PathMetricsRepositoryImpl({
    required DatabaseHelper databaseHelper,
  }) : _databaseHelper = databaseHelper;

  @override
  Future<Either<Failure, double>> getCompletionRate({
    String? subjectId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      // Build WHERE clause
      final conditions = <String>[];
      final args = <dynamic>[];

      if (subjectId != null) {
        conditions.add('subject_id = ?');
        args.add(subjectId);
      }

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

      // Query: Count completed and total started paths
      final query = '''
        SELECT
          COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_count,
          COUNT(*) as total_count
        FROM learning_paths
        $whereClause
      ''';

      final result = await db.rawQuery(query, args);

      if (result.isEmpty) {
        return const Right(0.0);
      }

      final completedCount = result.first['completed_count'] as int? ?? 0;
      final totalCount = result.first['total_count'] as int? ?? 0;

      if (totalCount == 0) {
        return const Right(0.0);
      }

      final completionRate = completedCount / totalCount;
      logger.debug('Completion rate: ${(completionRate * 100).toStringAsFixed(1)}%');

      return Right(completionRate);
    } catch (e, stackTrace) {
      logger.error('Failed to get completion rate', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get completion rate: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, double>> getAverageCompletionTime({
    String? subjectId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>['status = ?'];
      final args = <dynamic>['completed'];

      if (subjectId != null) {
        conditions.add('subject_id = ?');
        args.add(subjectId);
      }

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = 'WHERE ${conditions.join(' AND ')}';

      // Query: Average time from created_at to completed_at
      final query = '''
        SELECT AVG(completed_at - created_at) as avg_duration_ms
        FROM learning_paths
        $whereClause
        AND completed_at IS NOT NULL
      ''';

      final result = await db.rawQuery(query, args);

      if (result.isEmpty || result.first['avg_duration_ms'] == null) {
        return const Right(0.0);
      }

      final avgDurationMs = result.first['avg_duration_ms'] as num;
      final avgMinutes = avgDurationMs / 60000.0; // Convert ms to minutes

      logger.debug('Average completion time: ${avgMinutes.toStringAsFixed(1)} minutes');

      return Right(avgMinutes);
    } catch (e, stackTrace) {
      logger.error('Failed to get average completion time', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get average completion time: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, double>> getDropOffRate({
    String? subjectId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>[];
      final args = <dynamic>[];

      if (subjectId != null) {
        conditions.add('subject_id = ?');
        args.add(subjectId);
      }

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

      // Query: Count abandoned paths with <50% progress
      // We calculate progress as: (current_node_index / total_nodes) * 100
      final query = '''
        SELECT
          COUNT(*) as total_count,
          SUM(
            CASE
              WHEN status = 'abandoned'
              AND (
                SELECT COUNT(*)
                FROM json_each(completed_node_ids)
              ) * 2 < (
                SELECT COUNT(*)
                FROM json_each(nodes)
              )
              THEN 1
              ELSE 0
            END
          ) as early_dropoff_count
        FROM learning_paths
        $whereClause
      ''';

      final result = await db.rawQuery(query, args);

      if (result.isEmpty) {
        return const Right(0.0);
      }

      final totalCount = result.first['total_count'] as int? ?? 0;
      final earlyDropoffCount = result.first['early_dropoff_count'] as int? ?? 0;

      if (totalCount == 0) {
        return const Right(0.0);
      }

      final dropOffRate = earlyDropoffCount / totalCount;
      logger.debug('Drop-off rate: ${(dropOffRate * 100).toStringAsFixed(1)}%');

      return Right(dropOffRate);
    } catch (e, stackTrace) {
      logger.error('Failed to get drop-off rate', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get drop-off rate: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, double>> getNodeSkipRate({
    String? subjectId,
    String? nodeType,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>[];
      final args = <dynamic>[];

      if (subjectId != null) {
        conditions.add('lp.subject_id = ?');
        args.add(subjectId);
      }

      final whereClause = conditions.isEmpty ? '' : 'AND ${conditions.join(' AND ')}';

      // Query using json_each to parse nodes JSON and count skipped nodes
      // A node is "skipped" if: completed = false AND the path has moved past it
      // For simplicity, we count nodes where completed = false but they are
      // in the completed_node_ids set, which would indicate a skip
      String nodeTypeCondition = '';
      if (nodeType != null) {
        // Use parameterized query to prevent SQL injection
        nodeTypeCondition = "AND json_extract(node.value, '\$.type') = ?";
        args.add(nodeType);
      }

      final query = '''
        SELECT
          SUM(
            CASE
              WHEN json_extract(node.value, '\$.completed') = 0
              AND json_extract(node.value, '\$.locked') = 0
              AND lp.current_node_index > (
                SELECT COUNT(*)
                FROM json_each(lp.nodes) AS prev
                WHERE prev.key < node.key
              )
              THEN 1
              ELSE 0
            END
          ) as skipped_count,
          COUNT(*) as total_count
        FROM learning_paths lp,
        json_each(lp.nodes) AS node
        WHERE lp.status IN ('completed', 'active')
        $whereClause
        $nodeTypeCondition
      ''';

      final result = await db.rawQuery(query, args);

      if (result.isEmpty) {
        return const Right(0.0);
      }

      final skippedCount = result.first['skipped_count'] as int? ?? 0;
      final totalCount = result.first['total_count'] as int? ?? 0;

      if (totalCount == 0) {
        return const Right(0.0);
      }

      final skipRate = skippedCount / totalCount;
      logger.debug('Node skip rate: ${(skipRate * 100).toStringAsFixed(1)}%');

      return Right(skipRate);
    } catch (e, stackTrace) {
      logger.error('Failed to get node skip rate', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get node skip rate: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, double>> getAveragePathScore({
    String? subjectId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>['lp.status = ?'];
      final args = <dynamic>['completed'];

      if (subjectId != null) {
        conditions.add('lp.subject_id = ?');
        args.add(subjectId);
      }

      if (dateRange != null) {
        conditions.add('lp.created_at >= ?');
        conditions.add('lp.created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = 'WHERE ${conditions.join(' AND ')}';

      // Query using json_each to parse nodes JSON and calculate average scores
      // Only considers nodes that are completed and have a scorePercentage
      final query = '''
        SELECT
          AVG(json_extract(node.value, '\$.scorePercentage')) as avg_score
        FROM learning_paths lp,
        json_each(lp.nodes) AS node
        $whereClause
        AND json_extract(node.value, '\$.completed') = 1
        AND json_extract(node.value, '\$.scorePercentage') IS NOT NULL
      ''';

      final result = await db.rawQuery(query, args);

      if (result.isEmpty || result.first['avg_score'] == null) {
        return const Right(0.0);
      }

      final avgScore = (result.first['avg_score'] as num).toDouble();
      logger.debug('Average path score: ${avgScore.toStringAsFixed(1)}%');

      return Right(avgScore);
    } catch (e, stackTrace) {
      logger.error('Failed to get average path score', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get average path score: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalPathsStarted({
    String? subjectId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>[];
      final args = <dynamic>[];

      if (subjectId != null) {
        conditions.add('subject_id = ?');
        args.add(subjectId);
      }

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

      final query = '''
        SELECT COUNT(*) as count
        FROM learning_paths
        $whereClause
      ''';

      final result = await db.rawQuery(query, args);

      final count = result.first['count'] as int? ?? 0;
      logger.debug('Total paths started: $count');

      return Right(count);
    } catch (e, stackTrace) {
      logger.error('Failed to get total paths started', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get total paths started: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalPathsCompleted({
    String? subjectId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>['status = ?'];
      final args = <dynamic>['completed'];

      if (subjectId != null) {
        conditions.add('subject_id = ?');
        args.add(subjectId);
      }

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = 'WHERE ${conditions.join(' AND ')}';

      final query = '''
        SELECT COUNT(*) as count
        FROM learning_paths
        $whereClause
      ''';

      final result = await db.rawQuery(query, args);

      final count = result.first['count'] as int? ?? 0;
      logger.debug('Total paths completed: $count');

      return Right(count);
    } catch (e, stackTrace) {
      logger.error('Failed to get total paths completed', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get total paths completed: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getMostPopularSubjects({
    int limit = 10,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>[];
      final args = <dynamic>[];

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

      final query = '''
        SELECT subject_id, COUNT(*) as count
        FROM learning_paths
        $whereClause
        GROUP BY subject_id
        ORDER BY count DESC
        LIMIT ?
      ''';

      args.add(limit);

      final result = await db.rawQuery(query, args);

      final popularSubjects = <String, int>{};
      for (final row in result) {
        final subjectId = row['subject_id'] as String;
        final count = row['count'] as int;
        popularSubjects[subjectId] = count;
      }

      logger.debug('Most popular subjects: ${popularSubjects.length} subjects');

      return Right(popularSubjects);
    } catch (e, stackTrace) {
      logger.error('Failed to get most popular subjects', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get most popular subjects: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStudentEngagement({
    required String studentId,
    DateTimeRange? dateRange,
  }) async {
    try {
      final db = await _databaseHelper.database;

      final conditions = <String>['student_id = ?'];
      final args = <dynamic>[studentId];

      if (dateRange != null) {
        conditions.add('created_at >= ?');
        conditions.add('created_at <= ?');
        args.add(dateRange.start.millisecondsSinceEpoch);
        args.add(dateRange.end.millisecondsSinceEpoch);
      }

      final whereClause = 'WHERE ${conditions.join(' AND ')}';

      // Comprehensive engagement query
      final query = '''
        SELECT
          COUNT(*) as total_paths_started,
          COUNT(CASE WHEN status = 'completed' THEN 1 END) as total_paths_completed,
          SUM(
            CASE WHEN status = 'completed' AND completed_at IS NOT NULL
            THEN completed_at - created_at
            ELSE 0
            END
          ) as total_time_spent_ms
        FROM learning_paths
        $whereClause
      ''';

      final result = await db.rawQuery(query, args);

      if (result.isEmpty) {
        return Right(<String, dynamic>{
          'total_paths_started': 0,
          'total_paths_completed': 0,
          'completion_rate': 0.0,
          'average_score': 0.0,
          'total_time_spent_minutes': 0.0,
        });
      }

      final row = result.first;
      final totalStarted = row['total_paths_started'] as int? ?? 0;
      final totalCompleted = row['total_paths_completed'] as int? ?? 0;
      final totalTimeMs = row['total_time_spent_ms'] as int? ?? 0;

      final completionRate = totalStarted > 0 ? totalCompleted / totalStarted : 0.0;
      final totalTimeMinutes = totalTimeMs / 60000.0;

      // Calculate average score from completed nodes
      final scoreQuery = '''
        SELECT AVG(json_extract(node.value, '\$.scorePercentage')) as avg_score
        FROM learning_paths lp,
        json_each(lp.nodes) AS node
        WHERE lp.student_id = ?
        AND json_extract(node.value, '\$.completed') = 1
        AND json_extract(node.value, '\$.scorePercentage') IS NOT NULL
      ''';

      final scoreResult = await db.rawQuery(scoreQuery, [studentId]);
      final averageScore = scoreResult.isNotEmpty && scoreResult.first['avg_score'] != null
          ? (scoreResult.first['avg_score'] as num).toDouble()
          : 0.0;

      final engagement = {
        'total_paths_started': totalStarted,
        'total_paths_completed': totalCompleted,
        'completion_rate': completionRate,
        'average_score': averageScore,
        'total_time_spent_minutes': totalTimeMinutes,
      };

      logger.debug('Student engagement for $studentId: $engagement');

      return Right(engagement);
    } catch (e, stackTrace) {
      logger.error('Failed to get student engagement', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get student engagement: ${e.toString()}',
        details: e,
      ));
    }
  }
}
