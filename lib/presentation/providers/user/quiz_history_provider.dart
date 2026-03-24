/// Quiz history and statistics provider (PHASE 4)
///
/// Provides access to quiz history, statistics, and analytics data
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_filter.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_statistics.dart';
import 'package:crack_the_code/domain/entities/quiz/subject_statistics.dart';
import 'package:crack_the_code/domain/repositories/quiz_repository.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/presentation/providers/user/user_info_provider.dart';
import 'package:crack_the_code/presentation/providers/auth/user_id_provider.dart';

// ==================== PHASE 4: PROVIDERS ====================

/// Provider for quiz repository access
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return injectionContainer.quizRepository;
});

/// Provider for filtered quiz history with pagination
///
/// Usage:
/// ```dart
/// final history = ref.watch(quizHistoryProvider(
///   filters: QuizFilters(subjectId: 'physics'),
///   limit: 20,
///   offset: 0,
/// ));
/// ```
final quizHistoryProvider = FutureProvider.autoDispose.family<
    List<QuizAttempt>,
    ({QuizFilters? filters, int? limit, int? offset})>((ref, params) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getQuizHistory(
    studentId: studentId,
    filters: params.filters,
    limit: params.limit,
    offset: params.offset,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (history) => history,
  );
});

/// Provider for recent quizzes (convenience provider)
///
/// Usage:
/// ```dart
/// final recentQuizzes = ref.watch(recentQuizzesProvider(10));
/// ```
final recentQuizzesProvider =
    FutureProvider.family<List<QuizAttempt>, int>((ref, limit) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getRecentQuizzes(
    studentId,
    limit: limit,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (quizzes) => quizzes,
  );
});

/// Provider for quiz history count (for pagination)
///
/// Usage:
/// ```dart
/// final totalCount = ref.watch(quizHistoryCountProvider(
///   filters: QuizFilters(subjectId: 'physics'),
/// ));
/// ```
final quizHistoryCountProvider =
    FutureProvider.family<int, QuizFilters?>((ref, filters) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getQuizHistoryCount(
    studentId: studentId,
    filters: filters,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (count) => count,
  );
});

/// Provider for overall quiz statistics
///
/// Uses autoDispose to automatically refresh data when the screen is reopened.
/// This ensures quiz statistics always show the latest data after completing new quizzes.
///
/// Usage:
/// ```dart
/// final stats = ref.watch(quizStatisticsProvider);
/// ```
final quizStatisticsProvider = FutureProvider.autoDispose<QuizStatistics>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getQuizStatistics(studentId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

/// Provider for subject-specific statistics
///
/// Usage:
/// ```dart
/// final subjectStats = ref.watch(subjectStatisticsProvider('physics'));
/// ```
final subjectStatisticsProvider =
    FutureProvider.family<SubjectStatistics, String>((ref, subjectId) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getSubjectStatistics(
    studentId,
    subjectId,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

/// Provider for quiz streak data
///
/// Returns map of dates to quiz counts for calendar visualization
///
/// Usage:
/// ```dart
/// final streakData = ref.watch(quizStreakDataProvider);
/// ```
final quizStreakDataProvider =
    FutureProvider<Map<DateTime, int>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getQuizStreakData(studentId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

/// Provider for score trend data over specified days
///
/// Usage:
/// ```dart
/// final trendData = ref.watch(scoreTrendDataProvider(30)); // Last 30 days
/// ```
final scoreTrendDataProvider =
    FutureProvider.family<Map<String, double>, int>((ref, days) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getScoreTrendData(
    studentId,
    days: days,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

/// Provider for performance comparison across quiz levels
///
/// Usage:
/// ```dart
/// final levelPerformance = ref.watch(performanceByLevelProvider);
/// ```
final performanceByLevelProvider =
    FutureProvider<Map<QuizLevel, double>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);

  // Get student ID from auth provider
  final studentId = ref.read(effectiveUserIdProvider);

  final result = await repository.getPerformanceByLevel(studentId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// ==================== CONVENIENCE PROVIDERS ====================

/// Provider for latest quiz attempt
final latestQuizAttemptProvider = FutureProvider<QuizAttempt?>((ref) async {
  final recentQuizzes = await ref.watch(recentQuizzesProvider(1).future);
  return recentQuizzes.isEmpty ? null : recentQuizzes.first;
});

/// Provider for today's quiz count
final todayQuizCountProvider = FutureProvider<int>((ref) async {
  final streakData = await ref.watch(quizStreakDataProvider.future);
  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);
  return streakData[todayKey] ?? 0;
});

/// Provider for current streak (consecutive days with quizzes)
final currentStreakProvider = FutureProvider<int>((ref) async {
  final streakData = await ref.watch(quizStreakDataProvider.future);

  int streak = 0;
  DateTime currentDate = DateTime.now();

  // Check from today backwards
  while (true) {
    final dateKey = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    if ((streakData[dateKey] ?? 0) > 0) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return streak;
});

/// Provider for average score (last 10 quizzes)
final averageScoreProvider = FutureProvider<double>((ref) async {
  final recentQuizzes = await ref.watch(recentQuizzesProvider(10).future);

  if (recentQuizzes.isEmpty) return 0.0;

  final totalScore = recentQuizzes.fold<double>(
    0.0,
    (sum, quiz) => sum + quiz.score,
  );

  return (totalScore / recentQuizzes.length) * 100; // Convert to percentage
});

/// Provider for pass rate (last 20 quizzes)
final passRateProvider = FutureProvider<double>((ref) async {
  final recentQuizzes = await ref.watch(recentQuizzesProvider(20).future);

  if (recentQuizzes.isEmpty) return 0.0;

  final passedCount = recentQuizzes.where((quiz) => quiz.passed).length;

  return (passedCount / recentQuizzes.length) * 100; // Convert to percentage
});
