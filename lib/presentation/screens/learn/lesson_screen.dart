import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/lesson.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/lesson_provider.dart';
import 'package:crack_the_code/shared/widgets/phonogram_tile_widget.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _currentStep = 0; // 0=intro, 1..N=phonograms, N+1=quiz, N+2=complete
  int _phonogramsLearned = 0;

  List<Phonogram> _phonograms = [];

  @override
  void initState() {
    super.initState();
    _loadPhonograms();
  }

  void _loadPhonograms() {
    final repo = ref.read(phonogramRepositoryProvider);
    _phonograms = widget.lesson.phonogramIds
        .map((id) => repo.getById(id))
        .whereType<Phonogram>()
        .toList();
  }

  int get _totalSteps => _phonograms.length + 2; // intro + phonograms + complete

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(playerProfileProvider);
    final lang = profile.language.name;
    // strings used in _buildComplete
    final color =
        Color(int.parse(widget.lesson.color.replaceFirst('#', '0xFF')));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: Colors.white,
        title: Text(
          'Lesson ${widget.lesson.lessonId}: ${widget.lesson.titleForLang(lang)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _totalSteps,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),

            // Content
            Expanded(
              child: _currentStep == 0
                  ? _buildIntro(lang, color)
                  : _currentStep <= _phonograms.length
                      ? _buildPhonogramStep(
                          _phonograms[_currentStep - 1], color)
                      : _buildComplete(lang, color),
            ),

            // Navigation
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _currentStep == 0
                        ? "Let's Start!"
                        : _currentStep > _phonograms.length
                            ? 'Finish Lesson'
                            : 'Next Sound →',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro(String lang, Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KKAvatar(size: 72),
            const SizedBox(height: 24),
            Text(
              widget.lesson.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              widget.lesson.titleForLang(lang),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.lesson.subtitleForLang(lang),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            KKSpeechBubble(
              message: KKMessage(
                text: widget.lesson.kkIntroForLang(lang),
                mood: KKMood.excited,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.lesson.phonogramCount} sounds · ${widget.lesson.estimatedMinutes} min',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhonogramStep(Phonogram phonogram, Color color) {
    final primarySound =
        phonogram.sounds.isNotEmpty ? phonogram.sounds.first : null;
    final exampleWord = primarySound != null && primarySound.exampleWords.isNotEmpty
        ? primarySound.exampleWords.first
        : null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large phonogram tile
            PhonogramTileWidget(
              phonogram: phonogram,
              size: 120,
              onTap: () {
                if (primarySound != null) {
                  ref
                      .read(audioRepositoryProvider)
                      .playPhonogram(primarySound.soundId);
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              '👆 Tap to hear!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Sound notation
            if (primarySound != null)
              Text(
                'Sound: ${primarySound.notation}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),

            const SizedBox(height: 12),

            // Example word
            if (exampleWord != null) ...[
              Text(
                exampleWord.emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                exampleWord.word,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Multi-sound indicator
            if (phonogram.isMultiSound)
              Text(
                '${phonogram.soundCount} sounds — tap to cycle through!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),

            const SizedBox(height: 16),

            // Sound counter
            Text(
              '$_currentStep of ${_phonograms.length} sounds',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplete(String lang, Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            Text(
              'Lesson ${widget.lesson.lessonId} Complete!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            KKSpeechBubble(
              message: KKMessage(
                text: AppStrings(ref.read(playerProfileProvider).language)
                    .kkLessonComplete(widget.lesson.phonogramCount),
                mood: KKMood.excited,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${widget.lesson.phonogramCount}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const Text(
                    'sounds learned!',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    if (_currentStep <= _phonograms.length) {
      // Record phonogram mastery when moving past a phonogram
      if (_currentStep > 0 && _currentStep <= _phonograms.length) {
        final phonogram = _phonograms[_currentStep - 1];
        for (final sound in phonogram.sounds) {
          ref
              .read(phonogramMasteryProvider.notifier)
              .recordCorrect(sound.soundId, MasteryLevel.heard);
        }
        _phonogramsLearned++;
      }

      setState(() => _currentStep++);
    } else {
      // Complete lesson
      ref.read(lessonProgressProvider.notifier).completeLesson(
            widget.lesson.lessonId,
            widget.lesson.phonogramCount,
            100, // quiz score placeholder
          );
      ref.read(playerProfileProvider.notifier).addXp(50);
      ref.read(playerProfileProvider.notifier).addCoins(20);
      Navigator.of(context).pop();
    }
  }
}
