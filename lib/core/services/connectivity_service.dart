/// Connectivity Service
///
/// Monitors network connectivity status for offline mode handling.
/// The app uses an offline-first architecture where all data is saved
/// locally first, then synced to the server when online.
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Network connectivity status
enum ConnectivityStatus {
  /// No network connection
  offline,

  /// Connected via WiFi
  wifi,

  /// Connected via mobile data
  mobile,

  /// Connected via ethernet
  ethernet,

  /// Connection status unknown
  unknown,

  /// Legacy online status (for backward compatibility)
  online,
}

/// Extension methods for ConnectivityStatus
extension ConnectivityStatusX on ConnectivityStatus {
  /// Human-readable name
  String get displayName {
    switch (this) {
      case ConnectivityStatus.offline:
        return 'Offline';
      case ConnectivityStatus.wifi:
        return 'WiFi';
      case ConnectivityStatus.mobile:
        return 'Mobile Data';
      case ConnectivityStatus.ethernet:
        return 'Ethernet';
      case ConnectivityStatus.unknown:
        return 'Unknown';
      case ConnectivityStatus.online:
        return 'Online';
    }
  }

  /// Whether the device has any network connection
  bool get isConnected {
    switch (this) {
      case ConnectivityStatus.wifi:
      case ConnectivityStatus.mobile:
      case ConnectivityStatus.ethernet:
      case ConnectivityStatus.online:
        return true;
      case ConnectivityStatus.offline:
      case ConnectivityStatus.unknown:
        return false;
    }
  }

  /// Whether downloads should be allowed (conservative approach)
  bool get allowLargeDownloads {
    switch (this) {
      case ConnectivityStatus.wifi:
      case ConnectivityStatus.ethernet:
        return true;
      case ConnectivityStatus.mobile:
      case ConnectivityStatus.offline:
      case ConnectivityStatus.unknown:
      case ConnectivityStatus.online:
        return false;
    }
  }
}

/// Service for monitoring network connectivity
///
/// Provides:
/// - Current connectivity status
/// - Stream of connectivity changes
/// - Helper methods for checking connection type
class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;
  final _connectivityController = StreamController<ConnectivityStatus>.broadcast();
  bool _initialized = false;

  ConnectivityStatus _status = ConnectivityStatus.unknown;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Current connectivity status
  ConnectivityStatus get status => _status;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get statusStream => _connectivityController.stream;

  /// Whether the device has any network connection
  bool get isOnline => _status.isConnected;

  /// Whether the device is offline
  bool get isOffline => _status == ConnectivityStatus.offline;

  /// Whether the device is on WiFi (good for larger downloads)
  bool get isOnWifi => _status == ConnectivityStatus.wifi;

  /// Whether the device is on mobile data (may want to limit downloads)
  bool get isOnMobileData => _status == ConnectivityStatus.mobile;

  /// Initialize the service and start monitoring
  Future<void> initialize() async {
    if (_initialized) return;

    logger.info('Initializing connectivity service');

    try {
      // Get initial status
      final result = await _connectivity.checkConnectivity();
      _updateStatusFromResult(result);

      // Listen for changes
      _subscription = _connectivity.onConnectivityChanged.listen(
        _updateStatusFromResult,
        onError: (error) {
          logger.error('Connectivity monitoring error: $error');
          _status = ConnectivityStatus.unknown;
          _connectivityController.add(_status);
          notifyListeners();
        },
      );

      _initialized = true;
    } catch (e) {
      logger.error('Failed to initialize connectivity service: $e');
      _status = ConnectivityStatus.unknown;
    }
  }

  /// Check current connectivity (one-time check)
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatusFromResult(result);
    return _status.isConnected;
  }

  void _updateStatusFromResult(ConnectivityResult result) {
    _updateStatus([result]);
  }

  /// Update status manually (for testing or fallback)
  void updateStatus(ConnectivityStatus status) {
    if (_status != status) {
      _status = status;
      _connectivityController.add(_status);
      notifyListeners();
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus = _mapResults(results);

    if (newStatus != _status) {
      logger.info('Connectivity changed: $_status -> $newStatus');
      _status = newStatus;
      _connectivityController.add(_status);
      notifyListeners();
    }
  }

  ConnectivityStatus _mapResults(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }

    // Prefer WiFi if available
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.wifi;
    }

    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityStatus.ethernet;
    }

    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.mobile;
    }

    if (results.contains(ConnectivityResult.vpn)) {
      // VPN is typically over another connection type
      return ConnectivityStatus.wifi;
    }

    if (results.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth tethering
      return ConnectivityStatus.mobile;
    }

    return ConnectivityStatus.unknown;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
    super.dispose();
  }
}

/// Global connectivity service instance
final connectivityService = ConnectivityService();
