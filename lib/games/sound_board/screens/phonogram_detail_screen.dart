import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/tier_progress_provider.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/widgets/word_card.dart';
import 'package:crack_the_code/games/sound_board/widgets/word_detail_sheet.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class PhonogramDetailScreen extends ConsumerStatefulWidget {
  final String phonogramId;

  const PhonogramDetailScreen({super.key, required this.phonogramId});

  @override
  ConsumerState<PhonogramDetailScreen> createState() =>
      _PhonogramDetailScreenState();
}

class _PhonogramDetailScreenState
    extends ConsumerState<PhonogramDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  int _currentSoundIndex = 0;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(phonogramRepositoryProvider);
    final phonogram = repo.getById(widget.phonogramId);
    if (phonogram == null) {
      return const Scaffold(
        body: Center(child: Text('Phonogram not found')),
      );
    }

    final mastery = ref.watch(phonogramMasteryLevelProvider(widget.phonogramId));
    final profile = ref.watch(playerProfileProvider);
    final words = ref.watch(wordsForPhonogramProvider(phonogram.text));
    final currentSound = phonogram.sounds.isNotEmpty
        ? phonogram.sounds[_currentSoundIndex % phonogram.sounds.length]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: phonogram.color.withValues(alpha: 0.15),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero card
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: phonogram.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                        color: phonogram.color.withValues(alpha: 0.4),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: phonogram.color.withValues(
                            alpha: 0.1 + _glowController.value * 0.2),
                        blurRadius: 20 + _glowController.value * 10,
                        spreadRadius: _glowController.value * 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        phonogram.text,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: phonogram.color,
                        ),
                      ),
                      Text(
                        mastery.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: phonogram.color.withValues(alpha: 0.6),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Sound notation + play button
            if (currentSound != null) ...[
              Text(
                'Sound: ${currentSound.notation}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Play sound
                  ref.read(audioRepositoryProvider)
                      .playPhonogram(currentSound.soundId);
                },
                icon: const Icon(Icons.volume_up),
                label: const Text('Tap to hear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: phonogram.color.withValues(alpha: 0.2),
                  foregroundColor: phonogram.color,
                ),
              ),
            ],

            // Multi-sound selector
            if (phonogram.sounds.length > 1) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: List.generate(phonogram.sounds.length, (i) {
                  final sound = phonogram.sounds[i];
                  final isActive = i == _currentSoundIndex;
                  return ChoiceChip(
                    label: Text(sound.notation),
                    selected: isActive,
                    onSelected: (_) {
                      setState(() => _currentSoundIndex = i);
                      ref.read(audioRepositoryProvider)
                          .playPhonogram(sound.soundId);
                    },
                    selectedColor: phonogram.color.withValues(alpha: 0.3),
                    backgroundColor: const Color(0xFF1A1832),
                    labelStyle: TextStyle(
                      color: isActive ? phonogram.color : Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: isActive
                          ? phonogram.color
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  );
                }),
              ),
            ],

            const SizedBox(height: 24),

            // KK fun fact
            if (phonogram.funFact.isNotEmpty) ...[
              Row(
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
              ),
              const SizedBox(height: 24),
            ],

            // Words from unlocked tiers
            if (words.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'WORDS YOU\'RE LEARNING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 2,
                  ),
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
                  childAspectRatio: 0.85,
                ),
                itemCount: words.length.clamp(0, 9),
                itemBuilder: (context, index) {
                  final word = words[index];
                  return WordCard(
                    word: word,
                    ageLevel: profile.ageLevelKey,
                    onTap: () {
                      // Play word audio
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => WordDetailSheet(
                          word: word,
                          ageLevel: profile.ageLevelKey,
                        ),
                      );
                    },
                  );
                },
              ),
            ],

            // Hindi / Marathi
            if (phonogram.hindiText.isNotEmpty) ...[
              const SizedBox(height: 20),
              _languageRow('हिंदी', phonogram.hindiText),
            ],
            if (phonogram.marathiText.isNotEmpty) ...[
              const SizedBox(height: 8),
              _languageRow('मराठी', phonogram.marathiText),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _languageRow(String label, String text) {
    return Container(
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
        ],
      ),
    );
  }
}
