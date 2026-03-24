/// Riverpod providers for chapter notes
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/data/datasources/local/database/dao/chapter_notes_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/study_tools/chapter_notes_repository_impl.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_note.dart';
import 'package:streamshaala/domain/repositories/study_tools/chapter_notes_repository.dart';
import 'package:streamshaala/presentation/providers/study_tools/study_tools_json_provider.dart';

part 'chapter_notes_provider.g.dart';

/// Provider for ChapterNotesDao
@riverpod
ChapterNotesDao chapterNotesDao(ChapterNotesDaoRef ref) {
  return ChapterNotesDao(DatabaseHelper());
}

/// Provider for ChapterNotesRepository
@riverpod
ChapterNotesRepository chapterNotesRepository(ChapterNotesRepositoryRef ref) {
  final dao = ref.watch(chapterNotesDaoProvider);
  final jsonDataSource = ref.watch(studyToolsJsonDataSourceProvider);
  return ChapterNotesRepositoryImpl(dao, jsonDataSource);
}

/// Data class for chapter notes (curated + personal)
class ChapterNotesData {
  final List<ChapterNote> curatedNotes;
  final List<ChapterNote> personalNotes;

  const ChapterNotesData({
    required this.curatedNotes,
    required this.personalNotes,
  });

  int get totalCount => curatedNotes.length + personalNotes.length;
  List<ChapterNote> get allNotes => [...curatedNotes, ...personalNotes];

  /// Get pinned notes first, then by date
  List<ChapterNote> get sortedNotes {
    final sorted = [...allNotes];
    sorted.sort((a, b) {
      // Pinned notes first
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      // Then by date (newest first)
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return sorted;
  }
}

/// Provider for all chapter notes (curated + personal)
@riverpod
Future<ChapterNotesData> chapterNotes(
  ChapterNotesRef ref,
  String chapterId,
  String subjectId,
  String profileId,
) async {
  final repository = ref.watch(chapterNotesRepositoryProvider);
  final segment = SegmentConfig.current.name;

  // Load curated notes from JSON/cache
  final curatedResult =
      await repository.getCuratedNotes(chapterId, subjectId, segment);
  final curated = curatedResult.fold((_) => <ChapterNote>[], (notes) => notes);

  // Load personal notes from database
  final personalResult =
      await repository.getPersonalNotes(chapterId, profileId);
  final personal =
      personalResult.fold((_) => <ChapterNote>[], (notes) => notes);

  return ChapterNotesData(
    curatedNotes: curated,
    personalNotes: personal,
  );
}

/// Provider for notes count
@riverpod
Future<({int curated, int personal})> chapterNotesCount(
  ChapterNotesCountRef ref,
  String chapterId,
  String subjectId,
  String profileId,
) async {
  final repository = ref.watch(chapterNotesRepositoryProvider);
  final segment = SegmentConfig.current.name;

  final result =
      await repository.getNotesCount(chapterId, profileId, subjectId, segment);
  return result.fold(
    (_) => (curated: 0, personal: 0),
    (counts) => counts,
  );
}

/// Notifier for managing personal notes (CRUD operations)
@riverpod
class PersonalNotesNotifier extends _$PersonalNotesNotifier {
  @override
  Future<List<ChapterNote>> build(
    String chapterId,
    String profileId,
  ) async {
    final repository = ref.watch(chapterNotesRepositoryProvider);
    final result = await repository.getPersonalNotes(chapterId, profileId);
    return result.fold(
      (failure) => [],
      (notes) => notes,
    );
  }

  /// Add a new personal note
  Future<bool> addNote({
    required String content,
    String? title,
    List<String>? tags,
  }) async {
    final repository = ref.read(chapterNotesRepositoryProvider);
    final segment = SegmentConfig.current.name;

    final note = ChapterNote.createPersonal(
      chapterId: chapterId,
      profileId: profileId,
      content: content,
      title: title,
      tags: tags ?? [],
      segment: segment,
    );

    final result = await repository.savePersonalNote(note);
    return result.fold(
      (failure) => false,
      (savedNote) {
        // Update state with new note
        state = AsyncData([savedNote, ...state.value ?? []]);
        return true;
      },
    );
  }

  /// Update an existing personal note
  Future<bool> updateNote(ChapterNote note) async {
    final repository = ref.read(chapterNotesRepositoryProvider);

    final result = await repository.updatePersonalNote(note);
    return result.fold(
      (failure) => false,
      (updatedNote) {
        // Update state with updated note
        final notes = <ChapterNote>[...state.value ?? []];
        final index = notes.indexWhere((n) => n.id == updatedNote.id);
        if (index != -1) {
          notes[index] = updatedNote;
          state = AsyncData(notes);
        }
        return true;
      },
    );
  }

  /// Delete a personal note
  Future<bool> deleteNote(String noteId) async {
    final repository = ref.read(chapterNotesRepositoryProvider);

    final result = await repository.deletePersonalNote(noteId);
    return result.fold(
      (failure) => false,
      (_) {
        // Remove note from state
        final notes = <ChapterNote>[...state.value ?? []];
        notes.removeWhere((n) => n.id == noteId);
        state = AsyncData(notes);
        return true;
      },
    );
  }

  /// Toggle pin status of a note
  Future<bool> togglePin(String noteId) async {
    final notes = state.value ?? [];
    final note = notes.firstWhere(
      (n) => n.id == noteId,
      orElse: () => throw Exception('Note not found'),
    );

    final updatedNote = note.copyWith(isPinned: !note.isPinned);
    return updateNote(updatedNote);
  }

  /// Refresh notes
  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(chapterNotesRepositoryProvider);
    final result = await repository.getPersonalNotes(chapterId, profileId);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (notes) => AsyncData(notes),
    );
  }
}

/// Provider for searching notes
@riverpod
Future<List<ChapterNote>> searchChapterNotes(
  SearchChapterNotesRef ref,
  String chapterId,
  String subjectId,
  String profileId,
  String query,
) async {
  final repository = ref.watch(chapterNotesRepositoryProvider);
  final segment = SegmentConfig.current.name;

  final result =
      await repository.searchNotes(query, chapterId, profileId, segment);
  return result.fold(
    (failure) => [],
    (notes) => notes,
  );
}
