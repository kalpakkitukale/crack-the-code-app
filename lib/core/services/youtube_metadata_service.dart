import 'package:crack_the_code/core/services/secure_http_client.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/core/utils/validation_helpers.dart';

/// YouTube Metadata Service
/// Fetches video metadata using YouTube oEmbed API (no API key required)
class YouTubeMetadataService {
  static const String _oembedBaseUrl = 'https://www.youtube.com/oembed';

  // Regex to validate YouTube video IDs (11 characters, alphanumeric with - and _)
  static final _videoIdRegex = RegExp(r'^[a-zA-Z0-9_-]{11}$');

  /// Validate a YouTube video ID
  static bool isValidVideoId(String? videoId) {
    if (videoId == null || videoId.isEmpty) return false;
    return _videoIdRegex.hasMatch(videoId);
  }

  /// Fetch video metadata from YouTube oEmbed API
  /// Returns a map with title, author_name (channel), and thumbnail_url
  static Future<Map<String, String>?> fetchMetadata(String videoId) async {
    try {
      // Validate video ID format to prevent injection
      if (!isValidVideoId(videoId)) {
        logger.warning('[YouTube Metadata] Invalid video ID format: $videoId');
        return null;
      }

      final url = '$_oembedBaseUrl?url=https://www.youtube.com/watch?v=$videoId&format=json';
      logger.info('[YouTube Metadata] Fetching metadata for video: $videoId');

      final result = await secureApiClient.get(url);

      if (result.isSuccess && result.json != null) {
        final data = result.json!;

        // Validate and sanitize response fields
        final metadata = {
          'title': ApiResponseValidator.sanitizeString(
            data['title'] as String?,
            defaultValue: 'Untitled Video',
          ),
          'channelName': ApiResponseValidator.sanitizeString(
            data['author_name'] as String?,
          ),
          'thumbnailUrl': ApiResponseValidator.sanitizeString(
            data['thumbnail_url'] as String?,
          ),
        };

        // Validate title length
        if (metadata['title']!.length > InputLimits.mediumText) {
          metadata['title'] = metadata['title']!.substring(0, InputLimits.mediumText);
        }

        logger.info('[YouTube Metadata] ✅ Successfully fetched metadata: ${metadata['title']}');
        return metadata;
      } else if (result.statusCode == 404) {
        logger.warning('[YouTube Metadata] Video not found: $videoId');
        return null;
      } else if (result.statusCode == 408) {
        logger.warning('[YouTube Metadata] Request timeout for video: $videoId');
        return null;
      } else {
        logger.warning('[YouTube Metadata] Failed to fetch metadata: ${result.statusCode} - ${result.error}');
        return null;
      }
    } catch (e, stackTrace) {
      logger.error('[YouTube Metadata] Error fetching metadata for $videoId: $e', e, stackTrace);
      return null;
    }
  }

  /// Fetch metadata and cache it in video_metadata_cache table
  static Future<Map<String, String>?> fetchAndCacheMetadata(
    String videoId,
    Future<void> Function(String videoId, String title, String channelName, String thumbnailUrl) cacheCallback,
  ) async {
    final metadata = await fetchMetadata(videoId);

    if (metadata != null) {
      // Cache the metadata
      await cacheCallback(
        videoId,
        metadata['title']!,
        metadata['channelName']!,
        metadata['thumbnailUrl']!,
      );
    }

    return metadata;
  }
}
