import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/pedagogy/learning_path_context.dart';
import 'package:crack_the_code/presentation/providers/pedagogy/learning_path_provider.dart';

/// Revision Screen - Quick review of key concepts before continuing
///
/// Shows key concepts from previous nodes in the learning path
/// and allows users to mark them as reviewed before continuing.
class RevisionScreen extends ConsumerStatefulWidget {
  final String nodeId;
  final LearningPathContext pathContext;

  const RevisionScreen({
    super.key,
    required this.nodeId,
    required this.pathContext,
  });

  @override
  ConsumerState<RevisionScreen> createState() => _RevisionScreenState();
}

class _RevisionScreenState extends ConsumerState<RevisionScreen> {
  final Set<String> _reviewedConcepts = {};
  bool _allReviewed = false;
  DateTime? _startTime;

  // Mock revision data - In production, this would come from a provider
  final List<RevisionConcept> _mockConcepts = [
    RevisionConcept(
      id: 'concept_1',
      title: 'Introduction to the Topic',
      category: 'Foundation',
      summary: 'Understanding the basic principles and core concepts that form the foundation of this subject.',
      keyPoints: [
        'Definition and scope of the topic',
        'Historical context and evolution',
        'Key terminology and concepts',
        'Real-world applications',
      ],
    ),
    RevisionConcept(
      id: 'concept_2',
      title: 'Core Principles',
      category: 'Fundamentals',
      summary: 'The fundamental principles that govern this domain and how they apply in practice.',
      keyPoints: [
        'First principle and its implications',
        'Second principle with examples',
        'Third principle in context',
        'How principles interconnect',
      ],
    ),
    RevisionConcept(
      id: 'concept_3',
      title: 'Practical Applications',
      category: 'Application',
      summary: 'How to apply theoretical knowledge to solve real-world problems effectively.',
      keyPoints: [
        'Problem identification strategies',
        'Solution design approaches',
        'Implementation best practices',
        'Common pitfalls to avoid',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _checkAllReviewed() {
    setState(() {
      _allReviewed = _reviewedConcepts.length == _mockConcepts.length;
    });
  }

  Future<void> _markComplete() async {
    final timeSpent = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    // Mark node complete in provider
    await ref.read(learningPathProvider.notifier).completeNode(
      nodeId: widget.pathContext.nodeId,
      metadata: {
        'type': 'revision',
        'reviewedConcepts': _reviewedConcepts.toList(),
        'completionTime': DateTime.now().toIso8601String(),
        'timeSpent': timeSpent,
      },
    );

    if (mounted) {
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Revision completed!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Return completion result
      Navigator.of(context).pop(
        CompletionResult.revision(
          nodeId: widget.pathContext.nodeId,
          reviewedConceptsCount: _reviewedConcepts.length,
          timeSpent: timeSpent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // Return completion result when navigating back
        final timeSpent = _startTime != null
            ? DateTime.now().difference(_startTime!).inSeconds
            : 0;

        Navigator.pop(
          context,
          CompletionResult.revision(
            nodeId: widget.pathContext.nodeId,
            reviewedConceptsCount: _reviewedConcepts.length,
            timeSpent: timeSpent,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Revision'),
          actions: [
            if (_allReviewed)
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: _markComplete,
                tooltip: 'Mark Revision Complete',
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              _buildProgressIndicator(),
              const SizedBox(height: AppTheme.spacingLg),

              // Instruction text
              Text(
                'Review these key concepts before continuing:',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                'Take a moment to refresh your understanding of these important topics.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Revision cards
              ..._mockConcepts.map((concept) => _buildConceptCard(concept)),

              const SizedBox(height: AppTheme.spacingXl),

              // Mark Complete button (full width)
              if (_allReviewed)
                FilledButton.icon(
                  onPressed: _markComplete,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Mark Revision Complete'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: AppTheme.successColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = _mockConcepts.isEmpty
        ? 0.0
        : _reviewedConcepts.length / _mockConcepts.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_reviewedConcepts.length}/${_mockConcepts.length} reviewed',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? AppTheme.successColor : context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard(RevisionConcept concept) {
    final reviewed = _reviewedConcepts.contains(concept.id);

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            reviewed ? Icons.check_circle : Icons.circle_outlined,
            color: reviewed ? AppTheme.successColor : context.colorScheme.onSurfaceVariant,
            size: 28,
          ),
          title: Text(
            concept.title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacingXs),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    concept.category,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary
                  Text(
                    concept.summary,
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Key Points
                  if (concept.keyPoints.isNotEmpty) ...[
                    Text(
                      'Key Points:',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    ...concept.keyPoints.map((point) =>
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppTheme.spacingSm,
                          bottom: AppTheme.spacingXs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(
                              child: Text(
                                point,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                  ],

                  // Mark as Reviewed button
                  FilledButton.tonal(
                    onPressed: reviewed
                        ? null
                        : () {
                            setState(() {
                              _reviewedConcepts.add(concept.id);
                              _checkAllReviewed();
                            });
                          },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: reviewed
                          ? AppTheme.successColor.withValues(alpha: 0.2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          reviewed ? Icons.check_circle : Icons.check,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        Text(reviewed ? 'Reviewed ✓' : 'Mark as Reviewed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Revision concept model
class RevisionConcept {
  final String id;
  final String title;
  final String category;
  final String summary;
  final List<String> keyPoints;

  const RevisionConcept({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.keyPoints,
  });
}
