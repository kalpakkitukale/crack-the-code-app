/// Riverpod providers for mind maps
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/local/database/dao/mind_map_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/study_tools/mind_map_repository_impl.dart';
import 'package:streamshaala/domain/entities/study_tools/mind_map_node.dart';
import 'package:streamshaala/domain/repositories/study_tools/mind_map_repository.dart';
import 'package:streamshaala/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'mind_map_provider.g.dart';

/// Provider for MindMapDao
@riverpod
MindMapDao mindMapDao(MindMapDaoRef ref) {
  return MindMapDao(DatabaseHelper());
}

/// Provider for MindMapRepository
@riverpod
MindMapRepository mindMapRepository(MindMapRepositoryRef ref) {
  final dao = ref.watch(mindMapDaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return MindMapRepositoryImpl(dao, jsonDataSource);
}

/// Provider for mind map by chapter ID with subject context
@riverpod
Future<MindMap?> chapterMindMap(
  ChapterMindMapRef ref,
  String chapterId, {
  String? subjectId,
}) async {
  final repository = ref.watch(mindMapRepositoryProvider) as MindMapRepositoryImpl;
  final segment = SegmentConfig.current.name;

  // Set context for JSON lookup
  repository.subjectId = subjectId;

  final result = await repository.getMindMap(chapterId, segment);
  return result.fold(
    (failure) => null,
    (mindMap) => mindMap,
  );
}

/// Provider for mind map nodes by chapter ID with subject context
@riverpod
Future<List<MindMapNode>> chapterMindMapNodes(
  ChapterMindMapNodesRef ref,
  String chapterId, {
  String? subjectId,
}) async {
  final repository = ref.watch(mindMapRepositoryProvider) as MindMapRepositoryImpl;
  final segment = SegmentConfig.current.name;

  // Set context for JSON lookup
  repository.subjectId = subjectId;

  final result = await repository.getNodes(chapterId, segment);
  return result.fold(
    (failure) => [],
    (nodes) => nodes,
  );
}

/// Notifier for managing mind map state
@riverpod
class MindMapNotifier extends _$MindMapNotifier {
  String? _subjectId;

  @override
  Future<MindMap?> build(String chapterId) async {
    final repository = ref.watch(mindMapRepositoryProvider) as MindMapRepositoryImpl;
    final segment = SegmentConfig.current.name;

    // Set context for JSON lookup
    repository.subjectId = _subjectId;

    final result = await repository.getMindMap(chapterId, segment);
    return result.fold(
      (failure) => null,
      (mindMap) => mindMap,
    );
  }

  /// Set the subject ID for JSON lookup
  void setSubjectId(String subjectId) {
    _subjectId = subjectId;
  }

  /// Refresh mind map with subject context
  Future<void> refreshWithContext({required String subjectId}) async {
    _subjectId = subjectId;
    state = const AsyncLoading();

    final repository = ref.read(mindMapRepositoryProvider) as MindMapRepositoryImpl;
    final segment = SegmentConfig.current.name;

    repository.subjectId = subjectId;

    final result = await repository.getMindMap(chapterId, segment);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (mindMap) => AsyncData(mindMap),
    );
  }

  /// Refresh mind map data
  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(mindMapRepositoryProvider) as MindMapRepositoryImpl;
    final segment = SegmentConfig.current.name;

    repository.subjectId = _subjectId;

    final result = await repository.getMindMap(chapterId, segment);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (mindMap) => AsyncData(mindMap),
    );
  }
}
