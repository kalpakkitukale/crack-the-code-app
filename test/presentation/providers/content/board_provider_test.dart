/// Test suite for BoardNotifier and BoardState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/content/board.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/usecases/content/get_boards_usecase.dart';
import 'package:crack_the_code/presentation/providers/content/board_provider.dart';

void main() {
  group('BoardState', () {
    test('initial_hasEmptyBoardsAndIsLoading', () {
      final state = BoardState.initial();

      expect(state.boards, isEmpty);
      expect(state.isLoading, true);
      expect(state.error, isNull);
    });

    test('copyWith_updatesSpecifiedFields', () {
      final initial = BoardState.initial();
      final boards = [_createTestBoard('board-1')];

      final updated = initial.copyWith(
        boards: boards,
        isLoading: false,
      );

      expect(updated.boards, boards);
      expect(updated.isLoading, false);
      expect(updated.error, isNull);
    });

    test('copyWith_keepsExistingFieldsWhenNotSpecified', () {
      final state = BoardState(
        boards: [_createTestBoard('existing')],
        isLoading: false,
        error: 'Some error',
      );

      // Note: error is not preserved by copyWith (it's nullable and passed directly)
      // This tests the boards and isLoading preservation
      final updated = state.copyWith(isLoading: true, error: state.error);

      expect(updated.boards.length, 1);
      expect(updated.isLoading, true);
      expect(updated.error, 'Some error');
    });

    test('copyWith_clearsErrorWhenNotSpecified', () {
      final state = BoardState(
        boards: [_createTestBoard('existing')],
        isLoading: false,
        error: 'Some error',
      );

      // Error becomes null when not explicitly passed
      final updated = state.copyWith(isLoading: true);

      expect(updated.boards.length, 1);
      expect(updated.isLoading, true);
      expect(updated.error, isNull);
    });
  });

  group('BoardNotifier', () {
    late MockGetBoardsUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockGetBoardsUseCase();
    });

    BoardNotifier createNotifier({bool autoLoad = false}) {
      if (autoLoad) {
        return BoardNotifier(mockUseCase);
      }

      // Create without auto-loading by setting success result first
      mockUseCase.setSuccess([]);
      return BoardNotifier(mockUseCase);
    }

    group('loadBoards', () {
      test('success_updatesStateWithBoards', () async {
        final boards = [
          _createTestBoard('cbse'),
          _createTestBoard('icse'),
        ];
        mockUseCase.setSuccess(boards);

        final notifier = createNotifier(autoLoad: true);

        // Wait for async load
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.boards.length, 2);
        expect(notifier.state.boards[0].id, 'cbse');
        expect(notifier.state.boards[1].id, 'icse');
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
      });

      test('failure_setsErrorState', () async {
        mockUseCase.setFailure('Failed to load boards');

        final notifier = createNotifier(autoLoad: true);

        // Wait for async load
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.boards, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, 'Failed to load boards');
      });

      test('emptyList_setsEmptyStateWithoutError', () async {
        mockUseCase.setSuccess([]);

        final notifier = createNotifier(autoLoad: true);

        // Wait for async load
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.boards, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.error, isNull);
      });
    });

    group('refresh', () {
      test('reloadsBoards', () async {
        mockUseCase.setSuccess([_createTestBoard('initial')]);

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.boards.length, 1);
        expect(mockUseCase.callCount, 1);

        // Update mock to return different data
        mockUseCase.setSuccess([
          _createTestBoard('refreshed-1'),
          _createTestBoard('refreshed-2'),
          _createTestBoard('refreshed-3'),
        ]);

        await notifier.refresh();

        expect(notifier.state.boards.length, 3);
        expect(mockUseCase.callCount, 2);
      });

      test('clearsErrorOnSuccessfulRefresh', () async {
        mockUseCase.setFailure('Initial error');

        final notifier = createNotifier(autoLoad: true);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.error, 'Initial error');

        // Now set success for refresh
        mockUseCase.setSuccess([_createTestBoard('recovered')]);

        await notifier.refresh();

        expect(notifier.state.error, isNull);
        expect(notifier.state.boards.length, 1);
      });
    });

    group('state transitions', () {
      test('setsLoadingWhileFetching', () async {
        // Create a delayed mock
        mockUseCase.setDelayedSuccess(
          [_createTestBoard('delayed')],
          const Duration(milliseconds: 200),
        );

        final notifier = createNotifier(autoLoad: true);

        // Immediately check state - should be loading
        expect(notifier.state.isLoading, true);

        // Wait for completion
        await Future.delayed(const Duration(milliseconds: 300));

        expect(notifier.state.isLoading, false);
        expect(notifier.state.boards.length, 1);
      });
    });
  });
}

/// Create a test board
Board _createTestBoard(String id) {
  return Board(
    id: id,
    name: id.toUpperCase(),
    fullName: 'Board $id Full Name',
    description: 'Description for $id',
    icon: 'assets/icons/$id.png',
    classes: [],
  );
}

/// Mock GetBoardsUseCase
class MockGetBoardsUseCase implements GetBoardsUseCase {
  Either<Failure, List<Board>>? _result;
  Duration? _delay;
  int callCount = 0;

  @override
  ContentRepository get repository =>
      throw UnimplementedError('Mock does not use repository');

  void setSuccess(List<Board> boards) {
    _result = Right(boards);
    _delay = null;
  }

  void setDelayedSuccess(List<Board> boards, Duration delay) {
    _result = Right(boards);
    _delay = delay;
  }

  void setFailure(String message) {
    _result = Left(CacheFailure(message: message));
    _delay = null;
  }

  @override
  Future<Either<Failure, List<Board>>> call([void params]) async {
    callCount++;

    if (_delay != null) {
      await Future.delayed(_delay!);
    }

    return _result ?? const Right([]);
  }
}
