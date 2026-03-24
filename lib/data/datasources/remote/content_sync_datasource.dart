/// Content Sync Datasource
/// Handles downloading content from Cloudflare R2
library;

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:streamshaala/core/config/remote_content_config.dart';
import 'package:streamshaala/core/services/secure_http_client.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Datasource for fetching and caching content from R2
class ContentSyncDatasource {
  final SecureHttpClient _client;
  String? _cacheBasePath;

  ContentSyncDatasource({
    SecureHttpClient? client,
  }) : _client = client ?? secureContentClient;

  /// Initialize the datasource (set up cache directory)
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheBasePath = '${appDir.path}/${ContentCacheConfig.cacheDirectory}';

    // Ensure cache directory exists
    await Directory(_cacheBasePath!).create(recursive: true);
    logger.info('Content cache initialized at: $_cacheBasePath');
  }

  /// Fetch the content manifest
  Future<ContentManifest?> fetchManifest() async {
    try {
      final url = RemoteContentConfig.manifestUrl;
      logger.info('Fetching manifest from: $url');

      final result = await _client.get(url);

      if (!result.isSuccess) {
        logger.error('Failed to fetch manifest: ${result.statusCode} - ${result.error}');
        return null;
      }

      final jsonData = result.json;
      if (jsonData == null) {
        logger.error('Failed to parse manifest JSON');
        return null;
      }

      return ContentManifest.fromJson(jsonData);
    } catch (e) {
      logger.error('Failed to fetch manifest: $e');
      return null;
    }
  }

  /// Check if content needs update based on manifest
  Future<bool> needsUpdate(ContentManifest manifest) async {
    // Compare with cached manifest
    final cachedManifest = await _loadCachedManifest();
    if (cachedManifest == null) return true;

    return manifest.version != cachedManifest.version ||
        manifest.updatedAt.isAfter(cachedManifest.updatedAt);
  }

  /// Fetch content from a path
  Future<String?> fetchContent(String path) async {
    try {
      final url = RemoteContentConfig.fullUrl(path);
      logger.debug('Fetching content: $url');

      final result = await _client.get(url);

      if (!result.isSuccess) {
        logger.error('Failed to fetch content at $path: ${result.statusCode} - ${result.error}');
        return null;
      }

      return result.body;
    } catch (e) {
      logger.error('Failed to fetch content at $path: $e');
      return null;
    }
  }

  /// Fetch content as JSON
  Future<Map<String, dynamic>?> fetchContentAsJson(String path) async {
    try {
      // Try cache first
      final cached = await _loadFromCache(path);
      if (cached != null) {
        logger.debug('Loaded from cache: $path');
        return cached;
      }

      // Fetch from remote
      final content = await fetchContent(path);
      if (content == null) return null;

      final jsonData = json.decode(content) as Map<String, dynamic>;

      // Cache the content
      await _saveToCache(path, jsonData);

      return jsonData;
    } catch (e) {
      logger.error('Failed to fetch content as JSON at $path: $e');
      return null;
    }
  }

  /// Fetch catalog for a segment
  Future<Map<String, dynamic>?> fetchCatalog(String segment) async {
    final path = RemoteContentConfig.catalogPath(segment);
    return fetchContentAsJson(path);
  }

  /// Fetch chapters list for a subject
  Future<Map<String, dynamic>?> fetchChapters(
    String segment,
    String subjectId,
  ) async {
    final path = RemoteContentConfig.chaptersPath(segment, subjectId);
    return fetchContentAsJson(path);
  }

  /// Fetch chapter main content
  Future<Map<String, dynamic>?> fetchChapterContent(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    final path = RemoteContentConfig.chapterContentPath(
      segment,
      subjectId,
      chapterId,
    );
    return fetchContentAsJson(path);
  }

  /// Fetch chapter glossary
  Future<Map<String, dynamic>?> fetchGlossary(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    final path = RemoteContentConfig.glossaryPath(
      segment,
      subjectId,
      chapterId,
    );
    return fetchContentAsJson(path);
  }

  /// Fetch chapter flashcards
  Future<Map<String, dynamic>?> fetchFlashcards(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    final path = RemoteContentConfig.flashcardsPath(
      segment,
      subjectId,
      chapterId,
    );
    return fetchContentAsJson(path);
  }

  /// Fetch chapter mind map
  Future<Map<String, dynamic>?> fetchMindmap(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    final path = RemoteContentConfig.mindmapPath(
      segment,
      subjectId,
      chapterId,
    );
    return fetchContentAsJson(path);
  }

  /// Fetch chapter questions/FAQs
  Future<Map<String, dynamic>?> fetchQuestions(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    final path = RemoteContentConfig.questionsPath(
      segment,
      subjectId,
      chapterId,
    );
    return fetchContentAsJson(path);
  }

  /// Fetch video index for a chapter
  Future<Map<String, dynamic>?> fetchVideoIndex(
    String segment,
    String subjectId,
    String chapterId,
  ) async {
    final path = RemoteContentConfig.videosIndexPath(
      segment,
      subjectId,
      chapterId,
    );
    return fetchContentAsJson(path);
  }

  /// Fetch individual video content
  Future<Map<String, dynamic>?> fetchVideoContent(
    String segment,
    String subjectId,
    String chapterId,
    String videoId,
  ) async {
    final path = RemoteContentConfig.videoPath(
      segment,
      subjectId,
      chapterId,
      videoId,
    );
    return fetchContentAsJson(path);
  }

  /// Clear all cached content
  Future<void> clearCache() async {
    if (_cacheBasePath == null) return;

    try {
      final cacheDir = Directory(_cacheBasePath!);
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(recursive: true);
        logger.info('Content cache cleared');
      }
    } catch (e) {
      logger.error('Failed to clear cache: $e');
    }
  }

  /// Clear cache for a specific segment
  Future<void> clearSegmentCache(String segment) async {
    if (_cacheBasePath == null) return;

    try {
      final segmentDir = Directory(
        '$_cacheBasePath/${RemoteContentConfig.contentVersion}/$segment',
      );
      if (await segmentDir.exists()) {
        await segmentDir.delete(recursive: true);
        logger.info('Cleared cache for segment: $segment');
      }
    } catch (e) {
      logger.error('Failed to clear segment cache: $e');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    if (_cacheBasePath == null) {
      return {'initialized': false};
    }

    try {
      final cacheDir = Directory(_cacheBasePath!);
      if (!await cacheDir.exists()) {
        return {'initialized': true, 'size': 0, 'files': 0};
      }

      var totalSize = 0;
      var fileCount = 0;

      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
          fileCount++;
        }
      }

      return {
        'initialized': true,
        'size': totalSize,
        'sizeFormatted': _formatBytes(totalSize),
        'files': fileCount,
      };
    } catch (e) {
      logger.error('Failed to get cache stats: $e');
      return {'initialized': true, 'error': e.toString()};
    }
  }

  // ==================== Private Methods ====================

  Future<Map<String, dynamic>?> _loadFromCache(String path) async {
    if (_cacheBasePath == null) return null;

    try {
      final cachePath = ContentCacheConfig.cachePath(_cacheBasePath!, path);
      final file = File(cachePath);

      if (!await file.exists()) return null;

      // Check cache age
      final stat = await file.stat();
      final age = DateTime.now().difference(stat.modified);
      if (age.inDays > ContentCacheConfig.maxCacheAgeDays) {
        logger.debug('Cache expired for: $path');
        await file.delete();
        return null;
      }

      final jsonString = await file.readAsString();
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      logger.error('Failed to load from cache: $e');
      return null;
    }
  }

  Future<void> _saveToCache(String path, Map<String, dynamic> data) async {
    if (_cacheBasePath == null) return;

    try {
      final cachePath = ContentCacheConfig.cachePath(_cacheBasePath!, path);
      final file = File(cachePath);

      // Ensure parent directory exists
      await file.parent.create(recursive: true);

      await file.writeAsString(json.encode(data));
      logger.debug('Cached: $path');
    } catch (e) {
      logger.error('Failed to save to cache: $e');
    }
  }

  Future<ContentManifest?> _loadCachedManifest() async {
    final data = await _loadFromCache(RemoteContentConfig.manifestPath);
    if (data == null) return null;
    return ContentManifest.fromJson(data);
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Dispose of resources
  void dispose() {
    // Note: Don't dispose the shared secureContentClient
    // Only dispose if a custom client was provided
    if (_client != secureContentClient) {
      _client.dispose();
    }
  }
}
