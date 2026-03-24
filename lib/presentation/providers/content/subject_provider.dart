import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/content/subject.dart';
import 'package:crack_the_code/domain/usecases/content/get_subjects_usecase.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Subject Provider
/// Manages subjects for a specific board/class/stream
/// Uses real ContentRepository via GetSubjectsUseCase

class SubjectState {
  final List<Subject> subjects;
  final bool isLoading;
  final String? error;
  final String? currentBoardId;
  final String? currentClassId;
  final String? currentStreamId;

  const SubjectState({
    required this.subjects,
    this.isLoading = false,
    this.error,
    this.currentBoardId,
    this.currentClassId,
    this.currentStreamId,
  });

  factory SubjectState.initial() => const SubjectState(
        subjects: [],
        isLoading: false,
      );

  SubjectState copyWith({
    List<Subject>? subjects,
    bool? isLoading,
    String? error,
    String? currentBoardId,
    String? currentClassId,
    String? currentStreamId,
  }) {
    return SubjectState(
      subjects: subjects ?? this.subjects,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentBoardId: currentBoardId ?? this.currentBoardId,
      currentClassId: currentClassId ?? this.currentClassId,
      currentStreamId: currentStreamId ?? this.currentStreamId,
    );
  }
}

class SubjectNotifier extends StateNotifier<SubjectState> {
  final GetSubjectsUseCase _getSubjectsUseCase;

  SubjectNotifier(this._getSubjectsUseCase) : super(SubjectState.initial());

  Future<void> loadSubjects({
    required String boardId,
    required String classId,
    required String streamId,
  }) async {
    logger.info('Loading subjects for board: $boardId, class: $classId, stream: $streamId');
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentBoardId: boardId,
      currentClassId: classId,
      currentStreamId: streamId,
    );

    final result = await _getSubjectsUseCase.call(
      GetSubjectsParams(
        boardId: boardId,
        classId: classId,
        streamId: streamId,
      ),
    );

    result.fold(
      (failure) {
        logger.error('Failed to load subjects: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (subjects) {
        logger.info('Successfully loaded ${subjects.length} subjects');
        state = state.copyWith(
          subjects: subjects,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> refresh() async {
    if (state.currentBoardId != null &&
        state.currentClassId != null &&
        state.currentStreamId != null) {
      logger.info('Refreshing subjects');
      await loadSubjects(
        boardId: state.currentBoardId!,
        classId: state.currentClassId!,
        streamId: state.currentStreamId!,
      );
    }
  }

  void clear() {
    logger.info('Clearing subjects');
    state = SubjectState.initial();
  }
}

final subjectProvider = StateNotifierProvider<SubjectNotifier, SubjectState>((ref) {
  return SubjectNotifier(injectionContainer.getSubjectsUseCase);
});
