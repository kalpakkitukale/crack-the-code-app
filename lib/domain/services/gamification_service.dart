/// GamificationService - Manages XP, levels, streaks, and badges
library;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sqflite_mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_desktop;
import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/domain/entities/gamification/badge.dart';
import 'package:streamshaala/domain/entities/gamification/student_gamification.dart';

/// Service for gamification features (XP, levels, streaks, badges)
class GamificationService {
  final DatabaseHelper _dbHelper;
  List<Badge>? _cachedBadges;

  static const String _badgesPath = 'assets/data/gamification/badges.json';

  GamificationService({required DatabaseHelper dbHelper}) : _dbHelper = dbHelper;

  /// Award XP to a student
  Future<XpAwardResult> awardXp({
    required String studentId,
    required XpEventType event,
    int? bonusMultiplier,
    String? entityId,
    String? entityType,
  }) async {
    try {
      final baseXp = event.baseXp;
      final totalXp = baseXp * (bonusMultiplier ?? 1);

      // Get current gamification state
      var state = await getState(studentId);
      state ??= await _initializeState(studentId);

      // Calculate new total and level
      final newTotalXp = state.totalXp + totalXp;
      final newLevel = _calculateLevel(newTotalXp);
      final leveledUp = newLevel > state.level;

      // Check for new badges
      final newBadges = await _checkBadgeUnlocks(studentId, event);

      // Update state
      final updatedState = state.copyWith(
        totalXp: newTotalXp,
        level: newLevel,
        unlockedBadgeIds: [...state.unlockedBadgeIds, ...newBadges],
        updatedAt: DateTime.now(),
      );

      await _saveState(updatedState);

      // Log XP event
      await _logXpEvent(
        studentId: studentId,
        eventType: event,
        xpAwarded: totalXp,
        entityId: entityId,
        entityType: entityType,
      );

      logger.debug(
        'Awarded ${totalXp}XP to $studentId for ${event.displayName}. '
        'Total: $newTotalXp, Level: $newLevel',
      );

      return XpAwardResult(
        xpAwarded: totalXp,
        newTotalXp: newTotalXp,
        newLevel: newLevel,
        leveledUp: leveledUp,
        newBadges: newBadges,
      );
    } catch (e, stackTrace) {
      logger.error('Failed to award XP', e, stackTrace);
      rethrow;
    }
  }

  /// Update streak
  Future<StreakResult> updateStreak(String studentId) async {
    try {
      var state = await getState(studentId);
      state ??= await _initializeState(studentId);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastActive = state.lastActiveDate;

      bool streakIncremented = false;
      bool streakBroken = false;
      int? bonusXp;
      int newStreak = state.currentStreak;
      int newLongestStreak = state.longestStreak;

      if (lastActive == null) {
        // First activity ever
        newStreak = 1;
        streakIncremented = true;
      } else {
        final lastActiveDay = DateTime(
          lastActive.year,
          lastActive.month,
          lastActive.day,
        );
        final daysDifference = today.difference(lastActiveDay).inDays;

        if (daysDifference == 0) {
          // Already active today, no change
        } else if (daysDifference == 1) {
          // Consecutive day, increment streak
          newStreak = state.currentStreak + 1;
          streakIncremented = true;

          // Check for streak milestones
          if (newStreak == 7) {
            bonusXp = XpEventType.weekStreak.baseXp;
          }
        } else {
          // Streak broken
          newStreak = 1;
          streakBroken = state.currentStreak > 0;
          streakIncremented = true; // Starting new streak
        }
      }

      // Update longest streak
      if (newStreak > newLongestStreak) {
        newLongestStreak = newStreak;
      }

      // Update state
      final updatedState = state.copyWith(
        currentStreak: newStreak,
        longestStreak: newLongestStreak,
        lastActiveDate: now,
        updatedAt: now,
      );

      await _saveState(updatedState);

      // Award daily streak XP
      if (streakIncremented) {
        await awardXp(
          studentId: studentId,
          event: XpEventType.dailyStreak,
        );
      }

      // Award week streak bonus
      if (bonusXp != null) {
        await awardXp(
          studentId: studentId,
          event: XpEventType.weekStreak,
        );
      }

      return StreakResult(
        currentStreak: newStreak,
        longestStreak: newLongestStreak,
        streakIncremented: streakIncremented,
        streakBroken: streakBroken,
        bonusXp: bonusXp,
      );
    } catch (e, stackTrace) {
      logger.error('Failed to update streak', e, stackTrace);
      rethrow;
    }
  }

  /// Get gamification state for a student
  Future<StudentGamification?> getState(String studentId) async {
    try {
      final db = await _dbHelper.database;

      List<Map<String, dynamic>> maps;
      if (db is sqflite_mobile.Database) {
        maps = await db.query(
          GamificationTable.tableName,
          where: '${GamificationTable.columnStudentId} = ?',
          whereArgs: [studentId],
          limit: 1,
        );
      } else if (db is sqflite_desktop.Database) {
        maps = await db.query(
          GamificationTable.tableName,
          where: '${GamificationTable.columnStudentId} = ?',
          whereArgs: [studentId],
          limit: 1,
        );
      } else {
        return null;
      }

      if (maps.isEmpty) {
        return null;
      }

      final map = maps.first;
      return StudentGamification(
        id: map['id'] as String,
        studentId: map['student_id'] as String,
        totalXp: map['total_xp'] as int,
        level: map['level'] as int,
        currentStreak: map['current_streak'] as int,
        longestStreak: map['longest_streak'] as int,
        lastActiveDate: map['last_active_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['last_active_date'] as int)
            : null,
        unlockedBadgeIds: (jsonDecode(map['unlocked_badge_ids'] as String) as List)
            .cast<String>(),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      );
    } catch (e, stackTrace) {
      logger.error('Failed to get gamification state', e, stackTrace);
      return null;
    }
  }

  /// Initialize gamification state for a new student
  Future<StudentGamification> _initializeState(String studentId) async {
    final state = StudentGamification(
      id: 'gamification_$studentId',
      studentId: studentId,
      totalXp: 0,
      level: 1,
      currentStreak: 0,
      longestStreak: 0,
      unlockedBadgeIds: [],
      updatedAt: DateTime.now(),
    );

    await _saveState(state);
    return state;
  }

  /// Save gamification state
  Future<void> _saveState(StudentGamification state) async {
    try {
      final db = await _dbHelper.database;

      final map = {
        'id': state.id,
        'student_id': state.studentId,
        'total_xp': state.totalXp,
        'level': state.level,
        'current_streak': state.currentStreak,
        'longest_streak': state.longestStreak,
        'last_active_date': state.lastActiveDate?.millisecondsSinceEpoch,
        'unlocked_badge_ids': jsonEncode(state.unlockedBadgeIds),
        'updated_at': state.updatedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      };

      if (db is sqflite_mobile.Database) {
        await db.insert(
          GamificationTable.tableName,
          map,
          conflictAlgorithm: sqflite_mobile.ConflictAlgorithm.replace,
        );
      } else if (db is sqflite_desktop.Database) {
        await db.insert(
          GamificationTable.tableName,
          map,
          conflictAlgorithm: sqflite_desktop.ConflictAlgorithm.replace,
        );
      }
    } catch (e, stackTrace) {
      logger.error('Failed to save gamification state', e, stackTrace);
      rethrow;
    }
  }

  /// Log XP event
  Future<void> _logXpEvent({
    required String studentId,
    required XpEventType eventType,
    required int xpAwarded,
    String? entityId,
    String? entityType,
  }) async {
    try {
      final db = await _dbHelper.database;

      final map = {
        'id': 'xp_${DateTime.now().millisecondsSinceEpoch}_${studentId.hashCode}',
        'student_id': studentId,
        'event_type': eventType.name,
        'xp_awarded': xpAwarded,
        'entity_id': entityId,
        'entity_type': entityType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      if (db is sqflite_mobile.Database) {
        await db.insert(XpEventsTable.tableName, map);
      } else if (db is sqflite_desktop.Database) {
        await db.insert(XpEventsTable.tableName, map);
      }
    } catch (e, stackTrace) {
      logger.error('Failed to log XP event', e, stackTrace);
    }
  }

  /// Calculate level from XP (level^2 * 100 XP per level)
  int _calculateLevel(int totalXp) {
    // Solve: totalXp = level^2 * 100
    // level = sqrt(totalXp / 100)
    return max(1, (sqrt(totalXp / 100)).floor());
  }

  /// Check and unlock badges
  Future<List<String>> _checkBadgeUnlocks(
    String studentId,
    XpEventType event,
  ) async {
    // Simplified badge checking - in real implementation,
    // we would check all badge conditions against student stats
    final newBadges = <String>[];

    // This is a placeholder - full implementation would query stats
    // and check each badge condition

    return newBadges;
  }

  /// Load all badges from JSON
  Future<List<Badge>> loadBadges() async {
    if (_cachedBadges != null) {
      return _cachedBadges!;
    }

    try {
      final jsonString = await rootBundle.loadString(_badgesPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final badgesList = jsonData['badges'] as List<dynamic>;

      _cachedBadges = badgesList.map((json) {
        final map = json as Map<String, dynamic>;
        return Badge(
          id: map['id'] as String,
          name: map['name'] as String,
          description: map['description'] as String,
          iconPath: map['icon'] as String,
          category: _parseCategory(map['category'] as String? ?? 'learning'),
          condition: _parseCondition(map['condition'] as Map<String, dynamic>),
          xpBonus: map['xpBonus'] as int? ?? 0,
        );
      }).toList();

      return _cachedBadges!;
    } catch (e, stackTrace) {
      logger.error('Failed to load badges', e, stackTrace);
      return [];
    }
  }

  /// Parse badge category from string
  BadgeCategory _parseCategory(String category) {
    switch (category) {
      case 'learning':
        return BadgeCategory.learning;
      case 'streak':
        return BadgeCategory.streak;
      case 'mastery':
        return BadgeCategory.mastery;
      case 'special':
        return BadgeCategory.special;
      default:
        return BadgeCategory.learning;
    }
  }

  /// Parse badge condition from JSON
  BadgeCondition _parseCondition(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'videosWatched':
        return VideosWatchedCondition(json['count'] as int);
      case 'quizzesPassed':
        return QuizzesPassedCondition(json['count'] as int);
      case 'perfectScores':
        return PerfectScoresCondition(json['count'] as int);
      case 'streakDays':
        return StreakDaysCondition(json['days'] as int);
      case 'conceptsMastered':
        return ConceptsMasteredCondition(json['count'] as int);
      case 'gapsFixed':
        return GapsFixedCondition(json['count'] as int);
      case 'reviewsCompleted':
        return ReviewsCompletedCondition(json['count'] as int);
      case 'pathsCompleted':
        return PathsCompletedCondition(json['count'] as int);
      case 'subjectMastered':
        return SubjectMasteredCondition(json['count'] as int);
      case 'consecutiveCheckpoints':
        return ConsecutiveCheckpointsCondition(json['count'] as int);
      case 'earlyMorning':
        return EarlyMorningCondition(json['count'] as int);
      case 'lateNight':
        return LateNightCondition(json['count'] as int);
      default:
        // Default to a simple condition if unknown type
        return VideosWatchedCondition(1);
    }
  }

  /// Get recent XP events
  Future<List<Map<String, dynamic>>> getRecentXpEvents({
    required String studentId,
    int limit = 20,
  }) async {
    try {
      final db = await _dbHelper.database;

      List<Map<String, dynamic>> maps;
      if (db is sqflite_mobile.Database) {
        maps = await db.query(
          XpEventsTable.tableName,
          where: '${XpEventsTable.columnStudentId} = ?',
          whereArgs: [studentId],
          orderBy: '${XpEventsTable.columnTimestamp} DESC',
          limit: limit,
        );
      } else if (db is sqflite_desktop.Database) {
        maps = await db.query(
          XpEventsTable.tableName,
          where: '${XpEventsTable.columnStudentId} = ?',
          whereArgs: [studentId],
          orderBy: '${XpEventsTable.columnTimestamp} DESC',
          limit: limit,
        );
      } else {
        return [];
      }

      return maps;
    } catch (e, stackTrace) {
      logger.error('Failed to get recent XP events', e, stackTrace);
      return [];
    }
  }

  /// Delete all gamification data for a specific profile
  Future<void> deleteAllForProfile(String profileId) async {
    try {
      final db = await _dbHelper.database;

      // Delete gamification state
      if (db is sqflite_mobile.Database) {
        await db.delete(
          GamificationTable.tableName,
          where: '${GamificationTable.columnStudentId} = ?',
          whereArgs: [profileId],
        );
        // Delete XP events
        await db.delete(
          XpEventsTable.tableName,
          where: '${XpEventsTable.columnStudentId} = ?',
          whereArgs: [profileId],
        );
      } else if (db is sqflite_desktop.Database) {
        await db.delete(
          GamificationTable.tableName,
          where: '${GamificationTable.columnStudentId} = ?',
          whereArgs: [profileId],
        );
        // Delete XP events
        await db.delete(
          XpEventsTable.tableName,
          where: '${XpEventsTable.columnStudentId} = ?',
          whereArgs: [profileId],
        );
      }

      logger.debug('All gamification data deleted for profile: $profileId');
    } catch (e, stackTrace) {
      logger.error('Failed to delete gamification data for profile', e, stackTrace);
      rethrow;
    }
  }
}
