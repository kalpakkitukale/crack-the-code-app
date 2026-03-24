/// Content Sync Repository Implementation
/// Implements content synchronization from R2 with local caching
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/config/remote_content_config.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/services/connectivity_service.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/remote/content_sync_datasource.dart';
import 'package:streamshaala/domain/repositories/sync/content_sync_repository.dart';

/// Implementation of content sync repository
class ContentSyncRepositoryImpl implements ContentSyncRepository {
  final ContentSyncDatasource _datasource;
  final ConnectivityService _connectivityService;
  ContentManifest? _cachedManifest;
  bool _initialized = false;

  ContentSyncRepositoryImpl({
    ContentSyncDatasource? datasource,
    ConnectivityService? connectivityService,
  })  : _datasource = datasource ?? ContentSyncDatasource(),
        _connectivityService = connectivityService ?? connectivityService!;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    await _datasource.initialize();
    _initialized = true;
    logger.info('Content sync repository initialized');
  }

  @override
  Future<Either<Failure, bool>> checkForUpdates() async {
    try {
      if (!_connectivityService.isOnline) {
        return const Right(false);
      }

      final manifest = await _datasource.fetchManifest();
      if (manifest == null) {
        return const Left(ContentSyncFailure('Failed to fetch manifest'));
      }

      final needsUpdate = await _datasource.needsUpdate(manifest);
      _cachedManifest = manifest;

      return Right(needsUpdate);
    } catch (e) {
      logger.error('Failed to check for updates: $e');
      return Left(ContentSyncFailure('Failed to check for updates: $e'));
    }
  }

  @override
  Future<Either<Failure, ContentManifest>> fetchManifest() async {
    try {
      if (!_connectivityService.isOnline) {
        if (_cachedManifest != null) {
          return Right(_cachedManifest!);
        }
        return const Left(ContentSyncFailure('No network and no cached manifest'));
      }

      final manifest = await _datasource.fetchManifest();
      if (manifest == null) {
        if (_cachedManifest != null) {
          return Right(_cachedManifest!);
        }
        return const Left(ContentSyncFailure('Failed to fetch manifest'));
      }

      _cachedManifest = manifest;
      return Right(manifest);
    } catch (e) {
      logger.error('Failed to fetch manifest: $e');
      return Left(ContentSyncFailure('Failed to fetch manifest: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncSegment(
    String segment, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!_connectivityService.isOnline) {
        return const Left(ContentSyncFailure('No network connection'));
      }

      if (forceRefresh) {
        await _datasource.clearSegmentCache(segment);
      }

      // Fetch catalog for segment
      final catalog = await _datasource.fetchCatalog(segment);
      if (catalog == null) {
        return const Left(ContentSyncFailure('Failed to fetch catalog'));
      }

      logger.info('Synced segment: $segment');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync segment $segment: $e');
      return Left(ContentSyncFailure('Failed to sync segment: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncSubject(
    String segment,
    String subjectId, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!_connectivityService.isOnline) {
        return const Left(ContentSyncFailure('No network connection'));
      }

      // Fetch chapters for subject
      final chapters = await _datasource.fetchChapters(segment, subjectId);
      if (chapters == null) {
        return const Left(ContentSyncFailure('Failed to fetch chapters'));
      }

      logger.info('Synced subject: $subjectId');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync subject $subjectId: $e');
      return Left(ContentSyncFailure('Failed to sync subject: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncChapter(
    String segment,
    String subjectId,
    String chapterId, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!_connectivityService.isOnline) {
        return const Left(ContentSyncFailure('No network connection'));
      }

      // Fetch all chapter content in parallel
      final results = await Future.wait([
        _datasource.fetchChapterContent(segment, subjectId, chapterId),
        _datasource.fetchGlossary(segment, subjectId, chapterId),
        _datasource.fetchFlashcards(segment, subjectId, chapterId),
        _datasource.fetchMindmap(segment, subjectId, chapterId),
        _datasource.fetchQuestions(segment, subjectId, chapterId),
        _datasource.fetchVideoIndex(segment, subjectId, chapterId),
      ]);

      // Check if main chapter content was fetched
      if (results[0] == null) {
        return const Left(ContentSyncFailure('Failed to fetch chapter content'));
      }

      logger.info('Synced chapter: $chapterId');
      return const Right(null);
    } catch (e) {
      logger.error('Failed to sync chapter $chapterId: $e');
      return Left(ContentSyncFailure('Failed to sync chapter: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getChapterContent(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    try {
      final content = await _datasource.fetchChapterContent(
        segment,
        subjectId,
        chapterId,
      );

      if (content == null) {
        return const Left(ContentSyncFailure('Chapter content not available'));
      }

      return Right(content);
    } catch (e) {
      logger.error('Failed to get chapter content: $e');
      return Left(ContentSyncFailure('Failed to get chapter content: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getGlossary(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    try {
      final content = await _datasource.fetchGlossary(
        segment,
        subjectId,
        chapterId,
      );

      if (content == null) {
        return const Left(ContentSyncFailure('Glossary not available'));
      }

      return Right(content);
    } catch (e) {
      logger.error('Failed to get glossary: $e');
      return Left(ContentSyncFailure('Failed to get glossary: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFlashcards(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    try {
      final content = await _datasource.fetchFlashcards(
        segment,
        subjectId,
        chapterId,
      );

      if (content == null) {
        return const Left(ContentSyncFailure('Flashcards not available'));
      }

      return Right(content);
    } catch (e) {
      logger.error('Failed to get flashcards: $e');
      return Left(ContentSyncFailure('Failed to get flashcards: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMindmap(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    try {
      final content = await _datasource.fetchMindmap(
        segment,
        subjectId,
        chapterId,
      );

      if (content == null) {
        return const Left(ContentSyncFailure('Mind map not available'));
      }

      return Right(content);
    } catch (e) {
      logger.error('Failed to get mind map: $e');
      return Left(ContentSyncFailure('Failed to get mind map: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getQuestions(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    try {
      final content = await _datasource.fetchQuestions(
        segment,
        subjectId,
        chapterId,
      );

      if (content == null) {
        return const Left(ContentSyncFailure('Questions not available'));
      }

      return Right(content);
    } catch (e) {
      logger.error('Failed to get questions: $e');
      return Left(ContentSyncFailure('Failed to get questions: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getVideoContent(
    String segment,
    String subjectId,
    String chapterId,
    String videoId,
  ) async {
    try {
      final content = await _datasource.fetchVideoContent(
        segment,
        subjectId,
        chapterId,
        videoId,
      );

      if (content == null) {
        return const Left(ContentSyncFailure('Video content not available'));
      }

      return Right(content);
    } catch (e) {
      logger.error('Failed to get video content: $e');
      return Left(ContentSyncFailure('Failed to get video content: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _datasource.clearCache();
      _cachedManifest = null;
      return const Right(null);
    } catch (e) {
      logger.error('Failed to clear cache: $e');
      return Left(ContentSyncFailure('Failed to clear cache: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearSegmentCache(String segment) async {
    try {
      await _datasource.clearSegmentCache(segment);
      return const Right(null);
    } catch (e) {
      logger.error('Failed to clear segment cache: $e');
      return Left(ContentSyncFailure('Failed to clear segment cache: $e'));
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    return _datasource.getCacheStats();
  }
}
