import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/widgets/skeletons/skeleton_loading.dart';

/// Skeleton loading state for subject progress cards
class SubjectCardSkeleton extends StatelessWidget {
  const SubjectCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon skeleton
                const SkeletonCircle(size: 40),
                const SizedBox(width: AppTheme.spacingMd),

                // Subject name skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonText(height: 16, width: 150),
                      SizedBox(height: 6),
                      SkeletonText(height: 12, width: 100),
                    ],
                  ),
                ),

                // Stats skeleton
                const SkeletonText(height: 24, width: 40),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Progress bar skeleton
            const SkeletonLoading(
              height: 8,
              borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusRound)),
            ),
            const SizedBox(height: AppTheme.spacingSm),

            // Progress text skeleton
            const SkeletonText(height: 12, width: 120),
          ],
        ),
      ),
    );
  }
}

/// Grid view skeleton for subjects
class SubjectGridSkeleton extends StatelessWidget {
  final int itemCount;

  const SubjectGridSkeleton({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Main content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      // Quiz badge placeholder (top right area)
                      Align(
                        alignment: Alignment.topRight,
                        child: SkeletonLoading(
                          height: 20,
                          width: 36,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Icon
                      SkeletonCircle(size: 48),
                      SizedBox(height: 8),
                      // Title
                      SkeletonText(height: 14, width: 80),
                      SizedBox(height: 4),
                      // Chapter count
                      SkeletonText(height: 10, width: 60),
                    ],
                  ),
                ),
              ),
              // Bottom button area (PRE-assessment CTA)
              Container(
                height: 48,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                child: const Center(
                  child: SkeletonText(height: 12, width: 120),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
