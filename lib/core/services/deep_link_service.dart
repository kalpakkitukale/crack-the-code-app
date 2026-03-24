import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamshaala/core/services/secure_storage_service.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Service to handle deep links for email magic link authentication
///
/// This service listens for incoming deep links and handles email sign-in
/// when the user clicks on a magic link from their email.
class DeepLinkService {
  static DeepLinkService? _instance;
  static DeepLinkService get instance => _instance ??= DeepLinkService._();

  DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Callback to notify when sign-in is complete
  Function(bool success, String? error)? onSignInComplete;

  /// Initialize the deep link service
  /// Call this in main_common.dart after Firebase initialization
  Future<void> initialize() async {
    logger.info('[DeepLink] Initializing deep link service...');

    // Handle link that opened the app (cold start)
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        logger.info('[DeepLink] App opened with link: $initialLink');
        await _handleDeepLink(initialLink);
      }
    } catch (e) {
      logger.warning('[DeepLink] Error getting initial link: $e');
    }

    // Handle links while app is running (warm start)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) async {
        logger.info('[DeepLink] Received link while running: $uri');
        await _handleDeepLink(uri);
      },
      onError: (error) {
        logger.warning('[DeepLink] Error in link stream: $error');
      },
    );

    logger.info('[DeepLink] Deep link service initialized');
  }

  /// Handle incoming deep link
  Future<void> _handleDeepLink(Uri uri) async {
    final link = uri.toString();
    logger.info('[DeepLink] Processing link: $link');

    // Check if this is an email sign-in link
    if (FirebaseAuth.instance.isSignInWithEmailLink(link)) {
      logger.info('[DeepLink] Detected email sign-in link');
      await _handleEmailSignInLink(link);
    } else {
      logger.info('[DeepLink] Not an email sign-in link, ignoring');
    }
  }

  /// Handle email magic link sign-in
  Future<void> _handleEmailSignInLink(String link) async {
    try {
      // Get the pending email from secure storage
      final pendingEmail = await secureStorage.read(SecureStorageKeys.pendingEmailLink);

      if (pendingEmail == null || pendingEmail.isEmpty) {
        logger.warning('[DeepLink] No pending email found for sign-in');
        onSignInComplete?.call(false, 'No pending email found. Please request a new sign-in link.');
        return;
      }

      logger.info('[DeepLink] Signing in with email: $pendingEmail');

      // Sign in with email link
      final userCredential = await FirebaseAuth.instance.signInWithEmailLink(
        email: pendingEmail,
        emailLink: link,
      );

      // Clear the pending email from secure storage
      await secureStorage.delete(SecureStorageKeys.pendingEmailLink);

      logger.info('[DeepLink] Sign-in successful! User: ${userCredential.user?.uid}');
      onSignInComplete?.call(true, null);
    } on FirebaseAuthException catch (e) {
      logger.warning('[DeepLink] Firebase auth error: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'invalid-action-code':
          errorMessage = 'This sign-in link has expired or already been used. Please request a new one.';
          break;
        case 'expired-action-code':
          errorMessage = 'This sign-in link has expired. Please request a new one.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage = 'Sign-in failed: ${e.message}';
      }

      onSignInComplete?.call(false, errorMessage);
    } catch (e) {
      logger.warning('[DeepLink] Unexpected error during sign-in: $e');
      onSignInComplete?.call(false, 'An unexpected error occurred. Please try again.');
    }
  }

  /// Dispose the service
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    logger.info('[DeepLink] Deep link service disposed');
  }
}
