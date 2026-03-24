import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/presentation/providers/spelling/word_list_provider.dart';

class WordExplorerScreen extends ConsumerStatefulWidget {
  const WordExplorerScreen({super.key});

  @override
  ConsumerState<WordExplorerScreen> createState() =>
      _WordExplorerScreenState();
}

class _WordExplorerScreenState extends ConsumerState<WordExplorerScreen> {
  int _selectedGrade = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wordListProvider.notifier)
          .loadWordLists(gradeLevel: _selectedGrade);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;
    final state = ref.watch(wordListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Word Explorer')),
      body: Column(
        children: [
          // Grade selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: settings.maxGrade - settings.minGrade + 1,
              itemBuilder: (context, index) {
                final grade = settings.minGrade + index;
                final isSelected = grade == _selectedGrade;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  child: ChoiceChip(
                    label: Text('Grade $grade'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedGrade = grade);
                        ref
                            .read(wordListProvider.notifier)
                            .loadWordLists(gradeLevel: grade);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Word lists
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.wordLists.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64,
                                color: theme.colorScheme.outline),
                            const SizedBox(height: 16),
                            Text(
                                'No word lists for Grade $_selectedGrade yet',
                                style:
                                    theme.textTheme.bodyLarge),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.wordLists.length,
                        itemBuilder: (context, index) {
                          final wordList =
                              state.wordLists[index];
                          return Card(
                            margin: const EdgeInsets.only(
                                bottom: 12),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.all(16),
                              leading: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: theme
                                      .colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Text(
                                      '${wordList.wordCount}',
                                      style: theme.textTheme
                                          .titleLarge
                                          ?.copyWith(
                                        color: theme
                                            .colorScheme
                                            .primary,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    Text('words',
                                        style: theme
                                            .textTheme
                                            .labelSmall),
                                  ],
                                ),
                              ),
                              title: Text(wordList.name,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                      wordList.description,
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .ellipsis),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      Chip(
                                        label: Text(wordList
                                            .difficulty),
                                        visualDensity:
                                            VisualDensity
                                                .compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                      ),
                                      Chip(
                                        label: Text(
                                            '${wordList.estimatedMinutes} min'),
                                        visualDensity:
                                            VisualDensity
                                                .compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                      ),
                                      if (wordList
                                              .phonicsPattern !=
                                          null)
                                        Chip(
                                          label: Text(wordList
                                              .phonicsPattern!
                                              .replaceAll(
                                                  '_',
                                                  ' ')),
                                          visualDensity:
                                              VisualDensity
                                                  .compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                  Icons
                                      .play_circle_outline,
                                  size: 32),
                              onTap: () {
                                // Navigate to practice
                                Navigator.of(context)
                                    .pushNamed(
                                  '/spelling-practice',
                                  arguments: {
                                    'wordListId':
                                        wordList.id
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
