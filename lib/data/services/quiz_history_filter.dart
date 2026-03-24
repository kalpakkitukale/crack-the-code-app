/// Quiz History Filter Service
///
/// Extracts filtering and sorting logic from QuizRepositoryImpl to reduce
/// file size and improve testability. Handles all quiz attempt filtering
/// operations including date range, performance, and sorting.
library;

import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_filter.dart';

/// Service for filtering and sorting quiz attempt history
class QuizHistoryFilter {
  /// Apply filters and sorting to a list of quiz attempts
  ///
  /// Returns a new filtered and sorted list without modifying the original.
  List<QuizAttempt> applyFilters({
    required List<QuizAttempt> attempts,
    QuizFilters? filters,
    int? limit,
    int? offset,
  }) {
    if (attempts.isEmpty) return [];

    var filtered = List<QuizAttempt>.from(attempts);

    // Apply filters if provided
    if (filters != null) {
      filtered = _applyFilterCriteria(filtered, filters);
      filtered = _applySorting(filtered, filters.sortOrder);
    }

    // Apply pagination
    filtered = _applyPagination(filtered, limit: limit, offset: offset);

    return filtered;
  }

  /// Get recent quizzes sorted by date (newest first)
  List<QuizAttempt> getRecentQuizzes({
    required List<QuizAttempt> attempts,
    int limit = 10,
  }) {
    if (attempts.isEmpty) return [];

    final sorted = List<QuizAttempt>.from(attempts)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return sorted.take(limit).toList();
  }

  /// Apply filter criteria (date range, performance)
  List<QuizAttempt> _applyFilterCriteria(
    List<QuizAttempt> attempts,
    QuizFilters filters,
  ) {
    var filtered = attempts;

    // Filter by date range
    final startDate = filters.getStartDate();
    if (startDate != null) {
      filtered = filtered.where((a) => a.completedAt.isAfter(startDate)).toList();
    }

    // Filter by pass/fail status
    if (filters.performanceFilter == PerformanceFilter.passed) {
      filtered = filtered.where((a) => a.passed).toList();
    } else if (filters.performanceFilter == PerformanceFilter.failed) {
      filtered = filtered.where((a) => !a.passed).toList();
    }

    // TODO: Add level filtering when quiz metadata is available in attempts
    // if (filters.levels != null && filters.levels!.isNotEmpty) { ... }

    return filtered;
  }

  /// Apply sorting based on sort order
  List<QuizAttempt> _applySorting(
    List<QuizAttempt> attempts,
    SortOrder sortOrder,
  ) {
    final sorted = List<QuizAttempt>.from(attempts);

    switch (sortOrder) {
      case SortOrder.recentFirst:
        sorted.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      case SortOrder.oldestFirst:
        sorted.sort((a, b) => a.completedAt.compareTo(b.completedAt));
      case SortOrder.highestScore:
        sorted.sort((a, b) => b.score.compareTo(a.score));
      case SortOrder.lowestScore:
        sorted.sort((a, b) => a.score.compareTo(b.score));
      case SortOrder.longestDuration:
        sorted.sort((a, b) => b.timeTaken.compareTo(a.timeTaken));
      case SortOrder.shortestDuration:
        sorted.sort((a, b) => a.timeTaken.compareTo(b.timeTaken));
    }

    return sorted;
  }

  /// Apply pagination (offset and limit)
  List<QuizAttempt> _applyPagination(
    List<QuizAttempt> attempts, {
    int? limit,
    int? offset,
  }) {
    var result = attempts;

    if (offset != null && offset > 0) {
      result = result.skip(offset).toList();
    }

    if (limit != null && limit > 0) {
      result = result.take(limit).toList();
    }

    return result;
  }
}
