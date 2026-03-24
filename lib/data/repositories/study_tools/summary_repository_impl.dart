/// Summary repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/video_summary_dao.dart';
import 'package:streamshaala/data/models/study_tools/video_summary_model.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart';
import 'package:streamshaala/domain/repositories/study_tools/summary_repository.dart';

/// Implementation of SummaryRepository using JSON-first loading with database caching
class SummaryRepositoryImpl implements SummaryRepository {
  final VideoSummaryDao _summaryDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  /// Subject and chapter IDs for JSON lookup (set by provider)
  String? subjectId;
  String? chapterId;

  SummaryRepositoryImpl(this._summaryDao, this._jsonDataSource);

  @override
  Future<Either<Failure, VideoSummary?>> getSummary(
    String videoId,
    String segment,
  ) async {
    try {
      logger.info('Getting summary for video: $videoId, segment: $segment');

      // 1. Check database cache first
      final cached = await _summaryDao.getByVideoId(videoId, segment);
      if (cached != null) {
        logger.debug('Summary found in database cache');
        return Right(cached.toEntity());
      }

      // 2. Load from JSON if subject/chapter IDs are set
      if (subjectId != null && chapterId != null) {
        // Ensure JSON data is loaded
        await _jsonDataSource.loadSummaries(
          subjectId: subjectId!,
          chapterId: chapterId!,
        );

        // Get from JSON cache
        final jsonModel = _jsonDataSource.getSummaryByVideoId(
          subjectId: subjectId!,
          chapterId: chapterId!,
          videoId: videoId,
        );

        if (jsonModel != null) {
          // Cache to database
          await _summaryDao.insert(jsonModel);
          logger.info('Summary loaded from JSON and cached to database');
          return Right(jsonModel.toEntity());
        }
      }

      // Not found
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get summary',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting summary', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, VideoSummary>> saveSummary(VideoSummary summary) async {
    try {
      logger.info('Saving summary for video: ${summary.videoId}');

      final model = VideoSummaryModel.fromEntity(summary);
      await _summaryDao.insert(model);

      logger.info('Summary saved successfully');
      return Right(summary);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save summary',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving summary', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSummary(String videoId) async {
    try {
      logger.info('Deleting summary for video: $videoId');

      await _summaryDao.deleteByVideoId(videoId);

      logger.info('Summary deleted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete summary',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting summary', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
