import 'package:flutter/material.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class KKSpeechBubble extends StatelessWidget {
  final KKMessage message;

  const KKSpeechBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(message.text),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1832),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _moodColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_moodEmoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _moodEmoji => switch (message.mood) {
        KKMood.happy => '😊',
        KKMood.excited => '🎉',
        KKMood.encouraging => '💪',
        KKMood.thinking => '🤔',
      };

  Color get _moodColor => switch (message.mood) {
        KKMood.happy => const Color(0xFFFFD700),
        KKMood.excited => const Color(0xFF4CAF50),
        KKMood.encouraging => const Color(0xFF2196F3),
        KKMood.thinking => const Color(0xFF9C27B0),
      };
}
