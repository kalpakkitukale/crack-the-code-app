import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/content/board.dart';
import 'package:crack_the_code/domain/entities/content/subject.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/core/platform/platform_consistency_manager.dart';
import 'package:crack_the_code/presentation/providers/user/subject_progress_provider.dart';

/// Provider for content repository access
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return injectionContainer.contentRepository;
});

/// Keys for SharedPreferences storage
class _UserContextKeys {
  static const String boardId = 'user_context_board_id';
  static const String classId = 'user_context_class_id';
  static const String streamId = 'user_context_stream_id';
  static const String subjectId = 'user_context_subject_id';
  static const String lastUpdated = 'user_context_last_updated';
}

/// User context representing current selection
class UserContext {
  final String? boardId;
  final String? classId;
  final String? streamId;
  final String? subjectId;
  final DateTime lastUpdated;

  const UserContext({
    this.boardId,
    this.classId,
    this.streamId,
    this.subjectId,
    required this.lastUpdated,
  });

  factory UserContext.initial() => UserContext(
    lastUpdated: DateTime.now(),
  );

  UserContext copyWith({
    String? boardId,
    String? classId,
    String? streamId,
    String? subjectId,
  }) {
    return UserContext(
      boardId: boardId ?? this.boardId,
      classId: classId ?? this.classId,
      streamId: streamId ?? this.streamId,
      subjectId: subjectId ?? this.subjectId,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserContext &&
      other.boardId == boardId &&
      other.classId == classId &&
      other.streamId == streamId &&
      other.subjectId == subjectId;
  }

  @override
  int get hashCode => Object.hash(boardId, classId, streamId, subjectId);
}

/// Unified content state for all platforms
class ContentState {
  final List<Board> boards;
  final List<Subject> subjects;
  final Map<String, List<Video>> videosByChapter;
  final bool isLoading;
  final String? error;

  const ContentState({
    required this.boards,
    required this.subjects,
    required this.videosByChapter,
    required this.isLoading,
    this.error,
  });

  factory ContentState.initial() => const ContentState(
    boards: [],
    subjects: [],
    videosByChapter: {},
    isLoading: false,
  );

  ContentState copyWith({
    List<Board>? boards,
    List<Subject>? subjects,
    Map<String, List<Video>>? videosByChapter,
    bool? isLoading,
    String? error,
  }) {
    return ContentState(
      boards: boards ?? this.boards,
      subjects: subjects ?? this.subjects,
      videosByChapter: videosByChapter ?? this.videosByChapter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Unified progress state for all platforms
class UnifiedProgressState {
  final List<Progress> watchHistory;
  final Map<String, Progress> progressMap;
  final int totalWatchTimeSeconds;
  final int completedVideos;
  final bool isLoading;

  const UnifiedProgressState({
    required this.watchHistory,
    required this.progressMap,
    required this.totalWatchTimeSeconds,
    required this.completedVideos,
    required this.isLoading,
  });

  factory UnifiedProgressState.initial() => const UnifiedProgressState(
    watchHistory: [],
    progressMap: {},
    totalWatchTimeSeconds: 0,
    completedVideos: 0,
    isLoading: false,
  );

  UnifiedProgressState copyWith({
    List<Progress>? watchHistory,
    Map<String, Progress>? progressMap,
    int? totalWatchTimeSeconds,
    int? completedVideos,
    bool? isLoading,
  }) {
    return UnifiedProgressState(
      watchHistory: watchHistory ?? this.watchHistory,
      progressMap: progressMap ?? this.progressMap,
      totalWatchTimeSeconds: totalWatchTimeSeconds ?? this.totalWatchTimeSeconds,
      completedVideos: completedVideos ?? this.completedVideos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Unified app state - single source of truth for all platforms
class UnifiedAppState {
  final UserContext userContext;
  final ContentState contentState;
  final UnifiedProgressState progressState;
  final Map<String, dynamic> platformData;
  final DateTime lastSync;

  const UnifiedAppState({
    required this.userContext,
    required this.contentState,
    required this.progressState,
    required this.platformData,
    required this.lastSync,
  });

  factory UnifiedAppState.initial() => UnifiedAppState(
    userContext: UserContext.initial(),
    contentState: ContentState.initial(),
    progressState: UnifiedProgressState.initial(),
    platformData: {},
    lastSync: DateTime.now(),
  );

  UnifiedAppState copyWith({
    UserContext? userContext,
    ContentState? contentState,
    UnifiedProgressState? progressState,
    Map<String, dynamic>? platformData,
    DateTime? lastSync,
  }) {
    return UnifiedAppState(
      userContext: userContext ?? this.userContext,
      contentState: contentState ?? this.contentState,
      progressState: progressState ?? this.progressState,
      platformData: platformData ?? this.platformData,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnifiedAppState &&
      other.userContext == userContext &&
      other.contentState == contentState &&
      other.progressState == progressState &&
      mapEquals(other.platformData, platformData);
  }

  @override
  int get hashCode => Object.hash(
    userContext,
    contentState,
    progressState,
    platformData,
  );
}

/// Unified app state notifier - manages all state changes consistently
class UnifiedAppStateNotifier extends StateNotifier<UnifiedAppState> {
  final Ref ref;
  final ContentRepository _contentRepository;
  final ProgressRepository _progressRepository;

  UnifiedAppStateNotifier(
    this.ref,
    this._contentRepository,
    this._progressRepository,
  ) : super(UnifiedAppState.initial()) {
    _initializeUnifiedState();
  }

  /// Safely update state only if still mounted
  void _safeSetState(UnifiedAppState newState) {
    if (mounted) {
      state = newState;
    }
  }

  @override
  void dispose() {
    logger.debug('UnifiedAppStateNotifier: Disposing...');
    super.dispose();
  }

  /// Initialize unified state for all platforms
  Future<void> _initializeUnifiedState() async {
    logger.info('🎯 Initializing unified app state...');

    // Ensure platform consistency first
    await PlatformConsistencyManager().initializeConsistently();

    // Load boards (same for all platforms)
    await _loadBoards();

    // Load user context from storage
    await _loadUserContext();

    // Load progress (same database for all platforms)
    await _loadProgress();

    logger.info('✅ Unified app state initialized');
  }

  /// Load all boards
  Future<void> _loadBoards() async {
    try {
      _safeSetState(state.copyWith(
        contentState: state.contentState.copyWith(isLoading: true),
      ));

      final result = await _contentRepository.getBoards();

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to load boards: ${failure.message}');
          _safeSetState(state.copyWith(
            contentState: state.contentState.copyWith(
              isLoading: false,
              error: failure.message,
            ),
          ));
        },
        (boards) {
          logger.info('Loaded ${boards.length} boards');
          _safeSetState(state.copyWith(
            contentState: state.contentState.copyWith(
              boards: boards,
              isLoading: false,
              error: null,
            ),
          ));
        },
      );
    } catch (e) {
      logger.error('Error loading boards: $e');
    }
  }

  /// Load user context from persistent storage
  Future<void> _loadUserContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      final boardId = prefs.getString(_UserContextKeys.boardId);
      final classId = prefs.getString(_UserContextKeys.classId);
      final streamId = prefs.getString(_UserContextKeys.streamId);
      final subjectId = prefs.getString(_UserContextKeys.subjectId);
      final lastUpdatedStr = prefs.getString(_UserContextKeys.lastUpdated);

      final lastUpdated = lastUpdatedStr != null
          ? DateTime.tryParse(lastUpdatedStr) ?? DateTime.now()
          : DateTime.now();

      final userContext = UserContext(
        boardId: boardId,
        classId: classId,
        streamId: streamId,
        subjectId: subjectId,
        lastUpdated: lastUpdated,
      );

      _safeSetState(state.copyWith(userContext: userContext));

      // If we have a saved context, load subjects for it
      if (boardId != null && classId != null && streamId != null) {
        logger.info('Restored user context: $boardId/$classId/$streamId');
        await _loadSubjectsForContext(boardId, classId, streamId);
      } else {
        logger.info('No saved user context found, using defaults');
      }
    } catch (e, stackTrace) {
      logger.error('Failed to load user context', e, stackTrace);
      _safeSetState(state.copyWith(userContext: UserContext.initial()));
    }
  }

  /// Load progress data
  Future<void> _loadProgress() async {
    try {
      final result = await _progressRepository.getWatchHistory();

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to load progress: ${failure.message}');
        },
        (history) {
          final progressMap = <String, Progress>{};
          int totalWatchTime = 0;
          int completed = 0;

          for (final progress in history) {
            progressMap[progress.videoId] = progress;
            totalWatchTime += progress.watchDuration;
            if (progress.completed) completed++;
          }

          _safeSetState(state.copyWith(
            progressState: UnifiedProgressState(
              watchHistory: history,
              progressMap: progressMap,
              totalWatchTimeSeconds: totalWatchTime,
              completedVideos: completed,
              isLoading: false,
            ),
          ));

          logger.info('Loaded ${history.length} progress records');
        },
      );
    } catch (e) {
      logger.error('Error loading progress: $e');
    }
  }

  /// Update user selection (board, class, stream)
  Future<void> updateUserSelection({
    required String boardId,
    required String classId,
    required String streamId,
  }) async {
    logger.info('Updating user selection: $boardId/$classId/$streamId');

    // Update context
    state = state.copyWith(
      userContext: state.userContext.copyWith(
        boardId: boardId,
        classId: classId,
        streamId: streamId,
      ),
    );

    // Load subjects for this context
    await _loadSubjectsForContext(boardId, classId, streamId);

    // Persist selection
    await _persistUserContext();
  }

  /// Load subjects for current context
  Future<void> _loadSubjectsForContext(
    String boardId,
    String classId,
    String streamId,
  ) async {
    try {
      _safeSetState(state.copyWith(
        contentState: state.contentState.copyWith(isLoading: true),
      ));

      final result = await _contentRepository.getSubjects(
        boardId: boardId,
        classId: classId,
        streamId: streamId,
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          logger.error('Failed to load subjects: ${failure.message}');
          _safeSetState(state.copyWith(
            contentState: state.contentState.copyWith(
              isLoading: false,
              error: failure.message,
            ),
          ));
        },
        (subjects) {
          logger.info('Loaded ${subjects.length} subjects for $boardId/$classId/$streamId');
          _safeSetState(state.copyWith(
            contentState: state.contentState.copyWith(
              subjects: subjects,
              isLoading: false,
              error: null,
            ),
          ));
        },
      );
    } catch (e) {
      logger.error('Error loading subjects: $e');
    }
  }

  /// Select a subject
  Future<void> selectSubject(String subjectId) async {
    logger.info('Selecting subject: $subjectId');

    state = state.copyWith(
      userContext: state.userContext.copyWith(subjectId: subjectId),
    );

    await _persistUserContext();
  }

  /// Update progress for a video
  Future<void> updateVideoProgress({
    required String videoId,
    required int watchedSeconds,
    required int totalSeconds,
    String? title,
    String? channelName,
    String? thumbnailUrl,
  }) async {
    // Calculate completion with 90% threshold
    final completionPercentage = totalSeconds > 0
        ? (watchedSeconds / totalSeconds)
        : 0.0;
    final isComplete = completionPercentage >= 0.9;

    final progress = Progress(
      id: videoId,
      videoId: videoId,
      title: title,
      channelName: channelName,
      thumbnailUrl: thumbnailUrl,
      watchDuration: watchedSeconds,
      totalDuration: totalSeconds,
      completed: isComplete,
      lastWatched: DateTime.now(),
    );

    // Save to repository
    await _progressRepository.saveProgress(progress);

    // Update local state
    final updatedHistory = [...state.progressState.watchHistory];
    final index = updatedHistory.indexWhere((p) => p.videoId == videoId);

    if (index != -1) {
      updatedHistory[index] = progress;
    } else {
      updatedHistory.insert(0, progress);
    }

    final updatedMap = Map<String, Progress>.from(state.progressState.progressMap);
    updatedMap[videoId] = progress;

    state = state.copyWith(
      progressState: state.progressState.copyWith(
        watchHistory: updatedHistory,
        progressMap: updatedMap,
      ),
    );

    logger.info('Updated progress for video $videoId: ${(completionPercentage * 100).toInt()}%');
  }

  /// Persist user context to storage
  Future<void> _persistUserContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final context = state.userContext;

      // Save all context fields
      if (context.boardId != null) {
        await prefs.setString(_UserContextKeys.boardId, context.boardId!);
      } else {
        await prefs.remove(_UserContextKeys.boardId);
      }

      if (context.classId != null) {
        await prefs.setString(_UserContextKeys.classId, context.classId!);
      } else {
        await prefs.remove(_UserContextKeys.classId);
      }

      if (context.streamId != null) {
        await prefs.setString(_UserContextKeys.streamId, context.streamId!);
      } else {
        await prefs.remove(_UserContextKeys.streamId);
      }

      if (context.subjectId != null) {
        await prefs.setString(_UserContextKeys.subjectId, context.subjectId!);
      } else {
        await prefs.remove(_UserContextKeys.subjectId);
      }

      await prefs.setString(
        _UserContextKeys.lastUpdated,
        context.lastUpdated.toIso8601String(),
      );

      logger.info('Persisted user context: ${context.boardId}/${context.classId}/${context.streamId}');
    } catch (e, stackTrace) {
      logger.error('Failed to persist user context', e, stackTrace);
    }
  }

  /// Force sync across platforms
  Future<void> syncPlatformData() async {
    logger.info('Syncing platform data...');

    state = state.copyWith(lastSync: DateTime.now());

    // Reload all data to ensure consistency
    await _loadBoards();
    await _loadProgress();

    logger.info('Platform sync complete');
  }

  /// Get consistency report
  Future<Map<String, dynamic>> getConsistencyReport() async {
    final report = await PlatformConsistencyManager().getConsistencyReport();

    report['state_info'] = {
      'boards_count': state.contentState.boards.length,
      'subjects_count': state.contentState.subjects.length,
      'progress_count': state.progressState.watchHistory.length,
      'last_sync': state.lastSync.toIso8601String(),
    };

    return report;
  }
}

/// Provider for unified app state - single source of truth for all platforms
final unifiedAppStateProvider = StateNotifierProvider<UnifiedAppStateNotifier, UnifiedAppState>((ref) {
  return UnifiedAppStateNotifier(
    ref,
    ref.watch(contentRepositoryProvider),
    ref.watch(progressRepositoryProvider),
  );
});