import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';

/// Quiz Breadcrumb Widget
///
/// Displays hierarchical breadcrumb showing quiz context:
/// - Subject level: "Physics"
/// - Chapter level: "Physics > Work, Energy and Power"
/// - Topic level: "Physics > Work, Energy and Power > Work Done by a Force"
/// - Video level: "Physics > Work, Energy and Power > Work Done by a Force > Introduction to Work"
///
/// Usage:
/// ```dart
/// QuizBreadcrumb(
///   level: QuizLevel.topic,
///   subjectName: 'Physics',
///   chapterName: 'Work, Energy and Power',
///   topicName: 'Work Done by a Force',
/// )
/// ```
class QuizBreadcrumb extends StatelessWidget {
  final QuizLevel level;
  final String? subjectName;
  final String? chapterName;
  final String? topicName;
  final String? videoTitle;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double spacing;

  const QuizBreadcrumb({
    super.key,
    required this.level,
    this.subjectName,
    this.chapterName,
    this.topicName,
    this.videoTitle,
    this.textStyle,
    this.iconColor,
    this.spacing = AppTheme.spacingXs,
  });

  @override
  Widget build(BuildContext context) {
    final breadcrumbParts = _buildBreadcrumbParts();

    if (breadcrumbParts.isEmpty) {
      return const SizedBox.shrink();
    }

    final defaultTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      fontWeight: FontWeight.w500,
    );

    return Wrap(
      spacing: spacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < breadcrumbParts.length; i++) ...[
          Text(
            breadcrumbParts[i],
            style: textStyle ?? defaultTextStyle,
          ),
          if (i < breadcrumbParts.length - 1)
            Icon(
              Icons.chevron_right,
              size: 16,
              color: iconColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
        ],
      ],
    );
  }

  /// Build breadcrumb parts based on quiz level
  List<String> _buildBreadcrumbParts() {
    final parts = <String>[];

    switch (level) {
      case QuizLevel.subject:
        // Subject level: "Physics"
        if (subjectName != null) parts.add(subjectName!);
        break;

      case QuizLevel.chapter:
        // Chapter level: "Physics > Work, Energy and Power"
        if (subjectName != null) parts.add(subjectName!);
        if (chapterName != null) parts.add(chapterName!);
        break;

      case QuizLevel.topic:
        // Topic level: "Physics > Work, Energy and Power > Work Done by a Force"
        if (subjectName != null) parts.add(subjectName!);
        if (chapterName != null) parts.add(chapterName!);
        if (topicName != null) parts.add(topicName!);
        break;

      case QuizLevel.video:
        // Video level: "Physics > Work, Energy and Power > Work Done by a Force > Introduction to Work"
        if (subjectName != null) parts.add(subjectName!);
        if (chapterName != null) parts.add(chapterName!);
        if (topicName != null) parts.add(topicName!);
        if (videoTitle != null) parts.add(videoTitle!);
        break;
    }

    return parts;
  }
}

/// Compact variant of QuizBreadcrumb for use in smaller spaces
class QuizBreadcrumbCompact extends StatelessWidget {
  final QuizLevel level;
  final String? subjectName;
  final String? chapterName;
  final String? topicName;
  final String? videoTitle;

  const QuizBreadcrumbCompact({
    super.key,
    required this.level,
    this.subjectName,
    this.chapterName,
    this.topicName,
    this.videoTitle,
  });

  @override
  Widget build(BuildContext context) {
    return QuizBreadcrumb(
      level: level,
      subjectName: subjectName,
      chapterName: chapterName,
      topicName: topicName,
      videoTitle: videoTitle,
      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      iconColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      spacing: 4,
    );
  }
}
