import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/domain/entities/spelling/word_mastery.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

class WordJournalScreen extends ConsumerStatefulWidget {
  const WordJournalScreen({super.key});

  @override
  ConsumerState<WordJournalScreen> createState() => _WordJournalScreenState();
}

class _WordJournalScreenState extends ConsumerState<WordJournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Word> _weakWords = [];
  List<Word> _dueWords = [];
  List<WordMastery> _masteredWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final weakResult = await injectionContainer.getWeakWordsUseCase();
    final dueResult =
        await injectionContainer.spellingRepository.getDueForReview();
    final masteriesResult =
        await injectionContainer.spellingRepository.getAllMasteries();

    setState(() {
      weakResult.fold((_) {}, (words) => _weakWords = words);
      dueResult.fold((_) {}, (words) => _dueWords = words);
      masteriesResult.fold((_) {}, (masteries) {
        _masteredWords =
            masteries.where((m) => m.level == MasteryLevel.mastered).toList();
      });
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Word Journal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                icon: const Icon(Icons.warning_amber),
                text: 'Tricky (${_weakWords.length})'),
            Tab(
                icon: const Icon(Icons.schedule),
                text: 'Review (${_dueWords.length})'),
            Tab(
                icon: const Icon(Icons.star),
                text: 'Mastered (${_masteredWords.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildWordList(
                  _weakWords,
                  'No tricky words yet!',
                  'Start practicing to find words you need to work on.',
                  Colors.orange,
                ),
                _buildWordList(
                  _dueWords,
                  'Nothing to review!',
                  'All caught up. Check back later.',
                  Colors.blue,
                ),
                _buildMasteredList(),
              ],
            ),
    );
  }

  Widget _buildWordList(
    List<Word> words,
    String emptyTitle,
    String emptySubtitle,
    Color accentColor,
  ) {
    final theme = Theme.of(context);
    if (words.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64, color: accentColor.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(emptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(emptySubtitle, style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.volume_up, color: theme.colorScheme.primary),
                onPressed: () => ttsService.speak(word.word),
              ),
              title: Text(
                word.word,
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              subtitle: Text(word.definition,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Chip(
                label: Text(word.difficulty),
                visualDensity: VisualDensity.compact,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMasteredList() {
    final theme = Theme.of(context);
    if (_masteredWords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events,
                size: 64, color: Colors.amber.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No words mastered yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Keep practicing! You need 3 correct in a row.',
                style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _masteredWords.length,
      itemBuilder: (context, index) {
        final mastery = _masteredWords[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.star, color: Colors.amber, size: 28),
            title: Text(
              mastery.word,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            subtitle: Text(
                '${mastery.correctAttempts}/${mastery.totalAttempts} correct - ${(mastery.accuracy * 100).toStringAsFixed(0)}% accuracy'),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => ttsService.speak(mastery.word),
            ),
          ),
        );
      },
    );
  }
}
