/// User ID Provider
/// Provides the effective user ID for data operations
/// This replaces all hardcoded 'student_001' references
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/presentation/providers/auth/auth_provider.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';

/// Provides the current effective user ID for data operations
///
/// Priority:
/// 1. Firebase UID (when authenticated)
/// 2. Local profile ID (fallback for offline/testing)
///
/// Usage: Replace all `const studentId = 'student_001'` with:
/// ```dart
/// final studentId = ref.watch(effectiveUserIdProvider);
/// ```
final effectiveUserIdProvider = Provider<String>((ref) {
  // First, try to get Firebase user ID
  final firebaseUserId = ref.watch(currentUserIdProvider);
  if (firebaseUserId != null) {
    return firebaseUserId;
  }

  // Fallback to local profile ID (for offline mode or testing)
  final profileState = ref.watch(userProfileProvider);
  return profileState.profile.id;
});

/// Provides user ID or null if not available
/// Use this when you need to check if user is authenticated
final userIdOrNullProvider = Provider<String?>((ref) {
  return ref.watch(currentUserIdProvider);
});

/// Provides a boolean indicating if user is fully authenticated
/// (has both Firebase auth and can perform data operations)
final canPerformDataOperationsProvider = Provider<bool>((ref) {
  final userId = ref.watch(effectiveUserIdProvider);
  return userId.isNotEmpty;
});

/// Provider that combines auth state with user ID for convenience
final authenticatedUserIdProvider = Provider<String?>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return null;
  return ref.watch(currentUserIdProvider);
});
