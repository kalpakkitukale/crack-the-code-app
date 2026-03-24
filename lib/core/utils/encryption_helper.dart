/// Encryption Helper
///
/// Provides AES encryption/decryption for sensitive data stored locally.
/// Uses the cryptography package for secure encryption.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:streamshaala/core/services/secure_storage_service.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Helper class for encrypting and decrypting sensitive data
class EncryptionHelper {
  static final EncryptionHelper _instance = EncryptionHelper._();
  static EncryptionHelper get instance => _instance;

  EncryptionHelper._();

  /// AES-GCM algorithm for authenticated encryption
  final _algorithm = AesGcm.with256bits();

  /// Cached encryption key (stored in secure storage)
  SecretKey? _cachedKey;

  /// Initialize the encryption helper
  /// Must be called before encrypting/decrypting data
  Future<void> initialize() async {
    await _getOrCreateKey();
  }

  /// Get or create the encryption key
  /// Key is stored in secure storage and persisted across app restarts
  Future<SecretKey> _getOrCreateKey() async {
    final existingKey = _cachedKey;
    if (existingKey != null) {
      return existingKey;
    }

    // Try to load existing key from secure storage
    final storedKey = await secureStorage.read(SecureStorageKeys.encryptionKey);
    if (storedKey != null) {
      try {
        final keyBytes = base64Decode(storedKey);
        final loadedKey = SecretKey(keyBytes);
        _cachedKey = loadedKey;
        logger.debug('Loaded encryption key from secure storage');
        return loadedKey;
      } catch (e) {
        logger.warning('Failed to decode stored encryption key, generating new one');
      }
    }

    // Generate new key
    final newKey = await _algorithm.newSecretKey();
    final keyBytes = await newKey.extractBytes();
    await secureStorage.write(
      SecureStorageKeys.encryptionKey,
      base64Encode(keyBytes),
    );
    _cachedKey = newKey;
    logger.info('Generated and stored new encryption key');
    return newKey;
  }

  /// Encrypt a string value
  ///
  /// Returns base64-encoded encrypted data (nonce + ciphertext + mac)
  /// Returns null if encryption fails
  Future<String?> encrypt(String plaintext) async {
    if (plaintext.isEmpty) return plaintext;

    try {
      final key = await _getOrCreateKey();
      final plaintextBytes = utf8.encode(plaintext);

      // Generate random nonce
      final nonce = _algorithm.newNonce();

      // Encrypt
      final secretBox = await _algorithm.encrypt(
        plaintextBytes,
        secretKey: key,
        nonce: nonce,
      );

      // Combine nonce + ciphertext + mac into single bytes
      final combined = Uint8List(
        secretBox.nonce.length + secretBox.cipherText.length + secretBox.mac.bytes.length,
      );
      var offset = 0;
      combined.setRange(offset, offset + secretBox.nonce.length, secretBox.nonce);
      offset += secretBox.nonce.length;
      combined.setRange(offset, offset + secretBox.cipherText.length, secretBox.cipherText);
      offset += secretBox.cipherText.length;
      combined.setRange(offset, offset + secretBox.mac.bytes.length, secretBox.mac.bytes);

      return base64Encode(combined);
    } catch (e, stackTrace) {
      logger.error('Encryption failed', e, stackTrace);
      return null;
    }
  }

  /// Decrypt a base64-encoded encrypted string
  ///
  /// Returns the decrypted plaintext
  /// Returns null if decryption fails
  Future<String?> decrypt(String encryptedBase64) async {
    if (encryptedBase64.isEmpty) return encryptedBase64;

    try {
      final key = await _getOrCreateKey();
      final combined = base64Decode(encryptedBase64);

      // Extract nonce, ciphertext, and mac
      const nonceLength = 12; // AES-GCM standard nonce length
      const macLength = 16; // AES-GCM standard mac length

      if (combined.length < nonceLength + macLength + 1) {
        logger.warning('Encrypted data too short');
        return null;
      }

      final nonce = combined.sublist(0, nonceLength);
      final cipherText = combined.sublist(nonceLength, combined.length - macLength);
      final macBytes = combined.sublist(combined.length - macLength);

      final secretBox = SecretBox(
        cipherText,
        nonce: nonce,
        mac: Mac(macBytes),
      );

      // Decrypt
      final plaintextBytes = await _algorithm.decrypt(
        secretBox,
        secretKey: key,
      );

      return utf8.decode(plaintextBytes);
    } catch (e, stackTrace) {
      logger.error('Decryption failed', e, stackTrace);
      return null;
    }
  }

  /// Encrypt a Map (JSON object)
  ///
  /// Returns base64-encoded encrypted JSON
  Future<String?> encryptJson(Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      return await encrypt(jsonString);
    } catch (e, stackTrace) {
      logger.error('JSON encryption failed', e, stackTrace);
      return null;
    }
  }

  /// Decrypt to a Map (JSON object)
  ///
  /// Returns the decrypted Map
  Future<Map<String, dynamic>?> decryptJson(String encryptedBase64) async {
    try {
      final jsonString = await decrypt(encryptedBase64);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      logger.error('JSON decryption failed', e, stackTrace);
      return null;
    }
  }

  /// Check if a string appears to be encrypted (base64 format)
  bool isEncrypted(String data) {
    if (data.isEmpty) return false;
    try {
      final decoded = base64Decode(data);
      // Check minimum length for nonce + mac + at least 1 byte
      return decoded.length >= 29; // 12 (nonce) + 16 (mac) + 1
    } catch (e) {
      return false;
    }
  }

  /// Generate a random string for use as salt or nonce
  String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Clear the cached key (for testing or key rotation)
  void clearCache() {
    _cachedKey = null;
  }

  /// Rotate the encryption key
  /// WARNING: This will make all previously encrypted data unreadable!
  /// Only use after migrating all encrypted data.
  Future<void> rotateKey() async {
    final newKey = await _algorithm.newSecretKey();
    final keyBytes = await newKey.extractBytes();
    await secureStorage.write(
      SecureStorageKeys.encryptionKey,
      base64Encode(keyBytes),
    );
    _cachedKey = newKey;
    logger.warning('Encryption key rotated - previous encrypted data is now unreadable');
  }
}

/// Global encryption helper instance
final encryptionHelper = EncryptionHelper.instance;
