import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/presentation/providers/spelling/spelling_statistics_provider.dart';

class SpellingProgressScreen extends ConsumerStatefulWidget {
  const SpellingProgressScreen({super.key});

  @override
  ConsumerState<SpellingProgressScreen> createState() =>
      _SpellingProgressScreenState();
}

class _SpellingProgressScreenState
    extends ConsumerState<SpellingProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(spellingStatsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(spellingStatsProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Progress')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final stats = state.stats;
    if (stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Progress')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up,
                  size: 64, color: theme.colorScheme.outline),
              const SizedBox(height: 16),
              Text('Start practicing to see your progress!',
                  style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overview card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.school,
                        size: 48,
                        color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      '${stats.totalWordsMastered}',
                      style:
                          theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text('Words Mastered',
                        style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _ProgressCard(
                    icon: Icons.book,
                    value: '${stats.totalWordsLearned}',
                    label: 'Words Learned',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressCard(
                    icon: Icons.percent,
                    value:
                        '${(stats.overallAccuracy * 100).toStringAsFixed(0)}%',
                    label: 'Accuracy',
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ProgressCard(
                    icon: Icons.local_fire_department,
                    value: '${stats.currentStreak}',
                    label: 'Day Streak',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressCard(
                    icon: Icons.edit,
                    value: '${stats.totalAttempts}',
                    label: 'Total Attempts',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ProgressCard(
                    icon: Icons.emoji_events,
                    value: '${stats.spellingBeesCompleted}',
                    label: 'Bees Completed',
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressCard(
                    icon: Icons.timer,
                    value: '${stats.totalPracticeMinutes}',
                    label: 'Minutes Practiced',
                    color: Colors.teal,
                  ),
                ),
              ],
            ),

            // Weak patterns section
            if (stats.weakPatterns.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Areas to Improve',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...stats.weakPatterns.entries.map((e) => ListTile(
                    leading: const Icon(Icons.warning_amber,
                        color: Colors.orange),
                    title: Text(e.key.replaceAll('_', ' ')),
                    trailing: Text('${e.value} errors'),
                  )),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ProgressCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
