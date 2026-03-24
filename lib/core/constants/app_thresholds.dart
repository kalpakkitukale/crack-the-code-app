/// Centralized thresholds and limits for Crack the Code
///
/// This file consolidates magic numbers used throughout the codebase
/// to ensure consistency and make them easier to tune.
library;

/// Mastery level thresholds used by the learning system
///
/// These thresholds determine how well a student has mastered a concept
/// and influence spaced repetition scheduling.
class MasteryThresholds {
  MasteryThresholds._();

  /// Score at or above which a concept is considered mastered (90%)
  static const double mastered = 90.0;

  /// Score at or above which a student is proficient (80%)
  static const double proficient = 80.0;

  /// Score at or above which a student is familiar with the concept (60%)
  static const double familiar = 60.0;

  /// Score at or above which a student is still learning (40%)
  static const double learning = 40.0;

  /// Score below which a concept is considered a knowledge gap
  static const double gapThreshold = 60.0;

  /// Check if a score indicates mastery
  static bool isMastered(double score) => score >= mastered;

  /// Check if a score indicates proficiency
  static bool isProficient(double score) => score >= proficient;

  /// Check if a score indicates a knowledge gap
  static bool isGap(double score) => score < gapThreshold;

  /// Get the mastery level name for a score
  static String getLevelName(double score) {
    if (score >= mastered) return 'Mastered';
    if (score >= proficient) return 'Proficient';
    if (score >= familiar) return 'Familiar';
    if (score >= learning) return 'Learning';
    return 'Needs Practice';
  }
}

/// Performance score thresholds for UI display and grading
class PerformanceThresholds {
  PerformanceThresholds._();

  /// Excellent performance (A grade)
  static const double excellent = 90.0;

  /// Good performance (B grade)
  static const double good = 75.0;

  /// Average performance (C grade)
  static const double average = 60.0;

  /// Below average / needs improvement (D grade)
  static const double belowAverage = 50.0;

  /// Poor performance threshold for urgent attention
  static const double poor = 30.0;

  /// Threshold for considering a quiz "passed"
  static const double passingScore = 60.0;

  /// Threshold for "needs practice" recommendation
  static const double needsPractice = 75.0;

  /// Get letter grade for a percentage score
  static String getGrade(double percentage) {
    if (percentage >= excellent) return 'A';
    if (percentage >= good) return 'B';
    if (percentage >= average) return 'C';
    if (percentage >= belowAverage) return 'D';
    return 'F';
  }

  /// Get descriptive label for a percentage score
  static String getLabel(double percentage) {
    if (percentage >= excellent) return 'Excellent';
    if (percentage >= good) return 'Good';
    if (percentage >= average) return 'Average';
    if (percentage >= belowAverage) return 'Below Average';
    return 'Needs Improvement';
  }
}

/// Star rating thresholds for quiz results
class StarThresholds {
  StarThresholds._();

  /// Score for 3 stars (90%+)
  static const double threeStars = 90.0;

  /// Score for 2 stars (75%+)
  static const double twoStars = 75.0;

  /// Below this gets 1 star
  static const double oneStar = 0.0;

  /// Calculate stars earned for a percentage score
  static int getStars(double percentage) {
    if (percentage >= threeStars) return 3;
    if (percentage >= twoStars) return 2;
    return 1;
  }
}

/// Spaced repetition review intervals in days
class ReviewIntervals {
  ReviewIntervals._();

  /// Standard spaced repetition intervals (SM-2 inspired)
  static const List<int> standardIntervals = [1, 3, 7, 14, 30, 60, 120];

  /// Review interval for mastered concepts (30 days)
  static const int mastered = 30;

  /// Review interval for proficient concepts (14 days)
  static const int proficient = 14;

  /// Review interval for familiar concepts (7 days)
  static const int familiar = 7;

  /// Review interval for learning concepts (3 days)
  static const int learning = 3;

  /// Review interval for struggling concepts (1 day)
  static const int struggling = 1;

  /// Get review interval based on mastery score
  static int getIntervalForScore(double score) {
    if (score >= MasteryThresholds.mastered) return mastered;
    if (score >= MasteryThresholds.proficient) return proficient;
    if (score >= MasteryThresholds.familiar) return familiar;
    if (score >= MasteryThresholds.learning) return learning;
    return struggling;
  }
}

/// Date range thresholds for filtering and analytics
class DateRangeThresholds {
  DateRangeThresholds._();

  /// Days in "this week" filter
  static const int thisWeek = 7;

  /// Days in "this month" filter
  static const int thisMonth = 30;

  /// Days in "last 3 months" filter
  static const int lastThreeMonths = 90;

  /// Days after which recommendations are considered outdated
  static const int recommendationsOutdated = 30;

  /// Days for "recently watched" filter
  static const int recentlyWatched = 7;

  /// Days for "recently curated" content
  static const int recentlyCurated = 30;

  /// Days to keep old data before cleanup
  static const int dataRetention = 90;
}

/// Video progress thresholds
class VideoProgressThresholds {
  VideoProgressThresholds._();

  /// Percentage watched to consider video "started" (5%)
  static const double started = 0.05;

  /// Percentage watched to show quiz prompt (80%)
  static const double quizPrompt = 0.80;

  /// Percentage watched to auto-complete in learning path (80%)
  static const double autoComplete = 0.80;

  /// Percentage watched to mark as "completed" (90%)
  static const double completed = 0.90;
}

/// UI display limits for lists and collections
class DisplayLimits {
  DisplayLimits._();

  /// Maximum items to show in "Recent" sections
  static const int recentItems = 5;

  /// Maximum items in preview cards
  static const int previewItems = 3;

  /// Maximum milestones to display
  static const int milestones = 3;

  /// Maximum subjects in pie chart
  static const int pieChartSegments = 5;

  /// Maximum quiz history items in filter
  static const int quizHistoryFilter = 10;

  /// Maximum items in recommendations list
  static const int recommendations = 50;

  /// Maximum recent XP events to show
  static const int recentXpEvents = 20;

  /// Maximum daily challenge questions
  static const int dailyChallengeQuestions = 100;

  /// Maximum videos to consider for daily challenge
  static const int dailyChallengeVideos = 50;
}

/// Retry and resilience thresholds
class RetryThresholds {
  RetryThresholds._();

  /// Maximum retries for API calls
  static const int apiRetries = 3;

  /// Maximum retries for quiz submission
  static const int quizRetries = 5;

  /// Maximum items in retry queue
  static const int maxQueueSize = 20;

  /// Maximum retries for video player
  static const int videoPlayerRetries = 3;

  /// Maximum sync retries
  static const int syncRetries = 3;
}

/// Parental control thresholds
class ParentalControlThresholds {
  ParentalControlThresholds._();

  /// Duration of lockout after failed PIN attempts
  static const Duration lockoutDuration = Duration(minutes: 15);

  /// Duration after which failed attempts reset
  static const Duration attemptResetDuration = Duration(hours: 1);

  /// Interval for usage tracking timer
  static const Duration usageTrackingInterval = Duration(minutes: 1);

  /// Maximum PIN length
  static const int pinLength = 4;

  /// Screen time options in minutes
  static const List<int> screenTimeOptions = [30, 60, 90, 120];
}

/// HTTP and network thresholds
class NetworkThresholds {
  NetworkThresholds._();

  /// Connection timeout
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// Read timeout for responses
  static const Duration readTimeout = Duration(seconds: 60);

  /// Minimum interval between API requests (rate limiting)
  static const Duration minRequestInterval = Duration(milliseconds: 100);

  /// Maximum response size in bytes (10MB)
  static const int maxResponseSize = 10 * 1024 * 1024;
}

/// Cache thresholds
class CacheThresholds {
  CacheThresholds._();

  /// Default cache expiry duration
  static const Duration defaultExpiry = Duration(hours: 24);

  /// Short cache expiry for frequently changing data
  static const Duration shortExpiry = Duration(hours: 1);

  /// Maximum computation cache entries
  static const int maxComputationCacheSize = 100;
}

/// Responsive design breakpoints
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  /// Maximum width for mobile layout
  static const double mobile = 600.0;

  /// Maximum width for tablet layout
  static const double tablet = 1200.0;

  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48.0;
}
