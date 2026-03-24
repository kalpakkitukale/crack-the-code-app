import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/services/content_filter_service.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/usecases/content/get_videos_usecase.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Video Provider
/// Manages videos for a specific chapter
/// Uses real ContentRepository via GetVideosUseCase

class VideoState {
  final List<Video> videos;
  final bool isLoading;
  final String? error;
  final String? currentSubjectId;
  final String? currentChapterId;

  const VideoState({
    required this.videos,
    this.isLoading = false,
    this.error,
    this.currentSubjectId,
    this.currentChapterId,
  });

  factory VideoState.initial() => const VideoState(
        videos: [],
        isLoading: false,
      );

  VideoState copyWith({
    List<Video>? videos,
    bool? isLoading,
    String? error,
    String? currentSubjectId,
    String? currentChapterId,
  }) {
    return VideoState(
      videos: videos ?? this.videos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentSubjectId: currentSubjectId ?? this.currentSubjectId,
      currentChapterId: currentChapterId ?? this.currentChapterId,
    );
  }

  Video? getVideoById(String videoId) {
    try {
      return videos.firstWhere((v) => v.id == videoId);
    } catch (e) {
      return null;
    }
  }

  Video? getVideoByYoutubeId(String youtubeId) {
    try {
      return videos.firstWhere((v) => v.youtubeId == youtubeId);
    } catch (e) {
      return null;
    }
  }
}

class VideoNotifier extends StateNotifier<VideoState> {
  final GetVideosUseCase _getVideosUseCase;

  VideoNotifier(this._getVideosUseCase) : super(VideoState.initial());

  Future<void> loadVideos({
    required String subjectId,
    required String chapterId,
  }) async {
    logger.info('Loading videos for subject: $subjectId, chapter: $chapterId');
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentSubjectId: subjectId,
      currentChapterId: chapterId,
    );

    final result = await _getVideosUseCase.call(
      GetVideosParams(
        subjectId: subjectId,
        chapterId: chapterId,
      ),
    );

    result.fold(
      (failure) {
        logger.error('Failed to load videos: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (videos) {
        logger.info('Successfully loaded ${videos.length} videos');
        state = state.copyWith(
          videos: videos,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> refresh() async {
    if (state.currentSubjectId != null && state.currentChapterId != null) {
      logger.info('Refreshing videos');
      await loadVideos(
        subjectId: state.currentSubjectId!,
        chapterId: state.currentChapterId!,
      );
    }
  }

  void clear() {
    logger.info('Clearing videos');
    state = VideoState.initial();
  }
}

final videoProvider = StateNotifierProvider<VideoNotifier, VideoState>((ref) {
  return VideoNotifier(injectionContainer.getVideosUseCase);
});

/// Filtered video provider that applies parental control filters
/// Use this provider when displaying videos in the UI for Junior segment
final filteredVideosProvider = Provider<List<Video>>((ref) {
  final videoState = ref.watch(videoProvider);

  // Only apply filtering for Junior segment with parental controls
  if (!SegmentConfig.settings.showParentalControls) {
    return videoState.videos;
  }

  final filterService = ref.watch(contentFilterServiceProvider);
  return filterService.filterVideos(videoState.videos);
});

/// Provider for filtered video count (useful for displaying filter status)
final filteredVideoCountProvider = Provider<({int total, int filtered})>((ref) {
  final videoState = ref.watch(videoProvider);
  final filteredVideos = ref.watch(filteredVideosProvider);

  return (total: videoState.videos.length, filtered: filteredVideos.length);
});
