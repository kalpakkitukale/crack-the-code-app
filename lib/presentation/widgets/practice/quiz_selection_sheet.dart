import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/presentation/providers/content/subject_provider.dart';
import 'package:crack_the_code/presentation/providers/content/chapter_provider.dart';

/// Quiz type selection for filtering
enum QuizSelectionType {
  topic,
  chapter,
  subject,
}

/// Bottom sheet for selecting a quiz to practice
/// Allows users to browse subjects/chapters and select quizzes
class QuizSelectionSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function(String entityId, AssessmentType type) onQuizSelected;

  const QuizSelectionSheet({
    super.key,
    required this.scrollController,
    required this.onQuizSelected,
  });

  @override
  ConsumerState<QuizSelectionSheet> createState() => _QuizSelectionSheetState();
}

class _QuizSelectionSheetState extends ConsumerState<QuizSelectionSheet> {
  QuizSelectionType _selectedType = QuizSelectionType.chapter;
  String? _expandedSubjectId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isJunior = SegmentConfig.isCrackTheCode;
    final subjectState = ref.watch(subjectProvider);

    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.quiz_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isJunior ? 'Choose a Quiz' : 'Select Quiz',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isJunior ? 'Pick a topic to practice!' : 'Browse by subject and chapter',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Quiz Type Selection Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeChip(
                  context,
                  label: isJunior ? 'Topic' : 'Topic Quiz',
                  icon: Icons.topic,
                  type: QuizSelectionType.topic,
                ),
                const SizedBox(width: 8),
                _buildTypeChip(
                  context,
                  label: isJunior ? 'Chapter' : 'Chapter Quiz',
                  icon: Icons.menu_book,
                  type: QuizSelectionType.chapter,
                ),
                const SizedBox(width: 8),
                _buildTypeChip(
                  context,
                  label: isJunior ? 'Subject' : 'Subject Quiz',
                  icon: Icons.school,
                  type: QuizSelectionType.subject,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Divider
        Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.2)),

        // Subject/Chapter List
        Expanded(
          child: subjectState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : subjectState.subjects.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: subjectState.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjectState.subjects[index];
                        return _buildSubjectSection(context, subject);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required QuizSelectionType type,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedType == type;

    return FilterChip(
      label: Text(label),
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
      ),
      selected: isSelected,
      onSelected: (value) {
        setState(() {
          _selectedType = type;
        });
      },
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onPrimary : null,
        fontWeight: isSelected ? FontWeight.w600 : null,
      ),
      checkmarkColor: theme.colorScheme.onPrimary,
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildSubjectSection(BuildContext context, dynamic subject) {
    final theme = Theme.of(context);
    final isExpanded = _expandedSubjectId == subject.id;
    final isJunior = SegmentConfig.isCrackTheCode;

    // Get subject color or use a default
    Color subjectColor;
    try {
      subjectColor = Color(int.parse(subject.color?.replaceFirst('#', '0xFF') ?? '0xFF1976D2'));
    } catch (_) {
      subjectColor = theme.colorScheme.primary;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isExpanded ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isExpanded
              ? subjectColor.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Subject Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSubjectId = isExpanded ? null : subject.id;
              });
              // Load chapters when expanding
              if (!isExpanded) {
                ref.read(chapterProvider.notifier).loadChapters(subject.id);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: subjectColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getSubjectIcon(subject.name),
                      color: subjectColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_selectedType == QuizSelectionType.subject) ...[
                          const SizedBox(height: 4),
                          Text(
                            isJunior ? 'Tap to start subject quiz' : 'Full subject assessment',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_selectedType == QuizSelectionType.subject)
                    FilledButton.tonal(
                      onPressed: () => widget.onQuizSelected(subject.id, AssessmentType.knowledge),
                      child: Text(isJunior ? 'Start' : 'Take Quiz'),
                    )
                  else
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                ],
              ),
            ),
          ),

          // Chapters (if expanded and not subject-level)
          if (isExpanded && _selectedType != QuizSelectionType.subject)
            _buildChaptersList(context, subject.id, subjectColor),
        ],
      ),
    );
  }

  Widget _buildChaptersList(BuildContext context, String subjectId, Color subjectColor) {
    final theme = Theme.of(context);
    final chapterState = ref.watch(chapterProvider);
    final isJunior = SegmentConfig.isCrackTheCode;

    if (chapterState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Chapters are loaded per subject, so we use all chapters from the current state
    final chapters = chapterState.chapters;

    if (chapters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No chapters available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: chapters.map((chapter) {
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: subjectColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _selectedType == QuizSelectionType.topic ? Icons.topic : Icons.quiz_outlined,
                color: subjectColor,
                size: 20,
              ),
            ),
            title: Text(
              chapter.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              _selectedType == QuizSelectionType.topic
                  ? (isJunior ? 'Pick a topic to practice' : 'Select topic for quiz')
                  : (isJunior ? 'Test the whole chapter!' : 'Chapter assessment'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            trailing: _selectedType == QuizSelectionType.chapter
                ? FilledButton.tonal(
                    onPressed: () => widget.onQuizSelected(chapter.id, AssessmentType.knowledge),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(isJunior ? 'Start' : 'Quiz'),
                  )
                : Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            onTap: _selectedType == QuizSelectionType.topic
                ? () {
                    // For topic selection, we'd need to show topics
                    // For now, use chapter quiz
                    widget.onQuizSelected(chapter.id, AssessmentType.knowledge);
                  }
                : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isJunior = SegmentConfig.isCrackTheCode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isJunior ? 'No subjects yet!' : 'No Subjects Available',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isJunior
                  ? 'Browse some videos first to unlock quizzes!'
                  : 'Browse content to see available quizzes',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('math')) return Icons.calculate;
    if (name.contains('science')) return Icons.science;
    if (name.contains('english')) return Icons.abc;
    if (name.contains('hindi')) return Icons.translate;
    if (name.contains('social') || name.contains('history')) return Icons.public;
    if (name.contains('computer')) return Icons.computer;
    if (name.contains('physics')) return Icons.bolt;
    if (name.contains('chemistry')) return Icons.science;
    if (name.contains('biology')) return Icons.biotech;
    return Icons.school;
  }
}
