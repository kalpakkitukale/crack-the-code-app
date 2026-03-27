import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int _step = 0; // 0=welcome, 1=A, 2=B, 3=SH, 4=done
  bool _phonogramTapped = false; // has user tapped the current phonogram?

  final _guidePhonogramIds = ['01', '07', '27']; // A, B, SH

  String get _kkMessage {
    final lang = ref.read(playerProfileProvider).language.name;
    if (_step == 0) {
      return ref.read(playerProfileProvider).language.name == 'hi'
          ? "हाय! मैं KK हूँ! चलो अंग्रेज़ी के सीक्रेट कोड सीखते हैं!"
          : ref.read(playerProfileProvider).language.name == 'mr'
              ? "हाय! मी KK! चला इंग्रजीचे सीक्रेट कोड शिकूया!"
              : "Hey! I'm KK! Let's learn the secret codes of English!";
    }
    if (_step == 4) {
      return lang == 'hi'
          ? "शानदार! आप नेचुरल हो! अब अपनी साउंड कलेक्शन खोलो!"
          : lang == 'mr'
              ? "अप्रतिम! तुम्ही नैसर्गिक आहात! आता तुमचा साउंड कलेक्शन उघडा!"
              : "You're a natural! Now explore your Sound Collection!";
    }
    if (!_phonogramTapped) {
      final phonogram = _getCurrentPhonogram();
      if (phonogram == null) return '';
      return lang == 'hi'
          ? "${phonogram.text} को टैप करो और सुनो!"
          : lang == 'mr'
              ? "${phonogram.text} वर टॅप करा आणि ऐका!"
              : "Tap ${phonogram.text} and listen!";
    }
    // After tapping — show what they heard
    final phonogram = _getCurrentPhonogram();
    if (phonogram == null || phonogram.sounds.isEmpty) return '';
    final sound = phonogram.sounds.first;
    final word = sound.exampleWords.isNotEmpty ? sound.exampleWords.first.word : '';
    return lang == 'hi'
        ? "${phonogram.text} बोलता है ${sound.notation}! जैसे $word!"
        : lang == 'mr'
            ? "${phonogram.text} बोलतो ${sound.notation}! जसे $word!"
            : "${phonogram.text} says ${sound.notation}! Like in $word!";
  }

  Phonogram? _getCurrentPhonogram() {
    if (_step < 1 || _step > 3) return null;
    final idx = (_step - 1).clamp(0, 2);
    return ref.read(phonogramRepositoryProvider).getById(_guidePhonogramIds[idx]);
  }

  @override
  Widget build(BuildContext context) {
    final phonogram = _getCurrentPhonogram();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress dots
              if (_step >= 1 && _step <= 3)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final active = i < _step;
                      final current = i == _step - 1;
                      return Container(
                        width: current ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFFFD700)
                              : Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

              // Main content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const KKAvatar(size: 64),
                        const SizedBox(height: 16),
                        KKSpeechBubble(
                          message: KKMessage(
                            text: _kkMessage,
                            mood: _phonogramTapped ? KKMood.excited : KKMood.happy,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Step-specific content
                        if (_step == 0) _buildWelcome(),
                        if (_step >= 1 && _step <= 3 && phonogram != null)
                          _buildPhonogramCard(phonogram),
                        if (_step == 4) _buildComplete(),
                      ],
                    ),
                  ),
                ),
              ),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0618),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _step == 0
                        ? "✨ Let's Start! ✨"
                        : _step >= 1 && _step <= 3 && !_phonogramTapped
                            ? '👆 Tap the sound above!'
                            : _step >= 1 && _step <= 3 && _phonogramTapped
                                ? 'Next Sound →'
                                : "🚀 Start Exploring!",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      children: [
        const Text('🔤', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 16),
        const Text(
          'Your Sound Collection',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '74 sounds to discover!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildPhonogramCard(Phonogram phonogram) {
    final color = phonogram.color;
    final sound = phonogram.sounds.isNotEmpty ? phonogram.sounds.first : null;
    final words = sound?.exampleWords ?? [];

    return Column(
      children: [
        // Large tappable phonogram
        GestureDetector(
          onTap: () {
            // Play sound
            if (sound != null) {
              final ex = words.isNotEmpty ? words.first.word : null;
              ref.read(audioRepositoryProvider).playPhonogram(
                    sound.soundId,
                    notation: sound.notation,
                    exampleWord: ex,
                  );
            }
            // Record
            ref.read(soundBoardProgressProvider.notifier).recordTap(phonogram.id);
            setState(() => _phonogramTapped = true);
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _phonogramTapped
                    ? const Color(0xFFFFD700)
                    : color.withValues(alpha: 0.4),
                width: _phonogramTapped ? 3 : 2,
              ),
              boxShadow: _phonogramTapped
                  ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 20)]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  phonogram.text,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                if (sound != null && _phonogramTapped)
                  Text(
                    sound.notation,
                    style: TextStyle(
                      fontSize: 16,
                      color: color.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (!_phonogramTapped) ...[
          const SizedBox(height: 16),
          Text(
            '👆 Tap to hear!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],

        // Show words after tapping
        if (_phonogramTapped && words.isNotEmpty) ...[
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: words.take(6).map((w) {
              return GestureDetector(
                onTap: () {
                  ref.read(audioRepositoryProvider).playWord(w.word);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (w.emoji.isNotEmpty)
                        Text(w.emoji, style: const TextStyle(fontSize: 20)),
                      if (w.emoji.isNotEmpty) const SizedBox(width: 6),
                      Text(
                        w.word,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.volume_up,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap any word to hear it!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildComplete() {
    return Column(
      children: [
        const Text('🎉', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 16),
        const Text(
          '3 sounds collected!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '71 more waiting to be discovered!',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  void _onAction() {
    if (_step == 0) {
      setState(() {
        _step = 1;
        _phonogramTapped = false;
      });
    } else if (_step >= 1 && _step <= 3) {
      if (!_phonogramTapped) {
        // Prompt user to tap first
        return;
      }
      if (_step < 3) {
        setState(() {
          _step++;
          _phonogramTapped = false;
        });
      } else {
        setState(() {
          _step = 4;
        });
      }
    } else {
      // Complete
      ref.read(soundBoardProgressProvider.notifier).completeOnboarding();
    }
  }
}
