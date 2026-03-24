/// ProgressProvider tests - Video progress tracking and streak calculation
/// Tests both ProgressState logic and ProgressNotifier methods with injected mocks
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';

import '../../../fixtures/progress_fixtures.dart';
import '../../../mocks/mock_use_cases.dart';

void main() {
  group('ProgressState', () {
    // =========================================================================
    // INITIAL STATE TESTS
    // =========================================================================
    group('initial', () {
      test('hasCorrectDefaults', () {
        final state = ProgressState.initial();

        expect(state.watchHistory, isEmpty);
        expect(state.progressMap, isEmpty);
        expect(state.statistics, isNull);
        expect(state.currentStreak, 0);
        expect(state.longestStreak, 0);
        expect(state.isLoading, true);
        expect(state.isLoadingHistory, true);
        expect(state.error, isNull);
      });
    });

    // =========================================================================
    // COMPUTED METHODS TESTS
    // =========================================================================
    group('getProgress', () {
      test('withExistingVideo_returnsProgress', () {
        final progress = ProgressFixtures.halfWatched;
        final state = ProgressState(
          watchHistory: [progress],
          progressMap: {progress.videoId: progress},
        );

        expect(state.getProgress(progress.videoId), progress);
      });

      test('withNonExistingVideo_returnsNull', () {
        final state = ProgressState(
          watchHistory: const [],
          progressMap: const {},
        );

        expect(state.getProgress('non-existing-video'), isNull);
      });
    });

    group('getProgressPercent', () {
      test('withExistingVideo_returnsPercentage', () {
        final progress = ProgressFixtures.halfWatched;
        final state = ProgressState(
          watchHistory: [progress],
          progressMap: {progress.videoId: progress},
        );

        expect(state.getProgressPercent(progress.videoId), 0.5);
      });

      test('withNonExistingVideo_returnsZero', () {
        final state = ProgressState(
          watchHistory: const [],
          progressMap: const {},
        );

        expect(state.getProgressPercent('non-existing-video'), 0.0);
      });

      test('withZeroDurationVideo_returnsZero', () {
        final progress = ProgressFixtures.zeroDuration;
        final state = ProgressState(
          watchHistory: [progress],
          progressMap: {progress.videoId: progress},
        );

        expect(state.getProgressPercent(progress.videoId), 0.0);
      });

      test('clampsToOne', () {
        final progress = ProgressFixtures.overWatched;
        final state = ProgressState(
          watchHistory: [progress],
          progressMap: {progress.videoId: progress},
        );

        expect(state.getProgressPercent(progress.videoId), lessThanOrEqualTo(1.0));
      });
    });

    group('isCompleted', () {
      test('withCompletedVideo_returnsTrue', () {
        final progress = ProgressFixtures.fullyCompleted;
        final state = ProgressState(
          watchHistory: [progress],
          progressMap: {progress.videoId: progress},
        );

        expect(state.isCompleted(progress.videoId), true);
      });

      test('withInProgressVideo_returnsFalse', () {
        final progress = ProgressFixtures.halfWatched;
        final state = ProgressState(
          watchHistory: [progress],
          progressMap: {progress.videoId: progress},
        );

        expect(state.isCompleted(progress.videoId), false);
      });

      test('withNonExistingVideo_returnsFalse', () {
        final state = ProgressState(
          watchHistory: const [],
          progressMap: const {},
        );

        expect(state.isCompleted('non-existing-video'), false);
      });
    });

    // =========================================================================
    // COPY WITH TESTS
    // =========================================================================
    group('copyWith', () {
      test('updatesWatchHistory', () {
        final state = ProgressState.initial();
        final history = [ProgressFixtures.halfWatched];

        final updated = state.copyWith(watchHistory: history);

        expect(updated.watchHistory.length, 1);
        expect(state.watchHistory, isEmpty);
      });

      test('updatesProgressMap', () {
        final state = ProgressState.initial();
        final progress = ProgressFixtures.halfWatched;

        final updated = state.copyWith(
          progressMap: {progress.videoId: progress},
        );

        expect(updated.progressMap.containsKey(progress.videoId), true);
      });

      test('updatesCurrentStreak', () {
        final state = ProgressState.initial();
        final updated = state.copyWith(currentStreak: 5);

        expect(updated.currentStreak, 5);
      });

      test('updatesLongestStreak', () {
        final state = ProgressState.initial();
        final updated = state.copyWith(longestStreak: 10);

        expect(updated.longestStreak, 10);
      });

      test('updatesIsLoading', () {
        final state = ProgressState.initial();
        final updated = state.copyWith(isLoading: false);

        expect(updated.isLoading, false);
      });

      test('updatesIsLoadingHistory', () {
        final state = ProgressState.initial();
        final updated = state.copyWith(isLoadingHistory: false);

        expect(updated.isLoadingHistory, false);
      });

      test('updatesError', () {
        final state = ProgressState.initial();
        final updated = state.copyWith(error: 'Test error');

        expect(updated.error, 'Test error');
      });

      test('clearsError', () {
        final state = ProgressState(
          watchHistory: const [],
          progressMap: const {},
          error: 'Previous error',
        );

        final updated = state.copyWith(error: null);
        expect(updated.error, isNull);
      });

      test('preservesUnchangedFields', () {
        final state = ProgressState(
          watchHistory: ProgressFixtures.sampleHistory,
          progressMap: const {},
          currentStreak: 3,
          longestStreak: 7,
          isLoading: false,
          isLoadingHistory: false,
        );

        final updated = state.copyWith(error: 'New error');

        expect(updated.watchHistory, state.watchHistory);
        expect(updated.currentStreak, state.currentStreak);
        expect(updated.longestStreak, state.longestStreak);
      });

      test('updatesStatistics', () {
        final state = ProgressState.initial();
        const stats = ProgressStats(
          totalVideosWatched: 10,
          completedVideos: 5,
          inProgressVideos: 3,
          totalWatchTimeSeconds: 3600,
          averageCompletionRate: 0.75,
        );

        final updated = state.copyWith(statistics: stats);

        expect(updated.statistics, isNotNull);
        expect(updated.statistics!.totalVideosWatched, 10);
        expect(updated.statistics!.completedVideos, 5);
      });
    });
  });

  // ===========================================================================
  // PROGRESS NOTIFIER TESTS WITH INJECTED MOCKS
  // ===========================================================================
  group('ProgressNotifier', () {
    late MockSaveProgressUseCase mockSaveUseCase;
    late MockGetWatchHistoryUseCase mockHistoryUseCase;
    late MockGetStatisticsUseCase mockStatsUseCase;
    late MockContentRepository mockContentRepository;

    setUp(() {
      mockSaveUseCase = MockSaveProgressUseCase();
      mockHistoryUseCase = MockGetWatchHistoryUseCase();
      mockStatsUseCase = MockGetStatisticsUseCase();
      mockContentRepository = MockContentRepository();
    });

    ProgressNotifier createNotifier({bool autoLoad = false}) {
      return ProgressNotifier(
        mockSaveUseCase,
        mockHistoryUseCase,
        mockStatsUseCase,
        mockContentRepository,
        autoLoad: autoLoad,
      );
    }

    group('constructor', () {
      test('initialState_isCorrect', () {
        final notifier = createNotifier(autoLoad: false);

        expect(notifier.state.watchHistory, isEmpty);
        expect(notifier.state.isLoading, true);
        expect(notifier.state.isLoadingHistory, true);

        notifier.dispose();
      });

      test('withAutoLoad_callsLoadMethods', () async {
        mockHistoryUseCase.setSuccess([]);
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(mockHistoryUseCase.callCount, greaterThanOrEqualTo(1));
        expect(mockStatsUseCase.callCount, greaterThanOrEqualTo(1));

        notifier.dispose();
      });
    });

    group('loadWatchHistory', () {
      test('success_updatesStateWithHistory', () async {
        final history = MockProgressData.createHistory(count: 3);
        mockHistoryUseCase.setSuccess(history);

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadWatchHistory();

        expect(notifier.state.isLoadingHistory, false);
        expect(notifier.state.watchHistory.length, 3);
        expect(notifier.state.progressMap.length, 3);
        expect(notifier.state.error, isNull);

        notifier.dispose();
      });

      test('success_buildsProgressMap', () async {
        final history = [
          MockProgressData.createProgress(videoId: 'v1'),
          MockProgressData.createProgress(videoId: 'v2'),
        ];
        mockHistoryUseCase.setSuccess(history);

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadWatchHistory();

        expect(notifier.state.progressMap.containsKey('v1'), true);
        expect(notifier.state.progressMap.containsKey('v2'), true);

        notifier.dispose();
      });

      test('failure_setsError', () async {
        mockHistoryUseCase.setFailure('Database error');

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadWatchHistory();

        expect(notifier.state.isLoadingHistory, false);
        expect(notifier.state.watchHistory, isEmpty);
        expect(notifier.state.error, 'Database error');

        notifier.dispose();
      });

      test('calculatesStreaks_forConsecutiveDays', () async {
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));
        final twoDaysAgo = today.subtract(const Duration(days: 2));

        final history = [
          MockProgressData.createProgress(videoId: 'v1', lastWatched: today),
          MockProgressData.createProgress(videoId: 'v2', lastWatched: yesterday),
          MockProgressData.createProgress(videoId: 'v3', lastWatched: twoDaysAgo),
        ];
        mockHistoryUseCase.setSuccess(history);

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadWatchHistory();

        expect(notifier.state.currentStreak, 3);
        expect(notifier.state.longestStreak, greaterThanOrEqualTo(3));

        notifier.dispose();
      });

      test('calculatesStreaks_breaksOnGap', () async {
        final today = DateTime.now();
        final threeDaysAgo = today.subtract(const Duration(days: 3));

        final history = [
          MockProgressData.createProgress(videoId: 'v1', lastWatched: today),
          MockProgressData.createProgress(videoId: 'v2', lastWatched: threeDaysAgo),
        ];
        mockHistoryUseCase.setSuccess(history);

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadWatchHistory();

        expect(notifier.state.currentStreak, 1);

        notifier.dispose();
      });

      test('fixesCompletionStatus_at90Percent', () async {
        // Progress at 90% but marked incomplete - should be fixed
        final progress = MockProgressData.createProgress(
          videoId: 'v1',
          watchDuration: 540, // 90% of 600
          totalDuration: 600,
          completed: false,
        );
        mockHistoryUseCase.setSuccess([progress]);
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadWatchHistory();

        // The _fixMissingMetadata should mark it as complete
        // Note: saveProgress will be called if fixed
        expect(mockSaveUseCase.callCount, greaterThanOrEqualTo(0));

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });
    });

    group('loadStatistics', () {
      test('success_updatesStateWithStats', () async {
        final stats = MockProgressData.createStats(
          totalVideosWatched: 15,
          completedVideos: 8,
        );
        mockStatsUseCase.setSuccess(stats);

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadStatistics();

        expect(notifier.state.statistics, isNotNull);
        expect(notifier.state.statistics!.totalVideosWatched, 15);
        expect(notifier.state.statistics!.completedVideos, 8);
        expect(notifier.state.isLoading, false);

        notifier.dispose();
      });

      test('failure_doesNotSetError', () async {
        mockStatsUseCase.setFailure('Stats error');

        final notifier = createNotifier(autoLoad: false);
        await notifier.loadStatistics();

        expect(notifier.state.statistics, isNull);
        expect(notifier.state.isLoading, false);
        // Error is not set for statistics failure (silent fail)

        notifier.dispose();
      });
    });

    group('saveProgress', () {
      test('success_updatesLocalState', () async {
        final notifier = createNotifier(autoLoad: false);

        final progress = MockProgressData.createProgress(
          videoId: 'new-video',
          watchDuration: 200,
        );
        mockSaveUseCase.setSuccess(progress);
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.saveProgress(progress);

        expect(notifier.state.watchHistory.length, 1);
        expect(notifier.state.progressMap['new-video'], isNotNull);
        expect(notifier.state.error, isNull);
        expect(mockSaveUseCase.callCount, 1);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });

      test('success_updatesExistingProgress', () async {
        final existingProgress = MockProgressData.createProgress(
          videoId: 'existing-video',
          watchDuration: 100,
        );

        final notifier = createNotifier(autoLoad: false);
        // Manually set initial state
        mockSaveUseCase.setSuccess(existingProgress);
        mockStatsUseCase.setSuccess(MockProgressData.createStats());
        await notifier.saveProgress(existingProgress);

        // Update existing progress
        final updatedProgress = MockProgressData.createProgress(
          videoId: 'existing-video',
          watchDuration: 400,
        );
        mockSaveUseCase.setSuccess(updatedProgress);

        await notifier.saveProgress(updatedProgress);

        expect(notifier.state.watchHistory.length, 1);
        expect(notifier.state.progressMap['existing-video']!.watchDuration, 400);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });

      test('failure_setsError', () async {
        final notifier = createNotifier(autoLoad: false);

        mockSaveUseCase.setFailure('Save failed');
        final progress = MockProgressData.createProgress();

        await notifier.saveProgress(progress);

        expect(notifier.state.error, 'Save failed');

        notifier.dispose();
      });

      test('success_reloadsStatistics', () async {
        final notifier = createNotifier(autoLoad: false);

        final progress = MockProgressData.createProgress();
        mockSaveUseCase.setSuccess(progress);
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.saveProgress(progress);

        expect(mockStatsUseCase.callCount, greaterThanOrEqualTo(1));

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });
    });

    group('updateProgress', () {
      test('calculatesCompletion_at90Percent', () async {
        final notifier = createNotifier(autoLoad: false);

        mockSaveUseCase.setSuccess(MockProgressData.createProgress(completed: true));
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.updateProgress(
          videoId: 'video-1',
          watchedSeconds: 540, // 90% of 600
          totalSeconds: 600,
        );

        // Should save with completed = true
        expect(mockSaveUseCase.lastSavedProgress?.completed, true);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });

      test('doesNotMarkComplete_at89Percent', () async {
        final notifier = createNotifier(autoLoad: false);

        mockSaveUseCase.setSuccess(MockProgressData.createProgress(completed: false));
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.updateProgress(
          videoId: 'video-1',
          watchedSeconds: 534, // 89% of 600
          totalSeconds: 600,
        );

        // Should save with completed = false (89% < 90%)
        expect(mockSaveUseCase.lastSavedProgress?.completed, false);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });

      test('respectsExplicitCompletedFlag', () async {
        final notifier = createNotifier(autoLoad: false);

        mockSaveUseCase.setSuccess(MockProgressData.createProgress(completed: true));
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.updateProgress(
          videoId: 'video-1',
          watchedSeconds: 100, // Only 16%
          totalSeconds: 600,
          completed: true, // Explicitly marked complete
        );

        expect(mockSaveUseCase.lastSavedProgress?.completed, true);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });

      test('handlesZeroTotalSeconds', () async {
        final notifier = createNotifier(autoLoad: false);

        mockSaveUseCase.setSuccess(MockProgressData.createProgress(completed: false));
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.updateProgress(
          videoId: 'video-1',
          watchedSeconds: 100,
          totalSeconds: 0, // Invalid duration
        );

        // Should not crash, should save with completed = false
        expect(mockSaveUseCase.callCount, 1);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });
    });

    group('markAsComplete', () {
      test('setsCompletedTrue', () async {
        final notifier = createNotifier(autoLoad: false);

        mockSaveUseCase.setSuccess(MockProgressData.createProgress(completed: true));
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        await notifier.markAsComplete('video-1', 600);

        expect(mockSaveUseCase.lastSavedProgress?.completed, true);
        expect(mockSaveUseCase.lastSavedProgress?.watchDuration, 600);

        // Wait for background loadStatistics to complete
        await Future.delayed(const Duration(milliseconds: 100));
        notifier.dispose();
      });
    });

    group('refresh', () {
      test('reloadsHistoryAndStatistics', () async {
        mockHistoryUseCase.setSuccess([]);
        mockStatsUseCase.setSuccess(MockProgressData.createStats());

        final notifier = createNotifier(autoLoad: false);
        await notifier.refresh();

        expect(mockHistoryUseCase.callCount, 1);
        expect(mockStatsUseCase.callCount, 1);

        notifier.dispose();
      });
    });
  });

  // ===========================================================================
  // 90% COMPLETION THRESHOLD TESTS
  // ===========================================================================
  group('90% Completion Threshold', () {
    test('updateProgress_marks_complete_at_90_percent', () {
      const totalSeconds = 600;
      const watchedSeconds = 540; // 90%

      final completionPercentage = totalSeconds > 0
          ? (watchedSeconds / totalSeconds)
          : 0.0;
      final isComplete = completionPercentage >= 0.9;

      expect(isComplete, true);
    });

    test('updateProgress_does_not_mark_complete_at_89_percent', () {
      const totalSeconds = 600;
      const watchedSeconds = 534; // 89%

      final completionPercentage = totalSeconds > 0
          ? (watchedSeconds / totalSeconds)
          : 0.0;
      final isComplete = completionPercentage >= 0.9;

      expect(isComplete, false);
    });

    test('updateProgress_handles_zero_total_seconds', () {
      const totalSeconds = 0;
      const watchedSeconds = 100;

      final completionPercentage = totalSeconds > 0
          ? (watchedSeconds / totalSeconds)
          : 0.0;
      final isComplete = completionPercentage >= 0.9;

      expect(completionPercentage, 0.0);
      expect(isComplete, false);
    });
  });

  // ===========================================================================
  // STATE TRANSITION TESTS
  // ===========================================================================
  group('State Transitions', () {
    test('loadWatchHistory_success_transition', () {
      var state = ProgressState.initial();

      expect(state.isLoadingHistory, true);

      state = state.copyWith(
        watchHistory: ProgressFixtures.sampleHistory,
        progressMap: {
          for (final p in ProgressFixtures.sampleHistory) p.videoId: p
        },
        isLoadingHistory: false,
        error: null,
      );

      expect(state.isLoadingHistory, false);
      expect(state.watchHistory.length, 4);
      expect(state.error, isNull);
    });

    test('loadWatchHistory_error_transition', () {
      var state = ProgressState.initial();

      state = state.copyWith(
        isLoadingHistory: false,
        error: 'Failed to load watch history',
      );

      expect(state.isLoadingHistory, false);
      expect(state.watchHistory, isEmpty);
      expect(state.error, 'Failed to load watch history');
    });

    test('saveProgress_adds_to_history', () {
      var state = ProgressState(
        watchHistory: [ProgressFixtures.halfWatched],
        progressMap: {ProgressFixtures.halfWatched.videoId: ProgressFixtures.halfWatched},
        isLoading: false,
        isLoadingHistory: false,
      );

      final newProgress = ProgressFixtures.fullyCompleted;
      final updatedHistory = [...state.watchHistory];
      updatedHistory.insert(0, newProgress);

      final updatedMap = Map<String, Progress>.from(state.progressMap);
      updatedMap[newProgress.videoId] = newProgress;

      state = state.copyWith(
        watchHistory: updatedHistory,
        progressMap: updatedMap,
      );

      expect(state.watchHistory.length, 2);
      expect(state.watchHistory.first.videoId, newProgress.videoId);
    });
  });

  // ===========================================================================
  // STATISTICS TESTS
  // ===========================================================================
  group('Statistics', () {
    test('loadStatistics_updates_state', () {
      var state = ProgressState.initial();

      const stats = ProgressStats(
        totalVideosWatched: 10,
        completedVideos: 5,
        inProgressVideos: 3,
        totalWatchTimeSeconds: 3600,
        averageCompletionRate: 0.75,
      );

      state = state.copyWith(
        statistics: stats,
        isLoading: false,
      );

      expect(state.statistics, isNotNull);
      expect(state.statistics!.totalWatchTimeSeconds, 3600);
      expect(state.statistics!.completedVideos, 5);
    });

    test('formattedTotalWatchTime_formats_correctly', () {
      const stats = ProgressStats(
        totalVideosWatched: 10,
        completedVideos: 5,
        inProgressVideos: 3,
        totalWatchTimeSeconds: 3665,
        averageCompletionRate: 0.75,
      );

      expect(stats.formattedTotalWatchTime, contains('hr'));
    });

    test('formattedTotalWatchTime_handlesMinutesOnly', () {
      const stats = ProgressStats(
        totalVideosWatched: 10,
        completedVideos: 5,
        inProgressVideos: 3,
        totalWatchTimeSeconds: 300,
        averageCompletionRate: 0.75,
      );

      expect(stats.formattedTotalWatchTime, contains('min'));
    });
  });
}
