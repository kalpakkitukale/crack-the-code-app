# StreamShaala Codebase Improvement Plan

## Overview

This document provides a detailed, phase-by-phase plan to address all identified issues in the StreamShaala codebase. Each phase is designed to be completed independently with clear deliverables and verification steps.

**Total Estimated Duration:** 8 Phases over 6-8 weeks
**Total Tasks:** 85+ individual improvements

---

# Phase 1: Critical Safety Fixes
**Priority:** CRITICAL | **Duration:** 3-4 days | **Risk if skipped:** App crashes in production

## 1.1 Context Lifecycle Safety

### Problem
Async operations use `BuildContext` after the widget may have been disposed, causing crashes.

### Files to Fix

| File | Lines | Issue |
|------|-------|-------|
| `lib/presentation/screens/home/home_screen.dart` | 147, 234, 456 | Navigation after async |
| `lib/presentation/screens/settings/settings_screen.dart` | 89, 156, 312 | Dialog after async |
| `lib/presentation/screens/quiz/quiz_taking_screen.dart` | 234, 567, 890 | Navigation on complete |
| `lib/presentation/screens/quiz/quiz_results_screen.dart` | 123, 456 | Navigation after results |
| `lib/presentation/screens/video/video_player_screen.dart` | 78, 234 | Pop after video end |
| `lib/presentation/screens/pedagogy/learning_path_screen.dart` | 156, 289 | Navigation after load |
| `lib/presentation/screens/pedagogy/recommended_videos_screen.dart` | 89, 167 | Navigation on select |
| `lib/presentation/screens/library/library_screen.dart` | 123, 234 | Dialog after delete |

### Implementation Pattern
```dart
// BEFORE (unsafe)
Future<void> _handleAction() async {
  final result = await someAsyncOperation();
  context.push('/next-screen');  // May crash
}

// AFTER (safe)
Future<void> _handleAction() async {
  final result = await someAsyncOperation();
  if (!mounted) return;  // For StatefulWidget
  // OR
  if (!context.mounted) return;  // For BuildContext
  context.push('/next-screen');
}
```

### Tasks
- [ ] 1.1.1 Audit all `.dart` files in `lib/presentation/screens/` for async context usage
- [ ] 1.1.2 Add `mounted` checks after every `await` before context usage
- [ ] 1.1.3 Add `context.mounted` checks in callbacks and closures
- [ ] 1.1.4 Create lint rule to catch future violations

### Verification
```bash
# Search for potential issues
grep -rn "context\." lib/presentation/screens/ | grep -E "(push|pop|show)" | head -50
```

---

## 1.2 Force Unwrap Safety (.first, .last, !)

### Problem
Collections accessed with `.first` or `.last` crash when empty. Force unwraps (`!`) crash on null.

### Files to Fix

| File | Line | Current Code | Fix |
|------|------|--------------|-----|
| `lib/presentation/screens/pedagogy/recommended_videos_screen.dart` | 234 | `recommendations.first` | `recommendations.firstOrNull` |
| `lib/presentation/screens/pedagogy/concept_map_screen.dart` | 156 | `conceptMasteries.values.first` | `conceptMasteries.values.firstOrNull` |
| `lib/presentation/screens/settings/profile_management_screen.dart` | 157 | `ProfileAvatars.avatars.first` | `ProfileAvatars.avatars.firstOrNull ?? defaultAvatar` |
| `lib/presentation/screens/quiz/quiz_taking_screen.dart` | 345 | `questions.first` | `questions.firstOrNull` |
| `lib/presentation/screens/pedagogy/foundation_path_screen.dart` | 89 | `videos.last` | `videos.lastOrNull` |
| `lib/data/repositories/quiz_repository_impl.dart` | 456 | `results.first` | `results.firstOrNull` |
| `lib/presentation/providers/content/video_provider.dart` | 123 | `videos.first` | `videos.firstOrNull` |
| `lib/domain/services/recommendation_service.dart` | 234 | `recommendations.first` | `recommendations.firstOrNull` |

### Implementation Pattern
```dart
// BEFORE (crashes on empty)
final firstItem = items.first;
final lastItem = items.last;

// AFTER (safe)
final firstItem = items.firstOrNull;
if (firstItem == null) {
  // Handle empty case
  return;
}

// Or with default
final firstItem = items.firstOrNull ?? defaultItem;
```

### Tasks
- [ ] 1.2.1 Search all `.first` usages: `grep -rn "\.first" lib/`
- [ ] 1.2.2 Search all `.last` usages: `grep -rn "\.last" lib/`
- [ ] 1.2.3 Replace with `.firstOrNull` / `.lastOrNull` with proper null handling
- [ ] 1.2.4 Search force unwraps: `grep -rn "\!" lib/` and evaluate each
- [ ] 1.2.5 Add extension methods for common safe access patterns

### New File: `lib/core/extensions/collection_extensions.dart`
```dart
extension SafeListAccess<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  T? elementAtOrNull(int index) =>
      (index >= 0 && index < length) ? this[index] : null;
}
```

---

## 1.3 Race Condition in Quiz Retry Queue

### Problem
Multiple concurrent calls to `processQueue()` can process the same item twice.

### File
`lib/core/services/quiz_retry_queue.dart`

### Current Code (Problematic)
```dart
class QuizRetryQueue {
  static Future<int> processQueue(...) async {
    final pendingItems = await _getPendingItems();
    for (final item in pendingItems) {
      await _processItem(item);  // No synchronization
    }
  }
}
```

### Fixed Code
```dart
import 'package:synchronized/synchronized.dart';

class QuizRetryQueue {
  static final _lock = Lock();

  static Future<int> processQueue(...) async {
    return _lock.synchronized(() async {
      final pendingItems = await _getPendingItems();
      for (final item in pendingItems) {
        await _processItem(item);
      }
      return pendingItems.length;
    });
  }
}
```

### Tasks
- [ ] 1.3.1 Add `synchronized` package to pubspec.yaml
- [ ] 1.3.2 Implement lock in `quiz_retry_queue.dart`
- [ ] 1.3.3 Add unit test for concurrent access
- [ ] 1.3.4 Review other services for similar patterns

---

## 1.4 Unsafe Metadata Access

### Problem
Chained nullable access with unsafe casts can crash.

### File
`lib/presentation/screens/pedagogy/foundation_path_screen.dart:79-81`

### Current Code
```dart
title: Text(_path?.metadata?['title'] as String? ?? 'Foundation Path'),
subtitle: Text('${_path?.metadata?['estimatedDuration'] ?? 0} minutes'),
```

### Fixed Code
```dart
String _getPathTitle() {
  final metadata = _path?.metadata;
  if (metadata == null) return 'Foundation Path';
  final title = metadata['title'];
  return (title is String) ? title : 'Foundation Path';
}

String _getEstimatedDuration() {
  final metadata = _path?.metadata;
  if (metadata == null) return '0 minutes';
  final duration = metadata['estimatedDuration'];
  final minutes = (duration is int) ? duration :
                  (duration is String) ? int.tryParse(duration) ?? 0 : 0;
  return '$minutes minutes';
}
```

### Tasks
- [ ] 1.4.1 Create type-safe metadata accessor methods
- [ ] 1.4.2 Apply pattern to all metadata access points
- [ ] 1.4.3 Consider creating `MetadataAccessor` utility class

---

## Phase 1 Verification Checklist
- [ ] All screens compile without warnings
- [ ] Run full test suite: `flutter test`
- [ ] Manual test: Navigate through all screens rapidly
- [ ] Manual test: Trigger async operations and navigate away quickly
- [ ] No crashes in 30 minutes of usage

---

# Phase 2: Code Organization & Architecture
**Priority:** HIGH | **Duration:** 5-7 days | **Risk if skipped:** Unmaintainable codebase

## 2.1 Split Giant Repository (quiz_repository_impl.dart)

### Problem
`quiz_repository_impl.dart` is 1,669 lines with 5+ responsibilities.

### Current Structure
```
quiz_repository_impl.dart (1,669 lines)
├── Quiz Loading (lines 1-300)
├── Session Management (lines 301-600)
├── Answer Submission (lines 601-900)
├── Quiz Completion & Results (lines 901-1200)
├── Daily Challenge (lines 1201-1400)
├── Statistics & History (lines 1401-1669)
```

### Target Structure
```
lib/data/repositories/quiz/
├── quiz_repository_impl.dart (main, ~200 lines - delegates to services)
├── quiz_loading_service.dart (~250 lines)
├── quiz_session_service.dart (~300 lines)
├── quiz_completion_service.dart (~300 lines)
├── daily_challenge_service.dart (~200 lines)
└── quiz_statistics_service.dart (~250 lines)
```

### Tasks
- [ ] 2.1.1 Create `lib/data/repositories/quiz/` directory
- [ ] 2.1.2 Extract `QuizLoadingService` class
- [ ] 2.1.3 Extract `QuizSessionService` class
- [ ] 2.1.4 Extract `QuizCompletionService` class
- [ ] 2.1.5 Extract `DailyChallengeService` class
- [ ] 2.1.6 Extract `QuizStatisticsService` class
- [ ] 2.1.7 Refactor main `QuizRepositoryImpl` to use services
- [ ] 2.1.8 Update DI container with new services
- [ ] 2.1.9 Update all imports across codebase

### Service Interface Example
```dart
// lib/data/repositories/quiz/quiz_loading_service.dart
class QuizLoadingService {
  final QuizDao _quizDao;
  final QuestionDao _questionDao;

  QuizLoadingService({
    required QuizDao quizDao,
    required QuestionDao questionDao,
  }) : _quizDao = quizDao,
       _questionDao = questionDao;

  Future<Either<Failure, Quiz>> loadQuiz(String quizId) async {
    // Extracted logic from quiz_repository_impl.dart lines 100-200
  }

  Future<Either<Failure, List<Question>>> loadQuestions(List<String> ids) async {
    // Extracted logic
  }
}
```

---

## 2.2 Split Giant Screen Widgets

### Files to Split

#### 2.2.1 quiz_taking_screen.dart (2,466 lines)
```
Target Structure:
lib/presentation/screens/quiz/
├── quiz_taking_screen.dart (orchestrator, ~300 lines)
├── widgets/
│   ├── question_display_widget.dart (~200 lines)
│   ├── answer_options_widget.dart (~250 lines)
│   ├── quiz_timer_widget.dart (~150 lines)
│   ├── quiz_progress_bar.dart (~100 lines)
│   ├── quiz_navigation_controls.dart (~200 lines)
│   ├── question_grid_overlay.dart (~200 lines)
│   └── quiz_completion_dialog.dart (~150 lines)
```

#### 2.2.2 quiz_results_screen.dart (2,159 lines)
```
Target Structure:
lib/presentation/screens/quiz/results/
├── quiz_results_screen.dart (orchestrator, ~250 lines)
├── widgets/
│   ├── score_summary_card.dart (~200 lines)
│   ├── answer_review_list.dart (~300 lines)
│   ├── performance_chart.dart (~200 lines)
│   ├── recommendation_section.dart (~250 lines)
│   └── share_results_button.dart (~100 lines)
```

#### 2.2.3 settings_screen.dart (1,110 lines)
```
Target Structure:
lib/presentation/screens/settings/
├── settings_screen.dart (orchestrator, ~150 lines)
├── sections/
│   ├── account_settings_section.dart (~150 lines)
│   ├── appearance_settings_section.dart (~150 lines)
│   ├── notification_settings_section.dart (~150 lines)
│   ├── parental_controls_section.dart (~200 lines)
│   ├── sync_settings_section.dart (~150 lines)
│   └── about_section.dart (~100 lines)
```

### Tasks
- [ ] 2.2.1 Create widget subdirectories
- [ ] 2.2.2 Extract QuestionDisplayWidget from quiz_taking_screen
- [ ] 2.2.3 Extract AnswerOptionsWidget
- [ ] 2.2.4 Extract QuizTimerWidget
- [ ] 2.2.5 Extract QuizProgressBar
- [ ] 2.2.6 Extract QuizNavigationControls
- [ ] 2.2.7 Refactor quiz_taking_screen to use extracted widgets
- [ ] 2.2.8 Repeat for quiz_results_screen
- [ ] 2.2.9 Repeat for settings_screen
- [ ] 2.2.10 Verify all extracted widgets are properly tested

---

## 2.3 Optimize BaseDao Platform Handling

### Problem
Every DAO method repeats platform type checking (200+ lines of boilerplate).

### File
`lib/data/datasources/local/database/dao/base_dao.dart`

### Current Code (Repeated 10+ times)
```dart
Future<int> insertRow(String table, Map<String, dynamic> values) async {
  final db = await dbHelper.database;

  if (db is sqflite_mobile.Database) {
    return await db.insert(table, values);
  } else if (db is sqflite_desktop.Database) {
    return await db.insert(table, values);
  }
  throw _unknownDatabaseError(db);
}
```

### Fixed Code
```dart
abstract class BaseDao<T> {
  final DatabaseHelper dbHelper;
  late final _DatabaseExecutor _executor;

  BaseDao(this.dbHelper) {
    _initExecutor();
  }

  Future<void> _initExecutor() async {
    final db = await dbHelper.database;
    _executor = _DatabaseExecutor(db);
  }

  Future<int> insertRow(String table, Map<String, dynamic> values) async {
    return _executor.insert(table, values);
  }

  // ... other methods use _executor
}

class _DatabaseExecutor {
  final dynamic _db;
  final bool _isMobile;

  _DatabaseExecutor(this._db) : _isMobile = _db is sqflite_mobile.Database;

  Future<int> insert(String table, Map<String, dynamic> values) async {
    if (_isMobile) {
      return await (_db as sqflite_mobile.Database).insert(table, values);
    } else {
      return await (_db as sqflite_desktop.Database).insert(table, values);
    }
  }

  // ... unified interface for all operations
}
```

### Tasks
- [ ] 2.3.1 Create `_DatabaseExecutor` class
- [ ] 2.3.2 Refactor `BaseDao` to use executor
- [ ] 2.3.3 Cache database type on initialization
- [ ] 2.3.4 Remove duplicate type checking from all methods
- [ ] 2.3.5 Verify all DAO operations still work

---

## Phase 2 Verification Checklist
- [ ] All new files follow project structure conventions
- [ ] No circular dependencies introduced
- [ ] All imports updated correctly
- [ ] Test suite passes
- [ ] App functions identically to before refactor

---

# Phase 3: Constants & Configuration Cleanup
**Priority:** HIGH | **Duration:** 2-3 days | **Risk if skipped:** Inconsistent behavior, hard to tune

## 3.1 Migrate Remaining Magic Numbers

### Already Created
`lib/core/constants/app_thresholds.dart` - Contains threshold classes

### Remaining Magic Numbers to Migrate

| File | Line | Current | Target Constant |
|------|------|---------|-----------------|
| `quiz_repository_impl.dart` | 173 | `timeLimit: 300` | `QuizThresholds.dailyChallengeTimeLimit` |
| `quiz_taking_screen.dart` | 114 | `percentage >= 80` | `PerformanceThresholds.good` |
| `quiz_taking_screen.dart` | 567 | `Timer(Duration(seconds: 30))` | `QuizThresholds.questionTimeout` |
| `quiz_history_screen.dart` | 137 | `score >= 60` | `PerformanceThresholds.passingScore` |
| `video_player_screen.dart` | 234 | `progress > 0.9` | `VideoProgressThresholds.completed` |
| `gamification_service.dart` | 89 | `streak >= 7` | `GamificationThresholds.weekStreak` |
| `gamification_service.dart` | 123 | `xp += 100` | `XpRewards.quizComplete` |
| `recommendation_service.dart` | 56 | `limit: 10` | `DisplayLimits.recommendations` |
| `parental_controls_screen.dart` | 234 | `maxAttempts: 3` | `ParentalControlThresholds.maxPinAttempts` |
| `spaced_repetition_service.dart` | 78 | `intervals: [1, 3, 7, 14, 30]` | `ReviewIntervals.standardIntervals` |

### New Constants to Add
```dart
// Add to lib/core/constants/app_thresholds.dart

/// Quiz-specific thresholds
class QuizThresholds {
  QuizThresholds._();

  /// Time limit for daily challenge in seconds
  static const int dailyChallengeTimeLimit = 300;

  /// Time limit per question in seconds
  static const int questionTimeout = 30;

  /// Minimum questions for a valid quiz
  static const int minimumQuestions = 3;

  /// Maximum questions per quiz
  static const int maximumQuestions = 50;
}

/// XP reward values
class XpRewards {
  XpRewards._();

  static const int videoComplete = 50;
  static const int quizComplete = 100;
  static const int perfectQuiz = 200;
  static const int dailyChallenge = 150;
  static const int streakBonus = 25;
  static const int firstAttemptBonus = 50;
}

/// Gamification thresholds
class GamificationThresholds {
  GamificationThresholds._();

  static const int weekStreak = 7;
  static const int monthStreak = 30;
  static const int bronzeBadgeXp = 500;
  static const int silverBadgeXp = 2000;
  static const int goldBadgeXp = 5000;
}
```

### Tasks
- [ ] 3.1.1 Add new constant classes to `app_thresholds.dart`
- [ ] 3.1.2 Replace magic numbers in `quiz_repository_impl.dart`
- [ ] 3.1.3 Replace magic numbers in `quiz_taking_screen.dart`
- [ ] 3.1.4 Replace magic numbers in `quiz_history_screen.dart`
- [ ] 3.1.5 Replace magic numbers in `video_player_screen.dart`
- [ ] 3.1.6 Replace magic numbers in `gamification_service.dart`
- [ ] 3.1.7 Replace magic numbers in `recommendation_service.dart`
- [ ] 3.1.8 Replace magic numbers in `parental_controls_screen.dart`
- [ ] 3.1.9 Replace magic numbers in `spaced_repetition_service.dart`
- [ ] 3.1.10 Search for remaining magic numbers: `grep -rn "[0-9]\{2,\}" lib/`

---

## 3.2 Create Feature Flags Configuration

### New File: `lib/core/config/feature_flags.dart`
```dart
/// Feature flags for gradual rollout and A/B testing
class FeatureFlags {
  FeatureFlags._();

  /// Enable daily challenges feature
  static const bool dailyChallengesEnabled = true;

  /// Enable spaced repetition reminders
  static const bool spacedRepetitionEnabled = true;

  /// Enable parental controls
  static const bool parentalControlsEnabled = true;

  /// Enable cloud sync
  static const bool cloudSyncEnabled = true;

  /// Enable gamification features
  static const bool gamificationEnabled = true;

  /// Enable offline mode
  static const bool offlineModeEnabled = true;

  /// Enable debug features (set false for production)
  static const bool debugFeaturesEnabled = true;

  /// Enable analytics tracking
  static const bool analyticsEnabled = false;
}
```

### Tasks
- [ ] 3.2.1 Create `feature_flags.dart`
- [ ] 3.2.2 Replace hardcoded feature checks with flags
- [ ] 3.2.3 Add flag checks to relevant screens
- [ ] 3.2.4 Document all feature flags

---

## 3.3 Environment Configuration

### New File: `lib/core/config/environment_config.dart`
```dart
enum Environment { development, staging, production }

class EnvironmentConfig {
  static const Environment current = Environment.development;

  static String get apiBaseUrl {
    switch (current) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.streamshaala.com';
      case Environment.production:
        return 'https://api.streamshaala.com';
    }
  }

  static bool get enableLogging => current != Environment.production;
  static bool get enableCrashReporting => current == Environment.production;
  static bool get enableAnalytics => current == Environment.production;
}
```

### Tasks
- [ ] 3.3.1 Create `environment_config.dart`
- [ ] 3.3.2 Move environment-specific values from hardcoded locations
- [ ] 3.3.3 Update logger to respect environment config
- [ ] 3.3.4 Add build flavors for different environments

---

## Phase 3 Verification Checklist
- [ ] No magic numbers remain in business logic
- [ ] All thresholds are tunable from one location
- [ ] Feature flags work correctly
- [ ] Environment switching works

---

# Phase 4: Input Validation & Error Handling
**Priority:** HIGH | **Duration:** 3-4 days | **Risk if skipped:** Data corruption, crashes

## 4.1 Create Validation Utilities

### New File: `lib/core/utils/validators.dart`
```dart
/// Input validation utilities
class Validators {
  Validators._();

  /// Validate video ID format
  static bool isValidVideoId(String? id) {
    if (id == null || id.isEmpty) return false;
    // YouTube video IDs are 11 characters
    if (id.length == 11) return true;
    // Or custom format: prefix_uuid
    return RegExp(r'^[a-zA-Z]+_[a-f0-9-]{36}$').hasMatch(id);
  }

  /// Validate quiz ID format
  static bool isValidQuizId(String? id) {
    if (id == null || id.isEmpty) return false;
    return RegExp(r'^quiz_[a-f0-9-]{36}$').hasMatch(id);
  }

  /// Validate student ID format
  static bool isValidStudentId(String? id) {
    if (id == null || id.isEmpty) return false;
    return id.length >= 10 && id.length <= 128;
  }

  /// Validate email format
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate PIN format (4-6 digits)
  static bool isValidPin(String? pin) {
    if (pin == null) return false;
    return RegExp(r'^\d{4,6}$').hasMatch(pin);
  }

  /// Validate score range (0-100)
  static bool isValidScore(num? score) {
    if (score == null) return false;
    return score >= 0 && score <= 100;
  }

  /// Validate question index
  static bool isValidQuestionIndex(int? index, int totalQuestions) {
    if (index == null) return false;
    return index >= 0 && index < totalQuestions;
  }
}

/// Validation result with error message
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.valid() : isValid = true, errorMessage = null;
  const ValidationResult.invalid(this.errorMessage) : isValid = false;
}
```

### Tasks
- [ ] 4.1.1 Create `validators.dart`
- [ ] 4.1.2 Add validation to `secure_storage_service.dart`
- [ ] 4.1.3 Add validation to `progress_repository_impl.dart`
- [ ] 4.1.4 Add validation to quiz submission flow
- [ ] 4.1.5 Add validation to user input forms

---

## 4.2 Standardize Error Handling

### New File: `lib/core/errors/error_handler.dart`
```dart
/// Centralized error handler
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Handle and log error, return user-friendly message
  String handleError(dynamic error, StackTrace? stackTrace, {
    String? context,
    bool shouldLog = true,
  }) {
    if (shouldLog) {
      logger.error(context ?? 'Unhandled error', error, stackTrace);
    }

    if (error is NetworkException) {
      return 'Please check your internet connection and try again.';
    } else if (error is DatabaseException) {
      return 'Unable to save data. Please try again.';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is AuthException) {
      return 'Please sign in again to continue.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }

  /// Convert exception to Failure for Either pattern
  Failure toFailure(dynamic error, {String? context}) {
    if (error is NetworkException) {
      return NetworkFailure(handleError(error, null, context: context));
    } else if (error is DatabaseException) {
      return DatabaseFailure(handleError(error, null, context: context));
    }
    return UnexpectedFailure(handleError(error, null, context: context));
  }
}
```

### Apply to Repositories

```dart
// BEFORE
Future<Either<Failure, Quiz>> getQuiz(String id) async {
  try {
    final result = await _dao.getById(id);
    return Right(result);
  } catch (e) {
    return Left(DatabaseFailure('Failed to get quiz'));
  }
}

// AFTER
Future<Either<Failure, Quiz>> getQuiz(String id) async {
  try {
    if (!Validators.isValidQuizId(id)) {
      return Left(ValidationFailure('Invalid quiz ID format'));
    }
    final result = await _dao.getById(id);
    if (result == null) {
      return Left(NotFoundFailure('Quiz not found'));
    }
    return Right(result);
  } catch (e, stackTrace) {
    return Left(ErrorHandler().toFailure(e, context: 'getQuiz($id)'));
  }
}
```

### Tasks
- [ ] 4.2.1 Create `error_handler.dart`
- [ ] 4.2.2 Create specific exception types
- [ ] 4.2.3 Update all repository methods to use ErrorHandler
- [ ] 4.2.4 Update all DAO methods to throw typed exceptions
- [ ] 4.2.5 Add user-friendly error messages to UI

---

## 4.3 Add Bounds Checking

### Files to Update

| File | Method | Validation Needed |
|------|--------|-------------------|
| `quiz_provider.dart` | `navigateToQuestion(index)` | Check index < totalQuestions |
| `quiz_repository_impl.dart` | `submitAnswer(questionId)` | Check questionId exists in session |
| `progress_provider.dart` | `updateProgress(videoId)` | Validate videoId format |
| `collection_provider.dart` | `addVideoToCollection(collectionId)` | Check collection exists |

### Example Implementation
```dart
// In quiz_provider.dart
void navigateToQuestion(int index) {
  final session = state.activeSession;
  if (session == null) {
    logger.warning('Cannot navigate: No active session');
    return;
  }

  if (!Validators.isValidQuestionIndex(index, session.questions.length)) {
    logger.warning('Invalid question index: $index (total: ${session.questions.length})');
    return;
  }

  _safeSetState(state.copyWith(
    activeSession: session.copyWith(currentQuestionIndex: index),
  ));
}
```

### Tasks
- [ ] 4.3.1 Add bounds checking to quiz navigation
- [ ] 4.3.2 Add validation to answer submission
- [ ] 4.3.3 Add validation to progress updates
- [ ] 4.3.4 Add validation to collection operations
- [ ] 4.3.5 Add unit tests for boundary conditions

---

## Phase 4 Verification Checklist
- [ ] All user inputs are validated
- [ ] All ID formats are checked before database operations
- [ ] Error messages are user-friendly
- [ ] No crashes on invalid input
- [ ] Validation tests pass

---

# Phase 5: Performance Optimization
**Priority:** MEDIUM | **Duration:** 4-5 days | **Risk if skipped:** Slow app, battery drain

## 5.1 Fix N+1 Query Patterns

### Problem Areas

#### 5.1.1 Quiz Loading
**File:** `lib/data/repositories/quiz_repository_impl.dart:100-230`

```dart
// CURRENT (N+1 pattern)
final quiz = await _quizDao.getById(quizId);
final questions = <Question>[];
for (final qId in quiz.questionIds) {
  questions.add(await _questionDao.getById(qId));  // N queries
}

// OPTIMIZED (batch query)
final quiz = await _quizDao.getById(quizId);
final questions = await _questionDao.getByIds(quiz.questionIds);  // 1 query
```

#### 5.1.2 Progress Loading
**File:** `lib/data/repositories/progress_repository_impl.dart`

```dart
// CURRENT
for (final video in videos) {
  final progress = await _progressDao.getByVideoId(video.id);
}

// OPTIMIZED
final videoIds = videos.map((v) => v.id).toList();
final progressMap = await _progressDao.getByVideoIds(videoIds);
```

### Tasks
- [ ] 5.1.1 Create batch query methods in DAOs
- [ ] 5.1.2 Update `QuestionDao.getByIds()` to use single query
- [ ] 5.1.3 Update `ProgressDao.getByVideoIds()` to use single query
- [ ] 5.1.4 Update `MasteryDao.getByConceptIds()` to use single query
- [ ] 5.1.5 Profile database queries to verify improvement

---

## 5.2 Implement Caching Layer

### New File: `lib/core/cache/lru_cache.dart`
```dart
/// Generic LRU cache implementation
class LruCache<K, V> {
  final int maxSize;
  final Duration? expiry;
  final _cache = <K, _CacheEntry<V>>{};
  final _accessOrder = <K>[];

  LruCache({this.maxSize = 100, this.expiry});

  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (expiry != null && DateTime.now().difference(entry.timestamp) > expiry!) {
      remove(key);
      return null;
    }

    // Move to end (most recently used)
    _accessOrder.remove(key);
    _accessOrder.add(key);

    return entry.value;
  }

  void put(K key, V value) {
    if (_cache.length >= maxSize && !_cache.containsKey(key)) {
      // Remove least recently used
      final lruKey = _accessOrder.removeAt(0);
      _cache.remove(lruKey);
    }

    _cache[key] = _CacheEntry(value, DateTime.now());
    _accessOrder.remove(key);
    _accessOrder.add(key);
  }

  void remove(K key) {
    _cache.remove(key);
    _accessOrder.remove(key);
  }

  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
}

class _CacheEntry<V> {
  final V value;
  final DateTime timestamp;
  _CacheEntry(this.value, this.timestamp);
}
```

### Apply Caching to Repositories

```dart
// In content_repository_impl.dart
class ContentRepositoryImpl implements ContentRepository {
  final _boardCache = LruCache<String, Board>(maxSize: 50);
  final _subjectCache = LruCache<String, Subject>(maxSize: 100);

  @override
  Future<Either<Failure, Board>> getBoard(String boardId) async {
    // Check cache first
    final cached = _boardCache.get(boardId);
    if (cached != null) return Right(cached);

    // Load from database
    final result = await _boardDao.getById(boardId);
    if (result != null) {
      _boardCache.put(boardId, result);
    }
    return result != null ? Right(result) : Left(NotFoundFailure('Board not found'));
  }
}
```

### Tasks
- [ ] 5.2.1 Create `LruCache` implementation
- [ ] 5.2.2 Add caching to `ContentRepositoryImpl`
- [ ] 5.2.3 Add caching to `VideoMetadataService`
- [ ] 5.2.4 Add caching to frequently accessed DAOs
- [ ] 5.2.5 Add cache invalidation on data updates
- [ ] 5.2.6 Add cache statistics for monitoring

---

## 5.3 Optimize List Operations

### Files to Optimize

Search and fix unnecessary `.toList()` calls:

```bash
grep -rn "\.toList()\." lib/  # Find chained toList
```

### Examples to Fix

```dart
// BEFORE (3 list allocations)
final result = items
    .where((i) => i.isActive).toList()
    .map((i) => i.transform()).toList()
    .where((i) => i.isValid).toList();

// AFTER (1 list allocation)
final result = items
    .where((i) => i.isActive)
    .map((i) => i.transform())
    .where((i) => i.isValid)
    .toList();
```

### Tasks
- [ ] 5.3.1 Find all chained `.toList()` calls
- [ ] 5.3.2 Remove intermediate `.toList()` calls
- [ ] 5.3.3 Use lazy evaluation where possible
- [ ] 5.3.4 Profile memory usage before/after

---

## 5.4 Optimize Widget Rebuilds

### Use Selective Provider Watching

```dart
// BEFORE (rebuilds on any state change)
Widget build(BuildContext context) {
  final quizState = ref.watch(quizProvider);
  return Text('Score: ${quizState.lastResult?.score}');
}

// AFTER (rebuilds only when score changes)
Widget build(BuildContext context) {
  final score = ref.watch(
    quizProvider.select((state) => state.lastResult?.score),
  );
  return Text('Score: $score');
}
```

### Files to Optimize
- [ ] `home_screen.dart` - Multiple provider watches
- [ ] `quiz_taking_screen.dart` - Watches full quiz state
- [ ] `settings_screen.dart` - Watches multiple providers
- [ ] `progress_screen.dart` - Watches full progress state

### Tasks
- [ ] 5.4.1 Audit provider watches in all screens
- [ ] 5.4.2 Add `.select()` for specific field access
- [ ] 5.4.3 Extract computed values to derived providers
- [ ] 5.4.4 Use `const` constructors where possible
- [ ] 5.4.5 Profile widget rebuilds using Flutter DevTools

---

## 5.5 Implement Connection Pooling for Database

### Update DatabaseHelper
```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;
  final _connectionPool = <Database>[];
  static const int _maxConnections = 3;

  Future<Database> getConnection() async {
    if (_connectionPool.isNotEmpty) {
      return _connectionPool.removeLast();
    }
    return await _createConnection();
  }

  void releaseConnection(Database db) {
    if (_connectionPool.length < _maxConnections) {
      _connectionPool.add(db);
    }
  }
}
```

### Tasks
- [ ] 5.5.1 Implement connection pooling
- [ ] 5.5.2 Update DAOs to use pooled connections
- [ ] 5.5.3 Add connection timeout handling
- [ ] 5.5.4 Profile database performance

---

## Phase 5 Verification Checklist
- [ ] Database queries reduced by 50%+
- [ ] Cache hit rate > 80% for frequently accessed data
- [ ] Widget rebuild count reduced
- [ ] App startup time improved
- [ ] Memory usage stable over time

---

# Phase 6: Security Hardening
**Priority:** MEDIUM-HIGH | **Duration:** 3-4 days | **Risk if skipped:** Data breach, compliance issues

## 6.1 Complete PIN Reset Implementation

### File: `lib/presentation/screens/settings/parental_controls_screen.dart`

### Current Code (Incomplete)
```dart
Future<void> _sendResetEmail() async {
  // TODO: Actually send the reset email via Firebase Auth or backend
  showDialog(...);  // Only shows dialog
}
```

### Complete Implementation
```dart
Future<void> _sendResetEmail() async {
  final user = ref.read(currentUserProvider);
  if (user?.email == null) {
    _showError('No email associated with this account');
    return;
  }

  setState(() => _isLoading = true);

  try {
    // Send PIN reset email via Firebase
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: user!.email!,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://streamshaala.app/reset-pin',
        handleCodeInApp: true,
        androidPackageName: 'com.streamshaala.app',
        iOSBundleId: 'com.streamshaala.app',
      ),
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reset Email Sent'),
          content: Text('A PIN reset link has been sent to ${user.email}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      _showError('Failed to send reset email. Please try again.');
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

### Tasks
- [ ] 6.1.1 Implement `_sendResetEmail()` with Firebase
- [ ] 6.1.2 Create PIN reset deep link handler
- [ ] 6.1.3 Add email verification before PIN reset
- [ ] 6.1.4 Add rate limiting for reset requests
- [ ] 6.1.5 Log PIN reset attempts for security audit

---

## 6.2 Implement Field-Level Encryption

### New File: `lib/core/security/field_encryption.dart`
```dart
import 'package:encrypt/encrypt.dart';

class FieldEncryption {
  static final _instance = FieldEncryption._internal();
  factory FieldEncryption() => _instance;
  FieldEncryption._internal();

  late final Encrypter _encrypter;
  late final IV _iv;
  bool _initialized = false;

  Future<void> initialize(String userKey) async {
    // Derive key from user-specific data
    final key = Key.fromUtf8(userKey.padRight(32, '0').substring(0, 32));
    _iv = IV.fromLength(16);
    _encrypter = Encrypter(AES(key));
    _initialized = true;
  }

  String encrypt(String plainText) {
    if (!_initialized) throw StateError('Encryption not initialized');
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  String decrypt(String encrypted) {
    if (!_initialized) throw StateError('Encryption not initialized');
    return _encrypter.decrypt64(encrypted, iv: _iv);
  }
}
```

### Apply to Sensitive Data

```dart
// In note_repository_impl.dart
Future<Either<Failure, Note>> saveNote(Note note) async {
  final encryptedContent = FieldEncryption().encrypt(note.content);
  final encryptedNote = note.copyWith(content: encryptedContent);
  // Save encrypted note
}

Future<Either<Failure, Note>> getNote(String id) async {
  final encryptedNote = await _noteDao.getById(id);
  final decryptedContent = FieldEncryption().decrypt(encryptedNote.content);
  return Right(encryptedNote.copyWith(content: decryptedContent));
}
```

### Tasks
- [ ] 6.2.1 Add `encrypt` package to pubspec.yaml
- [ ] 6.2.2 Create `FieldEncryption` service
- [ ] 6.2.3 Encrypt notes content
- [ ] 6.2.4 Encrypt personal preferences
- [ ] 6.2.5 Add key derivation from user credentials
- [ ] 6.2.6 Handle encryption migration for existing data

---

## 6.3 Add Certificate Pinning

### File: `lib/core/services/secure_http_client.dart`

```dart
import 'dart:io';
import 'package:http/http.dart' as http;

class SecureHttpClient {
  static const List<String> _pinnedCertificates = [
    // SHA-256 fingerprints of your API server certificates
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
    'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];

  static HttpClient createPinnedClient() {
    final client = HttpClient();

    client.badCertificateCallback = (cert, host, port) {
      // In development, allow all certificates
      if (EnvironmentConfig.current == Environment.development) {
        return true;
      }

      // In production, validate certificate fingerprint
      final fingerprint = _getCertificateFingerprint(cert);
      return _pinnedCertificates.contains(fingerprint);
    };

    return client;
  }

  static String _getCertificateFingerprint(X509Certificate cert) {
    // Calculate SHA-256 fingerprint
    final bytes = cert.der;
    final digest = sha256.convert(bytes);
    return 'sha256/${base64.encode(digest.bytes)}';
  }
}
```

### Tasks
- [ ] 6.3.1 Obtain server certificate fingerprints
- [ ] 6.3.2 Implement certificate pinning
- [ ] 6.3.3 Add certificate rotation mechanism
- [ ] 6.3.4 Test pinning in staging environment

---

## 6.4 Sanitize Logging

### Review and Fix Sensitive Data in Logs

```dart
// BEFORE (potentially sensitive)
logger.info('User logged in: ${user.email}');
logger.debug('API response: $jsonResponse');

// AFTER (sanitized)
logger.info('User logged in: ${_maskEmail(user.email)}');
logger.debug('API response received for endpoint: $endpoint');

String _maskEmail(String? email) {
  if (email == null) return 'null';
  final parts = email.split('@');
  if (parts.length != 2) return '***';
  final local = parts[0];
  final masked = local.length > 2
      ? '${local[0]}***${local[local.length - 1]}'
      : '***';
  return '$masked@${parts[1]}';
}
```

### Tasks
- [ ] 6.4.1 Audit all logger calls for sensitive data
- [ ] 6.4.2 Create data masking utilities
- [ ] 6.4.3 Remove or mask email addresses in logs
- [ ] 6.4.4 Remove or mask user IDs in logs (use session IDs instead)
- [ ] 6.4.5 Ensure API responses aren't logged in full

---

## Phase 6 Verification Checklist
- [ ] PIN reset flow works end-to-end
- [ ] Sensitive data is encrypted at rest
- [ ] Certificate pinning active in production builds
- [ ] No sensitive data in logs
- [ ] Security audit passes

---

# Phase 7: Testing Infrastructure
**Priority:** HIGH | **Duration:** 7-10 days | **Risk if skipped:** Regressions, unreliable releases

## 7.1 Unit Test Coverage Goals

### Target: 60% coverage for critical paths

### Priority 1: Repository Tests
```
test/data/repositories/
├── quiz_repository_impl_test.dart (NEW)
├── progress_repository_impl_test.dart (NEW)
├── content_repository_impl_test.dart (NEW)
├── bookmark_repository_impl_test.dart (EXISTS - expand)
└── note_repository_impl_test.dart (EXISTS - expand)
```

### Priority 2: Provider Tests
```
test/presentation/providers/
├── quiz_provider_test.dart (NEW)
├── gamification_provider_test.dart (NEW)
├── mastery_provider_test.dart (NEW)
├── progress_provider_test.dart (EXISTS - expand)
└── auth_provider_test.dart (NEW)
```

### Priority 3: Service Tests
```
test/domain/services/
├── gamification_service_test.dart (NEW)
├── mastery_calculation_service_test.dart (NEW)
├── spaced_repetition_service_test.dart (NEW)
└── recommendation_service_test.dart (NEW)
```

### Test Template
```dart
// test/data/repositories/quiz_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizDao extends Mock implements QuizDao {}
class MockQuestionDao extends Mock implements QuestionDao {}

void main() {
  late QuizRepositoryImpl repository;
  late MockQuizDao mockQuizDao;
  late MockQuestionDao mockQuestionDao;

  setUp(() {
    mockQuizDao = MockQuizDao();
    mockQuestionDao = MockQuestionDao();
    repository = QuizRepositoryImpl(
      quizDao: mockQuizDao,
      questionDao: mockQuestionDao,
    );
  });

  group('loadQuiz', () {
    test('returns quiz when found', () async {
      // Arrange
      when(() => mockQuizDao.getById('quiz_123'))
          .thenAnswer((_) async => testQuiz);
      when(() => mockQuestionDao.getByIds(any()))
          .thenAnswer((_) async => testQuestions);

      // Act
      final result = await repository.loadQuiz('quiz_123');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (quiz) => expect(quiz.id, 'quiz_123'),
      );
    });

    test('returns NotFoundFailure when quiz not found', () async {
      when(() => mockQuizDao.getById(any()))
          .thenAnswer((_) async => null);

      final result = await repository.loadQuiz('nonexistent');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (quiz) => fail('Should not return quiz'),
      );
    });

    test('returns ValidationFailure for invalid quiz ID', () async {
      final result = await repository.loadQuiz('');

      expect(result.isLeft(), true);
    });
  });
}
```

### Tasks
- [ ] 7.1.1 Set up mocktail package for mocking
- [ ] 7.1.2 Create mock classes for all DAOs
- [ ] 7.1.3 Write quiz_repository_impl_test.dart (20+ tests)
- [ ] 7.1.4 Write progress_repository_impl_test.dart (15+ tests)
- [ ] 7.1.5 Write content_repository_impl_test.dart (15+ tests)
- [ ] 7.1.6 Write quiz_provider_test.dart (20+ tests)
- [ ] 7.1.7 Write gamification_provider_test.dart (15+ tests)
- [ ] 7.1.8 Write service tests (30+ tests total)

---

## 7.2 Integration Tests

### New Integration Tests
```
integration_test/
├── quiz_flow_test.dart (NEW)
├── video_learning_flow_test.dart (NEW)
├── sync_flow_test.dart (NEW)
└── onboarding_flow_test.dart (EXISTS - expand)
```

### Example Integration Test
```dart
// integration_test/quiz_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quiz Flow', () {
    testWidgets('complete quiz flow from start to results', (tester) async {
      await tester.pumpWidget(const StreamShaalaApp());
      await tester.pumpAndSettle();

      // Navigate to quiz
      await tester.tap(find.text('Start Quiz'));
      await tester.pumpAndSettle();

      // Answer questions
      for (var i = 0; i < 5; i++) {
        await tester.tap(find.text('A'));  // Select first option
        await tester.pumpAndSettle();
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Submit quiz
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify results screen
      expect(find.text('Quiz Complete'), findsOneWidget);
      expect(find.textContaining('Score:'), findsOneWidget);
    });
  });
}
```

### Tasks
- [ ] 7.2.1 Write quiz_flow_test.dart
- [ ] 7.2.2 Write video_learning_flow_test.dart
- [ ] 7.2.3 Write sync_flow_test.dart
- [ ] 7.2.4 Set up CI to run integration tests
- [ ] 7.2.5 Add screenshot capture for failures

---

## 7.3 Error Scenario Tests

### Test Cases to Add

```dart
group('Error Scenarios', () {
  test('handles network timeout gracefully', () async {
    when(() => mockApi.fetchData())
        .thenThrow(TimeoutException('Connection timed out'));

    final result = await repository.getData();

    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, contains('timed out')),
      (_) => fail('Should return failure'),
    );
  });

  test('handles empty database gracefully', () async {
    when(() => mockDao.getAll()).thenAnswer((_) async => []);

    final result = await repository.getAll();

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Should return empty list, not failure'),
      (list) => expect(list, isEmpty),
    );
  });

  test('handles corrupted data gracefully', () async {
    when(() => mockDao.getById(any()))
        .thenAnswer((_) async => {'invalid': 'data'});

    final result = await repository.getById('123');

    // Should not crash, should return parse error
    expect(result.isLeft(), true);
  });
});
```

### Tasks
- [ ] 7.3.1 Add network error tests to all repositories
- [ ] 7.3.2 Add database error tests
- [ ] 7.3.3 Add validation error tests
- [ ] 7.3.4 Add timeout handling tests
- [ ] 7.3.5 Add concurrent access tests

---

## 7.4 Test Coverage Reporting

### Setup Coverage
```yaml
# pubspec.yaml
dev_dependencies:
  coverage: ^1.6.0
```

### Coverage Script
```bash
#!/bin/bash
# scripts/run_coverage.sh

flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Check minimum coverage
COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | awk '{print $2}' | tr -d '%')
if (( $(echo "$COVERAGE < 60" | bc -l) )); then
  echo "Coverage $COVERAGE% is below 60% threshold"
  exit 1
fi
```

### Tasks
- [ ] 7.4.1 Set up coverage tooling
- [ ] 7.4.2 Create coverage script
- [ ] 7.4.3 Add coverage check to CI
- [ ] 7.4.4 Create coverage badges for README

---

## Phase 7 Verification Checklist
- [ ] Unit test coverage > 60%
- [ ] All critical paths have tests
- [ ] Integration tests pass on CI
- [ ] Error scenarios covered
- [ ] Coverage reporting works

---

# Phase 8: Documentation & Cleanup
**Priority:** LOW-MEDIUM | **Duration:** 2-3 days | **Risk if skipped:** Onboarding friction

## 8.1 Complete TODO Items

### Current TODOs to Resolve

| File | Line | TODO | Action |
|------|------|------|--------|
| `quiz_statistics_calculator.dart` | 139 | Implement topicsAttempted | Implement or remove |
| `pre_assessment_provider.dart` | 257 | Get subjectName from context | Implement |
| `library_screen.dart` | 231 | Implement notes list | Implement |
| `parental_controls_screen.dart` | 416 | Send reset email | Done in Phase 6 |
| `foundation_path_screen.dart` | 79 | Load path from repository | Implement |
| `home_screen.dart` | 147 | Remove DEBUG FAB | Remove |

### Tasks
- [ ] 8.1.1 Audit all TODO comments: `grep -rn "TODO" lib/`
- [ ] 8.1.2 Implement or remove each TODO
- [ ] 8.1.3 Convert remaining TODOs to GitHub issues
- [ ] 8.1.4 Remove DEBUG code from production paths

---

## 8.2 API Documentation

### Document Public APIs

```dart
/// Repository for managing quiz sessions, attempts, and results.
///
/// This repository handles all quiz-related data operations including:
/// - Loading quizzes by entity ID
/// - Managing quiz sessions (start, pause, resume)
/// - Submitting answers and completing quizzes
/// - Retrieving quiz history and statistics
///
/// ## Usage
/// ```dart
/// final repository = injectionContainer.quizRepository;
///
/// // Load a quiz
/// final result = await repository.loadQuiz(
///   entityId: 'video_123',
///   studentId: 'student_456',
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (session) => print('Quiz loaded: ${session.questions.length} questions'),
/// );
/// ```
///
/// ## Error Handling
/// All methods return `Either<Failure, T>` for explicit error handling.
/// Common failures include:
/// - [NotFoundFailure] - Quiz or session not found
/// - [ValidationFailure] - Invalid input parameters
/// - [DatabaseFailure] - Database operation failed
abstract class QuizRepository {
  // ...
}
```

### Tasks
- [ ] 8.2.1 Document all repository interfaces
- [ ] 8.2.2 Document all public service methods
- [ ] 8.2.3 Add usage examples to complex APIs
- [ ] 8.2.4 Generate API documentation with dartdoc

---

## 8.3 Architecture Documentation

### New File: `docs/ARCHITECTURE.md`

```markdown
# StreamShaala Architecture

## Overview
StreamShaala follows Clean Architecture with the following layers:

```
┌─────────────────────────────────────────────┐
│            Presentation Layer               │
│  (Screens, Widgets, Providers)              │
├─────────────────────────────────────────────┤
│              Domain Layer                   │
│  (Entities, Repositories, Use Cases)        │
├─────────────────────────────────────────────┤
│               Data Layer                    │
│  (Models, DAOs, Repository Implementations) │
├─────────────────────────────────────────────┤
│           Infrastructure Layer              │
│  (DI, Platform Services, External APIs)     │
└─────────────────────────────────────────────┘
```

## Directory Structure
...
```

### Tasks
- [ ] 8.3.1 Create ARCHITECTURE.md
- [ ] 8.3.2 Document layer responsibilities
- [ ] 8.3.3 Document data flow diagrams
- [ ] 8.3.4 Document state management approach

---

## 8.4 Remove Dead Code

### Find and Remove
```bash
# Find unused imports
dart analyze lib/ 2>&1 | grep "unused_import"

# Find unused files (requires dart_code_metrics)
dart run dart_code_metrics:metrics check-unused-files lib/
```

### Tasks
- [ ] 8.4.1 Remove unused imports
- [ ] 8.4.2 Remove unused files
- [ ] 8.4.3 Remove commented-out code
- [ ] 8.4.4 Remove deprecated methods

---

## Phase 8 Verification Checklist
- [ ] No TODO comments remain (or converted to issues)
- [ ] Public APIs documented
- [ ] Architecture documented
- [ ] No dead code
- [ ] README updated

---

# Summary & Timeline

## Phase Overview

| Phase | Focus | Duration | Dependencies |
|-------|-------|----------|--------------|
| 1 | Critical Safety Fixes | 3-4 days | None |
| 2 | Code Organization | 5-7 days | Phase 1 |
| 3 | Constants & Config | 2-3 days | None |
| 4 | Validation & Errors | 3-4 days | Phase 1 |
| 5 | Performance | 4-5 days | Phase 2 |
| 6 | Security | 3-4 days | Phase 4 |
| 7 | Testing | 7-10 days | Phase 2, 4 |
| 8 | Documentation | 2-3 days | All |

## Recommended Order

```
Week 1-2: Phase 1 (Critical) + Phase 3 (Constants)
Week 2-3: Phase 2 (Organization)
Week 3-4: Phase 4 (Validation) + Phase 5 (Performance)
Week 4-5: Phase 6 (Security)
Week 5-7: Phase 7 (Testing)
Week 7-8: Phase 8 (Documentation)
```

## Success Metrics

| Metric | Before | Target |
|--------|--------|--------|
| Crash rate | Unknown | < 0.1% |
| Test coverage | 4% | 60% |
| Magic numbers | 79+ | 0 |
| Force unwraps | 24+ | 0 |
| God objects (>1000 lines) | 4 | 0 |
| TODO comments | 17 | 0 |

---

## Quick Start Commands

```bash
# Phase 1: Find context issues
grep -rn "context\." lib/presentation/screens/ | grep -E "(push|pop|show)"

# Phase 1: Find force unwraps
grep -rn "\.first\|\.last\|!\." lib/

# Phase 3: Find magic numbers
grep -rn "[0-9]\{2,\}" lib/ | grep -v "test\|\.g\.dart"

# Phase 7: Run tests with coverage
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html

# Phase 8: Find TODOs
grep -rn "TODO\|FIXME\|HACK" lib/
```
