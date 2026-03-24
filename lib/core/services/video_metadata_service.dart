import 'dart:async';
import 'dart:convert';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

/// Centralized service for managing video metadata across platforms
/// Ensures consistent video information and efficient caching
class VideoMetadataService {
  static final VideoMetadataService _instance = VideoMetadataService._internal();
  factory VideoMetadataService() => _instance;
  VideoMetadataService._internal();

  final Map<String, Video> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(hours: 24);

  Timer? _cleanupTimer;

  /// Initialize the service
  Future<void> initialize() async {
    logger.info('🎬 Initializing Video Metadata Service...');

    // Note: Database caching removed for simplification
    // Now using in-memory cache only

    // Set up periodic cleanup
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      const Duration(hours: 1),
      (_) => _cleanupExpiredCache(),
    );

    logger.info('✅ Video Metadata Service initialized (in-memory only)');
  }

  /// Get video metadata by ID
  Future<Video?> getVideoMetadata(String videoId) async {
    // Check memory cache first
    if (_memoryCache.containsKey(videoId)) {
      final timestamp = _cacheTimestamps[videoId]!;
      if (DateTime.now().difference(timestamp) < _cacheExpiry) {
        logger.debug('Video metadata hit from memory cache: $videoId');
        return _memoryCache[videoId];
      }
    }

    // Check database cache
    final dbMetadata = await _getFromDatabaseCache(videoId);
    if (dbMetadata != null) {
      _memoryCache[videoId] = dbMetadata;
      _cacheTimestamps[videoId] = DateTime.now();
      return dbMetadata;
    }

    // Fetch from repository
    try {
      final contentRepository = injectionContainer.contentRepository;
      final result = await contentRepository.getVideoById(videoId);

      return result.fold(
        (failure) {
          logger.error('Failed to fetch video metadata: ${failure.message}');
          return null;
        },
        (video) {
          // Cache the result
          _cacheVideoMetadata(video);
          return video;
        },
      );
    } catch (e) {
      logger.error('Error fetching video metadata: $e');
      return null;
    }
  }

  /// Batch fetch video metadata
  Future<Map<String, Video>> getVideosMetadata(List<String> videoIds) async {
    final results = <String, Video>{};
    final toFetch = <String>[];

    // Check cache for each video
    for (final id in videoIds) {
      final cached = await getVideoMetadata(id);
      if (cached != null) {
        results[id] = cached;
      } else {
        toFetch.add(id);
      }
    }

    // Batch fetch missing videos
    if (toFetch.isNotEmpty) {
      logger.info('Batch fetching ${toFetch.length} video metadata...');

      try {
        final contentRepository = injectionContainer.contentRepository;

        // Fetch videos in parallel
        final futures = toFetch.map((id) => contentRepository.getVideoById(id));
        final fetchResults = await Future.wait(futures);

        for (int i = 0; i < toFetch.length; i++) {
          final result = fetchResults[i];
          result.fold(
            (failure) => logger.warning('Failed to fetch ${toFetch[i]}: ${failure.message}'),
            (video) {
              results[video.id] = video;
              _cacheVideoMetadata(video);
            },
          );
        }
      } catch (e) {
        logger.error('Error batch fetching videos: $e');
      }
    }

    return results;
  }

  /// Update video metadata
  Future<void> updateVideoMetadata(Video video) async {
    // Update memory cache
    _memoryCache[video.id] = video;
    _cacheTimestamps[video.id] = DateTime.now();

    // Update database cache
    await _saveToDatabaseCache(video);

    logger.info('Updated metadata for video: ${video.id}');
  }

  /// Cache video metadata
  void _cacheVideoMetadata(Video video) {
    _memoryCache[video.id] = video;
    _cacheTimestamps[video.id] = DateTime.now();

    // Save to database in background
    _saveToDatabaseCache(video).catchError((e) {
      logger.warning('Failed to save video metadata to database: $e');
    });
  }

  /// Load cached metadata from database (DISABLED - database caching removed)
  Future<void> _loadCachedMetadata() async {
    // Database caching removed for simplification
    // Using in-memory cache only now
    logger.debug('Database caching disabled, using in-memory only');
  }

  /// Get video from database cache (DISABLED - database caching removed)
  Future<Video?> _getFromDatabaseCache(String videoId) async {
    // Database caching removed for simplification
    return null;
  }

  /// Save video to database cache (DISABLED - database caching removed)
  Future<void> _saveToDatabaseCache(Video video) async {
    // Database caching removed for simplification
    return;
  }

  /// Clean up expired cache entries
  Future<void> _cleanupExpiredCache() async {
    logger.debug('Cleaning up expired video metadata cache...');

    // Clean memory cache
    final now = DateTime.now();
    final toRemove = <String>[];

    _cacheTimestamps.forEach((id, timestamp) {
      if (now.difference(timestamp) > _cacheExpiry) {
        toRemove.add(id);
      }
    });

    for (final id in toRemove) {
      _memoryCache.remove(id);
      _cacheTimestamps.remove(id);
    }

    // Note: Database cache cleanup removed (database caching disabled)

    if (toRemove.isNotEmpty) {
      logger.info('Cleaned up ${toRemove.length} expired video metadata entries');
    }
  }

  /// Prefetch video metadata for a subject
  Future<void> prefetchSubjectVideos(String subjectId) async {
    logger.info('Prefetching videos for subject: $subjectId');

    try {
      final contentRepository = injectionContainer.contentRepository;
      final result = await contentRepository.getSubjectById(subjectId);

      result.fold(
        (failure) => logger.error('Failed to prefetch subject: ${failure.message}'),
        (subject) async {
          // In our structure: Subject -> Chapters -> Topics (no direct video access)
          // We'll need to fetch videos through the content repository when needed
          logger.info('Subject ${subject.name} has ${subject.totalChapters} chapters '
              'with ${subject.totalVideos} total videos');
        },
      );
    } catch (e) {
      logger.error('Error prefetching subject videos: $e');
    }
  }

  /// Get statistics about cached metadata
  Future<Map<String, dynamic>> getCacheStatistics() async {
    // Note: Database statistics removed (database caching disabled)
    final stats = <String, dynamic>{
      'memory_cache_size': _memoryCache.length,
      'memory_cache_videos': _memoryCache.keys.toList(),
      'database_cache_size': 0, // Database caching disabled
    };

    return stats;
  }

  /// Clear all cached metadata
  Future<void> clearCache() async {
    logger.warning('Clearing all video metadata cache...');

    // Clear memory cache
    _memoryCache.clear();
    _cacheTimestamps.clear();

    // Note: Database cache clearing removed (database caching disabled)
    logger.info('Video metadata cache cleared');
  }

  /// Dispose the service
  void dispose() {
    _cleanupTimer?.cancel();
    _memoryCache.clear();
    _cacheTimestamps.clear();
  }
}