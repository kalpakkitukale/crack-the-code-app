import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/widgets/skeletons/skeleton_loading.dart';

/// Skeleton loading state for video cards
class VideoCardSkeleton extends StatelessWidget {
  const VideoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail skeleton
            const SkeletonLoading(
              height: 200,
              borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusMd)),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Title skeleton (2 lines)
            const SkeletonText(height: 16, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonText(height: 16, width: 200),
            const SizedBox(height: AppTheme.spacingSm),

            // Channel name skeleton
            const SkeletonText(height: 12, width: 150),
            const SizedBox(height: AppTheme.spacingSm),

            // Stats row skeleton
            Row(
              children: const [
                SkeletonText(height: 12, width: 80),
                SizedBox(width: AppTheme.spacingMd),
                SkeletonText(height: 12, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact video card skeleton for lists
class VideoListItemSkeleton extends StatelessWidget {
  const VideoListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail skeleton
            const SkeletonLoading(
              width: 100,
              height: 56,
              borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusSm)),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Video info skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonText(height: 14, width: double.infinity),
                  SizedBox(height: 6),
                  SkeletonText(height: 14, width: 180),
                  SizedBox(height: 8),
                  SkeletonText(height: 12, width: 120),
                  SizedBox(height: 6),
                  SkeletonText(height: 12, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
