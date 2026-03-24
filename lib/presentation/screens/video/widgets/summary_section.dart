/// Summary Section widget for video summaries
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/services/tts_service.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/study_tools/video_summary.dart';
import 'package:streamshaala/presentation/providers/study_tools/summary_provider.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';

/// Summary section in video player tabs
class SummarySection extends ConsumerWidget {
  final String videoId;

  const SummarySection({
    super.key,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(videoSummaryProvider(videoId));
    final isJunior = SegmentConfig.isJunior;

    return summaryAsync.when(
      loading: () => const _SummaryShimmer(),
      error: (error, _) => _buildEmptyState(context),
      data: (summary) {
        if (summary == null) return _buildEmptyState(context);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Points Section
              if (summary.hasKeyPoints) ...[
                _KeyPointsSection(
                  points: summary.keyPoints,
                  isJunior: isJunior,
                ),
                const SizedBox(height: AppTheme.spacingLg),
              ],

              // Full Summary
              _SummaryContent(
                content: summary.content,
                isJunior: isJunior,
              ),

              // Read Aloud Button (Junior only)
              if (isJunior) ...[
                const SizedBox(height: AppTheme.spacingMd),
                _ReadAloudButton(content: summary.content),
              ],

              // Metadata
              const SizedBox(height: AppTheme.spacingLg),
              _SummaryMetadata(summary: summary),
            ],
          ),
        );
      },
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
              'No summary available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'A summary for this video has not been created yet.',
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
}

/// Key points section with visual bullets
class _KeyPointsSection extends StatelessWidget {
  final List<String> points;
  final bool isJunior;

  const _KeyPointsSection({
    required this.points,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: isJunior ? 28 : 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Key Points',
              style: isJunior
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        ...points.asMap().entries.map((entry) {
          final index = entry.key;
          final point = entry.value;
          return _KeyPointItem(
            point: point,
            index: index,
            isJunior: isJunior,
          );
        }),
      ],
    );
  }
}

/// Individual key point item
class _KeyPointItem extends StatelessWidget {
  final String point;
  final int index;
  final bool isJunior;

  const _KeyPointItem({
    required this.point,
    required this.index,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    final color = colors[index % colors.length];

    return Padding(
      padding: EdgeInsets.only(bottom: isJunior ? 12.0 : 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isJunior ? 28 : 20,
            height: isJunior ? 28 : 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(isJunior ? 8 : 6),
            ),
            child: Center(
              child: Icon(
                _getIconForIndex(index),
                size: isJunior ? 16 : 12,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              point,
              style: isJunior
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.star,
      Icons.check_circle,
      Icons.arrow_forward,
      Icons.lightbulb,
      Icons.bookmark,
    ];
    return icons[index % icons.length];
  }
}

/// Summary content display
class _SummaryContent extends StatelessWidget {
  final String content;
  final bool isJunior;

  const _SummaryContent({
    required this.content,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: isJunior ? 28 : 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Summary',
              style: isJunior
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            content,
            style: isJunior
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
          ),
        ),
      ],
    );
  }
}

/// Read aloud button for Junior segment
class _ReadAloudButton extends StatefulWidget {
  final String content;

  const _ReadAloudButton({required this.content});

  @override
  State<_ReadAloudButton> createState() => _ReadAloudButtonState();
}

class _ReadAloudButtonState extends State<_ReadAloudButton> {
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await ttsService.initialize();
    ttsService.onStart = () {
      if (mounted) setState(() => _isPlaying = true);
    };
    ttsService.onComplete = () {
      if (mounted) setState(() => _isPlaying = false);
    };
    ttsService.onCancel = () {
      if (mounted) setState(() => _isPlaying = false);
    };
    ttsService.onError = (_) {
      if (mounted) setState(() => _isPlaying = false);
    };
  }

  @override
  void dispose() {
    // Stop speaking when leaving the screen
    if (_isPlaying) {
      ttsService.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _toggleReadAloud,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(_isPlaying ? Icons.stop : Icons.volume_up),
      label: Text(_isPlaying ? 'Stop Reading' : 'Read Aloud'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingMd,
        ),
      ),
    );
  }

  Future<void> _toggleReadAloud() async {
    if (_isPlaying) {
      await ttsService.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isLoading = true);
      try {
        await ttsService.speak(widget.content);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}

/// Summary metadata display
class _SummaryMetadata extends StatelessWidget {
  final VideoSummary summary;

  const _SummaryMetadata({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          summary.isAiGenerated ? Icons.auto_awesome : Icons.edit_note,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          summary.isAiGenerated ? 'AI Generated' : 'Expert Written',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const Spacer(),
        Text(
          '${summary.estimatedReadTimeMinutes} min read',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}

/// Shimmer loading state for summary
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
            const SkeletonBox(height: 24, width: 120),
            const SizedBox(height: AppTheme.spacingMd),
            const SkeletonBox(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBox(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBox(height: 16, width: 200),
            const SizedBox(height: AppTheme.spacingLg),
            const SkeletonBox(height: 24, width: 100),
            const SizedBox(height: AppTheme.spacingMd),
            const SkeletonBox(height: 120, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
