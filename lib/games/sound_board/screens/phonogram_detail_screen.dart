import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/models/phonogram_sound.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/tier_progress_provider.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/widgets/word_detail_sheet.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class PhonogramDetailScreen extends ConsumerStatefulWidget {
  final String phonogramId;

  const PhonogramDetailScreen({super.key, required this.phonogramId});

  @override
  ConsumerState<PhonogramDetailScreen> createState() =>
      _PhonogramDetailScreenState();
}

class _PhonogramDetailScreenState extends ConsumerState<PhonogramDetailScreen> {
  int _currentSoundIndex = 0;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(phonogramRepositoryProvider);
    final phonogram = repo.getById(widget.phonogramId);
    if (phonogram == null) {
      return const Scaffold(body: Center(child: Text('Not found')));
    }

    final color = phonogram.color;
    final profile = ref.watch(playerProfileProvider);
    final words = ref.watch(wordsForPhonogramProvider(phonogram.text));
    final currentSound = phonogram.sounds.isNotEmpty
        ? phonogram.sounds[_currentSoundIndex % phonogram.sounds.length]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ─── HERO CARD ───
            _buildHero(phonogram, currentSound, color),

            // ─── SOUND SELECTOR ───
            if (phonogram.sounds.length > 1) ...[
              const SizedBox(height: 14),
              _buildSoundChips(phonogram, color),
            ],

            // ─── EXAMPLE WORDS FROM THIS SOUND ───
            if (currentSound != null &&
                currentSound.exampleWords.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionHeader('WORDS WITH ${phonogram.text}'),
              const SizedBox(height: 10),
              _buildWordGrid(currentSound.exampleWords, phonogram, color),
            ],

            // ─── WORDS FROM TIER DATA ───
            if (words.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionHeader('MORE WORDS TO LEARN'),
              const SizedBox(height: 10),
              _buildTierWordGrid(words, phonogram, color, profile.ageLevelKey),
            ],

            // ─── KK FUN FACT ───
            if (phonogram.funFact.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KKAvatar(size: 36, animate: false),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KKSpeechBubble(
                        message: KKMessage(text: phonogram.funFact)),
                  ),
                ],
              ),
            ],

            // ─── HINDI / MARATHI ───
            if (phonogram.hindiText.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildLangRow('हिंदी', phonogram.hindiText),
            ],
            if (phonogram.marathiText.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildLangRow('मराठी', phonogram.marathiText),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── HERO ───
  Widget _buildHero(Phonogram phonogram, PhonogramSound? sound, Color color) {
    return GestureDetector(
      onTap: () => _playSound(phonogram),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.18),
              color.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 24),
          ],
        ),
        child: Column(
          children: [
            // Large phonogram
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: color.withValues(alpha: 0.5), width: 2.5),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 20),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    phonogram.text,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 2,
                    ),
                  ),
                  if (sound != null)
                    Text(
                      sound.notation,
                      style: TextStyle(
                        fontSize: 15,
                        color: color.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_up, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Tap to hear',
                  style: TextStyle(
                    fontSize: 13,
                    color: color.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${phonogram.category.displayName} · ${phonogram.soundCount} sound${phonogram.soundCount > 1 ? "s" : ""}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SOUND CHIPS ───
  Widget _buildSoundChips(Phonogram phonogram, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(phonogram.sounds.length, (i) {
        final sound = phonogram.sounds[i];
        final active = i == _currentSoundIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              setState(() => _currentSoundIndex = i);
              final ex = sound.exampleWords.isNotEmpty
                  ? sound.exampleWords.first.word
                  : null;
              ref.read(audioRepositoryProvider).playPhonogram(
                    sound.soundId,
                    notation: sound.notation,
                    exampleWord: ex,
                  );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: active
                    ? color.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? color : Colors.white.withValues(alpha: 0.1),
                  width: active ? 2 : 1,
                ),
              ),
              child: Text(
                sound.notation,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? color : Colors.white60,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─── WORD GRID (from phonogram example words) ───
  Widget _buildWordGrid(
      List<dynamic> words, Phonogram phonogram, Color color) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final w = words[index];
        return _buildWordTile(w.word, w.emoji, phonogram.text, color);
      },
    );
  }

  // ─── TIER WORD GRID ───
  Widget _buildTierWordGrid(List<dynamic> words, Phonogram phonogram,
      Color color, String ageLevel) {
    final displayWords = words.take(9).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: displayWords.length,
      itemBuilder: (context, index) {
        final w = displayWords[index];
        return GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) =>
                  WordDetailSheet(word: w, ageLevel: ageLevel),
            );
          },
          child: _buildWordTile(
              w.word, w.emoji ?? '', phonogram.text, color),
        );
      },
    );
  }

  // ─── SINGLE WORD TILE ───
  Widget _buildWordTile(
      String word, String emoji, String phonogram, Color color) {
    return GestureDetector(
      onTap: () {
        ref.read(audioRepositoryProvider).playWord(word);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.07),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emoji.isNotEmpty)
              Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            _highlightPhonogram(word, phonogram, color),
            const SizedBox(height: 3),
            Icon(Icons.volume_up,
                size: 13, color: Colors.white.withValues(alpha: 0.25)),
          ],
        ),
      ),
    );
  }

  // ─── HIGHLIGHT PHONOGRAM IN WORD ───
  Widget _highlightPhonogram(String word, String phonogram, Color color) {
    final upper = word.toUpperCase();
    final pUpper = phonogram.toUpperCase();
    final idx = upper.indexOf(pUpper);

    if (idx == -1) {
      return Text(word,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
          textAlign: TextAlign.center);
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        children: [
          if (idx > 0)
            TextSpan(
                text: word.substring(0, idx),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          TextSpan(
              text: word.substring(idx, idx + phonogram.length),
              style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          if (idx + phonogram.length < word.length)
            TextSpan(
                text: word.substring(idx + phonogram.length),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.4),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildLangRow(String label, String text) {
    return GestureDetector(
      onTap: () {
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
                    style: const TextStyle(fontSize: 14, color: Colors.white))),
            Icon(Icons.volume_up,
                size: 16, color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  void _playSound(Phonogram phonogram) {
    if (phonogram.sounds.isEmpty) return;
    final sound =
        phonogram.sounds[_currentSoundIndex % phonogram.sounds.length];
    final ex =
        sound.exampleWords.isNotEmpty ? sound.exampleWords.first.word : null;
    ref.read(audioRepositoryProvider).playPhonogram(
          sound.soundId,
          notation: sound.notation,
          exampleWord: ex,
        );
  }
}
