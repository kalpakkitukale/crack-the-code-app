import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/domain/entities/spelling/phonics_pattern.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

class PhonicsLessonScreen extends ConsumerStatefulWidget {
  const PhonicsLessonScreen({super.key});

  @override
  ConsumerState<PhonicsLessonScreen> createState() =>
      _PhonicsLessonScreenState();
}

class _PhonicsLessonScreenState extends ConsumerState<PhonicsLessonScreen> {
  List<PhonicsPattern> _patterns = [];
  bool _isLoading = true;
  String? _error;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadPatterns();
  }

  Future<void> _loadPatterns() async {
    setState(() => _isLoading = true);
    final result = await injectionContainer.getPhonicsPatterns();
    result.fold(
      (error) => setState(() {
        _error = error.toString();
        _isLoading = false;
      }),
      (patterns) => setState(() {
        _patterns = patterns;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Phonics Patterns')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _patterns.length,
                  itemBuilder: (context, index) {
                    final pattern = _patterns[index];
                    final isExpanded = _expandedIndex == index;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        }),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _gradeColor(pattern.gradeLevel)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Grade ${pattern.gradeLevel}',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color:
                                            _gradeColor(pattern.gradeLevel),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(pattern.difficulty),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const Spacer(),
                                  Icon(isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pattern.name,
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(pattern.description,
                                  style: theme.textTheme.bodyMedium),

                              // Expanded content
                              if (isExpanded) ...[
                                const Divider(height: 24),

                                // Rule
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.2)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.rule,
                                              size: 20,
                                              color: theme
                                                  .colorScheme.primary),
                                          const SizedBox(width: 8),
                                          Text(
                                            'The Rule',
                                            style: theme
                                                .textTheme.titleSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme
                                                  .colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(pattern.rule,
                                          style:
                                              theme.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),

                                // Tip
                                if (pattern.tip != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.amber
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.lightbulb,
                                            color: Colors.amber, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            pattern.tip!,
                                            style: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontStyle: FontStyle
                                                        .italic),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                // Example words
                                if (pattern.exampleWords.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Examples:',
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: pattern.exampleWords
                                        .map((word) => ActionChip(
                                              avatar: const Icon(
                                                  Icons.volume_up,
                                                  size: 16),
                                              label: Text(word,
                                                  style: const TextStyle(
                                                      letterSpacing: 1)),
                                              onPressed: () =>
                                                  ttsService.speak(word),
                                            ))
                                        .toList(),
                                  ),
                                ],

                                // Exceptions
                                if (pattern.exceptions.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Watch out - Exceptions:',
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: pattern.exceptions
                                        .map((word) => Chip(
                                              avatar: const Icon(
                                                  Icons.warning_amber,
                                                  size: 14,
                                                  color: Colors.orange),
                                              label: Text(word),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _gradeColor(int grade) {
    final colors = [
      Colors.green,
      Colors.teal,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.deepPurple,
      Colors.red,
      Colors.brown,
    ];
    return colors[(grade - 1).clamp(0, colors.length - 1)];
  }
}
