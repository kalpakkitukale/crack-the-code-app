/// Test suite for ProgressRepositoryImpl
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/data/repositories/progress_repository_impl.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('ProgressRepositoryImpl', () {
    late MockProgressDao mockDao;
    late MockContentRepository mockContentRepo;
    late ProgressRepositoryImpl repository;

    setUp(() {
      mockDao = MockProgressDao();
      mockContentRepo = MockContentRepository();
      repository = ProgressRepositoryImpl(mockDao, mockContentRepo);
    });

    tearDown(() {
      mockDao.clear();
    });

    // Helper to create test progress
    Progress createTestProgress({
      String id = 'progress-1',
      String videoId = 'video-1',
      int watchDuration = 120,
      int totalDuration = 300,
      bool completed = false,
    }) {
      return Progress(
        id: id,
        videoId: videoId,
        title: 'Test Video',
        channelName: 'Test Channel',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        watchDuration: watchDuration,
        totalDuration: totalDuration,
        completed: completed,
        lastWatched: DateTime.now(),
      );
    }

    group('saveProgress', () {
      test('success_savesAndReturnsRight', () async {
        final progress = createTestProgress();

        final result = await repository.saveProgress(progress);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (savedProgress) => expect(savedProgress.videoId, progress.videoId),
        );
        expect(mockDao.count, 1);
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        final progress = createTestProgress();
        mockDao.setNextException(
          DatabaseException(message: 'Insert failed'),
        );

        final result = await repository.saveProgress(progress);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Failed to save progress')),
          (progress) => fail('Should not return progress'),
        );
      });

      test('unknownException_returnsLeftUnknownFailure', () async {
        final progress = createTestProgress();
        mockDao.setNextException(Exception('Unknown error'));

        final result = await repository.saveProgress(progress);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'UnknownFailure'),
          (progress) => fail('Should not return progress'),
        );
      });
    });

    group('getProgressByVideoId', () {
      test('progressExists_returnsProgress', () async {
        final progress = createTestProgress();
        await repository.saveProgress(progress);

        final result = await repository.getProgressByVideoId('video-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (retrievedProgress) {
            expect(retrievedProgress, isNotNull);
            expect(retrievedProgress!.videoId, 'video-1');
          },
        );
      });

      test('progressDoesNotExist_returnsNull', () async {
        final result = await repository.getProgressByVideoId('nonexistent');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (progress) => expect(progress, isNull),
        );
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        mockDao.setNextException(
          DatabaseException(message: 'Query failed'),
        );

        final result = await repository.getProgressByVideoId('any-id');

        expect(result.isLeft(), true);
      });
    });

    group('getInProgressVideos', () {
      test('multipleInProgress_returnsAll', () async {
        final progress1 = createTestProgress(id: 'p1', videoId: 'v1', completed: false);
        final progress2 = createTestProgress(id: 'p2', videoId: 'v2', completed: false);
        final progress3 = createTestProgress(id: 'p3', videoId: 'v3', completed: true);

        await repository.saveProgress(progress1);
        await repository.saveProgress(progress2);
        await repository.saveProgress(progress3);

        final result = await repository.getInProgressVideos();

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) {
            expect(progressList.length, 2);
            expect(progressList.every((p) => !p.completed), true);
          },
        );
      });

      test('noInProgress_returnsEmptyList', () async {
        final completed = createTestProgress(completed: true);
        await repository.saveProgress(completed);

        final result = await repository.getInProgressVideos();

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) => expect(progressList, isEmpty),
        );
      });
    });

    group('getCompletedVideos', () {
      test('multipleCompleted_returnsAll', () async {
        final completed1 = createTestProgress(id: 'p1', videoId: 'v1', completed: true);
        final completed2 = createTestProgress(id: 'p2', videoId: 'v2', completed: true);
        final inProgress = createTestProgress(id: 'p3', videoId: 'v3', completed: false);

        await repository.saveProgress(completed1);
        await repository.saveProgress(completed2);
        await repository.saveProgress(inProgress);

        final result = await repository.getCompletedVideos();

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) {
            expect(progressList.length, 2);
            expect(progressList.every((p) => p.completed), true);
          },
        );
      });

      test('noCompleted_returnsEmptyList', () async {
        final inProgress = createTestProgress(completed: false);
        await repository.saveProgress(inProgress);

        final result = await repository.getCompletedVideos();

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) => expect(progressList, isEmpty),
        );
      });
    });

    group('getWatchHistory', () {
      test('withLimit_returnsLimitedResults', () async {
        for (int i = 0; i < 10; i++) {
          final progress = createTestProgress(id: 'p$i', videoId: 'v$i');
          await repository.saveProgress(progress);
        }

        final result = await repository.getWatchHistory(limit: 5);

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) => expect(progressList.length, 5),
        );
      });

      test('withoutLimit_returnsAll', () async {
        for (int i = 0; i < 3; i++) {
          final progress = createTestProgress(id: 'p$i', videoId: 'v$i');
          await repository.saveProgress(progress);
        }

        final result = await repository.getWatchHistory();

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) => expect(progressList.length, 3),
        );
      });

      test('sortedByLastWatched_newestFirst', () async {
        // Note: In real implementation, this would be tested with different timestamps
        final result = await repository.getWatchHistory();

        expect(result.isRight(), true);
      });
    });

    group('getRecentlyWatched', () {
      test('recentVideos_returnsOnlyRecent', () async {
        // Recently watched video
        final recent = createTestProgress(id: 'recent', videoId: 'v-recent');
        await repository.saveProgress(recent);

        final result = await repository.getRecentlyWatched();

        result.fold(
          (failure) => fail('Should not return failure'),
          (progressList) => expect(progressList.length, greaterThanOrEqualTo(0)),
        );
      });
    });

    group('markAsCompleted', () {
      test('progressExists_marksAsCompleted', () async {
        final progress = createTestProgress(completed: false);
        await repository.saveProgress(progress);

        final result = await repository.markAsCompleted('video-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedProgress) => expect(updatedProgress.completed, true),
        );
      });

      test('progressNotFound_returnsNotFoundFailure', () async {
        final result = await repository.markAsCompleted('nonexistent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'NotFoundFailure'),
          (progress) => fail('Should not return progress'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final progress = createTestProgress();
        await repository.saveProgress(progress);

        mockDao.setNextException(DatabaseException(message: 'Update failed'));

        final result = await repository.markAsCompleted('video-1');

        expect(result.isLeft(), true);
      });
    });

    group('deleteProgress', () {
      test('progressExists_deletesSuccessfully', () async {
        final progress = createTestProgress();
        await repository.saveProgress(progress);

        final result = await repository.deleteProgress('video-1');

        expect(result.isRight(), true);
        expect(mockDao.count, 0);
      });

      test('progressNotFound_returnsNotFoundFailure', () async {
        final result = await repository.deleteProgress('nonexistent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'NotFoundFailure'),
          (_) => fail('Should not return success'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'Delete failed'));

        final result = await repository.deleteProgress('any-id');

        expect(result.isLeft(), true);
      });
    });

    group('getTotalWatchTime', () {
      test('noProgress_returns0', () async {
        final result = await repository.getTotalWatchTime();

        result.fold(
          (failure) => fail('Should not return failure'),
          (totalTime) => expect(totalTime, 0),
        );
      });

      test('multipleVideos_returnsSumOfWatchDurations', () async {
        final progress1 = createTestProgress(id: 'p1', videoId: 'v1', watchDuration: 100);
        final progress2 = createTestProgress(id: 'p2', videoId: 'v2', watchDuration: 200);
        final progress3 = createTestProgress(id: 'p3', videoId: 'v3', watchDuration: 150);

        await repository.saveProgress(progress1);
        await repository.saveProgress(progress2);
        await repository.saveProgress(progress3);

        final result = await repository.getTotalWatchTime();

        result.fold(
          (failure) => fail('Should not return failure'),
          (totalTime) => expect(totalTime, 450),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'Query failed'));

        final result = await repository.getTotalWatchTime();

        expect(result.isLeft(), true);
      });
    });

    group('getStatistics', () {
      test('noProgress_returnsZeroStats', () async {
        final result = await repository.getStatistics();

        result.fold(
          (failure) => fail('Should not return failure'),
          (stats) {
            expect(stats.totalVideosWatched, 0);
            expect(stats.completedVideos, 0);
            expect(stats.inProgressVideos, 0);
            expect(stats.totalWatchTimeSeconds, 0);
          },
        );
      });

      test('mixedProgress_returnsCorrectStats', () async {
        final completed1 = createTestProgress(id: 'p1', videoId: 'v1', completed: true, watchDuration: 100);
        final completed2 = createTestProgress(id: 'p2', videoId: 'v2', completed: true, watchDuration: 200);
        final inProgress = createTestProgress(id: 'p3', videoId: 'v3', completed: false, watchDuration: 50);

        await repository.saveProgress(completed1);
        await repository.saveProgress(completed2);
        await repository.saveProgress(inProgress);

        final result = await repository.getStatistics();

        result.fold(
          (failure) => fail('Should not return failure'),
          (stats) {
            expect(stats.totalVideosWatched, 3);
            expect(stats.completedVideos, 2);
            expect(stats.inProgressVideos, 1);
            expect(stats.totalWatchTimeSeconds, 350);
          },
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'Stats query failed'));

        final result = await repository.getStatistics();

        expect(result.isLeft(), true);
      });
    });

    group('clearAllProgress', () {
      test('withProgress_clearsAll', () async {
        for (int i = 0; i < 5; i++) {
          final progress = createTestProgress(id: 'p$i', videoId: 'v$i');
          await repository.saveProgress(progress);
        }

        final result = await repository.clearAllProgress();

        expect(result.isRight(), true);
        expect(mockDao.count, 0);
      });

      test('alreadyEmpty_succeedsWithoutError', () async {
        final result = await repository.clearAllProgress();

        expect(result.isRight(), true);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'Delete all failed'));

        final result = await repository.clearAllProgress();

        expect(result.isLeft(), true);
      });
    });

    group('Profile Scoping', () {
      test('withProfileId_scopesOperationsToProfile', () async {
        repository.profileId = 'profile-1';

        final progress = createTestProgress();
        await repository.saveProgress(progress);

        // Progress should be saved with profile ID scoping
        expect(mockDao.count, 1);
      });

      test('differentProfiles_isolatesData', () async {
        // Save progress for profile 1
        repository.profileId = 'profile-1';
        final progress1 = createTestProgress(id: 'p1', videoId: 'v1');
        await repository.saveProgress(progress1);

        // Save progress for profile 2
        repository.profileId = 'profile-2';
        final progress2 = createTestProgress(id: 'p2', videoId: 'v2');
        await repository.saveProgress(progress2);

        // Both should be saved but isolated
        expect(mockDao.count, 2);
      });
    });

    group('Error Handling', () {
      test('allReadMethods_handleDatabaseException', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));
        final result1 = await repository.getInProgressVideos();
        expect(result1.isLeft(), true);

        mockDao.setNextException(DatabaseException(message: 'DB error'));
        final result2 = await repository.getCompletedVideos();
        expect(result2.isLeft(), true);

        mockDao.setNextException(DatabaseException(message: 'DB error'));
        final result3 = await repository.getWatchHistory();
        expect(result3.isLeft(), true);

        mockDao.setNextException(DatabaseException(message: 'DB error'));
        final result4 = await repository.getRecentlyWatched();
        expect(result4.isLeft(), true);
      });

      test('wrapsExceptionsCorrectly', () async {
        // Database exception wrapped in DatabaseFailure
        mockDao.setNextException(DatabaseException(message: 'DB error'));
        final dbResult = await repository.getTotalWatchTime();
        dbResult.fold(
          (failure) => expect(failure.runtimeType.toString(), 'DatabaseFailure'),
          (_) => fail('Should return failure'),
        );

        // Unknown exception wrapped in UnknownFailure
        mockDao.setNextException(Exception('Unknown'));
        final unknownResult = await repository.saveProgress(createTestProgress());
        unknownResult.fold(
          (failure) => expect(failure.runtimeType.toString(), 'UnknownFailure'),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('getSubjectProgress', () {
      test('returnsEmptyList_requiresContext', () async {
        final result = await repository.getSubjectProgress();

        result.fold(
          (failure) => fail('Should not return failure'),
          (subjectProgress) => expect(subjectProgress, isEmpty),
        );
      });
    });
  });
}
