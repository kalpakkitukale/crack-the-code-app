# StreamShaala Comprehensive Testing Guide v2.0

## Table of Contents
1. [Testing Philosophy](#1-testing-philosophy)
2. [Architecture Overview](#2-architecture-overview)
3. [Test Prioritization Framework](#3-test-prioritization-framework)
4. [Naming Conventions & Standards](#4-naming-conventions--standards)
5. [Riverpod State Management Testing](#5-riverpod-state-management-testing)
6. [Multi-Profile Data Isolation Testing](#6-multi-profile-data-isolation-testing)
7. [Segment/Flavor Testing Matrix](#7-segmentflavor-testing-matrix)
8. [Database & DAO Testing](#8-database--dao-testing)
9. [Domain Entity Testing](#9-domain-entity-testing)
10. [Use Case Testing](#10-use-case-testing)
11. [Widget & Screen Testing](#11-widget--screen-testing)
12. [Navigation & Routing Testing](#12-navigation--routing-testing)
13. [Integration Testing](#13-integration-testing)
14. [Performance Testing](#14-performance-testing)
15. [Accessibility Testing](#15-accessibility-testing)
16. [Security & Parental Controls Testing](#16-security--parental-controls-testing)
17. [Test Anti-Patterns](#17-test-anti-patterns)
18. [Debugging Failed Tests](#18-debugging-failed-tests)
19. [Test Infrastructure](#19-test-infrastructure)
20. [CI/CD Configuration](#20-cicd-configuration)

---

## 1. TESTING PHILOSOPHY

### 1.1 Core Principles

**The Testing Pyramid for StreamShaala:**
```
                    /\
                   /  \  E2E Integration (10%)
                  /----\  - Critical user journeys
                 /      \ - Multi-profile flows
                /--------\  Widget Tests (30%)
               /          \ - Screen states
              /            \ - User interactions
             /--------------\  Unit Tests (60%)
            /                \ - Entities, Use Cases
           /                  \ - DAOs, Providers
          /____________________\
```

**Why This Ratio:**
- Unit tests catch 80% of bugs, run in milliseconds
- Widget tests verify UI contracts without device overhead
- Integration tests validate real user scenarios but are slow/flaky

### 1.2 What Makes a Good Test

```dart
// GOOD: Descriptive, tests ONE behavior, clear arrange/act/assert
test('submitAnswer with valid answer updates session answers map and advances to next question', () {
  // Arrange
  final session = QuizSession(questions: [q1, q2], currentQuestionIndex: 0);
  notifier.state = QuizState(activeSession: session);

  // Act
  notifier.submitAnswer('q1', 'option_b');

  // Assert
  expect(notifier.state.activeSession!.answers['q1'], 'option_b');
  expect(notifier.state.activeSession!.currentQuestionIndex, 1);
});

// BAD: Vague name, tests multiple behaviors, no clear structure
test('quiz works', () {
  notifier.loadQuiz('q1');
  notifier.submitAnswer('q1', 'a');
  notifier.submitAnswer('q2', 'b');
  notifier.completeQuiz();
  expect(notifier.state.isLoading, false);
});
```

### 1.3 Test Independence Rules

1. **No Shared Mutable State**: Each test gets fresh instances
2. **No Test Order Dependencies**: Tests must pass in any order
3. **No External Dependencies**: Mock all I/O (database, network, filesystem)
4. **Deterministic**: Same input always produces same output (avoid `DateTime.now()` in tests)

### 1.4 The FIRST Principles

| Principle | Meaning | StreamShaala Application |
|-----------|---------|--------------------------|
| **F**ast | Tests run quickly | Unit tests < 10ms each |
| **I**solated | No inter-test dependencies | Fresh ProviderContainer per test |
| **R**epeatable | Same result every time | Mock time, UUIDs, random values |
| **S**elf-validating | Pass/fail is automatic | No manual inspection needed |
| **T**imely | Written with/before code | TDD for critical business logic |

---

## 2. ARCHITECTURE OVERVIEW

### 2.1 Technical Stack

| Component | Technology | Testing Strategy |
|-----------|------------|------------------|
| Architecture | Clean Architecture | Layer-isolated unit tests |
| State Management | Riverpod StateNotifierProvider | Provider override mocking |
| Database | SQLite (sqflite + sqflite_ffi) | In-memory database for tests |
| Navigation | GoRouter with shell routes | Route guard and redirect testing |
| Serialization | Freezed + json_serializable | JSON roundtrip testing |
| Error Handling | Dartz Either<Failure, T> | Left/Right path testing |
| Build Flavors | junior, middle, preboard, senior | Segment matrix testing |

### 2.2 Layer Dependencies

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │      Providers      │  │
│  │  (Widget    │  │  (Widget    │  │  (StateNotifier     │  │
│  │   Tests)    │  │   Tests)    │  │   Unit Tests)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────────────┐  ┌─────────────────────────────┐   │
│  │      Entities       │  │         Use Cases           │   │
│  │  (Unit Tests -      │  │  (Unit Tests - Mock Repos)  │   │
│  │   Pure Functions)   │  │                             │   │
│  └─────────────────────┘  └─────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────────────┐  ┌─────────────────────────────┐   │
│  │    Repositories     │  │           DAOs              │   │
│  │  (Integration Tests │  │  (In-Memory DB Unit Tests)  │   │
│  │   with Real DAOs)   │  │                             │   │
│  └─────────────────────┘  └─────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Critical Business Rules

| Rule | Implementation | Test Priority |
|------|----------------|---------------|
| Video Completion | 90% watched threshold | CRITICAL |
| Multi-Profile Isolation | profileId filtering in all DAOs | CRITICAL |
| XP Calculation | `level = sqrt(totalXp / 100)` | HIGH |
| Streak Logic | Consecutive calendar days | HIGH |
| Quiz Session Safety | Clear old session before loading new | CRITICAL |
| Answer Backup | 10-second undo window | MEDIUM |
| Segment UI Scaling | fontScaleFactor, buttonScaleFactor | MEDIUM |

---

## 3. TEST PRIORITIZATION FRAMEWORK

### 3.1 Risk-Based Priority Matrix

```
                    HIGH IMPACT
                         │
         ┌───────────────┼───────────────┐
         │   CRITICAL    │   IMPORTANT   │
         │  (Test First) │  (Test Soon)  │
HIGH     │               │               │
LIKELIHOOD│ • Multi-profile│ • Quiz scoring │
OF BUGS  │   isolation   │ • XP awards    │
         │ • Quiz session │ • Streak calc  │
         │   state mgmt  │               │
         │ • 90% video   │               │
         │   completion  │               │
         ├───────────────┼───────────────┤
         │   MODERATE    │    LOW        │
LOW      │  (Test Later) │  (Optional)   │
LIKELIHOOD│               │               │
OF BUGS  │ • UI overflow │ • Static text │
         │ • Navigation  │ • Theme colors│
         │   guards      │               │
         └───────────────┴───────────────┘
                    LOW IMPACT
```

### 3.2 Test Implementation Order

**Phase 1: Critical Path (Week 1)**
```
1. Multi-profile data isolation (ALL DAOs)
2. Quiz provider state transitions
3. Progress entity 90% threshold
4. SegmentConfig initialization
```

**Phase 2: Core Business Logic (Week 2)**
```
5. Use cases with Either<Failure, T>
6. All Freezed entity JSON roundtrips
7. Provider error state handling
8. Database CRUD operations
```

**Phase 3: UI & Integration (Week 3)**
```
9. Screen widget tests (states)
10. Overflow prevention tests
11. Navigation route tests
12. Integration test flows
```

**Phase 4: Edge Cases & Performance (Week 4)**
```
13. Boundary value tests
14. Performance benchmarks
15. Accessibility compliance
16. Security/parental controls
```

### 3.3 Coverage Targets

| Layer | Target | Rationale |
|-------|--------|-----------|
| Domain Entities | 100% | Pure functions, easy to test, foundation |
| Use Cases | 95% | Critical business logic |
| DAOs | 90% | Data integrity is paramount |
| Repositories | 90% | Error handling paths |
| Providers | 85% | State transitions |
| Widgets | 80% | User-facing, overflow prevention |
| Screens | 75% | Integration-like, slower |
| Overall | 85% | Industry standard for production |

---

## 4. NAMING CONVENTIONS & STANDARDS

### 4.1 Test File Naming

```
lib/domain/entities/progress.dart
  → test/domain/entities/progress_test.dart

lib/presentation/providers/user/quiz_provider.dart
  → test/presentation/providers/user/quiz_provider_test.dart

lib/data/datasources/local/database/dao/progress_dao.dart
  → test/data/dao/progress_dao_test.dart
```

### 4.2 Test Case Naming Pattern

**Format:** `[method/property]_[scenario]_[expectedBehavior]`

```dart
// Entity computed properties
test('progressFraction_withHalfWatched_returns0Point5', () { ... });
test('isCompleted_at89Percent_returnsFalse', () { ... });
test('isCompleted_at90Percent_returnsTrue', () { ... });

// Provider methods
test('loadQuiz_withValidId_setsActiveSessionAndResetsIndex', () { ... });
test('loadQuiz_withInvalidId_setsErrorState', () { ... });
test('loadQuiz_whileSessionActive_clearsOldSessionFirst', () { ... });

// DAO operations
test('getByVideoId_withMatchingProfile_returnsProgress', () { ... });
test('getByVideoId_withDifferentProfile_returnsNull', () { ... });
```

### 4.3 Group Organization

```dart
void main() {
  group('Progress', () {
    group('construction', () {
      test('fromJson_withValidJson_createsInstance', () { ... });
      test('toJson_preservesAllFields', () { ... });
    });

    group('progressFraction', () {
      test('withZeroTotal_returnsZero', () { ... });
      test('withHalfWatched_returns0Point5', () { ... });
      test('withOverWatched_returnsGreaterThan1', () { ... });
    });

    group('isCompleted', () {
      test('below90Percent_returnsFalse', () { ... });
      test('at90Percent_returnsTrue', () { ... });
      test('above90Percent_returnsTrue', () { ... });
    });
  });
}
```

### 4.4 Assertion Messages

Always include context in assertions for debugging:

```dart
// BAD: No context
expect(result.length, 5);

// GOOD: Clear context
expect(
  result.length,
  5,
  reason: 'Should return exactly 5 recommendations for low quiz score',
);

// GOOD: With actual values
expect(
  progress.completionPercentage,
  89,
  reason: 'watchDuration=534, totalDuration=600 should yield 89% (534/600*100)',
);
```

---

## 5. RIVERPOD STATE MANAGEMENT TESTING

### 5.1 StateNotifierProvider Testing Pattern

**Target Providers:**
- `lib/presentation/providers/user/quiz_provider.dart`
- `lib/presentation/providers/user/progress_provider.dart`
- `lib/presentation/providers/user/user_profile_provider.dart`

```dart
// test/presentation/providers/user/quiz_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

@GenerateMocks([
  LoadQuizUseCase,
  SubmitAnswerUseCase,
  CompleteQuizUseCase,
  QuizAttemptDao,
])
void main() {
  late MockLoadQuizUseCase mockLoadQuiz;
  late MockSubmitAnswerUseCase mockSubmitAnswer;
  late QuizNotifier notifier;

  setUp(() {
    mockLoadQuiz = MockLoadQuizUseCase();
    mockSubmitAnswer = MockSubmitAnswerUseCase();
    notifier = QuizNotifier(
      loadQuizUseCase: mockLoadQuiz,
      submitAnswerUseCase: mockSubmitAnswer,
    );
  });

  group('QuizNotifier', () {
    group('initial state', () {
      test('hasIsLoadingFalse_andNoActiveSession', () {
        expect(notifier.state.isLoading, false);
        expect(notifier.state.activeSession, isNull);
        expect(notifier.state.error, isNull);
      });
    });

    group('loadQuiz', () {
      test('clearsActiveSessionImmediately_beforeLoadingNew', () async {
        // CRITICAL: This tests the question swap bug prevention
        // Arrange - pre-populate with old session
        final oldSession = QuizSession(
          id: 'old-session',
          questions: [oldQuestion],
          currentQuestionIndex: 3,
        );
        notifier.state = notifier.state.copyWith(activeSession: oldSession);

        when(mockLoadQuiz.call(any)).thenAnswer(
          (_) async => Future.delayed(
            Duration(milliseconds: 100),
            () => Right(newSession),
          ),
        );

        // Act - start loading new quiz
        final future = notifier.loadQuiz('new-quiz-id');

        // Assert - IMMEDIATELY after call, old session should be null
        expect(
          notifier.state.activeSession,
          isNull,
          reason: 'Old session must be cleared immediately to prevent question swap bug',
        );
        expect(notifier.state.isLoading, true);

        await future;

        // After load completes
        expect(notifier.state.activeSession?.id, 'new-session');
        expect(notifier.state.activeSession?.currentQuestionIndex, 0);
      });

      test('withValidQuizId_setsActiveSessionWithIndexZero', () async {
        final session = QuizSession(
          questions: [q1, q2, q3],
          currentQuestionIndex: 0,
        );
        when(mockLoadQuiz.call(any)).thenAnswer((_) async => Right(session));

        await notifier.loadQuiz('quiz-123');

        expect(notifier.state.isLoading, false);
        expect(notifier.state.activeSession, isNotNull);
        expect(notifier.state.activeSession!.currentQuestionIndex, 0);
        expect(notifier.state.error, isNull);
      });

      test('withRepositoryError_setsErrorState', () async {
        when(mockLoadQuiz.call(any)).thenAnswer(
          (_) async => Left(DatabaseFailure('Quiz not found')),
        );

        await notifier.loadQuiz('invalid-id');

        expect(notifier.state.isLoading, false);
        expect(notifier.state.activeSession, isNull);
        expect(notifier.state.error, 'Quiz not found');
      });
    });

    group('submitAnswer', () {
      late QuizSession activeSession;

      setUp(() {
        activeSession = QuizSession(
          questions: [
            Question(id: 'q1', text: 'Q1', options: ['a', 'b', 'c', 'd']),
            Question(id: 'q2', text: 'Q2', options: ['a', 'b', 'c', 'd']),
          ],
          currentQuestionIndex: 0,
          answers: {},
        );
        notifier.state = notifier.state.copyWith(activeSession: activeSession);
      });

      test('withValidAnswer_updatesAnswersMap', () {
        notifier.submitAnswer('q1', 'option_b');

        expect(notifier.state.activeSession!.answers['q1'], 'option_b');
      });

      test('withValidAnswer_advancesToNextQuestion', () {
        notifier.submitAnswer('q1', 'option_b');

        expect(notifier.state.activeSession!.currentQuestionIndex, 1);
      });

      test('onLastQuestion_doesNotAdvanceBeyondEnd', () {
        notifier.state = notifier.state.copyWith(
          activeSession: activeSession.copyWith(currentQuestionIndex: 1),
        );

        notifier.submitAnswer('q2', 'option_a');

        expect(notifier.state.activeSession!.currentQuestionIndex, 1);
      });
    });

    group('clearAllAnswers', () {
      test('createsBackupBeforeClearing', () {
        final session = QuizSession(
          answers: {'q1': 'a', 'q2': 'b'},
          answersBackup: null,
        );
        notifier.state = notifier.state.copyWith(activeSession: session);

        notifier.clearAllAnswers();

        expect(notifier.state.activeSession!.answers, isEmpty);
        expect(notifier.state.activeSession!.answersBackup, {'q1': 'a', 'q2': 'b'});
      });
    });

    group('undoClearAllAnswers', () {
      test('restoresFromBackup_withinUndoWindow', () async {
        final session = QuizSession(
          answers: {},
          answersBackup: {'q1': 'a', 'q2': 'b'},
          backupTimestamp: DateTime.now(),
        );
        notifier.state = notifier.state.copyWith(activeSession: session);

        notifier.undoClearAllAnswers();

        expect(notifier.state.activeSession!.answers, {'q1': 'a', 'q2': 'b'});
        expect(notifier.state.activeSession!.answersBackup, isNull);
      });

      test('failsToRestore_afterUndoWindowExpires', () async {
        final session = QuizSession(
          answers: {},
          answersBackup: {'q1': 'a', 'q2': 'b'},
          backupTimestamp: DateTime.now().subtract(Duration(seconds: 11)),
        );
        notifier.state = notifier.state.copyWith(activeSession: session);

        notifier.undoClearAllAnswers();

        expect(
          notifier.state.activeSession!.answers,
          isEmpty,
          reason: '10-second undo window should have expired',
        );
      });
    });
  });
}
```

### 5.2 Provider Container Testing

```dart
// test/presentation/providers/provider_container_test.dart
void main() {
  group('Provider Dependencies', () {
    test('userGradeProvider_derivesFromActiveProfile', () {
      final container = ProviderContainer(
        overrides: [
          userProfileProvider.overrideWith((ref) {
            final notifier = MockUserProfileNotifier();
            when(notifier.state).thenReturn(UserProfileState(
              profile: UserProfile(grade: 7),
            ));
            return notifier;
          }),
        ],
      );

      expect(container.read(userGradeProvider), 7);
      container.dispose();
    });

    test('hasMultipleProfilesProvider_withTwoProfiles_returnsTrue', () {
      final container = ProviderContainer(
        overrides: [
          userProfileProvider.overrideWith((ref) {
            final notifier = MockUserProfileNotifier();
            when(notifier.state).thenReturn(UserProfileState(
              allProfiles: [profile1, profile2],
            ));
            return notifier;
          }),
        ],
      );

      expect(container.read(hasMultipleProfilesProvider), true);
      container.dispose();
    });

    test('hasMultipleProfilesProvider_withOneProfile_returnsFalse', () {
      final container = ProviderContainer(
        overrides: [
          userProfileProvider.overrideWith((ref) {
            final notifier = MockUserProfileNotifier();
            when(notifier.state).thenReturn(UserProfileState(
              allProfiles: [profile1],
            ));
            return notifier;
          }),
        ],
      );

      expect(container.read(hasMultipleProfilesProvider), false);
      container.dispose();
    });
  });
}
```

### 5.3 Async Provider Testing

```dart
group('Async Initialization', () {
  test('progressProvider_autoLoadsHistoryOnConstruction', () async {
    when(mockProgressDao.getAll(profileId: any)).thenAnswer(
      (_) async => [progress1, progress2],
    );

    final notifier = ProgressNotifier(progressDao: mockProgressDao);

    // Wait for async initialization
    await Future.delayed(Duration(milliseconds: 50));

    expect(notifier.state.watchHistory.length, 2);
    verify(mockProgressDao.getAll(profileId: any)).called(1);
  });

  test('progressProvider_handlesInitializationError', () async {
    when(mockProgressDao.getAll(profileId: any)).thenThrow(
      Exception('Database error'),
    );

    final notifier = ProgressNotifier(progressDao: mockProgressDao);

    await Future.delayed(Duration(milliseconds: 50));

    expect(notifier.state.error, contains('Database error'));
    expect(notifier.state.watchHistory, isEmpty);
  });
});
```

---

## 6. MULTI-PROFILE DATA ISOLATION TESTING

### 6.1 Profile-Scoped Data Access

**CRITICAL: This is the highest priority test category. Data leakage between profiles is a security/privacy issue.**

```dart
// test/data/dao/multi_profile_isolation_test.dart
@Tags(['database', 'critical'])
void main() {
  late ProgressDao progressDao;
  late QuizAttemptDao quizDao;
  late BookmarkDao bookmarkDao;
  late DatabaseHelper dbHelper;

  const profileA = 'profile-uuid-a';
  const profileB = 'profile-uuid-b';

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    dbHelper = await DatabaseHelper.inMemory();
    progressDao = ProgressDao(dbHelper);
    quizDao = QuizAttemptDao(dbHelper);
    bookmarkDao = BookmarkDao(dbHelper);
  });

  tearDown(() async {
    await dbHelper.close();
  });

  group('ProgressDao Profile Isolation', () {
    setUp(() async {
      // Seed identical data for both profiles
      await progressDao.insert(ProgressModel(
        id: 'progress-a-1',
        videoId: 'video-1',
        profileId: profileA,
        watchDuration: 100,
        totalDuration: 600,
      ));
      await progressDao.insert(ProgressModel(
        id: 'progress-b-1',
        videoId: 'video-1', // Same video!
        profileId: profileB,
        watchDuration: 300,
        totalDuration: 600,
      ));
    });

    test('getByVideoId_returnsOnlyMatchingProfileData', () async {
      final progressA = await progressDao.getByVideoId(
        'video-1',
        profileId: profileA,
      );
      final progressB = await progressDao.getByVideoId(
        'video-1',
        profileId: profileB,
      );

      expect(progressA?.watchDuration, 100, reason: 'Profile A watched 100s');
      expect(progressB?.watchDuration, 300, reason: 'Profile B watched 300s');
    });

    test('getAll_returnsOnlyMatchingProfileData', () async {
      await progressDao.insert(ProgressModel(
        id: 'progress-a-2',
        videoId: 'video-2',
        profileId: profileA,
        watchDuration: 50,
      ));

      final allA = await progressDao.getAll(profileId: profileA);
      final allB = await progressDao.getAll(profileId: profileB);

      expect(allA.length, 2, reason: 'Profile A has 2 videos');
      expect(allB.length, 1, reason: 'Profile B has 1 video');
    });

    test('getStatistics_areProfileScoped', () async {
      final statsA = await progressDao.getStatistics(profileId: profileA);
      final statsB = await progressDao.getStatistics(profileId: profileB);

      expect(statsA['totalWatchTime'], 100);
      expect(statsB['totalWatchTime'], 300);
    });

    test('deleteAllForProfile_removesOnlyThatProfileData', () async {
      await progressDao.deleteAllForProfile(profileA);

      final allA = await progressDao.getAll(profileId: profileA);
      final allB = await progressDao.getAll(profileId: profileB);

      expect(allA, isEmpty, reason: 'Profile A data should be deleted');
      expect(allB.length, 1, reason: 'Profile B data should be intact');
    });
  });

  group('Cross-DAO Profile Isolation', () {
    test('profileDeletion_cascadesToAllDAOs', () async {
      // Seed data across all DAOs for profile A
      await progressDao.insert(ProgressModel(
        id: 'p1',
        profileId: profileA,
        videoId: 'v1',
      ));
      await quizDao.insert(QuizAttemptModel(
        id: 'q1',
        profileId: profileA,
        quizId: 'quiz1',
      ));
      await bookmarkDao.insert(BookmarkModel(
        id: 'b1',
        profileId: profileA,
        videoId: 'v1',
      ));

      // Delete profile A data
      await progressDao.deleteAllForProfile(profileA);
      await quizDao.deleteAllForProfile(profileA);
      await bookmarkDao.deleteAllForProfile(profileA);

      // Verify all data is gone
      expect(await progressDao.getAll(profileId: profileA), isEmpty);
      expect(await quizDao.getAll(profileId: profileA), isEmpty);
      expect(await bookmarkDao.getAll(profileId: profileA), isEmpty);
    });
  });
}
```

### 6.2 Profile Boundary Value Tests

```dart
group('Profile ID Boundary Cases', () {
  test('emptyProfileId_returnsNoData', () async {
    final result = await progressDao.getAll(profileId: '');
    expect(result, isEmpty);
  });

  test('nullSafeProfileId_handlesGracefully', () async {
    // Simulating migration scenario where old data might not have profileId
    final result = await progressDao.getByVideoId('video-1', profileId: 'default');
    expect(result, isNull);
  });

  test('specialCharactersInProfileId_workCorrectly', () async {
    const specialProfileId = 'profile-with-special_chars.123';
    await progressDao.insert(ProgressModel(
      id: 'p1',
      profileId: specialProfileId,
      videoId: 'v1',
    ));

    final result = await progressDao.getAll(profileId: specialProfileId);
    expect(result.length, 1);
  });
});
```

---

## 7. SEGMENT/FLAVOR TESTING MATRIX

### 7.1 Segment Configuration Testing

```dart
// test/core/config/segment_config_test.dart
@Tags(['segment'])
void main() {
  tearDown(() {
    // Reset to default after each test
    SegmentConfig.reset();
  });

  group('SegmentConfig Initialization', () {
    test('junior_hasCorrectGradeRange', () {
      SegmentConfig.initialize(AppSegment.junior);
      expect(SegmentConfig.settings.grades, [4, 5, 6, 7]);
    });

    test('middle_hasCorrectGradeRange', () {
      SegmentConfig.initialize(AppSegment.middle);
      expect(SegmentConfig.settings.grades, [7, 8, 9]);
    });

    test('preboard_hasCorrectGradeRange', () {
      SegmentConfig.initialize(AppSegment.preboard);
      expect(SegmentConfig.settings.grades, [10]);
    });

    test('senior_hasCorrectGradeRange', () {
      SegmentConfig.initialize(AppSegment.senior);
      expect(SegmentConfig.settings.grades, [11, 12]);
    });
  });

  group('Segment Feature Flags', () {
    final featureMatrix = {
      AppSegment.junior: {
        'hasParentalControls': true,
        'showStreams': false,
        'showSearchInBottomNav': false,
        'gamificationLevel': GamificationLevel.high,
      },
      AppSegment.middle: {
        'hasParentalControls': false,
        'showStreams': false,
        'showSearchInBottomNav': false,
        'gamificationLevel': GamificationLevel.medium,
      },
      AppSegment.preboard: {
        'hasParentalControls': false,
        'showStreams': false,
        'showSearchInBottomNav': true,
        'gamificationLevel': GamificationLevel.low,
      },
      AppSegment.senior: {
        'hasParentalControls': false,
        'showStreams': true,
        'showSearchInBottomNav': true,
        'gamificationLevel': GamificationLevel.low,
      },
    };

    for (final entry in featureMatrix.entries) {
      final segment = entry.key;
      final expected = entry.value;

      group('${segment.name}', () {
        setUp(() => SegmentConfig.initialize(segment));

        test('hasParentalControls_is${expected['hasParentalControls']}', () {
          expect(
            SegmentConfig.settings.hasParentalControls,
            expected['hasParentalControls'],
          );
        });

        test('showStreams_is${expected['showStreams']}', () {
          expect(SegmentConfig.settings.showStreams, expected['showStreams']);
        });

        test('showSearchInBottomNav_is${expected['showSearchInBottomNav']}', () {
          expect(
            SegmentConfig.settings.showSearchInBottomNav,
            expected['showSearchInBottomNav'],
          );
        });

        test('gamificationLevel_is${expected['gamificationLevel']}', () {
          expect(
            SegmentConfig.settings.gamificationLevel,
            expected['gamificationLevel'],
          );
        });
      });
    }
  });

  group('UI Scaling', () {
    test('junior_hasLargerFontScale', () {
      SegmentConfig.initialize(AppSegment.junior);
      expect(SegmentConfig.settings.fontScaleFactor, 1.25);
    });

    test('senior_hasDefaultFontScale', () {
      SegmentConfig.initialize(AppSegment.senior);
      expect(SegmentConfig.settings.fontScaleFactor, 1.0);
    });
  });

  group('XP Multiplier', () {
    test('junior_has1Point5Multiplier', () {
      SegmentConfig.initialize(AppSegment.junior);
      expect(SegmentConfig.settings.xpMultiplier, 1.5);
    });

    test('middle_has1Point25Multiplier', () {
      SegmentConfig.initialize(AppSegment.middle);
      expect(SegmentConfig.settings.xpMultiplier, 1.25);
    });

    test('senior_has1Point0Multiplier', () {
      SegmentConfig.initialize(AppSegment.senior);
      expect(SegmentConfig.settings.xpMultiplier, 1.0);
    });
  });

  group('Quiz Configuration', () {
    test('junior_maxQuestions5', () {
      SegmentConfig.initialize(AppSegment.junior);
      expect(SegmentConfig.settings.maxQuizQuestions, 5);
    });

    test('middle_maxQuestions10', () {
      SegmentConfig.initialize(AppSegment.middle);
      expect(SegmentConfig.settings.maxQuizQuestions, 10);
    });

    test('preboard_maxQuestions20', () {
      SegmentConfig.initialize(AppSegment.preboard);
      expect(SegmentConfig.settings.maxQuizQuestions, 20);
    });

    test('senior_maxQuestions30', () {
      SegmentConfig.initialize(AppSegment.senior);
      expect(SegmentConfig.settings.maxQuizQuestions, 30);
    });
  });

  group('Database Names', () {
    test('eachSegment_hasUniqueDatabaseName', () {
      final dbNames = <String>{};
      for (final segment in AppSegment.values) {
        SegmentConfig.initialize(segment);
        final dbName = SegmentConfig.settings.databaseName;
        expect(
          dbNames.contains(dbName),
          false,
          reason: 'Database name $dbName is not unique',
        );
        dbNames.add(dbName);
      }
    });
  });
}
```

### 7.2 Segment Widget Tests

```dart
// test/presentation/screens/segment_specific_test.dart
@Tags(['widget', 'segment'])
void main() {
  group('Bottom Navigation by Segment', () {
    testWidgets('junior_shows4Items', (tester) async {
      SegmentConfig.initialize(AppSegment.junior);

      await tester.pumpWidget(
        ProviderScope(
          overrides: testOverrides,
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.items.length, 4);
      expect(find.byIcon(Icons.search), findsNothing);
    });

    testWidgets('senior_shows5ItemsWithSearch', (tester) async {
      SegmentConfig.initialize(AppSegment.senior);

      await tester.pumpWidget(
        ProviderScope(
          overrides: testOverrides,
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.items.length, 5);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('Onboarding by Segment', () {
    testWidgets('junior_showsJuniorOnboarding', (tester) async {
      SegmentConfig.initialize(AppSegment.junior);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnboardingCompleteProvider.overrideWithValue(false),
          ],
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(JuniorOnboardingScreen), findsOneWidget);
    });

    testWidgets('senior_showsStandardOnboarding', (tester) async {
      SegmentConfig.initialize(AppSegment.senior);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnboardingCompleteProvider.overrideWithValue(false),
          ],
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });
}
```

---

## 8. DATABASE & DAO TESTING

### 8.1 In-Memory Database Setup

```dart
// test/helpers/database_helpers.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<DatabaseHelper> createTestDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return DatabaseHelper.inMemory();
}

extension DatabaseTestHelpers on DatabaseHelper {
  Future<void> seedProgressData(List<ProgressModel> items) async {
    for (final item in items) {
      await progressDao.insert(item);
    }
  }

  Future<void> seedQuizData(List<QuizAttemptModel> items) async {
    for (final item in items) {
      await quizAttemptDao.insert(item);
    }
  }
}
```

### 8.2 DAO CRUD Testing

```dart
// test/data/dao/progress_dao_test.dart
@Tags(['database'])
void main() {
  late ProgressDao dao;
  late DatabaseHelper db;
  const testProfileId = 'test-profile';

  setUp(() async {
    db = await createTestDatabase();
    dao = ProgressDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ProgressDao', () {
    group('insert', () {
      test('createsNewRecord', () async {
        final progress = ProgressModel(
          id: 'test-id',
          videoId: 'video-1',
          profileId: testProfileId,
          watchDuration: 100,
          totalDuration: 600,
        );

        await dao.insert(progress);

        final retrieved = await dao.getByVideoId(
          'video-1',
          profileId: testProfileId,
        );
        expect(retrieved, isNotNull);
        expect(retrieved!.watchDuration, 100);
      });

      test('withDuplicateId_throws', () async {
        final progress = ProgressModel(id: 'dup-id', videoId: 'v1', profileId: testProfileId);
        await dao.insert(progress);

        expect(
          () => dao.insert(progress),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('update', () {
      test('modifiesExistingRecord', () async {
        await dao.insert(ProgressModel(
          id: 'test-id',
          videoId: 'video-1',
          profileId: testProfileId,
          watchDuration: 100,
        ));

        await dao.update(ProgressModel(
          id: 'test-id',
          videoId: 'video-1',
          profileId: testProfileId,
          watchDuration: 500,
        ));

        final retrieved = await dao.getByVideoId('video-1', profileId: testProfileId);
        expect(retrieved!.watchDuration, 500);
      });
    });

    group('getInProgress', () {
      test('returnsVideosBelow90Percent', () async {
        await dao.insert(ProgressModel(
          id: '1',
          videoId: 'v1',
          profileId: testProfileId,
          watchDuration: 50,
          totalDuration: 100,
        )); // 50%
        await dao.insert(ProgressModel(
          id: '2',
          videoId: 'v2',
          profileId: testProfileId,
          watchDuration: 89,
          totalDuration: 100,
        )); // 89%
        await dao.insert(ProgressModel(
          id: '3',
          videoId: 'v3',
          profileId: testProfileId,
          watchDuration: 90,
          totalDuration: 100,
        )); // 90% - completed

        final inProgress = await dao.getInProgress(profileId: testProfileId);

        expect(inProgress.length, 2);
        expect(inProgress.map((p) => p.videoId), containsAll(['v1', 'v2']));
      });
    });

    group('getCompleted', () {
      test('returnsVideosAt90PercentOrAbove', () async {
        await dao.insert(ProgressModel(
          id: '1',
          videoId: 'v1',
          profileId: testProfileId,
          watchDuration: 89,
          totalDuration: 100,
        )); // 89%
        await dao.insert(ProgressModel(
          id: '2',
          videoId: 'v2',
          profileId: testProfileId,
          watchDuration: 90,
          totalDuration: 100,
        )); // 90%
        await dao.insert(ProgressModel(
          id: '3',
          videoId: 'v3',
          profileId: testProfileId,
          watchDuration: 100,
          totalDuration: 100,
        )); // 100%

        final completed = await dao.getCompleted(profileId: testProfileId);

        expect(completed.length, 2);
        expect(completed.map((p) => p.videoId), containsAll(['v2', 'v3']));
      });
    });
  });
}
```

### 8.3 Complex Query Testing

```dart
group('QuizAttemptDao Advanced Queries', () {
  test('getFiltered_appliesAllCriteria', () async {
    // Seed varied quiz attempts
    await seedQuizAttempts([
      QuizAttemptModel(subjectId: 'math', scorePercentage: 85, attemptDate: today),
      QuizAttemptModel(subjectId: 'math', scorePercentage: 65, attemptDate: today),
      QuizAttemptModel(subjectId: 'science', scorePercentage: 90, attemptDate: today),
      QuizAttemptModel(subjectId: 'math', scorePercentage: 75, attemptDate: lastWeek),
    ]);

    final filtered = await dao.getFiltered(
      profileId: testProfileId,
      filters: QuizFilters(
        subjectId: 'math',
        minScore: 70,
        dateRange: DateRange(start: yesterday, end: tomorrow),
      ),
    );

    expect(filtered.length, 1);
    expect(filtered.first.scorePercentage, 85);
  });

  test('getStreakData_calculatesConsecutiveDays', () async {
    await seedQuizAttempts([
      QuizAttemptModel(attemptDate: DateTime(2024, 1, 1)),
      QuizAttemptModel(attemptDate: DateTime(2024, 1, 2)),
      QuizAttemptModel(attemptDate: DateTime(2024, 1, 3)),
      // Gap on Jan 4
      QuizAttemptModel(attemptDate: DateTime(2024, 1, 5)),
    ]);

    final streaks = await dao.getStreakData(profileId: testProfileId);

    // Streak of 3 ending Jan 3, streak of 1 on Jan 5
    expect(streaks[DateTime(2024, 1, 3)], 3);
    expect(streaks[DateTime(2024, 1, 5)], 1);
  });
});
```

---

## 9. DOMAIN ENTITY TESTING

### 9.1 Freezed Entity Pattern

```dart
// test/domain/entities/progress_test.dart
void main() {
  group('Progress', () {
    group('JSON Serialization', () {
      test('fromJson_toJson_roundtrip', () {
        final original = Progress(
          id: 'test-id',
          videoId: 'video-1',
          title: 'Test Video',
          channelName: 'Test Channel',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          watchDuration: 540,
          totalDuration: 600,
          completed: true,
          lastWatched: DateTime(2024, 1, 15, 10, 30),
        );

        final json = original.toJson();
        final restored = Progress.fromJson(json);

        expect(restored, original);
      });

      test('fromJson_withMissingOptionalFields_usesDefaults', () {
        final json = {
          'id': 'id-1',
          'videoId': 'v1',
          'watchDuration': 100,
          'totalDuration': 600,
        };

        final progress = Progress.fromJson(json);

        expect(progress.title, isNull);
        expect(progress.completed, false);
      });
    });

    group('copyWith', () {
      test('createsNewInstanceWithUpdatedFields', () {
        final original = Progress(watchDuration: 100, totalDuration: 600);
        final updated = original.copyWith(watchDuration: 200);

        expect(updated.watchDuration, 200);
        expect(updated.totalDuration, 600);
        expect(original.watchDuration, 100, reason: 'Original unchanged');
      });
    });

    group('progressFraction', () {
      test('withZeroTotal_returnsZero', () {
        final progress = Progress(watchDuration: 100, totalDuration: 0);
        expect(progress.progressFraction, 0);
      });

      test('withHalfWatched_returns0Point5', () {
        final progress = Progress(watchDuration: 300, totalDuration: 600);
        expect(progress.progressFraction, 0.5);
      });

      test('withOverwatched_returnsGreaterThan1', () {
        final progress = Progress(watchDuration: 700, totalDuration: 600);
        expect(progress.progressFraction, closeTo(1.167, 0.001));
      });
    });

    group('completionPercentage', () {
      test('returnsIntegerPercentage', () {
        final progress = Progress(watchDuration: 456, totalDuration: 600);
        expect(progress.completionPercentage, 76);
      });
    });

    group('isCompleted (90% threshold)', () {
      test('at89Percent_returnsFalse', () {
        final progress = Progress(watchDuration: 534, totalDuration: 600);
        expect(progress.isCompleted, false);
      });

      test('at90Percent_returnsTrue', () {
        final progress = Progress(watchDuration: 540, totalDuration: 600);
        expect(progress.isCompleted, true);
      });

      test('at100Percent_returnsTrue', () {
        final progress = Progress(watchDuration: 600, totalDuration: 600);
        expect(progress.isCompleted, true);
      });

      test('withZeroTotal_returnsFalse', () {
        final progress = Progress(watchDuration: 0, totalDuration: 0);
        expect(progress.isCompleted, false);
      });
    });

    group('Boundary Value Analysis', () {
      final boundaryTestCases = [
        (watchDuration: 0, totalDuration: 0, expectedComplete: false),
        (watchDuration: 0, totalDuration: 100, expectedComplete: false),
        (watchDuration: 89, totalDuration: 100, expectedComplete: false),
        (watchDuration: 90, totalDuration: 100, expectedComplete: true),
        (watchDuration: 91, totalDuration: 100, expectedComplete: true),
        (watchDuration: 100, totalDuration: 100, expectedComplete: true),
        (watchDuration: 150, totalDuration: 100, expectedComplete: true),
      ];

      for (final tc in boundaryTestCases) {
        test('watch${tc.watchDuration}_total${tc.totalDuration}_complete${tc.expectedComplete}', () {
          final progress = Progress(
            watchDuration: tc.watchDuration,
            totalDuration: tc.totalDuration,
          );
          expect(progress.isCompleted, tc.expectedComplete);
        });
      }
    });
  });
}
```

### 9.2 Quiz Session State Machine Testing

```dart
// test/domain/entities/quiz_session_test.dart
void main() {
  group('QuizSession State Machine', () {
    /*
     * State Machine:
     *
     *   NOT_STARTED ──[loadQuiz]──> IN_PROGRESS
     *                                   │
     *                    ┌──────────────┼──────────────┐
     *                    │              │              │
     *              [submitAnswer]  [clearAnswers]  [timeout]
     *                    │              │              │
     *                    ▼              ▼              ▼
     *              IN_PROGRESS    IN_PROGRESS    COMPLETED
     *                    │
     *            [submitLastAnswer]
     *                    │
     *                    ▼
     *              COMPLETED
     */

    test('initialState_isNotStarted', () {
      final session = QuizSession.empty();
      expect(session.state, QuizSessionState.notStarted);
    });

    test('afterLoadingQuestions_isInProgress', () {
      final session = QuizSession(
        questions: [q1, q2, q3],
        state: QuizSessionState.inProgress,
      );
      expect(session.state, QuizSessionState.inProgress);
    });

    test('afterAllAnswered_canTransitionToCompleted', () {
      final session = QuizSession(
        questions: [q1, q2],
        answers: {'q1': 'a', 'q2': 'b'},
        state: QuizSessionState.inProgress,
      );

      expect(session.allQuestionsAnswered, true);
      expect(session.canComplete, true);
    });

    test('withPartialAnswers_cannotComplete', () {
      final session = QuizSession(
        questions: [q1, q2, q3],
        answers: {'q1': 'a'},
        state: QuizSessionState.inProgress,
      );

      expect(session.allQuestionsAnswered, false);
      expect(session.canComplete, false);
    });
  });

  group('QuizSession Navigation', () {
    test('currentQuestion_returnsCorrectQuestion', () {
      final session = QuizSession(
        questions: [q1, q2, q3],
        currentQuestionIndex: 1,
      );
      expect(session.currentQuestion, q2);
    });

    test('isFirstQuestion_trueAtIndex0', () {
      final session = QuizSession(questions: [q1, q2], currentQuestionIndex: 0);
      expect(session.isFirstQuestion, true);
    });

    test('isLastQuestion_trueAtLastIndex', () {
      final session = QuizSession(questions: [q1, q2], currentQuestionIndex: 1);
      expect(session.isLastQuestion, true);
    });

    test('progressPercentage_calculatesCorrectly', () {
      final session = QuizSession(
        questions: [q1, q2, q3, q4],
        answers: {'q1': 'a', 'q2': 'b'},
      );
      expect(session.progressPercentage, 50);
    });
  });
}
```

---

## 10. USE CASE TESTING

### 10.1 Either<Failure, T> Pattern

```dart
// test/domain/usecases/evaluate_quiz_usecase_test.dart
@GenerateMocks([QuizRepository])
void main() {
  late EvaluateQuizUseCase useCase;
  late MockQuizRepository mockRepository;

  setUp(() {
    mockRepository = MockQuizRepository();
    useCase = EvaluateQuizUseCase(mockRepository);
  });

  group('EvaluateQuizUseCase', () {
    group('Success Path (Right)', () {
      test('withValidSession_returnsQuizResult', () async {
        final session = QuizSession(
          questions: [q1, q2],
          answers: {'q1': 'correct', 'q2': 'correct'},
        );
        final expectedResult = QuizResult(scorePercentage: 100);

        when(mockRepository.evaluateQuiz(any))
          .thenAnswer((_) async => Right(expectedResult));

        final result = await useCase(EvaluateQuizParams(session: session));

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (quizResult) {
            expect(quizResult.scorePercentage, 100);
          },
        );
      });

      test('appliesSegmentXpMultiplier', () async {
        SegmentConfig.initialize(AppSegment.junior); // 1.5x multiplier

        when(mockRepository.evaluateQuiz(any))
          .thenAnswer((_) async => Right(QuizResult(
            scorePercentage: 80,
            baseXp: 100,
          )));

        final result = await useCase(EvaluateQuizParams(session: validSession));

        result.fold(
          (_) => fail('Should succeed'),
          (quizResult) {
            expect(quizResult.xpAwarded, 150); // 100 * 1.5
          },
        );
      });
    });

    group('Failure Path (Left)', () {
      test('withRepositoryError_returnsFailure', () async {
        when(mockRepository.evaluateQuiz(any))
          .thenAnswer((_) async => Left(DatabaseFailure('DB error')));

        final result = await useCase(EvaluateQuizParams(session: validSession));

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<DatabaseFailure>());
            expect(failure.message, 'DB error');
          },
          (_) => fail('Should not succeed'),
        );
      });

      test('withEmptySession_returnsValidationFailure', () async {
        final emptySession = QuizSession(questions: []);

        final result = await useCase(EvaluateQuizParams(session: emptySession));

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Should not succeed'),
        );
      });
    });
  });
}
```

---

## 11. WIDGET & SCREEN TESTING

### 11.1 Screen State Testing

```dart
// test/presentation/screens/quiz/quiz_taking_screen_test.dart
@Tags(['widget'])
void main() {
  late MockQuizNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockQuizNotifier();
  });

  Widget createWidget({QuizState? state}) {
    if (state != null) {
      when(mockNotifier.state).thenReturn(state);
    }

    return ProviderScope(
      overrides: [
        quizProvider.overrideWith((ref) => mockNotifier),
      ],
      child: MaterialApp(
        home: QuizTakingScreen(quizId: 'test-quiz', studentId: 'test-student'),
      ),
    );
  }

  group('QuizTakingScreen', () {
    testWidgets('loading_showsIndicator', (tester) async {
      await tester.pumpWidget(createWidget(
        state: QuizState(isLoading: true),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error_showsMessageAndRetryButton', (tester) async {
      await tester.pumpWidget(createWidget(
        state: QuizState(error: 'Failed to load quiz'),
      ));

      expect(find.text('Failed to load quiz'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      verify(mockNotifier.loadQuiz('test-quiz')).called(1);
    });

    testWidgets('loaded_displaysCurrentQuestion', (tester) async {
      await tester.pumpWidget(createWidget(
        state: QuizState(
          activeSession: QuizSession(
            questions: [Question(text: 'What is 2+2?', options: ['3', '4', '5', '6'])],
            currentQuestionIndex: 0,
          ),
        ),
      ));

      expect(find.text('What is 2+2?'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('selectingAnswer_callsSubmitAnswer', (tester) async {
      await tester.pumpWidget(createWidget(
        state: QuizState(
          activeSession: QuizSession(
            questions: [Question(id: 'q1', text: 'Q?', options: ['A', 'B'])],
            currentQuestionIndex: 0,
          ),
        ),
      ));

      await tester.tap(find.text('B'));
      await tester.pump();

      verify(mockNotifier.submitAnswer('q1', 'B')).called(1);
    });
  });
}
```

### 11.2 Overflow Prevention Testing

```dart
// test/presentation/widgets/overflow_prevention_test.dart
@Tags(['widget', 'overflow'])
void main() {
  final testSizes = [
    (width: 320.0, height: 568.0, name: 'iPhone SE'),
    (width: 375.0, height: 667.0, name: 'iPhone 8'),
    (width: 393.0, height: 852.0, name: 'iPhone 14'),
    (width: 768.0, height: 1024.0, name: 'iPad'),
  ];

  group('Overflow Prevention', () {
    for (final size in testSizes) {
      group(size.name, () {
        testWidgets('QuizHistoryItem_noOverflow', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: QuizHistoryItem(
                  quizName: 'Very Long Quiz Name That Could Potentially Overflow',
                  subjectName: 'Environmental Science and Social Studies',
                  assessmentType: AssessmentType.readiness,
                  scorePercentage: 85,
                  attemptDate: DateTime.now(),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });

        testWidgets('VideoCard_noOverflow', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: VideoCard(
                  title: 'Understanding Complex Mathematical Concepts: A Comprehensive Introduction',
                  channelName: 'Educational Content Creator Channel Name',
                  duration: Duration(minutes: 45),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });
      });
    }
  });
}
```

---

## 12. NAVIGATION & ROUTING TESTING

### 12.1 Route Guard Testing

```dart
// test/presentation/navigation/app_router_test.dart
void main() {
  group('AppRouter Redirects', () {
    testWidgets('notOnboarded_redirectsToOnboarding', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnboardingCompleteProvider.overrideWithValue(false),
          ],
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('onboarded_goesToHome', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnboardingCompleteProvider.overrideWithValue(true),
            ...defaultProviderOverrides,
          ],
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('junior_requiresGradeSelection', (tester) async {
      SegmentConfig.initialize(AppSegment.junior);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnboardingCompleteProvider.overrideWithValue(true),
            gradeSelectionCompleteProvider.overrideWithValue(false),
          ],
          child: MaterialApp.router(routerConfig: AppRouter.router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GradeSelectionScreen), findsOneWidget);
    });
  });
}
```

---

## 13. INTEGRATION TESTING

### 13.1 Critical User Flow

```dart
// integration_test/quiz_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quiz Taking Flow', () {
    setUp(() async {
      await DatabaseHelper.deleteAll();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    testWidgets('completeFlow_browseToQuizToResults', (tester) async {
      await tester.pumpWidget(StreamShaalaApp());
      await tester.pumpAndSettle();

      // Skip onboarding if shown
      if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
        await completeOnboarding(tester);
      }

      // Navigate to Browse
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();

      // Select subject
      await tester.tap(find.text('Mathematics'));
      await tester.pumpAndSettle();

      // Start quiz
      await tester.tap(find.text('Take Quiz'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizTakingScreen), findsOneWidget);

      // Answer all questions
      while (find.text('Submit').evaluate().isEmpty) {
        await tester.tap(find.byType(AnswerOption).first);
        await tester.pumpAndSettle();
        if (find.text('Next').evaluate().isNotEmpty) {
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
        }
      }

      // Submit
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizResultsScreen), findsOneWidget);
      expect(find.textContaining('%'), findsWidgets);
    });
  });
}
```

---

## 14. PERFORMANCE TESTING

### 14.1 Scroll Performance

```dart
group('Scroll Performance', () {
  testWidgets('quizHistory_smoothScrollWith100Items', (tester) async {
    // Seed data
    for (int i = 0; i < 100; i++) {
      await quizDao.insert(generateMockQuizResult(i));
    }

    await tester.pumpWidget(createTestApp(QuizHistoryScreen()));
    await tester.pumpAndSettle();

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < 50; i++) {
      await tester.fling(find.byType(ListView), Offset(0, -300), 3000);
      await tester.pump(Duration(milliseconds: 16));
    }

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    expect(tester.takeException(), isNull);
  });
});
```

### 14.2 Database Query Performance

```dart
group('Database Performance', () {
  test('quizHistoryQuery_under100ms_with1000Records', () async {
    for (int i = 0; i < 1000; i++) {
      await quizDao.insert(generateMockQuizResult(i));
    }

    final stopwatch = Stopwatch()..start();
    await quizDao.getFiltered(profileId: 'test', limit: 50);
    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  });
});
```

---

## 15. ACCESSIBILITY TESTING

```dart
group('Accessibility', () {
  testWidgets('touchTargets_meetMinimumSize', (tester) async {
    await tester.pumpWidget(MaterialApp(home: QuizTakingScreen()));

    final answerOption = tester.getRect(find.byType(AnswerOption).first);
    expect(answerOption.width, greaterThanOrEqualTo(48));
    expect(answerOption.height, greaterThanOrEqualTo(48));
  });

  testWidgets('interactiveElements_haveSemanticLabels', (tester) async {
    await tester.pumpWidget(MaterialApp(home: QuizTakingScreen()));

    final semantics = tester.getSemantics(find.byType(AnswerOption).first);
    expect(semantics.label, isNotEmpty);
  });
});
```

---

## 16. SECURITY & PARENTAL CONTROLS TESTING

```dart
// test/presentation/screens/settings/parental_controls_test.dart
@Tags(['security'])
void main() {
  setUp(() {
    SegmentConfig.initialize(AppSegment.junior);
  });

  group('Parental Controls', () {
    testWidgets('requiresPIN_toAccess', (tester) async {
      await tester.pumpWidget(createTestApp(SettingsScreen()));

      await tester.tap(find.text('Parental Controls'));
      await tester.pumpAndSettle();

      expect(find.byType(PinEntryDialog), findsOneWidget);
    });

    testWidgets('incorrectPIN_showsError', (tester) async {
      await prefs.setString('parental_pin', '1234');
      await tester.pumpWidget(createTestApp(SettingsScreen()));

      await tester.tap(find.text('Parental Controls'));
      await tester.pumpAndSettle();

      await enterPin(tester, '0000');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect PIN'), findsOneWidget);
    });
  });
}
```

---

## 17. TEST ANTI-PATTERNS

### Avoid These Patterns

```dart
// ANTI-PATTERN 1: Testing implementation details
// BAD
test('uses SharedPreferences to store data', () {
  // Tests HOW, not WHAT
});
// GOOD
test('persists user preference across sessions', () {
  // Tests behavior
});

// ANTI-PATTERN 2: Shared mutable state
// BAD
late QuizNotifier notifier; // Shared across tests
setUpAll(() => notifier = QuizNotifier());
// GOOD
setUp(() => notifier = QuizNotifier()); // Fresh each test

// ANTI-PATTERN 3: Non-deterministic tests
// BAD
test('handles timeout', () async {
  await Future.delayed(Duration(seconds: 11)); // Flaky!
});
// GOOD
test('handles timeout', () async {
  fakeAsync((async) {
    async.elapse(Duration(seconds: 11)); // Deterministic
  });
});

// ANTI-PATTERN 4: Testing multiple behaviors
// BAD
test('quiz flow works', () {
  notifier.loadQuiz('id');
  notifier.submitAnswer('q1', 'a');
  notifier.completeQuiz();
  // Which behavior failed?
});
// GOOD
test('loadQuiz sets active session', () { ... });
test('submitAnswer updates answers map', () { ... });
test('completeQuiz transitions to completed state', () { ... });
```

---

## 18. DEBUGGING FAILED TESTS

### 18.1 Common Failures and Solutions

| Symptom | Likely Cause | Solution |
|---------|--------------|----------|
| `Null check operator` | Provider not overridden | Add missing provider override |
| `No MediaQuery ancestor` | Missing MaterialApp | Wrap in MaterialApp |
| `pumpAndSettle timeout` | Infinite animation | Use `pump()` with duration |
| `State modification after dispose` | Async callback after test | Use `addTearDown` cleanup |
| `Database locked` | Previous test didn't close | Use `setUp/tearDown` for DB |

### 18.2 Debugging Techniques

```dart
// Print state during test
debugPrint('State: ${notifier.state}');

// Take screenshot in widget test
await binding.takeScreenshot('debug_screenshot');

// Verbose pump
await tester.pump();
debugPrint('Widget tree: ${find.byType(Widget).evaluate()}');

// Check semantics
final semantics = tester.getSemantics(find.byType(Button));
debugPrint('Semantics: $semantics');
```

---

## 19. TEST INFRASTRUCTURE

### 19.1 File Organization

```
test/
├── core/
│   └── config/
│       └── segment_config_test.dart
├── data/
│   ├── dao/
│   │   ├── progress_dao_test.dart
│   │   └── multi_profile_isolation_test.dart
│   └── repositories/
├── domain/
│   ├── entities/
│   │   ├── progress_test.dart
│   │   └── quiz_session_test.dart
│   └── usecases/
├── presentation/
│   ├── providers/
│   │   └── user/
│   │       ├── quiz_provider_test.dart
│   │       └── progress_provider_test.dart
│   ├── screens/
│   └── widgets/
│       └── overflow_prevention_test.dart
├── fixtures/
│   ├── quiz_fixtures.dart
│   └── progress_fixtures.dart
├── mocks/
│   └── mock_notifiers.dart
└── helpers/
    ├── database_helpers.dart
    └── test_app.dart

integration_test/
├── quiz_flow_test.dart
├── profile_management_test.dart
└── helpers/
```

### 19.2 Test Tags

```dart
@Tags(['unit'])           // Fast unit tests
@Tags(['widget'])         // Widget tests
@Tags(['database'])       // Requires DB setup
@Tags(['segment'])        // Segment-specific
@Tags(['critical'])       // Must pass before merge
@Tags(['slow'])           // Long-running
```

---

## 20. CI/CD CONFIGURATION

```yaml
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - run: flutter pub get
      - run: flutter test --coverage --tags=unit,widget,critical
      - uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info

  database-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: sudo apt-get install -y libsqlite3-dev
      - run: flutter pub get
      - run: flutter test --tags=database

  integration-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: |
          xcrun simctl boot "iPhone 15"
          flutter test integration_test/ --flavor junior -t lib/main_junior.dart
```

---

## QUICK REFERENCE

### Must-Test Before PR

1. Multi-profile data isolation
2. Quiz session state transitions (question swap prevention)
3. 90% video completion threshold
4. Segment-specific UI differences
5. Overflow prevention on cards
6. Either<Failure, T> both paths
7. Provider loading/error/success states

### Commands

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# By tag
flutter test --tags=critical
flutter test --exclude-tags=slow

# Single file
flutter test test/domain/entities/progress_test.dart

# Integration tests
flutter test integration_test/ --flavor junior
```

---

*This guide provides production-ready testing patterns for StreamShaala. Follow the prioritization framework to maximize test value with available time.*
