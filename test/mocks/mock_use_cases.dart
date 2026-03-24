/// Mock Use Cases for Provider Testing
/// These mocks allow testing provider notifiers without real database dependencies
library;

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';
import 'package:crack_the_code/domain/entities/user/bookmark.dart';
import 'package:crack_the_code/domain/entities/user/note.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/entities/content/board.dart';
import 'package:crack_the_code/domain/entities/content/subject.dart';
import 'package:crack_the_code/domain/entities/content/chapter.dart';
import 'package:crack_the_code/domain/entities/search/unified_search_results.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/repositories/quiz_repository.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/base_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/bookmark_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/note_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/database_helper.dart';
import 'package:crack_the_code/data/models/user/bookmark_model.dart';
import 'package:crack_the_code/data/models/user/note_model.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/collection_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/collection_video_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/preference_dao.dart';
import 'package:crack_the_code/data/models/user/collection_model.dart';
import 'package:crack_the_code/data/models/user/collection_video_model.dart';
import 'package:crack_the_code/data/models/user/preference_model.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/recommendations_history_dao.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendations_history.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/learning_path_dao.dart';
import 'package:crack_the_code/data/models/pedagogy/learning_path_model.dart';
import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/progress_dao.dart';
import 'package:crack_the_code/data/models/user/progress_model.dart';
import 'package:crack_the_code/domain/usecases/progress/get_statistics_usecase.dart';
import 'package:crack_the_code/domain/usecases/progress/get_watch_history_usecase.dart';
import 'package:crack_the_code/domain/usecases/progress/save_progress_usecase.dart';
import 'package:crack_the_code/domain/usecases/quiz/load_quiz_usecase.dart';
import 'package:crack_the_code/domain/usecases/quiz/submit_answer_usecase.dart';
import 'package:crack_the_code/domain/usecases/quiz/complete_quiz_usecase.dart';
import 'package:crack_the_code/domain/usecases/quiz/resume_session_usecase.dart';
import 'package:crack_the_code/domain/usecases/quiz/get_quiz_history_usecase.dart';
import 'package:crack_the_code/domain/usecases/quiz/get_active_session_usecase.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_filter.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_statistics.dart';
import 'package:crack_the_code/domain/entities/quiz/subject_statistics.dart';
import 'package:crack_the_code/data/datasources/json/content_json_datasource.dart';
import 'package:crack_the_code/data/models/content/board_model.dart';
import 'package:crack_the_code/data/models/content/class_model.dart';
import 'package:crack_the_code/data/models/content/stream_model.dart';
import 'package:crack_the_code/data/models/content/subject_model.dart';
import 'package:crack_the_code/data/models/content/chapter_model.dart';
import 'package:crack_the_code/data/models/content/topic_model.dart';
import 'package:crack_the_code/data/models/content/video_model.dart';

/// Mock SaveProgressUseCase
class MockSaveProgressUseCase implements SaveProgressUseCase {
  Either<Failure, Progress>? _result;
  Progress? lastSavedProgress;
  int callCount = 0;

  @override
  ProgressRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, Progress> result) {
    _result = result;
  }

  void setSuccess(Progress progress) {
    _result = Right(progress);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, Progress>> call(Progress params) async {
    callCount++;
    lastSavedProgress = params;
    return _result ?? Right(params);
  }
}

/// Mock GetWatchHistoryUseCase
class MockGetWatchHistoryUseCase implements GetWatchHistoryUseCase {
  Either<Failure, List<Progress>>? _result;
  GetWatchHistoryParams? lastParams;
  int callCount = 0;

  @override
  ProgressRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, List<Progress>> result) {
    _result = result;
  }

  void setSuccess(List<Progress> history) {
    _result = Right(history);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, List<Progress>>> call(GetWatchHistoryParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? const Right([]);
  }
}

/// Mock GetStatisticsUseCase
class MockGetStatisticsUseCase implements GetStatisticsUseCase {
  Either<Failure, ProgressStats>? _result;
  int callCount = 0;

  @override
  ProgressRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, ProgressStats> result) {
    _result = result;
  }

  void setSuccess(ProgressStats stats) {
    _result = Right(stats);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, ProgressStats>> call([void params]) async {
    callCount++;
    return _result ?? const Right(ProgressStats(
      totalVideosWatched: 0,
      completedVideos: 0,
      inProgressVideos: 0,
      totalWatchTimeSeconds: 0,
      averageCompletionRate: 0.0,
    ));
  }
}

/// Mock progress data for testing
class MockProgressData {
  static Progress createProgress({
    String id = 'progress-1',
    String videoId = 'video-1',
    String? title = 'Test Video',
    String? channelName = 'Test Channel',
    String? thumbnailUrl = 'https://example.com/thumb.jpg',
    int watchDuration = 300,
    int totalDuration = 600,
    bool completed = false,
    DateTime? lastWatched,
  }) {
    return Progress(
      id: id,
      videoId: videoId,
      title: title,
      channelName: channelName,
      thumbnailUrl: thumbnailUrl,
      watchDuration: watchDuration,
      totalDuration: totalDuration,
      completed: completed,
      lastWatched: lastWatched ?? DateTime.now(),
    );
  }

  static List<Progress> createHistory({int count = 5}) {
    final now = DateTime.now();
    return List.generate(count, (i) => createProgress(
      id: 'progress-$i',
      videoId: 'video-$i',
      title: 'Test Video $i',
      watchDuration: 100 * (i + 1),
      totalDuration: 600,
      completed: i % 2 == 0,
      lastWatched: now.subtract(Duration(days: i)),
    ));
  }

  static ProgressStats createStats({
    int totalVideosWatched = 10,
    int completedVideos = 5,
    int inProgressVideos = 3,
    int totalWatchTimeSeconds = 3600,
    double averageCompletionRate = 0.75,
  }) {
    return ProgressStats(
      totalVideosWatched: totalVideosWatched,
      completedVideos: completedVideos,
      inProgressVideos: inProgressVideos,
      totalWatchTimeSeconds: totalWatchTimeSeconds,
      averageCompletionRate: averageCompletionRate,
    );
  }
}

/// Mock ContentRepository for testing
/// Only implements methods needed for ProgressNotifier testing
class MockContentRepository implements ContentRepository {
  final Map<String, Video> _videos = {};
  Either<Failure, Video>? _getVideoByIdResult;

  /// Add a video to the mock repository
  /// Videos are stored by their id for lookup via getVideoById
  void addVideo(Video video) {
    _videos[video.id] = video;
  }

  /// Add a video that can be found by YouTube ID
  /// Useful when Progress.videoId contains the YouTube ID
  void addVideoByYoutubeId(Video video) {
    _videos[video.youtubeId] = video;
  }

  void setGetVideoByIdResult(Either<Failure, Video> result) {
    _getVideoByIdResult = result;
  }

  void setGetVideoByIdFailure(String message) {
    _getVideoByIdResult = Left(CacheFailure(message: message));
  }

  @override
  Future<Either<Failure, Video>> getVideoById(String videoId) async {
    if (_getVideoByIdResult != null) {
      return _getVideoByIdResult!;
    }
    final video = _videos[videoId];
    if (video != null) {
      return Right(video);
    }
    return Left(CacheFailure(message: 'Video not found: $videoId'));
  }

  // Stub implementations for other methods (not used in ProgressNotifier tests)
  @override
  Future<Either<Failure, List<Board>>> getBoards() async =>
      const Right([]);

  @override
  Future<Either<Failure, Board>> getBoardById(String boardId) async =>
      Left(CacheFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, List<Subject>>> getSubjects({
    required String boardId,
    required String classId,
    required String streamId,
  }) async => const Right([]);

  @override
  Future<Either<Failure, Subject>> getSubjectById(String subjectId) async =>
      Left(CacheFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, List<Chapter>>> getChapters(String subjectId) async =>
      const Right([]);

  @override
  Future<Either<Failure, Chapter>> getChapterById({
    required String subjectId,
    required String chapterId,
  }) async => Left(CacheFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, List<Video>>> getVideos({
    required String subjectId,
    required String chapterId,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<Video>>> getVideosByTopic({
    required String subjectId,
    required String chapterId,
    required String topicId,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<Video>>> searchVideos({
    required String query,
    String? difficulty,
    String? language,
    List<String>? examRelevance,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<Video>>> getFilteredVideos({
    String? subjectId,
    String? chapterId,
    String? topicId,
    String? difficulty,
    String? language,
    List<String>? examRelevance,
    List<String>? tags,
  }) async => const Right([]);

  @override
  Future<Either<Failure, UnifiedSearchResults>> searchContent({
    required String query,
    String? subjectFilter,
    String? difficulty,
    int maxResultsPerType = 10,
  }) async => Right(UnifiedSearchResults(
    query: query,
    results: const [],
    totalCount: 0,
  ));

  @override
  Future<Either<Failure, List<Subject>>> getAllSubjects() async =>
      const Right([]);
}

/// Mock video data for testing
class MockVideoData {
  static Video createVideo({
    String id = 'test-video-id',
    String youtubeId = 'test-video-id',
    String title = 'Test Video',
    String description = 'Test video description',
    String channelName = 'Test Channel',
    String channelId = 'test-channel-id',
    String thumbnailUrl = 'https://example.com/thumb.jpg',
    String youtubeUrl = 'https://youtube.com/watch?v=test-video-id',
    int duration = 600,
    String durationDisplay = '10:00',
    String language = 'English',
    String topicId = 'topic-1',
    String difficulty = 'basic',
    List<String> examRelevance = const ['CBSE'],
    double rating = 4.5,
    int viewCount = 1000,
    List<String> tags = const ['test'],
    DateTime? dateAdded,
    DateTime? lastUpdated,
  }) {
    final now = DateTime.now();
    return Video(
      id: id,
      title: title,
      description: description,
      youtubeId: youtubeId,
      youtubeUrl: youtubeUrl,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      durationDisplay: durationDisplay,
      channelName: channelName,
      channelId: channelId,
      language: language,
      topicId: topicId,
      difficulty: difficulty,
      examRelevance: examRelevance,
      rating: rating,
      viewCount: viewCount,
      tags: tags,
      dateAdded: dateAdded ?? now,
      lastUpdated: lastUpdated ?? now,
    );
  }
}

// ============================================================================
// QUIZ MOCK USE CASES
// ============================================================================

/// Mock LoadQuizUseCase
class MockLoadQuizUseCase implements LoadQuizUseCase {
  Either<Failure, QuizSession>? _result;
  LoadQuizParams? lastParams;
  int callCount = 0;

  @override
  QuizRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, QuizSession> result) {
    _result = result;
  }

  void setSuccess(QuizSession session) {
    _result = Right(session);
  }

  void setFailure(String message) {
    _result = Left(CacheFailure(message: message));
  }

  @override
  Future<Either<Failure, QuizSession>> call(LoadQuizParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? Left(CacheFailure(message: 'No mock result set'));
  }
}

/// Mock SubmitAnswerUseCase
class MockSubmitAnswerUseCase implements SubmitAnswerUseCase {
  Either<Failure, QuizSession>? _result;
  SubmitAnswerParams? lastParams;
  int callCount = 0;

  @override
  QuizRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, QuizSession> result) {
    _result = result;
  }

  void setSuccess(QuizSession session) {
    _result = Right(session);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, QuizSession>> call(SubmitAnswerParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? Left(DatabaseFailure(message: 'No mock result set'));
  }
}

/// Mock CompleteQuizUseCase
class MockCompleteQuizUseCase implements CompleteQuizUseCase {
  Either<Failure, QuizResult>? _result;
  CompleteQuizParams? lastParams;
  int callCount = 0;

  @override
  QuizRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, QuizResult> result) {
    _result = result;
  }

  void setSuccess(QuizResult result) {
    _result = Right(result);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, QuizResult>> call(CompleteQuizParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? Left(DatabaseFailure(message: 'No mock result set'));
  }
}

/// Mock ResumeSessionUseCase
class MockResumeSessionUseCase implements ResumeSessionUseCase {
  Either<Failure, QuizSession>? _result;
  ResumeSessionParams? lastParams;
  int callCount = 0;

  @override
  QuizRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, QuizSession> result) {
    _result = result;
  }

  void setSuccess(QuizSession session) {
    _result = Right(session);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, QuizSession>> call(ResumeSessionParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? Left(DatabaseFailure(message: 'No mock result set'));
  }
}

/// Mock GetQuizHistoryUseCase
class MockGetQuizHistoryUseCase implements GetQuizHistoryUseCase {
  Either<Failure, List<QuizAttempt>>? _result;
  GetQuizHistoryParams? lastParams;
  int callCount = 0;

  @override
  QuizRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, List<QuizAttempt>> result) {
    _result = result;
  }

  void setSuccess(List<QuizAttempt> history) {
    _result = Right(history);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, List<QuizAttempt>>> call(GetQuizHistoryParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? const Right([]);
  }
}

/// Mock GetActiveSessionUseCase
class MockGetActiveSessionUseCase implements GetActiveSessionUseCase {
  Either<Failure, QuizSession?>? _result;
  GetActiveSessionParams? lastParams;
  int callCount = 0;

  @override
  QuizRepository get repository => throw UnimplementedError('Mock does not use repository');

  void setResult(Either<Failure, QuizSession?> result) {
    _result = result;
  }

  void setSuccess(QuizSession? session) {
    _result = Right(session);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, QuizSession?>> call(GetActiveSessionParams params) async {
    callCount++;
    lastParams = params;
    return _result ?? const Right(null);
  }
}

/// Mock QuizRepository
class MockQuizRepository implements QuizRepository {
  Either<Failure, QuizSession>? _clearAllAnswersResult;

  void setClearAllAnswersResult(Either<Failure, QuizSession> result) {
    _clearAllAnswersResult = result;
  }

  void setClearAllAnswersSuccess(QuizSession session) {
    _clearAllAnswersResult = Right(session);
  }

  void setClearAllAnswersFailure(String message) {
    _clearAllAnswersResult = Left(DatabaseFailure(message: message));
  }

  @override
  Future<Either<Failure, QuizSession>> clearAllAnswers(String sessionId) async {
    return _clearAllAnswersResult ?? Left(DatabaseFailure(message: 'No mock result set'));
  }

  // Stub implementations for other interface methods
  @override
  Future<Either<Failure, QuizSession>> loadQuiz({
    required String entityId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  }) async => Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, QuizSession>> loadQuizById({
    required String quizId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  }) async => Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, QuizSession>> submitAnswer({
    required String sessionId,
    required String questionId,
    required String answer,
    int? currentQuestionIndex,
  }) async => Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, QuizResult>> completeQuiz(String sessionId) async =>
      Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, QuizSession>> resumeSession(String sessionId) async =>
      Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, QuizSession>> pauseSession(String sessionId) async =>
      Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, List<QuizAttempt>>> getAttemptHistory({
    required String studentId,
    String? entityId,
    int? limit,
  }) async => const Right([]);

  @override
  Future<Either<Failure, List<QuizAttempt>>> getQuizHistory({
    required String studentId,
    QuizFilters? filters,
    int? limit,
    int? offset,
  }) async => const Right([]);

  @override
  Future<Either<Failure, QuizSession?>> getActiveSession(String studentId) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteSession(String sessionId) async =>
      const Right(null);

  @override
  Future<Either<Failure, Quiz?>> getQuizByEntityId(String entityId) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevel(QuizLevel level) async =>
      const Right([]);

  @override
  Future<Either<Failure, List<Quiz>>> getQuizzesByLevelAndEntity(
    QuizLevel level,
    String entityId,
  ) async => const Right([]);

  @override
  Future<Either<Failure, QuizStatistics>> getQuizStatistics(String studentId) async =>
      Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, SubjectStatistics>> getSubjectStatistics(
    String studentId,
    String subjectId,
  ) async => Left(DatabaseFailure(message: 'Not implemented'));

  @override
  Future<Either<Failure, List<QuizAttempt>>> getRecentQuizzes(
    String studentId, {
    int limit = 10,
  }) async => const Right([]);

  @override
  Future<Either<Failure, Map<DateTime, int>>> getQuizStreakData(
    String studentId,
  ) async => const Right({});

  @override
  Future<Either<Failure, Map<String, double>>> getScoreTrendData(
    String studentId, {
    required int days,
  }) async => const Right({});

  @override
  Future<Either<Failure, Map<QuizLevel, double>>> getPerformanceByLevel(
    String studentId,
  ) async => const Right({});

  @override
  Future<Either<Failure, int>> getQuizHistoryCount({
    required String studentId,
    QuizFilters? filters,
  }) async => const Right(0);
}

/// Mock SharedPreferences for testing UserProfileNotifier
class MockSharedPreferences {
  final Map<String, dynamic> _store = {};

  String? getString(String key) => _store[key] as String?;

  bool? getBool(String key) => _store[key] as bool?;

  int? getInt(String key) => _store[key] as int?;

  double? getDouble(String key) => _store[key] as double?;

  List<String>? getStringList(String key) => _store[key] as List<String>?;

  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  Future<bool> setBool(String key, bool value) async {
    _store[key] = value;
    return true;
  }

  Future<bool> setInt(String key, int value) async {
    _store[key] = value;
    return true;
  }

  Future<bool> setDouble(String key, double value) async {
    _store[key] = value;
    return true;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    _store[key] = value;
    return true;
  }

  Future<bool> remove(String key) async {
    _store.remove(key);
    return true;
  }

  Future<bool> clear() async {
    _store.clear();
    return true;
  }

  bool containsKey(String key) => _store.containsKey(key);

  Set<String> getKeys() => _store.keys.toSet();

  /// For testing purposes - get the internal store
  Map<String, dynamic> get store => _store;
}

/// Mock BookmarkDao for testing BookmarkRepository
class MockBookmarkDao implements BookmarkDao {
  final List<BookmarkModel> _bookmarks = [];
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(BookmarkModel bookmark) async {
    _checkException();

    // Check for duplicate
    if (_bookmarks.any((b) => b.id == bookmark.id)) {
      throw DuplicateException(
        message: 'Bookmark already exists',
        entityType: 'Bookmark',
        duplicateKey: bookmark.id,
      );
    }

    _bookmarks.add(bookmark);
  }

  @override
  Future<void> deleteByVideoId(String videoId, {String? profileId}) async {
    _checkException();

    final found = _bookmarks.where((b) {
      if (profileId != null) {
        return b.videoId == videoId && b.profileId == profileId;
      }
      return b.videoId == videoId;
    }).toList();

    if (found.isEmpty) {
      throw NotFoundException(
        message: 'Bookmark not found',
        entityType: 'Bookmark',
        entityId: videoId,
      );
    }

    _bookmarks.removeWhere((b) {
      if (profileId != null) {
        return b.videoId == videoId && b.profileId == profileId;
      }
      return b.videoId == videoId;
    });
  }

  @override
  Future<List<BookmarkModel>> getAll({String? profileId}) async {
    _checkException();

    if (profileId != null) {
      return _bookmarks
          .where((b) => b.profileId == profileId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return List.from(_bookmarks)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<bool> isBookmarked(String videoId, {String? profileId}) async {
    _checkException();

    return _bookmarks.any((b) {
      if (profileId != null) {
        return b.videoId == videoId && b.profileId == profileId;
      }
      return b.videoId == videoId;
    });
  }

  @override
  Future<BookmarkModel?> getByVideoId(String videoId, {String? profileId}) async {
    _checkException();

    try {
      return _bookmarks.firstWhere((b) {
        if (profileId != null) {
          return b.videoId == videoId && b.profileId == profileId;
        }
        return b.videoId == videoId;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> getCount({String? profileId}) async {
    _checkException();

    if (profileId != null) {
      return _bookmarks.where((b) => b.profileId == profileId).length;
    }
    return _bookmarks.length;
  }

  @override
  Future<void> deleteAll() async {
    _checkException();
    _bookmarks.clear();
  }

  @override
  Future<List<BookmarkModel>> getRecent(int limit, {String? profileId}) async {
    _checkException();

    final filtered = profileId != null
        ? _bookmarks.where((b) => b.profileId == profileId).toList()
        : List.from(_bookmarks);

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List<BookmarkModel>.from(filtered.take(limit));
  }

  @override
  Future<void> deleteAllForProfile(String profileId) async {
    _checkException();
    _bookmarks.removeWhere((b) => b.profileId == profileId);
  }

  // Helper methods for testing
  void clear() {
    _bookmarks.clear();
    _nextException = null;
  }

  List<BookmarkModel> get all => List.from(_bookmarks);

  // BaseDao method stubs (required since BookmarkDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock NoteDao for testing NoteRepository
class MockNoteDao implements NoteDao {
  final List<NoteModel> _notes = [];
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(NoteModel note) async {
    _checkException();
    _notes.add(note);
  }

  @override
  Future<void> update(NoteModel note) async {
    _checkException();

    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) {
      throw NotFoundException(
        message: 'Note not found',
        entityType: 'Note',
        entityId: note.id,
      );
    }

    _notes[index] = note;
  }

  @override
  Future<void> delete(String noteId) async {
    _checkException();

    final found = _notes.any((n) => n.id == noteId);
    if (!found) {
      throw NotFoundException(
        message: 'Note not found',
        entityType: 'Note',
        entityId: noteId,
      );
    }

    _notes.removeWhere((n) => n.id == noteId);
  }

  @override
  Future<List<NoteModel>> getAllByVideoId(String videoId, {String? profileId}) async {
    _checkException();

    return _notes.where((n) {
      if (profileId != null) {
        return n.videoId == videoId && n.profileId == profileId;
      }
      return n.videoId == videoId;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<NoteModel>> getAll({String? profileId}) async {
    _checkException();

    if (profileId != null) {
      return _notes
          .where((n) => n.profileId == profileId)
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return List.from(_notes)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<NoteModel?> getById(String noteId) async {
    _checkException();

    try {
      return _notes.firstWhere((n) => n.id == noteId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> getCount({String? profileId}) async {
    _checkException();

    if (profileId != null) {
      return _notes.where((n) => n.profileId == profileId).length;
    }
    return _notes.length;
  }

  @override
  Future<int> getCountByVideoId(String videoId, {String? profileId}) async {
    _checkException();

    return _notes.where((n) {
      if (profileId != null) {
        return n.videoId == videoId && n.profileId == profileId;
      }
      return n.videoId == videoId;
    }).length;
  }

  @override
  Future<List<NoteModel>> searchByContent(String query, {String? profileId}) async {
    _checkException();

    final lowerQuery = query.toLowerCase();
    return _notes.where((n) {
      final matchesProfile = profileId == null || n.profileId == profileId;
      final matchesContent = n.content.toLowerCase().contains(lowerQuery);
      return matchesProfile && matchesContent;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<NoteModel>> getRecent(int limit, {String? profileId}) async {
    _checkException();

    final filtered = profileId != null
        ? _notes.where((n) => n.profileId == profileId).toList()
        : List.from(_notes);

    filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List<NoteModel>.from(filtered.take(limit));
  }

  @override
  Future<void> deleteByVideoId(String videoId, {String? profileId}) async {
    _checkException();

    _notes.removeWhere((n) {
      if (profileId != null) {
        return n.videoId == videoId && n.profileId == profileId;
      }
      return n.videoId == videoId;
    });
  }

  @override
  Future<void> deleteAll() async {
    _checkException();
    _notes.clear();
  }

  @override
  Future<void> deleteAllForProfile(String profileId) async {
    _checkException();
    _notes.removeWhere((n) => n.profileId == profileId);
  }

  // Helper methods for testing
  void clear() {
    _notes.clear();
    _nextException = null;
  }

  List<NoteModel> get all => List.from(_notes);

  // BaseDao method stubs (required since NoteDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock CollectionDao for testing
class MockCollectionDao implements CollectionDao {
  final List<CollectionModel> _collections = [];
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(CollectionModel collection) async {
    _checkException();
    _collections.add(collection);
  }

  @override
  Future<void> update(CollectionModel collection) async {
    _checkException();
    final index = _collections.indexWhere((c) => c.id == collection.id);
    if (index == -1) {
      throw NotFoundException(
        message: 'Collection not found',
        entityType: 'Collection',
        entityId: collection.id,
      );
    }
    _collections[index] = collection;
  }

  @override
  Future<void> delete(String collectionId) async {
    _checkException();
    final index = _collections.indexWhere((c) => c.id == collectionId);
    if (index == -1) {
      throw NotFoundException(
        message: 'Collection not found',
        entityType: 'Collection',
        entityId: collectionId,
      );
    }
    _collections.removeAt(index);
  }

  @override
  Future<CollectionModel?> getById(String collectionId, {String? profileId}) async {
    _checkException();
    try {
      return _collections.firstWhere((c) {
        if (profileId != null) {
          return c.id == collectionId && c.profileId == profileId;
        }
        return c.id == collectionId;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CollectionModel>> getAll({String? profileId}) async {
    _checkException();
    if (profileId != null) {
      return _collections
          .where((c) => c.profileId == profileId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return List.from(_collections)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<int> getCount({String? profileId}) async {
    _checkException();
    if (profileId != null) {
      return _collections.where((c) => c.profileId == profileId).length;
    }
    return _collections.length;
  }

  @override
  Future<void> deleteAllForProfile(String profileId) async {
    _checkException();
    _collections.removeWhere((c) => c.profileId == profileId);
  }

  @override
  Future<void> deleteAll() async {
    _checkException();
    _collections.clear();
  }

  // Helper methods for testing
  void clear() {
    _collections.clear();
    _nextException = null;
  }

  List<CollectionModel> get all => List.from(_collections);

  // BaseDao method stubs (required since CollectionDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock CollectionVideoDao for testing
class MockCollectionVideoDao implements CollectionVideoDao {
  final List<CollectionVideoModel> _collectionVideos = [];
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(CollectionVideoModel video) async {
    _checkException();
    _collectionVideos.add(video);
  }

  @override
  Future<void> deleteByCollectionAndVideo(String collectionId, String videoId) async {
    _checkException();
    final found = _collectionVideos.where(
      (cv) => cv.collectionId == collectionId && cv.videoId == videoId,
    );

    if (found.isEmpty) {
      throw NotFoundException(
        message: 'Video not found in collection',
        entityType: 'CollectionVideo',
        entityId: '$collectionId-$videoId',
      );
    }

    _collectionVideos.removeWhere(
      (cv) => cv.collectionId == collectionId && cv.videoId == videoId,
    );
  }

  @override
  Future<List<CollectionVideoModel>> getByCollectionId(String collectionId) async {
    _checkException();
    return _collectionVideos
        .where((cv) => cv.collectionId == collectionId)
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  @override
  Future<List<CollectionVideoModel>> getCollectionsForVideo(String videoId) async {
    _checkException();
    return _collectionVideos
        .where((cv) => cv.videoId == videoId)
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  @override
  Future<bool> isVideoInCollection(String collectionId, String videoId) async {
    _checkException();
    return _collectionVideos.any(
      (cv) => cv.collectionId == collectionId && cv.videoId == videoId,
    );
  }

  @override
  Future<int> getTotalVideosCount() async {
    _checkException();
    return _collectionVideos.length;
  }

  @override
  Future<int> getVideoCountForCollection(String collectionId) async {
    _checkException();
    return _collectionVideos.where((cv) => cv.collectionId == collectionId).length;
  }

  @override
  Future<void> deleteByCollectionId(String collectionId) async {
    _checkException();
    _collectionVideos.removeWhere((cv) => cv.collectionId == collectionId);
  }

  @override
  Future<void> deleteAll() async {
    _checkException();
    _collectionVideos.clear();
  }

  // Helper methods for testing
  void clear() {
    _collectionVideos.clear();
    _nextException = null;
  }

  List<CollectionVideoModel> get all => List.from(_collectionVideos);

  // BaseDao method stubs (required since CollectionVideoDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock PreferenceDao for testing
class MockPreferenceDao implements PreferenceDao {
  final Map<String, PreferenceModel> _preferences = {};
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> save(PreferenceModel preference) async {
    _checkException();
    _preferences[preference.key] = preference;
  }

  @override
  Future<PreferenceModel?> getByKey(String key) async {
    _checkException();
    return _preferences[key];
  }

  @override
  Future<List<PreferenceModel>> getAll() async {
    _checkException();
    final list = _preferences.values.toList();
    list.sort((a, b) => a.key.compareTo(b.key));
    return list;
  }

  @override
  Future<void> delete(String key) async {
    _checkException();
    if (!_preferences.containsKey(key)) {
      throw NotFoundException(
        message: 'Preference not found',
        entityType: 'Preference',
        entityId: key,
      );
    }
    _preferences.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _checkException();
    _preferences.clear();
  }

  @override
  Future<bool> exists(String key) async {
    _checkException();
    return _preferences.containsKey(key);
  }

  // Helper methods for testing
  void clear() {
    _preferences.clear();
    _nextException = null;
  }

  Map<String, PreferenceModel> get all => Map.from(_preferences);

  // BaseDao method stubs (required since PreferenceDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock RecommendationsHistoryDao for testing
class MockRecommendationsHistoryDao implements RecommendationsHistoryDao {
  final Map<String, RecommendationsHistory> _histories = {};
  final Map<String, RecommendationsHistory> _byQuizAttempt = {};
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(RecommendationsHistory history) async {
    _checkException();
    _histories[history.id] = history;
    _byQuizAttempt[history.quizAttemptId] = history;
  }

  @override
  Future<void> update(RecommendationsHistory history) async {
    _checkException();
    _histories[history.id] = history;
    _byQuizAttempt[history.quizAttemptId] = history;
  }

  @override
  Future<RecommendationsHistory?> getByQuizAttempt(String quizAttemptId) async {
    _checkException();
    return _byQuizAttempt[quizAttemptId];
  }

  @override
  Future<RecommendationsHistory?> getById(String id) async {
    _checkException();
    return _histories[id];
  }

  @override
  Future<List<RecommendationsHistory>> getFiltered({
    required String userId,
    AssessmentType? assessmentType,
    String? subjectId,
    bool? hasRecommendations,
    int limit = 50,
    int offset = 0,
  }) async {
    _checkException();

    var filtered = _histories.values.where((h) => h.userId == userId);

    if (assessmentType != null) {
      filtered = filtered.where((h) => h.assessmentType == assessmentType);
    }

    if (subjectId != null) {
      filtered = filtered.where((h) => h.subjectId == subjectId);
    }

    if (hasRecommendations == true) {
      filtered = filtered.where((h) => h.totalRecommendations > 0);
    }

    final sorted = filtered.toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));

    final start = offset;
    final end = (offset + limit).clamp(0, sorted.length);

    return sorted.sublist(start, end);
  }

  @override
  Future<void> markAsViewed(String id) async {
    _checkException();
    final history = _histories[id];
    if (history != null) {
      final now = DateTime.now();
      final updated = history.copyWith(
        viewedAt: now,
        lastAccessedAt: now,
        viewCount: history.viewCount + 1,
      );
      _histories[id] = updated;
      _byQuizAttempt[updated.quizAttemptId] = updated;
    }
  }

  @override
  Future<void> updateLearningPathStatus({
    required String id,
    String? learningPathId,
    bool? started,
    bool? completed,
  }) async {
    _checkException();
    final history = _histories[id];
    if (history != null) {
      final now = DateTime.now();
      final updated = history.copyWith(
        learningPathId: learningPathId ?? history.learningPathId,
        learningPathStarted: started ?? history.learningPathStarted,
        learningPathStartedAt: started == true ? now : history.learningPathStartedAt,
        learningPathCompleted: completed ?? history.learningPathCompleted,
        learningPathCompletedAt: completed == true ? now : history.learningPathCompletedAt,
      );
      _histories[id] = updated;
      _byQuizAttempt[updated.quizAttemptId] = updated;
    }
  }

  @override
  Future<void> trackVideoViewed(String id, String videoId) async {
    _checkException();
    final history = _histories[id];
    if (history != null) {
      final viewedVideos = List<String>.from(history.viewedVideoIds);
      if (!viewedVideos.contains(videoId)) {
        viewedVideos.add(videoId);
        final updated = history.copyWith(viewedVideoIds: viewedVideos);
        _histories[id] = updated;
        _byQuizAttempt[updated.quizAttemptId] = updated;
      }
    }
  }

  @override
  Future<void> dismissRecommendation(String id, String conceptId) async {
    _checkException();
    final history = _histories[id];
    if (history != null) {
      final dismissed = List<String>.from(history.dismissedRecommendationIds);
      if (!dismissed.contains(conceptId)) {
        dismissed.add(conceptId);
        final updated = history.copyWith(dismissedRecommendationIds: dismissed);
        _histories[id] = updated;
        _byQuizAttempt[updated.quizAttemptId] = updated;
      }
    }
  }

  @override
  Future<int> deleteOlderThan({int daysOld = 90}) async {
    _checkException();
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final toDelete = _histories.values
        .where((h) => h.generatedAt.isBefore(cutoffDate))
        .map((h) => h.id)
        .toList();

    for (final id in toDelete) {
      final history = _histories[id];
      if (history != null) {
        _histories.remove(id);
        _byQuizAttempt.remove(history.quizAttemptId);
      }
    }

    return toDelete.length;
  }

  // Helper methods for testing
  void clear() {
    _histories.clear();
    _byQuizAttempt.clear();
    _nextException = null;
  }

  Map<String, RecommendationsHistory> get all => Map.from(_histories);
  int get count => _histories.length;

  // BaseDao method stubs (required since RecommendationsHistoryDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock LearningPathDao for testing
class MockLearningPathDao implements LearningPathDao {
  final Map<String, LearningPathModel> _paths = {};
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(LearningPathModel path) async {
    _checkException();
    _paths[path.id] = path;
  }

  @override
  Future<void> update(LearningPathModel path) async {
    _checkException();
    _paths[path.id] = path;
  }

  @override
  Future<LearningPathModel?> getById(String id) async {
    _checkException();
    return _paths[id];
  }

  @override
  Future<List<LearningPathModel>> getByStudent({
    required String studentId,
    String? status,
  }) async {
    _checkException();
    var filtered = _paths.values.where((p) => p.studentId == studentId);

    if (status != null) {
      filtered = filtered.where((p) => p.status == status);
    }

    // Sort by last updated descending
    final sorted = filtered.toList()
      ..sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));

    return sorted;
  }

  @override
  Future<LearningPathModel?> getActivePathForSubject({
    required String studentId,
    required String subjectId,
  }) async {
    _checkException();
    final paths = _paths.values
        .where((p) =>
            p.studentId == studentId &&
            p.subjectId == subjectId &&
            p.status == 'active')
        .toList();

    if (paths.isEmpty) return null;

    // Sort by last updated and return most recent
    paths.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    return paths.first;
  }

  @override
  Future<void> updateNodeCompletion({
    required String pathId,
    required String nodeId,
    required bool completed,
    DateTime? completedAt,
    double? scorePercentage,
  }) async {
    _checkException();

    final path = _paths[pathId];
    if (path == null) {
      throw Exception('Learning path not found: $pathId');
    }

    // Parse and update nodes
    final nodesList = jsonDecode(path.nodesJson) as List<dynamic>;
    bool nodeFound = false;

    for (var i = 0; i < nodesList.length; i++) {
      final node = nodesList[i] as Map<String, dynamic>;
      if (node['id'] == nodeId) {
        node['completed'] = completed;
        if (completedAt != null) {
          node['completedAt'] = completedAt.millisecondsSinceEpoch;
        }
        if (scorePercentage != null) {
          node['scorePercentage'] = scorePercentage;
        }
        nodeFound = true;
        break;
      }
    }

    if (!nodeFound) {
      throw Exception('Node not found in path: $nodeId');
    }

    // Update completed node IDs
    final completedIds = (jsonDecode(path.completedNodeIds) as List<dynamic>)
        .map((e) => e as String)
        .toList();

    if (completed && !completedIds.contains(nodeId)) {
      completedIds.add(nodeId);
    } else if (!completed && completedIds.contains(nodeId)) {
      completedIds.remove(nodeId);
    }

    // Create updated model
    final updatedPath = LearningPathModel(
      id: path.id,
      studentId: path.studentId,
      subjectId: path.subjectId,
      targetConceptId: path.targetConceptId,
      nodesJson: jsonEncode(nodesList),
      currentNodeIndex: path.currentNodeIndex,
      completedNodeIds: jsonEncode(completedIds),
      status: path.status,
      createdAt: path.createdAt,
      lastUpdatedAt: DateTime.now().millisecondsSinceEpoch,
      completedAt: path.completedAt,
      metadataJson: path.metadataJson,
    );

    _paths[pathId] = updatedPath;
  }

  @override
  Future<void> updatePathStatus(String pathId, PathStatus status) async {
    _checkException();

    final path = _paths[pathId];
    if (path == null) return;

    final updatedPath = LearningPathModel(
      id: path.id,
      studentId: path.studentId,
      subjectId: path.subjectId,
      targetConceptId: path.targetConceptId,
      nodesJson: path.nodesJson,
      currentNodeIndex: path.currentNodeIndex,
      completedNodeIds: path.completedNodeIds,
      status: status.name,
      createdAt: path.createdAt,
      lastUpdatedAt: DateTime.now().millisecondsSinceEpoch,
      completedAt: path.completedAt,
      metadataJson: path.metadataJson,
    );

    _paths[pathId] = updatedPath;
  }

  @override
  Future<void> markCompleted(String pathId) async {
    _checkException();

    final path = _paths[pathId];
    if (path == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final updatedPath = LearningPathModel(
      id: path.id,
      studentId: path.studentId,
      subjectId: path.subjectId,
      targetConceptId: path.targetConceptId,
      nodesJson: path.nodesJson,
      currentNodeIndex: path.currentNodeIndex,
      completedNodeIds: path.completedNodeIds,
      status: PathStatus.completed.name,
      createdAt: path.createdAt,
      lastUpdatedAt: now,
      completedAt: now,
      metadataJson: path.metadataJson,
    );

    _paths[pathId] = updatedPath;
  }

  @override
  Future<void> delete(String id) async {
    _checkException();
    _paths.remove(id);
  }

  // Helper methods for testing
  void clear() {
    _paths.clear();
    _nextException = null;
  }

  Map<String, LearningPathModel> get all => Map.from(_paths);
  int get count => _paths.length;

  // BaseDao method stubs (required since LearningPathDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock ProgressDao for testing
class MockProgressDao implements ProgressDao {
  final Map<String, ProgressModel> _progressRecords = {};
  Exception? _nextException;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  @override
  Future<void> insert(ProgressModel progress) async {
    _checkException();
    _progressRecords[progress.id] = progress;
  }

  @override
  Future<void> update(ProgressModel progress) async {
    _checkException();
    if (!_progressRecords.containsKey(progress.id)) {
      throw NotFoundException(
        message: 'Progress not found',
        entityType: 'Progress',
        entityId: progress.id,
      );
    }
    _progressRecords[progress.id] = progress;
  }

  @override
  Future<ProgressModel?> getByVideoId(String videoId, {String? profileId}) async {
    _checkException();
    try {
      return _progressRecords.values.firstWhere(
        (p) => p.videoId == videoId && (profileId == null || p.profileId == profileId),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProgressModel>> getInProgress({String? profileId}) async {
    _checkException();
    return _progressRecords.values
        .where((p) => !p.completed && (profileId == null || p.profileId == profileId))
        .toList();
  }

  @override
  Future<List<ProgressModel>> getCompleted({String? profileId}) async {
    _checkException();
    return _progressRecords.values
        .where((p) => p.completed && (profileId == null || p.profileId == profileId))
        .toList();
  }

  @override
  Future<List<ProgressModel>> getRecent(int limit, {String? profileId}) async {
    _checkException();
    final filtered = _progressRecords.values
        .where((p) => profileId == null || p.profileId == profileId)
        .toList();
    filtered.sort((a, b) => b.lastWatched.compareTo(a.lastWatched));
    return filtered.take(limit).toList();
  }

  @override
  Future<List<ProgressModel>> getAll({String? profileId}) async {
    _checkException();
    final filtered = _progressRecords.values
        .where((p) => profileId == null || p.profileId == profileId)
        .toList();
    filtered.sort((a, b) => b.lastWatched.compareTo(a.lastWatched));
    return filtered;
  }

  @override
  Future<List<ProgressModel>> getRecentlyWatched({String? profileId}) async {
    _checkException();
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _progressRecords.values
        .where((p) =>
            DateTime.fromMillisecondsSinceEpoch(p.lastWatched).isAfter(sevenDaysAgo) &&
            (profileId == null || p.profileId == profileId))
        .toList();
  }

  @override
  Future<void> delete(String videoId, {String? profileId}) async {
    _checkException();
    final key = _progressRecords.keys.firstWhere(
      (k) {
        final p = _progressRecords[k]!;
        return p.videoId == videoId && (profileId == null || p.profileId == profileId);
      },
      orElse: () => throw NotFoundException(
        message: 'Progress not found',
        entityType: 'Progress',
        entityId: videoId,
      ),
    );
    _progressRecords.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _checkException();
    _progressRecords.clear();
  }

  @override
  Future<void> deleteAllForProfile(String profileId) async {
    _checkException();
    _progressRecords.removeWhere((key, value) => value.profileId == profileId);
  }

  @override
  Future<int> getTotalWatchTime({String? profileId}) async {
    _checkException();
    return _progressRecords.values
        .where((p) => profileId == null || p.profileId == profileId)
        .fold<int>(0, (sum, p) => sum + p.watchDuration);
  }

  @override
  Future<Map<String, dynamic>> getStatistics({String? profileId}) async {
    _checkException();
    final filtered = _progressRecords.values
        .where((p) => profileId == null || p.profileId == profileId)
        .toList();

    final totalVideos = filtered.length;
    final completed = filtered.where((p) => p.completed).length;
    final inProgress = filtered.where((p) => !p.completed).length;
    final totalWatchTime = filtered.fold<int>(0, (sum, p) => sum + p.watchDuration);

    double avgCompletionRate = 0.0;
    if (filtered.isNotEmpty) {
      final totalCompletionSum = filtered.fold<double>(
        0.0,
        (sum, p) => sum + (p.totalDuration > 0 ? p.watchDuration / p.totalDuration : 0.0),
      );
      avgCompletionRate = totalCompletionSum / filtered.length;
    }

    return {
      'totalVideosWatched': totalVideos,
      'completedVideos': completed,
      'inProgressVideos': inProgress,
      'totalWatchTimeSeconds': totalWatchTime,
      'avgCompletionRate': avgCompletionRate,
    };
  }

  // Helper methods for testing
  void clear() {
    _progressRecords.clear();
    _nextException = null;
  }

  Map<String, ProgressModel> get all => Map.from(_progressRecords);
  int get count => _progressRecords.length;

  // BaseDao method stubs (required since ProgressDao extends BaseDao)
  @override
  DatabaseHelper get dbHelper => throw UnimplementedError('Mock does not use dbHelper');

  @override
  Future<int> insertRow({
    required String table,
    required Map<String, dynamic> values,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use insertRow directly');

  @override
  Future<int> updateRows({
    required String table,
    required Map<String, dynamic> values,
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.abort,
  }) async => throw UnimplementedError('Mock does not use updateRows directly');

  @override
  Future<int> deleteRows({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async => throw UnimplementedError('Mock does not use deleteRows directly');

  @override
  Future<List<Map<String, dynamic>>> queryRows({
    required String table,
    bool distinct = false,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async => throw UnimplementedError('Mock does not use queryRows directly');

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawQuery directly');

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawInsert directly');

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawUpdate directly');

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use rawDelete directly');

  @override
  Future<List<dynamic>> batch(
    void Function(BatchHelper batch) operations, {
    bool noResult = false,
  }) async => throw UnimplementedError('Mock does not use batch directly');

  @override
  Future<int?> firstIntValue(String sql, [List<dynamic>? arguments]) async =>
      throw UnimplementedError('Mock does not use firstIntValue directly');

  @override
  Future<T> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async => throw UnimplementedError('Mock does not use executeWithErrorHandling directly');

  @override
  Future<T> transaction<T>(Future<T> Function(TransactionHelper txn) action) async =>
      throw UnimplementedError('Mock does not use transaction directly');
}

/// Mock ContentJsonDataSource for testing
class MockContentJsonDataSource implements ContentJsonDataSource {
  final Map<String, BoardModel> _boards = {};
  final Map<String, SubjectModel> _subjects = {};
  final Map<String, List<VideoModel>> _videos = {};
  Exception? _nextException;

  @override
  final Map<String, BoardModel> _boardsCache = {};

  @override
  final Map<String, SubjectModel> _subjectsCache = {};

  @override
  final Map<String, List<VideoModel>> _videosCache = {};

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  // Add test data
  void addBoard(BoardModel board) {
    _boards[board.id] = board;
    _boardsCache[board.id] = board;
  }

  void addSubject(SubjectModel subject) {
    _subjects[subject.id] = subject;
    _subjectsCache[subject.id] = subject;
  }

  void addVideos(String subjectId, String chapterId, List<VideoModel> videos) {
    final key = '${subjectId}_$chapterId';
    _videos[key] = videos;
    _videosCache[key] = videos;
  }

  @override
  Future<List<BoardModel>> loadBoards() async {
    _checkException();
    return _boards.values.toList();
  }

  @override
  Future<BoardModel> loadBoardById(String boardId) async {
    _checkException();
    if (_boards.containsKey(boardId)) {
      return _boards[boardId]!;
    }
    throw NotFoundException(
      message: 'Board not found',
      entityType: 'Board',
      entityId: boardId,
    );
  }

  @override
  Future<SubjectModel> loadSubjectById(String subjectId) async {
    _checkException();
    if (_subjects.containsKey(subjectId)) {
      return _subjects[subjectId]!;
    }
    throw AssetNotFoundException(
      message: 'Subject not found',
      assetPath: 'subjects/$subjectId.json',
    );
  }

  @override
  Future<List<VideoModel>> loadVideos({
    required String subjectId,
    required String chapterId,
  }) async {
    _checkException();
    final key = '${subjectId}_$chapterId';
    if (_videos.containsKey(key)) {
      return _videos[key]!;
    }
    throw NotFoundException(
      message: 'Videos not found',
      entityType: 'Video',
      entityId: key,
    );
  }

  @override
  void clearCache() {
    _boardsCache.clear();
    _subjectsCache.clear();
    _videosCache.clear();
  }

  @override
  void clearBoardCache(String boardId) {
    _boardsCache.remove(boardId);
  }

  @override
  void clearSubjectCache(String subjectId) {
    _subjectsCache.remove(subjectId);
  }

  @override
  void clearVideosCache(String subjectId, String chapterId) {
    final key = '${subjectId}_$chapterId';
    _videosCache.remove(key);
  }

  // Helper methods for testing
  void clear() {
    _boards.clear();
    _subjects.clear();
    _videos.clear();
    _boardsCache.clear();
    _subjectsCache.clear();
    _videosCache.clear();
    _nextException = null;
  }

  int get boardCount => _boards.length;
  int get subjectCount => _subjects.length;
  int get videoGroupCount => _videos.length;
}
