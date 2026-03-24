import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/subject_progress.dart';
import 'package:crack_the_code/domain/entities/chapter_progress.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/presentation/providers/content/subject_provider.dart';

/// Provider for accessing the progress repository
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return injectionContainer.progressRepository;
});

/// Provider for getting subject progress for all subjects in the current context
final subjectProgressListProvider = FutureProvider<List<SubjectProgress>>((ref) async {
  final progressRepository = ref.watch(progressRepositoryProvider);
  final subjectState = ref.watch(subjectProvider);

  // If no subjects are loaded yet, return empty list
  if (subjectState.subjects.isEmpty) {
    logger.info('No subjects available for progress calculation');
    return [];
  }

  final subjectProgressList = <SubjectProgress>[];

  // Calculate progress for each subject
  for (final subject in subjectState.subjects) {
    try {
      final result = await progressRepository.getSubjectProgressById(subject.id);

      result.fold(
        (failure) {
          logger.error('Failed to get progress for subject ${subject.id}: ${failure.message}');
        },
        (progress) {
          if (progress != null) {
            subjectProgressList.add(progress);
          }
        },
      );
    } catch (e) {
      logger.error('Error calculating progress for subject ${subject.id}: $e');
    }
  }

  logger.info('Calculated progress for ${subjectProgressList.length} subjects');
  return subjectProgressList;
});

/// Provider for getting progress for a specific subject by ID
final subjectProgressByIdProvider = FutureProvider.family<SubjectProgress?, String>((ref, subjectId) async {
  final progressRepository = ref.watch(progressRepositoryProvider);

  logger.info('Getting progress for subject: $subjectId');

  final result = await progressRepository.getSubjectProgressById(subjectId);

  return result.fold(
    (failure) {
      logger.error('Failed to get subject progress: ${failure.message}');
      throw Exception(failure.message);
    },
    (progress) => progress,
  );
});

/// Provider for getting chapter progress for a specific subject
final chapterProgressBySubjectProvider = FutureProvider.family<List<ChapterProgress>, String>((ref, subjectId) async {
  final progressRepository = ref.watch(progressRepositoryProvider);

  logger.info('Getting chapter progress for subject: $subjectId');

  final result = await progressRepository.getChapterProgressBySubject(subjectId);

  return result.fold(
    (failure) {
      logger.error('Failed to get chapter progress: ${failure.message}');
      throw Exception(failure.message);
    },
    (chapterProgress) => chapterProgress,
  );
});

/// Provider for getting progress for a specific chapter
final chapterProgressByIdProvider = FutureProvider.family<ChapterProgress?, ChapterProgressParams>((ref, params) async {
  final progressRepository = ref.watch(progressRepositoryProvider);

  logger.info('Getting progress for chapter: ${params.chapterId} in subject: ${params.subjectId}');

  final result = await progressRepository.getChapterProgressById(
    params.subjectId,
    params.chapterId,
  );

  return result.fold(
    (failure) {
      logger.error('Failed to get chapter progress: ${failure.message}');
      throw Exception(failure.message);
    },
    (progress) => progress,
  );
});

/// Parameters for chapter progress provider
class ChapterProgressParams {
  final String subjectId;
  final String chapterId;

  const ChapterProgressParams({
    required this.subjectId,
    required this.chapterId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChapterProgressParams &&
        other.subjectId == subjectId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode => subjectId.hashCode ^ chapterId.hashCode;
}
