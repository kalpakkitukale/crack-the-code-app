import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/presentation/providers/spelling/spelling_practice_provider.dart';

class UnscrambleScreen extends ConsumerStatefulWidget {
  final String wordListId;

  const UnscrambleScreen({super.key, required this.wordListId});

  @override
  ConsumerState<UnscrambleScreen> createState() => _UnscrambleScreenState();
}

class _UnscrambleScreenState extends ConsumerState<UnscrambleScreen> {
  List<String> _shuffledLetters = [];
  List<String> _selectedLetters = [];
  List<int> _selectedIndices = [];
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(spellingPracticeProvider.notifier).startSession(
            wordListId: widget.wordListId,
            activityType: 'unscramble',
          );
    });
  }

  void _shuffleWord(String word) {
    final letters = word.split('');
    final random = Random();
    // Ensure the shuffle is actually different from the original
    do {
      letters.shuffle(random);
    } while (letters.join() == word && word.length > 1);
    setState(() {
      _shuffledLetters = letters;
      _selectedLetters = [];
      _selectedIndices = [];
      _showResult = false;
    });
  }

  void _selectLetter(int index) {
    if (_selectedIndices.contains(index) || _showResult) return;
    setState(() {
      _selectedIndices.add(index);
      _selectedLetters.add(_shuffledLetters[index]);
    });

    // Auto-check when all letters selected
    final currentWord = ref.read(spellingPracticeProvider).currentWord;
    if (currentWord != null &&
        _selectedLetters.length == currentWord.word.length) {
      _checkAnswer(currentWord);
    }
  }

  void _removeLast() {
    if (_selectedLetters.isEmpty || _showResult) return;
    setState(() {
      _selectedLetters.removeLast();
      _selectedIndices.removeLast();
    });
  }

  void _checkAnswer(Word currentWord) {
    final answer = _selectedLetters.join();
    final correct = answer.toLowerCase() == currentWord.word.toLowerCase();
    setState(() {
      _showResult = true;
      _isCorrect = correct;
    });
    ref.read(spellingPracticeProvider.notifier).submitAnswer(answer);
  }

  void _nextWord() {
    ref.read(spellingPracticeProvider.notifier).clearLastResult();
    final state = ref.read(spellingPracticeProvider);
    if (state.currentWord != null) {
      _shuffleWord(state.currentWord!.word);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(spellingPracticeProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Unscramble')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isSessionComplete) {
      return _buildCompleteView(context, state);
    }

    final currentWord = state.currentWord;
    final session = state.session;
    if (currentWord == null || session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Unscramble')),
        body: Center(child: Text(state.error ?? 'No words available')),
      );
    }

    // Initialize shuffle on first load or word change
    if (_shuffledLetters.isEmpty ||
        _shuffledLetters.length != currentWord.word.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _shuffleWord(currentWord.word);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Word ${session.currentIndex + 1} of ${session.totalWords}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: session.progressPercent),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Hint section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () =>
                              ttsService.speak(currentWord.definition),
                          icon: Icon(Icons.volume_up,
                              color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentWord.definition,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    if (currentWord.partOfSpeech.isNotEmpty)
                      Chip(label: Text(currentWord.partOfSpeech)),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Selected letters (answer area)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _showResult
                        ? (_isCorrect ? Colors.green : Colors.red)
                        : theme.colorScheme.primary,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._selectedLetters.map((letter) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 40,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _showResult
                              ? (_isCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1))
                              : theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          letter,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  // Empty slots
                  ...List.generate(
                    currentWord.word.length - _selectedLetters.length,
                    (_) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 40,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('_',
                          style: theme.textTheme.headlineSmall),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Undo button
            if (!_showResult && _selectedLetters.isNotEmpty)
              TextButton.icon(
                onPressed: _removeLast,
                icon: const Icon(Icons.backspace_outlined, size: 20),
                label: const Text('Undo'),
              ),

            const SizedBox(height: 24),

            // Result feedback
            if (_showResult)
              Card(
                color: _isCorrect
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect ? Colors.green : Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isCorrect
                            ? 'Correct!'
                            : 'The word is: ${currentWord.word}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: _isCorrect ? 0 : 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Scrambled letters (tap to select)
            if (!_showResult)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children:
                    List.generate(_shuffledLetters.length, (index) {
                  final isSelected = _selectedIndices.contains(index);
                  return GestureDetector(
                    onTap:
                        isSelected ? null : () => _selectLetter(index),
                    child: AnimatedOpacity(
                      opacity: isSelected ? 0.3 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme
                                  .colorScheme.surfaceContainerHighest
                              : theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? null
                              : [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Text(
                          _shuffledLetters[index],
                          style:
                              theme.textTheme.headlineSmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.outline
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

            const Spacer(),

            // Next button
            if (_showResult)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    session.currentIndex + 1 >= session.totalWords
                        ? 'See Results'
                        : 'Next Word',
                  ),
                ),
              ),

            // Skip button
            if (!_showResult)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(spellingPracticeProvider.notifier)
                            .skipWord();
                        final newState =
                            ref.read(spellingPracticeProvider);
                        if (newState.currentWord != null) {
                          _shuffleWord(newState.currentWord!.word);
                        }
                      },
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _shuffleWord(currentWord.word),
                      child: const Text('Reshuffle'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteView(
      BuildContext context, SpellingPracticeState state) {
    final theme = Theme.of(context);
    final session = state.session!;
    final accuracy = session.accuracy;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                accuracy >= 0.8 ? Icons.emoji_events : Icons.thumb_up,
                size: 80,
                color: accuracy >= 0.8
                    ? Colors.amber
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                accuracy >= 0.8 ? 'Amazing!' : 'Good effort!',
                style: theme.textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '${session.correctCount} out of ${session.totalWords} correct!',
                style: theme.textTheme.titleLarge,
              ),
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
