import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/presentation/providers/spelling/spelling_bee_provider.dart';

class SpellingBeeScreen extends ConsumerStatefulWidget {
  final int gradeLevel;
  final int roundCount;

  const SpellingBeeScreen({
    super.key,
    required this.gradeLevel,
    this.roundCount = 5,
  });

  @override
  ConsumerState<SpellingBeeScreen> createState() => _SpellingBeeScreenState();
}

class _SpellingBeeScreenState extends ConsumerState<SpellingBeeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showResult = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(spellingBeeProvider.notifier).startBee(
            gradeLevel: widget.gradeLevel,
            roundCount: widget.roundCount,
          );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    ref
        .read(spellingBeeProvider.notifier)
        .submitAnswer(_controller.text.trim());
    setState(() => _showResult = true);
    _animController.forward(from: 0);
  }

  void _next() {
    ref.read(spellingBeeProvider.notifier).nextRound();
    _controller.clear();
    setState(() => _showResult = false);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(spellingBeeProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Spelling Bee')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isComplete && state.score != null) {
      return _BeeCompleteView(score: state.score!, rounds: state.rounds);
    }

    final round = state.currentRound;
    if (round == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Spelling Bee')),
        body: Center(child: Text(state.error ?? 'No rounds available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Round ${round.roundNumber} of ${state.totalRounds}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      _difficultyColor(round.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  round.difficulty.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _difficultyColor(round.difficulty),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Trophy & round indicator
            Center(
              child:
                  Icon(Icons.emoji_events, size: 48, color: Colors.amber),
            ),
            const SizedBox(height: 16),

            // Definition card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Definition:',
                        style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(
                      round.definition,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (round.partOfSpeech != null) ...[
                      const SizedBox(height: 8),
                      Chip(label: Text(round.partOfSpeech!)),
                    ],
                  ],
                ),
              ),
            ),

            // Hint buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Wrap(
                spacing: 8,
                children: [
                  if (round.exampleSentence != null &&
                      state.hintsUsedThisRound >= 1)
                    Chip(
                      avatar: const Icon(Icons.format_quote, size: 16),
                      label: Text(round.exampleSentence!,
                          style: theme.textTheme.bodySmall),
                    ),
                  if (state.hintsUsedThisRound < 2 && !_showResult)
                    ActionChip(
                      avatar: const Icon(Icons.help_outline, size: 16),
                      label: Text(
                          'Hint (${2 - state.hintsUsedThisRound} left)'),
                      onPressed: () {
                        ref
                            .read(spellingBeeProvider.notifier)
                            .useHint();
                      },
                    ),
                ],
              ),
            ),

            const Spacer(),

            // Input field
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
                hintText: 'Spell it...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),

            const SizedBox(height: 16),

            // Result
            if (_showResult && state.lastResult != null)
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (_animController.value * 0.2),
                    child: Opacity(
                      opacity: _animController.value,
                      child: Card(
                        color: state.lastResult!.isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                state.lastResult!.isCorrect
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 40,
                                color: state.lastResult!.isCorrect
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.lastResult!.isCorrect
                                    ? 'Correct!'
                                    : 'The word is: ${round.word}',
                                style:
                                    theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing:
                                      state.lastResult!.isCorrect
                                          ? 0
                                          : 3,
                                ),
                              ),
                              if (_showResult) ...[
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: () => ttsService.speak(round.word),
                                  icon: const Icon(Icons.volume_up),
                                  label: const Text('Hear the word'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const Spacer(),

            // Action button
            if (!_showResult)
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: const Text('SPELL IT!',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            else
              ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  state.currentRoundIndex + 1 >= state.totalRounds
                      ? 'See Results'
                      : 'Next Round',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    return switch (difficulty) {
      'easy' => Colors.green,
      'medium' => Colors.orange,
      'hard' => Colors.red,
      _ => Colors.grey,
    };
  }
}

class _BeeCompleteView extends StatelessWidget {
  final dynamic score;
  final List<dynamic> rounds;

  const _BeeCompleteView({required this.score, required this.rounds});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Icon(
                score.isPerfect ? Icons.emoji_events : Icons.star,
                size: 80,
                color: score.isPerfect
                    ? Colors.amber
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                score.isPerfect
                    ? 'PERFECT SCORE!'
                    : score.accuracy >= 0.8
                        ? 'Great Job!'
                        : 'Good Try!',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Score card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '${score.totalPoints}',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      Text('POINTS',
                          style: theme.textTheme.labelLarge),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          _ScoreDetail(
                              label: 'Correct',
                              value:
                                  '${score.correctRounds}/${score.totalRounds}'),
                          _ScoreDetail(
                              label: 'Accuracy',
                              value:
                                  '${(score.accuracy * 100).toStringAsFixed(0)}%'),
                          _ScoreDetail(
                              label: 'Hints',
                              value: '${score.totalHintsUsed}'),
                        ],
                      ),
                      if (score.streakBonus > 0) ...[
                        const SizedBox(height: 8),
                        Chip(
                          avatar: const Icon(Icons.bolt,
                              size: 16, color: Colors.amber),
                          label: Text(
                              'Streak Bonus: +${score.streakBonus}'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Round results
              ...rounds.map((round) => ListTile(
                    leading: Icon(
                      round.isCorrect
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: round.isCorrect
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(round.word,
                        style: const TextStyle(letterSpacing: 2)),
                    subtitle: Text(round.definition,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: Text(round.difficulty),
                  )),

              const SizedBox(height: 32),
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

class _ScoreDetail extends StatelessWidget {
  final String label;
  final String value;

  const _ScoreDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
