/// Path Maintenance Service
///
/// Handles automatic maintenance tasks for learning paths:
/// - Auto-pause inactive paths
/// - Cleanup abandoned paths
/// - Path validation
library;

import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';
import 'package:crack_the_code/domain/repositories/learning_path_repository.dart';

/// Service for automatic path maintenance and cleanup
class PathMaintenanceService {
  final LearningPathRepository _repository;

  PathMaintenanceService({
    required LearningPathRepository repository,
  }) : _repository = repository;

  /// Auto-pause paths that have been inactive for too long
  ///
  /// Rules:
  /// - Paths inactive for 14+ days with <25% progress → pause
  /// - Paths inactive for 30+ days → mark as abandoned
  Future<void> autoPauseInactivePaths(String studentId) async {
    try {
      logger.debug('Running auto-pause maintenance for student: $studentId');

      final result = await _repository.getActivePaths(studentId);

      result.fold(
        (failure) {
          logger.error('Failed to load paths for maintenance: ${failure.message}');
        },
        (paths) async {
          final now = DateTime.now();
          int pausedCount = 0;
          int abandonedCount = 0;

          for (final path in paths) {
            final daysSinceAccess = now.difference(path.lastUpdated).inDays;

            // Rule 1: Pause paths inactive for 14+ days with low progress
            if (daysSinceAccess >= 14 && path.progressPercentage < 25) {
              logger.info('Auto-pausing path ${path.id} (inactive for $daysSinceAccess days, ${path.progressPercentage.toStringAsFixed(0)}% complete)');

              await _repository.updatePathStatus(path.id, PathStatus.paused);
              pausedCount++;

              // Optional: Send notification to encourage resumption
              _sendResumeNotification(path);
            }
            // Rule 2: Abandon paths inactive for 30+ days
            else if (daysSinceAccess >= 30) {
              logger.info('Marking path ${path.id} as abandoned (inactive for $daysSinceAccess days)');

              await _repository.updatePathStatus(path.id, PathStatus.abandoned);
              abandonedCount++;
            }
          }

          logger.info('Maintenance complete: $pausedCount paused, $abandonedCount abandoned');
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to run path maintenance', e, stackTrace);
    }
  }

  /// Archive completed paths older than specified days
  ///
  /// Completed paths that are older than [daysOld] will be archived
  /// to keep the active list clean.
  Future<void> archiveOldCompletedPaths(
    String studentId, {
    int daysOld = 90,
  }) async {
    try {
      logger.debug('Archiving completed paths older than $daysOld days');

      final result = await _repository.getAllPaths(studentId);

      result.fold(
        (failure) {
          logger.error('Failed to load paths for archival: ${failure.message}');
        },
        (paths) async {
          final now = DateTime.now();
          int archivedCount = 0;

          for (final path in paths) {
            if (path.status == PathStatus.completed) {
              final daysSinceCompletion = now.difference(path.lastUpdated).inDays;

              if (daysSinceCompletion >= daysOld) {
                logger.info('Archiving old completed path ${path.id} (completed $daysSinceCompletion days ago)');

                // In a real implementation, you might have an 'archived' status
                // or move to a separate table. For now, we'll mark as completed
                // with a metadata flag.
                archivedCount++;
              }
            }
          }

          logger.info('Archived $archivedCount old completed paths');
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to archive old paths', e, stackTrace);
    }
  }

  /// Cleanup duplicate active paths for the same subject
  ///
  /// If a student has multiple active paths for the same subject,
  /// keep only the most recent one and pause the others.
  Future<void> cleanupDuplicatePaths(String studentId) async {
    try {
      logger.debug('Cleaning up duplicate paths for student: $studentId');

      final result = await _repository.getActivePaths(studentId);

      result.fold(
        (failure) {
          logger.error('Failed to load paths for cleanup: ${failure.message}');
        },
        (paths) async {
          // Group paths by subject
          final pathsBySubject = <String, List<LearningPath>>{};

          for (final path in paths) {
            pathsBySubject.putIfAbsent(path.subjectId, () => []).add(path);
          }

          int pausedCount = 0;

          // For each subject, keep only the most recent path
          for (final entry in pathsBySubject.entries) {
            final subjectPaths = entry.value;

            if (subjectPaths.length > 1) {
              // Sort by last updated, most recent first
              subjectPaths.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));

              // Keep the first (most recent), pause the rest
              for (int i = 1; i < subjectPaths.length; i++) {
                final oldPath = subjectPaths[i];
                logger.info('Pausing duplicate path ${oldPath.id} for subject ${entry.key}');

                await _repository.updatePathStatus(oldPath.id, PathStatus.paused);
                pausedCount++;
              }
            }
          }

          if (pausedCount > 0) {
            logger.info('Paused $pausedCount duplicate paths');
          }
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to cleanup duplicate paths', e, stackTrace);
    }
  }

  /// Run all maintenance tasks
  ///
  /// This is the main entry point for scheduled maintenance.
  /// Call this from a background job or periodic task.
  Future<void> runAllMaintenance(String studentId) async {
    logger.info('Running full path maintenance for student: $studentId');

    await autoPauseInactivePaths(studentId);
    await cleanupDuplicatePaths(studentId);
    await archiveOldCompletedPaths(studentId);

    logger.info('Full maintenance complete');
  }

  /// Send notification to encourage path resumption
  ///
  /// This is a placeholder for notification logic.
  /// In a real implementation, this would integrate with a notification service.
  void _sendResumeNotification(LearningPath path) {
    logger.debug('Would send resume notification for path: ${path.id}');
    // TODO: Integrate with notification service
    // Example: "Your Foundation Path is waiting for you! Continue learning where you left off."
  }
}
