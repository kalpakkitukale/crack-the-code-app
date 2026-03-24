/// Quiz Retry Queue Service
/// Manages failed quiz attempts for later persistence
library;

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/models/quiz/quiz_attempt_model.dart';

/// Queue for retrying failed quiz attempt saves
class QuizRetryQueue {
  static const String _queueKey = 'quiz_retry_queue';
  static const int _maxRetries = 5;
  static const int _maxQueueSize = 20;

  /// Lock to prevent race conditions when modifying the queue
  static Completer<void>? _lock;

  /// Acquire the lock - waits if another operation is in progress
  static Future<void> _acquireLock() async {
    while (_lock != null) {
      await _lock!.future;
    }
    _lock = Completer<void>();
  }

  /// Release the lock
  static void _releaseLock() {
    final completer = _lock;
    _lock = null;
    completer?.complete();
  }

  /// Add a failed attempt to the retry queue
  static Future<void> enqueue(QuizAttemptModel attempt) async {
    await _acquireLock();
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];

      // Create queue entry with metadata
      final entry = {
        'attempt': attempt.toMap(),
        'addedAt': DateTime.now().toIso8601String(),
        'retryCount': 0,
      };

      queueJson.add(jsonEncode(entry));

      // Keep queue size manageable
      if (queueJson.length > _maxQueueSize) {
        queueJson.removeAt(0); // Remove oldest
        logger.warning('Quiz retry queue exceeded max size, removed oldest entry');
      }

      await prefs.setStringList(_queueKey, queueJson);
      logger.info('Added quiz attempt to retry queue. Queue size: ${queueJson.length}');
    } catch (e, stackTrace) {
      logger.error('Failed to add to retry queue', e, stackTrace);
    } finally {
      _releaseLock();
    }
  }

  /// Get all pending attempts from the queue (internal use)
  static Future<List<_QueueEntry>> _getPendingAttempts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];

      final entries = <_QueueEntry>[];
      for (final json in queueJson) {
        try {
          final data = jsonDecode(json) as Map<String, dynamic>;
          entries.add(_QueueEntry.fromJson(data));
        } catch (e) {
          logger.warning('Failed to parse queue entry: $e');
        }
      }

      return entries;
    } catch (e, stackTrace) {
      logger.error('Failed to get pending attempts', e, stackTrace);
      return [];
    }
  }

  /// Process the retry queue with a save function
  /// Returns number of successfully processed attempts
  static Future<int> processQueue(
    Future<bool> Function(QuizAttemptModel attempt) saveFunction,
  ) async {
    await _acquireLock();
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];

      if (queueJson.isEmpty) {
        return 0;
      }

      logger.info('Processing quiz retry queue: ${queueJson.length} items');

      final remainingEntries = <String>[];
      int successCount = 0;

      for (final json in queueJson) {
        try {
          final data = jsonDecode(json) as Map<String, dynamic>;
          final entry = _QueueEntry.fromJson(data);

          // Skip if max retries reached
          if (entry.retryCount >= _maxRetries) {
            logger.warning('Max retries reached for attempt ${entry.attempt.id}, removing from queue');
            continue;
          }

          // Try to save
          final success = await saveFunction(entry.attempt);

          if (success) {
            successCount++;
            logger.info('Successfully saved queued attempt: ${entry.attempt.id}');
          } else {
            // Increment retry count and keep in queue
            final updatedEntry = {
              'attempt': entry.attempt.toMap(),
              'addedAt': entry.addedAt.toIso8601String(),
              'retryCount': entry.retryCount + 1,
            };
            remainingEntries.add(jsonEncode(updatedEntry));
          }
        } catch (e) {
          logger.warning('Failed to process queue entry: $e');
          // Keep the entry for next retry
          remainingEntries.add(json);
        }
      }

      // Update queue with remaining entries
      await prefs.setStringList(_queueKey, remainingEntries);

      logger.info('Queue processing complete: $successCount saved, ${remainingEntries.length} remaining');
      return successCount;
    } catch (e, stackTrace) {
      logger.error('Failed to process retry queue', e, stackTrace);
      return 0;
    } finally {
      _releaseLock();
    }
  }

  /// Remove a specific attempt from the queue
  static Future<void> remove(String attemptId) async {
    await _acquireLock();
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];

      final updatedQueue = queueJson.where((json) {
        try {
          final data = jsonDecode(json) as Map<String, dynamic>;
          final attempt = data['attempt'] as Map<String, dynamic>;
          return attempt['id'] != attemptId;
        } catch (e) {
          return true; // Keep if can't parse
        }
      }).toList();

      await prefs.setStringList(_queueKey, updatedQueue);
    } catch (e, stackTrace) {
      logger.error('Failed to remove from retry queue', e, stackTrace);
    } finally {
      _releaseLock();
    }
  }

  /// Clear the entire queue
  static Future<void> clear() async {
    await _acquireLock();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_queueKey);
      logger.info('Quiz retry queue cleared');
    } catch (e, stackTrace) {
      logger.error('Failed to clear retry queue', e, stackTrace);
    } finally {
      _releaseLock();
    }
  }

  /// Get queue size
  static Future<int> getQueueSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getStringList(_queueKey) ?? [];
      return queueJson.length;
    } catch (e) {
      return 0;
    }
  }
}

/// Internal class for queue entries
class _QueueEntry {
  final QuizAttemptModel attempt;
  final DateTime addedAt;
  final int retryCount;

  _QueueEntry({
    required this.attempt,
    required this.addedAt,
    required this.retryCount,
  });

  factory _QueueEntry.fromJson(Map<String, dynamic> json) {
    return _QueueEntry(
      attempt: QuizAttemptModel.fromMap(json['attempt'] as Map<String, dynamic>),
      addedAt: DateTime.parse(json['addedAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}
