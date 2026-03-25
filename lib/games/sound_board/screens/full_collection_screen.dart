import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/category.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/phonogram_collection_tile.dart';
import 'package:crack_the_code/games/sound_board/screens/phonogram_detail_screen.dart';

class FullCollectionScreen extends ConsumerWidget {
  const FullCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phonograms = ref.watch(phonogramsProvider);
    final progress = ref.watch(soundBoardProgressProvider);
    final profile = ref.watch(playerProfileProvider);
    final columns = profile.gridColumns;

    // Group by category
    final grouped = <PhonogramCategory, List<Phonogram>>{};
    for (final p in phonograms) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text(
            'YOUR COLLECTION  ${progress.totalExplored}/${progress.totalAvailable}'),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: PhonogramCategory.values.map((category) {
          final items = grouped[category] ?? [];
          if (items.isEmpty) return const SizedBox.shrink();

          final explored =
              items.where((p) => progress.isExplored(p.id)).length;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1832),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: category.color.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: category.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: category.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$explored/${items.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tiles grid
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((p) {
                    final discovered = progress.isExplored(p.id);
                    final mastery =
                        ref.watch(phonogramMasteryLevelProvider(p.id));
                    final tileSize =
                        (MediaQuery.of(context).size.width - 48) / columns -
                            8;

                    return PhonogramCollectionTile(
                      phonogram: p,
                      isDiscovered: discovered,
                      masteryLevel: mastery,
                      size: tileSize.clamp(40, 90),
                      onTap: () {
                        // Record progress + play sound
                        ref
                            .read(soundBoardProgressProvider.notifier)
                            .recordTap(p.id);
                        if (p.sounds.isNotEmpty) {
                          final sound = p.sounds.first;
                          final ex = sound.exampleWords.isNotEmpty
                              ? sound.exampleWords.first.word
                              : null;
                          ref.read(audioRepositoryProvider).playPhonogram(
                                sound.soundId,
                                notation: sound.notation,
                                exampleWord: ex,
                              );
                        }
                        // Open detail screen
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              PhonogramDetailScreen(phonogramId: p.id),
                        ));
                      },
                      onLongPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              PhonogramDetailScreen(phonogramId: p.id),
                        ));
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
