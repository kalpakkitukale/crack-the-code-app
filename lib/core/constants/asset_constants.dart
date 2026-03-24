/// Asset paths and constants for StreamShaala
///
/// This file contains all asset-related constants including:
/// - JSON data file paths
/// - Image paths
/// - Icon paths
library;

/// JSON Data Assets
class JsonAssets {
  // Base paths
  static const String _basePath = 'assets/data';
  static const String _boardsPath = '$_basePath/boards';
  static const String _contentPath = '$_basePath/content';
  static const String _metadataPath = '$_basePath/metadata';

  // Board files
  static const String cbseBoard = '$_boardsPath/cbse.json';
  static const String cbseElementaryBoard = '$_boardsPath/cbse_elementary.json';
  static const String icseBoard = '$_boardsPath/icse.json';
  static const String stateBoards = '$_boardsPath/state_boards.json';

  // Subject files
  static const String subjectsPath = '$_contentPath/subjects';
  static String subject(String subjectId) => '$subjectsPath/$subjectId.json';

  // Video files
  static const String videosPath = '$_contentPath/videos';
  static String videos(String subjectId, String chapterId) =>
      '$videosPath/${subjectId}_${chapterId}_videos.json';

  // Metadata files
  static const String difficultyLevels = '$_metadataPath/difficulty_levels.json';
  static const String tags = '$_metadataPath/tags.json';
  static const String categories = '$_metadataPath/categories.json';
}

/// Image Assets
class ImageAssets {
  static const String _basePath = 'assets/images';

  static const String logo = '$_basePath/logo.png';
  static const String placeholder = '$_basePath/placeholder.png';
  static const String emptyState = '$_basePath/empty_state.png';
}

/// Icon Assets
class IconAssets {
  static const String _basePath = 'assets/icons';

  // Board icons
  static const String cbse = '$_basePath/cbse.png';
  static const String icse = '$_basePath/icse.png';

  // Subject icons
  static const String physics = '$_basePath/physics.png';
  static const String chemistry = '$_basePath/chemistry.png';
  static const String mathematics = '$_basePath/mathematics.png';
  static const String biology = '$_basePath/biology.png';
}

/// Study Tools JSON Assets
class StudyToolsAssets {
  static const String _basePath = 'assets/data/study_tools';

  /// Get path to summaries JSON file for a chapter
  static String summaries(String subjectId, String chapterId) =>
      '$_basePath/summaries/${subjectId}_${chapterId}_summaries.json';

  /// Get path to glossary JSON file for a chapter
  static String glossary(String subjectId, String chapterId) =>
      '$_basePath/glossary/${subjectId}_${chapterId}_glossary.json';

  /// Get path to mind map JSON file for a chapter
  static String mindMap(String subjectId, String chapterId) =>
      '$_basePath/mind_maps/${subjectId}_${chapterId}_mindmap.json';

  /// Get path to flashcards JSON file for a chapter
  static String flashcards(String subjectId, String chapterId) =>
      '$_basePath/flashcards/${subjectId}_${chapterId}_flashcards.json';

  /// Get path to FAQs JSON file for a chapter
  static String faqs(String subjectId, String chapterId) =>
      '$_basePath/faqs/${subjectId}_${chapterId}_faqs.json';

  /// Get path to chapter content JSON file (contains summary and curated notes)
  static String chapterContent(String subjectId, String chapterId) =>
      '$_basePath/chapter_content/${subjectId}_${chapterId}_chapter_content.json';
}

/// Readiness Assessment JSON Assets
class AssessmentAssets {
  static const String _basePath = 'assets/data/assessments';

  /// Get path to readiness assessment JSON file for a chapter
  static String readiness(String subjectId, String chapterId) =>
      '$_basePath/readiness_${subjectId}_$chapterId.json';
}

/// Recommendation Algorithm JSON Assets
class RecommendationAssets {
  static const String _basePath = 'assets/data/recommendations';

  /// Get path to recommendation algorithm JSON file for a chapter
  static String recommendation(String subjectId, String chapterId) =>
      '$_basePath/recommendations_${subjectId}_$chapterId.json';
}

/// Prerequisite Video JSON Assets
class PrerequisiteVideoAssets {
  static const String _basePath = 'assets/data/videos';

  /// Get path to prerequisite videos JSON file for a chapter
  static String prerequisiteVideos(String subjectId, String chapterId) =>
      '$_basePath/prerequisite_videos_${subjectId}_$chapterId.json';
}

/// Topic Playlist JSON Assets
class TopicPlaylistAssets {
  static const String _basePath = 'assets/data/content/videos';

  /// Get path to topic playlist JSON file for a chapter topic
  static String topicPlaylist(String subjectId, String chapterId, String topicId) =>
      '$_basePath/topic_videos_${subjectId}_${chapterId}_$topicId.json';
}

/// Cache directory constants
class CacheAssets {
  /// Content cache directory name
  static const String contentCacheDir = 'content_cache';

  /// User data cache directory name
  static const String userDataCacheDir = 'user_data_cache';

  /// Build cache path for content
  static String contentCachePath(String basePath, String relativePath) {
    var cleanPath = relativePath;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
    if (cleanPath.endsWith('.enc')) {
      cleanPath = cleanPath.substring(0, cleanPath.length - 4);
    }
    return '$basePath/$contentCacheDir/$cleanPath';
  }

  /// Build cache path for user data
  static String userDataCachePath(String basePath, String dataType) {
    return '$basePath/$userDataCacheDir/$dataType.json';
  }
}
