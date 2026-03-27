import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/trial_provider.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';

class ProgressDashboard extends ConsumerWidget {
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final strings = AppStrings(profile.language);
    final trial = ref.watch(trialProgressProvider);
    final levels = ref.watch(allLevelsProvider);
    final characters = ref.watch(allCharactersProvider);
    final phonograms = ref.watch(phonogramsProvider);
    final rules = ref.watch(rulesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(strings.myProgress,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),

            // Level Journey
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1832),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('YOUR JOURNEY',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: Colors.white38, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      ...levels.map((level) {
                        final isCurrent = level.number == 1; // TODO: track actual level
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? level.colorValue.withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: isCurrent
                                      ? Text('${level.number}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: level.colorValue))
                                      : Icon(Icons.lock, size: 14, color: Colors.white.withValues(alpha: 0.15)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${level.nameForLang(profile.language.name)} ${level.starDisplay}',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                            color: isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.3))),
                                    if (isCurrent) ...[
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: 0.2,
                                          minHeight: 4,
                                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                                          valueColor: AlwaysStoppedAnimation(level.colorValue),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // Mastery Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1832),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MASTERY',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: Colors.white38, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      _StatRow(label: 'Sounds', current: trial.totalMastered, total: 45,
                          color: const Color(0xFFFFD700)),
                      _StatRow(label: 'Phonograms', current: 0, total: phonograms.length,
                          color: const Color(0xFF4CAF50)),
                      _StatRow(label: 'Characters', current: 0, total: characters.length,
                          color: const Color(0xFF2196F3)),
                      _StatRow(label: 'Rules', current: 0, total: rules.length,
                          color: const Color(0xFFFF9800)),
                    ],
                  ),
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1832),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCircle(icon: '🔥', value: '0', label: 'Streak'),
                          _StatCircle(icon: '⭐', value: '${profile.xp}', label: 'XP'),
                          _StatCircle(icon: '🪙', value: '${profile.coins}', label: 'Coins'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Achievements
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1832),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ACHIEVEMENTS',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: Colors.white38, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      _AchievementRow(icon: '🏅', name: 'Sound Explorer',
                          desc: 'Master all 45 sounds',
                          earned: trial.trialCompleted),
                      _AchievementRow(icon: '🔒', name: 'Card Collector',
                          desc: 'Collect 50 characters', earned: false),
                      _AchievementRow(icon: '🔒', name: 'Rule Scholar',
                          desc: 'Master all 38 core rules', earned: false),
                      _AchievementRow(icon: '🔒', name: 'Legend',
                          desc: 'Complete all 5 levels', earned: false),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int current;
  final int total;
  final Color color;

  const _StatRow({required this.label, required this.current, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.white70))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: total > 0 ? current / total : 0,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$current/$total',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _StatCircle extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatCircle({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
      ],
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final String icon;
  final String name;
  final String desc;
  final bool earned;

  const _AchievementRow({required this.icon, required this.name, required this.desc, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: earned ? Colors.white : Colors.white.withValues(alpha: 0.3))),
                Text(desc, style: TextStyle(fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.3))),
              ],
            ),
          ),
          if (earned)
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
        ],
      ),
    );
  }
}
