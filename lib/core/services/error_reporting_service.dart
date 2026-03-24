/// Error Reporting Service
///
/// Provides a unified interface for reporting errors to Firebase Crashlytics.
/// Handles debug/release mode differences automatically.
library;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Service for reporting errors to Firebase Crashlytics
class ErrorReportingService {
  static final ErrorReportingService _instance = ErrorReportingService._();
  static ErrorReportingService get instance => _instance;

  ErrorReportingService._();

  /// Whether error reporting is enabled
  bool get isEnabled => !kDebugMode;

  /// Report a non-fatal error to Crashlytics
  ///
  /// [error] - The error that occurred
  /// [stackTrace] - The stack trace when the error occurred
  /// [reason] - Optional context about why/where the error occurred
  /// [information] - Optional additional key-value pairs for debugging
  Future<void> reportError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, String>? information,
  }) async {
    logger.error(reason ?? 'Error reported', error, stackTrace);

    if (!isEnabled) {
      logger.debug('Error reporting disabled in debug mode');
      return;
    }

    try {
      // Add custom keys if provided
      if (information != null) {
        for (final entry in information.entries) {
          await FirebaseCrashlytics.instance.setCustomKey(entry.key, entry.value);
        }
      }

      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );
    } catch (e) {
      logger.warning('Failed to report error to Crashlytics: $e');
    }
  }

  /// Report a fatal error (crash) to Crashlytics
  ///
  /// Use this for errors that cause the app to become unusable
  Future<void> reportFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
  }) async {
    logger.error('FATAL: ${reason ?? 'Fatal error'}', error, stackTrace);

    if (!isEnabled) {
      return;
    }

    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: true,
      );
    } catch (e) {
      logger.warning('Failed to report fatal error to Crashlytics: $e');
    }
  }

  /// Set user identifier for crash reports
  ///
  /// [userId] - The user's ID (anonymized if possible)
  Future<void> setUserId(String? userId) async {
    if (!isEnabled || userId == null) {
      return;
    }

    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    } catch (e) {
      logger.warning('Failed to set user ID in Crashlytics: $e');
    }
  }

  /// Add custom key-value pair for crash reports
  ///
  /// [key] - The key name
  /// [value] - The value (must be String, bool, int, or double)
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!isEnabled) {
      return;
    }

    try {
      if (value is String) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is bool) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is int) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is double) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else {
        await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
      }
    } catch (e) {
      logger.warning('Failed to set custom key in Crashlytics: $e');
    }
  }

  /// Log a message to Crashlytics (visible in crash reports)
  ///
  /// [message] - The log message
  Future<void> log(String message) async {
    if (!isEnabled) {
      return;
    }

    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      logger.warning('Failed to log to Crashlytics: $e');
    }
  }
}

/// Global error reporting service instance
final errorReporting = ErrorReportingService.instance;
