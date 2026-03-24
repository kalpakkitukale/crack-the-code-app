/// Authentication User Entity
/// Represents an authenticated user from Firebase
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// Authentication provider types
enum AuthProvider {
  google,
  apple,
  email,
  phone,
  anonymous,
}

/// Authenticated user entity
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    required AuthProvider provider,
    required bool emailVerified,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _AuthUser;

  const AuthUser._();

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  /// Check if user signed in with social provider
  bool get isSocialAuth =>
      provider == AuthProvider.google || provider == AuthProvider.apple;

  /// Check if user has email
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Check if user has display name
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Check if user has photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Get initials for avatar fallback
  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email?.substring(0, 1).toUpperCase() ?? '?';
    }
    final parts = displayName!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName![0].toUpperCase();
  }

  /// Get display name or email fallback
  String get displayNameOrEmail => displayName ?? email ?? 'User';

  /// Get short display name (first name only)
  String get firstName {
    if (displayName == null || displayName!.isEmpty) {
      return email?.split('@').first ?? 'User';
    }
    return displayName!.split(' ').first;
  }
}
