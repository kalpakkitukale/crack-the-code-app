/// Riverpod providers for chapter summaries
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/local/database/dao/chapter_summary_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/study_tools/chapter_summary_repository_impl.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_summary.dart';
import 'package:streamshaala/domain/repositories/study_tools/chapter_summary_repository.dart';
import 'package:streamshaala/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'chapter_summary_provider.g.dart';

/// Provider for ChapterSummaryDao
@riverpod
ChapterSummaryDao chapterSummaryDao(ChapterSummaryDaoRef ref) {
  return ChapterSummaryDao(DatabaseHelper());
}

/// Provider for ChapterSummaryRepository
@riverpod
ChapterSummaryRepository chapterSummaryRepository(
    ChapterSummaryRepositoryRef ref) {
  final dao = ref.watch(chapterSummaryDaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return ChapterSummaryRepositoryImpl(dao, jsonDataSource);
}

/// Provider for chapter summary by chapter ID and subject ID
@riverpod
Future<ChapterSummary?> chapterSummary(
  ChapterSummaryRef ref,
  String chapterId,
  String subjectId,
) async {
  final repository = ref.watch(chapterSummaryRepositoryProvider);
  final segment = SegmentConfig.current.name;

  final result = await repository.getSummary(chapterId, subjectId, segment);
  return result.fold(
    (failure) => null,
    (summary) => summary,
  );
}

/// Provider to check if a chapter has a summary
@riverpod
Future<bool> hasChapterSummary(
  HasChapterSummaryRef ref,
  String chapterId,
  String subjectId,
) async {
  final repository = ref.watch(chapterSummaryRepositoryProvider);
  final segment = SegmentConfig.current.name;

  final result = await repository.hasSummary(chapterId, subjectId, segment);
  return result.fold(
    (failure) => false,
    (hasSummary) => hasSummary,
  );
}
