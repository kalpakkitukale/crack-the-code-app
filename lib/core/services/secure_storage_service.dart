/// Secure Storage Service
///
/// Provides encrypted storage for sensitive data using flutter_secure_storage.
/// Uses platform-specific secure storage mechanisms:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences (or Keystore on older devices)
/// - macOS: Keychain
/// - Windows: Windows Credential Manager
/// - Linux: libsecret
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Keys for secure storage
class SecureStorageKeys {
  SecureStorageKeys._();

  /// Parental control PIN (hashed)
  static const String parentalPin = 'parental_pin';

  /// Parental PIN salt for hashing
  static const String parentalPinSalt = 'parental_pin_salt';

  /// Failed PIN attempts counter
  static const String pinFailedAttempts = 'pin_failed_attempts';

  /// PIN lockout timestamp
  static const String pinLockoutUntil = 'pin_lockout_until';

  /// User session token (if custom auth is used)
  static const String sessionToken = 'session_token';

  /// API keys (if stored locally)
  static const String apiKey = 'api_key';

  /// Encryption key for local data
  static const String encryptionKey = 'encryption_key';

  /// Pending email for magic link sign-in
  static const String pendingEmailLink = 'pending_email_link';
}

/// Service for secure storage of sensitive data
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._();
  static SecureStorageService get instance => _instance;

  SecureStorageService._();

  /// Flutter secure storage instance with platform-specific options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'streamshaala_secure_prefs',
      preferencesKeyPrefix: 'ss_',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      accountName: 'StreamShaala',
    ),
    mOptions: MacOsOptions(
      accountName: 'StreamShaala',
      groupId: 'com.streamshaala.streamshaala',
    ),
    lOptions: LinuxOptions(),
    wOptions: WindowsOptions(),
  );

  /// Write a value to secure storage
  ///
  /// [key] - Storage key
  /// [value] - Value to store (will be encrypted)
  Future<bool> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      logger.debug('Secure storage: wrote key "$key"');
      return true;
    } catch (e, stackTrace) {
      logger.error('Secure storage write failed for key "$key"', e, stackTrace);
      return false;
    }
  }

  /// Read a value from secure storage
  ///
  /// [key] - Storage key
  /// Returns the decrypted value or null if not found
  Future<String?> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      logger.debug('Secure storage: read key "$key" (found: ${value != null})');
      return value;
    } catch (e, stackTrace) {
      logger.error('Secure storage read failed for key "$key"', e, stackTrace);
      return null;
    }
  }

  /// Delete a value from secure storage
  ///
  /// [key] - Storage key to delete
  Future<bool> delete(String key) async {
    try {
      await _storage.delete(key: key);
      logger.debug('Secure storage: deleted key "$key"');
      return true;
    } catch (e, stackTrace) {
      logger.error('Secure storage delete failed for key "$key"', e, stackTrace);
      return false;
    }
  }

  /// Check if a key exists in secure storage
  ///
  /// [key] - Storage key to check
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e, stackTrace) {
      logger.error('Secure storage containsKey failed for key "$key"', e, stackTrace);
      return false;
    }
  }

  /// Delete all values from secure storage
  ///
  /// Use with caution - this removes all secure data
  Future<bool> deleteAll() async {
    try {
      await _storage.deleteAll();
      logger.info('Secure storage: deleted all values');
      return true;
    } catch (e, stackTrace) {
      logger.error('Secure storage deleteAll failed', e, stackTrace);
      return false;
    }
  }

  /// Read all keys from secure storage
  ///
  /// Returns a map of all key-value pairs
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e, stackTrace) {
      logger.error('Secure storage readAll failed', e, stackTrace);
      return {};
    }
  }

  // ============ Convenience Methods ============

  /// Write an integer value
  Future<bool> writeInt(String key, int value) async {
    return write(key, value.toString());
  }

  /// Read an integer value
  Future<int?> readInt(String key) async {
    final value = await read(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Write a DateTime value (stored as ISO8601)
  Future<bool> writeDateTime(String key, DateTime value) async {
    return write(key, value.toIso8601String());
  }

  /// Read a DateTime value
  Future<DateTime?> readDateTime(String key) async {
    final value = await read(key);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  /// Write a boolean value
  Future<bool> writeBool(String key, bool value) async {
    return write(key, value.toString());
  }

  /// Read a boolean value
  Future<bool?> readBool(String key) async {
    final value = await read(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }
}

/// Global secure storage service instance
final secureStorage = SecureStorageService.instance;
