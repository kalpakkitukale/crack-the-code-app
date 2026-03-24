import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/presentation/providers/spelling/spelling_practice_provider.dart';

class FillInBlankScreen extends ConsumerStatefulWidget {
  final String wordListId;

  const FillInBlankScreen({super.key, required this.wordListId});

  @override
  ConsumerState<FillInBlankScreen> createState() => _FillInBlankScreenState();
}

class _FillInBlankScreenState extends ConsumerState<FillInBlankScreen> {
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, FocusNode> _focusNodes = {};
  List<int> _hiddenIndices = [];
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(spellingPracticeProvider.notifier).startSession(
            wordListId: widget.wordListId,
            activityType: 'fill_blank',
          );
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  void _setupForWord(Word word) {
    // Cleanup old controllers
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    _controllers.clear();
    _focusNodes.clear();

    // Hide ~40% of letters (at least 1, spread out)
    final random = Random();
    final letterCount = word.word.length;
    final hideCount =
        (letterCount * 0.4).ceil().clamp(1, letterCount - 1);
    final allIndices = List.generate(letterCount, (i) => i)
      ..shuffle(random);
    _hiddenIndices = allIndices.take(hideCount).toList()..sort();

    for (final i in _hiddenIndices) {
      _controllers[i] = TextEditingController();
      _focusNodes[i] = FocusNode();
    }

    setState(() {
      _showResult = false;
      _isCorrect = false;
    });

    // Focus first blank
    if (_focusNodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[_hiddenIndices.first]?.requestFocus();
      });
    }
  }

  void _checkAnswer(Word word) {
    // Build the full word from visible + entered letters
    final letters = word.word.split('');
    String userAnswer = '';
    for (int i = 0; i < letters.length; i++) {
      if (_hiddenIndices.contains(i)) {
        userAnswer += _controllers[i]?.text ?? '';
      } else {
        userAnswer += letters[i];
      }
    }

    final correct =
        userAnswer.toLowerCase() == word.word.toLowerCase();
    setState(() {
      _showResult = true;
      _isCorrect = correct;
    });

    ref
        .read(spellingPracticeProvider.notifier)
        .submitAnswer(userAnswer);
  }

  void _nextWord() {
    ref.read(spellingPracticeProvider.notifier).clearLastResult();
    final state = ref.read(spellingPracticeProvider);
    if (state.currentWord != null) {
      _setupForWord(state.currentWord!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(spellingPracticeProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fill in the Blanks')),
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
        appBar: AppBar(title: const Text('Fill in the Blanks')),
        body: Center(
            child: Text(state.error ?? 'No words available')),
      );
    }

    // Setup letters on word change
    if (_hiddenIndices.isEmpty || _controllers.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _setupForWord(currentWord));
    }

    final letters = currentWord.word.split('');

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Word ${session.currentIndex + 1} of ${session.totalWords}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child:
              LinearProgressIndicator(value: session.progressPercent),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Hint
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () =>
                          ttsService.speak(currentWord.word),
                      icon: Icon(Icons.volume_up,
                          size: 36,
                          color: theme.colorScheme.primary),
                    ),
                    Text(currentWord.definition,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Letter tiles
            Wrap(
              spacing: 4,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(letters.length, (index) {
                final isHidden = _hiddenIndices.contains(index);

                if (!isHidden) {
                  // Visible letter
                  return Container(
                    width: 44,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      letters[index],
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Hidden letter - input field
                return SizedBox(
                  width: 44,
                  height: 52,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    enabled: !_showResult,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _showResult
                          ? (_controllers[index]
                                      ?.text
                                      .toLowerCase() ==
                                  letters[index].toLowerCase()
                              ? Colors.green
                              : Colors.red)
                          : null,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _showResult
                              ? (_controllers[index]
                                          ?.text
                                          .toLowerCase() ==
                                      letters[index].toLowerCase()
                                  ? Colors.green
                                  : Colors.red)
                              : theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // Move to next blank
                        final currentHiddenIdx =
                            _hiddenIndices.indexOf(index);
                        if (currentHiddenIdx <
                            _hiddenIndices.length - 1) {
                          _focusNodes[_hiddenIndices[
                                  currentHiddenIdx + 1]]
                              ?.requestFocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),

            // Show correct answer on wrong
            if (_showResult && !_isCorrect) ...[
              const SizedBox(height: 16),
              Text(
                'Correct: ${currentWord.word}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.green,
                ),
              ),
            ],

            const Spacer(),

            // Action buttons
            if (!_showResult)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(
                                spellingPracticeProvider.notifier)
                            .skipWord();
                        final s =
                            ref.read(spellingPracticeProvider);
                        if (s.currentWord != null) {
                          _setupForWord(s.currentWord!);
                        }
                      },
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () =>
                          _checkAnswer(currentWord),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16),
                      ),
                      child: const Text('Check'),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16)),
                  child: Text(
                    session.currentIndex + 1 >=
                            session.totalWords
                        ? 'See Results'
                        : 'Next Word',
                  ),
                ),
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
                  accuracy >= 0.8
                      ? Icons.emoji_events
                      : Icons.thumb_up,
                  size: 80,
                  color: accuracy >= 0.8
                      ? Colors.amber
                      : theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                  accuracy >= 0.8 ? 'Amazing!' : 'Good effort!',
                  style: theme.textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                  '${session.correctCount} out of ${session.totalWords} correct!',
                  style: theme.textTheme.titleLarge),
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
