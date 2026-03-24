import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/domain/services/spelling_checker_service.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  final _checker = SpellingCheckerService();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<Word> _challengeWords = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _totalPoints = 0;
  bool _isLoading = true;
  bool _showResult = false;
  SpellingCheckResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _loadChallenge();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadChallenge() async {
    // Use date-based seed for consistent daily challenge
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);

    // Load all word lists and pick 5 random words
    final result = await injectionContainer.getWordListsUseCase();
    result.fold(
      (error) => setState(() {
        _isLoading = false;
      }),
      (wordLists) async {
        final allWords = <Word>[];
        for (final wl in wordLists) {
          final wordsResult =
              await injectionContainer.getWordsForListUseCase(wl.id);
          wordsResult.fold((_) {}, (words) => allWords.addAll(words));
        }

        if (allWords.isNotEmpty) {
          allWords.shuffle(random);
          setState(() {
            _challengeWords = allWords.take(5).toList();
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      },
    );
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    final word = _challengeWords[_currentIndex];
    final result = _checker.check(_controller.text.trim(), word.word);
    final points = result.isCorrect
        ? (word.difficulty == 'hard'
            ? 30
            : word.difficulty == 'medium'
                ? 20
                : 10)
        : 0;

    setState(() {
      _showResult = true;
      _lastResult = result;
      if (result.isCorrect) _correctCount++;
      _totalPoints += points;
    });
  }

  void _next() {
    _controller.clear();
    setState(() {
      _currentIndex++;
      _showResult = false;
      _lastResult = null;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Challenge')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_challengeWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Challenge')),
        body: const Center(
            child: Text('No words available for today\'s challenge')),
      );
    }

    if (_currentIndex >= _challengeWords.length) {
      final isPerfect = _correctCount == _challengeWords.length;
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isPerfect ? Icons.emoji_events : Icons.star,
                    size: 80,
                    color:
                        isPerfect ? Colors.amber : theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  isPerfect ? 'PERFECT!' : 'Challenge Complete!',
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('$_totalPoints points earned!',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(color: Colors.amber)),
                const SizedBox(height: 8),
                Text('$_correctCount of ${_challengeWords.length} correct',
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.home),
                  label: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final word = _challengeWords[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.amber),
            const SizedBox(width: 8),
            Text('Challenge ${_currentIndex + 1}/5'),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '$_totalPoints pts',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () => ttsService.speak(word.word),
                      icon: Icon(Icons.volume_up,
                          size: 48, color: theme.colorScheme.primary),
                    ),
                    Text(word.definition,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(label: Text(word.partOfSpeech)),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(word.difficulty == 'hard'
                              ? '30 pts'
                              : word.difficulty == 'medium'
                                  ? '20 pts'
                                  : '10 pts'),
                          backgroundColor:
                              Colors.amber.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !_showResult,
              autofocus: true,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(letterSpacing: 4, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Spell it...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            if (_showResult && _lastResult != null)
              Card(
                color: _lastResult!.isCorrect
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        _lastResult!.isCorrect
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _lastResult!.isCorrect
                            ? Colors.green
                            : Colors.red,
                        size: 40,
                      ),
                      if (!_lastResult!.isCorrect)
                        Text(
                          'Correct: ${word.word}',
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, letterSpacing: 3),
                        ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_showResult ? _submit : _next,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(!_showResult
                    ? 'Check'
                    : (_currentIndex + 1 >= _challengeWords.length
                        ? 'See Results'
                        : 'Next')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
