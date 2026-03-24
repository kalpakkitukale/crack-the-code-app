/// Quiz Statistics Calculator Service
///
/// Extracts statistics calculation logic from QuizRepositoryImpl to reduce
/// file size and improve maintainability. Handles all score aggregation,
/// streak calculation, and performance analysis.
library;

import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_statistics.dart';
import 'package:crack_the_code/domain/entities/quiz/subject_statistics.dart';

/// Standard passing score threshold (60%)
const double kPassingScoreThreshold = 0.6;

/// Score threshold for weak topics (below 60%)
const double kWeakTopicThreshold = 60.0;

/// Score threshold for strong topics (80% and above)
const double kStrongTopicThreshold = 80.0;

/// Service for calculating quiz statistics and performance metrics
class QuizStatisticsCalculator {
  /// Calculate comprehensive quiz statistics from attempts
  QuizStatistics calculateQuizStatistics({
    required List<QuizAttempt> attempts,
    required Map<DateTime, int> streakData,
  }) {
    if (attempts.isEmpty) {
      return _emptyStatistics();
    }

    // Calculate basic statistics
    final totalAttempts = attempts.length;
    final scores = attempts.map((a) => a.score * 100).toList();
    final averageScore = scores.reduce((a, b) => a + b) / scores.length;
    final bestScore = scores.reduce((a, b) => a > b ? a : b).toInt();

    // Calculate time spent
    final totalSeconds = attempts.map((a) => a.timeTaken).reduce((a, b) => a + b);
    final totalTimeSpent = Duration(seconds: totalSeconds);

    // Calculate streak data
    final currentStreak = calculateCurrentStreak(streakData);
    final longestStreak = calculateLongestStreak(streakData);

    // Calculate pass/fail counts based on scores (60% passing score)
    final passedCount = attempts.where((a) => a.score >= kPassingScoreThreshold).length;
    final failedCount = totalAttempts - passedCount;

    // Count perfect scores
    final perfectScoreCount = attempts.where((a) => a.score >= 1.0).length;

    // Get most recent quiz date
    final lastQuizDate = attempts.isNotEmpty
        ? attempts.map((a) => a.completedAt).reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    // Calculate subject breakdown and topic analysis
    final analysisResult = _analyzeSubjectsAndTopics(attempts);

    final statistics = QuizStatistics(
      totalAttempts: totalAttempts,
      averageScore: averageScore,
      currentStreak: currentStreak,
      totalTimeSpent: totalTimeSpent,
      subjectBreakdown: analysisResult.subjectBreakdown,
      weakTopics: analysisResult.weakTopics,
      strongTopics: analysisResult.strongTopics,
      lastQuizDate: lastQuizDate,
      bestScore: bestScore,
      perfectScoreCount: perfectScoreCount,
      totalPassed: passedCount,
      totalFailed: failedCount,
      longestStreak: longestStreak,
    );

    logger.info('Calculated quiz statistics: ${statistics.totalAttempts} attempts');
    return statistics;
  }

  /// Calculate statistics for a specific subject
  SubjectStatistics calculateSubjectStatistics({
    required String subjectId,
    required List<QuizAttempt> attempts,
  }) {
    if (attempts.isEmpty) {
      final formattedSubjectName = formatSubjectName(subjectId);
      return SubjectStatistics(
        subjectId: subjectId,
        subjectName: formattedSubjectName,
        totalAttempts: 0,
        averageScore: 0.0,
        bestScore: 0,
        totalTimeSpent: const Duration(),
        topicsAttempted: [],
        topicPerformance: {},
        worstScore: 0,
        totalPassed: 0,
        totalFailed: 0,
      );
    }

    final scores = attempts.map((a) => a.score * 100).toList();

    // Calculate pass/fail counts based on scores
    final passedCount = attempts.where((a) => a.score >= kPassingScoreThreshold).length;
    final failedCount = attempts.length - passedCount;
    final totalSeconds = attempts.map((a) => a.timeTaken).reduce((a, b) => a + b);
    final bestScore = scores.reduce((a, b) => a > b ? a : b).toInt();
    final worstScore = scores.reduce((a, b) => a < b ? a : b).toInt();
    final averageScore = scores.reduce((a, b) => a + b) / scores.length;

    // Get most recent attempt date
    final lastAttemptDate = attempts.isNotEmpty
        ? attempts.map((a) => a.completedAt).reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    // Count perfect scores
    final perfectScoreCount = attempts.where((a) => a.score >= 1.0).length;

    // Calculate average time per quiz in seconds
    final averageTimeSeconds = (totalSeconds / attempts.length).round();

    // Get subject name from attempt metadata or format from ID
    final subjectName = attempts
            .map((a) => a.subjectName)
            .firstWhere((name) => name != null && name.isNotEmpty, orElse: () => null) ??
        formatSubjectName(subjectId);

    return SubjectStatistics(
      subjectId: subjectId,
      subjectName: subjectName,
      totalAttempts: attempts.length,
      averageScore: averageScore,
      bestScore: bestScore,
      totalTimeSpent: Duration(seconds: totalSeconds),
      topicsAttempted: [], // TODO: Implement from quiz metadata
      topicPerformance: {}, // TODO: Implement from quiz metadata
      lastAttemptDate: lastAttemptDate,
      worstScore: worstScore,
      totalPassed: passedCount,
      totalFailed: failedCount,
      perfectScoreCount: perfectScoreCount,
      averageTimeSeconds: averageTimeSeconds,
    );
  }

  /// Calculate score trend data grouped by date
  Map<String, double> calculateScoreTrend({
    required List<QuizAttempt> attempts,
    required int days,
  }) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    // Filter attempts within date range
    final recentAttempts = attempts.where((a) => a.completedAt.isAfter(startDate)).toList();

    // Group by date and calculate average scores
    final dateScores = <String, List<double>>{};

    for (final attempt in recentAttempts) {
      // Validate attempt score before processing
      if (attempt.score < 0 || attempt.score > 1 || !attempt.score.isFinite) {
        logger.warning('Invalid attempt score: ${attempt.score}, skipping');
        continue;
      }

      final dateKey = '${attempt.completedAt.year}-'
          '${attempt.completedAt.month.toString().padLeft(2, '0')}-'
          '${attempt.completedAt.day.toString().padLeft(2, '0')}';

      if (!dateScores.containsKey(dateKey)) {
        dateScores[dateKey] = [];
      }
      dateScores[dateKey]!.add(attempt.score * 100);
    }

    // Calculate averages with validation
    final trendData = <String, double>{};
    dateScores.forEach((date, scores) {
      if (scores.isEmpty) return;

      final average = scores.reduce((a, b) => a + b) / scores.length;

      // Only add if average is valid
      if (average.isFinite && average >= 0 && average <= 100) {
        trendData[date] = average;
      }
    });

    return trendData;
  }

  /// Calculate performance breakdown by quiz level
  Map<QuizLevel, double> calculatePerformanceByLevel({
    required List<QuizAttempt> attempts,
    required Map<String, Quiz> quizCache,
  }) {
    final levelScores = <QuizLevel, List<double>>{};

    // Group attempts by quiz level
    for (final attempt in attempts) {
      final quiz = quizCache[attempt.quizId];
      if (quiz == null) continue;

      if (!levelScores.containsKey(quiz.level)) {
        levelScores[quiz.level] = [];
      }
      levelScores[quiz.level]!.add(attempt.score * 100);
    }

    // Calculate averages
    final performanceMap = <QuizLevel, double>{};
    levelScores.forEach((level, scores) {
      performanceMap[level] = scores.reduce((a, b) => a + b) / scores.length;
    });

    return performanceMap;
  }

  /// Build streak data map from attempts
  Map<DateTime, int> buildStreakMap(List<QuizAttempt> attempts) {
    final streakMap = <DateTime, int>{};

    for (final attempt in attempts) {
      // Normalize to date only (midnight)
      final date = DateTime(
        attempt.completedAt.year,
        attempt.completedAt.month,
        attempt.completedAt.day,
      );

      streakMap[date] = (streakMap[date] ?? 0) + 1;
    }

    return streakMap;
  }

  /// Calculate current streak (consecutive days up to today)
  int calculateCurrentStreak(Map<DateTime, int> streakData) {
    if (streakData.isEmpty) return 0;

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    var streak = 0;
    var checkDate = todayNormalized;

    while (streakData.containsKey(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Calculate longest streak (maximum consecutive days)
  int calculateLongestStreak(Map<DateTime, int> streakData) {
    if (streakData.isEmpty) return 0;

    final sortedDates = streakData.keys.toList()..sort();

    var maxStreak = 1;
    var currentStreak = 1;

    for (var i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;

      if (diff == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
    }

    return maxStreak;
  }

  /// Format subject name from ID
  /// Converts IDs like "mathematics", "science_physics" to readable names
  String formatSubjectName(String subjectId) {
    // Handle common patterns
    final formatted = subjectId
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' ')
        .trim();

    return formatted.isNotEmpty ? formatted : subjectId;
  }

  /// Create empty statistics for students with no attempts
  QuizStatistics _emptyStatistics() {
    return QuizStatistics(
      totalAttempts: 0,
      averageScore: 0.0,
      currentStreak: 0,
      totalTimeSpent: const Duration(),
      subjectBreakdown: {},
      weakTopics: [],
      strongTopics: [],
      bestScore: 0,
      totalPassed: 0,
      totalFailed: 0,
      longestStreak: 0,
    );
  }

  /// Analyze attempts to extract subject breakdown and topic performance
  _SubjectTopicAnalysis _analyzeSubjectsAndTopics(List<QuizAttempt> attempts) {
    final subjectBreakdown = <String, SubjectStatistics>{};
    final topicScores = <String, List<double>>{};

    // Group attempts by subject
    final subjectGroups = <String, List<QuizAttempt>>{};
    for (final attempt in attempts) {
      // Use subject_id as key if available, otherwise use subject_name
      final subjectKey = attempt.subjectId ?? attempt.subjectName;
      if (subjectKey != null && subjectKey.isNotEmpty) {
        subjectGroups.putIfAbsent(subjectKey, () => []).add(attempt);

        // Also track topic scores for weak/strong topic identification
        if (attempt.topicName != null && attempt.topicName!.isNotEmpty) {
          final topicKey = attempt.topicName!;
          topicScores.putIfAbsent(topicKey, () => []).add(attempt.score * 100);
        }
      }
    }

    // Calculate statistics for each subject
    for (final entry in subjectGroups.entries) {
      final subjectKey = entry.key;
      final subjectAttempts = entry.value;

      if (subjectAttempts.isEmpty) continue;

      // Get subject name from first attempt
      final subjectName = subjectAttempts.first.subjectName ?? subjectKey;
      final subjectId = subjectAttempts.first.subjectId ?? subjectKey;

      // Calculate subject statistics
      final subjectScores = subjectAttempts.map((a) => a.score * 100).toList();
      final subjectAverage = subjectScores.reduce((a, b) => a + b) / subjectScores.length;
      final subjectBest = subjectScores.reduce((a, b) => a > b ? a : b).toInt();
      final subjectWorst = subjectScores.reduce((a, b) => a < b ? a : b).toInt();
      // Calculate passed/failed using score-based approach (60% passing score)
      final subjectPassed =
          subjectAttempts.where((a) => a.score >= kPassingScoreThreshold).length;
      final subjectFailed = subjectAttempts.length - subjectPassed;
      final subjectPerfect = subjectAttempts.where((a) => a.score >= 1.0).length;
      final subjectTotalTime = subjectAttempts.map((a) => a.timeTaken).reduce((a, b) => a + b);
      final subjectAvgTime = (subjectTotalTime / subjectAttempts.length).round();
      final subjectLastDate =
          subjectAttempts.map((a) => a.completedAt).reduce((a, b) => a.isAfter(b) ? a : b);

      // Calculate topic performance for this subject
      final topicPerformance = <String, List<double>>{};
      final topicsAttempted = <String>[];

      for (final attempt in subjectAttempts) {
        if (attempt.topicName != null && attempt.topicName!.isNotEmpty) {
          final topicKey = attempt.topicName!;
          if (!topicsAttempted.contains(topicKey)) {
            topicsAttempted.add(topicKey);
          }
          topicPerformance.putIfAbsent(topicKey, () => []).add(attempt.score * 100);
        }
      }

      // Average topic scores
      final topicAvg = <String, double>{};
      topicPerformance.forEach((topic, scores) {
        topicAvg[topic] = scores.reduce((a, b) => a + b) / scores.length;
      });

      subjectBreakdown[subjectKey] = SubjectStatistics(
        subjectId: subjectId,
        subjectName: subjectName,
        totalAttempts: subjectAttempts.length,
        averageScore: subjectAverage,
        bestScore: subjectBest,
        worstScore: subjectWorst,
        totalTimeSpent: Duration(seconds: subjectTotalTime),
        totalPassed: subjectPassed,
        totalFailed: subjectFailed,
        perfectScoreCount: subjectPerfect,
        averageTimeSeconds: subjectAvgTime,
        lastAttemptDate: subjectLastDate,
        topicsAttempted: topicsAttempted,
        topicPerformance: topicAvg,
      );
    }

    // Calculate weak and strong topics across all subjects
    final weakTopics = <String>[];
    final strongTopics = <String>[];

    topicScores.forEach((topicName, scores) {
      final avgScore = scores.reduce((a, b) => a + b) / scores.length;
      if (avgScore < kWeakTopicThreshold) {
        weakTopics.add(topicName);
      } else if (avgScore >= kStrongTopicThreshold) {
        strongTopics.add(topicName);
      }
    });

    return _SubjectTopicAnalysis(
      subjectBreakdown: subjectBreakdown,
      weakTopics: weakTopics,
      strongTopics: strongTopics,
    );
  }
}

/// Internal class to hold subject and topic analysis results
class _SubjectTopicAnalysis {
  final Map<String, SubjectStatistics> subjectBreakdown;
  final List<String> weakTopics;
  final List<String> strongTopics;

  _SubjectTopicAnalysis({
    required this.subjectBreakdown,
    required this.weakTopics,
    required this.strongTopics,
  });
}
