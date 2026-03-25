import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/lesson.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/models/category.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/lesson_provider.dart';
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
  int _currentStep = 0; // 0=intro, 1..N=phonograms, N+1=complete
  int _currentSoundIndex = 0; // for multi-sound phonograms
  String? _expandedWordId; // which word card is expanded

  List<Phonogram> _phonograms = [];

  @override
  void initState() {
    super.initState();
    final repo = ref.read(phonogramRepositoryProvider);
    _phonograms = widget.lesson.phonogramIds
        .map((id) => repo.getById(id))
        .whereType<Phonogram>()
        .toList();
  }

  int get _totalSteps => _phonograms.length + 2;

  Phonogram? get _currentPhonogram =>
      _currentStep > 0 && _currentStep <= _phonograms.length
          ? _phonograms[_currentStep - 1]
          : null;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(playerProfileProvider);
    final lang = profile.language.name;
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
              child: Row(
                children: [
                  Text(
                    '$_currentStep/${_phonograms.length + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_currentStep) / (_totalSteps - 1),
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _currentStep == 0
                  ? _buildIntro(lang, color)
                  : _currentStep <= _phonograms.length
                      ? _buildPhonogramDetail(_currentPhonogram!, color)
                      : _buildComplete(lang, color),
            ),

            // Next button — user controls when to advance
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
                            ? 'Finish Lesson 🎉'
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

  // ═══════════════════════════════════════════
  // INTRO SCREEN
  // ═══════════════════════════════════════════

  Widget _buildIntro(String lang, Color color) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KKAvatar(size: 72),
            const SizedBox(height: 24),
            Text(widget.lesson.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              widget.lesson.titleForLang(lang),
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.lesson.subtitleForLang(lang),
              style: TextStyle(
                  fontSize: 16, color: Colors.white.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            KKSpeechBubble(
              message: KKMessage(
                  text: widget.lesson.kkIntroForLang(lang),
                  mood: KKMood.excited),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.lesson.phonogramCount} sounds · ${widget.lesson.estimatedMinutes} min',
              style: TextStyle(
                  fontSize: 13, color: Colors.white.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PHONOGRAM DETAIL — THE MAIN LEARNING CARD
  // ═══════════════════════════════════════════

  Widget _buildPhonogramDetail(Phonogram phonogram, Color color) {
    final currentSound = phonogram.sounds.isNotEmpty
        ? phonogram.sounds[_currentSoundIndex % phonogram.sounds.length]
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // ─── HERO CARD ───
          _buildHeroCard(phonogram, currentSound, color),

          // ─── SOUND SELECTOR (multi-sound) ───
          if (phonogram.sounds.length > 1) ...[
            const SizedBox(height: 12),
            _buildSoundSelector(phonogram, color),
          ],

          // ─── WORD GRID ───
          if (currentSound != null && currentSound.exampleWords.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildWordSection(
                'WORDS WITH ${phonogram.text}', currentSound, phonogram, color),
          ],

          // ─── KK FUN FACT ───
          if (phonogram.funFact.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildFunFact(phonogram),
          ],

          // ─── HINDI / MARATHI ───
          if (phonogram.hindiText.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildLanguageRow('हिंदी', phonogram.hindiText, color),
          ],
          if (phonogram.marathiText.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildLanguageRow('मराठी', phonogram.marathiText, color),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ─── HERO CARD ───
  Widget _buildHeroCard(Phonogram phonogram, dynamic currentSound, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Phonogram tile
          GestureDetector(
            onTap: () => _playCurrentSound(phonogram),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    phonogram.text,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  if (currentSound != null)
                    Text(
                      currentSound.notation,
                      style: TextStyle(
                        fontSize: 14,
                        color: color.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '🔊 Tap to hear',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 12),

          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${phonogram.category.displayName} · ${phonogram.soundCount} sound${phonogram.soundCount > 1 ? "s" : ""}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SOUND SELECTOR ───
  Widget _buildSoundSelector(Phonogram phonogram, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(phonogram.sounds.length, (i) {
        final sound = phonogram.sounds[i];
        final isActive = i == _currentSoundIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              setState(() => _currentSoundIndex = i);
              ref.read(audioRepositoryProvider).playPhonogram(
                    sound.soundId,
                    notation: sound.notation,
                    exampleWord: sound.exampleWords.isNotEmpty
                        ? sound.exampleWords.first.word
                        : null,
                  );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? color.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? color
                      : Colors.white.withValues(alpha: 0.1),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Text(
                sound.notation,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? color : Colors.white70,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── WORD SECTION ───
  Widget _buildWordSection(
      String title, dynamic currentSound, Phonogram phonogram, Color color) {
    final words = currentSound.exampleWords;
    if (words.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.4),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            final wordText = word.word;
            final emoji = word.emoji;
            final isExpanded = _expandedWordId == '${currentSound.soundId}_$index';

            return GestureDetector(
              onTap: () {
                // Play word audio
                ref.read(audioRepositoryProvider).playWord(wordText);

                // Toggle expanded
                setState(() {
                  _expandedWordId = isExpanded
                      ? null
                      : '${currentSound.soundId}_$index';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isExpanded
                        ? [
                            color.withValues(alpha: 0.2),
                            color.withValues(alpha: 0.1),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.06),
                            Colors.white.withValues(alpha: 0.02),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isExpanded
                        ? color.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                    width: isExpanded ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (emoji.isNotEmpty)
                      Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    _buildHighlightedWord(wordText, phonogram.text, color),
                    const SizedBox(height: 2),
                    Icon(Icons.volume_up,
                        size: 14,
                        color: isExpanded
                            ? color
                            : Colors.white.withValues(alpha: 0.3)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── HIGHLIGHTED WORD ───
  Widget _buildHighlightedWord(String word, String phonogram, Color color) {
    final upperWord = word.toUpperCase();
    final upperPhonogram = phonogram.toUpperCase();
    final idx = upperWord.indexOf(upperPhonogram);

    if (idx == -1) {
      return Text(
        word,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        textAlign: TextAlign.center,
      );
    }

    final before = word.substring(0, idx);
    final match = word.substring(idx, idx + phonogram.length);
    final after = word.substring(idx + phonogram.length);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, fontFamily: null),
        children: [
          if (before.isNotEmpty)
            TextSpan(
                text: before,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          TextSpan(text: match, style: TextStyle(color: color)),
          if (after.isNotEmpty)
            TextSpan(
                text: after,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  // ─── FUN FACT ───
  Widget _buildFunFact(Phonogram phonogram) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KKAvatar(size: 36, animate: false),
        const SizedBox(width: 10),
        Expanded(
          child: KKSpeechBubble(
            message: KKMessage(text: phonogram.funFact),
          ),
        ),
      ],
    );
  }

  // ─── LANGUAGE ROW ───
  Widget _buildLanguageRow(String label, String text, Color color) {
    return GestureDetector(
      onTap: () {
        // Play Hindi/Marathi pronunciation
        if (label == 'हिंदी') {
          ref.read(audioRepositoryProvider).playHindi(text);
        } else {
          ref.read(audioRepositoryProvider).playMarathi(text);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            ),
            Icon(Icons.volume_up,
                size: 16, color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // COMPLETION SCREEN
  // ═══════════════════════════════════════════

  Widget _buildComplete(String lang, Color color) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            Text(
              'Lesson ${widget.lesson.lessonId} Complete!',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const KKAvatar(size: 56),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    '${widget.lesson.phonogramCount}',
                    style: TextStyle(
                        fontSize: 48, fontWeight: FontWeight.w800, color: color),
                  ),
                  const Text(
                    'sounds learned!',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+50 XP · +20 coins 🪙',
                    style: TextStyle(
                        fontSize: 14, color: const Color(0xFFFFD700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════

  void _playCurrentSound(Phonogram phonogram) {
    if (phonogram.sounds.isEmpty) return;
    final sound = phonogram.sounds[_currentSoundIndex % phonogram.sounds.length];
    final ex =
        sound.exampleWords.isNotEmpty ? sound.exampleWords.first.word : null;
    ref.read(audioRepositoryProvider).playPhonogram(
          sound.soundId,
          notation: sound.notation,
          exampleWord: ex,
        );
  }

  void _onNext() {
    if (_currentStep <= _phonograms.length) {
      // Record mastery for current phonogram before moving
      if (_currentStep > 0 && _currentStep <= _phonograms.length) {
        final phonogram = _phonograms[_currentStep - 1];
        for (final sound in phonogram.sounds) {
          ref
              .read(phonogramMasteryProvider.notifier)
              .recordCorrect(sound.soundId, MasteryLevel.heard);
        }
      }

      setState(() {
        _currentStep++;
        _currentSoundIndex = 0; // reset sound index for next phonogram
        _expandedWordId = null; // reset expanded word
      });
    } else {
      // Complete lesson
      ref.read(lessonProgressProvider.notifier).completeLesson(
            widget.lesson.lessonId,
            widget.lesson.phonogramCount,
            100,
          );
      ref.read(playerProfileProvider.notifier).addXp(50);
      ref.read(playerProfileProvider.notifier).addCoins(20);
      Navigator.of(context).pop();
    }
  }
}
