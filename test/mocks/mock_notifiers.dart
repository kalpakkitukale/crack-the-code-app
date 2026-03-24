/// Mock notifiers for testing
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/presentation/providers/user/quiz_provider.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/presentation/providers/user/user_profile_provider.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/domain/entities/user/progress.dart';

import '../fixtures/quiz_fixtures.dart';
import '../fixtures/progress_fixtures.dart';

/// Mock QuizNotifier for testing
/// Provides controllable state without real use cases
class MockQuizNotifier extends StateNotifier<QuizState> {
  MockQuizNotifier([QuizState? initialState])
      : super(initialState ?? QuizState.initial());

  /// Set state directly for testing
  void setState(QuizState newState) {
    state = newState;
  }

  /// Set active session
  void setActiveSession(QuizSession? session) {
    state = state.copyWith(
      activeSession: session,
      clearActiveSession: session == null,
    );
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error state
  void setError(String? error) {
    state = state.copyWith(error: error, clearError: error == null);
  }

  /// Set history
  void setHistory(List<QuizAttempt> history) {
    state = state.copyWith(history: history);
  }

  /// Simulate load quiz success
  void simulateLoadQuizSuccess(QuizSession session) {
    state = state.copyWith(
      activeSession: session.copyWith(currentQuestionIndex: 0),
      isLoading: false,
      clearError: true,
      clearLastResult: true,
    );
  }

  /// Simulate load quiz error
  void simulateLoadQuizError(String message) {
    state = state.copyWith(
      isLoading: false,
      error: message,
      clearActiveSession: true,
    );
  }

  /// Simulate complete quiz success
  void simulateCompleteQuizSuccess(QuizResult result) {
    state = state.copyWith(
      lastResult: result,
      isLoading: false,
      clearError: true,
      clearActiveSession: true,
    );
  }
}

/// Mock ProgressNotifier for testing
class MockProgressNotifier extends StateNotifier<ProgressState> {
  MockProgressNotifier([ProgressState? initialState])
      : super(initialState ?? ProgressState.initial());

  /// Set state directly for testing
  void setState(ProgressState newState) {
    state = newState;
  }

  /// Set watch history
  void setWatchHistory(List<Progress> history) {
    final progressMap = <String, Progress>{};
    for (final p in history) {
      progressMap[p.videoId] = p;
    }
    state = state.copyWith(
      watchHistory: history,
      progressMap: progressMap,
      isLoadingHistory: false,
    );
  }

  /// Set streaks
  void setStreaks({int currentStreak = 0, int longestStreak = 0}) {
    state = state.copyWith(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error state
  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  /// Add progress to history
  void addProgress(Progress progress) {
    final updatedHistory = [progress, ...state.watchHistory];
    final updatedMap = Map<String, Progress>.from(state.progressMap);
    updatedMap[progress.videoId] = progress;

    state = state.copyWith(
      watchHistory: updatedHistory,
      progressMap: updatedMap,
    );
  }

  /// Update existing progress
  void updateProgress(Progress progress) {
    final updatedHistory = state.watchHistory.map((p) {
      return p.videoId == progress.videoId ? progress : p;
    }).toList();

    final updatedMap = Map<String, Progress>.from(state.progressMap);
    updatedMap[progress.videoId] = progress;

    state = state.copyWith(
      watchHistory: updatedHistory,
      progressMap: updatedMap,
    );
  }
}

/// Mock UserProfileNotifier for testing
class MockUserProfileNotifier extends StateNotifier<UserProfileState> {
  MockUserProfileNotifier([UserProfileState? initialState])
      : super(initialState ?? const UserProfileState());

  /// Set state directly for testing
  void setState(UserProfileState newState) {
    state = newState;
  }

  /// Set active profile
  void setProfile(UserProfile profile) {
    state = state.copyWith(profile: profile);
  }

  /// Set all profiles
  void setAllProfiles(List<UserProfile> profiles) {
    state = state.copyWith(allProfiles: profiles);
  }

  /// Set onboarding complete
  void setOnboardingComplete(bool complete) {
    state = state.copyWith(onboardingComplete: complete);
  }

  /// Set grade selection complete
  void setGradeSelectionComplete(bool complete) {
    state = state.copyWith(gradeSelectionComplete: complete);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error state
  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  /// Add profile to list
  void addProfile(UserProfile profile) {
    final updatedProfiles = [...state.allProfiles, profile];
    state = state.copyWith(allProfiles: updatedProfiles);
  }

  /// Remove profile from list
  void removeProfile(String profileId) {
    final updatedProfiles = state.allProfiles.where((p) => p.id != profileId).toList();
    state = state.copyWith(allProfiles: updatedProfiles);
  }

  /// Switch active profile
  void switchProfile(String profileId) {
    final profile = state.allProfiles.firstWhere(
      (p) => p.id == profileId,
      orElse: () => state.profile,
    );
    state = state.copyWith(profile: profile);
  }
}

/// Create mock provider overrides for testing
List<Override> createMockOverrides({
  MockQuizNotifier? quizNotifier,
  MockProgressNotifier? progressNotifier,
  MockUserProfileNotifier? userProfileNotifier,
}) {
  final overrides = <Override>[];

  if (quizNotifier != null) {
    overrides.add(
      quizProvider.overrideWith((ref) => quizNotifier),
    );
  }

  if (progressNotifier != null) {
    overrides.add(
      progressProvider.overrideWith((ref) => progressNotifier),
    );
  }

  if (userProfileNotifier != null) {
    overrides.add(
      userProfileProvider.overrideWith((ref) => userProfileNotifier),
    );
  }

  return overrides;
}

/// Pre-configured mock states for common test scenarios
class MockStates {
  /// Quiz loaded and ready
  static QuizState get quizLoaded => QuizState(
        activeSession: QuizFixtures.inProgressSession.copyWith(currentQuestionIndex: 0),
        history: const [],
        isLoading: false,
      );

  /// Quiz loading
  static QuizState get quizLoading => const QuizState(
        history: [],
        isLoading: true,
      );

  /// Quiz error
  static QuizState get quizError => const QuizState(
        history: [],
        isLoading: false,
        error: 'Failed to load quiz',
      );

  /// Progress with history
  static ProgressState get progressWithHistory {
    final history = ProgressFixtures.sampleHistory;
    return ProgressState(
      watchHistory: history,
      progressMap: {for (final p in history) p.videoId: p},
      currentStreak: 3,
      longestStreak: 7,
      isLoading: false,
      isLoadingHistory: false,
    );
  }

  /// Progress empty
  static ProgressState get progressEmpty => const ProgressState(
        watchHistory: [],
        progressMap: {},
        isLoading: false,
        isLoadingHistory: false,
      );

  /// User with profile
  static UserProfileState get userWithProfile => UserProfileState(
        profile: UserProfile(
          id: 'test-uuid',
          name: 'Test Student',
          grade: 6,
          avatarId: 'bear',
        ),
        allProfiles: [
          UserProfile(
            id: 'test-uuid',
            name: 'Test Student',
            grade: 6,
            avatarId: 'bear',
          ),
        ],
        onboardingComplete: true,
        gradeSelectionComplete: true,
      );

  /// User without profile (needs onboarding)
  static UserProfileState get userNeedsOnboarding => const UserProfileState(
        onboardingComplete: false,
        gradeSelectionComplete: false,
      );

  /// Multiple profiles
  static UserProfileState get multipleProfiles => UserProfileState(
        profile: UserProfile(
          id: 'uuid-1',
          name: 'Alice',
          grade: 5,
          avatarId: 'cat',
        ),
        allProfiles: [
          UserProfile(
            id: 'uuid-1',
            name: 'Alice',
            grade: 5,
            avatarId: 'cat',
          ),
          UserProfile(
            id: 'uuid-2',
            name: 'Bob',
            grade: 7,
            avatarId: 'dog',
          ),
        ],
        onboardingComplete: true,
        gradeSelectionComplete: true,
      );
}
