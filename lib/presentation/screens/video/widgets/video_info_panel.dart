import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Video Information Panel
/// Displays video title, description, stats, and metadata
class VideoInfoPanel extends StatelessWidget {
  const VideoInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Title
          Text(
            'Introduction to Motion in a Straight Line',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Stats Row
          Wrap(
            spacing: AppTheme.spacingMd,
            children: [
              _buildStat(Icons.visibility, '15.4K views', colorScheme),
              _buildStat(Icons.access_time, '2 days ago', colorScheme),
              _buildStat(Icons.timer, '12:35', colorScheme),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),

          // Chapter Info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: AppTheme.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  'Chapter 1',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Motion in a Straight Line',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Subject & Class
          Row(
            children: [
              Icon(Icons.school, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: 4),
              Text(
                'Physics • Class 11 • CBSE',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Description
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'In this video, we will learn about motion in a straight line. We\'ll cover the basic concepts of distance, displacement, speed, velocity, and acceleration. This is a fundamental topic in physics that forms the basis for understanding more complex motion.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Key Topics
          Text(
            'Key Topics Covered',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _buildKeyTopic('Introduction to Motion', '0:00'),
          _buildKeyTopic('Distance and Displacement', '2:15'),
          _buildKeyTopic('Speed and Velocity', '5:30'),
          _buildKeyTopic('Acceleration Basics', '8:45'),
          _buildKeyTopic('Practice Problems', '10:20'),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyTopic(String topic, String timestamp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(topic),
          ),
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
