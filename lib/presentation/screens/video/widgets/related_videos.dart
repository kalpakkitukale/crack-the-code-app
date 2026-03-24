import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/widgets/cards/video_card.dart';

/// Related Videos Section
/// Shows videos from same chapter/topic
class RelatedVideos extends StatelessWidget {
  const RelatedVideos({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock related videos
    final relatedVideos = [
      {
        'id': 'dQw4w9WgXcQ',
        'title': 'Distance and Displacement',
        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
        'progress': 0.0,
      },
      {
        'id': 'kJQP7kiw5Fk',
        'title': 'Speed and Velocity',
        'thumbnail': 'https://img.youtube.com/vi/kJQP7kiw5Fk/mqdefault.jpg',
        'progress': 0.3,
      },
      {
        'id': 'jNQXAC9IVRw',
        'title': 'Acceleration',
        'thumbnail': 'https://img.youtube.com/vi/jNQXAC9IVRw/mqdefault.jpg',
        'progress': 0.0,
      },
      {
        'id': 'y8Kyi0WNg40',
        'title': 'Equations of Motion',
        'thumbnail': 'https://img.youtube.com/vi/y8Kyi0WNg40/mqdefault.jpg',
        'progress': 0.7,
      },
      {
        'id': '3fumBcKC6RE',
        'title': 'Graphical Analysis',
        'thumbnail': 'https://img.youtube.com/vi/3fumBcKC6RE/mqdefault.jpg',
        'progress': 1.0,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                Text(
                  'Related Videos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${relatedVideos.length} videos',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Videos List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              itemCount: relatedVideos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                  child: VideoCard(
                    videoId: relatedVideos[index]['id'] as String,
                    title: relatedVideos[index]['title'] as String,
                    thumbnailUrl: relatedVideos[index]['thumbnail'] as String,
                    progress: relatedVideos[index]['progress'] as double,
                    isGridView: false,
                    onTap: () {
                      // TODO: Navigate to video
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
