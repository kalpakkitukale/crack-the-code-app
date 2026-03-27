import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/character.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class CharacterDetailScreen extends ConsumerWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  Color get _levelColor {
    return switch (character.levelColor) {
      'green' => const Color(0xFF4CAF50),
      'blue' => const Color(0xFF2196F3),
      'orange' => const Color(0xFFFF9800),
      'red' => const Color(0xFFF44336),
      'gold' => const Color(0xFFFFD700),
      _ => const Color(0xFFFFD700),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final lang = profile.language.name;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: _levelColor.withValues(alpha: 0.1),
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _levelColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('LVL ${character.level}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _levelColor)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  _levelColor.withValues(alpha: 0.15),
                  _levelColor.withValues(alpha: 0.05),
                ]),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _levelColor.withValues(alpha: 0.3)),
                boxShadow: [BoxShadow(color: _levelColor.withValues(alpha: 0.15), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  Text(character.name,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _levelColor, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      ref.read(audioRepositoryProvider).playPhonogram(
                        character.soundId,
                        notation: character.sound,
                        exampleWord: character.easyWords.isNotEmpty ? character.easyWords.first : null,
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _levelColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _levelColor.withValues(alpha: 0.4), width: 2),
                        boxShadow: [BoxShadow(color: _levelColor.withValues(alpha: 0.3), blurRadius: 16)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(character.phonogram.toUpperCase(),
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _levelColor)),
                          Text(character.sound,
                              style: TextStyle(fontSize: 14, color: _levelColor.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('🔊 Tap to hear',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
                  const SizedBox(height: 12),
                  Text('${character.phonogram.toUpperCase()} → ${character.sound}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // KK introduction
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const KKAvatar(size: 36, animate: false),
                const SizedBox(width: 10),
                Expanded(
                  child: KKSpeechBubble(
                    message: KKMessage(text: character.introForLang(lang), mood: KKMood.excited),
                  ),
                ),
              ],
            ),

            // Easy words
            if (character.easyWords.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSectionHeader('EASY WORDS'),
              const SizedBox(height: 8),
              _buildWordGrid(character.easyWords, ref),
            ],

            // Medium words
            if (character.mediumWords.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionHeader('MORE WORDS'),
              const SizedBox(height: 8),
              _buildWordGrid(character.mediumWords, ref),
            ],

            // Character ID
            const SizedBox(height: 24),
            Text('${character.id} · Level ${character.level} ${character.levelColor.toUpperCase()}',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.2))),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.4), letterSpacing: 2)),
    );
  }

  Widget _buildWordGrid(List<String> words, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: words.map((word) {
        return GestureDetector(
          onTap: () => ref.read(audioRepositoryProvider).playWord(word),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(word, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(width: 4),
                Icon(Icons.volume_up, size: 14, color: Colors.white.withValues(alpha: 0.3)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
