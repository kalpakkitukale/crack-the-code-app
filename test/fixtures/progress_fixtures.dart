/// Progress test fixtures
library;

import 'package:streamshaala/domain/entities/user/progress.dart';

/// Fixtures for Progress entity testing
class ProgressFixtures {
  /// Not started video (0% progress)
  static Progress get notStarted => Progress(
        id: 'progress-not-started',
        videoId: 'video-1',
        title: 'Introduction to Mathematics',
        channelName: 'Math Channel',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        watchDuration: 0,
        totalDuration: 600,
        completed: false,
        lastWatched: DateTime(2024, 1, 15, 10, 30),
      );

  /// In progress video (50% progress)
  static Progress get halfWatched => Progress(
        id: 'progress-half',
        videoId: 'video-2',
        title: 'Algebra Basics',
        channelName: 'Math Channel',
        thumbnailUrl: 'https://example.com/thumb2.jpg',
        watchDuration: 300,
        totalDuration: 600,
        completed: false,
        lastWatched: DateTime(2024, 1, 15, 11, 0),
      );

  /// Almost complete video (89% - just below threshold)
  static Progress get almostComplete89 => Progress(
        id: 'progress-89',
        videoId: 'video-3',
        title: 'Quadratic Equations',
        channelName: 'Math Channel',
        thumbnailUrl: 'https://example.com/thumb3.jpg',
        watchDuration: 534, // 89% of 600
        totalDuration: 600,
        completed: false,
        lastWatched: DateTime(2024, 1, 15, 12, 0),
      );

  /// At threshold video (90% - exactly at threshold)
  static Progress get atThreshold90 => Progress(
        id: 'progress-90',
        videoId: 'video-4',
        title: 'Linear Equations',
        channelName: 'Math Channel',
        thumbnailUrl: 'https://example.com/thumb4.jpg',
        watchDuration: 540, // 90% of 600
        totalDuration: 600,
        completed: true,
        lastWatched: DateTime(2024, 1, 15, 13, 0),
      );

  /// Fully completed video (100%)
  static Progress get fullyCompleted => Progress(
        id: 'progress-complete',
        videoId: 'video-5',
        title: 'Polynomials',
        channelName: 'Math Channel',
        thumbnailUrl: 'https://example.com/thumb5.jpg',
        watchDuration: 600,
        totalDuration: 600,
        completed: true,
        lastWatched: DateTime(2024, 1, 15, 14, 0),
      );

  /// Edge case: zero duration video
  static Progress get zeroDuration => Progress(
        id: 'progress-zero',
        videoId: 'video-zero',
        title: 'Zero Duration Video',
        channelName: 'Test Channel',
        thumbnailUrl: null,
        watchDuration: 0,
        totalDuration: 0,
        completed: false,
        lastWatched: DateTime(2024, 1, 15),
      );

  /// Edge case: over-watched video
  static Progress get overWatched => Progress(
        id: 'progress-over',
        videoId: 'video-over',
        title: 'Over Watched Video',
        channelName: 'Test Channel',
        thumbnailUrl: null,
        watchDuration: 700, // More than total
        totalDuration: 600,
        completed: true,
        lastWatched: DateTime(2024, 1, 15),
      );

  /// Progress with missing metadata
  static Progress get missingMetadata => Progress(
        id: 'progress-no-meta',
        videoId: 'video-no-meta',
        title: null,
        channelName: null,
        thumbnailUrl: null,
        watchDuration: 100,
        totalDuration: 600,
        completed: false,
        lastWatched: DateTime(2024, 1, 15),
      );

  /// Get a list of progress records for testing
  static List<Progress> get sampleHistory => [
        fullyCompleted,
        atThreshold90,
        halfWatched,
        notStarted,
      ];

  /// Generate progress with specific percentage
  static Progress withPercentage(int percentage, {String? id}) {
    final watchDuration = (600 * percentage / 100).round();
    return Progress(
      id: id ?? 'progress-$percentage',
      videoId: 'video-$percentage',
      title: 'Video at $percentage%',
      channelName: 'Test Channel',
      thumbnailUrl: null,
      watchDuration: watchDuration,
      totalDuration: 600,
      completed: percentage >= 90,
      lastWatched: DateTime(2024, 1, 15),
    );
  }
}
