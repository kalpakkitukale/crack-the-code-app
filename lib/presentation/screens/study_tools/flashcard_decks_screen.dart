/// Flashcard Decks Screen
/// Lists all flashcard decks in a chapter with progress
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/services/content_index.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/widgets/loaders/shimmer_loading.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard_progress.dart';
import 'package:crack_the_code/presentation/providers/study_tools/flashcard_provider.dart';

/// Screen showing all flashcard decks in a chapter
class FlashcardDecksScreen extends ConsumerWidget {
  final String chapterId;
  final String subjectId;

  const FlashcardDecksScreen({
    super.key,
    required this.chapterId,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(
      chapterFlashcardsProvider(chapterId, subjectId: subjectId),
    );
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
              'Flashcards',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              chapterName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: decksAsync.when(
          loading: () => _buildLoadingState(),
          error: (error, _) => _buildErrorState(context, error.toString()),
          data: (decks) => decks.isEmpty
              ? _buildEmptyState(context)
              : _buildDecksList(context, ref, decks, isJunior),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: ListView.separated(
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingMd),
          itemBuilder: (_, __) => SkeletonBox(
            height: 120,
            width: double.infinity,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
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
              'Failed to load flashcard decks',
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.style_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No flashcard decks available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Flashcards for this chapter will appear here',
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

  Widget _buildDecksList(
    BuildContext context,
    WidgetRef ref,
    List<FlashcardDeck> decks,
    bool isJunior,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: decks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingMd),
      itemBuilder: (context, index) {
        final deck = decks[index];
        return _FlashcardDeckCard(
          deck: deck,
          isJunior: isJunior,
          onTap: () => _navigateToStudy(context, deck.id),
        );
      },
    );
  }

  void _navigateToStudy(BuildContext context, String deckId) {
    context.push(RouteConstants.getFlashcardStudyPath(deckId));
  }
}

/// Card showing flashcard deck with progress
class _FlashcardDeckCard extends ConsumerWidget {
  final FlashcardDeck deck;
  final bool isJunior;
  final VoidCallback onTap;

  const _FlashcardDeckCard({
    required this.deck,
    required this.isJunior,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(deckProgressProvider(deck.id));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: EdgeInsets.all(isJunior ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.style,
                      color: Colors.purple,
                      size: isJunior ? 28 : 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title and card count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deck.name,
                          style: isJunior
                              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )
                              : Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${deck.cardCount} cards',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress section
              progressAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
                data: (progress) => _buildProgressSection(context, progress),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, DeckProgress progress) {
    final masteryPercentage = progress.masteryPercentage;
    final hasDueCards = progress.hasDueCards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: masteryPercentage / 100,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              masteryPercentage >= 80
                  ? Colors.green
                  : masteryPercentage >= 50
                      ? Colors.orange
                      : Colors.purple,
            ),
            minHeight: 8,
          ),
        ),

        const SizedBox(height: 12),

        // Stats row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Mastery
            _StatChip(
              icon: Icons.star,
              label: '${progress.masteredCards} mastered',
              color: Colors.amber,
            ),

            // Reviewed
            _StatChip(
              icon: Icons.check_circle,
              label: '${progress.reviewedCards}/${progress.totalCards} reviewed',
              color: Colors.blue,
            ),

            // Due
            if (hasDueCards)
              _StatChip(
                icon: Icons.schedule,
                label: '${progress.dueCards} due',
                color: Colors.orange,
                highlighted: true,
              ),
          ],
        ),
      ],
    );
  }
}

/// Small stat chip for deck card
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool highlighted;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlighted ? color.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: highlighted ? Border.all(color: color.withValues(alpha: 0.5)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: highlighted ? color : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
