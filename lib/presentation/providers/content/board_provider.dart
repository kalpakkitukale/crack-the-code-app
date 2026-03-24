import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/content/board.dart';
import 'package:streamshaala/domain/usecases/content/get_boards_usecase.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// Board Provider
/// Manages board data (CBSE, State boards, etc.)
/// Uses real ContentRepository via GetBoardsUseCase

class BoardState {
  final List<Board> boards;
  final bool isLoading;
  final String? error;

  const BoardState({
    required this.boards,
    this.isLoading = false,
    this.error,
  });

  factory BoardState.initial() => const BoardState(
        boards: [],
        isLoading: true,
      );

  BoardState copyWith({
    List<Board>? boards,
    bool? isLoading,
    String? error,
  }) {
    return BoardState(
      boards: boards ?? this.boards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BoardNotifier extends StateNotifier<BoardState> {
  final GetBoardsUseCase _getBoardsUseCase;

  BoardNotifier(this._getBoardsUseCase) : super(BoardState.initial()) {
    loadBoards();
  }

  Future<void> loadBoards() async {
    logger.info('Loading boards from repository');
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getBoardsUseCase.call();

    result.fold(
      (failure) {
        logger.error('Failed to load boards: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (boards) {
        logger.info('Successfully loaded ${boards.length} boards');
        state = state.copyWith(
          boards: boards,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> refresh() async {
    logger.info('Refreshing boards');
    await loadBoards();
  }
}

final boardProvider = StateNotifierProvider<BoardNotifier, BoardState>((ref) {
  return BoardNotifier(injectionContainer.getBoardsUseCase);
});
