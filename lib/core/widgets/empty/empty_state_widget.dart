import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Widget to display when there's no data to show
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final bool compact;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppTheme.spacingLg : AppTheme.spacingXxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: compact ? 80 : 120,
              height: compact ? 80 : 120,
              decoration: BoxDecoration(
                color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: compact ? 40 : 60,
                color: iconColor ?? colorScheme.primary,
              ),
            ),
            SizedBox(height: compact ? AppTheme.spacingMd : AppTheme.spacingLg),

            // Title
            Text(
              title,
              style: (compact ? theme.textTheme.titleMedium : theme.textTheme.titleLarge)?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: compact ? AppTheme.spacingSm : AppTheme.spacingMd),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? AppTheme.spacingLg : AppTheme.spacingXl),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pre-configured empty states for common scenarios
class EmptyStates {
  /// No watch history empty state
  static Widget noWatchHistory({VoidCallback? onBrowseVideos}) {
    return EmptyStateWidget(
      icon: Icons.history,
      title: 'No Watch History Yet',
      message: 'Start watching videos to track your progress and build your learning history.',
      actionLabel: onBrowseVideos != null ? 'Browse Videos' : null,
      onAction: onBrowseVideos,
    );
  }

  /// No quiz attempts empty state
  static Widget noQuizAttempts({VoidCallback? onTakeQuiz}) {
    return EmptyStateWidget(
      icon: Icons.quiz_outlined,
      title: 'No Quizzes Taken Yet',
      message: 'Take your first quiz to test your knowledge and track your progress!',
      actionLabel: onTakeQuiz != null ? 'Take a Quiz' : null,
      onAction: onTakeQuiz,
      iconColor: Colors.purple,
    );
  }

  /// No search results empty state
  static Widget noSearchResults(String query) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'No videos or chapters match "$query".\nTry different keywords or browse by subject.',
      iconColor: Colors.orange,
    );
  }

  /// No bookmarks empty state
  static Widget noBookmarks({VoidCallback? onBrowseVideos}) {
    return EmptyStateWidget(
      icon: Icons.bookmark_border,
      title: 'No Bookmarks Yet',
      message: 'Bookmark videos to easily find and access them later.',
      actionLabel: onBrowseVideos != null ? 'Browse Videos' : null,
      onAction: onBrowseVideos,
      iconColor: Colors.amber,
    );
  }

  /// No collections empty state
  static Widget noCollections({VoidCallback? onCreateCollection}) {
    return EmptyStateWidget(
      icon: Icons.folder_outlined,
      title: 'No Collections',
      message: 'Create collections to organize your favorite videos by topic or subject.',
      actionLabel: onCreateCollection != null ? 'Create Collection' : null,
      onAction: onCreateCollection,
      iconColor: Colors.blue,
    );
  }

  /// No notifications empty state
  static Widget noNotifications() {
    return const EmptyStateWidget(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message: 'You\'re all caught up! No new notifications at the moment.',
      iconColor: Colors.green,
    );
  }

  /// No progress data empty state
  static Widget noProgressData({VoidCallback? onStartLearning}) {
    return EmptyStateWidget(
      icon: Icons.trending_up,
      title: 'No Progress Data',
      message: 'Start watching videos and taking quizzes to see your progress and achievements!',
      actionLabel: onStartLearning != null ? 'Start Learning' : null,
      onAction: onStartLearning,
      iconColor: Colors.blue,
    );
  }

  /// No quiz history empty state
  static Widget noQuizHistory({VoidCallback? onTakeQuiz}) {
    return EmptyStateWidget(
      icon: Icons.history,
      title: 'No Quiz History',
      message: 'Your completed quizzes will appear here. Take your first quiz to get started!',
      actionLabel: onTakeQuiz != null ? 'Take a Quiz' : null,
      onAction: onTakeQuiz,
      iconColor: Colors.purple,
    );
  }

  /// No subject progress empty state
  static Widget noSubjectProgress({VoidCallback? onStartLearning}) {
    return EmptyStateWidget(
      icon: Icons.school_outlined,
      title: 'No Subject Progress',
      message: 'Watch videos from different subjects to track your progress across all topics.',
      actionLabel: onStartLearning != null ? 'Start Learning' : null,
      onAction: onStartLearning,
      iconColor: Colors.teal,
    );
  }

  /// No notes empty state
  static Widget noNotes({VoidCallback? onCreateNote}) {
    return EmptyStateWidget(
      icon: Icons.note_outlined,
      title: 'No Notes Yet',
      message: 'Take notes while watching videos to remember key points and concepts.',
      actionLabel: onCreateNote != null ? 'Add Note' : null,
      onAction: onCreateNote,
    );
  }

  /// No videos empty state
  static Widget noVideos() {
    return const EmptyStateWidget(
      icon: Icons.video_library_outlined,
      title: 'No Videos Available',
      message: 'There are no videos available for this topic yet.\nCheck back later for new content.',
    );
  }

  /// Compact no data state (for cards/sections)
  static Widget compactNoData({
    required String message,
    IconData icon = Icons.inbox_outlined,
  }) {
    return EmptyStateWidget(
      icon: icon,
      title: 'No Data',
      message: message,
      compact: true,
    );
  }

  /// Network error state
  static Widget networkError({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      message: 'Check your connection and try again.',
      actionLabel: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
      iconColor: Colors.red,
    );
  }

  /// Generic error state
  static Widget error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'Something Went Wrong',
      message: message,
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
      iconColor: Colors.red,
    );
  }
}

/// Legacy widgets for backward compatibility (deprecated)
@Deprecated('Use EmptyStates.noBookmarks() instead')
class NoBookmarksEmpty extends StatelessWidget {
  const NoBookmarksEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noBookmarks();
  }
}

@Deprecated('Use EmptyStates.noCollections() instead')
class NoCollectionsEmpty extends StatelessWidget {
  final VoidCallback? onCreateCollection;

  const NoCollectionsEmpty({
    super.key,
    this.onCreateCollection,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noCollections(onCreateCollection: onCreateCollection);
  }
}

@Deprecated('Use EmptyStates.noSearchResults() instead')
class NoSearchResultsEmpty extends StatelessWidget {
  final String? searchQuery;

  const NoSearchResultsEmpty({
    super.key,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noSearchResults(searchQuery ?? '');
  }
}

@Deprecated('Use EmptyStates.noNotes() instead')
class NoNotesEmpty extends StatelessWidget {
  final VoidCallback? onCreateNote;

  const NoNotesEmpty({
    super.key,
    this.onCreateNote,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noNotes(onCreateNote: onCreateNote);
  }
}

@Deprecated('Use EmptyStates.noVideos() instead')
class NoVideosEmpty extends StatelessWidget {
  const NoVideosEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noVideos();
  }
}

@Deprecated('Use EmptyStates.noProgressData() instead')
class NoProgressEmpty extends StatelessWidget {
  const NoProgressEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStates.noProgressData();
  }
}
