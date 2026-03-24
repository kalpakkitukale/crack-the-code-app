/// Application-wide constants for Crack the Code
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Crack the Code';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Multi-platform educational video aggregator for Indian 12th standard students';

  // Database
  static const String databaseName = 'crackthecode.db';
  static const int databaseVersion = 1;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration filterDebounce = Duration(milliseconds: 500);

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB

  // Video
  static const double defaultVideoAspectRatio = 16 / 9;
  static const Duration videoProgressUpdateInterval = Duration(seconds: 5);

  // Animation
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);

  // Limits
  static const int maxNoteLength = 5000;
  static const int maxCollectionNameLength = 50;
  static const int maxSearchHistoryItems = 20;

  // YouTube
  static const String youtubeThumbnailUrl =
      'https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg';
  static const String youtubeWatchUrl = 'https://www.youtube.com/watch?v=';

  // Default values
  static const int defaultStreak = 0;
  static const double defaultProgress = 0.0;
}
