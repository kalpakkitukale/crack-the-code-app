/// Chapter Summary Screen for displaying chapter overview
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_summary.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart' show SummarySource;
import 'package:streamshaala/presentation/providers/study_tools/chapter_summary_provider.dart';

/// Chapter Summary Screen
/// Displays the chapter overview with key points and learning objectives
class ChapterSummaryScreen extends ConsumerWidget {
  final String chapterId;
  final String subjectId;

  const ChapterSummaryScreen({
    super.key,
    required this.chapterId,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(chapterSummaryProvider(chapterId, subjectId));
    final isJunior = SegmentConfig.isJunior;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: summaryAsync.when(
        loading: () => const _SummaryShimmer(),
        error: (error, _) => _buildErrorState(context, error.toString()),
        data: (summary) {
          if (summary == null) {
            return _buildEmptyState(context);
          }
          return _SummaryContent(
            summary: summary,
            isJunior: isJunior,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.summarize_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Summary Available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'A summary for this chapter has not been added yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Failed to load summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Summary content widget
class _SummaryContent extends StatelessWidget {
  final ChapterSummary summary;
  final bool isJunior;

  const _SummaryContent({
    required this.summary,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter title
          Text(
            summary.title,
            style: isJunior
                ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                : Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Overview content
          _ContentCard(
            child: Text(
              summary.content,
              style: isJunior
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Key Points section
          if (summary.hasKeyPoints) ...[
            const SizedBox(height: AppTheme.spacingLg),
            _SectionHeader(
              icon: Icons.lightbulb_outline,
              title: 'Key Points',
              iconColor: Colors.amber,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            _ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: summary.keyPoints
                    .map((point) => _KeyPointItem(
                          text: point,
                          isJunior: isJunior,
                        ))
                    .toList(),
              ),
            ),
          ],

          // Learning Objectives section
          if (summary.learningObjectives.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingLg),
            _SectionHeader(
              icon: Icons.flag_outlined,
              title: 'Learning Objectives',
              iconColor: Colors.green,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            _ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: summary.learningObjectives
                    .map((objective) => _ObjectiveItem(
                          text: objective,
                          isJunior: isJunior,
                        ))
                    .toList(),
              ),
            ),
          ],

          // Metadata footer
          const SizedBox(height: AppTheme.spacingLg),
          _MetadataFooter(summary: summary),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

/// Content card wrapper
class _ContentCard extends StatelessWidget {
  final Widget child;

  const _ContentCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: child,
      ),
    );
  }
}

/// Key point item widget
class _KeyPointItem extends StatelessWidget {
  final String text;
  final bool isJunior;

  const _KeyPointItem({
    required this.text,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.star,
            size: isJunior ? 20 : 16,
            color: Colors.amber,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              text,
              style: isJunior
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Learning objective item widget
class _ObjectiveItem extends StatelessWidget {
  final String text;
  final bool isJunior;

  const _ObjectiveItem({
    required this.text,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_box_outline_blank,
            size: isJunior ? 20 : 16,
            color: Colors.green,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              text,
              style: isJunior
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Metadata footer widget
class _MetadataFooter extends StatelessWidget {
  final ChapterSummary summary;

  const _MetadataFooter({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          summary.source == SummarySource.ai ? Icons.smart_toy : Icons.person,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          summary.source == SummarySource.ai ? 'AI Generated' : 'Curated',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Icon(
          Icons.access_time,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          '${summary.estimatedReadTimeMinutes > 0 ? summary.estimatedReadTimeMinutes : summary.calculatedReadTimeMinutes} min read',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}

/// Shimmer loading for summary
class _SummaryShimmer extends StatelessWidget {
  const _SummaryShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(height: 32, width: 200),
            const SizedBox(height: AppTheme.spacingMd),
            const SkeletonBox(height: 120, width: double.infinity),
            const SizedBox(height: AppTheme.spacingLg),
            const SkeletonBox(height: 24, width: 150),
            const SizedBox(height: AppTheme.spacingSm),
            ...List.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: SkeletonBox(height: 20, width: double.infinity),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const SkeletonBox(height: 24, width: 180),
            const SizedBox(height: AppTheme.spacingSm),
            ...List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: SkeletonBox(height: 20, width: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
