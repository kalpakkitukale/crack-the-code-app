/// Path Metrics Repository
///
/// Provides queries for analyzing learning path effectiveness and usage metrics.
library;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:crack_the_code/core/errors/failures.dart';

/// Repository interface for learning path metrics
abstract class PathMetricsRepository {
  /// Get completion rate (completed paths / total paths started)
  ///
  /// Returns a value between 0.0 and 1.0
  /// Optional filters: subjectId, dateRange
  Future<Either<Failure, double>> getCompletionRate({
    String? subjectId,
    DateTimeRange? dateRange,
  });

  /// Get average completion time in minutes
  ///
  /// Returns average time from path start to completion
  /// Optional filters: subjectId, dateRange
  Future<Either<Failure, double>> getAverageCompletionTime({
    String? subjectId,
    DateTimeRange? dateRange,
  });

  /// Get drop-off rate (paths abandoned before 50% / total paths started)
  ///
  /// Returns a value between 0.0 and 1.0
  /// Helps identify paths that are too difficult or not engaging
  Future<Either<Failure, double>> getDropOffRate({
    String? subjectId,
    DateTimeRange? dateRange,
  });

  /// Get node skip rate (skipped nodes / total completed nodes)
  ///
  /// Returns a value between 0.0 and 1.0
  /// Optional filters: subjectId, nodeType
  Future<Either<Failure, double>> getNodeSkipRate({
    String? subjectId,
    String? nodeType,
  });

  /// Get average score across all completed paths
  ///
  /// Returns average score percentage (0-100)
  Future<Either<Failure, double>> getAveragePathScore({
    String? subjectId,
    DateTimeRange? dateRange,
  });

  /// Get total number of paths started
  Future<Either<Failure, int>> getTotalPathsStarted({
    String? subjectId,
    DateTimeRange? dateRange,
  });

  /// Get total number of paths completed
  Future<Either<Failure, int>> getTotalPathsCompleted({
    String? subjectId,
    DateTimeRange? dateRange,
  });

  /// Get most popular subjects (by path starts)
  ///
  /// Returns map of subjectId -> count
  Future<Either<Failure, Map<String, int>>> getMostPopularSubjects({
    int limit = 10,
    DateTimeRange? dateRange,
  });

  /// Get engagement metrics for a specific student
  ///
  /// Returns a map with various engagement metrics:
  /// - total_paths_started
  /// - total_paths_completed
  /// - completion_rate
  /// - average_score
  /// - total_time_spent_minutes
  Future<Either<Failure, Map<String, dynamic>>> getStudentEngagement({
    required String studentId,
    DateTimeRange? dateRange,
  });
}

/// Path metrics data class
class PathMetrics {
  final double completionRate;
  final double averageCompletionTimeMinutes;
  final double dropOffRate;
  final double nodeSkipRate;
  final double averageScore;
  final int totalPathsStarted;
  final int totalPathsCompleted;

  const PathMetrics({
    required this.completionRate,
    required this.averageCompletionTimeMinutes,
    required this.dropOffRate,
    required this.nodeSkipRate,
    required this.averageScore,
    required this.totalPathsStarted,
    required this.totalPathsCompleted,
  });

  /// Get human-readable completion rate (e.g., "75%")
  String get completionRateFormatted =>
      '${(completionRate * 100).toStringAsFixed(1)}%';

  /// Get human-readable drop-off rate
  String get dropOffRateFormatted =>
      '${(dropOffRate * 100).toStringAsFixed(1)}%';

  /// Get human-readable skip rate
  String get nodeSkipRateFormatted =>
      '${(nodeSkipRate * 100).toStringAsFixed(1)}%';

  /// Get completion time in hours and minutes (e.g., "2h 30m")
  String get completionTimeFormatted {
    final hours = averageCompletionTimeMinutes ~/ 60;
    final minutes = (averageCompletionTimeMinutes % 60).round();

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Check if metrics indicate healthy engagement
  bool get isHealthy {
    return completionRate >= 0.5 &&  // 50%+ completion rate
           dropOffRate <= 0.3 &&      // Less than 30% drop-off
           averageScore >= 60.0;       // Average score 60%+
  }
}
