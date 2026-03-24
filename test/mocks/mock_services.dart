/// Mock Services for Testing
///
/// Provides mock implementations of core services for provider and repository testing.
/// These mocks allow testing without real network connections, storage, or platform APIs.
library;

import 'dart:async';

import 'package:crack_the_code/core/services/connectivity_service.dart';
import 'package:crack_the_code/core/services/secure_http_client.dart';

/// Mock ConnectivityService for testing offline/online scenarios
///
/// This mock allows tests to simulate various connectivity states
/// without relying on actual network conditions.
class MockConnectivityService {
  ConnectivityStatus _status = ConnectivityStatus.wifi;
  final _controller = StreamController<ConnectivityStatus>.broadcast();
  bool _isInitialized = false;

  ConnectivityStatus get currentStatus => _status;

  Stream<ConnectivityStatus> get onStatusChange => _controller.stream;

  bool get isOnline => _status.isConnected;

  bool get isOffline => !_status.isConnected;

  bool get isWifi => _status == ConnectivityStatus.wifi;

  bool get isMobile => _status == ConnectivityStatus.mobile;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _isInitialized = true;
  }

  void dispose() {
    _controller.close();
  }

  Future<ConnectivityStatus> checkConnectivity() async {
    return _status;
  }

  // Test helpers
  void setStatus(ConnectivityStatus status) {
    _status = status;
    _controller.add(status);
  }

  void setOnline() => setStatus(ConnectivityStatus.wifi);
  void setOffline() => setStatus(ConnectivityStatus.offline);
  void setMobileData() => setStatus(ConnectivityStatus.mobile);
}

/// Mock SecureStorageService for testing secure storage operations
///
/// This is a fake implementation that mimics SecureStorageService behavior
/// without requiring flutter_secure_storage or platform channels.
class MockSecureStorageService {
  final Map<String, String> _store = {};
  Exception? _nextException;
  bool _shouldFail = false;

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void setShouldFail(bool shouldFail) {
    _shouldFail = shouldFail;
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  /// Write a value to secure storage (returns bool like the real service)
  Future<bool> write(String key, String value) async {
    _checkException();
    if (_shouldFail) return false;
    _store[key] = value;
    return true;
  }

  /// Read a value from secure storage
  Future<String?> read(String key) async {
    _checkException();
    return _store[key];
  }

  /// Delete a value from secure storage
  Future<bool> delete(String key) async {
    _checkException();
    if (_shouldFail) return false;
    _store.remove(key);
    return true;
  }

  /// Delete all values from secure storage
  Future<bool> deleteAll() async {
    _checkException();
    if (_shouldFail) return false;
    _store.clear();
    return true;
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    _checkException();
    return _store.containsKey(key);
  }

  /// Read all values from secure storage
  Future<Map<String, String>> readAll() async {
    _checkException();
    return Map.from(_store);
  }

  // Test helpers
  void clear() {
    _store.clear();
    _nextException = null;
    _shouldFail = false;
  }

  Map<String, String> get store => Map.from(_store);
}

/// Mock SecureHttpClient for testing API calls
///
/// This mock allows tests to simulate HTTP responses without
/// making real network requests.
class MockSecureHttpClient {
  final Map<String, SecureHttpResult> _responses = {};
  final List<String> _requestLog = [];
  Exception? _nextException;
  Duration? _responseDelay;

  SecureHttpConfig get config => SecureHttpConfig();

  void setResponse(String url, SecureHttpResult result) {
    _responses[url] = result;
  }

  void setSuccessResponse(String url, String body, {int statusCode = 200}) {
    _responses[url] = SecureHttpResult(
      statusCode: statusCode,
      body: body,
      headers: const {},
    );
  }

  void setErrorResponse(String url, int statusCode, String error) {
    _responses[url] = SecureHttpResult(
      statusCode: statusCode,
      body: error,
      headers: const {},
    );
  }

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  void setResponseDelay(Duration delay) {
    _responseDelay = delay;
  }

  Future<void> _applyDelay() async {
    if (_responseDelay != null) {
      await Future.delayed(_responseDelay!);
    }
  }

  void _checkException() {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }
  }

  Future<SecureHttpResult> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    _checkException();
    await _applyDelay();
    _requestLog.add('GET $url');

    if (_responses.containsKey(url)) {
      return _responses[url]!;
    }

    return SecureHttpResult(
      statusCode: 404,
      body: 'Not found',
      headers: const {},
    );
  }

  Future<SecureHttpResult> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    _checkException();
    await _applyDelay();
    _requestLog.add('POST $url');

    if (_responses.containsKey(url)) {
      return _responses[url]!;
    }

    return SecureHttpResult(
      statusCode: 404,
      body: 'Not found',
      headers: const {},
    );
  }

  Future<SecureHttpResult> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    _checkException();
    await _applyDelay();
    _requestLog.add('PUT $url');

    if (_responses.containsKey(url)) {
      return _responses[url]!;
    }

    return SecureHttpResult(
      statusCode: 404,
      body: 'Not found',
      headers: const {},
    );
  }

  Future<SecureHttpResult> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    _checkException();
    await _applyDelay();
    _requestLog.add('DELETE $url');

    if (_responses.containsKey(url)) {
      return _responses[url]!;
    }

    return SecureHttpResult(
      statusCode: 404,
      body: 'Not found',
      headers: const {},
    );
  }

  // Test helpers
  void clear() {
    _responses.clear();
    _requestLog.clear();
    _nextException = null;
    _responseDelay = null;
  }

  List<String> get requestLog => List.from(_requestLog);
  int get requestCount => _requestLog.length;
}

/// Mock YouTubeMetadataService for testing video metadata fetching
class MockYouTubeMetadataService {
  final Map<String, Map<String, String?>> _metadata = {};
  Exception? _nextException;

  void setMetadata(
    String videoId, {
    String? title,
    String? channelName,
    String? thumbnailUrl,
  }) {
    _metadata[videoId] = {
      'title': title ?? 'Test Video $videoId',
      'channelName': channelName ?? 'Test Channel',
      'thumbnailUrl': thumbnailUrl ?? 'https://example.com/thumb/$videoId.jpg',
    };
  }

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  Future<Map<String, String?>?> fetchMetadata(String videoId) async {
    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }

    return _metadata[videoId];
  }

  // Test helpers
  void clear() {
    _metadata.clear();
    _nextException = null;
  }
}

/// Mock AudioPlayerService for testing audio playback
class MockAudioPlayerService {
  bool _isPlaying = false;
  double _position = 0;
  double _duration = 0;
  double _speed = 1.0;
  String? _currentUrl;
  final _positionController = StreamController<Duration>.broadcast();
  final _stateController = StreamController<bool>.broadcast();

  bool get isPlaying => _isPlaying;
  double get position => _position;
  double get duration => _duration;
  double get speed => _speed;
  String? get currentUrl => _currentUrl;

  Stream<Duration> get positionStream => _positionController.stream;
  Stream<bool> get playingStream => _stateController.stream;

  Future<void> play(String url) async {
    _currentUrl = url;
    _isPlaying = true;
    _stateController.add(true);
  }

  Future<void> pause() async {
    _isPlaying = false;
    _stateController.add(false);
  }

  Future<void> stop() async {
    _isPlaying = false;
    _currentUrl = null;
    _position = 0;
    _stateController.add(false);
  }

  Future<void> seek(Duration position) async {
    _position = position.inMilliseconds / 1000;
    _positionController.add(position);
  }

  Future<void> setSpeed(double speed) async {
    _speed = speed;
  }

  void dispose() {
    _positionController.close();
    _stateController.close();
  }

  // Test helpers
  void setDuration(double seconds) {
    _duration = seconds;
  }

  void setPosition(double seconds) {
    _position = seconds;
    _positionController.add(Duration(milliseconds: (seconds * 1000).toInt()));
  }

  void simulateComplete() {
    _position = _duration;
    _isPlaying = false;
    _stateController.add(false);
  }
}

/// Mock ErrorReportingService for testing error capture
class MockErrorReportingService {
  final List<CapturedError> _errors = [];
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;
  List<CapturedError> get capturedErrors => List.from(_errors);
  int get errorCount => _errors.length;

  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) async {
    if (_isEnabled) {
      _errors.add(CapturedError(
        exception: exception,
        stackTrace: stackTrace,
        extras: extras,
      ));
    }
  }

  Future<void> captureMessage(
    String message, {
    Map<String, dynamic>? extras,
  }) async {
    if (_isEnabled) {
      _errors.add(CapturedError(
        message: message,
        extras: extras,
      ));
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  // Test helpers
  void clear() {
    _errors.clear();
  }

  bool hasError(String message) {
    return _errors.any(
      (e) =>
          e.exception?.toString().contains(message) == true ||
          e.message?.contains(message) == true,
    );
  }
}

/// A captured error for testing purposes
class CapturedError {
  final dynamic exception;
  final String? message;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? extras;

  CapturedError({
    this.exception,
    this.message,
    this.stackTrace,
    this.extras,
  });
}

/// Factory methods to create pre-configured mock services
class MockServiceFactory {
  /// Create a mock connectivity service that's online
  static MockConnectivityService createOnlineConnectivity() {
    final service = MockConnectivityService();
    service.setOnline();
    return service;
  }

  /// Create a mock connectivity service that's offline
  static MockConnectivityService createOfflineConnectivity() {
    final service = MockConnectivityService();
    service.setOffline();
    return service;
  }

  /// Create a mock HTTP client with common success responses
  static MockSecureHttpClient createSuccessHttpClient() {
    return MockSecureHttpClient();
  }

  /// Create a mock secure storage with pre-populated data
  static MockSecureStorageService createSecureStorage({
    Map<String, String>? initialData,
  }) {
    final service = MockSecureStorageService();
    if (initialData != null) {
      for (final entry in initialData.entries) {
        service._store[entry.key] = entry.value;
      }
    }
    return service;
  }
}
