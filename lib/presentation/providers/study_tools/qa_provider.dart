/// Riverpod providers for video Q&A (FAQs)
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/video_qa_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/database_helper.dart';
import 'package:crack_the_code/data/repositories/study_tools/qa_repository_impl.dart';
import 'package:crack_the_code/domain/entities/study_tools/video_question.dart';
import 'package:crack_the_code/domain/repositories/study_tools/qa_repository.dart';
import 'package:crack_the_code/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'qa_provider.g.dart';

/// Provider for VideoQADao
@riverpod
VideoQADao videoQADao(VideoQADaoRef ref) {
  return VideoQADao(DatabaseHelper());
}

/// Provider for QARepository
@riverpod
QARepository qaRepository(QaRepositoryRef ref) {
  final dao = ref.watch(videoQADaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return QARepositoryImpl(dao, jsonDataSource);
}

/// Notifier for managing video FAQs (read-only from JSON)
@riverpod
class VideoQuestions extends _$VideoQuestions {
  String? _subjectId;
  String? _chapterId;

  @override
  Future<List<VideoQuestion>> build(String videoId) async {
    final repository = ref.watch(qaRepositoryProvider) as QARepositoryImpl;

    // Set context for JSON lookup
    repository.subjectId = _subjectId;
    repository.chapterId = _chapterId;

    final result = await repository.getQuestionsByVideoId(videoId);

    return result.fold(
      (failure) => [],
      (questions) => questions,
    );
  }

  /// Set the subject and chapter IDs for JSON lookup
  void setContext({required String subjectId, required String chapterId}) {
    _subjectId = subjectId;
    _chapterId = chapterId;
  }

  /// Upvote a question
  Future<void> upvoteQuestion(String questionId) async {
    final repository = ref.read(qaRepositoryProvider);
    final result = await repository.upvoteQuestion(questionId);

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {
        // Update local state
        final current = state.valueOrNull ?? [];
        final updated = current.map((q) {
          if (q.id == questionId) {
            return q.copyWith(upvotes: q.upvotes + 1);
          }
          return q;
        }).toList();
        state = AsyncData(updated);
      },
    );
  }

  /// Refresh FAQs with context
  Future<void> refreshWithContext({
    required String subjectId,
    required String chapterId,
  }) async {
    _subjectId = subjectId;
    _chapterId = chapterId;

    state = const AsyncLoading();
    final repository = ref.read(qaRepositoryProvider) as QARepositoryImpl;

    repository.subjectId = subjectId;
    repository.chapterId = chapterId;

    final result = await repository.getQuestionsByVideoId(videoId);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (questions) => AsyncData(questions),
    );
  }

  /// Refresh FAQs
  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(qaRepositoryProvider) as QARepositoryImpl;

    repository.subjectId = _subjectId;
    repository.chapterId = _chapterId;

    final result = await repository.getQuestionsByVideoId(videoId);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (questions) => AsyncData(questions),
    );
  }
}

/// Provider for question count
@riverpod
Future<int> videoQuestionCount(
  VideoQuestionCountRef ref,
  String videoId, {
  String? subjectId,
  String? chapterId,
}) async {
  final repository = ref.watch(qaRepositoryProvider) as QARepositoryImpl;

  // Set context for JSON lookup
  repository.subjectId = subjectId;
  repository.chapterId = chapterId;

  final result = await repository.getQuestionCount(videoId);

  return result.fold(
    (failure) => 0,
    (count) => count,
  );
}
