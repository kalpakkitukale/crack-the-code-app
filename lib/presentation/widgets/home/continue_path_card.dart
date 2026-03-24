import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/domain/repositories/learning_path_repository.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';
import 'package:streamshaala/presentation/providers/pedagogy/path_analytics_provider.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';
import 'package:intl/intl.dart';

/// Provider for learning path repository access
final learningPathRepositoryProvider = Provider<LearningPathRepository>((ref) {
  return injectionContainer.learningPathRepository;
});

/// Provider for active learning paths
///
/// Loads all active learning paths for the current student,
/// sorted by most recently accessed first.
final activePathsProvider = FutureProvider<List<LearningPath>>((ref) async {
  final repository = ref.watch(learningPathRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getActivePaths(studentId);

  return result.fold(
    (failure) => <LearningPath>[], // Return empty list on failure
    (paths) {
      // Sort by last updated, most recent first
      paths.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      return paths;
    },
  );
});

/// Continue Path Card widget
///
/// Displays the most recently accessed active learning path
/// on the home screen, allowing users to quickly resume their progress.
class ContinuePathCard extends ConsumerWidget {
  const ContinuePathCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathsAsync = ref.watch(activePathsProvider);

    return pathsAsync.when(
      data: (paths) {
        // Don't show anything if no active paths
        if (paths.isEmpty) return const SizedBox.shrink();

        // Show the most recently accessed path
        final mostRecentPath = paths.first;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          elevation: 2,
          child: InkWell(
            onTap: () => _resumePath(context, ref, mostRecentPath),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingSm),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: Icon(
                          Icons.school,
                          color: context.colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Continue Your Foundation Path',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Pick up where you left off',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppTheme.spacingLg),

                  // Path title
                  Text(
                    mostRecentPath.metadata?['title'] as String? ?? 'Foundation Path',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),

                  // Progress info
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: context.colorScheme.primary,
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text(
                        '${mostRecentPath.progressPercentage.toStringAsFixed(0)}% complete',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(' • ', style: TextStyle(fontSize: 12)),
                      Text(
                        '${mostRecentPath.completedNodes}/${mostRecentPath.totalNodes} modules',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    child: LinearProgressIndicator(
                      value: mostRecentPath.progressPercentage / 100,
                      minHeight: 8,
                      backgroundColor: context.colorScheme.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Last accessed and next module info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last studied: ${_formatLastAccessed(mostRecentPath.lastUpdated)}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Next: ${mostRecentPath.currentNode?.title ?? "Complete!"}',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Resume button
                  FilledButton.icon(
                    onPressed: () => _resumePath(context, ref, mostRecentPath),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume Path'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(), // Don't show loading state
      error: (_, __) => const SizedBox.shrink(), // Don't show error state
    );
  }

  /// Navigate to the foundation path screen to resume
  void _resumePath(BuildContext context, WidgetRef ref, LearningPath path) {
    // Track analytics: path accessed from home
    final analytics = ref.read(pathAnalyticsServiceProvider);
    analytics.trackPathAccessedFromHome(path.id);

    // Navigate to foundation path screen
    context.push('/foundation-path', extra: path);
  }

  /// Format the last accessed time in a human-readable way
  String _formatLastAccessed(DateTime lastAccessed) {
    final now = DateTime.now();
    final difference = now.difference(lastAccessed);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(lastAccessed);
    }
  }
}
