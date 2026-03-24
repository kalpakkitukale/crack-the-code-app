/// Authentication Repository Implementation
/// Implements Firebase Authentication with Google, Apple, and Email sign-in
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:streamshaala/core/config/auth_config.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/auth/auth_user.dart';
import 'package:streamshaala/domain/repositories/auth_repository.dart';

/// Firebase Authentication Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    firebase.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: AuthConfig.googleDriveScopes,
              // Web client ID from AuthConfig (can be overridden via --dart-define)
              serverClientId: AuthConfig.googleWebClientId,
            );

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        logger.debug('Auth state changed: No user');
        return null;
      }
      logger.info('Auth state changed: User ${firebaseUser.uid}');
      return _mapFirebaseUser(firebaseUser);
    });
  }

  @override
  AuthUser? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return _mapFirebaseUser(firebaseUser);
  }

  @override
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      logger.info('Starting Google Sign-In...');

      // Trigger Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        logger.info('Google Sign-In cancelled by user');
        return Left(AuthFailure('Google sign-in cancelled'));
      }

      logger.debug('Google user obtained: ${googleUser.email}');

      // Get auth details
      final googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        logger.error('Firebase sign-in returned null user');
        return Left(AuthFailure('Failed to sign in with Google'));
      }

      logger.info(
          'Google Sign-In successful: ${userCredential.user!.uid}');
      return Right(_mapFirebaseUser(userCredential.user!));
    } on firebase.FirebaseAuthException catch (e) {
      logger.error('Firebase Auth error: ${e.code} - ${e.message}');
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e, stackTrace) {
      logger.error('Google Sign-In error: $e', e, stackTrace);
      return Left(AuthFailure('Google sign-in failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithApple() async {
    try {
      logger.info('Starting Apple Sign-In...');

      // Generate nonce for security
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      logger.debug('Apple credential obtained');

      // Create Firebase credential
      final oauthCredential = firebase.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        logger.error('Firebase sign-in returned null user');
        return Left(AuthFailure('Failed to sign in with Apple'));
      }

      // Apple only provides name on first sign-in, update profile if available
      if (appleCredential.givenName != null) {
        final fullName =
            '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
                .trim();
        if (fullName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(fullName);
          await userCredential.user!.reload();
        }
      }

      logger.info('Apple Sign-In successful: ${userCredential.user!.uid}');
      return Right(_mapFirebaseUser(
          _firebaseAuth.currentUser ?? userCredential.user!));
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        logger.info('Apple Sign-In cancelled by user');
        return Left(AuthFailure('Apple sign-in cancelled'));
      }
      logger.error('Apple Sign-In authorization error: ${e.message}');
      return Left(AuthFailure('Apple sign-in failed: ${e.message}'));
    } on firebase.FirebaseAuthException catch (e) {
      logger.error('Firebase Auth error: ${e.code} - ${e.message}');
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e, stackTrace) {
      logger.error('Apple Sign-In error: $e', e, stackTrace);
      return Left(AuthFailure('Apple sign-in failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailLink(String email) async {
    try {
      logger.info('Sending email link to: $email');

      // Configure action code settings for email magic link
      // Uses Firebase Auth domain for reliable cross-platform deep linking
      final actionCodeSettings = firebase.ActionCodeSettings(
        url: 'https://streamshaala.firebaseapp.com/__/auth/action?mode=signIn',
        handleCodeInApp: true,
        iOSBundleId: 'com.streamshaala.streamshaala',
        androidPackageName: 'com.streamshaala.streamshaala',
        androidInstallApp: true,
        androidMinimumVersion: '21',
      );

      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      logger.info('Email link sent successfully');
      return const Right(null);
    } on firebase.FirebaseAuthException catch (e) {
      logger.error('Firebase Auth error: ${e.code} - ${e.message}');
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e, stackTrace) {
      logger.error('Send email link error: $e', e, stackTrace);
      return Left(AuthFailure('Failed to send email link: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailLink(
    String email,
    String emailLink,
  ) async {
    try {
      logger.info('Signing in with email link...');

      final userCredential = await _firebaseAuth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      if (userCredential.user == null) {
        logger.error('Firebase sign-in returned null user');
        return Left(AuthFailure('Failed to sign in with email link'));
      }

      logger.info(
          'Email link Sign-In successful: ${userCredential.user!.uid}');
      return Right(_mapFirebaseUser(userCredential.user!));
    } on firebase.FirebaseAuthException catch (e) {
      logger.error('Firebase Auth error: ${e.code} - ${e.message}');
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e, stackTrace) {
      logger.error('Email link Sign-In error: $e', e, stackTrace);
      return Left(AuthFailure('Email sign-in failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      logger.info('Signing out...');

      // Sign out from Google if signed in
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
          logger.debug('Signed out from Google');
        }
      } catch (e) {
        // Ignore Google sign-out errors
        logger.debug('Google sign-out error (ignored): $e');
      }

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      logger.info('Sign out successful');
      return const Right(null);
    } catch (e, stackTrace) {
      logger.error('Sign out error: $e', e, stackTrace);
      return Left(AuthFailure('Sign out failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      logger.info('Deleting user account...');

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure('No user signed in'));
      }

      await user.delete();

      logger.info('Account deleted successfully');
      return const Right(null);
    } on firebase.FirebaseAuthException catch (e) {
      logger.error('Firebase Auth error: ${e.code} - ${e.message}');
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e, stackTrace) {
      logger.error('Delete account error: $e', e, stackTrace);
      return Left(AuthFailure('Account deletion failed: ${e.toString()}'));
    }
  }

  @override
  bool isSignInWithEmailLink(String link) {
    return _firebaseAuth.isSignInWithEmailLink(link);
  }

  @override
  Future<Either<Failure, AuthUser>> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure('No user signed in'));
      }

      await user.reload();
      final reloadedUser = _firebaseAuth.currentUser;

      if (reloadedUser == null) {
        return Left(AuthFailure('User no longer exists'));
      }

      return Right(_mapFirebaseUser(reloadedUser));
    } on firebase.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      return Left(AuthFailure('Failed to reload user: ${e.toString()}'));
    }
  }

  // ============ Private Helper Methods ============

  /// Map Firebase User to AuthUser entity
  AuthUser _mapFirebaseUser(firebase.User firebaseUser) {
    // Determine auth provider from provider data
    AuthProvider provider = AuthProvider.email;
    for (final info in firebaseUser.providerData) {
      if (info.providerId == 'google.com') {
        provider = AuthProvider.google;
        break;
      } else if (info.providerId == 'apple.com') {
        provider = AuthProvider.apple;
        break;
      } else if (info.providerId == 'phone') {
        provider = AuthProvider.phone;
        break;
      }
    }

    // Check for anonymous user
    if (firebaseUser.isAnonymous) {
      provider = AuthProvider.anonymous;
    }

    return AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      provider: provider,
      emailVerified: firebaseUser.emailVerified,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      lastSignInAt: firebaseUser.metadata.lastSignInTime,
    );
  }

  /// Map Firebase Auth exceptions to user-friendly messages
  String _mapFirebaseError(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'invalid-action-code':
        return 'The link has expired or already been used';
      case 'expired-action-code':
        return 'The link has expired. Please request a new one';
      default:
        return e.message ?? 'Authentication error occurred';
    }
  }

  /// Generate a cryptographically secure nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// SHA256 hash a string
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
