import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/character.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/presentation/screens/collection/character_detail_screen.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(allCharactersProvider);
    final levels = ref.watch(allLevelsProvider);
    final profile = ref.watch(playerProfileProvider);
    final lang = profile.language.name;

    // Group by level
    final byLevel = <int, List<Character>>{};
    for (final c in characters) {
      byLevel.putIfAbsent(c.level, () => []).add(c);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text('YOUR COLLECTION  ${characters.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: levels.map((level) {
          final chars = byLevel[level.number] ?? [];
          if (chars.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1832),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: level.colorValue.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: level.colorValue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: Text('${level.number}',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: level.colorValue)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Level ${level.number}: ${level.nameForLang(lang)}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: level.colorValue)),
                    const Spacer(),
                    Text('${chars.length}',
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chars.map((c) {
                    return GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CharacterDetailScreen(character: c))),
                      child: Container(
                        width: 70,
                        height: 80,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: level.colorValue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: level.colorValue.withValues(alpha: 0.15)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(c.name,
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: level.colorValue),
                                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(c.phonogram.toUpperCase(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                            Text(c.sound,
                                style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
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
