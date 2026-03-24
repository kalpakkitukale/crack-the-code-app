import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/presentation/providers/gamification/gamification_provider.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';

/// @Deprecated('Use userProfileProvider for name and gamificationProvider for streak instead')
/// Simple user info provider - DEPRECATED
/// This provider is deprecated. Use:
/// - userProfileProvider.profile.displayName for name
/// - gamificationProvider.currentStreak for streak
class UserInfo {
  final String name;
  final int currentStreak;

  const UserInfo({
    required this.name,
    required this.currentStreak,
  });

  const UserInfo.guest()
      : name = 'Student',
        currentStreak = 0;

  UserInfo copyWith({
    String? name,
    int? currentStreak,
  }) {
    return UserInfo(
      name: name ?? this.name,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

/// @Deprecated('Use userProfileProvider and gamificationProvider instead')
/// User info provider - DEPRECATED
/// Provides basic user information like name and streak.
///
/// Migration: Replace usages with:
/// ```dart
/// final name = ref.watch(userProfileProvider).profile.displayName;
/// final streak = ref.watch(gamificationProvider).currentStreak;
/// ```
final userInfoProvider = Provider<UserInfo>((ref) {
  final profileState = ref.watch(userProfileProvider);
  final gamificationState = ref.watch(gamificationProvider);

  return UserInfo(
    name: profileState.profile.displayName,
    currentStreak: gamificationState.currentStreak,
  );
});
