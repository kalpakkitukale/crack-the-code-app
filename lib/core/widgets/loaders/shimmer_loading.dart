import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading effect widget for skeleton screens
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// Skeleton box for loading placeholders
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Skeleton line for text placeholders
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// Skeleton circle for avatar placeholders
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Video card skeleton
class VideoCardSkeleton extends StatelessWidget {
  const VideoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            const SkeletonBox(
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 12),
            // Title
            const SkeletonLine(width: double.infinity),
            const SizedBox(height: 8),
            // Subtitle
            SkeletonLine(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 14,
            ),
            const SizedBox(height: 8),
            // Metadata
            Row(
              children: [
                SkeletonLine(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 12,
                ),
                const SizedBox(width: 16),
                SkeletonLine(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Subject card skeleton
class SubjectCardSkeleton extends StatelessWidget {
  const SubjectCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SkeletonCircle(size: 64),
            const SizedBox(height: 12),
            const SkeletonLine(width: 100),
            const SizedBox(height: 8),
            SkeletonLine(
              width: 80,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

/// List tile skeleton
class ListTileSkeleton extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;

  const ListTileSkeleton({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            if (hasLeading) ...[
              const SkeletonCircle(size: 48),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: double.infinity),
                  const SizedBox(height: 8),
                  SkeletonLine(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 12,
                  ),
                ],
              ),
            ),
            if (hasTrailing) ...[
              const SizedBox(width: 16),
              const SkeletonBox(width: 24, height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
