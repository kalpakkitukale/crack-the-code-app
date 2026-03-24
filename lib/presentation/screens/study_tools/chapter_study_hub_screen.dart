/// Chapter Study Hub Screen
/// Central screen for accessing all study tools for a chapter
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/services/content_index.dart';
import 'package:crack_the_code/presentation/providers/study_tools/chapter_study_provider.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';
import 'package:crack_the_code/presentation/screens/study_tools/widgets/study_tool_card.dart';
import 'package:crack_the_code/presentation/screens/study_tools/widgets/chapter_progress_card.dart';
import 'package:crack_the_code/core/widgets/loaders/shimmer_loading.dart';

/// Chapter Study Hub Screen
/// Provides central access to all study tools for a chapter
class ChapterStudyHubScreen extends ConsumerWidget {
  final String chapterId;
  final String subjectId;

  const ChapterStudyHubScreen({
    super.key,
    required this.chapterId,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(chapterStudyStatsProvider(chapterId, subjectId));
    final isJunior = SegmentConfig.isCrackTheCode;

    // Get chapter name from content index
    final contentIndex = ContentIndex();
    final chapter = contentIndex.getChapter(chapterId);
    final chapterName = chapter?.name ?? 'Chapter';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chapterName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Study Hub',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show study tips or help
              _showStudyTips(context);
            },
            icon: const Icon(Icons.help_outline),
            tooltip: 'Study Tips',
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, deviceType) {
            return statsAsync.when(
              loading: () => _buildLoadingState(context),
              error: (error, _) => _buildErrorState(context, error.toString()),
              data: (stats) => _buildContent(
                context,
                ref,
                stats,
                deviceType,
                isJunior,
                chapterName,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              height: 120,
              width: double.infinity,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Row(
              children: [
                Expanded(
                  child: SkeletonBox(
                    height: 140,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: SkeletonBox(
                    height: 140,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: SkeletonBox(
                    height: 140,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: SkeletonBox(
                    height: 140,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Failed to load study tools',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ChapterStudyData stats,
    DeviceType deviceType,
    bool isJunior,
    String chapterName,
  ) {
    final spacing = isJunior ? AppTheme.spacingLg : AppTheme.spacingMd;
    final padding = isJunior ? AppTheme.spacingLg : AppTheme.spacingMd;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Card
          ChapterProgressCard(
            chapterId: chapterId,
            subjectId: subjectId,
            videosWatched: stats.videosWatched,
            totalVideos: stats.totalVideos,
            flashcardsMastered: stats.masteredFlashcards,
            totalFlashcards: stats.totalFlashcards,
          ),

          SizedBox(height: spacing * 1.5),

          // Section Title
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              'Study Tools',
              style: (isJunior
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.titleSmall)?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: spacing),

          // Study Tools Grid
          _buildStudyToolsGrid(context, stats, isJunior, deviceType),

          SizedBox(height: spacing * 1.5),

          // Chapter Quiz Card
          _buildQuizCard(context, ref, isJunior),

          SizedBox(height: spacing),

          // Videos Card
          _buildVideosCard(context, isJunior, chapterName),
        ],
      ),
    );
  }

  Widget _buildStudyToolsGrid(
    BuildContext context,
    ChapterStudyData stats,
    bool isJunior,
    DeviceType deviceType,
  ) {
    final crossAxisCount = deviceType == DeviceType.mobile ? 2 : 4;
    // Increased aspect ratio to prevent overflow (lower = taller cards)
    final aspectRatio = isJunior ? 0.85 : 0.95;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: AppTheme.spacingMd,
      crossAxisSpacing: AppTheme.spacingMd,
      childAspectRatio: aspectRatio,
      children: [
        // Mind Map
        StudyToolCard(
          icon: Icons.account_tree,
          title: 'Mind Map',
          subtitle: stats.totalMindMapNodes > 0
              ? '${stats.totalMindMapNodes} nodes'
              : 'Visual overview',
          color: Colors.indigo,
          onTap: () => _navigateToMindMap(context),
        ),

        // Glossary
        StudyToolCard(
          icon: Icons.menu_book,
          title: 'Glossary',
          subtitle: stats.totalGlossaryTerms > 0
              ? '${stats.totalGlossaryTerms} terms'
              : 'Key terms',
          color: Colors.teal,
          onTap: () => _navigateToGlossary(context),
        ),

        // Flashcards
        StudyToolCard(
          icon: Icons.style,
          title: 'Flashcards',
          subtitle: stats.totalFlashcards > 0
              ? '${stats.totalFlashcards} cards'
              : 'Review cards',
          color: Colors.purple,
          badge: stats.dueFlashcards > 0
              ? DueBadge(count: stats.dueFlashcards)
              : null,
          onTap: () => _navigateToFlashcards(context),
        ),

        // Summary
        StudyToolCard(
          icon: Icons.summarize,
          title: 'Summary',
          subtitle: stats.hasSummary ? 'Chapter overview' : 'Coming soon',
          color: Colors.deepOrange,
          onTap: stats.hasSummary ? () => _navigateToSummary(context) : null,
        ),

        // Notes
        StudyToolCard(
          icon: Icons.note_alt,
          title: 'Notes',
          subtitle: _getNotesSubtitle(stats),
          color: Colors.amber,
          badge: stats.personalNotesCount > 0
              ? PersonalBadge(count: stats.personalNotesCount)
              : null,
          onTap: () => _navigateToNotes(context),
        ),

        // Q&A / FAQs
        if (!SegmentConfig.isCrackTheCode)
          StudyToolCard(
            icon: Icons.question_answer,
            title: 'Q&A',
            subtitle: stats.totalFaqs > 0
                ? '${stats.totalFaqs} FAQs'
                : 'Common questions',
            color: Colors.orange,
            onTap: () => _navigateToVideos(context),
          ),
      ],
    );
  }

  String _getNotesSubtitle(ChapterStudyData stats) {
    if (stats.totalNotesCount == 0) return 'Study tips & notes';
    if (stats.curatedNotesCount > 0 && stats.personalNotesCount > 0) {
      return '${stats.curatedNotesCount} tips, ${stats.personalNotesCount} personal';
    }
    if (stats.curatedNotesCount > 0) {
      return '${stats.curatedNotesCount} study tips';
    }
    return '${stats.personalNotesCount} personal notes';
  }

  Widget _buildQuizCard(BuildContext context, WidgetRef ref, bool isJunior) {
    return StudyToolCard(
      icon: Icons.quiz,
      title: 'Chapter Quiz',
      subtitle: 'Test your knowledge of this chapter',
      color: Colors.green,
      isLarge: true,
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Start',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      onTap: () => _navigateToQuiz(context, ref),
    );
  }

  Widget _buildVideosCard(BuildContext context, bool isJunior, String chapterName) {
    return StudyToolCard(
      icon: Icons.play_circle_outline,
      title: 'Continue to Videos',
      subtitle: 'Watch video lessons for $chapterName',
      color: Colors.blue,
      isLarge: true,
      onTap: () => _navigateToVideos(context),
    );
  }

  void _navigateToMindMap(BuildContext context) {
    context.push(RouteConstants.getMindMapPath(chapterId));
  }

  void _navigateToGlossary(BuildContext context) {
    context.push(
      RouteConstants.getGlossaryPath(chapterId),
      extra: {'subjectId': subjectId},
    );
  }

  void _navigateToFlashcards(BuildContext context) {
    // Navigate to flashcard decks browser for this chapter
    context.push(RouteConstants.getFlashcardDecksPath(chapterId, subjectId: subjectId));
  }

  void _navigateToSummary(BuildContext context) {
    context.push(RouteConstants.getChapterSummaryPath(chapterId, subjectId: subjectId));
  }

  void _navigateToNotes(BuildContext context) {
    context.push(RouteConstants.getChapterNotesPath(chapterId, subjectId: subjectId));
  }

  void _navigateToQuiz(BuildContext context, WidgetRef ref) {
    final profileId = ref.read(activeProfileProvider).id;
    final studentId = profileId.isNotEmpty ? profileId : 'default_student';
    context.push(RouteConstants.getQuizPath(chapterId, studentId));
  }

  void _navigateToVideos(BuildContext context) {
    // Navigate back to the topic/video list for this chapter
    context.pop();
  }

  void _showStudyTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.amber.shade700),
            const SizedBox(width: 8),
            const Text('Study Tips'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTip(
                context,
                '1. Start with the Mind Map',
                'Get an overview of all concepts before diving into details.',
              ),
              const SizedBox(height: 12),
              _buildTip(
                context,
                '2. Watch Videos',
                'Learn concepts through video lessons.',
              ),
              const SizedBox(height: 12),
              _buildTip(
                context,
                '3. Review Flashcards',
                'Use spaced repetition to memorize key facts.',
              ),
              const SizedBox(height: 12),
              _buildTip(
                context,
                '4. Check the Glossary',
                'Look up unfamiliar terms as you study.',
              ),
              const SizedBox(height: 12),
              _buildTip(
                context,
                '5. Take the Quiz',
                'Test yourself to identify gaps in your knowledge.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
