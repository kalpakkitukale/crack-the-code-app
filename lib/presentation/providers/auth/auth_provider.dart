/// Authentication Providers
/// Riverpod providers for managing authentication state
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/repositories/auth_repository_impl.dart';
import 'package:crack_the_code/domain/entities/auth/auth_user.dart';
import 'package:crack_the_code/domain/repositories/auth_repository.dart';
import 'package:crack_the_code/presentation/providers/auth/auth_state.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Auth state changes stream provider
final authStateChangesProvider = StreamProvider<AuthUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Current authenticated user provider
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
});

/// Current user ID provider (for replacing student_001)
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Auth loading state (for showing loading indicators)
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// Auth notifier provider for managing auth actions
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

/// Authentication state notifier
/// Manages all authentication actions and state transitions
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  ProviderSubscription<AsyncValue<AuthUser?>>? _authSubscription;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _init();
  }

  AuthRepository get _authRepository => _ref.read(authRepositoryProvider);

  /// Initialize auth state listener
  void _init() {
    logger.debug('AuthNotifier: Initializing...');

    // Listen to auth state changes from Firebase
    // Store subscription for cleanup in dispose()
    _authSubscription = _ref.listen(authStateChangesProvider, (previous, next) {
      // Check if notifier is still mounted before updating state
      if (!mounted) return;

      next.when(
        data: (user) {
          if (user != null) {
            logger.info('AuthNotifier: User authenticated - ${user.uid}');
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user,
            );
          } else {
            logger.info('AuthNotifier: User unauthenticated');
            state = const AuthState(
              status: AuthStatus.unauthenticated,
            );
          }
        },
        loading: () {
          logger.debug('AuthNotifier: Loading auth state...');
          state = const AuthState(
            status: AuthStatus.initial,
            isLoading: true,
          );
        },
        error: (error, stackTrace) {
          logger.error('AuthNotifier: Auth error', error, stackTrace);
          state = AuthState(
            status: AuthStatus.error,
            errorMessage: error.toString(),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    logger.debug('AuthNotifier: Disposing...');
    _authSubscription?.close();
    _authSubscription = null;
    super.dispose();
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    logger.info('AuthNotifier: Starting Google Sign-In');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.signInWithGoogle();

    return result.fold(
      (Failure failure) {
        logger.error('AuthNotifier: Google Sign-In failed - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (AuthUser user) {
        logger.info('AuthNotifier: Google Sign-In successful');
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
        return true;
      },
    );
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    logger.info('AuthNotifier: Starting Apple Sign-In');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.signInWithApple();

    return result.fold(
      (Failure failure) {
        logger.error('AuthNotifier: Apple Sign-In failed - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (AuthUser user) {
        logger.info('AuthNotifier: Apple Sign-In successful');
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
        return true;
      },
    );
  }

  /// Send email magic link
  Future<bool> sendEmailLink(String email) async {
    logger.info('AuthNotifier: Sending email link to $email');
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      pendingEmail: email,
    );

    final result = await _authRepository.sendEmailLink(email);

    return result.fold(
      (Failure failure) {
        logger.error('AuthNotifier: Send email link failed - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          emailLinkSent: false,
        );
        return false;
      },
      (_) {
        logger.info('AuthNotifier: Email link sent successfully');
        state = state.copyWith(
          isLoading: false,
          emailLinkSent: true,
        );
        return true;
      },
    );
  }

  /// Sign in with email link
  Future<bool> signInWithEmailLink(String email, String link) async {
    logger.info('AuthNotifier: Signing in with email link');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.signInWithEmailLink(email, link);

    return result.fold(
      (Failure failure) {
        logger.error('AuthNotifier: Email link Sign-In failed - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (AuthUser user) {
        logger.info('AuthNotifier: Email link Sign-In successful');
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
        return true;
      },
    );
  }

  /// Check if link is a valid email sign-in link
  bool isSignInWithEmailLink(String link) {
    return _authRepository.isSignInWithEmailLink(link);
  }

  /// Sign out
  Future<void> signOut() async {
    logger.info('AuthNotifier: Signing out');
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.signOut();

    result.fold(
      (Failure failure) {
        logger.error('AuthNotifier: Sign out failed - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        logger.info('AuthNotifier: Sign out successful');
        state = const AuthState(
          status: AuthStatus.unauthenticated,
        );
      },
    );
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    logger.info('AuthNotifier: Deleting account');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.deleteAccount();

    return result.fold(
      (Failure failure) {
        logger.error('AuthNotifier: Delete account failed - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        logger.info('AuthNotifier: Account deleted successfully');
        state = const AuthState(
          status: AuthStatus.unauthenticated,
        );
        return true;
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset email link sent state
  void resetEmailLinkState() {
    state = state.copyWith(
      emailLinkSent: false,
      pendingEmail: null,
    );
  }
}
