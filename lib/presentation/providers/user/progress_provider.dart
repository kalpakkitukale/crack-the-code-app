import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/usecases/progress/get_statistics_usecase.dart';
import 'package:crack_the_code/domain/usecases/progress/get_watch_history_usecase.dart';
import 'package:crack_the_code/domain/usecases/progress/save_progress_usecase.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/core/services/youtube_metadata_service.dart';

/// Progress Provider
/// Tracks user video watch progress using real repository

class ProgressState {
  final List<Progress> watchHistory;
  final Map<String, Progress> progressMap;
  final ProgressStats? statistics;
  final int currentStreak;
  final int longestStreak;
  final bool isLoading;
  final bool isLoadingHistory;
  final String? error;

  const ProgressState({
    required this.watchHistory,
    required this.progressMap,
    this.statistics,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.isLoading = false,
    this.isLoadingHistory = false,
    this.error,
  });

  factory ProgressState.initial() => const ProgressState(
        watchHistory: [],
        progressMap: {},
        isLoading: true,
        isLoadingHistory: true,
      );

  ProgressState copyWith({
    List<Progress>? watchHistory,
    Map<String, Progress>? progressMap,
    ProgressStats? statistics,
    int? currentStreak,
    int? longestStreak,
    bool? isLoading,
    bool? isLoadingHistory,
    String? error,
  }) {
    return ProgressState(
      watchHistory: watchHistory ?? this.watchHistory,
      progressMap: progressMap ?? this.progressMap,
      statistics: statistics ?? this.statistics,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      isLoading: isLoading ?? this.isLoading,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      error: error,
    );
  }

  Progress? getProgress(String videoId) {
    return progressMap[videoId];
  }

  double getProgressPercent(String videoId) {
    final progress = progressMap[videoId];
    if (progress == null || progress.totalDuration == 0) return 0.0;
    return (progress.watchDuration / progress.totalDuration).clamp(0.0, 1.0);
  }

  bool isCompleted(String videoId) {
    return progressMap[videoId]?.completed ?? false;
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  final SaveProgressUseCase _saveProgressUseCase;
  final GetWatchHistoryUseCase _getWatchHistoryUseCase;
  final GetStatisticsUseCase _getStatisticsUseCase;
  final ContentRepository _contentRepository;

  /// Creates a ProgressNotifier with injected dependencies.
  ///
  /// All dependencies are injected for better testability.
  /// Set [autoLoad] to false in tests to prevent automatic loading.
  ProgressNotifier(
    this._saveProgressUseCase,
    this._getWatchHistoryUseCase,
    this._getStatisticsUseCase,
    this._contentRepository, {
    bool autoLoad = true,
  }) : super(ProgressState.initial()) {
    if (autoLoad) {
      loadWatchHistory();
      loadStatistics();
    }
  }

  Future<void> loadWatchHistory({int? limit}) async {
    logger.info('Loading watch history from repository');
    state = state.copyWith(isLoadingHistory: true, error: null);

    final result = await _getWatchHistoryUseCase.call(
      GetWatchHistoryParams(limit: limit ?? 50),
    );

    if (result.isLeft()) {
      // Handle failure
      result.fold(
        (failure) {
          logger.error('Failed to load watch history: ${failure.message}');
          state = state.copyWith(
            isLoadingHistory: false,
            error: failure.message,
          );
        },
        (_) => null,
      );
    } else {
      // Handle success - extract history and fix metadata
      final history = result.getOrElse(() => []);
      logger.info('Successfully loaded ${history.length} progress records');

      // Fix any progress records with missing metadata
      logger.debug('Starting metadata migration...');
      final updatedHistory = await _fixMissingMetadata(history);
      logger.debug('Migration complete, updated ${updatedHistory.length} records');

      // Build progress map for quick lookups
      final progressMap = <String, Progress>{};
      for (final progress in updatedHistory) {
        progressMap[progress.videoId] = progress;
      }

      // Calculate streaks
      final streaks = _calculateStreaks(updatedHistory);

      state = state.copyWith(
        watchHistory: updatedHistory,
        progressMap: progressMap,
        currentStreak: streaks['current']!,
        longestStreak: streaks['longest']!,
        isLoadingHistory: false,
        error: null,
      );
    }
  }

  /// Calculate current and longest learning streaks
  Map<String, int> _calculateStreaks(List<Progress> history) {
    if (history.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    // Group progress by day
    final Map<String, bool> activeDays = {};
    for (final progress in history) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        progress.lastWatched.millisecondsSinceEpoch,
      );
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      activeDays[dateKey] = true;
    }

    // Calculate current streak
    int currentStreak = 0;
    final today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    while (true) {
      final dateKey = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
      if (activeDays.containsKey(dateKey)) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // Calculate longest streak
    int longestStreak = 0;
    int tempStreak = 0;

    // Sort dates
    final sortedDates = activeDays.keys.toList()..sort();

    for (int i = 0; i < sortedDates.length; i++) {
      if (i == 0) {
        tempStreak = 1;
      } else {
        final prevDate = DateTime.parse(sortedDates[i - 1]);
        final currDate = DateTime.parse(sortedDates[i]);
        final diff = currDate.difference(prevDate).inDays;

        if (diff == 1) {
          tempStreak++;
        } else {
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
          tempStreak = 1;
        }
      }
    }

    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
    }

    return {
      'current': currentStreak,
      'longest': longestStreak,
    };
  }

  /// Fix progress records with missing video metadata and completion status
  Future<List<Progress>> _fixMissingMetadata(List<Progress> progressList) async {
    logger.debug('Checking ${progressList.length} progress records for missing metadata...');
    final updatedList = <Progress>[];
    int metadataFixed = 0;
    int completionFixed = 0;

    for (final progress in progressList) {
      bool needsUpdate = false;
      String? title = progress.title;
      String? channelName = progress.channelName;
      String? thumbnailUrl = progress.thumbnailUrl;
      bool completed = progress.completed;

      // Check if completion status needs fixing (90% threshold)
      if (!progress.completed && progress.totalDuration > 0) {
        final completionPercentage = progress.watchDuration / progress.totalDuration;
        if (completionPercentage >= 0.9) {
          completed = true;
          needsUpdate = true;
          completionFixed++;
          logger.debug('Fixing completion status for video: ${progress.videoId} (${(completionPercentage * 100).toInt()}%)');
        }
      }

      // Check if metadata needs fixing
      if (progress.title == null || progress.title!.isEmpty) {
        logger.debug('Fixing missing metadata for video: ${progress.videoId}');

        try {
          // First try content repository (for videos loaded from JSON)
          final result = await _contentRepository.getVideoById(progress.videoId);

          if (result.isRight()) {
            final video = result.getOrElse(() => throw Exception('Failed to get video'));
            title = video.title;
            channelName = video.channelName;
            thumbnailUrl = video.thumbnailUrl;
            needsUpdate = true;
            metadataFixed++;
            logger.debug('Fixed metadata from repository: ${video.title}');
          } else {
            // Fallback: Try YouTube oEmbed API
            logger.debug('Repository failed, trying YouTube API for ${progress.videoId}');

            final youtubeMetadata = await YouTubeMetadataService.fetchMetadata(progress.videoId);

            if (youtubeMetadata != null) {
              title = youtubeMetadata['title'];
              channelName = youtubeMetadata['channelName'];
              thumbnailUrl = youtubeMetadata['thumbnailUrl'];
              needsUpdate = true;
              metadataFixed++;
              logger.debug('Fixed metadata from YouTube: ${youtubeMetadata['title']}');
            } else {
              logger.warning('Could not fetch metadata from YouTube for ${progress.videoId}');
            }
          }
        } catch (e) {
          logger.error('Error fixing metadata for ${progress.videoId}: $e');
        }
      }

      // Update progress if needed
      if (needsUpdate) {
        final updatedProgress = Progress(
          id: progress.id,
          videoId: progress.videoId,
          title: title,
          channelName: channelName,
          thumbnailUrl: thumbnailUrl,
          watchDuration: progress.watchDuration,
          totalDuration: progress.totalDuration,
          completed: completed,
          lastWatched: progress.lastWatched,
        );

        // Save updated progress to database
        await saveProgress(updatedProgress);
        updatedList.add(updatedProgress);
      } else {
        updatedList.add(progress);
      }
    }

    if (metadataFixed > 0 || completionFixed > 0) {
      logger.info('Fixed $metadataFixed metadata and $completionFixed completion status records');
    }

    return updatedList;
  }

  Future<void> loadStatistics() async {
    logger.info('Loading progress statistics');

    final result = await _getStatisticsUseCase.call();

    result.fold(
      (failure) {
        logger.error('Failed to load statistics: ${failure.message}');
        // Don't show error to user for statistics, just log it
        state = state.copyWith(isLoading: false);
      },
      (stats) {
        logger.info('Successfully loaded statistics');
        state = state.copyWith(statistics: stats, isLoading: false);
      },
    );
  }

  Future<void> saveProgress(Progress progress) async {
    logger.info('Saving progress for video: ${progress.videoId}');

    final result = await _saveProgressUseCase.call(progress);

    result.fold(
      (failure) {
        logger.error('Failed to save progress: ${failure.message}');
        state = state.copyWith(error: failure.message);
      },
      (savedProgress) {
        logger.info('Progress saved successfully');

        // Update local state
        final updatedHistory = [...state.watchHistory];
        final index = updatedHistory.indexWhere((p) => p.videoId == savedProgress.videoId);

        if (index != -1) {
          updatedHistory[index] = savedProgress;
        } else {
          updatedHistory.insert(0, savedProgress);
        }

        final updatedMap = Map<String, Progress>.from(state.progressMap);
        updatedMap[savedProgress.videoId] = savedProgress;

        state = state.copyWith(
          watchHistory: updatedHistory,
          progressMap: updatedMap,
          error: null,
        );

        // Reload statistics in background
        loadStatistics();
      },
    );
  }

  Future<void> updateProgress({
    required String videoId,
    required int watchedSeconds,
    required int totalSeconds,
    String? title,
    String? channelName,
    String? thumbnailUrl,
    bool? completed,
  }) async {
    // Calculate completion: consider video complete if watched >= 90%
    // This accounts for ads, outros, and other skippable content
    final completionPercentage = totalSeconds > 0
        ? (watchedSeconds / totalSeconds)
        : 0.0;
    final isComplete = completionPercentage >= 0.9; // 90% threshold

    // If metadata is missing, try to fetch from YouTube
    String? finalTitle = title;
    String? finalChannelName = channelName;
    String? finalThumbnailUrl = thumbnailUrl;

    if (finalTitle == null || finalTitle.isEmpty) {
      logger.info('Metadata missing for $videoId, fetching from YouTube...');
      try {
        final youtubeMetadata = await YouTubeMetadataService.fetchMetadata(videoId);
        if (youtubeMetadata != null) {
          finalTitle = youtubeMetadata['title'];
          finalChannelName = youtubeMetadata['channelName'];
          finalThumbnailUrl = youtubeMetadata['thumbnailUrl'];
          logger.info('Successfully fetched metadata from YouTube: $finalTitle');
        }
      } catch (e) {
        logger.warning('Failed to fetch metadata from YouTube: $e');
      }
    }

    final progress = Progress(
      id: videoId, // Using videoId as ID for simplicity
      videoId: videoId,
      title: finalTitle,
      channelName: finalChannelName,
      thumbnailUrl: finalThumbnailUrl,
      watchDuration: watchedSeconds,
      totalDuration: totalSeconds,
      completed: completed ?? isComplete,
      lastWatched: DateTime.now(),
    );

    await saveProgress(progress);
  }

  Future<void> markAsComplete(String videoId, int totalSeconds) async {
    logger.info('Marking video as complete: $videoId');

    await updateProgress(
      videoId: videoId,
      watchedSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      completed: true,
    );
  }

  Future<void> refresh() async {
    logger.info('Refreshing progress data');
    await loadWatchHistory();
    await loadStatistics();
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier(
    injectionContainer.saveProgressUseCase,
    injectionContainer.getWatchHistoryUseCase,
    injectionContainer.getStatisticsUseCase,
    injectionContainer.contentRepository,
  );
});

/// Parameters for chapter completion check
class ChapterCompletionParams {
  final String chapterId;
  final List<String> videoIds;

  const ChapterCompletionParams({
    required this.chapterId,
    required this.videoIds,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterCompletionParams &&
          runtimeType == other.runtimeType &&
          chapterId == other.chapterId &&
          _listEquals(videoIds, other.videoIds);

  @override
  int get hashCode => chapterId.hashCode ^ videoIds.hashCode;

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Result of chapter completion check
class ChapterCompletionStatus {
  final bool isComplete;
  final int completedCount;
  final int totalCount;
  final double completionPercentage;

  const ChapterCompletionStatus({
    required this.isComplete,
    required this.completedCount,
    required this.totalCount,
    required this.completionPercentage,
  });
}

/// Provider to check if all videos in a chapter are completed
/// Returns completion status with detailed progress info
final chapterCompletionProvider = Provider.family<ChapterCompletionStatus, ChapterCompletionParams>(
  (ref, params) {
    final progressState = ref.watch(progressProvider);

    if (params.videoIds.isEmpty) {
      return const ChapterCompletionStatus(
        isComplete: false,
        completedCount: 0,
        totalCount: 0,
        completionPercentage: 0.0,
      );
    }

    // Count completed videos
    int completedCount = 0;
    for (final videoId in params.videoIds) {
      final progress = progressState.progressMap[videoId];
      if (progress != null && progress.completed) {
        completedCount++;
      }
    }

    final totalCount = params.videoIds.length;
    final completionPercentage = totalCount > 0
        ? (completedCount / totalCount) * 100
        : 0.0;

    return ChapterCompletionStatus(
      isComplete: completedCount == totalCount && totalCount > 0,
      completedCount: completedCount,
      totalCount: totalCount,
      completionPercentage: completionPercentage,
    );
  },
);
