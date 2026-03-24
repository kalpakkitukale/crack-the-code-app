/// Authentication Configuration
/// Contains OAuth client IDs and authentication settings
///
/// IMPORTANT: In production, consider loading these values from:
/// - Environment variables (using --dart-define at build time)
/// - A secure remote configuration service
/// - Platform-specific secure storage
library;

/// Configuration for authentication providers
class AuthConfig {
  AuthConfig._();

  /// Google OAuth Web Client ID
  ///
  /// This is the Web client ID (client_type: 3) from Firebase console.
  /// It's required for Android to get idToken for Firebase Auth.
  ///
  /// To use build-time configuration:
  /// ```
  /// flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=your-client-id
  /// ```
  ///
  /// Then access via:
  /// ```
  /// const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: _defaultGoogleWebClientId)
  /// ```
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '145909045512-f97qltdtstv5kpp2g6q3qbngffannaul.apps.googleusercontent.com',
  );

  /// Google Drive API scopes for user data sync
  ///
  /// These scopes allow the app to:
  /// - Access user's email and profile
  /// - Store app data in a hidden Drive folder (appDataFolder)
  static const List<String> googleDriveScopes = [
    'email',
    'profile',
    // appDataFolder scope - allows app to store data in hidden folder
    // that only this app can access (not visible to user in Drive)
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  /// Apple Sign-In configuration
  ///
  /// Service ID for Apple Sign-In (configured in Apple Developer Portal)
  static const String appleServiceId = String.fromEnvironment(
    'APPLE_SERVICE_ID',
    defaultValue: '',
  );

  /// Whether Apple Sign-In is configured
  static bool get isAppleSignInConfigured => appleServiceId.isNotEmpty;
}
