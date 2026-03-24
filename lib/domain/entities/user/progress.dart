/// Progress entity for tracking video watch progress
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress.freezed.dart';

@freezed
class Progress with _$Progress {
  const factory Progress({
    required String id,
    required String videoId,
    String? title,
    String? channelName,
    String? thumbnailUrl,
    required int watchDuration,
    required int totalDuration,
    required bool completed,
    required DateTime lastWatched,
  }) = _Progress;

  const Progress._();

  /// Get progress as a fraction (0.0 to 1.0) for progress indicators
  double get progressFraction {
    if (totalDuration == 0) return 0.0;
    return (watchDuration / totalDuration).clamp(0.0, 1.0);
  }

  /// Get completion percentage (0-100) for display purposes
  double get completionPercentage {
    return progressFraction * 100;
  }

  /// Get remaining duration in seconds
  int get remainingDuration {
    return (totalDuration - watchDuration).clamp(0, totalDuration);
  }

  /// Check if video is started (watched > 0%)
  bool get isStarted => watchDuration > 0;

  /// Check if video is almost complete (> 95%)
  bool get isAlmostComplete => completionPercentage > 95.0;

  /// Check if video is in progress (started but not completed)
  bool get isInProgress => isStarted && !completed;

  /// Get formatted watch duration
  String get formattedWatchDuration {
    final hours = watchDuration ~/ 3600;
    final minutes = (watchDuration % 3600) ~/ 60;
    final seconds = watchDuration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Get formatted remaining duration
  String get formattedRemainingDuration {
    final remaining = remainingDuration;
    final hours = remaining ~/ 3600;
    final minutes = (remaining % 3600) ~/ 60;
    final seconds = remaining % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Check if watched recently (within last 7 days)
  bool get isWatchedRecently {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return lastWatched.isAfter(weekAgo);
  }

  /// Get time since last watched
  String get timeSinceLastWatched {
    final now = DateTime.now();
    final difference = now.difference(lastWatched);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
