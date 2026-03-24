/// Riverpod providers for video summaries
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/local/database/dao/video_summary_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/study_tools/summary_repository_impl.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart';
import 'package:streamshaala/domain/repositories/study_tools/summary_repository.dart';
import 'package:streamshaala/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'summary_provider.g.dart';

/// Provider for VideoSummaryDao
@riverpod
VideoSummaryDao videoSummaryDao(VideoSummaryDaoRef ref) {
  return VideoSummaryDao(DatabaseHelper());
}

/// Provider for SummaryRepository
@riverpod
SummaryRepository summaryRepository(SummaryRepositoryRef ref) {
  final dao = ref.watch(videoSummaryDaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return SummaryRepositoryImpl(dao, jsonDataSource);
}

/// Provider for video summary by video ID with context
@riverpod
Future<VideoSummary?> videoSummary(
  VideoSummaryRef ref,
  String videoId, {
  String? subjectId,
  String? chapterId,
}) async {
  final repository = ref.watch(summaryRepositoryProvider) as SummaryRepositoryImpl;
  final segment = SegmentConfig.current.name;

  // Set context for JSON lookup
  repository.subjectId = subjectId;
  repository.chapterId = chapterId;

  final result = await repository.getSummary(videoId, segment);
  return result.fold(
    (failure) => null,
    (summary) => summary,
  );
}

/// Notifier for managing video summaries
@riverpod
class VideoSummaryNotifier extends _$VideoSummaryNotifier {
  String? _subjectId;
  String? _chapterId;

  @override
  Future<VideoSummary?> build(String videoId) async {
    final repository = ref.watch(summaryRepositoryProvider) as SummaryRepositoryImpl;
    final segment = SegmentConfig.current.name;

    // Set context for JSON lookup
    repository.subjectId = _subjectId;
    repository.chapterId = _chapterId;

    final result = await repository.getSummary(videoId, segment);
    return result.fold(
      (failure) => null,
      (summary) => summary,
    );
  }

  /// Set the subject and chapter IDs for JSON lookup
  void setContext({required String subjectId, required String chapterId}) {
    _subjectId = subjectId;
    _chapterId = chapterId;
  }

  /// Save a new summary
  Future<void> saveSummary(VideoSummary summary) async {
    final repository = ref.read(summaryRepositoryProvider);
    final result = await repository.saveSummary(summary);

    result.fold(
      (failure) => throw Exception(failure.message),
      (saved) => state = AsyncData(saved),
    );
  }

  /// Delete summary
  Future<void> deleteSummary() async {
    final repository = ref.read(summaryRepositoryProvider);
    final result = await repository.deleteSummary(videoId);

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => state = const AsyncData(null),
    );
  }

  /// Refresh summary with context
  Future<void> refreshWithContext({
    required String subjectId,
    required String chapterId,
  }) async {
    _subjectId = subjectId;
    _chapterId = chapterId;
    state = const AsyncLoading();

    final repository = ref.read(summaryRepositoryProvider) as SummaryRepositoryImpl;
    final segment = SegmentConfig.current.name;

    repository.subjectId = subjectId;
    repository.chapterId = chapterId;

    final result = await repository.getSummary(videoId, segment);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (summary) => AsyncData(summary),
    );
  }
}
