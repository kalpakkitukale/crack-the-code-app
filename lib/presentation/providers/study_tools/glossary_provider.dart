/// Riverpod providers for glossary
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/local/database/dao/glossary_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/study_tools/glossary_repository_impl.dart';
import 'package:streamshaala/domain/entities/study_tools/glossary_term.dart';
import 'package:streamshaala/domain/repositories/study_tools/glossary_repository.dart';
import 'package:streamshaala/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'glossary_provider.g.dart';

/// Provider for GlossaryDao
@riverpod
GlossaryDao glossaryDao(GlossaryDaoRef ref) {
  return GlossaryDao(DatabaseHelper());
}

/// Provider for GlossaryRepository
@riverpod
GlossaryRepository glossaryRepository(GlossaryRepositoryRef ref) {
  final dao = ref.watch(glossaryDaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return GlossaryRepositoryImpl(dao, jsonDataSource);
}

/// Provider for glossary terms by chapter ID with subject context
@riverpod
Future<List<GlossaryTerm>> chapterGlossary(
  ChapterGlossaryRef ref,
  String chapterId, {
  String? subjectId,
}) async {
  final repository = ref.watch(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
  final segment = SegmentConfig.current.name;

  // Set context for JSON lookup
  repository.subjectId = subjectId;

  final result = await repository.getTermsByChapterId(chapterId, segment);
  return result.fold(
    (failure) => [],
    (terms) => terms,
  );
}

/// Provider for searching glossary terms
@riverpod
Future<List<GlossaryTerm>> searchGlossary(
  SearchGlossaryRef ref,
  String chapterId,
  String query, {
  String? subjectId,
}) async {
  final repository = ref.watch(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
  final segment = SegmentConfig.current.name;

  // Set context for JSON lookup
  repository.subjectId = subjectId;

  final result = await repository.searchTerms(query, chapterId, segment);
  return result.fold(
    (failure) => [],
    (terms) => terms,
  );
}

/// Provider for a single glossary term by ID
@riverpod
Future<GlossaryTerm?> glossaryTerm(GlossaryTermRef ref, String termId) async {
  final repository = ref.watch(glossaryRepositoryProvider);

  final result = await repository.getTermById(termId);
  return result.fold(
    (failure) => null,
    (term) => term,
  );
}

/// Notifier for managing glossary state with search functionality
@riverpod
class GlossaryNotifier extends _$GlossaryNotifier {
  String _searchQuery = '';
  String? _subjectId;

  @override
  Future<List<GlossaryTerm>> build(String chapterId) async {
    final repository = ref.watch(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
    final segment = SegmentConfig.current.name;

    // Set context for JSON lookup
    repository.subjectId = _subjectId;

    final result = await repository.getTermsByChapterId(chapterId, segment);
    return result.fold(
      (failure) => [],
      (terms) => terms,
    );
  }

  /// Set the subject ID for JSON lookup
  void setSubjectId(String subjectId) {
    _subjectId = subjectId;
  }

  /// Search terms
  Future<void> search(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      // Reload all terms
      state = const AsyncLoading();
      final repository = ref.read(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
      final segment = SegmentConfig.current.name;

      repository.subjectId = _subjectId;

      final result = await repository.getTermsByChapterId(chapterId, segment);
      state = result.fold(
        (failure) => AsyncError(failure, StackTrace.current),
        (terms) => AsyncData(terms),
      );
    } else {
      // Search terms
      state = const AsyncLoading();
      final repository = ref.read(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
      final segment = SegmentConfig.current.name;

      repository.subjectId = _subjectId;

      final result = await repository.searchTerms(query, chapterId, segment);
      state = result.fold(
        (failure) => AsyncError(failure, StackTrace.current),
        (terms) => AsyncData(terms),
      );
    }
  }

  /// Get current search query
  String get searchQuery => _searchQuery;

  /// Refresh glossary with subject context
  Future<void> refreshWithContext({required String subjectId}) async {
    _subjectId = subjectId;

    if (_searchQuery.isNotEmpty) {
      await search(_searchQuery);
    } else {
      state = const AsyncLoading();
      final repository = ref.read(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
      final segment = SegmentConfig.current.name;

      repository.subjectId = subjectId;

      final result = await repository.getTermsByChapterId(chapterId, segment);
      state = result.fold(
        (failure) => AsyncError(failure, StackTrace.current),
        (terms) => AsyncData(terms),
      );
    }
  }

  /// Refresh glossary
  Future<void> refresh() async {
    if (_searchQuery.isNotEmpty) {
      await search(_searchQuery);
    } else {
      state = const AsyncLoading();
      final repository = ref.read(glossaryRepositoryProvider) as GlossaryRepositoryImpl;
      final segment = SegmentConfig.current.name;

      repository.subjectId = _subjectId;

      final result = await repository.getTermsByChapterId(chapterId, segment);
      state = result.fold(
        (failure) => AsyncError(failure, StackTrace.current),
        (terms) => AsyncData(terms),
      );
    }
  }
}
