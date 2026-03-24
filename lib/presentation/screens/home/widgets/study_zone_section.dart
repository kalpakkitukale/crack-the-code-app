/// Study Zone Section for Home Screen
/// Shows spaced repetition stats and due flashcards
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/presentation/providers/study_tools/flashcard_provider.dart';
import 'package:streamshaala/presentation/providers/study_tools/flashcard_stats_provider.dart';

/// Study Zone Section showing flashcard stats and due cards
class StudyZoneSection extends ConsumerWidget {
  const StudyZoneSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueCardsAsync = ref.watch(dueCardsProvider);
    final statsAsync = ref.watch(flashcardStatsProvider);
    final isJunior = SegmentConfig.isJunior;

    return statsAsync.when(
      data: (stats) => dueCardsAsync.when(
        data: (dueCards) => _buildSection(
          context,
          stats,
          dueCards.length,
          isJunior,
        ),
        loading: () => _buildSection(context, stats, 0, isJunior),
        error: (_, __) => _buildSection(context, stats, 0, isJunior),
      ),
      loading: () => const _StudyZoneShimmer(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    FlashcardStudyStats stats,
    int dueCardsCount,
    bool isJunior,
  ) {
    // Don't show section if user hasn't studied any cards yet
    if (stats.totalCardsStudied == 0 && dueCardsCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.indigo.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  color: Colors.indigo.shade700,
                  size: isJunior ? 24 : 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Study Zone',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                      fontSize: isJunior ? 20 : 18,
                    ),
              ),
              const Spacer(),
              if (stats.currentStreak > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${stats.currentStreak}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Due cards alert (if any)
          if (dueCardsCount > 0) ...[
            _DueCardsAlert(count: dueCardsCount, isJunior: isJunior),
            const SizedBox(height: 16),
          ],

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickStat(
                icon: Icons.local_fire_department,
                value: '${stats.currentStreak}',
                label: 'Streak',
                color: Colors.orange,
                isJunior: isJunior,
              ),
              _QuickStat(
                icon: Icons.style,
                value: '${stats.cardsStudiedToday}',
                label: 'Today',
                color: Colors.blue,
                isJunior: isJunior,
              ),
              _QuickStat(
                icon: Icons.percent,
                value: '${stats.todayAccuracy}%',
                label: 'Accuracy',
                color: _getAccuracyColor(stats.todayAccuracy),
                isJunior: isJunior,
              ),
            ],
          ),

          // Start review button
          if (dueCardsCount > 0) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/review-due'),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  'Review $dueCardsCount Cards',
                  style: isJunior
                      ? Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          )
                      : null,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(
                    vertical: isJunior ? 14 : 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getAccuracyColor(int accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }
}

/// Due cards alert banner
class _DueCardsAlert extends StatelessWidget {
  final int count;
  final bool isJunior;

  const _DueCardsAlert({
    required this.count,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: Colors.orange.shade700,
            size: isJunior ? 24 : 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count ${count == 1 ? 'card' : 'cards'} due for review',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                        fontSize: isJunior ? 16 : 14,
                      ),
                ),
                Text(
                  'Keep your streak alive!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick stat display
class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isJunior;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isJunior ? 24 : 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: isJunior ? 18 : 16,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

/// Shimmer loading placeholder for Study Zone
class _StudyZoneShimmer extends StatelessWidget {
  const _StudyZoneShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
