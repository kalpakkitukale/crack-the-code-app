/// Flashcard study statistics provider for streak and progress tracking
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'flashcard_stats_provider.g.dart';

/// Keys for SharedPreferences storage
class _StudyStatsKeys {
  static const currentStreak = 'flashcard_current_streak';
  static const bestStreak = 'flashcard_best_streak';
  static const cardsStudiedToday = 'flashcard_cards_today';
  static const totalCardsStudied = 'flashcard_total_cards';
  static const lastStudyDate = 'flashcard_last_study_date';
  static const todayCorrect = 'flashcard_today_correct';
  static const todayIncorrect = 'flashcard_today_incorrect';
}

/// Study statistics data class
class FlashcardStudyStats {
  final int currentStreak;
  final int bestStreak;
  final int cardsStudiedToday;
  final int totalCardsStudied;
  final DateTime? lastStudyDate;
  final int todayCorrect;
  final int todayIncorrect;

  const FlashcardStudyStats({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.cardsStudiedToday = 0,
    this.totalCardsStudied = 0,
    this.lastStudyDate,
    this.todayCorrect = 0,
    this.todayIncorrect = 0,
  });

  /// Get today's accuracy percentage
  int get todayAccuracy {
    final total = todayCorrect + todayIncorrect;
    if (total == 0) return 0;
    return ((todayCorrect / total) * 100).round();
  }

  /// Check if studied today
  bool get hasStudiedToday {
    if (lastStudyDate == null) return false;
    final now = DateTime.now();
    return lastStudyDate!.year == now.year &&
        lastStudyDate!.month == now.month &&
        lastStudyDate!.day == now.day;
  }

  /// Copy with new values
  FlashcardStudyStats copyWith({
    int? currentStreak,
    int? bestStreak,
    int? cardsStudiedToday,
    int? totalCardsStudied,
    DateTime? lastStudyDate,
    int? todayCorrect,
    int? todayIncorrect,
  }) {
    return FlashcardStudyStats(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      cardsStudiedToday: cardsStudiedToday ?? this.cardsStudiedToday,
      totalCardsStudied: totalCardsStudied ?? this.totalCardsStudied,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      todayCorrect: todayCorrect ?? this.todayCorrect,
      todayIncorrect: todayIncorrect ?? this.todayIncorrect,
    );
  }
}

/// Provider for flashcard study statistics
@riverpod
class FlashcardStats extends _$FlashcardStats {
  @override
  Future<FlashcardStudyStats> build() async {
    return _loadStats();
  }

  /// Load stats from SharedPreferences
  Future<FlashcardStudyStats> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();

    final lastStudyDateStr = prefs.getString(_StudyStatsKeys.lastStudyDate);
    DateTime? lastStudyDate;
    if (lastStudyDateStr != null) {
      lastStudyDate = DateTime.tryParse(lastStudyDateStr);
    }

    var stats = FlashcardStudyStats(
      currentStreak: prefs.getInt(_StudyStatsKeys.currentStreak) ?? 0,
      bestStreak: prefs.getInt(_StudyStatsKeys.bestStreak) ?? 0,
      cardsStudiedToday: prefs.getInt(_StudyStatsKeys.cardsStudiedToday) ?? 0,
      totalCardsStudied: prefs.getInt(_StudyStatsKeys.totalCardsStudied) ?? 0,
      lastStudyDate: lastStudyDate,
      todayCorrect: prefs.getInt(_StudyStatsKeys.todayCorrect) ?? 0,
      todayIncorrect: prefs.getInt(_StudyStatsKeys.todayIncorrect) ?? 0,
    );

    // Reset today's stats if it's a new day
    if (lastStudyDate != null && !stats.hasStudiedToday) {
      // Check if streak should be broken (missed more than 1 day)
      final daysSinceLastStudy =
          DateTime.now().difference(lastStudyDate).inDays;
      if (daysSinceLastStudy > 1) {
        // Streak broken
        stats = stats.copyWith(
          currentStreak: 0,
          cardsStudiedToday: 0,
          todayCorrect: 0,
          todayIncorrect: 0,
        );
        await _saveStats(stats);
      } else {
        // Just reset daily counts
        stats = stats.copyWith(
          cardsStudiedToday: 0,
          todayCorrect: 0,
          todayIncorrect: 0,
        );
      }
    }

    return stats;
  }

  /// Save stats to SharedPreferences
  Future<void> _saveStats(FlashcardStudyStats stats) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_StudyStatsKeys.currentStreak, stats.currentStreak);
    await prefs.setInt(_StudyStatsKeys.bestStreak, stats.bestStreak);
    await prefs.setInt(
        _StudyStatsKeys.cardsStudiedToday, stats.cardsStudiedToday);
    await prefs.setInt(
        _StudyStatsKeys.totalCardsStudied, stats.totalCardsStudied);
    await prefs.setInt(_StudyStatsKeys.todayCorrect, stats.todayCorrect);
    await prefs.setInt(_StudyStatsKeys.todayIncorrect, stats.todayIncorrect);

    if (stats.lastStudyDate != null) {
      await prefs.setString(
        _StudyStatsKeys.lastStudyDate,
        stats.lastStudyDate!.toIso8601String(),
      );
    }
  }

  /// Record a study session
  Future<void> recordStudySession({
    required int correct,
    required int incorrect,
  }) async {
    final currentStats = await future;
    final now = DateTime.now();
    final totalCards = correct + incorrect;

    // Check if this is a new day
    final isNewDay = !currentStats.hasStudiedToday;

    // Calculate new streak
    int newStreak = currentStats.currentStreak;
    if (isNewDay) {
      // Check if last study was yesterday or if streak was broken
      if (currentStats.lastStudyDate != null) {
        final daysSinceLastStudy =
            now.difference(currentStats.lastStudyDate!).inDays;
        if (daysSinceLastStudy == 1) {
          // Consecutive day, increment streak
          newStreak = currentStats.currentStreak + 1;
        } else if (daysSinceLastStudy > 1) {
          // Streak broken, start fresh
          newStreak = 1;
        } else {
          // Same day (shouldn't happen since isNewDay is true)
          newStreak = currentStats.currentStreak;
        }
      } else {
        // First time studying
        newStreak = 1;
      }
    }

    // Update best streak
    final newBestStreak =
        newStreak > currentStats.bestStreak ? newStreak : currentStats.bestStreak;

    // Calculate new stats
    final newStats = FlashcardStudyStats(
      currentStreak: newStreak,
      bestStreak: newBestStreak,
      cardsStudiedToday: currentStats.cardsStudiedToday + totalCards,
      totalCardsStudied: currentStats.totalCardsStudied + totalCards,
      lastStudyDate: now,
      todayCorrect: currentStats.todayCorrect + correct,
      todayIncorrect: currentStats.todayIncorrect + incorrect,
    );

    // Save and update state
    await _saveStats(newStats);
    state = AsyncValue.data(newStats);
  }

  /// Reset all statistics
  Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_StudyStatsKeys.currentStreak);
    await prefs.remove(_StudyStatsKeys.bestStreak);
    await prefs.remove(_StudyStatsKeys.cardsStudiedToday);
    await prefs.remove(_StudyStatsKeys.totalCardsStudied);
    await prefs.remove(_StudyStatsKeys.lastStudyDate);
    await prefs.remove(_StudyStatsKeys.todayCorrect);
    await prefs.remove(_StudyStatsKeys.todayIncorrect);

    state = const AsyncValue.data(FlashcardStudyStats());
  }
}
