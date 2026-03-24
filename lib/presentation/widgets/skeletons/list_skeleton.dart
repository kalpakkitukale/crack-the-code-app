import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/widgets/skeletons/skeleton_loading.dart';

/// Generic list item skeleton
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            const SkeletonCircle(size: 48),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonText(height: 16, width: double.infinity),
                  SizedBox(height: 8),
                  SkeletonText(height: 12, width: 150),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for a full list view
class ListViewSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int)? itemBuilder;

  const ListViewSkeleton({
    super.key,
    this.itemCount = 5,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: itemBuilder ?? (context, index) => const ListItemSkeleton(),
    );
  }
}

/// Skeleton for stats cards (like in progress overview)
class StatsCardSkeleton extends StatelessWidget {
  const StatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Column(
                  children: const [
                    SkeletonCircle(size: 40),
                    SizedBox(height: AppTheme.spacingSm),
                    SkeletonText(height: 20, width: 60),
                    SizedBox(height: 4),
                    SkeletonText(height: 12, width: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for quiz/question cards
class QuizCardSkeleton extends StatelessWidget {
  const QuizCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question title skeleton
            const SkeletonText(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonText(height: 16, width: 200),
            const SizedBox(height: AppTheme.spacingMd),

            // Options skeleton
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: const SkeletonLoading(
                  height: 48,
                  borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusMd)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
