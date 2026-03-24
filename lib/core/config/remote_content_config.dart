/// Remote Content Configuration
/// Configuration for Cloudflare R2 bucket and content paths
library;

/// Configuration for remote content storage (Cloudflare R2)
class RemoteContentConfig {
  RemoteContentConfig._();

  /// Base URL for the R2 bucket (via Cloudflare CDN)
  /// Update this to your actual bucket URL
  static const String bucketUrl = 'https://content.streamshaala.com';

  /// Path to the manifest file
  static const String manifestPath = '/manifest.json';

  /// Current content version
  static const String contentVersion = 'v1';

  /// Build full URL for manifest
  static String get manifestUrl => '$bucketUrl$manifestPath';

  /// Build path for a catalog file
  static String catalogPath(String segment) =>
      '/$contentVersion/$segment/catalog.json';

  /// Build path for a chapters list file
  static String chaptersPath(String segment, String subjectId) =>
      '/$contentVersion/$segment/$subjectId/chapters.json';

  /// Build path for a chapter content file
  static String chapterPath(
    String segment,
    String subjectId,
    String chapterId,
    String file,
  ) =>
      '/$contentVersion/$segment/$subjectId/$chapterId/$file';

  /// Build path for chapter main content
  static String chapterContentPath(
    String segment,
    String subjectId,
    String chapterId,
  ) =>
      chapterPath(segment, subjectId, chapterId, 'chapter.json');

  /// Build path for chapter glossary
  static String glossaryPath(
    String segment,
    String subjectId,
    String chapterId,
  ) =>
      chapterPath(segment, subjectId, chapterId, 'glossary.json');

  /// Build path for chapter flashcards
  static String flashcardsPath(
    String segment,
    String subjectId,
    String chapterId,
  ) =>
      chapterPath(segment, subjectId, chapterId, 'flashcards.json');

  /// Build path for chapter mind map
  static String mindmapPath(
    String segment,
    String subjectId,
    String chapterId,
  ) =>
      chapterPath(segment, subjectId, chapterId, 'mindmap.json');

  /// Build path for chapter questions/FAQs
  static String questionsPath(
    String segment,
    String subjectId,
    String chapterId,
  ) =>
      chapterPath(segment, subjectId, chapterId, 'questions.json');

  /// Build path for video index
  static String videosIndexPath(
    String segment,
    String subjectId,
    String chapterId,
  ) =>
      '/$contentVersion/$segment/$subjectId/$chapterId/videos/index.json';

  /// Build path for individual video content
  static String videoPath(
    String segment,
    String subjectId,
    String chapterId,
    String videoId,
  ) =>
      '/$contentVersion/$segment/$subjectId/$chapterId/videos/$videoId.json';

  /// Build full URL from path
  static String fullUrl(String path) => '$bucketUrl$path';

  /// Extract version from a content path
  static String? extractVersion(String path) {
    final match = RegExp(r'^/(v\d+)/').firstMatch(path);
    return match?.group(1);
  }
}

/// Configuration for local content caching
class ContentCacheConfig {
  ContentCacheConfig._();

  /// Cache directory name within app documents
  static const String cacheDirectory = 'content_cache';

  /// Maximum cache age before forcing refresh (in days)
  static const int maxCacheAgeDays = 7;

  /// Build cache path for a content file
  static String cachePath(String basePath, String remotePath) {
    // Remove leading slash
    var cleanPath = remotePath;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
    return '$basePath/$cacheDirectory/$cleanPath';
  }
}

/// Content manifest structure
class ContentManifest {
  final String version;
  final DateTime updatedAt;
  final Map<String, SegmentManifest> segments;

  ContentManifest({
    required this.version,
    required this.updatedAt,
    required this.segments,
  });

  factory ContentManifest.fromJson(Map<String, dynamic> json) {
    final segmentsJson = json['segments'] as Map<String, dynamic>? ?? {};
    return ContentManifest(
      version: json['version'] as String? ?? 'v1',
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      segments: segmentsJson.map(
        (key, value) => MapEntry(key, SegmentManifest.fromJson(value as Map<String, dynamic>)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'updatedAt': updatedAt.toIso8601String(),
        'segments': segments.map((key, value) => MapEntry(key, value.toJson())),
      };
}

/// Segment manifest (e.g., "junior", "senior")
class SegmentManifest {
  final String checksum;
  final DateTime updatedAt;
  final List<String> subjects;

  SegmentManifest({
    required this.checksum,
    required this.updatedAt,
    required this.subjects,
  });

  factory SegmentManifest.fromJson(Map<String, dynamic> json) {
    return SegmentManifest(
      checksum: json['checksum'] as String? ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      subjects: (json['subjects'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'checksum': checksum,
        'updatedAt': updatedAt.toIso8601String(),
        'subjects': subjects,
      };
}
