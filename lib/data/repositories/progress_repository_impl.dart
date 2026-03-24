/// Progress repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/dao/progress_dao.dart';
import 'package:streamshaala/data/models/user/progress_model.dart';
import 'package:streamshaala/domain/entities/user/progress.dart';
import 'package:streamshaala/domain/entities/subject_progress.dart';
import 'package:streamshaala/domain/entities/chapter_progress.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';
import 'package:streamshaala/domain/repositories/progress_repository.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';

/// Implementation of ProgressRepository using local database
class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDao _progressDao;
  final ContentRepository _contentRepository;

  /// Optional profile ID for multi-profile support
  /// When set, all operations are scoped to this profile
  String? profileId;

  ProgressRepositoryImpl(this._progressDao, this._contentRepository, {this.profileId});

  @override
  Future<Either<Failure, Progress>> saveProgress(Progress progress) async {
    try {
      logger.info('Saving progress for video: ${progress.videoId}${profileId != null ? ' (profile: $profileId)' : ''}');

      final model = ProgressModel(
        id: profileId != null ? '${progress.videoId}_$profileId' : progress.id,
        videoId: progress.videoId,
        profileId: profileId ?? '',
        title: progress.title,
        channelName: progress.channelName,
        thumbnailUrl: progress.thumbnailUrl,
        watchDuration: progress.watchDuration,
        totalDuration: progress.totalDuration,
        completed: progress.completed,
        lastWatched: progress.lastWatched.millisecondsSinceEpoch,
      );
      await _progressDao.insert(model);

      logger.info('Progress saved successfully');
      return Right(progress);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Progress?>> getProgressByVideoId(String videoId) async {
    try {
      logger.debug('Getting progress by video ID: $videoId${profileId != null ? ' (profile: $profileId)' : ''}');

      final model = await _progressDao.getByVideoId(videoId, profileId: profileId);
      final progress = model?.toEntity();

      return Right(progress);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Progress>>> getInProgressVideos() async {
    try {
      logger.info('Getting in-progress videos${profileId != null ? ' (profile: $profileId)' : ''}');

      final models = await _progressDao.getInProgress(profileId: profileId);
      final progressList = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${progressList.length} in-progress videos');
      return Right(progressList);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting in-progress videos', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get in-progress videos',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting in-progress videos', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Progress>>> getCompletedVideos() async {
    try {
      logger.info('Getting completed videos${profileId != null ? ' (profile: $profileId)' : ''}');

      final models = await _progressDao.getCompleted(profileId: profileId);
      final progressList = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${progressList.length} completed videos');
      return Right(progressList);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting completed videos', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get completed videos',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting completed videos', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Progress>>> getWatchHistory({int? limit}) async {
    try {
      logger.info('Getting watch history${limit != null ? ' (limit: $limit)' : ''}${profileId != null ? ' (profile: $profileId)' : ''}');

      final models = limit != null
          ? await _progressDao.getRecent(limit, profileId: profileId)
          : await _progressDao.getAll(profileId: profileId);
      final progressList = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${progressList.length} watch history records');
      return Right(progressList);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting watch history', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get watch history',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting watch history', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Progress>>> getRecentlyWatched() async {
    try {
      logger.info('Getting recently watched videos${profileId != null ? ' (profile: $profileId)' : ''}');

      final models = await _progressDao.getRecentlyWatched(profileId: profileId);
      final progressList = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${progressList.length} recently watched videos');
      return Right(progressList);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting recently watched videos', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get recently watched videos',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting recently watched videos', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Progress>> markAsCompleted(String videoId) async {
    try {
      logger.info('Marking video as completed: $videoId${profileId != null ? ' (profile: $profileId)' : ''}');

      // Get existing progress
      final model = await _progressDao.getByVideoId(videoId, profileId: profileId);

      if (model == null) {
        logger.warning('Progress not found for video: $videoId');
        return Left(NotFoundFailure(
          message: 'Progress not found',
          entityType: 'Progress',
          entityId: videoId,
        ));
      }

      // Update completed flag
      final updatedModel = ProgressModel(
        id: model.id,
        videoId: model.videoId,
        profileId: model.profileId,
        watchDuration: model.watchDuration,
        totalDuration: model.totalDuration,
        completed: true,
        lastWatched: DateTime.now().millisecondsSinceEpoch,
      );

      // Save updated progress
      await _progressDao.update(updatedModel);

      logger.info('Video marked as completed successfully');
      return Right(updatedModel.toEntity());
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Progress not found', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Progress not found',
        entityType: 'Progress',
        entityId: videoId,
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error marking video as completed', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to mark video as completed',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error marking video as completed', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProgress(String videoId) async {
    try {
      logger.info('Deleting progress for video: $videoId${profileId != null ? ' (profile: $profileId)' : ''}');

      await _progressDao.delete(videoId, profileId: profileId);

      logger.info('Progress deleted successfully');
      return const Right(null);
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Progress not found', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Progress not found',
        entityType: 'Progress',
        entityId: videoId,
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalWatchTime() async {
    try {
      logger.debug('Getting total watch time${profileId != null ? ' (profile: $profileId)' : ''}');

      final totalSeconds = await _progressDao.getTotalWatchTime(profileId: profileId);

      return Right(totalSeconds);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting total watch time', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get total watch time',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting total watch time', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ProgressStats>> getStatistics() async {
    try {
      logger.debug('Getting progress statistics${profileId != null ? ' (profile: $profileId)' : ''}');

      final data = await _progressDao.getStatistics(profileId: profileId);

      final stats = ProgressStats(
        totalVideosWatched: data['totalVideosWatched'] as int,
        completedVideos: data['completedVideos'] as int,
        inProgressVideos: data['inProgressVideos'] as int,
        totalWatchTimeSeconds: data['totalWatchTimeSeconds'] as int,
        averageCompletionRate: data['avgCompletionRate'] as double,
      );

      logger.debug('Retrieved statistics: ${stats.totalVideosWatched} total videos');
      return Right(stats);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting statistics', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get statistics',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting statistics', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllProgress() async {
    try {
      logger.warning('Clearing all progress');

      await _progressDao.deleteAll();

      logger.info('All progress cleared successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error clearing progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to clear progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error clearing progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<SubjectProgress>>> getSubjectProgress() async {
    try {
      logger.info('Getting subject progress');

      // Get all subjects from the content repository
      // Note: This method returns empty because we don't have a way to get all subjects
      // without board/class/stream context. Use the provider which gets subjects from
      // the current user's context instead.
      logger.warning('getSubjectProgress() requires subject context. Use getSubjectProgressById() instead.');
      return const Right([]);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting subject progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get subject progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting subject progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, SubjectProgress?>> getSubjectProgressById(String subjectId) async {
    try {
      logger.info('Getting subject progress for: $subjectId');

      // Get the subject from content repository
      final subjectResult = await _contentRepository.getSubjectById(subjectId);

      return subjectResult.fold(
        (failure) => Left(failure),
        (subject) async {
          // Calculate progress for this subject
          final progressData = await _calculateSubjectProgress(subject);
          return Right(progressData);
        },
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting subject progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get subject progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting subject progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ChapterProgress>>> getChapterProgressBySubject(String subjectId) async {
    try {
      logger.info('Getting chapter progress for subject: $subjectId');

      // Get chapters for the subject
      final chaptersResult = await _contentRepository.getChapters(subjectId);

      return chaptersResult.fold(
        (failure) => Left(failure),
        (chapters) async {
          final chapterProgressList = <ChapterProgress>[];

          for (final chapter in chapters) {
            final progress = await _calculateChapterProgress(subjectId, chapter);
            chapterProgressList.add(progress);
          }

          logger.info('Calculated progress for ${chapterProgressList.length} chapters');
          return Right(chapterProgressList);
        },
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting chapter progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get chapter progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting chapter progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ChapterProgress?>> getChapterProgressById(
    String subjectId,
    String chapterId,
  ) async {
    try {
      logger.info('Getting chapter progress for: $chapterId');

      // Get the chapter from content repository
      final chapterResult = await _contentRepository.getChapterById(
        subjectId: subjectId,
        chapterId: chapterId,
      );

      return chapterResult.fold(
        (failure) => Left(failure),
        (chapter) async {
          final progress = await _calculateChapterProgress(subjectId, chapter);
          return Right(progress);
        },
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting chapter progress', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get chapter progress',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting chapter progress', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Helper method to calculate progress for a subject
  Future<SubjectProgress> _calculateSubjectProgress(dynamic subject) async {
    final chapters = subject.chapters as List;
    int totalVideos = 0;
    int completedVideos = 0;
    int inProgressVideos = 0;
    int totalWatchTime = 0;
    int completedChapters = 0;

    for (final chapter in chapters) {
      final chapterProgress = await _calculateChapterProgress(subject.id, chapter);

      totalVideos += chapterProgress.totalVideos;
      completedVideos += chapterProgress.completedVideos;
      inProgressVideos += chapterProgress.inProgressVideos;
      totalWatchTime += chapterProgress.totalWatchTimeSeconds;

      if (chapterProgress.isCompleted) {
        completedChapters++;
      }
    }

    return SubjectProgress(
      subjectId: subject.id,
      subjectName: subject.name,
      description: null,
      boardId: subject.boardId,
      totalVideos: totalVideos,
      completedVideos: completedVideos,
      inProgressVideos: inProgressVideos,
      totalChapters: chapters.length,
      completedChapters: completedChapters,
      totalWatchTimeSeconds: totalWatchTime,
    );
  }

  /// Helper method to calculate progress for a chapter
  Future<ChapterProgress> _calculateChapterProgress(String subjectId, dynamic chapter) async {
    // Get expected total videos from chapter metadata (sum of topic videoCount)
    // This is more reliable than counting loaded video files
    final int expectedTotalVideos = _getChapterTotalVideoCount(chapter);

    // Get all videos for this chapter to check progress
    final videosResult = await _contentRepository.getVideos(
      subjectId: subjectId,
      chapterId: chapter.id,
    );

    return videosResult.fold(
      (failure) {
        logger.warning('Failed to get videos for chapter ${chapter.id}: ${failure.message}');
        // Even if video files don't exist, use the expected count from metadata
        return ChapterProgress(
          chapterId: chapter.id,
          chapterName: chapter.name,
          description: chapter.description,
          totalVideos: expectedTotalVideos,
          completedVideos: 0,
          inProgressVideos: 0,
        );
      },
      (videos) async {
        int completed = 0;
        int inProgress = 0;
        int totalWatchTime = 0;
        DateTime? lastWatched;

        for (final video in videos) {
          final progressModel = await _progressDao.getByVideoId(video.id, profileId: profileId);

          if (progressModel != null) {
            totalWatchTime += progressModel.watchDuration;

            final watchedDate = DateTime.fromMillisecondsSinceEpoch(progressModel.lastWatched);
            if (lastWatched == null || watchedDate.isAfter(lastWatched)) {
              lastWatched = watchedDate;
            }

            if (progressModel.completed) {
              completed++;
            } else {
              inProgress++;
            }
          }
        }

        // Use the higher of expected count or actual count
        // (actual might be higher if videos were added after metadata was written)
        final totalVideos = videos.length > expectedTotalVideos ? videos.length : expectedTotalVideos;

        return ChapterProgress(
          chapterId: chapter.id,
          chapterName: chapter.name,
          description: chapter.description,
          totalVideos: totalVideos,
          completedVideos: completed,
          inProgressVideos: inProgress,
          totalWatchTimeSeconds: totalWatchTime,
          lastWatchedAt: lastWatched,
        );
      },
    );
  }

  /// Get total video count from chapter topics metadata
  int _getChapterTotalVideoCount(dynamic chapter) {
    try {
      // Try to access topics if available
      if (chapter.topics != null) {
        final topics = chapter.topics as List;
        int total = 0;
        for (final topic in topics) {
          if (topic.videoCount != null) {
            total += topic.videoCount as int;
          }
        }
        return total;
      }
      // Fallback: try totalVideoCount getter if it's a Chapter entity
      if (chapter is Chapter) {
        return chapter.totalVideoCount;
      }
    } catch (e) {
      logger.warning('Could not get video count from chapter metadata: $e');
    }
    return 0;
  }
}
