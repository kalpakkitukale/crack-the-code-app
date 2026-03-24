import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/entities/pedagogy/quiz_recommendation.dart';

/// Recommended Videos Screen - Flexible video browsing interface
///
/// Allows users to browse and watch all recommended videos with:
/// - Grid/List view toggle
/// - Filter by topic or priority
/// - Sort by rating or priority
/// - Direct video playback
class RecommendedVideosScreen extends StatefulWidget {
  final RecommendationsBundle bundle;

  const RecommendedVideosScreen({
    super.key,
    required this.bundle,
  });

  @override
  State<RecommendedVideosScreen> createState() => _RecommendedVideosScreenState();
}

class _RecommendedVideosScreenState extends State<RecommendedVideosScreen> {
  bool _isGridView = true;
  String _filterMode = 'all'; // all, topic, priority
  String? _selectedTopic;
  String _sortBy = 'priority'; // priority, rating, duration

  List<VideoWithContext> _filteredVideos = [];

  @override
  void initState() {
    super.initState();
    _buildVideoList();
  }

  void _buildVideoList() {
    final videosWithContext = <VideoWithContext>[];

    for (final recommendation in widget.bundle.recommendations) {
      for (final video in recommendation.recommendedVideos) {
        videosWithContext.add(VideoWithContext(
          video: video,
          conceptName: recommendation.conceptName,
          severity: recommendation.severity,
          priorityScore: recommendation.priorityScore,
        ));
      }
    }

    // Remove duplicates (same video might be recommended for multiple concepts)
    final uniqueVideos = <String, VideoWithContext>{};
    for (final vwc in videosWithContext) {
      if (!uniqueVideos.containsKey(vwc.video.id)) {
        uniqueVideos[vwc.video.id] = vwc;
      }
    }

    _filteredVideos = uniqueVideos.values.toList();
    _applySorting();
  }

  void _applyFilter() {
    final allVideos = <VideoWithContext>[];

    for (final recommendation in widget.bundle.recommendations) {
      for (final video in recommendation.recommendedVideos) {
        allVideos.add(VideoWithContext(
          video: video,
          conceptName: recommendation.conceptName,
          severity: recommendation.severity,
          priorityScore: recommendation.priorityScore,
        ));
      }
    }

    // Remove duplicates
    final uniqueVideos = <String, VideoWithContext>{};
    for (final vwc in allVideos) {
      if (!uniqueVideos.containsKey(vwc.video.id)) {
        uniqueVideos[vwc.video.id] = vwc;
      }
    }

    setState(() {
      _filteredVideos = uniqueVideos.values.toList();

      // Apply topic filter
      if (_filterMode == 'topic' && _selectedTopic != null) {
        _filteredVideos = _filteredVideos
            .where((vwc) => vwc.conceptName == _selectedTopic)
            .toList();
      }

      // Apply priority filter (high priority only)
      if (_filterMode == 'priority') {
        _filteredVideos = _filteredVideos
            .where((vwc) => vwc.priorityScore >= 50)
            .toList();
      }

      _applySorting();
    });
  }

  void _applySorting() {
    setState(() {
      switch (_sortBy) {
        case 'priority':
          _filteredVideos.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
          break;
        case 'rating':
          _filteredVideos.sort((a, b) => b.video.rating.compareTo(a.video.rating));
          break;
        case 'duration':
          _filteredVideos.sort((a, b) => a.video.duration.compareTo(b.video.duration));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assessmentType = widget.bundle.assessmentType;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Videos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_filteredVideos.length} ${_filteredVideos.length == 1 ? 'video' : 'videos'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        backgroundColor: assessmentType.backgroundColor,
        actions: [
          // View toggle
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List view' : 'Grid view',
          ),
          // Sort menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _applySorting();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'priority',
                child: Row(
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: 20,
                      color: _sortBy == 'priority' ? assessmentType.primaryColor : null,
                    ),
                    const SizedBox(width: 8),
                    Text('Priority'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 20,
                      color: _sortBy == 'rating' ? assessmentType.primaryColor : null,
                    ),
                    const SizedBox(width: 8),
                    Text('Rating'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'duration',
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: _sortBy == 'duration' ? assessmentType.primaryColor : null,
                    ),
                    const SizedBox(width: 8),
                    Text('Duration'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          if (_filterMode == 'topic') _buildTopicSelector(),
          Expanded(
            child: _buildVideoGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final assessmentType = widget.bundle.assessmentType;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('All Videos'),
              selected: _filterMode == 'all',
              onSelected: (selected) {
                setState(() {
                  _filterMode = 'all';
                  _applyFilter();
                });
              },
              selectedColor: assessmentType.backgroundColor,
              checkmarkColor: assessmentType.primaryColor,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            FilterChip(
              label: const Text('By Topic'),
              selected: _filterMode == 'topic',
              onSelected: (selected) {
                setState(() {
                  _filterMode = selected ? 'topic' : 'all';
                  if (selected && _selectedTopic == null) {
                    _selectedTopic = widget.bundle.recommendations.first.conceptName;
                  }
                  _applyFilter();
                });
              },
              selectedColor: assessmentType.backgroundColor,
              checkmarkColor: assessmentType.primaryColor,
            ),
            const SizedBox(width: AppTheme.spacingSm),
            FilterChip(
              label: const Text('High Priority'),
              selected: _filterMode == 'priority',
              onSelected: (selected) {
                setState(() {
                  _filterMode = selected ? 'priority' : 'all';
                  _applyFilter();
                });
              },
              selectedColor: assessmentType.backgroundColor,
              checkmarkColor: assessmentType.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSelector() {
    final topics = widget.bundle.recommendations
        .map((r) => r.conceptName)
        .toSet()
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTopic,
        decoration: InputDecoration(
          labelText: 'Select Topic',
          border: OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
        ),
        items: topics.map((topic) {
          return DropdownMenuItem(
            value: topic,
            child: Text(topic),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedTopic = value;
            _applyFilter();
          });
        },
      ),
    );
  }

  Widget _buildVideoGrid() {
    if (_filteredVideos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: context.colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No videos found',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Try changing your filters',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final crossAxisCount = _isGridView
            ? (deviceType == DeviceType.mobile ? 2 : deviceType == DeviceType.tablet ? 3 : 4)
            : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppTheme.spacingMd,
            mainAxisSpacing: AppTheme.spacingMd,
            childAspectRatio: _isGridView ? 0.7 : 2.5,
          ),
          itemCount: _filteredVideos.length,
          itemBuilder: (context, index) {
            final videoWithContext = _filteredVideos[index];
            return _VideoCard(
              videoWithContext: videoWithContext,
              isGridView: _isGridView,
              assessmentType: widget.bundle.assessmentType,
            );
          },
        );
      },
    );
  }
}

/// Video with recommendation context
class VideoWithContext {
  final Video video;
  final String conceptName;
  final dynamic severity;
  final int priorityScore;

  const VideoWithContext({
    required this.video,
    required this.conceptName,
    required this.severity,
    required this.priorityScore,
  });
}

/// Video card widget
class _VideoCard extends StatelessWidget {
  final VideoWithContext videoWithContext;
  final bool isGridView;
  final AssessmentType assessmentType;

  const _VideoCard({
    required this.videoWithContext,
    required this.isGridView,
    required this.assessmentType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final video = videoWithContext.video;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleVideoTap(context),
        child: isGridView ? _buildGridLayout(theme) : _buildListLayout(theme),
      ),
    );
  }

  Widget _buildGridLayout(ThemeData theme) {
    final video = videoWithContext.video;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _buildThumbnail(theme),
        ),
        // Video info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority badge
                if (videoWithContext.priorityScore >= 50)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: assessmentType.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'High Priority',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: assessmentType.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                // Title
                Text(
                  video.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Topic
                Text(
                  videoWithContext.conceptName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Rating and views
                Row(
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      video.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.remove_red_eye,
                      size: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      video.formattedViewCount,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListLayout(ThemeData theme) {
    final video = videoWithContext.video;

    return Row(
      children: [
        // Thumbnail
        SizedBox(
          width: 160,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildThumbnail(theme),
          ),
        ),
        // Video info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Priority badge
                if (videoWithContext.priorityScore >= 50)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: assessmentType.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'High Priority',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: assessmentType.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                // Title
                Text(
                  video.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Topic
                Text(
                  videoWithContext.conceptName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Rating, views, duration
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      video.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.remove_red_eye,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      video.formattedViewCount,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      video.durationDisplay,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(ThemeData theme) {
    final video = videoWithContext.video;

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: video.thumbnailUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.play_circle_outline,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
        // Duration overlay
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              video.durationDisplay,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
        // Play button
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: isGridView ? 24 : 32,
            ),
          ),
        ),
      ],
    );
  }

  void _handleVideoTap(BuildContext context) {
    // Use youtubeId instead of entity id for video playback
    context.push(RouteConstants.getVideoPath(videoWithContext.video.youtubeId));
  }
}
