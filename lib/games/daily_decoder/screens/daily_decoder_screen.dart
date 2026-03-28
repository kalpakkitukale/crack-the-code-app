import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/daily_decoder/models/daily_puzzle.dart';
import 'package:crack_the_code/games/daily_decoder/providers/daily_decoder_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';

class DailyDecoderScreen extends ConsumerStatefulWidget {
  const DailyDecoderScreen({super.key});

  @override
  ConsumerState<DailyDecoderScreen> createState() => _DailyDecoderScreenState();
}

class _DailyDecoderScreenState extends ConsumerState<DailyDecoderScreen> {
  late DailyPuzzle _puzzle;
  late Random _random;
  bool _completed = false;
  int _score = 0;

  // Type A: Phonogram Wordle
  List<String> _targetPhonograms = [];
  String _targetWord = '';
  List<List<String>> _guesses = [];
  List<String> _currentGuess = [];
  int _maxGuesses = 6;

  // Type B: Rule Quiz
  int _ruleNum = 1;
  String _ruleTitle = '';
  List<String> _ruleOptions = [];
  int _correctOption = 0;
  int? _selectedOption;

  // Type C: Memory Match
  List<String> _memoryCards = [];
  List<bool> _memoryFlipped = [];
  int? _firstFlip;
  int _matchesFound = 0;
  int _totalPairs = 6;

  @override
  void initState() {
    super.initState();
    _puzzle = ref.read(todayPuzzleProvider);
    _random = Random(_puzzle.seed);
    _setupPuzzle();
  }

  void _setupPuzzle() {
    switch (_puzzle.type) {
      case PuzzleType.wordDecode:
        _setupWordDecode();
      case PuzzleType.ruleQuiz:
        _setupRuleQuiz();
      case PuzzleType.soundMatch:
        _setupSoundMatch();
    }
  }

  void _setupWordDecode() {
    final words = ref.read(wordRepositoryProvider).getWordsByDifficulty(2);
    if (words.isEmpty) return;
    final word = words[_random.nextInt(words.length)];
    _targetWord = word.word;
    _targetPhonograms = word.phonogramBreakdown;
  }

  void _setupRuleQuiz() {
    final rules = ref.read(rulesProvider);
    if (rules.isEmpty) return;
    final rule = rules[_random.nextInt(rules.length)];
    _ruleNum = rule.ruleNum;
    _ruleTitle = rule.title;
    _ruleOptions = [...rule.yesWords.take(3), ...rule.noWords.take(1)]..shuffle(_random);
    _correctOption = _ruleOptions.indexWhere((w) => rule.noWords.contains(w));
    if (_correctOption < 0) _correctOption = 0;
  }

  void _setupSoundMatch() {
    final phonograms = ref.read(phonogramsProvider);
    final selected = (phonograms.toList()..shuffle(_random)).take(_totalPairs).toList();
    _memoryCards = [];
    for (final p in selected) {
      _memoryCards.add(p.text); // phonogram text
      _memoryCards.add(p.sounds.isNotEmpty ? p.sounds.first.notation : '?'); // sound
    }
    _memoryCards.shuffle(_random);
    _memoryFlipped = List.filled(_memoryCards.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(decoderProgressProvider);

    if (progress.isCompletedToday()) {
      return _buildAlreadyCompleted(progress.todayScore() ?? 0);
    }

    if (_completed) {
      return _buildResults();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text(
          'DAILY DECODER · ${_puzzleTypeName()}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
      ),
      body: SafeArea(
        child: switch (_puzzle.type) {
          PuzzleType.wordDecode => _buildWordDecode(),
          PuzzleType.ruleQuiz => _buildRuleQuiz(),
          PuzzleType.soundMatch => _buildSoundMatch(),
        },
      ),
    );
  }

  String _puzzleTypeName() => switch (_puzzle.type) {
    PuzzleType.wordDecode => 'Decode the Word',
    PuzzleType.ruleQuiz => 'Rule of the Day',
    PuzzleType.soundMatch => 'Sound Match',
  };

  // ═══════════════════════════════════════════
  // TYPE A: Phonogram Wordle
  // ═══════════════════════════════════════════
  Widget _buildWordDecode() {
    final phonograms = ref.read(phonogramsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'This word has ${_targetPhonograms.length} phonograms.\nBuild it from the keyboard below!',
            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
        ),

        // Current guess display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1832),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._currentGuess.map((p) => _guessChip(p, const Color(0xFFFFD700))),
                if (_currentGuess.length < _targetPhonograms.length)
                  ...List.generate(
                    _targetPhonograms.length - _currentGuess.length,
                    (_) => _guessChip('?', Colors.white24),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
        Text('${_guesses.length}/$_maxGuesses guesses used',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.3))),

        const Spacer(),

        // Phonogram keyboard
        SizedBox(
          height: 200,
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, mainAxisSpacing: 4, crossAxisSpacing: 4, childAspectRatio: 1.2),
            itemCount: phonograms.length.clamp(0, 40),
            itemBuilder: (context, i) {
              final p = phonograms[i];
              return GestureDetector(
                onTap: () => setState(() {
                  if (_currentGuess.length < _targetPhonograms.length) {
                    _currentGuess.add(p.text);
                  }
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(p.text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              );
            },
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    if (_currentGuess.isNotEmpty) _currentGuess.removeLast();
                  }),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white70,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                  child: const Text('Undo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _currentGuess.length == _targetPhonograms.length ? _submitGuess : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0618),
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.05)),
                  child: const Text('SUBMIT', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _guessChip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
    );
  }

  void _submitGuess() {
    _guesses.add(List.from(_currentGuess));
    final correct = _currentGuess.join() == _targetPhonograms.join();
    if (correct) {
      _score = [100, 80, 60, 40, 25, 15][_guesses.length - 1];
      _complete();
    } else if (_guesses.length >= _maxGuesses) {
      _score = 0;
      _complete();
    }
    setState(() => _currentGuess = []);
  }

  // ═══════════════════════════════════════════
  // TYPE B: Rule Quiz
  // ═══════════════════════════════════════════
  Widget _buildRuleQuiz() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const KKAvatar(size: 48),
          const SizedBox(height: 16),
          Text('Rule $_ruleNum', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
          const SizedBox(height: 8),
          Text(_ruleTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text('Which word does NOT follow this rule?',
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 16),
          ...List.generate(_ruleOptions.length, (i) {
            final selected = _selectedOption == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: _selectedOption == null ? () => setState(() {
                  _selectedOption = i;
                  _score = i == _correctOption ? 50 : 0;
                  Future.delayed(const Duration(seconds: 2), _complete);
                }) : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected
                        ? (i == _correctOption ? const Color(0xFF4CAF50) : const Color(0xFFF44336)).withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? (i == _correctOption ? const Color(0xFF4CAF50) : const Color(0xFFF44336))
                          : Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Text(_ruleOptions[i],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // TYPE C: Sound Memory Match
  // ═══════════════════════════════════════════
  Widget _buildSoundMatch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Match phonograms with their sounds!',
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
          Text('$_matchesFound / $_totalPairs pairs found',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFFFD700))),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemCount: _memoryCards.length,
              itemBuilder: (context, i) {
                final flipped = _memoryFlipped[i];
                return GestureDetector(
                  onTap: flipped ? null : () => _flipCard(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: flipped
                          ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                          : const Color(0xFF1A1832),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: flipped
                            ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Center(
                      child: Text(
                        flipped ? _memoryCards[i] : '?',
                        style: TextStyle(
                          fontSize: flipped ? 16 : 24,
                          fontWeight: FontWeight.w700,
                          color: flipped ? const Color(0xFFFFD700) : Colors.white24,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _flipCard(int index) {
    setState(() => _memoryFlipped[index] = true);

    if (_firstFlip == null) {
      _firstFlip = index;
    } else {
      final first = _firstFlip!;
      _firstFlip = null;

      // Check match: phonogram text matches its sound notation
      final card1 = _memoryCards[first];
      final card2 = _memoryCards[index];

      // Find if they're a pair
      final phonograms = ref.read(phonogramsProvider);
      bool isMatch = false;
      for (final p in phonograms) {
        if ((p.text == card1 && p.sounds.isNotEmpty && p.sounds.first.notation == card2) ||
            (p.text == card2 && p.sounds.isNotEmpty && p.sounds.first.notation == card1)) {
          isMatch = true;
          break;
        }
      }

      if (isMatch) {
        _matchesFound++;
        if (_matchesFound >= _totalPairs) {
          _score = (_matchesFound / _totalPairs * 50).round();
          Future.delayed(const Duration(milliseconds: 500), _complete);
        }
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _memoryFlipped[first] = false;
            _memoryFlipped[index] = false;
          });
        });
      }
    }
  }

  // ═══════════════════════════════════════════
  // COMPLETION
  // ═══════════════════════════════════════════
  void _complete() {
    ref.read(decoderProgressProvider.notifier).completeToday(_score);
    ref.read(playerProfileProvider.notifier).addXp(_score);
    ref.read(playerProfileProvider.notifier).addCoins(_score ~/ 5);
    setState(() => _completed = true);
  }

  Widget _buildResults() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_score > 0 ? '🎉' : '💪', style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('Score: $_score', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFFFFD700))),
                const SizedBox(height: 8),
                Text('+$_score XP · +${_score ~/ 5} coins 🪙',
                    style: const TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 24),
                Text('Come back tomorrow for a new puzzle!',
                    style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4))),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0618),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyCompleted(int score) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(backgroundColor: const Color(0xFF0A0618), foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✅', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text("Today's puzzle complete!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Score: $score', style: const TextStyle(fontSize: 16, color: Color(0xFFFFD700))),
            const SizedBox(height: 8),
            Text('Come back tomorrow!',
                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4))),
          ],
        ),
      ),
    );
  }
}
