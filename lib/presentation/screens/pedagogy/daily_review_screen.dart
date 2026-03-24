import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/presentation/providers/pedagogy/mastery_provider.dart';

/// Daily Review Screen
/// Shows concepts and flashcards due for review based on spaced repetition
class DailyReviewScreen extends ConsumerStatefulWidget {
  final String studentId;

  const DailyReviewScreen({
    super.key,
    required this.studentId,
  });

  @override
  ConsumerState<DailyReviewScreen> createState() => _DailyReviewScreenState();
}

class _DailyReviewScreenState extends ConsumerState<DailyReviewScreen> {
  int _currentIndex = 0;
  final Set<String> _reviewedItems = {};
  bool _showingAnswer = false;

  @override
  Widget build(BuildContext context) {
    final isJunior = SegmentConfig.isJunior;
    final masteryState = ref.watch(masteryProvider);

    // Get items due for review (mastery < 80% or last reviewed > 7 days ago)
    final dueItems = masteryState.conceptMasteries.values.where((m) {
      final daysSinceReview = DateTime.now().difference(m.lastAssessed).inDays;
      return m.masteryScore < 0.8 || daysSinceReview >= 7;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isJunior ? 'Daily Practice' : 'Daily Review',
          style: context.textTheme.titleLarge,
        ),
        actions: [
          if (dueItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_reviewedItems.length}/${dueItems.length}',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: masteryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dueItems.isEmpty
              ? _buildEmptyState(context, isJunior)
              : _buildReviewContent(context, dueItems, isJunior),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isJunior) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isJunior ? Icons.celebration : Icons.check_circle_outline,
              size: isJunior ? 100 : 80,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              isJunior ? 'All Done!' : 'No Reviews Due',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isJunior
                  ? 'Great job! Come back tomorrow for more practice.'
                  : 'You\'re all caught up! Check back later for new review items.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(isJunior ? 'Go Back' : 'Return'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent(
    BuildContext context,
    List<dynamic> dueItems,
    bool isJunior,
  ) {
    if (_currentIndex >= dueItems.length) {
      return _buildCompletionState(context, isJunior);
    }

    final currentItem = dueItems[_currentIndex];
    final progress = (_currentIndex + 1) / dueItems.length;

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: progress,
          backgroundColor: context.colorScheme.surfaceContainerHighest,
          color: context.colorScheme.primary,
          minHeight: 6,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(isJunior ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Concept card
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showingAnswer = !_showingAnswer;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Padding(
                        padding: EdgeInsets.all(isJunior ? 32 : 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Category chip
                            Chip(
                              label: Text(
                                currentItem.conceptId.split('_').first.toUpperCase(),
                                style: TextStyle(
                                  fontSize: isJunior ? 14 : 12,
                                ),
                              ),
                              backgroundColor: context.colorScheme.primaryContainer,
                            ),
                            const SizedBox(height: 24),

                            // Concept name
                            Text(
                              currentItem.conceptId.replaceAll('_', ' ').toUpperCase(),
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isJunior ? 28 : 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Mastery indicator
                            if (_showingAnswer) ...[
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Current Mastery: ',
                                    style: context.textTheme.bodyLarge,
                                  ),
                                  Text(
                                    '${(currentItem.masteryScore * 100).toInt()}%',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _getMasteryColor(
                                        context,
                                        currentItem.masteryScore,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Last reviewed: ${_formatDate(currentItem.lastAssessed)}',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 24),
                              Text(
                                isJunior ? 'Tap to see details!' : 'Tap to reveal',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Rating buttons
                if (_showingAnswer) ...[
                  Text(
                    isJunior ? 'How well do you know this?' : 'Rate your recall:',
                    style: context.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRatingButton(
                          context: context,
                          label: isJunior ? 'Hard' : 'Forgot',
                          color: Colors.red,
                          icon: Icons.close,
                          onTap: () => _recordReview(currentItem.conceptId, 0.3),
                          isJunior: isJunior,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildRatingButton(
                          context: context,
                          label: isJunior ? 'Okay' : 'Struggled',
                          color: Colors.orange,
                          icon: Icons.help_outline,
                          onTap: () => _recordReview(currentItem.conceptId, 0.6),
                          isJunior: isJunior,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildRatingButton(
                          context: context,
                          label: isJunior ? 'Easy!' : 'Got it',
                          color: Colors.green,
                          icon: Icons.check,
                          onTap: () => _recordReview(currentItem.conceptId, 1.0),
                          isJunior: isJunior,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        _showingAnswer = true;
                      });
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, isJunior ? 56 : 48),
                    ),
                    child: Text(
                      isJunior ? 'Show Answer' : 'Reveal',
                      style: TextStyle(fontSize: isJunior ? 18 : 16),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Skip button
                TextButton(
                  onPressed: _skipItem,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingButton({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    required bool isJunior,
  }) {
    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        minimumSize: Size(0, isJunior ? 64 : 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isJunior ? 28 : 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isJunior ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionState(BuildContext context, bool isJunior) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: isJunior ? 120 : 100,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),
            Text(
              isJunior ? 'Amazing Job!' : 'Review Complete!',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You reviewed ${_reviewedItems.length} concepts today.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Done'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                      RouteConstants.flashcardDecks,
                      pathParameters: {'chapterId': 'all'},
                    );
                  },
                  icon: const Icon(Icons.style),
                  label: const Text('Flashcards'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _recordReview(String conceptId, double score) {
    setState(() {
      _reviewedItems.add(conceptId);
      _currentIndex++;
      _showingAnswer = false;
    });

    // Update mastery in provider using checkpoint score
    ref.read(masteryProvider.notifier).updateMastery(
      studentId: widget.studentId,
      conceptId: conceptId,
      checkpointScore: score,
    );
  }

  void _skipItem() {
    setState(() {
      _currentIndex++;
      _showingAnswer = false;
    });
  }

  Color _getMasteryColor(BuildContext context, double mastery) {
    if (mastery >= 0.8) return Colors.green;
    if (mastery >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7} weeks ago';
    return '${diff.inDays ~/ 30} months ago';
  }
}
