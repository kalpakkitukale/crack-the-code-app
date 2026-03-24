import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/category.dart';
import 'package:crack_the_code/shared/models/word_entry.dart';

class WordDetailSheet extends StatelessWidget {
  final WordEntry word;
  final String ageLevel;

  const WordDetailSheet({
    super.key,
    required this.word,
    required this.ageLevel,
  });

  @override
  Widget build(BuildContext context) {
    final meaning = word.meaningForLevel(ageLevel);
    final sentence = word.sentenceForLevel(ageLevel);
    final spellingNote = word.spellingNoteForLevel(ageLevel);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1832),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Word header
              Row(
                children: [
                  if (word.emoji != null && word.emoji!.isNotEmpty) ...[
                    Text(word.emoji!, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (word.partOfSpeech != null)
                          Text(
                            '${word.partOfSpeech} · Tier ${word.tier}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: play word audio
                    },
                    icon: const Icon(Icons.volume_up, color: Color(0xFFFFD700)),
                    iconSize: 28,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Phonogram breakdown
              if (word.phonogramBreakdown.isNotEmpty) ...[
                _sectionTitle('HOW IT\'S SPELLED'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (int i = 0; i < word.phonogramBreakdown.length; i++) ...[
                      if (i > 0)
                        Icon(Icons.arrow_forward,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.3)),
                      _phonogramChip(word.phonogramBreakdown[i]),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Meaning
              if (meaning.isNotEmpty) ...[
                _sectionTitle('WHAT IT MEANS'),
                const SizedBox(height: 6),
                Text(
                  meaning,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Sentence
              if (sentence.isNotEmpty) ...[
                _sectionTitle('IN A SENTENCE'),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"$sentence"',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Spelling note
              if (spellingNote.isNotEmpty) ...[
                _sectionTitle('WHY IT\'S SPELLED THIS WAY'),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        spellingNote,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.4),
        letterSpacing: 2,
      ),
    );
  }

  Widget _phonogramChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFFFFD700).withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFFFFD700),
        ),
      ),
    );
  }
}
