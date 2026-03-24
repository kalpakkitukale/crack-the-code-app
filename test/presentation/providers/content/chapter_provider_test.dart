/// Test suite for ChapterNotifier and ChapterState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/content/chapter.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/usecases/content/get_chapters_usecase.dart';
import 'package:crack_the_code/presentation/providers/content/chapter_provider.dart';

void main() {
  group('ChapterState', () {
    test('initial_hasEmptyChaptersAndNotLoading', () {
      final state = ChapterState.initial();

      expect(state.chapters, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.currentSubjectId, isNull);
    });

    test('copyWith_updatesSpecifiedFields', () {
      final initial = ChapterState.initial();
      final chapters = [_createTestChapter(1)];

      final updated = initial.copyWith(
        chapters: chapters,
        isLoading: true,
        currentSubjectId: 'subject-1',
      );

      expect(updated.chapters, chapters);
      expect(updated.isLoading, true);
      expect(updated.currentSubjectId, 'subject-1');
      expect(updated.error, isNull);
    });

    test('copyWith_preservesUnspecifiedFields', () {
      final initial = ChapterState(
        chapters: [_createTestChapter(1)],
        isLoading: true,
        currentSubjectId: 'subject-1',
      );

      final updated = initial.copyWith(isLoading: false);

      expect(updated.chapters.length, 1);
      expect(updated.isLoading, false);
      expect(updated.currentSubjectId, 'subject-1');
    });

    test('copyWith_allowsClearingError', () {
      final initial = ChapterState(
        chapters: const [],
        error: 'Some error',
      );

      final updated = initial.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('ChapterNotifier', () {
    late MockGetChaptersUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockGetChaptersUseCase();
    });

    ChapterNotifier createNotifier() {
      return ChapterNotifier(mockUseCase);
    }

    group('loadChapters', () {
      test('success_updatesStateWithChapters', () async {
        final chapters = [
          _createTestChapter(1),
          _createTestChapter(2),
          _createTestChapter(3),
        ];
        mockUseCase.setSuccess(chapters);

        final notifier = createNotifier();

        await notifier.loadChapters('physics-101');

        expect(notifier.state.chapters, chapters);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
        expect(notifier.state.currentSubjectId, 'physics-101');
      });

      test('failure_setsErrorState', () async {
        mockUseCase.setFailure('Failed to load chapters');

        final notifier = createNotifier();

        await notifier.loadChapters('physics-101');

        expect(notifier.state.chapters, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, 'Failed to load chapters');
      });

      test('setsLoadingStateDuringRequest', () async {
        mockUseCase.setSuccess([]);
        mockUseCase.setDelay(const Duration(milliseconds: 100));

        final notifier = createNotifier();

        final loadFuture = notifier.loadChapters('physics-101');

        // Check loading state immediately
        expect(notifier.state.isLoading, true);
        expect(notifier.state.currentSubjectId, 'physics-101');

        await loadFuture;

        expect(notifier.state.isLoading, false);
      });

      test('capturesSubjectId', () async {
        mockUseCase.setSuccess([]);

        final notifier = createNotifier();

        await notifier.loadChapters('chemistry-advanced');

        expect(mockUseCase.lastSubjectId, 'chemistry-advanced');
      });

      test('clearsPreviousErrorOnNewLoad', () async {
        mockUseCase.setFailure('Initial error');
        final notifier = createNotifier();

        await notifier.loadChapters('subject-1');
        expect(notifier.state.error, 'Initial error');

        mockUseCase.setSuccess([_createTestChapter(1)]);

        await notifier.loadChapters('subject-2');
        expect(notifier.state.error, isNull);
      });
    });

    group('refresh', () {
      test('reloadsChapters_whenSubjectIdExists', () async {
        final initialChapters = [_createTestChapter(1)];
        mockUseCase.setSuccess(initialChapters);

        final notifier = createNotifier();

        await notifier.loadChapters('physics-101');

        expect(notifier.state.chapters.length, 1);
        expect(mockUseCase.callCount, 1);

        // Update mock to return different data
        final refreshedChapters = [
          _createTestChapter(1),
          _createTestChapter(2),
        ];
        mockUseCase.setSuccess(refreshedChapters);

        await notifier.refresh();

        expect(notifier.state.chapters.length, 2);
        expect(mockUseCase.callCount, 2);
        // Should use the same subject ID
        expect(mockUseCase.lastSubjectId, 'physics-101');
      });

      test('doesNothing_whenSubjectIdIsNull', () async {
        final notifier = createNotifier();

        await notifier.refresh();

        expect(mockUseCase.callCount, 0);
        expect(notifier.state.chapters, isEmpty);
      });
    });

    group('clear', () {
      test('resetsStateToInitial', () async {
        final chapters = [_createTestChapter(1)];
        mockUseCase.setSuccess(chapters);

        final notifier = createNotifier();

        await notifier.loadChapters('physics-101');

        expect(notifier.state.chapters.isNotEmpty, true);
        expect(notifier.state.currentSubjectId, 'physics-101');

        notifier.clear();

        expect(notifier.state.chapters, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
        expect(notifier.state.currentSubjectId, isNull);
      });
    });
  });
}

/// Create a test chapter
Chapter _createTestChapter(int number) {
  return Chapter(
    id: 'chapter-$number',
    number: number,
    name: 'Chapter $number: Test Chapter',
    description: 'Description for chapter $number',
    topics: const [],
  );
}

/// Mock GetChaptersUseCase
class MockGetChaptersUseCase implements GetChaptersUseCase {
  Either<Failure, List<Chapter>>? _result;
  String? lastSubjectId;
  int callCount = 0;
  Duration _delay = Duration.zero;

  @override
  ContentRepository get repository =>
      throw UnimplementedError('Mock does not use repository');

  void setSuccess(List<Chapter> chapters) {
    _result = Right(chapters);
  }

  void setFailure(String message) {
    _result = Left(DatabaseFailure(message: message));
  }

  void setDelay(Duration delay) {
    _delay = delay;
  }

  @override
  Future<Either<Failure, List<Chapter>>> call(String params) async {
    callCount++;
    lastSubjectId = params;
    if (_delay != Duration.zero) {
      await Future.delayed(_delay);
    }
    return _result ?? const Right([]);
  }
}
