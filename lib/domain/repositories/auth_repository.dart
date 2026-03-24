/// Authentication Repository Interface
/// Defines the contract for authentication operations
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/auth/auth_user.dart';

/// Abstract authentication repository
abstract class AuthRepository {
  /// Stream of auth state changes
  Stream<AuthUser?> get authStateChanges;

  /// Get current authenticated user
  AuthUser? get currentUser;

  /// Check if user is currently signed in
  bool get isSignedIn;

  /// Sign in with Google
  Future<Either<Failure, AuthUser>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, AuthUser>> signInWithApple();

  /// Send email magic link for passwordless sign-in
  Future<Either<Failure, void>> sendEmailLink(String email);

  /// Verify email magic link and sign in
  Future<Either<Failure, AuthUser>> signInWithEmailLink(
    String email,
    String emailLink,
  );

  /// Sign out from all providers
  Future<Either<Failure, void>> signOut();

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();

  /// Check if a link is a valid email sign-in link
  bool isSignInWithEmailLink(String link);

  /// Reload current user data from server
  Future<Either<Failure, AuthUser>> reloadUser();
}
