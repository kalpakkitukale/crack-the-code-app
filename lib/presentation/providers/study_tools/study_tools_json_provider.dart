/// Riverpod providers for study tools JSON data source
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';

part 'study_tools_json_provider.g.dart';

/// Provider for StudyToolsJsonDataSource (singleton)
@Riverpod(keepAlive: true)
StudyToolsJsonDataSource studyToolsJsonDataSource(StudyToolsJsonDataSourceRef ref) {
  return StudyToolsJsonDataSource();
}

/// Provider to preload all study tools for a chapter
@riverpod
Future<void> preloadChapterStudyTools(
  PreloadChapterStudyToolsRef ref,
  String subjectId,
  String chapterId,
) async {
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  final segment = SegmentConfig.current.name;

  await jsonDataSource.preloadChapter(
    subjectId: subjectId,
    chapterId: chapterId,
    segment: segment,
  );
}

/// Provider to get cache statistics
@riverpod
Map<String, int> studyToolsCacheStats(StudyToolsCacheStatsRef ref) {
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return jsonDataSource.getCacheStats();
}
