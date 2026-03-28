import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';

class SpellingQuizScreen extends ConsumerStatefulWidget {
  final String quizType; // 'phonogram', 'rule', 'word'
  const SpellingQuizScreen({super.key, required this.quizType});

  @override
  ConsumerState<SpellingQuizScreen> createState() => _SpellingQuizScreenState();
}

class _SpellingQuizScreenState extends ConsumerState<SpellingQuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  final int _totalQuestions = 10;
  int? _selectedAnswer;
  bool _answered = false;
  List<_QuizQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  void _generateQuestions() {
    final phonograms = ref.read(phonogramsProvider);
    final random = Random();
    _questions = [];

    for (int i = 0; i < _totalQuestions && i < phonograms.length; i++) {
      final correct = phonograms[random.nextInt(phonograms.length)];
      if (correct.sounds.isEmpty) continue;

      final sound = correct.sounds.first;
      final wrongOptions = phonograms
          .where((p) => p.id != correct.id && p.sounds.isNotEmpty)
          .toList()
        ..shuffle();

      final options = [correct, ...wrongOptions.take(3)]..shuffle();
      final correctIndex = options.indexOf(correct);

      _questions.add(_QuizQuestion(
        question: 'Which phonogram makes the ${sound.notation} sound?',
        options: options.map((p) => p.text).toList(),
        correctIndex: correctIndex,
        explanation: '${correct.text} says ${sound.notation}',
        exampleWord: sound.exampleWords.isNotEmpty ? sound.exampleWords.first.word : '',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0618),
        appBar: AppBar(backgroundColor: const Color(0xFF0A0618), foregroundColor: Colors.white),
        body: const Center(child: Text('Loading quiz...', style: TextStyle(color: Colors.white))),
      );
    }

    if (_currentQuestion >= _questions.length) return _buildResults();

    final q = _questions[_currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text('Question ${_currentQuestion + 1}/$_totalQuestions',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentQuestion + 1) / _totalQuestions,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Question
                    Text(q.question,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24),

                    // Options
                    ...List.generate(q.options.length, (i) {
                      final isSelected = _selectedAnswer == i;
                      final isCorrect = i == q.correctIndex;
                      Color bgColor = Colors.white.withValues(alpha: 0.05);
                      Color borderColor = Colors.white.withValues(alpha: 0.1);

                      if (_answered) {
                        if (isCorrect) {
                          bgColor = const Color(0xFF4CAF50).withValues(alpha: 0.15);
                          borderColor = const Color(0xFF4CAF50);
                        } else if (isSelected && !isCorrect) {
                          bgColor = const Color(0xFFF44336).withValues(alpha: 0.15);
                          borderColor = const Color(0xFFF44336);
                        }
                      } else if (isSelected) {
                        bgColor = const Color(0xFFFFD700).withValues(alpha: 0.1);
                        borderColor = const Color(0xFFFFD700);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: _answered ? null : () => setState(() => _selectedAnswer = i),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor, width: _answered && isCorrect ? 2 : 1),
                            ),
                            child: Row(
                              children: [
                                Text('${String.fromCharCode(65 + i)})',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                                        color: Colors.white.withValues(alpha: 0.5))),
                                const SizedBox(width: 12),
                                Text(q.options[i],
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                                const Spacer(),
                                if (_answered && isCorrect)
                                  const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                                if (_answered && isSelected && !isCorrect)
                                  const Icon(Icons.cancel, color: Color(0xFFF44336)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Feedback
                    if (_answered) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (_selectedAnswer == q.correctIndex
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFF44336))
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const KKAvatar(size: 32, animate: false),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedAnswer == q.correctIndex
                                    ? 'Correct! ${q.explanation}'
                                    : 'Not quite. ${q.explanation}',
                                style: const TextStyle(fontSize: 13, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedAnswer == null
                      ? null
                      : _answered
                          ? _nextQuestion
                          : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0618),
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _answered ? 'Next →' : 'Check Answer',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAnswer() {
    setState(() {
      _answered = true;
      if (_selectedAnswer == _questions[_currentQuestion].correctIndex) {
        _score++;
        ref.read(playerProfileProvider.notifier).addXp(10);
        ref.read(playerProfileProvider.notifier).addCoins(5);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestion++;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  Widget _buildResults() {
    final percentage = (_score / _totalQuestions * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(percentage >= 80 ? '🎉' : percentage >= 50 ? '👍' : '💪',
                    style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('$_score / $_totalQuestions correct',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Text('$percentage%',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                        color: percentage >= 80
                            ? const Color(0xFF4CAF50)
                            : percentage >= 50
                                ? const Color(0xFFFF9800)
                                : const Color(0xFFF44336))),
                const SizedBox(height: 24),
                Text('+${_score * 10} XP · +${_score * 5} coins 🪙',
                    style: const TextStyle(fontSize: 14, color: Color(0xFFFFD700))),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF0A0618),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String exampleWord;

  _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.exampleWord = '',
  });
}
