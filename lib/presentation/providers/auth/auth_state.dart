/// Authentication State Model
/// Represents the current authentication state of the app
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crack_the_code/domain/entities/auth/auth_user.dart';

part 'auth_state.freezed.dart';

/// Authentication status enum
enum AuthStatus {
  /// App just started, checking auth state
  initial,

  /// User is logged in
  authenticated,

  /// User is not logged in
  unauthenticated,

  /// Auth error occurred
  error,
}

/// Authentication state
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    AuthUser? user,
    String? errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool emailLinkSent,
    String? pendingEmail,
  }) = _AuthState;

  const AuthState._();

  /// Check if user is authenticated
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  /// Check if user is not authenticated
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// Check if auth is still loading/checking
  bool get isChecking => status == AuthStatus.initial || isLoading;

  /// Check if there's an error
  bool get hasError => status == AuthStatus.error || errorMessage != null;

  /// Get user ID or null
  String? get userId => user?.uid;
}
