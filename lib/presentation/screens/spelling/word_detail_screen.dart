import 'package:flutter/material.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              ttsService.speak(word.word);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word display
            Center(
              child: Text(
                word.word,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            Center(
              child: Text(
                word.phonetic,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Chip(label: Text(word.partOfSpeech))),
            Center(
              child: Chip(
                label: Text(
                    'Grade ${word.gradeLevel} - ${word.difficulty}'),
                backgroundColor:
                    _difficultyColor(word.difficulty).withOpacity(0.1),
              ),
            ),

            const SizedBox(height: 24),

            // Definition
            _SectionTitle(title: 'Definition'),
            Text(word.definition, style: theme.textTheme.bodyLarge),

            if (word.meanings.length > 1) ...[
              const SizedBox(height: 8),
              ...word.meanings.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${e.key + 1}. ${e.value}',
                        style: theme.textTheme.bodyMedium),
                  )),
            ],

            // Example sentences
            if (word.exampleSentences.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Examples'),
              ...word.exampleSentences.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.format_quote, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(s,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                      fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  )),
            ],

            // Mnemonic hint
            if (settings.showMnemonics &&
                word.mnemonicHint != null) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Memory Trick'),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(child: Text(word.mnemonicHint!)),
                  ],
                ),
              ),
            ],

            // Common misspellings
            if (word.commonMisspellings.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Watch Out For'),
              Wrap(
                spacing: 8,
                children: word.commonMisspellings
                    .map((m) => Chip(
                          avatar: const Icon(Icons.close,
                              size: 14, color: Colors.red),
                          label: Text(m,
                              style: const TextStyle(
                                  decoration:
                                      TextDecoration.lineThrough)),
                        ))
                    .toList(),
              ),
            ],

            // Phonics patterns
            if (word.phonicsPatterns.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Phonics Patterns'),
              Wrap(
                spacing: 8,
                children: word.phonicsPatterns
                    .map((p) => Chip(
                          avatar:
                              const Icon(Icons.music_note, size: 14),
                          label: Text(p.replaceAll('_', ' ')),
                        ))
                    .toList(),
              ),
            ],

            // Synonyms & Antonyms
            if (word.synonyms.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Synonyms'),
              Wrap(
                spacing: 8,
                children: word.synonyms
                    .map((s) => Chip(label: Text(s)))
                    .toList(),
              ),
            ],

            if (word.antonyms.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Antonyms'),
              Wrap(
                spacing: 8,
                children: word.antonyms
                    .map((a) => Chip(label: Text(a)))
                    .toList(),
              ),
            ],

            // Etymology
            if (settings.showEtymology && word.etymology != null) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Word Origin'),
              Text(word.etymology!,
                  style: theme.textTheme.bodyMedium),
            ],

            // Word family
            if (word.wordFamily != null) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Word Family'),
              Chip(
                avatar:
                    const Icon(Icons.family_restroom, size: 16),
                label:
                    Text(word.wordFamily!.replaceAll('_', ' ')),
              ),
            ],

            // Word parts
            if (word.prefix != null ||
                word.suffix != null ||
                word.rootWord != null) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: 'Word Parts'),
              Row(
                children: [
                  if (word.prefix != null)
                    Chip(
                        label: Text('${word.prefix}-'),
                        backgroundColor:
                            Colors.blue.withOpacity(0.1)),
                  if (word.rootWord != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4),
                      child: Chip(
                          label: Text(word.rootWord!),
                          backgroundColor:
                              Colors.green.withOpacity(0.1)),
                    ),
                  if (word.suffix != null)
                    Chip(
                        label: Text('-${word.suffix}'),
                        backgroundColor:
                            Colors.purple.withOpacity(0.1)),
                ],
              ),
            ],

            const SizedBox(height: 40),

            // Practice button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back and let user practice from the list
                },
                icon: const Icon(Icons.edit),
                label: const Text('Practice This Word'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    return switch (difficulty) {
      'easy' => Colors.green,
      'medium' => Colors.orange,
      'hard' => Colors.red,
      _ => Colors.grey,
    };
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
