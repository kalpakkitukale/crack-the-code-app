/// Flashcard Section widget for video flashcards
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';
import 'package:streamshaala/presentation/providers/study_tools/flashcard_provider.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';

/// Flashcard section in video player tabs
class FlashcardSection extends ConsumerWidget {
  final String? topicId;

  const FlashcardSection({
    super.key,
    this.topicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (topicId == null || topicId!.isEmpty) {
      return _buildEmptyState(context, 'No topic associated with this video');
    }

    final deckAsync = ref.watch(topicFlashcardsProvider(topicId!));
    final isJunior = SegmentConfig.isJunior;

    return deckAsync.when(
      loading: () => const _FlashcardShimmer(),
      error: (error, _) => _buildErrorState(context, error.toString()),
      data: (deck) {
        if (deck == null || deck.isEmpty) {
          return _buildEmptyState(context, 'No flashcards available for this topic');
        }

        return Column(
          children: [
            // Deck Header
            _DeckHeader(deck: deck, isJunior: isJunior),

            // Cards Preview
            Expanded(
              child: _CardsPreview(
                cards: deck.sortedCards.take(3).toList(),
                totalCards: deck.cardCount,
                isJunior: isJunior,
                onStartStudy: () => _navigateToStudy(context, deck.id),
              ),
            ),

            // Study Button
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToStudy(context, deck.id),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    'Study ${deck.cardCount} Cards',
                    style: isJunior
                        ? Theme.of(context).textTheme.titleMedium
                        : null,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isJunior ? 16 : 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToStudy(BuildContext context, String deckId) {
    context.push(RouteConstants.getFlashcardStudyPath(deckId));
  }

  Widget _buildEmptyState(BuildContext context, String message) {
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
              'No Flashcards',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              message,
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
              'Failed to load flashcards',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Deck header with info
class _DeckHeader extends StatelessWidget {
  final FlashcardDeck deck;
  final bool isJunior;

  const _DeckHeader({
    required this.deck,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.style,
              color: Theme.of(context).colorScheme.onPrimary,
              size: isJunior ? 28 : 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deck.name,
                  style: isJunior
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                ),
                if (deck.hasDescription)
                  Text(
                    deck.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${deck.cardCount} cards',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preview of flashcards
class _CardsPreview extends StatelessWidget {
  final List<Flashcard> cards;
  final int totalCards;
  final bool isJunior;
  final VoidCallback onStartStudy;

  const _CardsPreview({
    required this.cards,
    required this.totalCards,
    required this.isJunior,
    required this.onStartStudy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ...cards.map((card) => _FlashcardPreviewItem(
                card: card,
                isJunior: isJunior,
              )),
          if (totalCards > cards.length) ...[
            const SizedBox(height: AppTheme.spacingMd),
            Center(
              child: Text(
                '+ ${totalCards - cards.length} more cards',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual flashcard preview
class _FlashcardPreviewItem extends StatelessWidget {
  final Flashcard card;
  final bool isJunior;

  const _FlashcardPreviewItem({
    required this.card,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.help_outline,
              size: isJunior ? 24 : 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.front,
                    style: isJunior
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (card.hasHint) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Hint: ${card.hint}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            fontStyle: FontStyle.italic,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.flip,
              size: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading state for flashcards
class _FlashcardShimmer extends StatelessWidget {
  const _FlashcardShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          children: [
            const SkeletonBox(height: 80, width: double.infinity),
            const SizedBox(height: AppTheme.spacingMd),
            ...List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: SkeletonBox(height: 60, width: double.infinity),
              ),
            ),
            const Spacer(),
            const SkeletonBox(height: 48, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
