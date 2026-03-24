/// Progress repository interface for tracking video watch progress
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';
import 'package:crack_the_code/domain/entities/subject_progress.dart';
import 'package:crack_the_code/domain/entities/chapter_progress.dart';

/// Repository interface for progress operations
abstract class ProgressRepository {
  /// Save or update progress for a video
  Future<Either<Failure, Progress>> saveProgress(Progress progress);

  /// Get progress for a specific video
  Future<Either<Failure, Progress?>> getProgressByVideoId(String videoId);

  /// Get all videos in progress (started but not completed)
  Future<Either<Failure, List<Progress>>> getInProgressVideos();

  /// Get all completed videos
  Future<Either<Failure, List<Progress>>> getCompletedVideos();

  /// Get watch history sorted by last watched (recent first)
  Future<Either<Failure, List<Progress>>> getWatchHistory({int? limit});

  /// Get recently watched videos (within last 7 days)
  Future<Either<Failure, List<Progress>>> getRecentlyWatched();

  /// Mark video as completed
  Future<Either<Failure, Progress>> markAsCompleted(String videoId);

  /// Delete progress for a specific video
  Future<Either<Failure, void>> deleteProgress(String videoId);

  /// Get total watch time in seconds
  Future<Either<Failure, int>> getTotalWatchTime();

  /// Get completion statistics
  Future<Either<Failure, ProgressStats>> getStatistics();

  /// Clear all progress data
  Future<Either<Failure, void>> clearAllProgress();

  /// Get aggregated progress for all subjects
  /// This combines content data with watch progress to calculate completion stats
  Future<Either<Failure, List<SubjectProgress>>> getSubjectProgress();

  /// Get progress for a specific subject by ID
  Future<Either<Failure, SubjectProgress?>> getSubjectProgressById(String subjectId);

  /// Get chapter progress for a specific subject
  Future<Either<Failure, List<ChapterProgress>>> getChapterProgressBySubject(String subjectId);

  /// Get chapter progress by chapter ID
  Future<Either<Failure, ChapterProgress?>> getChapterProgressById(String subjectId, String chapterId);
}

/// Progress statistics
class ProgressStats {
  final int totalVideosWatched;
  final int completedVideos;
  final int inProgressVideos;
  final int totalWatchTimeSeconds;
  final double averageCompletionRate;

  const ProgressStats({
    required this.totalVideosWatched,
    required this.completedVideos,
    required this.inProgressVideos,
    required this.totalWatchTimeSeconds,
    required this.averageCompletionRate,
  });

  String get formattedTotalWatchTime {
    final hours = totalWatchTimeSeconds ~/ 3600;
    final minutes = (totalWatchTimeSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours hr ${minutes} min';
    } else if (minutes > 0) {
      return '$minutes min';
    } else {
      return '${totalWatchTimeSeconds} sec';
    }
  }
}
