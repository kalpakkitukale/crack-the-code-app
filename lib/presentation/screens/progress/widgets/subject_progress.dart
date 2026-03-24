import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/widgets/cards/subject_card.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/domain/entities/subject_progress.dart' as entities;
import 'package:crack_the_code/presentation/providers/user/subject_progress_provider.dart';
import 'package:crack_the_code/presentation/widgets/skeletons/subject_card_skeleton.dart';
import 'package:crack_the_code/core/utils/ui_enhancements.dart';

/// Subject Progress Widget
/// Shows progress for each subject with real data from the database
class SubjectProgress extends ConsumerWidget {
  final int? limit;

  const SubjectProgress({
    super.key,
    this.limit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subjectProgressAsync = ref.watch(subjectProgressListProvider);

    return subjectProgressAsync.when(
      data: (subjects) {
        final displaySubjects = limit != null && subjects.isNotEmpty
            ? subjects.take(limit!).toList()
            : subjects;

        if (displaySubjects.isEmpty) {
          return _buildEmptyState(theme, colorScheme);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: AppTheme.spacingMd),
            ...displaySubjects.map((subject) => _buildProgressCard(
                  context,
                  subject,
                )),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme),
          const SizedBox(height: AppTheme.spacingMd),
          ...List.generate(
            limit ?? 3,
            (index) => const SubjectCardSkeleton(),
          ),
        ],
      ),
      error: (error, stack) => _buildErrorState(theme, colorScheme, error),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Subject Progress',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (limit != null)
          TextButton(
            onPressed: () {
              context.go('/progress/all-subjects');
            },
            child: const Text('View All'),
          ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 48,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Subject Progress Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Start watching videos to track your progress',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme, Object error) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Error Loading Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    entities.SubjectProgress subject,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = _getSubjectColor(subject.subjectName);
    final icon = _getSubjectIcon(subject.subjectName);

    return InkWell(
      onTap: () {
        // Navigate to chapter screen for this subject
        // Use boardId from subject progress, fallback to 'cbse' if not available
        final boardId = subject.boardId ?? 'cbse';
        context.push(RouteConstants.getSubjectChaptersPath(
          boardId,
          subject.subjectId,
        ));
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        elevation: ShadowElevations.medium,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: AnimationDurations.fast,
          curve: AnimationCurves.ease,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingSm),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.subjectName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${subject.completedChapters} / ${subject.totalChapters} chapters',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    '${(subject.progressPercentage * 100).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
                const SizedBox(height: AppTheme.spacingMd),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  child: TweenAnimationBuilder<double>(
                    duration: AnimationDurations.slow,
                    curve: AnimationCurves.emphasized,
                    tween: Tween<double>(begin: 0, end: subject.progressPercentage),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        backgroundColor: colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get color for a subject based on its name
  Color _getSubjectColor(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('physics')) return SubjectColors.physics;
    if (name.contains('chemistry')) return SubjectColors.chemistry;
    if (name.contains('math')) return SubjectColors.mathematics;
    if (name.contains('biology')) return SubjectColors.biology;
    if (name.contains('english')) return SubjectColors.english;
    return SubjectColors.physics; // Default color
  }

  /// Get icon for a subject based on its name
  IconData _getSubjectIcon(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('physics')) return Icons.science;
    if (name.contains('chemistry')) return Icons.biotech;
    if (name.contains('math')) return Icons.calculate;
    if (name.contains('biology')) return Icons.eco;
    if (name.contains('english')) return Icons.menu_book;
    return Icons.school; // Default icon
  }
}
