/// Chapter Summary repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/cache_manager.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/chapter_summary_dao.dart';
import 'package:streamshaala/data/models/study_tools/chapter_summary_model.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_summary.dart';
import 'package:streamshaala/domain/repositories/study_tools/chapter_summary_repository.dart';

/// Implementation of ChapterSummaryRepository using JSON-first loading with database caching
class ChapterSummaryRepositoryImpl implements ChapterSummaryRepository {
  final ChapterSummaryDao _summaryDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  ChapterSummaryRepositoryImpl(this._summaryDao, this._jsonDataSource);

  @override
  Future<Either<Failure, ChapterSummary?>> getSummary(
    String chapterId,
    String subjectId,
    String segment, {
    bool forceRefresh = false,
  }) async {
    try {
      logger.info('Getting chapter summary for chapter: $chapterId');

      final cacheKey = CacheManager.summaryKey(chapterId, segment);

      // 1. Check database cache first (if not force refresh)
      if (!forceRefresh) {
        final isExpired = await CacheManager.isCacheExpired(cacheKey);
        final cached = await _summaryDao.getSummary(chapterId, subjectId, segment);

        if (cached != null && !isExpired) {
          logger.debug('Chapter summary found in valid cache');
          return Right(cached.toEntity());
        }

        // Cache exists but expired - delete and reload
        if (cached != null && isExpired) {
          logger.info('Cache expired, refreshing chapter summary');
          await _summaryDao.deleteByChapterId(chapterId);
        }
      } else {
        // Force refresh - clear existing cache
        logger.info('Force refresh requested, clearing cache');
        await _summaryDao.deleteByChapterId(chapterId);
        await CacheManager.invalidateCache(cacheKey);
      }

      // 2. Load from JSON
      final jsonModel = await _jsonDataSource.loadChapterSummary(
        subjectId: subjectId,
        chapterId: chapterId,
        segment: segment,
      );

      if (jsonModel != null) {
        // Cache to database
        await _summaryDao.insert(jsonModel);
        await CacheManager.markCacheUpdated(cacheKey);
        logger.info('Chapter summary loaded from JSON and cached');
        return Right(jsonModel.toEntity());
      }

      logger.info('No chapter summary found');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting chapter summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get chapter summary',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting chapter summary', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ChapterSummary>>> getSubjectSummaries(
    String subjectId,
    String segment,
  ) async {
    try {
      logger.info('Getting chapter summaries for subject: $subjectId');

      final cached = await _summaryDao.getBySubjectId(subjectId, segment);
      final summaries = cached.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${summaries.length} chapter summaries');
      return Right(summaries);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting chapter summaries', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get chapter summaries',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting chapter summaries', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasSummary(
    String chapterId,
    String subjectId,
    String segment,
  ) async {
    try {
      logger.debug('Checking if chapter has summary: $chapterId');

      // First try to get the summary (this will load from JSON if needed)
      final result = await getSummary(chapterId, subjectId, segment);
      return result.fold(
        (failure) => Left(failure),
        (summary) => Right(summary != null),
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error checking summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to check summary',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error checking summary', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ChapterSummary>> saveSummary(
    ChapterSummary summary,
  ) async {
    try {
      logger.info('Saving chapter summary: ${summary.id}');

      final model = ChapterSummaryModel.fromEntity(summary);
      await _summaryDao.insert(model);

      logger.info('Summary saved successfully');
      return Right(summary);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save chapter summary',
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
  Future<Either<Failure, void>> deleteSummary(String chapterId) async {
    try {
      logger.info('Deleting chapter summary for chapter: $chapterId');

      await _summaryDao.deleteByChapterId(chapterId);

      logger.info('Summary deleted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting summary', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete chapter summary',
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
