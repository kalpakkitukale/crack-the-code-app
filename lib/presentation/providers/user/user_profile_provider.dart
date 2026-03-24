// User Profile Provider
// Manages user profile data including grade, name, and preferences
// Supports multiple student profiles for siblings

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';
import 'package:streamshaala/core/config/segment_config.dart';

/// Keys for storing user profile data
class _ProfileKeys {
  static const String profile = 'user_profile';
  static const String profiles = 'user_profiles'; // List of all profiles
  static const String activeProfileId = 'active_profile_id';
  static const String onboardingComplete = 'onboarding_complete';
  static const String gradeSelectionComplete = 'grade_selection_complete';
}

/// Available avatar options for student profiles
class ProfileAvatars {
  static const List<Map<String, dynamic>> avatars = [
    {'id': 'bear', 'icon': '🐻', 'name': 'Bear', 'color': 0xFFFFB74D},
    {'id': 'cat', 'icon': '🐱', 'name': 'Cat', 'color': 0xFF90CAF9},
    {'id': 'dog', 'icon': '🐶', 'name': 'Dog', 'color': 0xFFA5D6A7},
    {'id': 'rabbit', 'icon': '🐰', 'name': 'Rabbit', 'color': 0xFFF48FB1},
    {'id': 'panda', 'icon': '🐼', 'name': 'Panda', 'color': 0xFFB0BEC5},
    {'id': 'lion', 'icon': '🦁', 'name': 'Lion', 'color': 0xFFFFCC80},
    {'id': 'owl', 'icon': '🦉', 'name': 'Owl', 'color': 0xFFCE93D8},
    {'id': 'fox', 'icon': '🦊', 'name': 'Fox', 'color': 0xFFFFAB91},
  ];

  static Map<String, dynamic>? getAvatar(String? id) {
    if (id == null) return avatars.first;
    return avatars.firstWhere(
      (a) => a['id'] == id,
      orElse: () => avatars.first,
    );
  }
}

/// User profile data
class UserProfile {
  final String id;
  final String? name;
  final int? grade;
  final String? avatarId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  UserProfile({
    String? id,
    this.name,
    this.grade,
    this.avatarId,
    this.createdAt,
    this.updatedAt,
    this.isActive = false,
  }) : id = id ?? const Uuid().v4();

  /// Create an empty default profile
  const UserProfile._empty()
      : id = '',
        name = null,
        grade = null,
        avatarId = null,
        createdAt = null,
        updatedAt = null,
        isActive = false;

  static const UserProfile empty = UserProfile._empty();

  UserProfile copyWith({
    String? id,
    String? name,
    int? grade,
    String? avatarId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      avatarId: avatarId ?? this.avatarId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'avatarId': avatarId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? const Uuid().v4(),
      name: json['name'] as String?,
      grade: json['grade'] as int?,
      avatarId: json['avatarId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Check if profile is complete for Junior segment
  bool get isJuniorProfileComplete => grade != null && name != null;

  /// Check if this is an empty/default profile
  bool get isEmpty => id.isEmpty;

  /// Get avatar data for this profile
  Map<String, dynamic>? get avatar => ProfileAvatars.getAvatar(avatarId);

  /// Get display name (or default)
  String get displayName => name ?? 'Student';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// State for user profile
class UserProfileState {
  final UserProfile profile; // Active profile
  final List<UserProfile> allProfiles; // All profiles (for siblings)
  final bool isLoading;
  final bool onboardingComplete;
  final bool gradeSelectionComplete;
  final String? error;

  const UserProfileState({
    this.profile = UserProfile.empty,
    this.allProfiles = const [],
    this.isLoading = false,
    this.onboardingComplete = false,
    this.gradeSelectionComplete = false,
    this.error,
  });

  UserProfileState copyWith({
    UserProfile? profile,
    List<UserProfile>? allProfiles,
    bool? isLoading,
    bool? onboardingComplete,
    bool? gradeSelectionComplete,
    String? error,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      allProfiles: allProfiles ?? this.allProfiles,
      isLoading: isLoading ?? this.isLoading,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      gradeSelectionComplete:
          gradeSelectionComplete ?? this.gradeSelectionComplete,
      error: error,
    );
  }

  /// Check if there are multiple profiles
  bool get hasMultipleProfiles => allProfiles.length > 1;

  /// Get count of profiles
  int get profileCount => allProfiles.length;
}

/// User Profile Notifier
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  SharedPreferences? _prefs;
  final void Function(String profileId)? _onProfileIdChanged;
  final Future<void> Function(String profileId)? _onProfileDeleted;

  /// Creates a UserProfileNotifier with injected dependencies.
  ///
  /// [prefs] - Optional SharedPreferences instance for persistence (for testing)
  ///           If null, will get instance internally (for production)
  /// [onProfileIdChanged] - Optional callback when active profile changes (for DI container)
  /// [onProfileDeleted] - Optional callback when profile is deleted (for cleanup)
  /// [autoLoad] - Set to false in tests to prevent automatic loading
  UserProfileNotifier({
    SharedPreferences? prefs,
    void Function(String profileId)? onProfileIdChanged,
    Future<void> Function(String profileId)? onProfileDeleted,
    bool autoLoad = true,
  })  : _prefs = prefs,
        _onProfileIdChanged = onProfileIdChanged,
        _onProfileDeleted = onProfileDeleted,
        super(const UserProfileState()) {
    if (autoLoad) {
      _initialize();
    }
  }

  /// Get SharedPreferences instance, ensuring it's initialized
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('SharedPreferences not initialized. Call _initialize() first.');
    }
    return _prefs!;
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs; // Cache for future use

      // Load all profiles
      final profilesJson = prefs.getString(_ProfileKeys.profiles);
      List<UserProfile> allProfiles = [];

      if (profilesJson != null) {
        final profilesList = jsonDecode(profilesJson) as List;
        allProfiles = profilesList
            .map((p) => UserProfile.fromJson(p as Map<String, dynamic>))
            .toList();
      }

      // Get active profile ID
      final activeProfileId = prefs.getString(_ProfileKeys.activeProfileId);
      UserProfile activeProfile = UserProfile.empty;

      if (allProfiles.isNotEmpty) {
        // Find active profile or use first one
        activeProfile = allProfiles.firstWhere(
          (p) => p.id == activeProfileId,
          orElse: () => allProfiles.first,
        );
      } else {
        // Migrate from old single-profile format
        final oldProfileJson = prefs.getString(_ProfileKeys.profile);
        if (oldProfileJson != null) {
          final oldProfile = UserProfile.fromJson(
            jsonDecode(oldProfileJson) as Map<String, dynamic>,
          );
          allProfiles = [oldProfile];
          activeProfile = oldProfile;
          // Save in new format
          await _saveAllProfiles(allProfiles);
          await _setActiveProfileId(oldProfile.id);
        }
      }

      // Load flags
      final onboardingComplete =
          prefs.getBool(_ProfileKeys.onboardingComplete) ?? false;
      final gradeSelectionComplete =
          prefs.getBool(_ProfileKeys.gradeSelectionComplete) ?? false;

      // Set the active profile ID in the injection container for multi-profile data filtering
      if (activeProfile.id.isNotEmpty) {
        _onProfileIdChanged?.call(activeProfile.id);
      }

      state = state.copyWith(
        profile: activeProfile,
        allProfiles: allProfiles,
        onboardingComplete: onboardingComplete,
        gradeSelectionComplete: gradeSelectionComplete,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile: $e',
      );
    }
  }

  /// Create a new student profile
  Future<UserProfile> createProfile({
    required String name,
    required int grade,
    String? avatarId,
  }) async {
    final now = DateTime.now();
    final newProfile = UserProfile(
      name: name,
      grade: grade,
      avatarId: avatarId ?? ProfileAvatars.avatars.first['id'] as String,
      createdAt: now,
      updatedAt: now,
    );

    final updatedProfiles = [...state.allProfiles, newProfile];
    await _saveAllProfiles(updatedProfiles);

    // If this is the first profile, make it active
    if (state.allProfiles.isEmpty) {
      await _setActiveProfileId(newProfile.id);

      // Update the injection container with the new profile ID
      _onProfileIdChanged?.call(newProfile.id);

      state = state.copyWith(
        profile: newProfile,
        allProfiles: updatedProfiles,
        gradeSelectionComplete: true,
      );
      // Update grade selection complete flag
      await prefs.setBool(_ProfileKeys.gradeSelectionComplete, true);
    } else {
      state = state.copyWith(allProfiles: updatedProfiles);
    }

    return newProfile;
  }

  /// Switch to a different profile
  Future<void> switchProfile(String profileId) async {
    final profile = state.allProfiles.firstWhere(
      (p) => p.id == profileId,
      orElse: () => state.profile,
    );

    if (profile.id != state.profile.id) {
      await _setActiveProfileId(profile.id);

      // Update the injection container with the new profile ID
      _onProfileIdChanged?.call(profile.id);

      state = state.copyWith(profile: profile);
    }
  }

  /// Update an existing profile
  Future<void> updateProfile(UserProfile updatedProfile) async {
    final profileWithTimestamp = updatedProfile.copyWith(
      updatedAt: DateTime.now(),
    );

    final updatedProfiles = state.allProfiles.map((p) {
      return p.id == profileWithTimestamp.id ? profileWithTimestamp : p;
    }).toList();

    await _saveAllProfiles(updatedProfiles);

    state = state.copyWith(
      allProfiles: updatedProfiles,
      profile: state.profile.id == profileWithTimestamp.id
          ? profileWithTimestamp
          : state.profile,
    );
  }

  /// Delete a profile
  Future<bool> deleteProfile(String profileId) async {
    // Don't allow deleting the last profile
    if (state.allProfiles.length <= 1) {
      return false;
    }

    // Clean up all data associated with this profile
    if (_onProfileDeleted != null) {
      try {
        await _onProfileDeleted!(profileId);
      } catch (e) {
        // Log error but don't fail the profile deletion
        // Data cleanup failure shouldn't prevent profile deletion
      }
    }

    final updatedProfiles =
        state.allProfiles.where((p) => p.id != profileId).toList();
    await _saveAllProfiles(updatedProfiles);

    // If we deleted the active profile, switch to another
    if (state.profile.id == profileId) {
      if (updatedProfiles.isEmpty) {
        // Cannot delete the last profile - create a default one
        final defaultProfile = UserProfile();
        await _saveAllProfiles([defaultProfile]);
        await _setActiveProfileId(defaultProfile.id);
        _onProfileIdChanged?.call(defaultProfile.id);
        state = state.copyWith(
          profile: defaultProfile,
          allProfiles: [defaultProfile],
        );
      } else {
        final newActive = updatedProfiles.first;
        await _setActiveProfileId(newActive.id);

        // Update the injection container with the new profile ID
        _onProfileIdChanged?.call(newActive.id);

        state = state.copyWith(
          profile: newActive,
          allProfiles: updatedProfiles,
        );
      }
    } else {
      state = state.copyWith(allProfiles: updatedProfiles);
    }

    return true;
  }

  /// Set user's name (for active profile)
  Future<void> setName(String name) async {
    final newProfile = state.profile.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );
    await updateProfile(newProfile);
  }

  /// Set user's grade (for active profile)
  Future<void> setGrade(int grade) async {
    final now = DateTime.now();
    final newProfile = state.profile.copyWith(
      grade: grade,
      updatedAt: now,
      createdAt: state.profile.createdAt ?? now,
    );
    await updateProfile(newProfile);

    // Mark grade selection as complete
    await prefs.setBool(_ProfileKeys.gradeSelectionComplete, true);

    state = state.copyWith(gradeSelectionComplete: true);
  }

  /// Set user's avatar (for active profile)
  Future<void> setAvatar(String avatarId) async {
    final newProfile = state.profile.copyWith(
      avatarId: avatarId,
      updatedAt: DateTime.now(),
    );
    await updateProfile(newProfile);
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    await prefs.setBool(_ProfileKeys.onboardingComplete, true);
    state = state.copyWith(onboardingComplete: true);
  }

  /// Reset all profiles (for testing/development)
  Future<void> resetProfile() async {
    await prefs.remove(_ProfileKeys.profile);
    await prefs.remove(_ProfileKeys.profiles);
    await prefs.remove(_ProfileKeys.activeProfileId);
    await prefs.remove(_ProfileKeys.onboardingComplete);
    await prefs.remove(_ProfileKeys.gradeSelectionComplete);
    state = const UserProfileState();
  }

  /// Save all profiles to SharedPreferences
  Future<void> _saveAllProfiles(List<UserProfile> profiles) async {
    final profilesJson = profiles.map((p) => p.toJson()).toList();
    await prefs.setString(_ProfileKeys.profiles, jsonEncode(profilesJson));
  }

  /// Set active profile ID
  Future<void> _setActiveProfileId(String profileId) async {
    await prefs.setString(_ProfileKeys.activeProfileId, profileId);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for user profile
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>(
  (ref) => UserProfileNotifier(
    onProfileIdChanged: (profileId) {
      if (SegmentConfig.isJunior) {
        injectionContainer.setActiveProfileId(profileId);
      }
    },
    onProfileDeleted: (profileId) async {
      if (injectionContainer.isInitialized) {
        await injectionContainer.deleteAllDataForProfile(profileId);
      }
    },
  ),
);

/// Provider for user's current grade
final userGradeProvider = Provider<int?>((ref) {
  return ref.watch(userProfileProvider).profile.grade;
});

/// Provider to check if onboarding flow is complete
final isOnboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider).onboardingComplete;
});

/// Provider to check if grade selection is complete
final isGradeSelectionCompleteProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider).gradeSelectionComplete;
});

/// Provider for all student profiles
final allProfilesProvider = Provider<List<UserProfile>>((ref) {
  return ref.watch(userProfileProvider).allProfiles;
});

/// Provider for active profile
final activeProfileProvider = Provider<UserProfile>((ref) {
  return ref.watch(userProfileProvider).profile;
});

/// Provider to check if multiple profiles exist
final hasMultipleProfilesProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider).hasMultipleProfiles;
});
