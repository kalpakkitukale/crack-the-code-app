import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/player_profile.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final settings = ref.watch(gameSettingsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1832),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Age Level
          const Text('Who\'s playing?',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: AgeLevel.values.map((level) {
              final selected = profile.ageLevel == level;
              final label = switch (level) {
                AgeLevel.tiny => 'Tiny (2-4)',
                AgeLevel.starter => 'Starter (5-7)',
                AgeLevel.explorer => 'Explorer (8-10)',
                AgeLevel.master => 'Master (11-14)',
                AgeLevel.adult => 'Adult',
              };
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) {
                  ref
                      .read(playerProfileProvider.notifier)
                      .updateAgeLevel(level);
                },
                selectedColor:
                    const Color(0xFFFFD700).withValues(alpha: 0.25),
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: selected ? const Color(0xFFFFD700) : Colors.white70,
                ),
                side: BorderSide(
                  color: selected
                      ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Sound Volume
          Row(
            children: [
              const Text('Sound Volume',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
              const Spacer(),
              Text('${(settings.soundVolume * 100).toInt()}%',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFFFFD700))),
            ],
          ),
          Slider(
            value: settings.soundVolume,
            onChanged: (v) {
              ref.read(gameSettingsProvider.notifier).setSoundVolume(v);
            },
            activeColor: const Color(0xFFFFD700),
            inactiveColor: Colors.white.withValues(alpha: 0.1),
          ),

          // Language toggles
          SwitchListTile(
            title: const Text('Hindi pronunciation guide',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            value: settings.showHindiPronunciation,
            onChanged: (v) {
              ref.read(gameSettingsProvider.notifier).toggleHindi(v);
            },
            activeColor: const Color(0xFFFFD700),
          ),
          SwitchListTile(
            title: const Text('Marathi pronunciation guide',
                style: TextStyle(fontSize: 14, color: Colors.white)),
            value: settings.showMarathiPronunciation,
            onChanged: (v) {
              ref.read(gameSettingsProvider.notifier).toggleMarathi(v);
            },
            activeColor: const Color(0xFFFFD700),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
