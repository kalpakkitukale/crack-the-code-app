/// NoteRepositoryImpl tests - Comprehensive coverage
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/data/repositories/note_repository_impl.dart';
import 'package:streamshaala/data/models/user/note_model.dart';
import 'package:streamshaala/domain/entities/user/note.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('NoteRepositoryImpl', () {
    late MockNoteDao mockDao;
    late NoteRepositoryImpl repository;

    setUp(() {
      mockDao = MockNoteDao();
      repository = NoteRepositoryImpl(mockDao);
    });

    tearDown() {
      mockDao.clear();
    }

    // Helper to create a test note
    Note createNote({
      String id = 'note-1',
      String videoId = 'video-1',
      String content = 'Test note content',
      int? timestampSeconds,
    }) {
      final now = DateTime(2024, 1, 15, 10, 0);
      return Note(
        id: id,
        videoId: videoId,
        content: content,
        timestampSeconds: timestampSeconds,
        createdAt: now,
        updatedAt: now,
      );
    }

    // =========================================================================
    // ADD NOTE TESTS
    // =========================================================================
    group('addNote', () {
      test('success_addsNoteToDao', () async {
        final note = createNote();

        final result = await repository.addNote(note);

        expect(result.isRight(), true);
        expect(mockDao.all.length, 1);
        expect(mockDao.all.first.videoId, 'video-1');
        expect(mockDao.all.first.content, 'Test note content');
      });

      test('success_returnsNoteEntity', () async {
        final note = createNote();

        final result = await repository.addNote(note);

        result.fold(
          (failure) => fail('Should succeed'),
          (savedNote) {
            expect(savedNote.id, note.id);
            expect(savedNote.videoId, note.videoId);
            expect(savedNote.content, note.content);
          },
        );
      });

      test('withProfileId_createsProfileSpecificNote', () async {
        repository.profileId = 'profile-123';
        final note = createNote();

        await repository.addNote(note);

        expect(mockDao.all.first.profileId, 'profile-123');
      });

      test('withTimestamp_savesTimestamp', () async {
        final note = createNote(timestampSeconds: 120);

        await repository.addNote(note);

        expect(mockDao.all.first.timestampSeconds, 120);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final note = createNote();
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.addNote(note);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('Database operation failed'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('unknownException_returnsUnknownFailure', () async {
        final note = createNote();
        mockDao.setNextException(Exception('Unknown error'));

        final result = await repository.addNote(note);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('unexpected error'));
          },
          (_) => fail('Should fail'),
        );
      });
    });

    // =========================================================================
    // UPDATE NOTE TESTS
    // =========================================================================
    group('updateNote', () {
      test('success_updatesNoteInDao', () async {
        final note = createNote();
        await repository.addNote(note);

        final updatedNote = note.copyWith(
          content: 'Updated content',
          updatedAt: DateTime(2024, 1, 15, 11, 0),
        );

        final result = await repository.updateNote(updatedNote);

        expect(result.isRight(), true);
        expect(mockDao.all.length, 1);
        expect(mockDao.all.first.content, 'Updated content');
      });

      test('success_returnsUpdatedNote', () async {
        final note = createNote();
        await repository.addNote(note);

        final updatedNote = note.copyWith(content: 'Updated content');

        final result = await repository.updateNote(updatedNote);

        result.fold(
          (_) => fail('Should succeed'),
          (savedNote) {
            expect(savedNote.content, 'Updated content');
          },
        );
      });

      test('notFound_returnsNotFoundFailure', () async {
        final note = createNote(id: 'non-existent');

        final result = await repository.updateNote(note);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final note = createNote();
        await repository.addNote(note);
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.updateNote(note);

        expect(result.isLeft(), true);
      });
    });

    // =========================================================================
    // DELETE NOTE TESTS
    // =========================================================================
    group('deleteNote', () {
      test('success_removesNoteFromDao', () async {
        final note = createNote();
        await repository.addNote(note);
        expect(mockDao.all.length, 1);

        final result = await repository.deleteNote('note-1');

        expect(result.isRight(), true);
        expect(mockDao.all.length, 0);
      });

      test('notFound_returnsNotFoundFailure', () async {
        final result = await repository.deleteNote('non-existent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.message, contains('not found'));
          },
          (_) => fail('Should fail'),
        );
      });

      test('databaseException_returnsDatabaseFailure', () async {
        final note = createNote();
        await repository.addNote(note);
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.deleteNote('note-1');

        expect(result.isLeft(), true);
      });
    });

    // =========================================================================
    // GET NOTES BY VIDEO ID TESTS
    // =========================================================================
    group('getNotesByVideoId', () {
      test('empty_returnsEmptyList', () async {
        final result = await repository.getNotesByVideoId('video-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes, isEmpty);
          },
        );
      });

      test('withNotes_returnsNotesForVideo', () async {
        await repository.addNote(createNote(id: 'n1', videoId: 'video-1'));
        await repository.addNote(createNote(id: 'n2', videoId: 'video-1'));
        await repository.addNote(createNote(id: 'n3', videoId: 'video-2'));

        final result = await repository.getNotesByVideoId('video-1');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
            expect(notes.every((n) => n.videoId == 'video-1'), true);
          },
        );
      });

      test('sortsBy_updatedDate_newestFirst', () async {
        await repository.addNote(
          createNote(id: 'n1', videoId: 'v1').copyWith(
            updatedAt: DateTime(2024, 1, 1),
          ),
        );
        await repository.addNote(
          createNote(id: 'n2', videoId: 'v1').copyWith(
            updatedAt: DateTime(2024, 1, 15),
          ),
        );
        await repository.addNote(
          createNote(id: 'n3', videoId: 'v1').copyWith(
            updatedAt: DateTime(2024, 1, 10),
          ),
        );

        final result = await repository.getNotesByVideoId('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes[0].id, 'n2'); // Jan 15 (newest)
            expect(notes[1].id, 'n3'); // Jan 10
            expect(notes[2].id, 'n1'); // Jan 1 (oldest)
          },
        );
      });

      test('withProfileId_returnsOnlyProfileNotes', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1', videoId: 'v1'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n2', videoId: 'v1'));

        repository.profileId = 'profile-1';
        final result = await repository.getNotesByVideoId('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 1);
            expect(notes.first.id, 'n1');
          },
        );
      });
    });

    // =========================================================================
    // GET ALL NOTES TESTS
    // =========================================================================
    group('getAllNotes', () {
      test('empty_returnsEmptyList', () async {
        final result = await repository.getAllNotes();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes, isEmpty);
          },
        );
      });

      test('withNotes_returnsAllNotes', () async {
        await repository.addNote(createNote(id: 'n1', videoId: 'v1'));
        await repository.addNote(createNote(id: 'n2', videoId: 'v2'));
        await repository.addNote(createNote(id: 'n3', videoId: 'v3'));

        final result = await repository.getAllNotes();

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 3);
          },
        );
      });

      test('sortsBy_updatedDate_newestFirst', () async {
        await repository.addNote(
          createNote(id: 'n1').copyWith(updatedAt: DateTime(2024, 1, 1)),
        );
        await repository.addNote(
          createNote(id: 'n2').copyWith(updatedAt: DateTime(2024, 1, 15)),
        );
        await repository.addNote(
          createNote(id: 'n3').copyWith(updatedAt: DateTime(2024, 1, 10)),
        );

        final result = await repository.getAllNotes();

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes[0].id, 'n2'); // Jan 15 (newest)
            expect(notes[1].id, 'n3'); // Jan 10
            expect(notes[2].id, 'n1'); // Jan 1 (oldest)
          },
        );
      });

      test('withProfileId_returnsOnlyProfileNotes', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1'));
        await repository.addNote(createNote(id: 'n2'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n3'));

        repository.profileId = 'profile-1';
        final result = await repository.getAllNotes();

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
            expect(notes.every((n) => n.id != 'n3'), true);
          },
        );
      });
    });

    // =========================================================================
    // GET NOTE BY ID TESTS
    // =========================================================================
    group('getNoteById', () {
      test('exists_returnsNote', () async {
        await repository.addNote(createNote(id: 'note-1'));

        final result = await repository.getNoteById('note-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (note) {
            expect(note, isNotNull);
            expect(note!.id, 'note-1');
          },
        );
      });

      test('notExists_returnsNull', () async {
        final result = await repository.getNoteById('note-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (note) {
            expect(note, isNull);
          },
        );
      });
    });

    // =========================================================================
    // GET NOTES COUNT TESTS
    // =========================================================================
    group('getNotesCount', () {
      test('empty_returnsZero', () async {
        final result = await repository.getNotesCount();

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 0);
          },
        );
      });

      test('withNotes_returnsCount', () async {
        await repository.addNote(createNote(id: 'n1'));
        await repository.addNote(createNote(id: 'n2'));
        await repository.addNote(createNote(id: 'n3'));

        final result = await repository.getNotesCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 3);
          },
        );
      });

      test('withProfileId_countsOnlyProfile', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1'));
        await repository.addNote(createNote(id: 'n2'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n3'));

        repository.profileId = 'profile-1';
        final result = await repository.getNotesCount();

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 2);
          },
        );
      });
    });

    // =========================================================================
    // GET NOTES COUNT BY VIDEO ID TESTS
    // =========================================================================
    group('getNotesCountByVideoId', () {
      test('noNotes_returnsZero', () async {
        final result = await repository.getNotesCountByVideoId('video-1');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 0);
          },
        );
      });

      test('withNotes_returnsCount', () async {
        await repository.addNote(createNote(id: 'n1', videoId: 'v1'));
        await repository.addNote(createNote(id: 'n2', videoId: 'v1'));
        await repository.addNote(createNote(id: 'n3', videoId: 'v2'));

        final result = await repository.getNotesCountByVideoId('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 2);
          },
        );
      });

      test('withProfileId_countsOnlyProfile', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1', videoId: 'v1'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n2', videoId: 'v1'));

        repository.profileId = 'profile-1';
        final result = await repository.getNotesCountByVideoId('v1');

        result.fold(
          (_) => fail('Should succeed'),
          (count) {
            expect(count, 1);
          },
        );
      });
    });

    // =========================================================================
    // SEARCH NOTES TESTS
    // =========================================================================
    group('searchNotes', () {
      test('noMatches_returnsEmptyList', () async {
        await repository.addNote(createNote(content: 'Hello world'));

        final result = await repository.searchNotes('xyz');

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes, isEmpty);
          },
        );
      });

      test('caseInsensitive_findsMatches', () async {
        await repository.addNote(createNote(id: 'n1', content: 'Hello WORLD'));
        await repository.addNote(createNote(id: 'n2', content: 'world hello'));

        final result = await repository.searchNotes('WoRlD');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
          },
        );
      });

      test('partialMatch_findsMatches', () async {
        await repository.addNote(createNote(id: 'n1', content: 'testing'));
        await repository.addNote(createNote(id: 'n2', content: 'test case'));
        await repository.addNote(createNote(id: 'n3', content: 'hello'));

        final result = await repository.searchNotes('test');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
          },
        );
      });

      test('withProfileId_searchesOnlyProfile', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1', content: 'test note'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n2', content: 'test note'));

        repository.profileId = 'profile-1';
        final result = await repository.searchNotes('test');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 1);
            expect(notes.first.id, 'n1');
          },
        );
      });
    });

    // =========================================================================
    // GET RECENT NOTES TESTS
    // =========================================================================
    group('getRecentNotes', () {
      test('limitsResultsToSpecifiedCount', () async {
        for (int i = 0; i < 10; i++) {
          await repository.addNote(createNote(id: 'n$i'));
        }

        final result = await repository.getRecentNotes(5);

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 5);
          },
        );
      });

      test('returnsNewestFirst', () async {
        await repository.addNote(
          createNote(id: 'n1').copyWith(updatedAt: DateTime(2024, 1, 1)),
        );
        await repository.addNote(
          createNote(id: 'n2').copyWith(updatedAt: DateTime(2024, 1, 15)),
        );
        await repository.addNote(
          createNote(id: 'n3').copyWith(updatedAt: DateTime(2024, 1, 10)),
        );

        final result = await repository.getRecentNotes(2);

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
            expect(notes[0].id, 'n2'); // Jan 15 (newest)
            expect(notes[1].id, 'n3'); // Jan 10
          },
        );
      });

      test('lessThanLimit_returnsAll', () async {
        await repository.addNote(createNote(id: 'n1'));
        await repository.addNote(createNote(id: 'n2'));

        final result = await repository.getRecentNotes(10);

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
          },
        );
      });

      test('withProfileId_returnsOnlyProfileNotes', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1'));
        await repository.addNote(createNote(id: 'n2'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n3'));

        repository.profileId = 'profile-1';
        final result = await repository.getRecentNotes(10);

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
            expect(notes.every((n) => n.id != 'n3'), true);
          },
        );
      });
    });

    // =========================================================================
    // DELETE NOTES BY VIDEO ID TESTS
    // =========================================================================
    group('deleteNotesByVideoId', () {
      test('success_removesAllNotesForVideo', () async {
        await repository.addNote(createNote(id: 'n1', videoId: 'v1'));
        await repository.addNote(createNote(id: 'n2', videoId: 'v1'));
        await repository.addNote(createNote(id: 'n3', videoId: 'v2'));
        expect(mockDao.all.length, 3);

        final result = await repository.deleteNotesByVideoId('v1');

        expect(result.isRight(), true);
        expect(mockDao.all.length, 1);
        expect(mockDao.all.first.videoId, 'v2');
      });

      test('withProfileId_removesOnlyProfileNotes', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1', videoId: 'v1'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n2', videoId: 'v1'));

        repository.profileId = 'profile-1';
        await repository.deleteNotesByVideoId('v1');

        // profile-2 note should still exist
        expect(mockDao.all.length, 1);
        expect(mockDao.all.first.id, 'n2');
      });

      test('noNotes_succeeds', () async {
        final result = await repository.deleteNotesByVideoId('v1');

        expect(result.isRight(), true);
      });

      test('databaseException_returnsDatabaseFailure', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.deleteNotesByVideoId('v1');

        expect(result.isLeft(), true);
      });
    });

    // =========================================================================
    // MULTI-PROFILE ISOLATION TESTS
    // =========================================================================
    group('Multi-Profile Isolation', () {
      test('differentProfiles_haveIsolatedNotes', () async {
        // Profile 1 notes
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1'));
        await repository.addNote(createNote(id: 'n2'));

        // Profile 2 notes
        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n3'));

        // Check profile 1
        repository.profileId = 'profile-1';
        final result1 = await repository.getAllNotes();
        result1.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 2);
            expect(notes.every((n) => n.id != 'n3'), true);
          },
        );

        // Check profile 2
        repository.profileId = 'profile-2';
        final result2 = await repository.getAllNotes();
        result2.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 1);
            expect(notes.first.id, 'n3');
          },
        );
      });

      test('searchIsolation_onlySearchesProfileNotes', () async {
        repository.profileId = 'profile-1';
        await repository.addNote(createNote(id: 'n1', content: 'test'));

        repository.profileId = 'profile-2';
        await repository.addNote(createNote(id: 'n2', content: 'test'));

        repository.profileId = 'profile-1';
        final result = await repository.searchNotes('test');

        result.fold(
          (_) => fail('Should succeed'),
          (notes) {
            expect(notes.length, 1);
            expect(notes.first.id, 'n1');
          },
        );
      });
    });
  });
}
