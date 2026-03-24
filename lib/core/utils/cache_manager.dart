/// Cache Manager for managing cache expiry
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Manages cache timestamps and expiry for local data
class CacheManager {
  static const String _keyPrefix = 'cache_timestamp_';
  static const Duration defaultCacheExpiry = Duration(hours: 24);

  /// Check if cache for a given key is expired
  static Future<bool> isCacheExpired(
    String cacheKey, {
    Duration? maxAge,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampKey = '$_keyPrefix$cacheKey';
      final cachedAt = prefs.getInt(timestampKey);

      if (cachedAt == null) {
        // No cache timestamp found, consider expired
        return true;
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedAt);
      final expiryDuration = maxAge ?? defaultCacheExpiry;
      final isExpired = DateTime.now().difference(cacheTime) > expiryDuration;

      if (isExpired) {
        logger.debug('Cache expired for: $cacheKey');
      }

      return isExpired;
    } catch (e) {
      logger.warning('Failed to check cache expiry: $e');
      return true; // Treat as expired on error
    }
  }

  /// Mark cache as updated for a given key
  static Future<void> markCacheUpdated(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampKey = '$_keyPrefix$cacheKey';
      await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
      logger.debug('Cache timestamp updated for: $cacheKey');
    } catch (e) {
      logger.warning('Failed to update cache timestamp: $e');
    }
  }

  /// Invalidate cache for a given key
  static Future<void> invalidateCache(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampKey = '$_keyPrefix$cacheKey';
      await prefs.remove(timestampKey);
      logger.debug('Cache invalidated for: $cacheKey');
    } catch (e) {
      logger.warning('Failed to invalidate cache: $e');
    }
  }

  /// Invalidate all study tools cache
  static Future<void> invalidateStudyToolsCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
      for (final key in keys) {
        if (key.contains('notes_') ||
            key.contains('summary_') ||
            key.contains('mindmap_') ||
            key.contains('flashcard_')) {
          await prefs.remove(key);
        }
      }
      logger.info('Study tools cache invalidated');
    } catch (e) {
      logger.warning('Failed to invalidate study tools cache: $e');
    }
  }

  /// Generate cache key for curated notes
  static String curatedNotesKey(String chapterId, String segment) {
    return 'notes_curated_${chapterId}_$segment';
  }

  /// Generate cache key for summaries
  static String summaryKey(String chapterId, String segment) {
    return 'summary_${chapterId}_$segment';
  }

  /// Generate cache key for mind maps
  static String mindMapKey(String chapterId, String segment) {
    return 'mindmap_${chapterId}_$segment';
  }

  /// Generate cache key for flashcards
  static String flashcardsKey(String chapterId, String segment) {
    return 'flashcard_${chapterId}_$segment';
  }
}
