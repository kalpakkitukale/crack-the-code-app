import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_progress.freezed.dart';
part 'subject_progress.g.dart';

/// Entity representing progress for a subject
/// Calculated from watch_progress data aggregated by subject
@freezed
class SubjectProgress with _$SubjectProgress {
  const SubjectProgress._();

  const factory SubjectProgress({
    required String subjectId,
    required String subjectName,
    String? description,
    String? boardId,
    required int totalVideos,
    required int completedVideos,
    required int inProgressVideos,
    required int totalChapters,
    required int completedChapters,
    @Default(0) int totalWatchTimeSeconds,
  }) = _SubjectProgress;

  factory SubjectProgress.fromJson(Map<String, dynamic> json) =>
      _$SubjectProgressFromJson(json);

  /// Calculate progress percentage (0.0 to 1.0)
  double get progressPercentage =>
      totalVideos > 0 ? (completedVideos / totalVideos) : 0.0;

  /// Check if user has started this subject
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

  /// Check if subject is completed
  bool get isCompleted =>
      totalVideos > 0 && completedVideos == totalVideos;
}
