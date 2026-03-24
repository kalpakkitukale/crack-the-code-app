import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/services/tts_service.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/presentation/providers/spelling/word_list_provider.dart';

class WordMatchScreen extends ConsumerStatefulWidget {
  final String wordListId;

  const WordMatchScreen({super.key, required this.wordListId});

  @override
  ConsumerState<WordMatchScreen> createState() =>
      _WordMatchScreenState();
}

class _WordMatchScreenState extends ConsumerState<WordMatchScreen> {
  List<Word> _words = [];
  List<String> _shuffledDefinitions = [];
  int? _selectedWordIndex;
  int? _selectedDefIndex;
  final Map<int, int> _matches = {}; // word index -> def index
  final Set<int> _correctMatches = {};
  bool _isComplete = false;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(wordsProvider.notifier)
          .loadWords(widget.wordListId);
    });
  }

  void _setupGame(List<Word> words) {
    // Take up to 6 words for a manageable game
    final gameWords = words.take(6).toList();
    final defs = gameWords.map((w) => w.definition).toList()
      ..shuffle(Random());

    setState(() {
      _words = gameWords;
      _shuffledDefinitions = defs;
      _matches.clear();
      _correctMatches.clear();
      _selectedWordIndex = null;
      _selectedDefIndex = null;
      _isComplete = false;
      _attempts = 0;
    });
  }

  void _selectWord(int index) {
    if (_correctMatches.contains(index)) return;
    setState(() {
      _selectedWordIndex = index;
      if (_selectedDefIndex != null) {
        _checkMatch();
      }
    });
  }

  void _selectDefinition(int index) {
    if (_matches.containsValue(index)) return;
    setState(() {
      _selectedDefIndex = index;
      if (_selectedWordIndex != null) {
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    if (_selectedWordIndex == null || _selectedDefIndex == null) {
      return;
    }

    _attempts++;
    final word = _words[_selectedWordIndex!];
    final def = _shuffledDefinitions[_selectedDefIndex!];

    if (word.definition == def) {
      // Correct match
      setState(() {
        _correctMatches.add(_selectedWordIndex!);
        _matches[_selectedWordIndex!] = _selectedDefIndex!;
        _selectedWordIndex = null;
        _selectedDefIndex = null;

        if (_correctMatches.length == _words.length) {
          _isComplete = true;
        }
      });
      ttsService.speak(word.word);
    } else {
      // Wrong match - flash red then reset
      final wordIdx = _selectedWordIndex!;
      final defIdx = _selectedDefIndex!;
      setState(() {
        _matches[wordIdx] = defIdx;
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _matches.remove(wordIdx);
            _selectedWordIndex = null;
            _selectedDefIndex = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wordsState = ref.watch(wordsProvider);

    if (wordsState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Word Match')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (wordsState.words.isNotEmpty && _words.isEmpty) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _setupGame(wordsState.words));
    }

    if (_isComplete) {
      return _buildCompleteView(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Match'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                  '${_correctMatches.length}/${_words.length}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Words column
            Expanded(
              child: ListView.separated(
                itemCount: _words.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final isMatched =
                      _correctMatches.contains(index);
                  final isSelected =
                      _selectedWordIndex == index;
                  final isWrongMatch =
                      _matches.containsKey(index) && !isMatched;

                  return GestureDetector(
                    onTap: isMatched
                        ? null
                        : () => _selectWord(index),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isMatched
                            ? Colors.green.withOpacity(0.15)
                            : isWrongMatch
                                ? Colors.red
                                    .withOpacity(0.15)
                                : isSelected
                                    ? theme
                                        .colorScheme.primary
                                        .withOpacity(0.15)
                                    : theme.colorScheme
                                        .surface,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: isMatched
                              ? Colors.green
                              : isWrongMatch
                                  ? Colors.red
                                  : isSelected
                                      ? theme.colorScheme
                                          .primary
                                      : theme
                                          .colorScheme.outline
                                          .withOpacity(0.3),
                          width:
                              isSelected || isMatched ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isMatched)
                            const Icon(Icons.check_circle,
                                color: Colors.green,
                                size: 20),
                          if (isMatched)
                            const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _words[index].word,
                              style: theme
                                  .textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                decoration: isMatched
                                    ? TextDecoration.none
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Definitions column
            Expanded(
              child: ListView.separated(
                itemCount: _shuffledDefinitions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final isMatched =
                      _matches.containsValue(index) &&
                          _correctMatches.contains(_matches
                              .entries
                              .firstWhere(
                                  (e) => e.value == index,
                                  orElse: () =>
                                      const MapEntry(-1, -1))
                              .key);
                  final isSelected =
                      _selectedDefIndex == index;
                  final isWrongMatch =
                      _matches.containsValue(index) &&
                          !isMatched;

                  return GestureDetector(
                    onTap: isMatched
                        ? null
                        : () => _selectDefinition(index),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMatched
                            ? Colors.green.withOpacity(0.15)
                            : isWrongMatch
                                ? Colors.red
                                    .withOpacity(0.15)
                                : isSelected
                                    ? theme.colorScheme
                                        .secondary
                                        .withOpacity(0.15)
                                    : theme.colorScheme
                                        .surface,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: isMatched
                              ? Colors.green
                              : isWrongMatch
                                  ? Colors.red
                                  : isSelected
                                      ? theme.colorScheme
                                          .secondary
                                      : theme
                                          .colorScheme.outline
                                          .withOpacity(0.3),
                          width:
                              isSelected || isMatched ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        _shuffledDefinitions[index],
                        style: theme.textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteView(BuildContext context) {
    final theme = Theme.of(context);
    final accuracy = _words.length / _attempts;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events,
                  size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              Text('All Matched!',
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                  '${_words.length} pairs in $_attempts attempts',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                  'Efficiency: ${(accuracy * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
