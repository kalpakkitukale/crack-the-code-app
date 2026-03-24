/// Riverpod providers for chapter study hub aggregated data
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/usecases/content/get_videos_usecase.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';
import 'package:streamshaala/presentation/providers/study_tools/flashcard_provider.dart';
import 'package:streamshaala/presentation/providers/study_tools/glossary_provider.dart';
import 'package:streamshaala/presentation/providers/study_tools/mind_map_provider.dart';
import 'package:streamshaala/presentation/providers/study_tools/chapter_summary_provider.dart';
import 'package:streamshaala/presentation/providers/study_tools/chapter_notes_provider.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/presentation/providers/user/user_profile_provider.dart';

part 'chapter_study_provider.g.dart';

/// Provider for get videos use case
final getVideosUseCaseProvider = Provider<GetVideosUseCase>((ref) {
  return injectionContainer.getVideosUseCase;
});

/// Aggregated chapter study data
class ChapterStudyData {
  final int totalFlashcards;
  final int dueFlashcards;
  final int masteredFlashcards;
  final int totalGlossaryTerms;
  final int totalMindMapNodes;
  final int totalFaqs;
  final int videosWatched;
  final int totalVideos;
  final bool hasSummary;
  final int curatedNotesCount;
  final int personalNotesCount;

  const ChapterStudyData({
    this.totalFlashcards = 0,
    this.dueFlashcards = 0,
    this.masteredFlashcards = 0,
    this.totalGlossaryTerms = 0,
    this.totalMindMapNodes = 0,
    this.totalFaqs = 0,
    this.videosWatched = 0,
    this.totalVideos = 0,
    this.hasSummary = false,
    this.curatedNotesCount = 0,
    this.personalNotesCount = 0,
  });

  /// Total notes count (curated + personal)
  int get totalNotesCount => curatedNotesCount + personalNotesCount;

  /// Overall completion percentage
  double get completionPercentage {
    final total = totalVideos + totalFlashcards;
    if (total == 0) return 0;
    final completed = videosWatched + masteredFlashcards;
    return (completed / total) * 100;
  }

  /// Check if there are any due items
  bool get hasDueItems => dueFlashcards > 0;
}

/// Provider for aggregated chapter study stats
@riverpod
class ChapterStudyStats extends _$ChapterStudyStats {
  @override
  Future<ChapterStudyData> build(String chapterId, String subjectId) async {
    // Fetch data from all study tool providers in parallel
    int totalFlashcards = 0;
    int dueFlashcards = 0;
    int masteredFlashcards = 0;
    int totalGlossaryTerms = 0;
    int totalMindMapNodes = 0;
    int totalFaqs = 0;

    try {
      // Get flashcard stats from all decks in the chapter
      final flashcardDecks = await ref.watch(
        chapterFlashcardsProvider(chapterId, subjectId: subjectId).future,
      );

      for (final deck in flashcardDecks) {
        totalFlashcards += deck.cardCount;

        // Get progress for each deck to calculate due and mastered
        final progressResult = await ref.read(deckProgressProvider(deck.id).future);
        dueFlashcards += progressResult.dueCards;
        masteredFlashcards += progressResult.masteredCards;
      }
    } catch (e) {
      logger.debug('Flashcard data not available for chapter $chapterId: $e');
    }

    try {
      // Get glossary stats
      final glossaryTerms = await ref.watch(
        chapterGlossaryProvider(chapterId, subjectId: subjectId).future,
      );
      totalGlossaryTerms = glossaryTerms.length;
    } catch (e) {
      logger.debug('Glossary data not available for chapter $chapterId: $e');
    }

    try {
      // Get mind map stats
      final mindMap = await ref.watch(
        chapterMindMapProvider(chapterId, subjectId: subjectId).future,
      );
      if (mindMap != null) {
        totalMindMapNodes = mindMap.nodes.length;
      }
    } catch (e) {
      logger.debug('Mind map data not available for chapter $chapterId: $e');
    }

    // Note: FAQ provider is video-based, not chapter-based
    // For chapter-level FAQ count, we'd need to aggregate across all videos
    // For now, leave it at 0
    totalFaqs = 0;

    // Get chapter summary status
    bool hasSummary = false;
    try {
      hasSummary = await ref.watch(
        hasChapterSummaryProvider(chapterId, subjectId).future,
      );
    } catch (e) {
      logger.debug('Summary data not available for chapter $chapterId: $e');
    }

    // Get notes count
    int curatedNotesCount = 0;
    int personalNotesCount = 0;
    try {
      final profileId = ref.read(activeProfileProvider).id;
      final notesCount = await ref.watch(
        chapterNotesCountProvider(chapterId, subjectId, profileId).future,
      );
      curatedNotesCount = notesCount.curated;
      personalNotesCount = notesCount.personal;
    } catch (e) {
      logger.debug('Notes data not available for chapter $chapterId: $e');
    }

    // Get video progress from content and progress providers
    int videosWatched = 0;
    int totalVideos = 0;

    try {
      // Get all videos for this chapter
      final getVideosUseCase = ref.read(getVideosUseCaseProvider);
      final videosResult = await getVideosUseCase.call(
        GetVideosParams(subjectId: subjectId, chapterId: chapterId),
      );

      videosResult.fold(
        (_) {
          // Failed to get videos, keep defaults
        },
        (videos) {
          totalVideos = videos.length;

          // Get video IDs for progress lookup
          final videoIds = videos.map((v) => v.youtubeId).toList();

          // Check progress for each video using progress provider
          final progressState = ref.read(progressProvider);
          for (final videoId in videoIds) {
            if (progressState.isCompleted(videoId)) {
              videosWatched++;
            }
          }
        },
      );
    } catch (e) {
      logger.debug('Video data not available for chapter $chapterId: $e');
    }

    return ChapterStudyData(
      totalFlashcards: totalFlashcards,
      dueFlashcards: dueFlashcards,
      masteredFlashcards: masteredFlashcards,
      totalGlossaryTerms: totalGlossaryTerms,
      totalMindMapNodes: totalMindMapNodes,
      totalFaqs: totalFaqs,
      videosWatched: videosWatched,
      totalVideos: totalVideos,
      hasSummary: hasSummary,
      curatedNotesCount: curatedNotesCount,
      personalNotesCount: personalNotesCount,
    );
  }
}

/// Provider for checking if a chapter has study tools available
@riverpod
Future<bool> chapterHasStudyTools(
  ChapterHasStudyToolsRef ref,
  String chapterId,
  String subjectId,
) async {
  try {
    final stats = await ref.watch(
      chapterStudyStatsProvider(chapterId, subjectId).future,
    );
    return stats.totalFlashcards > 0 ||
        stats.totalGlossaryTerms > 0 ||
        stats.totalMindMapNodes > 0 ||
        stats.totalFaqs > 0 ||
        stats.hasSummary ||
        stats.totalNotesCount > 0;
  } catch (_) {
    return false;
  }
}
