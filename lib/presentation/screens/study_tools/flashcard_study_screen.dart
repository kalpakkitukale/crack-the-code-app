/// Flashcard Study Screen for interactive flashcard learning
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/widgets/loaders/shimmer_loading.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard_progress.dart';
import 'package:crack_the_code/presentation/providers/study_tools/flashcard_provider.dart';
import 'package:crack_the_code/presentation/providers/study_tools/flashcard_stats_provider.dart';
import 'package:crack_the_code/presentation/screens/study_tools/widgets/flashcard_badges.dart';
import 'package:crack_the_code/presentation/screens/study_tools/widgets/streak_banner.dart';
import 'package:crack_the_code/presentation/screens/study_tools/widgets/study_completion_screen.dart';

/// Flashcard Study Screen
/// Full-screen interactive flashcard study experience
class FlashcardStudyScreen extends ConsumerStatefulWidget {
  final String deckId;

  const FlashcardStudyScreen({
    super.key,
    required this.deckId,
  });

  @override
  ConsumerState<FlashcardStudyScreen> createState() =>
      _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends ConsumerState<FlashcardStudyScreen> {
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // Initialize study session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(flashcardStudySessionProvider(widget.deckId).notifier)
          .initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionState =
        ref.watch(flashcardStudySessionProvider(widget.deckId));
    final statsAsync = ref.watch(flashcardStatsProvider);
    final isJunior = SegmentConfig.isCrackTheCode;

    if (sessionState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Cards')),
        body: const _FlashcardStudyShimmer(),
      );
    }

    if (sessionState.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Cards')),
        body: _buildErrorState(context, sessionState.error!),
      );
    }

    if (sessionState.isComplete) {
      final studyTime = _startTime != null
          ? DateTime.now().difference(_startTime!)
          : sessionState.duration;

      // Record study session stats
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(flashcardStatsProvider.notifier).recordStudySession(
              correct: sessionState.knownCount,
              incorrect: sessionState.unknownCount,
            );
      });

      return statsAsync.when(
        data: (stats) => StudyCompletionScreen(
          correctCount: sessionState.knownCount,
          incorrectCount: sessionState.unknownCount,
          currentStreak: stats.currentStreak,
          bestStreak: stats.bestStreak,
          studyTime: studyTime,
          isJunior: isJunior,
          onDone: () => Navigator.pop(context),
          onStudyAgain: () {
            _startTime = DateTime.now();
            ref
                .read(flashcardStudySessionProvider(widget.deckId).notifier)
                .reset();
          },
          onReviewMistakes: sessionState.unknownCount > 0
              ? () {
                  _startTime = DateTime.now();
                  ref
                      .read(
                          flashcardStudySessionProvider(widget.deckId).notifier)
                      .resetWithMistakes();
                }
              : null,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => StudyCompletionScreen(
          correctCount: sessionState.knownCount,
          incorrectCount: sessionState.unknownCount,
          currentStreak: 0,
          bestStreak: 0,
          studyTime: studyTime,
          isJunior: isJunior,
          onDone: () => Navigator.pop(context),
          onStudyAgain: () {
            _startTime = DateTime.now();
            ref
                .read(flashcardStudySessionProvider(widget.deckId).notifier)
                .reset();
          },
        ),
      );
    }

    // Guard against null currentCard
    final currentCard = sessionState.currentCard;
    if (currentCard == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Cards')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Cards'),
        actions: [
          // Streak indicator
          statsAsync.when(
            data: (stats) => stats.currentStreak > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CompactStreakIndicator(streak: stats.currentStreak),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // Progress indicator
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${sessionState.currentIndex + 1}/${sessionState.totalCards}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: sessionState.progressPercentage,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),

          // Flashcard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: _EnhancedFlashcardWidget(
                card: currentCard,
                progress: sessionState.getProgressForCard(currentCard.id),
                isFlipped: sessionState.isFlipped,
                isJunior: isJunior,
                onFlip: () {
                  ref
                      .read(
                          flashcardStudySessionProvider(widget.deckId).notifier)
                      .flipCard();
                },
              ),
            ),
          ),

          // Action buttons (show appropriate rating system based on segment)
          if (sessionState.isFlipped)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: isJunior
                  ? SimpleRatingButtons(
                      isJunior: isJunior,
                      onKnow: () {
                        ref
                            .read(flashcardStudySessionProvider(widget.deckId)
                                .notifier)
                            .markKnown();
                      },
                      onDontKnow: () {
                        ref
                            .read(flashcardStudySessionProvider(widget.deckId)
                                .notifier)
                            .markUnknown();
                      },
                    )
                  : RatingButtons(
                      isJunior: isJunior,
                      onRate: (result) {
                        // Map rating to known/unknown
                        final isKnown = result == ReviewResult.good ||
                            result == ReviewResult.easy;
                        if (isKnown) {
                          ref
                              .read(flashcardStudySessionProvider(widget.deckId)
                                  .notifier)
                              .markKnown();
                        } else {
                          ref
                              .read(flashcardStudySessionProvider(widget.deckId)
                                  .notifier)
                              .markUnknown();
                        }
                      },
                    ),
            ),

          // Tap to flip hint (when not flipped)
          if (!sessionState.isFlipped)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tap card to reveal answer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
              'Failed to load cards',
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
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced flashcard widget with 3D flip animation and badges
class _EnhancedFlashcardWidget extends StatefulWidget {
  final Flashcard card;
  final FlashcardProgress? progress;
  final bool isFlipped;
  final bool isJunior;
  final VoidCallback onFlip;

  const _EnhancedFlashcardWidget({
    required this.card,
    this.progress,
    required this.isFlipped,
    required this.isJunior,
    required this.onFlip,
  });

  @override
  State<_EnhancedFlashcardWidget> createState() =>
      _EnhancedFlashcardWidgetState();
}

class _EnhancedFlashcardWidgetState extends State<_EnhancedFlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animation.addListener(() {
      if (!mounted) return;
      if (_animation.value >= 0.5 && _showFront) {
        setState(() => _showFront = false);
      } else if (_animation.value < 0.5 && !_showFront) {
        setState(() => _showFront = true);
      }
    });
  }

  @override
  void didUpdateWidget(_EnhancedFlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    // Reset when card changes
    if (widget.card.id != oldWidget.card.id) {
      _controller.reset();
      _showFront = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(angle);

          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: _showFront
                ? _buildFrontCard(context)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBackCard(context),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade50,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(widget.isJunior ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.isJunior ? 24 : 20),
        child: Column(
          children: [
            // Top row: Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DifficultyBadge(difficulty: widget.card.difficulty),
                MasteryBadge(
                  isMastered: widget.progress?.masteryLevel == MasteryLevel.mastered,
                  reviewCount: widget.progress?.reviewCount ?? 0,
                  isNew: widget.progress == null || widget.progress!.reviewCount == 0,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Question',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Question content
            Expanded(
              child: Center(
                child: Text(
                  widget.card.front,
                  textAlign: TextAlign.center,
                  style: widget.isJunior
                      ? Theme.of(context).textTheme.headlineMedium
                      : Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),

            // Hint (if available)
            if (widget.card.hint != null && widget.card.hint!.isNotEmpty) ...[
              const Divider(height: 1),
              const SizedBox(height: AppTheme.spacingSm),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      size: 20,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.card.hint!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.amber.shade900,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppTheme.spacingMd),

            // Tap to flip indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tap to flip',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.teal.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(widget.isJunior ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.isJunior ? 24 : 20),
        child: Column(
          children: [
            // Answer badge
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Answer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Answer content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.card.back,
                      textAlign: TextAlign.center,
                      style: widget.isJunior
                          ? Theme.of(context).textTheme.headlineMedium
                          : Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    Icon(
                      Icons.check_circle,
                      size: widget.isJunior ? 48 : 40,
                      color: Colors.green.shade600,
                    ),
                  ],
                ),
              ),
            ),

            // Rate prompt
            Text(
              'Rate your answer below',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for flashcard study
class _FlashcardStudyShimmer extends StatelessWidget {
  const _FlashcardStudyShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          children: [
            const SkeletonBox(height: 8, width: double.infinity),
            const SizedBox(height: AppTheme.spacingLg),
            Expanded(
              child: SkeletonBox(
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Row(
              children: [
                Expanded(
                    child: SkeletonBox(height: 50, width: double.infinity)),
                SizedBox(width: AppTheme.spacingMd),
                Expanded(
                    child: SkeletonBox(height: 50, width: double.infinity)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
