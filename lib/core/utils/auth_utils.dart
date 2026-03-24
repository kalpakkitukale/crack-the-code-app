/// Authentication utilities for getting current user information
library;

import 'package:firebase_auth/firebase_auth.dart';

/// Utility class for authentication-related operations
class AuthUtils {
  AuthUtils._();

  /// Get the current authenticated user's ID
  /// Returns 'anonymous' if no user is signed in
  static String get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'anonymous';
  }

  /// Get the current authenticated user's email
  /// Returns null if no user is signed in or email is not available
  static String? get currentUserEmail {
    return FirebaseAuth.instance.currentUser?.email;
  }

  /// Get the current authenticated user's display name
  /// Returns null if no user is signed in or name is not available
  static String? get currentUserDisplayName {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  /// Check if a user is currently signed in
  static bool get isSignedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Get the current Firebase user
  static User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  /// Get a student ID for use in the app
  /// Uses Firebase UID if available, otherwise returns a default
  static String getStudentId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    // Fallback for unauthenticated users (shouldn't happen with auth redirect)
    return 'anonymous_user';
  }
}
