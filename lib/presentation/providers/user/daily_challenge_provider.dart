import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';

/// Daily Challenge State
class DailyChallengeState {
  final bool isAvailable;
  final bool isCompleted;
  final int currentStreak;
  final DateTime? lastCompletedDate;
  final DateTime challengeDate;
  final List<Question>? questions;
  final bool isLoading;
  final String? error;

  const DailyChallengeState({
    required this.isAvailable,
    required this.isCompleted,
    required this.currentStreak,
    this.lastCompletedDate,
    required this.challengeDate,
    this.questions,
    this.isLoading = false,
    this.error,
  });

  factory DailyChallengeState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DailyChallengeState(
      isAvailable: false,
      isCompleted: false,
      currentStreak: 0,
      challengeDate: today,
      isLoading: true,
    );
  }

  DailyChallengeState copyWith({
    bool? isAvailable,
    bool? isCompleted,
    int? currentStreak,
    DateTime? lastCompletedDate,
    DateTime? challengeDate,
    List<Question>? questions,
    bool? isLoading,
    String? error,
  }) {
    return DailyChallengeState(
      isAvailable: isAvailable ?? this.isAvailable,
      isCompleted: isCompleted ?? this.isCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      challengeDate: challengeDate ?? this.challengeDate,
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Daily Challenge Provider
/// Manages daily quiz challenges with streak tracking
class DailyChallengeNotifier extends StateNotifier<DailyChallengeState> {
  final DatabaseHelper _db;
  static const int questionsPerChallenge = 5;

  DailyChallengeNotifier(this._db) : super(DailyChallengeState.initial()) {
    _initialize();
  }

  /// Safely update state only if still mounted
  void _safeSetState(DailyChallengeState newState) {
    if (mounted) {
      state = newState;
    }
  }

  Future<void> _initialize() async {
    try {
      logger.info('🎯 Initializing Daily Challenge...');
      await _loadChallengeState();
      if (!mounted) return;
      await _checkAndGenerateChallenge();
    } catch (e, stackTrace) {
      logger.error('Failed to initialize daily challenge', e, stackTrace);
      _safeSetState(state.copyWith(
        isLoading: false,
        error: 'Failed to load daily challenge',
      ));
    }
  }

  @override
  void dispose() {
    logger.debug('🎯 Disposing DailyChallengeNotifier');
    super.dispose();
  }

  /// Load challenge state from database
  Future<void> _loadChallengeState() async {
    try {
      final db = await _db.database;

      // Get last completed date
      final completedResults = await db.query(
        AppStateTable.tableName,
        where: '${AppStateTable.columnKey} = ?',
        whereArgs: ['daily_challenge_last_completed'],
      );

      DateTime? lastCompletedDate;
      if (completedResults.isNotEmpty) {
        final dateStr = completedResults.first[AppStateTable.columnValue] as String;
        lastCompletedDate = DateTime.tryParse(dateStr);
      }

      // Get streak
      final streakResults = await db.query(
        AppStateTable.tableName,
        where: '${AppStateTable.columnKey} = ?',
        whereArgs: ['daily_challenge_streak'],
      );

      int streak = 0;
      if (streakResults.isNotEmpty) {
        streak = int.tryParse(streakResults.first[AppStateTable.columnValue] as String) ?? 0;
      }

      // Check if today's challenge is completed
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastCompleted = lastCompletedDate != null
          ? DateTime(lastCompletedDate.year, lastCompletedDate.month, lastCompletedDate.day)
          : null;

      final isCompletedToday = lastCompleted != null && lastCompleted.isAtSameMomentAs(today);

      state = state.copyWith(
        lastCompletedDate: lastCompletedDate,
        currentStreak: streak,
        isCompleted: isCompletedToday,
        challengeDate: today,
      );

      logger.info('Daily Challenge state loaded: streak=$streak, completed=$isCompletedToday');
    } catch (e, stackTrace) {
      logger.error('Failed to load challenge state', e, stackTrace);
    }
  }

  /// Check and generate today's challenge if needed
  Future<void> _checkAndGenerateChallenge() async {
    try {
      if (state.isCompleted) {
        logger.info('Today\'s challenge already completed');
        state = state.copyWith(
          isAvailable: false,
          isLoading: false,
        );
        return;
      }

      // Generate challenge questions
      final questions = await _generateChallengeQuestions();

      if (questions.isEmpty) {
        logger.warning('No questions available for daily challenge');
        state = state.copyWith(
          isAvailable: false,
          isLoading: false,
          error: 'Not enough questions available. Watch more videos to unlock daily challenges!',
        );
        return;
      }

      state = state.copyWith(
        isAvailable: true,
        questions: questions,
        isLoading: false,
        error: null,
      );

      logger.info('Daily challenge generated with ${questions.length} questions');
    } catch (e, stackTrace) {
      logger.error('Failed to generate challenge', e, stackTrace);
      state = state.copyWith(
        isAvailable: false,
        isLoading: false,
        error: 'Failed to generate challenge',
      );
    }
  }

  /// Generate challenge questions from watched videos
  Future<List<Question>> _generateChallengeQuestions() async {
    try {
      final db = await _db.database;

      // Get watched videos (videos with watch_duration > 0)
      final progressResults = await db.query(
        ProgressTable.tableName,
        where: '${ProgressTable.columnWatchDuration} > ?',
        whereArgs: [0],
        orderBy: '${ProgressTable.columnLastWatched} DESC',
        limit: 50, // Last 50 watched videos
      );

      if (progressResults.isEmpty) {
        logger.info('No watched videos found for daily challenge');
        return [];
      }

      final videoIds = progressResults
          .map((row) => row['video_id'] as String?)
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList();

      logger.info('Found ${videoIds.length} watched videos');

      // Get quizzes for these videos
      List<Map<String, dynamic>> quizResults = await db.query(
        QuestionsOfflineTable.tableName,
        where: '${QuestionsOfflineTable.columnTopicIds} LIKE ?',
        whereArgs: ['%${videoIds.first}%'], // Simplified - in production, would need better filtering
        limit: 100, // Get up to 100 questions
      );

      if (quizResults.isEmpty) {
        // Fallback: Get any available questions
        quizResults = await db.query(
          QuestionsOfflineTable.tableName,
          limit: 100,
        );

        if (quizResults.isEmpty) {
          return [];
        }
      }

      logger.info('Found ${quizResults.length} questions from watched videos');

      // Parse questions
      final allQuestions = quizResults.map((row) {
        return Question(
          id: row[QuestionsOfflineTable.columnId] as String,
          questionText: row[QuestionsOfflineTable.columnQuestionText] as String,
          questionType: _parseQuestionType(row[QuestionsOfflineTable.columnQuestionType] as String),
          options: (row[QuestionsOfflineTable.columnOptions] as String)
              .split('|||')
              .where((s) => s.isNotEmpty)
              .toList(),
          correctAnswer: row[QuestionsOfflineTable.columnCorrectAnswer] as String,
          explanation: row[QuestionsOfflineTable.columnExplanation] as String,
          hints: (row[QuestionsOfflineTable.columnHints] as String)
              .split('|||')
              .where((s) => s.isNotEmpty)
              .toList(),
          difficulty: row[QuestionsOfflineTable.columnDifficulty] as String,
          conceptTags: (row[QuestionsOfflineTable.columnConceptTags] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .toList(),
          topicIds: (row[QuestionsOfflineTable.columnTopicIds] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .toList(),
          points: row[QuestionsOfflineTable.columnPoints] as int? ?? 1,
        );
      }).toList();

      // Randomly select 5 questions
      if (allQuestions.length <= questionsPerChallenge) {
        return allQuestions;
      }

      // Use date-based seed with salt for consistent daily questions
      // Hash-based approach is less predictable than simple date arithmetic
      final now = DateTime.now();
      final dateString = '${now.year}-${now.month}-${now.day}-streamshaala-daily';
      final hashBytes = utf8.encode(dateString);
      final hash = hashBytes.fold<int>(0, (prev, byte) => prev * 31 + byte);
      final seed = hash.abs();
      final random = Random(seed);

      // Shuffle and take first 5
      final shuffled = List<Question>.from(allQuestions);
      shuffled.shuffle(random);

      return shuffled.take(questionsPerChallenge).toList();
    } catch (e, stackTrace) {
      logger.error('Failed to generate challenge questions', e, stackTrace);
      return [];
    }
  }

  /// Parse question type from string
  QuestionType _parseQuestionType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'mcq':
      case 'multiple_choice':
        return QuestionType.mcq;
      case 'true_false':
      case 'truefalse':
        return QuestionType.trueFalse;
      case 'fill_blank':
      case 'fillblank':
        return QuestionType.fillBlank;
      case 'match':
        return QuestionType.match;
      case 'numerical':
        return QuestionType.numerical;
      default:
        return QuestionType.mcq;
    }
  }

  /// Mark challenge as completed and update streak
  Future<void> markAsCompleted() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Calculate new streak
      int newStreak = state.currentStreak;
      if (state.lastCompletedDate != null) {
        final lastCompleted = DateTime(
          state.lastCompletedDate!.year,
          state.lastCompletedDate!.month,
          state.lastCompletedDate!.day,
        );

        final daysSinceLastCompleted = today.difference(lastCompleted).inDays;

        if (daysSinceLastCompleted == 1) {
          // Consecutive day - increment streak
          newStreak++;
        } else if (daysSinceLastCompleted > 1) {
          // Streak broken - reset to 1
          newStreak = 1;
        }
        // If daysSinceLastCompleted == 0, it's the same day (shouldn't happen, but keep current streak)
      } else {
        // First completion
        newStreak = 1;
      }

      // Save to database
      await db.insert(
        AppStateTable.tableName,
        {
          AppStateTable.columnKey: 'daily_challenge_last_completed',
          AppStateTable.columnValue: now.toIso8601String(),
          AppStateTable.columnUpdatedAt: now.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.insert(
        AppStateTable.tableName,
        {
          AppStateTable.columnKey: 'daily_challenge_streak',
          AppStateTable.columnValue: newStreak.toString(),
          AppStateTable.columnUpdatedAt: now.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      logger.info('Daily challenge completed! New streak: $newStreak');

      state = state.copyWith(
        isCompleted: true,
        isAvailable: false,
        currentStreak: newStreak,
        lastCompletedDate: now,
      );
    } catch (e, stackTrace) {
      logger.error('Failed to mark challenge as completed', e, stackTrace);
    }
  }

  /// Refresh challenge state
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _initialize();
  }

  /// Create a quiz session for the daily challenge
  /// For simplicity, we'll just navigate to the quiz taking screen
  /// with a special 'daily_challenge' entity ID
  Future<bool> startChallenge() async {
    try {
      if (state.questions == null || state.questions!.isEmpty) {
        logger.warning('No questions available for daily challenge');
        return false;
      }

      logger.info('Starting daily challenge with ${state.questions!.length} questions');

      // The quiz will be created by the quiz repository when the user navigates to the quiz screen
      // For now, just return true to indicate the challenge is ready
      return true;
    } catch (e, stackTrace) {
      logger.error('Failed to start challenge', e, stackTrace);
      return false;
    }
  }
}

/// Daily Challenge Provider
final dailyChallengeProvider =
    StateNotifierProvider<DailyChallengeNotifier, DailyChallengeState>((ref) {
  return DailyChallengeNotifier(DatabaseHelper());
});
