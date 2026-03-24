import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/services/tts_service.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_attempt.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/services/spelling_checker_service.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

class ReviewDueSpellingScreen extends ConsumerStatefulWidget {
  const ReviewDueSpellingScreen({super.key});

  @override
  ConsumerState<ReviewDueSpellingScreen> createState() =>
      _ReviewDueSpellingScreenState();
}

class _ReviewDueSpellingScreenState
    extends ConsumerState<ReviewDueSpellingScreen> {
  final _checker = SpellingCheckerService();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<Word> _dueWords = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _isLoading = true;
  bool _showResult = false;
  SpellingCheckResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _loadDueWords();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadDueWords() async {
    final result =
        await injectionContainer.spellingRepository.getDueForReview();
    setState(() {
      result.fold((_) {}, (words) => _dueWords = words);
      _isLoading = false;
    });
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    final word = _dueWords[_currentIndex];
    final result = _checker.check(_controller.text.trim(), word.word);
    setState(() {
      _showResult = true;
      _lastResult = result;
      if (result.isCorrect) _correctCount++;
    });

    // Update mastery
    injectionContainer.submitSpellingAttemptUseCase(
      _createAttempt(word, result.isCorrect),
    );
  }

  SpellingAttempt _createAttempt(Word word, bool correct) {
    return SpellingAttempt(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      wordId: word.id,
      word: word.word,
      userInput: _controller.text.trim(),
      isCorrect: correct,
      activityType: 'review',
      attemptedAt: DateTime.now(),
    );
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
        appBar: AppBar(title: const Text('Review Due')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_dueWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Due')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  size: 80, color: Colors.green.withValues(alpha: 0.7)),
              const SizedBox(height: 16),
              Text('All caught up!',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('No words due for review right now.',
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.home),
                label: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentIndex >= _dueWords.length) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration, size: 80, color: Colors.amber),
                const SizedBox(height: 24),
                Text('Review Complete!',
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('$_correctCount of ${_dueWords.length} correct',
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

    final word = _dueWords[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${_currentIndex + 1} of ${_dueWords.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _currentIndex / _dueWords.length,
          ),
        ),
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
                    const SizedBox(height: 8),
                    Text(word.definition,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center),
                    if (word.partOfSpeech.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Chip(label: Text(word.partOfSpeech)),
                    ],
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
                hintText: 'Type the word...',
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
                      const SizedBox(height: 8),
                      if (!_lastResult!.isCorrect)
                        Text(
                          'Correct: ${word.word}',
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, letterSpacing: 3),
                        ),
                      Text(_lastResult!.feedback,
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            if (!_showResult)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Check'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(_currentIndex + 1 >= _dueWords.length
                      ? 'See Results'
                      : 'Next Word'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
