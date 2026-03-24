/// Data Access Object for RecommendationsHistory operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'dart:convert';

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/base_dao.dart';
import 'package:streamshaala/data/models/pedagogy/recommendations_history_model.dart';
import 'package:streamshaala/domain/entities/pedagogy/recommendations_history.dart';

/// DAO for recommendations_history table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class RecommendationsHistoryDao extends BaseDao {
  RecommendationsHistoryDao(super.dbHelper);

  /// Insert new recommendations history
  Future<void> insert(RecommendationsHistory history) async {
    await executeWithErrorHandling(
      operationName: 'insert recommendations history',
      operation: () async {
        final model = RecommendationsHistoryModel.fromEntity(history);

        await insertRow(
          table: RecommendationsHistoryTable.tableName,
          values: model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        logger.info('Inserted recommendations history: ${history.id}');
      },
    );
  }

  /// Update existing recommendations history
  Future<void> update(RecommendationsHistory history) async {
    await executeWithErrorHandling(
      operationName: 'update recommendations history',
      operation: () async {
        final model = RecommendationsHistoryModel.fromEntity(history);

        await updateRows(
          table: RecommendationsHistoryTable.tableName,
          values: model.toMap(),
          where: '${RecommendationsHistoryTable.columnId} = ?',
          whereArgs: [history.id],
        );

        logger.info('Updated recommendations history: ${history.id}');
      },
    );
  }

  /// Get recommendations by quiz attempt ID
  Future<RecommendationsHistory?> getByQuizAttempt(String quizAttemptId) async {
    return await executeWithErrorHandling(
      operationName: 'get recommendations by quiz attempt',
      operation: () async {
        final maps = await queryRows(
          table: RecommendationsHistoryTable.tableName,
          where: '${RecommendationsHistoryTable.columnQuizAttemptId} = ?',
          whereArgs: [quizAttemptId],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return RecommendationsHistoryModel.fromMap(maps.first).toEntity();
      },
    );
  }

  /// Get recommendations by ID
  Future<RecommendationsHistory?> getById(String id) async {
    return await executeWithErrorHandling(
      operationName: 'get recommendations by ID',
      operation: () async {
        final maps = await queryRows(
          table: RecommendationsHistoryTable.tableName,
          where: '${RecommendationsHistoryTable.columnId} = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (maps.isEmpty) {
          return null;
        }

        return RecommendationsHistoryModel.fromMap(maps.first).toEntity();
      },
    );
  }

  /// Get all recommendations for a user with filters
  Future<List<RecommendationsHistory>> getFiltered({
    required String userId,
    AssessmentType? assessmentType,
    String? subjectId,
    bool? hasRecommendations,
    int limit = 50,
    int offset = 0,
  }) async {
    return await executeWithErrorHandling(
      operationName: 'get filtered recommendations',
      operation: () async {
        String whereClause =
            '${RecommendationsHistoryTable.columnUserId} = ?';
        List<dynamic> whereArgs = [userId];

        if (assessmentType != null) {
          whereClause +=
              ' AND ${RecommendationsHistoryTable.columnAssessmentType} = ?';
          whereArgs.add(assessmentType.name);
        }

        if (subjectId != null) {
          whereClause +=
              ' AND ${RecommendationsHistoryTable.columnSubjectId} = ?';
          whereArgs.add(subjectId);
        }

        if (hasRecommendations == true) {
          whereClause +=
              ' AND ${RecommendationsHistoryTable.columnTotalRecommendations} > 0';
        }

        final maps = await queryRows(
          table: RecommendationsHistoryTable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy: '${RecommendationsHistoryTable.columnGeneratedAt} DESC',
          limit: limit,
          offset: offset,
        );

        return maps
            .map((map) => RecommendationsHistoryModel.fromMap(map).toEntity())
            .toList();
      },
    );
  }

  /// Mark recommendations as viewed
  Future<void> markAsViewed(String id) async {
    await executeWithErrorHandling(
      operationName: 'mark recommendations as viewed',
      operation: () async {
        final now = DateTime.now().millisecondsSinceEpoch;

        await rawUpdate('''
          UPDATE ${RecommendationsHistoryTable.tableName}
          SET
            ${RecommendationsHistoryTable.columnViewedAt} = ?,
            ${RecommendationsHistoryTable.columnLastAccessedAt} = ?,
            ${RecommendationsHistoryTable.columnViewCount} = ${RecommendationsHistoryTable.columnViewCount} + 1
          WHERE ${RecommendationsHistoryTable.columnId} = ?
        ''', [now, now, id]);

        logger.info('Marked recommendations as viewed: $id');
      },
    );
  }

  /// Update learning path status
  Future<void> updateLearningPathStatus({
    required String id,
    String? learningPathId,
    bool? started,
    bool? completed,
  }) async {
    await executeWithErrorHandling(
      operationName: 'update learning path status',
      operation: () async {
        final updates = <String, dynamic>{};

        if (learningPathId != null) {
          updates[RecommendationsHistoryTable.columnLearningPathId] =
              learningPathId;
        }

        if (started == true) {
          updates[RecommendationsHistoryTable.columnLearningPathStarted] = 1;
          updates[RecommendationsHistoryTable.columnLearningPathStartedAt] =
              DateTime.now().millisecondsSinceEpoch;
        }

        if (completed == true) {
          updates[RecommendationsHistoryTable.columnLearningPathCompleted] = 1;
          updates[RecommendationsHistoryTable.columnLearningPathCompletedAt] =
              DateTime.now().millisecondsSinceEpoch;
        }

        if (updates.isNotEmpty) {
          await updateRows(
            table: RecommendationsHistoryTable.tableName,
            values: updates,
            where: '${RecommendationsHistoryTable.columnId} = ?',
            whereArgs: [id],
          );

          logger.info('Updated learning path status for recommendations: $id');
        }
      },
    );
  }

  /// Track video view
  Future<void> trackVideoViewed(String id, String videoId) async {
    await executeWithErrorHandling(
      operationName: 'track video viewed',
      operation: () async {
        final history = await getById(id);
        if (history == null) return;

        final viewedVideos = [...history.viewedVideoIds];
        if (!viewedVideos.contains(videoId)) {
          viewedVideos.add(videoId);
        }

        await updateRows(
          table: RecommendationsHistoryTable.tableName,
          values: {
            RecommendationsHistoryTable.columnViewedVideoIds:
                jsonEncode(viewedVideos),
            RecommendationsHistoryTable.columnLastAccessedAt:
                DateTime.now().millisecondsSinceEpoch,
          },
          where: '${RecommendationsHistoryTable.columnId} = ?',
          whereArgs: [id],
        );

        logger.info('Tracked video viewed: $videoId for recommendations: $id');
      },
    );
  }

  /// Dismiss recommendation
  Future<void> dismissRecommendation(String id, String conceptId) async {
    await executeWithErrorHandling(
      operationName: 'dismiss recommendation',
      operation: () async {
        final history = await getById(id);
        if (history == null) return;

        final dismissed = [...history.dismissedRecommendationIds];
        if (!dismissed.contains(conceptId)) {
          dismissed.add(conceptId);
        }

        await updateRows(
          table: RecommendationsHistoryTable.tableName,
          values: {
            RecommendationsHistoryTable.columnDismissedRecommendationIds:
                jsonEncode(dismissed),
          },
          where: '${RecommendationsHistoryTable.columnId} = ?',
          whereArgs: [id],
        );

        logger.info('Dismissed recommendation: $conceptId for history: $id');
      },
    );
  }

  /// Delete old recommendations (cleanup)
  Future<int> deleteOlderThan({int daysOld = 90}) async {
    return await executeWithErrorHandling(
      operationName: 'delete old recommendations',
      operation: () async {
        final cutoffDate = DateTime.now()
            .subtract(Duration(days: daysOld))
            .millisecondsSinceEpoch;

        final count = await deleteRows(
          table: RecommendationsHistoryTable.tableName,
          where: '${RecommendationsHistoryTable.columnGeneratedAt} < ?',
          whereArgs: [cutoffDate],
        );

        logger.info(
            'Deleted $count old recommendations (older than $daysOld days)');
        return count;
      },
    );
  }
}
