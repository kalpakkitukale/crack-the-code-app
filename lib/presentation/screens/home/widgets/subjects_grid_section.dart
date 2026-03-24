import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/cards/subject_card.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/core/widgets/error/error_widget.dart';
import 'package:streamshaala/core/widgets/empty/empty_state_widget.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/presentation/providers/content/subject_provider.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';

/// Subjects grid section displaying all available subjects
class SubjectsGridSection extends ConsumerWidget {
  final int columns;

  const SubjectsGridSection({
    super.key,
    this.columns = 2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final subjectState = ref.watch(subjectProvider);

    // Handle loading state
    if (subjectState.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subjects',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: AppTheme.spacingMd,
              mainAxisSpacing: AppTheme.spacingMd,
              childAspectRatio: 0.75, // Taller cards to fit top + bottom assessment buttons
            ),
            itemCount: 4, // Show 4 skeleton loaders
            itemBuilder: (context, index) => const SubjectCardSkeleton(),
          ),
        ],
      );
    }

    // Handle error state
    if (subjectState.error != null) {
      return ErrorDisplayWidget(
        message: subjectState.error!,
        onRetry: () => ref.read(subjectProvider.notifier).refresh(),
      );
    }

    // Handle empty state
    if (subjectState.subjects.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.school_outlined,
        title: 'No Subjects Found',
        message: 'Explore our educational boards to find subjects',
        actionLabel: 'Browse Boards',
        onAction: () => context.go(RouteConstants.browse),
      );
    }

    final subjects = subjectState.subjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subjects',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(RouteConstants.browse),
              child: const Text('Browse All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Subjects grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppTheme.spacingMd,
            mainAxisSpacing: AppTheme.spacingMd,
            childAspectRatio: 0.75, // Taller cards to fit top + bottom assessment buttons
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            // Get icon and color from SubjectColors helper
            final icon = SubjectColors.getSubjectIcon(subject.name);
            final color = SubjectColors.getSubjectColor(subject.name);

            // NOTE: Subject progress calculation requires video-subject mapping
            // which doesn't exist in current data model. Showing 0% until
            // we add subject_id to progress tracking or implement chapter completion.
            final progress = 0.0;

            return SubjectCard(
              name: subject.name,
              icon: icon,
              color: color,
              chapterCount: subject.totalChapters,
              progress: progress,
              quizCount: subject.totalChapters, // Each chapter typically has quizzes
              onTap: () {
                // Navigate after frame to avoid Navigator deadlock
                Future.microtask(() {
                  context.push(
                    RouteConstants.getSubjectChaptersPath(
                      subject.boardId,
                      subject.id,
                    ),
                  );
                });
              },
              // POST-assessment: Knowledge validation after learning
              onQuizTap: () {
                final studentId = ref.read(effectiveUserIdProvider);
                Future.microtask(() {
                  context.push(
                    RouteConstants.getQuizPathWithType(
                      subject.id,
                      studentId,
                      assessmentType: 'knowledge',
                    ),
                  );
                });
              },
              // PRE-assessment: Gap analysis before learning (PRIMARY ACTION)
              // Uses same quiz functionality as POST, just different entry point
              onPreAssessmentTap: () {
                final studentId = ref.read(effectiveUserIdProvider);
                Future.microtask(() {
                  context.push(
                    RouteConstants.getQuizPathWithType(
                      subject.id,
                      studentId,
                      assessmentType: 'readiness',
                    ),
                  );
                });
              },
              showPreAssessment: true,
              isNewUser: progress == 0.0, // Show enhanced CTA for new users
            );
          },
        ),
      ],
    );
  }
}
