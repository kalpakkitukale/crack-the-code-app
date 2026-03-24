import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/utils/formatters.dart';

/// Video card widget to display video information
/// Supports both list and grid layouts with responsive design
class VideoCard extends StatelessWidget {
  final String videoId;
  final String title;
  final String? channelName;
  final int? durationSeconds;
  final String? thumbnailUrl;
  final bool isBookmarked;
  final double? progress;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onQuizTap;
  final bool isGridView;

  const VideoCard({
    super.key,
    required this.videoId,
    required this.title,
    this.channelName,
    this.durationSeconds,
    this.thumbnailUrl,
    this.isBookmarked = false,
    this.progress,
    this.onTap,
    this.onBookmarkToggle,
    this.onQuizTap,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridCard(context) : _buildListCard(context);
  }

  // Ensure progress is always between 0.0 and 1.0
  double get _clampedProgress => progress?.clamp(0.0, 1.0) ?? 0.0;

  // Segment-aware scaling for Junior
  double get _touchScale => SegmentConfig.settings.touchTargetScale;
  bool get _isJunior => SegmentConfig.isCrackTheCode;

  /// Build semantic label for screen readers
  String _buildSemanticLabel() {
    final buffer = StringBuffer('Video: $title.');

    if (channelName != null && channelName!.isNotEmpty) {
      buffer.write(' By $channelName.');
    }

    if (durationSeconds != null) {
      final minutes = durationSeconds! ~/ 60;
      final seconds = durationSeconds! % 60;
      if (minutes > 0) {
        buffer.write(' Duration: $minutes minutes');
        if (seconds > 0) buffer.write(' $seconds seconds');
        buffer.write('.');
      } else {
        buffer.write(' Duration: $seconds seconds.');
      }
    }

    if (progress != null && progress! > 0) {
      final percent = (progress! * 100).toInt();
      buffer.write(' $percent% watched.');
    }

    if (isBookmarked) {
      buffer.write(' Bookmarked.');
    }

    buffer.write(' Double tap to play.');

    return buffer.toString();
  }

  Widget _buildListCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final padding = 12.0 * _touchScale;

    return Semantics(
      label: _buildSemanticLabel(),
      button: true,
      child: Card(
        margin: EdgeInsets.only(bottom: AppTheme.spacingMd * _touchScale),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SegmentConfig.settings.cardBorderRadius,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail with duration overlay - fixed aspect ratio
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildThumbnail(context),
            ),

            // Video details - fixed padding, no overflow
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title - constrained to 2 lines
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Channel name
                        if (channelName != null && channelName!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            channelName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Quiz button
                  if (onQuizTap != null)
                    IconButton(
                      icon: Icon(
                        Icons.quiz,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      onPressed: onQuizTap,
                      tooltip: 'Take Quiz',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),

            // Progress bar outside of fixed height section
            if (progress != null && progress! > 0)
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10 * _touchScale),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  child: LinearProgressIndicator(
                    value: _clampedProgress,
                    minHeight: _isJunior ? 5 : 3,
                    backgroundColor: colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: _buildSemanticLabel(),
      button: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail - takes most of the available space
            Expanded(
              flex: 3,
              child: _buildThumbnail(context),
            ),

            // Details - compact fixed section at bottom
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (channelName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            channelName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Quiz button
                  if (onQuizTap != null)
                    IconButton(
                      icon: Icon(
                        Icons.quiz,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      onPressed: onQuizTap,
                      tooltip: 'Take Quiz',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final thumbnailImageUrl =
        thumbnailUrl ?? Formatters.getYoutubeThumbnail(videoId);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Thumbnail image with child-friendly placeholders
        CachedNetworkImage(
          imageUrl: thumbnailImageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildChildFriendlyPlaceholder(
            context,
            colorScheme,
            theme,
            isLoading: true,
          ),
          errorWidget: (context, url, error) => _buildChildFriendlyPlaceholder(
            context,
            colorScheme,
            theme,
            isLoading: false,
          ),
        ),

        // Duration overlay (bottom-right) - larger for Junior
        if (durationSeconds != null)
          Positioned(
            bottom: 8 * _touchScale,
            right: 8 * _touchScale,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6 * _touchScale,
                vertical: 2 * _touchScale,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm * _touchScale),
              ),
              child: Text(
                Formatters.formatDuration(durationSeconds!),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isJunior ? 14 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // Bookmark button (top-right)
        Positioned(
          top: 8 * _touchScale,
          right: 8 * _touchScale,
          child: _buildBookmarkButton(context),
        ),

        // Progress indicator at bottom if video is in progress
        if (progress != null && progress! > 0)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: _clampedProgress,
              minHeight: 4,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconSize = _isJunior ? 24.0 : 20.0;
    final padding = _isJunior ? 12.0 : 10.0;

    return Material(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      child: InkWell(
        onTap: onBookmarkToggle,
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        child: Padding(
          // Balanced padding for touch target and compact layout
          // Larger touch targets for Junior
          padding: EdgeInsets.all(padding),
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? colorScheme.primary : Colors.white,
            size: iconSize,
            semanticLabel: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
          ),
        ),
      ),
    );
  }

  /// Build a child-friendly placeholder for video thumbnails
  /// Shows encouraging messages and playful icons instead of technical error states
  Widget _buildChildFriendlyPlaceholder(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme, {
    required bool isLoading,
  }) {
    final iconSize = _isJunior ? 56.0 : 48.0;
    final fontSize = _isJunior ? 14.0 : 12.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.8),
            colorScheme.secondaryContainer.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              // Loading state - show playful animation indicator
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading video...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              // Error state - show friendly message
              Icon(
                Icons.play_circle_filled,
                size: iconSize,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 8),
              Text(
                _isJunior ? 'Tap to watch!' : 'Video ready',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact video list tile for use in lists
class VideoListTile extends StatelessWidget {
  final String videoId;
  final String title;
  final String? subtitle;
  final int? durationSeconds;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkToggle;

  const VideoListTile({
    super.key,
    required this.videoId,
    required this.title,
    this.subtitle,
    this.durationSeconds,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmarkToggle,
  });

  String _buildSemanticLabel() {
    final buffer = StringBuffer('Video: $title.');

    if (subtitle != null) {
      buffer.write(' $subtitle.');
    }

    if (durationSeconds != null) {
      final minutes = durationSeconds! ~/ 60;
      final seconds = durationSeconds! % 60;
      if (minutes > 0) {
        buffer.write(' Duration: $minutes minutes');
        if (seconds > 0) buffer.write(' $seconds seconds');
        buffer.write('.');
      } else {
        buffer.write(' Duration: $seconds seconds.');
      }
    }

    if (isBookmarked) {
      buffer.write(' Bookmarked.');
    }

    buffer.write(' Double tap to play.');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: _buildSemanticLabel(),
      button: true,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: SizedBox(
          width: 120,
          height: 68,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: Formatters.getYoutubeThumbnail(videoId),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceVariant,
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceVariant,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
              if (durationSeconds != null)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(
                      Formatters.formatDuration(durationSeconds!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      title: SizedBox(
        width: double.infinity,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: subtitle != null
          ? SizedBox(
              width: double.infinity,
              child: Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : null,
      trailing: IconButton(
        onPressed: onBookmarkToggle,
        icon: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: isBookmarked ? colorScheme.primary : null,
        ),
        tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
      ),
      ),
    );
  }
}
