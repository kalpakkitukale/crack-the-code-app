/// Test suite for SubjectNotifier and SubjectState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/content/subject.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/domain/usecases/content/get_subjects_usecase.dart';
import 'package:streamshaala/presentation/providers/content/subject_provider.dart';

void main() {
  group('SubjectState', () {
    test('initial_hasEmptySubjectsAndNotLoading', () {
      final state = SubjectState.initial();

      expect(state.subjects, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.currentBoardId, isNull);
      expect(state.currentClassId, isNull);
      expect(state.currentStreamId, isNull);
    });

    test('copyWith_updatesSpecifiedFields', () {
      final initial = SubjectState.initial();
      final subjects = [_createTestSubject('1')];

      final updated = initial.copyWith(
        subjects: subjects,
        isLoading: true,
        currentBoardId: 'board-1',
        currentClassId: 'class-1',
        currentStreamId: 'stream-1',
      );

      expect(updated.subjects, subjects);
      expect(updated.isLoading, true);
      expect(updated.currentBoardId, 'board-1');
      expect(updated.currentClassId, 'class-1');
      expect(updated.currentStreamId, 'stream-1');
      expect(updated.error, isNull);
    });

    test('copyWith_preservesUnspecifiedFields', () {
      final initial = SubjectState(
        subjects: [_createTestSubject('1')],
        isLoading: true,
        currentBoardId: 'board-1',
        currentClassId: 'class-1',
        currentStreamId: 'stream-1',
      );

      final updated = initial.copyWith(isLoading: false);

      expect(updated.subjects.length, 1);
      expect(updated.isLoading, false);
      expect(updated.currentBoardId, 'board-1');
      expect(updated.currentClassId, 'class-1');
      expect(updated.currentStreamId, 'stream-1');
    });

    test('copyWith_allowsClearingError', () {
      final initial = SubjectState(
        subjects: const [],
        error: 'Some error',
      );

      final updated = initial.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('SubjectNotifier', () {
    late MockGetSubjectsUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockGetSubjectsUseCase();
    });

    SubjectNotifier createNotifier() {
      return SubjectNotifier(mockUseCase);
    }

    group('loadSubjects', () {
      test('success_updatesStateWithSubjects', () async {
        final subjects = [
          _createTestSubject('physics'),
          _createTestSubject('chemistry'),
        ];
        mockUseCase.setSuccess(subjects);

        final notifier = createNotifier();

        await notifier.loadSubjects(
          boardId: 'cbse',
          classId: 'class-12',
          streamId: 'science',
        );

        expect(notifier.state.subjects, subjects);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
        expect(notifier.state.currentBoardId, 'cbse');
        expect(notifier.state.currentClassId, 'class-12');
        expect(notifier.state.currentStreamId, 'science');
      });

      test('failure_setsErrorState', () async {
        mockUseCase.setFailure('Failed to load subjects');

        final notifier = createNotifier();

        await notifier.loadSubjects(
          boardId: 'cbse',
          classId: 'class-12',
          streamId: 'science',
        );

        expect(notifier.state.subjects, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, 'Failed to load subjects');
      });

      test('setsLoadingStateDuringRequest', () async {
        mockUseCase.setSuccess([]);
        mockUseCase.setDelay(const Duration(milliseconds: 100));

        final notifier = createNotifier();

        final loadFuture = notifier.loadSubjects(
          boardId: 'cbse',
          classId: 'class-12',
          streamId: 'science',
        );

        // Check loading state immediately
        expect(notifier.state.isLoading, true);

        await loadFuture;

        expect(notifier.state.isLoading, false);
      });

      test('capturesParams', () async {
        mockUseCase.setSuccess([]);

        final notifier = createNotifier();

        await notifier.loadSubjects(
          boardId: 'board-x',
          classId: 'class-y',
          streamId: 'stream-z',
        );

        expect(mockUseCase.lastParams?.boardId, 'board-x');
        expect(mockUseCase.lastParams?.classId, 'class-y');
        expect(mockUseCase.lastParams?.streamId, 'stream-z');
      });
    });

    group('refresh', () {
      test('reloadsSubjects_whenParamsExist', () async {
        final initialSubjects = [_createTestSubject('initial')];
        mockUseCase.setSuccess(initialSubjects);

        final notifier = createNotifier();

        await notifier.loadSubjects(
          boardId: 'cbse',
          classId: 'class-12',
          streamId: 'science',
        );

        expect(notifier.state.subjects.length, 1);
        expect(mockUseCase.callCount, 1);

        // Update mock to return different data
        final refreshedSubjects = [
          _createTestSubject('refreshed-1'),
          _createTestSubject('refreshed-2'),
        ];
        mockUseCase.setSuccess(refreshedSubjects);

        await notifier.refresh();

        expect(notifier.state.subjects.length, 2);
        expect(mockUseCase.callCount, 2);
      });

      test('doesNothing_whenParamsAreNull', () async {
        final notifier = createNotifier();

        await notifier.refresh();

        expect(mockUseCase.callCount, 0);
        expect(notifier.state.subjects, isEmpty);
      });
    });

    group('clear', () {
      test('resetsStateToInitial', () async {
        final subjects = [_createTestSubject('physics')];
        mockUseCase.setSuccess(subjects);

        final notifier = createNotifier();

        await notifier.loadSubjects(
          boardId: 'cbse',
          classId: 'class-12',
          streamId: 'science',
        );

        expect(notifier.state.subjects.isNotEmpty, true);

        notifier.clear();

        expect(notifier.state.subjects, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
        expect(notifier.state.currentBoardId, isNull);
        expect(notifier.state.currentClassId, isNull);
        expect(notifier.state.currentStreamId, isNull);
      });
    });
  });
}

/// Create a test subject
Subject _createTestSubject(String id) {
  return Subject(
    id: 'subject-$id',
    name: 'Test Subject $id',
    boardId: 'cbse',
    classId: 'class-12',
    streamId: 'science',
    totalChapters: 5,
    chapters: const [],
  );
}

/// Mock GetSubjectsUseCase
class MockGetSubjectsUseCase implements GetSubjectsUseCase {
  Either<Failure, List<Subject>>? _result;
  GetSubjectsParams? lastParams;
  int callCount = 0;
  Duration _delay = Duration.zero;

  @override
  ContentRepository get repository =>
      throw UnimplementedError('Mock does not use repository');

  void setSuccess(List<Subject> subjects) {
    _result = Right(subjects);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  void setDelay(Duration delay) {
    _delay = delay;
  }

  @override
  Future<Either<Failure, List<Subject>>> call(GetSubjectsParams params) async {
    callCount++;
    lastParams = params;
    if (_delay != Duration.zero) {
      await Future.delayed(_delay);
    }
    return _result ?? const Right([]);
  }
}
