import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/word_entry.dart';

class WordCard extends StatelessWidget {
  final WordEntry word;
  final String ageLevel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const WordCard({
    super.key,
    required this.word,
    required this.ageLevel,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final meaning = word.meaningForLevel(ageLevel);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (word.emoji != null && word.emoji!.isNotEmpty)
              Text(word.emoji!, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              word.word,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (meaning.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                meaning,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
