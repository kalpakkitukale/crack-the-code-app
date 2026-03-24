import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/services/tts_service.dart';
import 'package:crack_the_code/presentation/providers/spelling/word_of_the_day_provider.dart';
import 'package:crack_the_code/presentation/providers/spelling/spelling_statistics_provider.dart';
import 'package:crack_the_code/presentation/providers/spelling/word_list_provider.dart';

class SpellingHomeScreen extends ConsumerStatefulWidget {
  const SpellingHomeScreen({super.key});

  @override
  ConsumerState<SpellingHomeScreen> createState() => _SpellingHomeScreenState();
}

class _SpellingHomeScreenState extends ConsumerState<SpellingHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wordOfTheDayProvider.notifier).load();
      ref.read(spellingStatsProvider.notifier).load();
      ref.read(wordListProvider.notifier).loadWordLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;
    final wotdState = ref.watch(wordOfTheDayProvider);
    final statsState = ref.watch(spellingStatsProvider);
    final wordListState = ref.watch(wordListProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(wordOfTheDayProvider.notifier).load();
            ref.read(spellingStatsProvider.notifier).load();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 80,
                floating: true,
                title: Text(
                  settings.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  if (statsState.stats != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_fire_department,
                                  color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${statsState.stats!.currentStreak}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Word of the Day Card
              if (settings.showWordOfTheDay)
                SliverToBoxAdapter(
                  child: _WordOfTheDayCard(
                    word: wotdState.word,
                    isLoading: wotdState.isLoading,
                  ),
                ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Quick Practice',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _QuickActionCard(
                        icon: Icons.mic,
                        title: 'Dictation',
                        subtitle: 'Hear & spell',
                        color: Colors.blue,
                        onTap: () {
                          // Navigate to word explorer for dictation
                          Navigator.of(context).pushNamed('/word-explorer');
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.shuffle,
                        title: 'Unscramble',
                        subtitle: 'Fix the word',
                        color: Colors.green,
                        onTap: () {
                          Navigator.of(context).pushNamed('/word-explorer');
                        },
                      ),
                      if (settings.showSpellingBee)
                        _QuickActionCard(
                          icon: Icons.emoji_events,
                          title: 'Spelling Bee',
                          subtitle: 'Challenge!',
                          color: Colors.amber,
                          onTap: () {
                            Navigator.of(context).pushNamed('/spelling-bee');
                          },
                        ),
                      _QuickActionCard(
                        icon: Icons.style,
                        title: 'Flashcards',
                        subtitle: 'Review words',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.of(context).pushNamed('/word-explorer');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Summary
              if (statsState.stats != null)
                SliverToBoxAdapter(
                  child: _StatsSummaryCard(stats: statsState.stats!),
                ),

              // Word Lists Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text('Word Lists',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),

              if (wordListState.isLoading)
                const SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  )),
                )
              else if (wordListState.wordLists.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.book_outlined,
                              size: 64, color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text('No word lists yet',
                              style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 8),
                          Text('Select a grade to get started',
                              style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final wordList = wordListState.wordLists[index];
                      return _WordListTile(
                        wordList: wordList,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/spelling-practice',
                            arguments: {'wordListId': wordList.id},
                          );
                        },
                      );
                    },
                    childCount: wordListState.wordLists.length,
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordOfTheDayCard extends StatelessWidget {
  final dynamic word;
  final bool isLoading;

  const _WordOfTheDayCard({this.word, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Container(
            height: 180,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (word == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                SegmentConfig.settings.cardBorderRadius),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome,
                      color: Colors.amber.shade200, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Word of the Day',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => ttsService.speak(word.word),
                    icon: Icon(Icons.volume_up, color: Colors.white.withOpacity(0.9)),
                    iconSize: 28,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                word.phonetic,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                word.definition,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      word.partOfSpeech,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      word.difficulty,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const Spacer(),
              Text(title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsSummaryCard extends StatelessWidget {
  final dynamic stats;

  const _StatsSummaryCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.check_circle,
                value: '${stats.totalWordsMastered}',
                label: 'Mastered',
                color: Colors.green,
              ),
              _StatItem(
                icon: Icons.school,
                value: '${stats.totalWordsLearned}',
                label: 'Learning',
                color: Colors.blue,
              ),
              _StatItem(
                icon: Icons.percent,
                value:
                    '${(stats.overallAccuracy * 100).toStringAsFixed(0)}%',
                label: 'Accuracy',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _WordListTile extends StatelessWidget {
  final dynamic wordList;
  final VoidCallback onTap;

  const _WordListTile({required this.wordList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${wordList.wordCount}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(wordList.name),
          subtitle: Text(
            '${wordList.difficulty} - ${wordList.estimatedMinutes} min',
            style: theme.textTheme.bodySmall,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
