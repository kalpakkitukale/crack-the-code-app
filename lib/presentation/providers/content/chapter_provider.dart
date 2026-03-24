import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/content/chapter.dart';
import 'package:crack_the_code/domain/usecases/content/get_chapters_usecase.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Chapter Provider
/// Manages chapters for a specific subject
/// Uses real ContentRepository via GetChaptersUseCase

class ChapterState {
  final List<Chapter> chapters;
  final bool isLoading;
  final String? error;
  final String? currentSubjectId;

  const ChapterState({
    required this.chapters,
    this.isLoading = false,
    this.error,
    this.currentSubjectId,
  });

  factory ChapterState.initial() => const ChapterState(
        chapters: [],
        isLoading: false,
      );

  ChapterState copyWith({
    List<Chapter>? chapters,
    bool? isLoading,
    String? error,
    String? currentSubjectId,
  }) {
    return ChapterState(
      chapters: chapters ?? this.chapters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentSubjectId: currentSubjectId ?? this.currentSubjectId,
    );
  }
}

class ChapterNotifier extends StateNotifier<ChapterState> {
  final GetChaptersUseCase _getChaptersUseCase;

  ChapterNotifier(this._getChaptersUseCase) : super(ChapterState.initial());

  Future<void> loadChapters(String subjectId) async {
    logger.info('Loading chapters for subject: $subjectId');
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentSubjectId: subjectId,
    );

    final result = await _getChaptersUseCase.call(subjectId);

    result.fold(
      (failure) {
        logger.error('Failed to load chapters: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (chapters) {
        logger.info('Successfully loaded ${chapters.length} chapters');
        state = state.copyWith(
          chapters: chapters,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> refresh() async {
    if (state.currentSubjectId != null) {
      logger.info('Refreshing chapters');
      await loadChapters(state.currentSubjectId!);
    }
  }

  void clear() {
    logger.info('Clearing chapters');
    state = ChapterState.initial();
  }
}

final chapterProvider = StateNotifierProvider<ChapterNotifier, ChapterState>((ref) {
  return ChapterNotifier(injectionContainer.getChaptersUseCase);
});
