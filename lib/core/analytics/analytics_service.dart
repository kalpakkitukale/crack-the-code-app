// Analytics Service
// Tracks user engagement, learning progress, and gamification events
// Segment-aware analytics with privacy considerations for Junior users

import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:crack_the_code/core/config/segment_config.dart';

/// Analytics event types
enum AnalyticsEvent {
  // App lifecycle
  appOpen,
  appClose,
  appBackground,
  appForeground,

  // Onboarding
  onboardingStart,
  onboardingComplete,
  onboardingSkip,
  gradeSelected,

  // Navigation
  screenView,
  tabSwitch,
  backNavigation,

  // Content engagement
  videoStart,
  videoComplete,
  videoPause,
  videoSeek,
  videoBookmark,
  videoUnbookmark,

  // Quiz engagement
  quizStart,
  quizComplete,
  quizAbandon,
  questionAnswered,
  questionCorrect,
  questionIncorrect,

  // Gamification (Junior-specific)
  xpEarned,
  levelUp,
  badgeUnlocked,
  streakUpdated,
  streakLost,

  // Learning progress
  conceptMastered,
  gapIdentified,
  recommendationViewed,
  recommendationActioned,

  // Parental controls (Junior-specific)
  screenTimeLimitReached,
  parentalPinEntered,
  progressReportViewed,

  // Search
  searchPerformed,
  searchResultClicked,

  // Errors
  errorOccurred,
  crashRecovered,
}

/// Analytics parameters
class AnalyticsParams {
  final Map<String, dynamic> _params = {};

  AnalyticsParams();

  AnalyticsParams add(String key, dynamic value) {
    if (value != null) {
      _params[key] = value;
    }
    return this;
  }

  Map<String, dynamic> toMap() => Map.unmodifiable(_params);

  // Common parameter builders
  static AnalyticsParams screenView(String screenName) {
    return AnalyticsParams()
      ..add('screen_name', screenName)
      ..add('timestamp', DateTime.now().toIso8601String());
  }

  static AnalyticsParams video({
    required String videoId,
    String? title,
    String? subjectId,
    String? chapterId,
    int? durationSeconds,
    int? watchedSeconds,
    double? percentWatched,
  }) {
    return AnalyticsParams()
      ..add('video_id', videoId)
      ..add('title', title)
      ..add('subject_id', subjectId)
      ..add('chapter_id', chapterId)
      ..add('duration_seconds', durationSeconds)
      ..add('watched_seconds', watchedSeconds)
      ..add('percent_watched', percentWatched);
  }

  static AnalyticsParams quiz({
    required String quizId,
    String? subjectId,
    String? assessmentType,
    int? totalQuestions,
    int? correctAnswers,
    int? score,
    int? durationSeconds,
  }) {
    return AnalyticsParams()
      ..add('quiz_id', quizId)
      ..add('subject_id', subjectId)
      ..add('assessment_type', assessmentType)
      ..add('total_questions', totalQuestions)
      ..add('correct_answers', correctAnswers)
      ..add('score', score)
      ..add('duration_seconds', durationSeconds);
  }

  static AnalyticsParams gamification({
    int? xpAmount,
    String? xpSource,
    int? newLevel,
    int? previousLevel,
    String? badgeId,
    String? badgeName,
    int? streakDays,
  }) {
    return AnalyticsParams()
      ..add('xp_amount', xpAmount)
      ..add('xp_source', xpSource)
      ..add('new_level', newLevel)
      ..add('previous_level', previousLevel)
      ..add('badge_id', badgeId)
      ..add('badge_name', badgeName)
      ..add('streak_days', streakDays);
  }

  static AnalyticsParams error({
    required String errorType,
    String? errorMessage,
    String? stackTrace,
    String? screenName,
  }) {
    return AnalyticsParams()
      ..add('error_type', errorType)
      ..add('error_message', errorMessage)
      ..add('stack_trace', stackTrace)
      ..add('screen_name', screenName);
  }
}

/// Analytics Service singleton
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// Firebase Analytics instance
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  /// Whether analytics is enabled
  bool _isEnabled = true;

  /// Debug mode logs events to console
  bool _debugMode = kDebugMode;

  /// Session tracking
  DateTime? _sessionStart;
  String? _currentScreen;
  final List<_AnalyticsEventRecord> _sessionEvents = [];

  /// User properties
  final Map<String, dynamic> _userProperties = {};

  /// Initialize analytics
  Future<void> initialize() async {
    _sessionStart = DateTime.now();

    // Set default user properties
    setUserProperty('segment', SegmentConfig.current.name);
    setUserProperty('is_junior', SegmentConfig.isCrackTheCode);

    if (_debugMode) {
      debugPrint('[Analytics] Initialized for segment: ${SegmentConfig.current.name}');
    }
  }

  /// Enable/disable analytics
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (_debugMode) {
      debugPrint('[Analytics] Enabled: $enabled');
    }
  }

  /// Set debug mode
  void setDebugMode(bool debug) {
    _debugMode = debug;
  }

  /// Set user property
  void setUserProperty(String name, dynamic value) {
    _userProperties[name] = value;

    if (_debugMode) {
      debugPrint('[Analytics] User property: $name = $value');
    }

    // Send to Firebase Analytics
    _firebaseAnalytics.setUserProperty(
      name: name,
      value: value?.toString(),
    );
  }

  /// Log analytics event
  void logEvent(AnalyticsEvent event, [AnalyticsParams? params]) {
    if (!_isEnabled) return;

    // Privacy: Don't track certain events for Junior unless parental consent
    if (SegmentConfig.isCrackTheCode && _isRestrictedEvent(event)) {
      if (_debugMode) {
        debugPrint('[Analytics] Skipped restricted event for Junior: ${event.name}');
      }
      return;
    }

    final eventRecord = _AnalyticsEventRecord(
      event: event,
      params: params?.toMap() ?? {},
      timestamp: DateTime.now(),
      screen: _currentScreen,
    );

    _sessionEvents.add(eventRecord);

    if (_debugMode) {
      debugPrint('[Analytics] Event: ${event.name}');
      if (params != null) {
        debugPrint('[Analytics] Params: ${params.toMap()}');
      }
    }

    // Send to Firebase Analytics
    _sendToBackend(eventRecord);
  }

  /// Track screen view
  void trackScreenView(String screenName) {
    _currentScreen = screenName;
    logEvent(
      AnalyticsEvent.screenView,
      AnalyticsParams.screenView(screenName),
    );
  }

  /// Track video engagement
  void trackVideoStart(String videoId, {String? title, String? subjectId}) {
    logEvent(
      AnalyticsEvent.videoStart,
      AnalyticsParams.video(
        videoId: videoId,
        title: title,
        subjectId: subjectId,
      ),
    );
  }

  void trackVideoComplete(
    String videoId, {
    int? durationSeconds,
    int? watchedSeconds,
  }) {
    final percentWatched = durationSeconds != null && durationSeconds > 0
        ? (watchedSeconds ?? durationSeconds) / durationSeconds
        : null;

    logEvent(
      AnalyticsEvent.videoComplete,
      AnalyticsParams.video(
        videoId: videoId,
        durationSeconds: durationSeconds,
        watchedSeconds: watchedSeconds,
        percentWatched: percentWatched,
      ),
    );
  }

  /// Track quiz engagement
  void trackQuizStart(String quizId, {String? subjectId, String? assessmentType}) {
    logEvent(
      AnalyticsEvent.quizStart,
      AnalyticsParams.quiz(
        quizId: quizId,
        subjectId: subjectId,
        assessmentType: assessmentType,
      ),
    );
  }

  void trackQuizComplete(
    String quizId, {
    int? totalQuestions,
    int? correctAnswers,
    int? score,
    int? durationSeconds,
  }) {
    logEvent(
      AnalyticsEvent.quizComplete,
      AnalyticsParams.quiz(
        quizId: quizId,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        score: score,
        durationSeconds: durationSeconds,
      ),
    );
  }

  /// Track gamification events (Junior-specific)
  void trackXpEarned(int amount, String source) {
    if (!SegmentConfig.isCrackTheCode) return;

    logEvent(
      AnalyticsEvent.xpEarned,
      AnalyticsParams.gamification(xpAmount: amount, xpSource: source),
    );
  }

  void trackLevelUp(int newLevel, int previousLevel) {
    if (!SegmentConfig.isCrackTheCode) return;

    logEvent(
      AnalyticsEvent.levelUp,
      AnalyticsParams.gamification(
        newLevel: newLevel,
        previousLevel: previousLevel,
      ),
    );
  }

  void trackBadgeUnlocked(String badgeId, String badgeName) {
    if (!SegmentConfig.isCrackTheCode) return;

    logEvent(
      AnalyticsEvent.badgeUnlocked,
      AnalyticsParams.gamification(badgeId: badgeId, badgeName: badgeName),
    );
  }

  void trackStreakUpdated(int streakDays) {
    if (!SegmentConfig.isCrackTheCode) return;

    logEvent(
      AnalyticsEvent.streakUpdated,
      AnalyticsParams.gamification(streakDays: streakDays),
    );
  }

  /// Track errors
  void trackError(
    String errorType,
    String errorMessage, {
    String? stackTrace,
  }) {
    logEvent(
      AnalyticsEvent.errorOccurred,
      AnalyticsParams.error(
        errorType: errorType,
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        screenName: _currentScreen,
      ),
    );
  }

  /// Get session duration
  Duration get sessionDuration {
    if (_sessionStart == null) return Duration.zero;
    return DateTime.now().difference(_sessionStart!);
  }

  /// Get session event count
  int get sessionEventCount => _sessionEvents.length;

  /// Get session summary for parental reports
  Map<String, dynamic> getSessionSummary() {
    final videosWatched = _sessionEvents
        .where((e) => e.event == AnalyticsEvent.videoComplete)
        .length;

    final quizzesCompleted = _sessionEvents
        .where((e) => e.event == AnalyticsEvent.quizComplete)
        .length;

    final xpEarned = _sessionEvents
        .where((e) => e.event == AnalyticsEvent.xpEarned)
        .fold<int>(0, (sum, e) => sum + ((e.params['xp_amount'] as int?) ?? 0));

    return {
      'session_duration_minutes': sessionDuration.inMinutes,
      'videos_watched': videosWatched,
      'quizzes_completed': quizzesCompleted,
      'xp_earned': xpEarned,
      'screens_visited': _sessionEvents
          .where((e) => e.event == AnalyticsEvent.screenView)
          .map((e) => e.params['screen_name'])
          .toSet()
          .length,
    };
  }

  /// Check if event is restricted for Junior segment (privacy)
  bool _isRestrictedEvent(AnalyticsEvent event) {
    // These events may contain sensitive data for minors
    // Currently no restrictions - add based on privacy policy
    const Set<AnalyticsEvent> restricted = {};
    return restricted.contains(event);
  }

  /// Send event to analytics backend
  Future<void> _sendToBackend(_AnalyticsEventRecord record) async {
    try {
      // Convert params to Map<String, Object> for Firebase
      final params = <String, Object>{};
      for (final entry in record.params.entries) {
        if (entry.value != null) {
          params[entry.key] = entry.value;
        }
      }

      // Add common params
      if (record.screen != null) {
        params['screen_name'] = record.screen!;
      }
      params['timestamp'] = record.timestamp.toIso8601String();

      // Send to Firebase Analytics
      await _firebaseAnalytics.logEvent(
        name: record.event.name,
        parameters: params,
      );
    } catch (e) {
      if (_debugMode) {
        debugPrint('[Analytics] Failed to send event: $e');
      }
    }
  }

  /// Flush pending events (call on app background/close)
  Future<void> flush() async {
    if (_debugMode) {
      debugPrint('[Analytics] Flushing ${_sessionEvents.length} events');
    }
    // Firebase Analytics handles batching automatically
    // Log session end event
    await _firebaseAnalytics.logEvent(
      name: 'session_end',
      parameters: {
        'duration_seconds': sessionDuration.inSeconds,
        'event_count': _sessionEvents.length,
      },
    );
  }

  /// Reset session (call on app open)
  void resetSession() {
    _sessionEvents.clear();
    _sessionStart = DateTime.now();
    if (_debugMode) {
      debugPrint('[Analytics] Session reset');
    }
  }
}

/// Internal event record
class _AnalyticsEventRecord {
  final AnalyticsEvent event;
  final Map<String, dynamic> params;
  final DateTime timestamp;
  final String? screen;

  _AnalyticsEventRecord({
    required this.event,
    required this.params,
    required this.timestamp,
    this.screen,
  });

  Map<String, dynamic> toJson() => {
        'event': event.name,
        'params': params,
        'timestamp': timestamp.toIso8601String(),
        'screen': screen,
      };
}

/// Global analytics instance
final analytics = AnalyticsService();

/// Extension for easy analytics tracking
extension AnalyticsExtension on AnalyticsEvent {
  void log([AnalyticsParams? params]) {
    analytics.logEvent(this, params);
  }
}
