import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/services/tts_service.dart';
import 'package:crack_the_code/presentation/providers/spelling/spelling_practice_provider.dart';

class SpellingPracticeScreen extends ConsumerStatefulWidget {
  final String wordListId;
  final String activityType;

  const SpellingPracticeScreen({
    super.key,
    required this.wordListId,
    this.activityType = 'dictation',
  });

  @override
  ConsumerState<SpellingPracticeScreen> createState() =>
      _SpellingPracticeScreenState();
}

class _SpellingPracticeScreenState
    extends ConsumerState<SpellingPracticeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(spellingPracticeProvider.notifier).startSession(
            wordListId: widget.wordListId,
            activityType: widget.activityType,
          );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_controller.text.trim().isEmpty) return;
    ref
        .read(spellingPracticeProvider.notifier)
        .submitAnswer(_controller.text.trim());
    setState(() => _showResult = true);
  }

  void _nextWord() {
    _controller.clear();
    setState(() => _showResult = false);
    ref.read(spellingPracticeProvider.notifier).clearLastResult();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(spellingPracticeProvider);
    final settings = SegmentConfig.settings;

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Spelling Practice')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isSessionComplete) {
      return _SessionCompleteView(session: state.session!);
    }

    final currentWord = state.currentWord;
    final session = state.session;

    if (currentWord == null || session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Spelling Practice')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(state.error ?? 'No words available',
                  style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Word ${session.currentIndex + 1} of ${session.totalWords}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: session.progressPercent,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),

            // Word info card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Listen button (TTS)
                    IconButton(
                      onPressed: () {
                        ttsService.speak(currentWord.word);
                      },
                      icon: Icon(Icons.volume_up,
                          size: 48, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text('Tap to hear the word',
                        style: theme.textTheme.bodySmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentWord.exampleSentences.isNotEmpty)
                          TextButton.icon(
                            onPressed: () {
                              ttsService.speak(currentWord.exampleSentences.first);
                            },
                            icon: const Icon(Icons.record_voice_over, size: 20),
                            label: const Text('Hear in a sentence'),
                          ),
                        TextButton.icon(
                          onPressed: () async {
                            await ttsService.setSpeechRate(0.25);
                            await ttsService.speak(currentWord.word);
                            // Reset rate after a delay
                            Future.delayed(const Duration(seconds: 3), () {
                              ttsService.setSpeechRate(0.45);
                            });
                          },
                          icon: const Icon(Icons.slow_motion_video, size: 20),
                          label: const Text('Say it slowly'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Definition hint
                    Text(
                      currentWord.definition,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),

                    if (currentWord.partOfSpeech.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Chip(label: Text(currentWord.partOfSpeech)),
                    ],

                    // Mnemonic hint
                    if (settings.showMnemonics &&
                        currentWord.mnemonicHint != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                currentWord.mnemonicHint!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Spelling input
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !_showResult,
              autofocus: true,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Type the word...',
                hintStyle: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.outline,
                  letterSpacing: 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => _submitAnswer(),
            ),

            const SizedBox(height: 16),

            // Result display
            if (_showResult && state.lastResult != null)
              _ResultCard(
                result: state.lastResult!,
                correctWord: currentWord.word,
              ),

            const Spacer(flex: 2),

            // Action buttons
            if (!_showResult)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(spellingPracticeProvider.notifier)
                            .skipWord();
                        _controller.clear();
                      },
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Check'),
                    ),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: _nextWord,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                    session.currentIndex + 1 >= session.totalWords
                        ? 'See Results'
                        : 'Next Word'),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final dynamic result;
  final String correctWord;

  const _ResultCard({required this.result, required this.correctWord});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = result.isCorrect;

    return Card(
      color: isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              result.feedback,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 8),
              Text(
                'Correct spelling: $correctWord',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SessionCompleteView extends StatelessWidget {
  final dynamic session;

  const _SessionCompleteView({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accuracy = session.accuracy;
    final isGreat = accuracy >= 0.8;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isGreat ? Icons.emoji_events : Icons.thumb_up,
                size: 80,
                color: isGreat ? Colors.amber : theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                isGreat ? 'Amazing!' : 'Good effort!',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You got ${session.correctCount} out of ${session.totalWords} correct!',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(
                    value: '${session.correctCount}',
                    label: 'Correct',
                    color: Colors.green,
                  ),
                  _StatColumn(
                    value: '${session.incorrectCount}',
                    label: 'Incorrect',
                    color: Colors.red,
                  ),
                  _StatColumn(
                    value: '${(accuracy * 100).toStringAsFixed(0)}%',
                    label: 'Accuracy',
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatColumn(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: color)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
