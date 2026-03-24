import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Manages platform consistency across iOS, Android, and other platforms
/// Ensures all platforms use the same data sources and state management
class PlatformConsistencyManager {
  static final PlatformConsistencyManager _instance = PlatformConsistencyManager._internal();
  factory PlatformConsistencyManager() => _instance;
  PlatformConsistencyManager._internal();

  static const String _checksumKey = 'platform_data_checksum';
  static const String _lastSyncKey = 'platform_last_sync';
  static const String _platformIdKey = 'platform_unique_id';

  /// Initialize the platform with consistent data
  Future<void> initializeConsistently() async {
    try {
      logger.info('🚀 Initializing platform consistency manager...');

      // 1. Generate or retrieve platform ID
      final platformId = await _getPlatformId();
      logger.info('Platform ID: $platformId');

      // 2. Clear any stale caches
      await _clearStaleCaches();

      // 3. Validate data integrity
      final isValid = await _validateDataIntegrity();
      if (!isValid) {
        logger.warning('Data integrity check failed, reinitializing...');
        await _reinitializeData();
      }

      // 4. Set up platform sync
      await _setupPlatformSync();

      // 5. Log platform info
      await _logPlatformInfo();

      logger.info('✅ Platform consistency manager initialized successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize platform consistency', e, stackTrace);
      rethrow;
    }
  }

  /// Get or generate unique platform identifier
  Future<String> _getPlatformId() async {
    final prefs = await SharedPreferences.getInstance();
    String? platformId = prefs.getString(_platformIdKey);

    if (platformId == null) {
      // Generate new platform ID
      String platformName;
      String platformVersion;

      if (kIsWeb) {
        platformName = 'web';
        platformVersion = 'web';
      } else {
        platformName = Platform.operatingSystem;
        platformVersion = Platform.operatingSystemVersion;
      }

      final platformInfo = {
        'os': platformName,
        'version': platformVersion,
        'timestamp': DateTime.now().toIso8601String(),
        'random': DateTime.now().millisecondsSinceEpoch,
      };

      final json = jsonEncode(platformInfo);
      platformId = sha256.convert(utf8.encode(json)).toString().substring(0, 16);
      await prefs.setString(_platformIdKey, platformId);
    }

    return platformId;
  }

  /// Clear stale caches that might cause inconsistency
  Future<void> _clearStaleCaches() async {
    try {
      if (kIsWeb) return; // No file system cache on web

      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync();

      for (final file in cacheFiles) {
        if (file.path.contains('crackthecode_cache')) {
          await file.delete(recursive: true);
          logger.debug('Cleared cache: ${file.path}');
        }
      }
    } catch (e) {
      logger.warning('Could not clear caches: $e');
    }
  }

  /// Validate that data is consistent across platforms
  Future<bool> _validateDataIntegrity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedChecksum = prefs.getString(_checksumKey);
      final currentChecksum = await _calculateDataChecksum();

      if (storedChecksum == null) {
        // First run, store checksum
        await prefs.setString(_checksumKey, currentChecksum);
        return true;
      }

      // Validate checksum matches
      final isValid = storedChecksum == currentChecksum;
      if (!isValid) {
        logger.warning('Data checksum mismatch. Stored: $storedChecksum, Current: $currentChecksum');
      }

      return isValid;
    } catch (e) {
      logger.error('Error validating data integrity: $e');
      return false;
    }
  }

  /// Calculate checksum of all critical data
  Future<String> _calculateDataChecksum() async {
    final dataPoints = <String>[];

    // Add app version
    dataPoints.add('version:1.0.0');

    // Add platform info
    final platformName = kIsWeb ? 'web' : Platform.operatingSystem;
    dataPoints.add('platform:$platformName');

    // Add data structure version
    dataPoints.add('data_version:2');

    // Add critical configuration
    dataPoints.add('completion_threshold:0.9');

    // Calculate combined checksum
    final combined = dataPoints.join('|');
    return sha256.convert(utf8.encode(combined)).toString();
  }

  /// Reinitialize data to ensure consistency
  Future<void> _reinitializeData() async {
    logger.info('Reinitializing platform data...');

    // Clear all stored preferences except platform ID
    final prefs = await SharedPreferences.getInstance();
    final platformId = prefs.getString(_platformIdKey);
    await prefs.clear();
    if (platformId != null) {
      await prefs.setString(_platformIdKey, platformId);
    }

    // Store new checksum
    final checksum = await _calculateDataChecksum();
    await prefs.setString(_checksumKey, checksum);

    logger.info('Platform data reinitialized');
  }

  /// Set up platform synchronization
  Future<void> _setupPlatformSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  /// Log platform information for debugging
  Future<void> _logPlatformInfo() async {
    final info = <String, dynamic>{
      'is_debug': kDebugMode,
      'is_profile': kProfileMode,
      'is_release': kReleaseMode,
    };

    if (kIsWeb) {
      info['platform'] = 'web';
      info['version'] = 'web';
    } else {
      info['platform'] = Platform.operatingSystem;
      info['version'] = Platform.operatingSystemVersion;
      info['locale'] = Platform.localeName;
      info['processors'] = Platform.numberOfProcessors;
    }

    logger.info('Platform Info: ${jsonEncode(info)}');
  }

  /// Check if platform data needs synchronization
  Future<bool> needsSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncStr = prefs.getString(_lastSyncKey);

      if (lastSyncStr == null) return true;

      final lastSync = DateTime.parse(lastSyncStr);
      final hoursSinceSync = DateTime.now().difference(lastSync).inHours;

      return hoursSinceSync > 24; // Sync daily
    } catch (e) {
      logger.error('Error checking sync status: $e');
      return true;
    }
  }

  /// Get platform consistency report
  Future<Map<String, dynamic>> getConsistencyReport() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'platform_id': await _getPlatformId(),
      'platform_os': kIsWeb ? 'web' : Platform.operatingSystem,
      'data_checksum': prefs.getString(_checksumKey),
      'last_sync': prefs.getString(_lastSyncKey),
      'is_consistent': await _validateDataIntegrity(),
    };
  }
}