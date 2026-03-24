/// Review Due Flashcards Screen
/// Allows studying all due flashcards across all decks
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard.dart';
import 'package:streamshaala/domain/entities/study_tools/flashcard_progress.dart';
import 'package:streamshaala/presentation/providers/study_tools/flashcard_provider.dart';
import 'package:streamshaala/presentation/providers/study_tools/flashcard_stats_provider.dart';
import 'package:streamshaala/presentation/screens/study_tools/widgets/flashcard_badges.dart';
import 'package:streamshaala/presentation/screens/study_tools/widgets/streak_banner.dart';
import 'package:streamshaala/presentation/screens/study_tools/widgets/study_completion_screen.dart';

/// Screen for reviewing all due flashcards
class ReviewDueScreen extends ConsumerStatefulWidget {
  const ReviewDueScreen({super.key});

  @override
  ConsumerState<ReviewDueScreen> createState() => _ReviewDueScreenState();
}

class _ReviewDueScreenState extends ConsumerState<ReviewDueScreen> {
  List<FlashcardProgress> _dueCards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  int _knownCount = 0;
  int _unknownCount = 0;
  bool _isComplete = false;
  DateTime? _startTime;
  Flashcard? _currentCard;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadDueCards();
  }

  Future<void> _loadDueCards() async {
    try {
      final dueCardsResult = await ref.read(dueCardsProvider.future);
      setState(() {
        _dueCards = dueCardsResult;
        _isLoading = false;
        if (_dueCards.isNotEmpty) {
          _loadCurrentCard();
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCurrentCard() async {
    if (_currentIndex >= _dueCards.length) {
      setState(() => _isComplete = true);
      return;
    }

    final cardProgress = _dueCards[_currentIndex];
    // For now, create a placeholder card from progress
    // In a real implementation, we'd load the full card from the repository
    setState(() {
      _currentCard = Flashcard(
        id: cardProgress.cardId,
        deckId: '',
        front: 'Card #${_currentIndex + 1}',
        back: 'Answer for card #${_currentIndex + 1}',
        createdAt: DateTime.now(),
      );
      _isFlipped = false;
    });
  }

  void _flipCard() {
    setState(() => _isFlipped = !_isFlipped);
  }

  Future<void> _markKnown() async {
    if (_currentCard == null) return;

    final repository = ref.read(flashcardRepositoryProvider);
    await repository.recordReview(_currentCard!.id, true);

    setState(() {
      _knownCount++;
      _currentIndex++;
    });

    if (_currentIndex >= _dueCards.length) {
      _completeSession();
    } else {
      _loadCurrentCard();
    }
  }

  Future<void> _markUnknown() async {
    if (_currentCard == null) return;

    final repository = ref.read(flashcardRepositoryProvider);
    await repository.recordReview(_currentCard!.id, false);

    setState(() {
      _unknownCount++;
      _currentIndex++;
    });

    if (_currentIndex >= _dueCards.length) {
      _completeSession();
    } else {
      _loadCurrentCard();
    }
  }

  void _completeSession() {
    setState(() => _isComplete = true);
    // Record stats
    ref.read(flashcardStatsProvider.notifier).recordStudySession(
          correct: _knownCount,
          incorrect: _unknownCount,
        );
  }

  void _reset() {
    setState(() {
      _currentIndex = 0;
      _isFlipped = false;
      _knownCount = 0;
      _unknownCount = 0;
      _isComplete = false;
      _startTime = DateTime.now();
    });
    _loadCurrentCard();
  }

  @override
  Widget build(BuildContext context) {
    final isJunior = SegmentConfig.isJunior;
    final statsAsync = ref.watch(flashcardStatsProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Due Cards')),
        body: const _ReviewDueShimmer(),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Due Cards')),
        body: _buildErrorState(context, _error!),
      );
    }

    if (_dueCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Due Cards')),
        body: _buildEmptyState(context, isJunior),
      );
    }

    if (_isComplete) {
      final studyTime = _startTime != null
          ? DateTime.now().difference(_startTime!)
          : Duration.zero;

      return statsAsync.when(
        data: (stats) => StudyCompletionScreen(
          correctCount: _knownCount,
          incorrectCount: _unknownCount,
          currentStreak: stats.currentStreak,
          bestStreak: stats.bestStreak,
          studyTime: studyTime,
          isJunior: isJunior,
          onDone: () => Navigator.pop(context),
          onStudyAgain: _reset,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => StudyCompletionScreen(
          correctCount: _knownCount,
          incorrectCount: _unknownCount,
          currentStreak: 0,
          bestStreak: 0,
          studyTime: studyTime,
          isJunior: isJunior,
          onDone: () => Navigator.pop(context),
          onStudyAgain: _reset,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Due Cards'),
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
                '${_currentIndex + 1}/${_dueCards.length}',
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
            value: _dueCards.isNotEmpty
                ? _currentIndex / _dueCards.length
                : 0,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),

          // Flashcard
          if (_currentCard != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: _ReviewFlashcardWidget(
                  card: _currentCard!,
                  isFlipped: _isFlipped,
                  isJunior: isJunior,
                  onFlip: _flipCard,
                ),
              ),
            ),

          // Action buttons (show appropriate rating system based on segment)
          if (_isFlipped)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: isJunior
                  ? SimpleRatingButtons(
                      isJunior: isJunior,
                      onKnow: _markKnown,
                      onDontKnow: _markUnknown,
                    )
                  : RatingButtons(
                      isJunior: isJunior,
                      onRate: (result) {
                        final isKnown = result == ReviewResult.good ||
                            result == ReviewResult.easy;
                        if (isKnown) {
                          _markKnown();
                        } else {
                          _markUnknown();
                        }
                      },
                    ),
            ),

          // Tap to flip hint (when not flipped)
          if (!_isFlipped)
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
              'Failed to load due cards',
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

  Widget _buildEmptyState(BuildContext context, bool isJunior) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: isJunior ? 100 : 80,
              color: Colors.green,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'All Caught Up!',
              style: isJunior
                  ? Theme.of(context).textTheme.headlineLarge
                  : Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'You have no cards due for review.\nGreat job keeping up with your studies!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: isJunior ? 14 : 12,
                  horizontal: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Review flashcard widget with flip animation
class _ReviewFlashcardWidget extends StatefulWidget {
  final Flashcard card;
  final bool isFlipped;
  final bool isJunior;
  final VoidCallback onFlip;

  const _ReviewFlashcardWidget({
    required this.card,
    required this.isFlipped,
    required this.isJunior,
    required this.onFlip,
  });

  @override
  State<_ReviewFlashcardWidget> createState() => _ReviewFlashcardWidgetState();
}

class _ReviewFlashcardWidgetState extends State<_ReviewFlashcardWidget>
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
  void didUpdateWidget(_ReviewFlashcardWidget oldWidget) {
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
            ..setEntry(3, 2, 0.001)
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
          colors: [Colors.indigo.shade50, Colors.blue.shade50],
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            // Content
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
            // Hint
            if (widget.card.hint != null && widget.card.hint!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, size: 20, color: Colors.amber.shade700),
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
            // Tap to flip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, size: 16, color: Colors.grey.shade600),
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
          colors: [Colors.green.shade50, Colors.teal.shade50],
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
            // Header
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
            // Content
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

/// Shimmer loading for review due screen
class _ReviewDueShimmer extends StatelessWidget {
  const _ReviewDueShimmer();

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
