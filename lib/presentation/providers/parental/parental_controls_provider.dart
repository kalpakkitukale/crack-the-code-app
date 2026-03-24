// Parental Controls Provider
// Manages parental control state using Riverpod

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/services/secure_storage_service.dart';
import 'package:streamshaala/domain/entities/parental/parental_settings.dart';

/// Result of PIN verification attempt
enum PinVerificationResult {
  success,
  incorrect,
  lockedOut,
}

/// Keys for storing parental control data
class _ParentalKeys {
  static const String settings = 'parental_settings';
  static const String screenTimeUsage = 'screen_time_usage';
  static const String sessionStartTime = 'session_start_time';
  static const String pinFailedAttempts = 'pin_failed_attempts';
  static const String pinLockoutUntil = 'pin_lockout_until';
}

/// PIN brute-force protection constants
class _PinSecurityConstants {
  static const int maxAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration attemptResetDuration = Duration(hours: 1);
}

/// State for parental controls
class ParentalControlsState {
  final ParentalSettings settings;
  final ScreenTimeUsage usage;
  final bool isParentMode;
  final bool isLoading;
  final String? error;
  final String? userEmail; // Email for PIN recovery
  final int failedPinAttempts;
  final DateTime? lockedUntil;

  const ParentalControlsState({
    this.settings = const ParentalSettings(),
    required this.usage,
    this.isParentMode = false,
    this.isLoading = false,
    this.error,
    this.userEmail,
    this.failedPinAttempts = 0,
    this.lockedUntil,
  });

  ParentalControlsState copyWith({
    ParentalSettings? settings,
    ScreenTimeUsage? usage,
    bool? isParentMode,
    bool? isLoading,
    String? error,
    String? userEmail,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool clearLockedUntil = false,
  }) {
    return ParentalControlsState(
      settings: settings ?? this.settings,
      usage: usage ?? this.usage,
      isParentMode: isParentMode ?? this.isParentMode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userEmail: userEmail ?? this.userEmail,
      failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
      lockedUntil: clearLockedUntil ? null : (lockedUntil ?? this.lockedUntil),
    );
  }

  /// Check if PIN entry is currently locked out
  bool get isPinLocked {
    if (lockedUntil == null) return false;
    return DateTime.now().isBefore(lockedUntil!);
  }

  /// Get remaining lockout time in minutes
  int get lockoutRemainingMinutes {
    if (lockedUntil == null) return 0;
    final remaining = lockedUntil!.difference(DateTime.now());
    return remaining.isNegative ? 0 : remaining.inMinutes + 1;
  }

  /// Get remaining PIN attempts before lockout
  int get remainingPinAttempts {
    return (_PinSecurityConstants.maxAttempts - failedPinAttempts).clamp(0, _PinSecurityConstants.maxAttempts);
  }

  /// Check if screen time limit is reached
  bool get isScreenTimeLimitReached {
    if (!settings.isEnabled) return false;
    if (!settings.screenTimeLimit.hasLimit) return false;
    return usage.limitReached;
  }

  /// Get remaining screen time in minutes
  int get remainingMinutes {
    return usage.remainingMinutes(settings.screenTimeLimit);
  }

  /// Check if warning should be shown (5 minutes remaining)
  bool get shouldShowTimeWarning {
    if (!settings.isEnabled) return false;
    if (!settings.screenTimeLimit.hasLimit) return false;
    final remaining = remainingMinutes;
    return remaining > 0 && remaining <= 5;
  }
}

/// Parental Controls Notifier
class ParentalControlsNotifier extends StateNotifier<ParentalControlsState> {
  Timer? _usageTimer;
  DateTime? _sessionStart;

  ParentalControlsNotifier()
      : super(ParentalControlsState(usage: ScreenTimeUsage.today())) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load settings
      final settingsJson = prefs.getString(_ParentalKeys.settings);
      final settings = settingsJson != null
          ? ParentalSettings.fromJson(
              jsonDecode(settingsJson) as Map<String, dynamic>)
          : const ParentalSettings();

      // Load usage - reset if not today
      final usageJson = prefs.getString(_ParentalKeys.screenTimeUsage);
      var usage = usageJson != null
          ? ScreenTimeUsage.fromJson(
              jsonDecode(usageJson) as Map<String, dynamic>)
          : ScreenTimeUsage.today();

      // Reset usage if it's a new day
      if (!usage.isToday) {
        usage = ScreenTimeUsage.today();
        await _saveUsage(usage);
      }

      // Check if there was an active session (app crash recovery)
      final sessionStartStr = prefs.getString(_ParentalKeys.sessionStartTime);
      if (sessionStartStr != null) {
        _sessionStart = DateTime.parse(sessionStartStr);
      }

      // Load PIN security state from secure storage
      final failedAttempts = await secureStorage.readInt(SecureStorageKeys.pinFailedAttempts) ?? 0;
      DateTime? lockedUntil = await secureStorage.readDateTime(SecureStorageKeys.pinLockoutUntil);

      // Clear lockout if it's expired
      if (lockedUntil != null && DateTime.now().isAfter(lockedUntil)) {
        await secureStorage.delete(SecureStorageKeys.pinLockoutUntil);
        await secureStorage.delete(SecureStorageKeys.pinFailedAttempts);
        lockedUntil = null;
      }

      // Migrate old SharedPreferences data to secure storage (one-time migration)
      final oldFailedAttempts = prefs.getInt(_ParentalKeys.pinFailedAttempts);
      if (oldFailedAttempts != null) {
        await secureStorage.writeInt(SecureStorageKeys.pinFailedAttempts, oldFailedAttempts);
        await prefs.remove(_ParentalKeys.pinFailedAttempts);
      }
      final oldLockoutStr = prefs.getString(_ParentalKeys.pinLockoutUntil);
      if (oldLockoutStr != null) {
        await secureStorage.write(SecureStorageKeys.pinLockoutUntil, oldLockoutStr);
        await prefs.remove(_ParentalKeys.pinLockoutUntil);
      }

      state = state.copyWith(
        settings: settings,
        usage: usage,
        isLoading: false,
        failedPinAttempts: lockedUntil != null ? failedAttempts : 0,
        lockedUntil: lockedUntil,
      );

      // Start tracking if parental controls are enabled
      if (settings.isEnabled && settings.screenTimeLimit.hasLimit) {
        _startUsageTracking();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load parental settings: $e',
      );
    }
  }

  /// Number of iterations for key stretching (OWASP recommends 600,000 for SHA-256)
  /// Using 100,000 as a balance between security and mobile performance
  static const int _hashIterations = 100000;

  /// Delimiter for storing salt:hash format
  static const String _hashDelimiter = ':';

  /// Generate a cryptographically secure salt
  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// Hash PIN with salt and key stretching for secure storage
  /// Uses iterated HMAC-SHA256 for protection against brute force
  /// Returns format: "salt:hash"
  String _hashPinSecure(String pin, String salt) {
    // Start with salted PIN
    List<int> data = utf8.encode('$salt$pin');

    // Apply key stretching with HMAC-SHA256
    final hmacKey = utf8.encode(salt);
    for (var i = 0; i < _hashIterations; i++) {
      final hmac = Hmac(sha256, hmacKey);
      data = hmac.convert(data).bytes;
    }

    // Return salt:hash format for storage
    final hash = base64Encode(data);
    return '$salt$_hashDelimiter$hash';
  }

  /// Hash PIN for secure storage (legacy - used for migration only)
  String _hashPinLegacy(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if a stored hash uses the new secure format
  bool _isSecureHashFormat(String? hash) {
    if (hash == null) return false;
    return hash.contains(_hashDelimiter);
  }

  /// Verify PIN matches stored hash (supports both legacy and secure formats)
  bool verifyPin(String pin) {
    final storedHash = state.settings.pinHash;
    if (storedHash == null) return false;

    if (_isSecureHashFormat(storedHash)) {
      // New secure format: salt:hash
      final parts = storedHash.split(_hashDelimiter);
      if (parts.length != 2) return false;

      final salt = parts[0];
      final expectedHash = _hashPinSecure(pin, salt);
      return storedHash == expectedHash;
    } else {
      // Legacy format: plain SHA-256 hash
      return _hashPinLegacy(pin) == storedHash;
    }
  }

  /// Upgrade legacy hash to secure format (call after successful legacy verification)
  Future<void> _upgradePinHashIfNeeded(String pin) async {
    final storedHash = state.settings.pinHash;
    if (storedHash == null || _isSecureHashFormat(storedHash)) return;

    // Generate new secure hash
    final salt = _generateSalt();
    final secureHash = _hashPinSecure(pin, salt);

    // Update settings with secure hash
    final newSettings = state.settings.copyWith(
      pinHash: secureHash,
      updatedAt: DateTime.now(),
    );
    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  /// Set up parental controls with PIN
  Future<bool> setupParentalControls(String pin) async {
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      state = state.copyWith(error: 'PIN must be 4 digits');
      return false;
    }

    // Generate salt and create secure hash
    final salt = _generateSalt();
    final secureHash = _hashPinSecure(pin, salt);

    final newSettings = state.settings.copyWith(
      isEnabled: true,
      pinHash: secureHash,
      pinChangedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings, error: null);

    // Start usage tracking
    _startUsageTracking();

    return true;
  }

  /// Enter parent mode with PIN verification
  /// Returns a result indicating success or the type of failure
  Future<PinVerificationResult> enterParentMode(String pin) async {
    // Check if currently locked out
    if (state.isPinLocked) {
      state = state.copyWith(
        error: 'Too many failed attempts. Try again in ${state.lockoutRemainingMinutes} minutes.',
      );
      return PinVerificationResult.lockedOut;
    }

    if (verifyPin(pin)) {
      // Success - reset failed attempts
      await _resetFailedAttempts();

      // Upgrade legacy hash to secure format if needed
      await _upgradePinHashIfNeeded(pin);

      state = state.copyWith(
        isParentMode: true,
        error: null,
        failedPinAttempts: 0,
        clearLockedUntil: true,
      );
      return PinVerificationResult.success;
    }

    // Failed attempt - track it
    final newFailedAttempts = state.failedPinAttempts + 1;
    await _recordFailedAttempt(newFailedAttempts);

    if (newFailedAttempts >= _PinSecurityConstants.maxAttempts) {
      // Lockout triggered
      final lockoutUntil = DateTime.now().add(_PinSecurityConstants.lockoutDuration);
      await _setLockout(lockoutUntil);
      state = state.copyWith(
        error: 'Too many failed attempts. Locked for ${_PinSecurityConstants.lockoutDuration.inMinutes} minutes.',
        failedPinAttempts: newFailedAttempts,
        lockedUntil: lockoutUntil,
      );
      return PinVerificationResult.lockedOut;
    }

    final remainingAttempts = _PinSecurityConstants.maxAttempts - newFailedAttempts;
    state = state.copyWith(
      error: 'Incorrect PIN. $remainingAttempts attempts remaining.',
      failedPinAttempts: newFailedAttempts,
    );
    return PinVerificationResult.incorrect;
  }

  /// Record a failed PIN attempt (stored securely)
  Future<void> _recordFailedAttempt(int attempts) async {
    await secureStorage.writeInt(
      SecureStorageKeys.pinFailedAttempts,
      attempts,
    );
  }

  /// Set lockout time (stored securely)
  Future<void> _setLockout(DateTime until) async {
    await secureStorage.writeDateTime(
      SecureStorageKeys.pinLockoutUntil,
      until,
    );
  }

  /// Reset failed attempts after successful login
  Future<void> _resetFailedAttempts() async {
    await secureStorage.delete(SecureStorageKeys.pinFailedAttempts);
    await secureStorage.delete(SecureStorageKeys.pinLockoutUntil);
  }

  /// Exit parent mode
  void exitParentMode() {
    state = state.copyWith(isParentMode: false);
  }

  /// Update screen time limit
  Future<void> updateScreenTimeLimit(ScreenTimeLimit limit) async {
    final newSettings = state.settings.copyWith(
      screenTimeLimit: limit,
      updatedAt: DateTime.now(),
    );
    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);

    // Restart tracking with new limit
    if (limit.hasLimit) {
      _startUsageTracking();
    } else {
      _stopUsageTracking();
    }
  }

  /// Update difficulty filter
  Future<void> updateDifficultyFilter(DifficultyFilter filter) async {
    final newSettings = state.settings.copyWith(
      difficultyFilter: filter,
      updatedAt: DateTime.now(),
    );
    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  /// Toggle show timer to child
  Future<void> toggleShowTimerToChild(bool show) async {
    final newSettings = state.settings.copyWith(
      showTimerToChild: show,
      updatedAt: DateTime.now(),
    );
    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  /// Extend screen time by specified minutes (parent only)
  Future<void> extendScreenTime(int minutes) async {
    if (!state.isParentMode) return;

    final newUsage = state.usage.copyWith(
      minutesUsed: (state.usage.minutesUsed - minutes).clamp(0, 9999),
      limitReached: false,
      wasExtended: true,
    );

    await _saveUsage(newUsage);
    state = state.copyWith(usage: newUsage);
  }

  /// Disable parental controls (requires PIN)
  Future<bool> disableParentalControls(String pin) async {
    if (!verifyPin(pin)) {
      state = state.copyWith(error: 'Incorrect PIN');
      return false;
    }

    final newSettings = state.settings.copyWith(
      isEnabled: false,
      updatedAt: DateTime.now(),
    );

    await _saveSettings(newSettings);
    state = state.copyWith(
      settings: newSettings,
      isParentMode: false,
      error: null,
    );

    _stopUsageTracking();

    return true;
  }

  /// Change PIN (requires old PIN)
  Future<bool> changePin(String oldPin, String newPin) async {
    if (!verifyPin(oldPin)) {
      state = state.copyWith(error: 'Incorrect current PIN');
      return false;
    }

    if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) {
      state = state.copyWith(error: 'New PIN must be 4 digits');
      return false;
    }

    // Generate new salt and create secure hash
    final salt = _generateSalt();
    final secureHash = _hashPinSecure(newPin, salt);

    final newSettings = state.settings.copyWith(
      pinHash: secureHash,
      pinChangedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveSettings(newSettings);
    state = state.copyWith(settings: newSettings, error: null);

    return true;
  }

  /// Start tracking screen time usage
  void _startUsageTracking() {
    _stopUsageTracking();

    _sessionStart = DateTime.now();
    _saveSessionStart(_sessionStart!);

    // Update usage every minute
    _usageTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateUsage();
    });
  }

  /// Stop tracking screen time usage
  void _stopUsageTracking() {
    _usageTimer?.cancel();
    _usageTimer = null;

    // Record session end if there was an active session
    if (_sessionStart != null) {
      _endSession();
    }
  }

  /// Update usage for the current session
  void _updateUsage() {
    if (_sessionStart == null) return;

    final totalMinutes = state.usage.minutesUsed + 1; // Add 1 minute

    var newUsage = state.usage.copyWith(
      minutesUsed: totalMinutes,
    );

    // Check if limit reached
    if (state.settings.screenTimeLimit.hasLimit) {
      final remaining =
          newUsage.remainingMinutes(state.settings.screenTimeLimit);
      if (remaining <= 0) {
        newUsage = newUsage.copyWith(limitReached: true);
      }
    }

    _saveUsage(newUsage);
    state = state.copyWith(usage: newUsage);
  }

  /// End the current session
  void _endSession() async {
    if (_sessionStart == null) return;

    final now = DateTime.now();
    final newUsage = state.usage.copyWith(
      sessionStarts: [...state.usage.sessionStarts, _sessionStart!],
      sessionEnds: [...state.usage.sessionEnds, now],
    );

    await _saveUsage(newUsage);
    await _clearSessionStart();
    _sessionStart = null;
    state = state.copyWith(usage: newUsage);
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings(ParentalSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _ParentalKeys.settings,
      jsonEncode(settings.toJson()),
    );
  }

  /// Save usage to SharedPreferences
  Future<void> _saveUsage(ScreenTimeUsage usage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _ParentalKeys.screenTimeUsage,
      jsonEncode(usage.toJson()),
    );
  }

  /// Save session start time
  Future<void> _saveSessionStart(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _ParentalKeys.sessionStartTime,
      time.toIso8601String(),
    );
  }

  /// Clear session start time
  Future<void> _clearSessionStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ParentalKeys.sessionStartTime);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset all parental control settings (forgot PIN recovery)
  Future<void> resetAllSettings() async {
    _stopUsageTracking();

    // Clear all stored data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ParentalKeys.settings);
    await prefs.remove(_ParentalKeys.screenTimeUsage);
    await prefs.remove(_ParentalKeys.sessionStartTime);

    // Reset state to defaults
    state = ParentalControlsState(
      settings: const ParentalSettings(),
      usage: ScreenTimeUsage.today(),
      isParentMode: false,
      isLoading: false,
      error: null,
      userEmail: state.userEmail,
    );
  }

  @override
  void dispose() {
    _stopUsageTracking();
    super.dispose();
  }
}

/// Provider for parental controls
final parentalControlsProvider =
    StateNotifierProvider<ParentalControlsNotifier, ParentalControlsState>(
  (ref) => ParentalControlsNotifier(),
);

/// Provider to check if parental controls should be shown
/// Only show in Junior segment
final shouldShowParentalControlsProvider = Provider<bool>((ref) {
  return SegmentConfig.settings.showParentalControls;
});

/// Provider for remaining screen time string
final remainingTimeStringProvider = Provider<String?>((ref) {
  final state = ref.watch(parentalControlsProvider);

  if (!state.settings.isEnabled) return null;
  if (!state.settings.screenTimeLimit.hasLimit) return null;
  if (!state.settings.showTimerToChild) return null;

  final remaining = state.remainingMinutes;
  if (remaining < 0) return null;

  if (remaining >= 60) {
    final hours = remaining ~/ 60;
    final mins = remaining % 60;
    return mins > 0 ? '${hours}h ${mins}m left' : '${hours}h left';
  }

  return '$remaining min left';
});
