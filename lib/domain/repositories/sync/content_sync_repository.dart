/// Content Sync Repository Interface
/// Defines the contract for syncing static content from R2
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/config/remote_content_config.dart';
import 'package:streamshaala/core/errors/failures.dart';

/// Repository interface for content synchronization
abstract class ContentSyncRepository {
  /// Initialize the repository
  Future<void> initialize();

  /// Check if content update is available
  Future<Either<Failure, bool>> checkForUpdates();

  /// Fetch the content manifest
  Future<Either<Failure, ContentManifest>> fetchManifest();

  /// Sync content for a specific segment
  ///
  /// [segment] - The segment to sync (e.g., "junior", "senior")
  /// [forceRefresh] - If true, ignore cache and fetch fresh content
  Future<Either<Failure, void>> syncSegment(
    String segment, {
    bool forceRefresh = false,
  });

  /// Sync content for a specific subject
  Future<Either<Failure, void>> syncSubject(
    String segment,
    String subjectId, {
    bool forceRefresh = false,
  });

  /// Sync content for a specific chapter
  Future<Either<Failure, void>> syncChapter(
    String segment,
    String subjectId,
    String chapterId, {
    bool forceRefresh = false,
  });

  /// Get cached chapter content
  Future<Either<Failure, Map<String, dynamic>>> getChapterContent(
    String segment,
    String subjectId,
    String chapterId,
  );

  /// Get cached glossary for a chapter
  Future<Either<Failure, Map<String, dynamic>>> getGlossary(
    String segment,
    String subjectId,
    String chapterId,
  );

  /// Get cached flashcards for a chapter
  Future<Either<Failure, Map<String, dynamic>>> getFlashcards(
    String segment,
    String subjectId,
    String chapterId,
  );

  /// Get cached mind map for a chapter
  Future<Either<Failure, Map<String, dynamic>>> getMindmap(
    String segment,
    String subjectId,
    String chapterId,
  );

  /// Get cached questions for a chapter
  Future<Either<Failure, Map<String, dynamic>>> getQuestions(
    String segment,
    String subjectId,
    String chapterId,
  );

  /// Get cached video content
  Future<Either<Failure, Map<String, dynamic>>> getVideoContent(
    String segment,
    String subjectId,
    String chapterId,
    String videoId,
  );

  /// Clear all cached content
  Future<Either<Failure, void>> clearCache();

  /// Clear cache for a specific segment
  Future<Either<Failure, void>> clearSegmentCache(String segment);

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats();
}

/// Content-related failure
class ContentSyncFailure extends Failure {
  const ContentSyncFailure(String message) : super(message: message);
}
