/// Data Access Object for Video Q&A operations
///
/// Refactored to use BaseDao for platform-abstracted database operations.
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/models/study_tools/video_question_model.dart';

/// DAO for video Q&A table operations
///
/// Uses BaseDao for platform-abstracted database operations,
/// eliminating repeated platform checks.
class VideoQADao extends BaseDao {
  VideoQADao(super.dbHelper);

  /// Insert a question
  Future<void> insert(VideoQuestionModel question) async {
    await executeWithErrorHandling(
      operationName: 'insert video question',
      operation: () async {
        await insertRow(
          table: VideoQATable.tableName,
          values: question.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        logger.debug('Video question inserted: ${question.id}');
      },
    );
  }

  /// Update a question (e.g., answer it)
  Future<void> update(VideoQuestionModel question) async {
    await executeWithErrorHandling(
      operationName: 'update video question',
      operation: () async {
        final count = await updateRows(
          table: VideoQATable.tableName,
          values: question.toMap(),
          where: '${VideoQATable.columnId} = ?',
          whereArgs: [question.id],
        );

        if (count == 0) {
          throw NotFoundException(
            message: 'Question not found',
            entityType: 'VideoQuestion',
            entityId: question.id,
          );
        }

        logger.debug('Video question updated: ${question.id}');
      },
    );
  }

  /// Get all questions for a video
  Future<List<VideoQuestionModel>> getByVideoId(String videoId,
      {String? profileId}) async {
    return await executeWithErrorHandling(
      operationName: 'get video questions',
      operation: () async {
        final String whereClause;
        final List<dynamic> whereArgs;

        if (profileId != null) {
          whereClause =
              '${VideoQATable.columnVideoId} = ? AND ${VideoQATable.columnProfileId} = ?';
          whereArgs = [videoId, profileId];
        } else {
          whereClause = '${VideoQATable.columnVideoId} = ?';
          whereArgs = [videoId];
        }

        final maps = await queryRows(
          table: VideoQATable.tableName,
          where: whereClause,
          whereArgs: whereArgs,
          orderBy:
              '${VideoQATable.columnUpvotes} DESC, ${VideoQATable.columnCreatedAt} DESC',
        );

        logger.debug('Retrieved ${maps.length} questions for video: $videoId');
        return maps.map((map) => VideoQuestionModel.fromMap(map)).toList();
      },
    );
  }

  /// Get questions by status
  Future<List<VideoQuestionModel>> getByStatus(
      String videoId, String status) async {
    return await executeWithErrorHandling(
      operationName: 'get questions by status',
      operation: () async {
        final maps = await queryRows(
          table: VideoQATable.tableName,
          where:
              '${VideoQATable.columnVideoId} = ? AND ${VideoQATable.columnStatus} = ?',
          whereArgs: [videoId, status],
          orderBy: '${VideoQATable.columnCreatedAt} DESC',
        );

        return maps.map((map) => VideoQuestionModel.fromMap(map)).toList();
      },
    );
  }

  /// Upvote a question
  Future<void> upvote(String questionId) async {
    await executeWithErrorHandling(
      operationName: 'upvote question',
      operation: () async {
        final updateQuery =
            'UPDATE ${VideoQATable.tableName} SET ${VideoQATable.columnUpvotes} = ${VideoQATable.columnUpvotes} + 1 WHERE ${VideoQATable.columnId} = ?';
        await rawQuery(updateQuery, [questionId]);
        logger.debug('Question upvoted: $questionId');
      },
    );
  }

  /// Delete a question by ID
  Future<void> delete(String questionId) async {
    await executeWithErrorHandling(
      operationName: 'delete question',
      operation: () async {
        await deleteRows(
          table: VideoQATable.tableName,
          where: '${VideoQATable.columnId} = ?',
          whereArgs: [questionId],
        );
        logger.debug('Question deleted: $questionId');
      },
    );
  }

  /// Delete all questions for a video
  Future<void> deleteByVideoId(String videoId) async {
    await executeWithErrorHandling(
      operationName: 'delete questions for video',
      operation: () async {
        await deleteRows(
          table: VideoQATable.tableName,
          where: '${VideoQATable.columnVideoId} = ?',
          whereArgs: [videoId],
        );
        logger.debug('Questions deleted for video: $videoId');
      },
    );
  }

  /// Get question count for a video
  Future<int> getCountByVideoId(String videoId) async {
    return await executeWithErrorHandling(
      operationName: 'get question count',
      operation: () async {
        final query =
            'SELECT COUNT(*) FROM ${VideoQATable.tableName} WHERE ${VideoQATable.columnVideoId} = ?';
        return await firstIntValue(query, [videoId]) ?? 0;
      },
    );
  }

  /// Delete all questions for a profile
  Future<void> deleteAllForProfile(String profileId) async {
    await executeWithErrorHandling(
      operationName: 'delete questions for profile',
      operation: () async {
        await deleteRows(
          table: VideoQATable.tableName,
          where: '${VideoQATable.columnProfileId} = ?',
          whereArgs: [profileId],
        );
        logger.debug('All questions deleted for profile: $profileId');
      },
    );
  }
}
