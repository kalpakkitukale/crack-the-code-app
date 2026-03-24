import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding state
class OnboardingState {
  final bool hasCompletedOnboarding;
  final bool isLoading;

  const OnboardingState({
    required this.hasCompletedOnboarding,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    bool? hasCompletedOnboarding,
    bool? isLoading,
  }) {
    return OnboardingState(
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Onboarding notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  static const String _onboardingKey = 'onboarding_complete';

  OnboardingNotifier() : super(const OnboardingState(hasCompletedOnboarding: false)) {
    _loadOnboardingStatus();
  }

  /// Load onboarding status from shared preferences
  Future<void> _loadOnboardingStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasCompleted = prefs.getBool(_onboardingKey) ?? false;
      state = OnboardingState(
        hasCompletedOnboarding: hasCompleted,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      state = state.copyWith(hasCompletedOnboarding: true);
    } catch (e) {
      // Handle error silently - worst case, user sees onboarding again
    }
  }

  /// Reset onboarding (for testing/demo purposes)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, false);
      state = state.copyWith(hasCompletedOnboarding: false);
    } catch (e) {
      // Handle error silently
    }
  }
}

/// Onboarding provider
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
