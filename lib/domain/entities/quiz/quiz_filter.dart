/// Quiz filtering and sorting options for quiz history queries
///
/// This file provides comprehensive filtering and sorting capabilities
/// for querying quiz history and statistics.
library;

import 'quiz.dart';

/// Date range filter options
enum DateRange {
  today,       // Only today's quizzes
  thisWeek,    // Last 7 days
  thisMonth,   // Last 30 days
  last3Months, // Last 90 days
  thisYear,    // Current calendar year
  allTime,     // No date restriction
}

/// Performance filter options based on pass/fail status
enum PerformanceFilter {
  all,     // All quizzes regardless of pass/fail
  passed,  // Only passed quizzes
  failed,  // Only failed quizzes
}

/// Sort order options for quiz history
enum SortOrder {
  recentFirst,      // Newest to oldest (default)
  oldestFirst,      // Oldest to newest
  highestScore,     // Highest score to lowest
  lowestScore,      // Lowest score to highest
  longestDuration,  // Longest time taken to shortest
  shortestDuration, // Shortest time taken to longest
}

/// Comprehensive filter configuration for quiz queries
class QuizFilters {
  /// Filter by specific subject IDs (null = all subjects)
  final List<String>? subjectIds;

  /// Filter by quiz levels (null = all levels)
  final List<QuizLevel>? levels;

  /// Date range for filtering quizzes
  final DateRange dateRange;

  /// Performance filter (all/passed/failed)
  final PerformanceFilter performanceFilter;

  /// Sort order for results
  final SortOrder sortOrder;

  /// Minimum score threshold (0-100, null = no minimum)
  final int? minScore;

  /// Maximum score threshold (0-100, null = no maximum)
  final int? maxScore;

  /// Filter by specific topic IDs (null = all topics)
  final List<String>? topicIds;

  /// Filter by specific chapter IDs (null = all chapters)
  final List<String>? chapterIds;

  const QuizFilters({
    this.subjectIds,
    this.levels,
    this.dateRange = DateRange.allTime,
    this.performanceFilter = PerformanceFilter.all,
    this.sortOrder = SortOrder.recentFirst,
    this.minScore,
    this.maxScore,
    this.topicIds,
    this.chapterIds,
  });

  /// Create a copy with modified filters
  QuizFilters copyWith({
    List<String>? subjectIds,
    List<QuizLevel>? levels,
    DateRange? dateRange,
    PerformanceFilter? performanceFilter,
    SortOrder? sortOrder,
    int? minScore,
    int? maxScore,
    List<String>? topicIds,
    List<String>? chapterIds,
    bool clearSubjectIds = false,
    bool clearLevels = false,
    bool clearMinScore = false,
    bool clearMaxScore = false,
    bool clearTopicIds = false,
    bool clearChapterIds = false,
  }) {
    return QuizFilters(
      subjectIds: clearSubjectIds ? null : subjectIds ?? this.subjectIds,
      levels: clearLevels ? null : levels ?? this.levels,
      dateRange: dateRange ?? this.dateRange,
      performanceFilter: performanceFilter ?? this.performanceFilter,
      sortOrder: sortOrder ?? this.sortOrder,
      minScore: clearMinScore ? null : minScore ?? this.minScore,
      maxScore: clearMaxScore ? null : maxScore ?? this.maxScore,
      topicIds: clearTopicIds ? null : topicIds ?? this.topicIds,
      chapterIds: clearChapterIds ? null : chapterIds ?? this.chapterIds,
    );
  }

  /// Check if any filters are active (excluding dateRange and sortOrder)
  bool get hasActiveFilters {
    return subjectIds != null ||
        levels != null ||
        dateRange != DateRange.allTime ||
        performanceFilter != PerformanceFilter.all ||
        minScore != null ||
        maxScore != null ||
        topicIds != null ||
        chapterIds != null;
  }

  /// Get the start date for the date range filter
  DateTime? getStartDate() {
    final now = DateTime.now();

    switch (dateRange) {
      case DateRange.today:
        return DateTime(now.year, now.month, now.day);
      case DateRange.thisWeek:
        return now.subtract(const Duration(days: 7));
      case DateRange.thisMonth:
        return now.subtract(const Duration(days: 30));
      case DateRange.last3Months:
        return now.subtract(const Duration(days: 90));
      case DateRange.thisYear:
        return DateTime(now.year, 1, 1);
      case DateRange.allTime:
        return null;
    }
  }

  /// Get SQL WHERE clause components for this filter
  /// Returns a map with 'where' clause and 'whereArgs' list
  Map<String, dynamic> toSqlComponents() {
    final conditions = <String>[];
    final args = <dynamic>[];

    // Date range filter
    final startDate = getStartDate();
    if (startDate != null) {
      conditions.add('completed_at >= ?');
      args.add(startDate.millisecondsSinceEpoch);
    }

    // Performance filter
    if (performanceFilter == PerformanceFilter.passed) {
      conditions.add('passed = 1');
    } else if (performanceFilter == PerformanceFilter.failed) {
      conditions.add('passed = 0');
    }

    // Score range filters
    if (minScore != null) {
      conditions.add('score_percentage >= ?');
      args.add(minScore! / 100.0); // Convert to 0-1 range
    }
    if (maxScore != null) {
      conditions.add('score_percentage <= ?');
      args.add(maxScore! / 100.0); // Convert to 0-1 range
    }

    // Subject filter
    if (subjectIds != null && subjectIds!.isNotEmpty) {
      final placeholders = List.filled(subjectIds!.length, '?').join(',');
      conditions.add('subject_id IN ($placeholders)');
      args.addAll(subjectIds!);
    }

    // Level filter
    if (levels != null && levels!.isNotEmpty) {
      final placeholders = List.filled(levels!.length, '?').join(',');
      conditions.add('quiz_level IN ($placeholders)');
      args.addAll(levels!.map((l) => l.toString().split('.').last));
    }

    // Topic filter (requires JSON query - implementation depends on database)
    if (topicIds != null && topicIds!.isNotEmpty) {
      // This would need a more complex JSON query in SQL
      // For now, this will be handled in the application layer
    }

    // Chapter filter
    if (chapterIds != null && chapterIds!.isNotEmpty) {
      final placeholders = List.filled(chapterIds!.length, '?').join(',');
      conditions.add('chapter_id IN ($placeholders)');
      args.addAll(chapterIds!);
    }

    return {
      'where': conditions.isEmpty ? null : conditions.join(' AND '),
      'whereArgs': args.isEmpty ? null : args,
    };
  }

  /// Get SQL ORDER BY clause for this filter
  String getOrderByClause() {
    switch (sortOrder) {
      case SortOrder.recentFirst:
        return 'completed_at DESC';
      case SortOrder.oldestFirst:
        return 'completed_at ASC';
      case SortOrder.highestScore:
        return 'score_percentage DESC';
      case SortOrder.lowestScore:
        return 'score_percentage ASC';
      case SortOrder.longestDuration:
        return 'time_taken DESC';
      case SortOrder.shortestDuration:
        return 'time_taken ASC';
    }
  }

  /// Get a display summary of active filters
  String getFilterSummary() {
    final parts = <String>[];

    if (dateRange != DateRange.allTime) {
      parts.add(_dateRangeDisplay(dateRange));
    }

    if (performanceFilter != PerformanceFilter.all) {
      parts.add(performanceFilter == PerformanceFilter.passed
          ? 'Passed only'
          : 'Failed only');
    }

    if (subjectIds != null && subjectIds!.isNotEmpty) {
      parts.add('${subjectIds!.length} subject${subjectIds!.length > 1 ? 's' : ''}');
    }

    if (levels != null && levels!.isNotEmpty) {
      parts.add('${levels!.length} level${levels!.length > 1 ? 's' : ''}');
    }

    if (minScore != null || maxScore != null) {
      if (minScore != null && maxScore != null) {
        parts.add('Score: $minScore-$maxScore%');
      } else if (minScore != null) {
        parts.add('Score: $minScore%+');
      } else {
        parts.add('Score: up to $maxScore%');
      }
    }

    return parts.isEmpty ? 'No filters' : parts.join(' • ');
  }

  String _dateRangeDisplay(DateRange range) {
    switch (range) {
      case DateRange.today:
        return 'Today';
      case DateRange.thisWeek:
        return 'This week';
      case DateRange.thisMonth:
        return 'This month';
      case DateRange.last3Months:
        return 'Last 3 months';
      case DateRange.thisYear:
        return 'This year';
      case DateRange.allTime:
        return 'All time';
    }
  }

  @override
  String toString() {
    return 'QuizFilters('
        'subjects: ${subjectIds?.length ?? 'all'}, '
        'levels: ${levels?.length ?? 'all'}, '
        'dateRange: $dateRange, '
        'performance: $performanceFilter, '
        'sortOrder: $sortOrder'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuizFilters &&
        _listEquals(other.subjectIds, subjectIds) &&
        _listEquals(other.levels, levels) &&
        other.dateRange == dateRange &&
        other.performanceFilter == performanceFilter &&
        other.sortOrder == sortOrder &&
        other.minScore == minScore &&
        other.maxScore == maxScore &&
        _listEquals(other.topicIds, topicIds) &&
        _listEquals(other.chapterIds, chapterIds);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(subjectIds ?? []),
      Object.hashAll(levels ?? []),
      dateRange,
      performanceFilter,
      sortOrder,
      minScore,
      maxScore,
      Object.hashAll(topicIds ?? []),
      Object.hashAll(chapterIds ?? []),
    );
  }
}
