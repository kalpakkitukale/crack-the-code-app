import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';

class CollectionOverviewCard extends ConsumerWidget {
  final VoidCallback onOpenCollection;

  const CollectionOverviewCard({super.key, required this.onOpenCollection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(soundBoardProgressProvider);
    final phonograms = ref.watch(phonogramsProvider);

    return GestureDetector(
      onTap: onOpenCollection,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1832),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFFFFD700).withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🎵',
                    style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Your Sound Collection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  '${progress.totalExplored} / ${progress.totalAvailable}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Mini collection grid (74 dots)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: phonograms.map((p) {
                final explored = progress.isExplored(p.id);
                return Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: explored
                        ? p.color
                        : Colors.white.withValues(alpha: 0.08),
                    border: explored
                        ? null
                        : Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 0.5),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.explorationPercent,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    progress.totalExplored == 0
                        ? 'Start tapping to collect sounds!'
                        : progress.totalExplored < 74
                            ? '${74 - progress.totalExplored} sounds waiting to be discovered'
                            : 'All 74 sounds collected! 🎉',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Open',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFD700))),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          size: 14, color: Color(0xFFFFD700)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
