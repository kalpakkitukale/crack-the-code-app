import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_progress.freezed.dart';
part 'chapter_progress.g.dart';

/// Entity representing progress for a chapter
/// Calculated from watch_progress data aggregated by chapter
@freezed
class ChapterProgress with _$ChapterProgress {
  const ChapterProgress._();

  const factory ChapterProgress({
    required String chapterId,
    required String chapterName,
    String? description,
    required int totalVideos,
    required int completedVideos,
    required int inProgressVideos,
    @Default(0) int totalWatchTimeSeconds,
    DateTime? lastWatchedAt,
  }) = _ChapterProgress;

  factory ChapterProgress.fromJson(Map<String, dynamic> json) =>
      _$ChapterProgressFromJson(json);

  /// Calculate progress percentage (0.0 to 1.0)
  double get progressPercentage =>
      totalVideos > 0 ? (completedVideos / totalVideos) : 0.0;

  /// Check if chapter is completed
  bool get isCompleted => totalVideos > 0 && completedVideos == totalVideos;

  /// Check if user has started this chapter
  bool get hasStarted => completedVideos > 0 || inProgressVideos > 0;

  /// Get formatted watch time as string
  String get formattedWatchTime {
    final duration = Duration(seconds: totalWatchTimeSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get total watch time as Duration
  Duration get totalWatchTime => Duration(seconds: totalWatchTimeSeconds);

  /// Get progress status text
  String get statusText {
    if (isCompleted) return 'Completed';
    if (hasStarted) return 'In Progress';
    return 'Not Started';
  }
}
