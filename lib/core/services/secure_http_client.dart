/// Secure HTTP Client
///
/// Provides a secure HTTP client with:
/// - Configurable timeouts
/// - Response size limits
/// - Request throttling/rate limiting
/// - URL validation
/// - Response validation
library;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crack_the_code/core/utils/logger.dart';

/// Configuration for the secure HTTP client
class SecureHttpConfig {
  /// Connection timeout
  final Duration connectionTimeout;

  /// Read timeout (time to receive response)
  final Duration readTimeout;

  /// Maximum response body size in bytes (default 10MB)
  final int maxResponseSize;

  /// Minimum delay between requests to same host (rate limiting)
  final Duration minRequestInterval;

  /// User agent string
  final String userAgent;

  /// List of allowed domains (null = allow all)
  final List<String>? allowedDomains;

  const SecureHttpConfig({
    this.connectionTimeout = const Duration(seconds: 30),
    this.readTimeout = const Duration(seconds: 60),
    this.maxResponseSize = 10 * 1024 * 1024, // 10MB
    this.minRequestInterval = const Duration(milliseconds: 100),
    this.userAgent = 'Crack the Code/1.0',
    this.allowedDomains,
  });

  /// Default configuration for content fetching
  static const SecureHttpConfig content = SecureHttpConfig(
    connectionTimeout: Duration(seconds: 30),
    readTimeout: Duration(seconds: 60),
    maxResponseSize: 50 * 1024 * 1024, // 50MB for content
    minRequestInterval: Duration(milliseconds: 50),
    allowedDomains: [
      'content.crackthecode.app',
      'crackthecode.app',
    ],
  );

  /// Default configuration for metadata/API calls
  static const SecureHttpConfig api = SecureHttpConfig(
    connectionTimeout: Duration(seconds: 15),
    readTimeout: Duration(seconds: 30),
    maxResponseSize: 1 * 1024 * 1024, // 1MB for API responses
    minRequestInterval: Duration(milliseconds: 200),
    allowedDomains: [
      'www.youtube.com',
      'youtube.com',
      'googleapis.com',
      'www.googleapis.com',
    ],
  );
}

/// Result of a secure HTTP request
class SecureHttpResult {
  final int statusCode;
  final String? body;
  final Map<String, String> headers;
  final String? error;
  final Duration? duration;

  const SecureHttpResult({
    required this.statusCode,
    this.body,
    this.headers = const {},
    this.error,
    this.duration,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isError => error != null || !isSuccess;

  /// Parse body as JSON
  Map<String, dynamic>? get json {
    if (body == null) return null;
    try {
      return jsonDecode(body!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Parse body as JSON list
  List<dynamic>? get jsonList {
    if (body == null) return null;
    try {
      return jsonDecode(body!) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }
}

/// Secure HTTP client with built-in security measures
class SecureHttpClient {
  final http.Client _client;
  final SecureHttpConfig config;
  final Map<String, DateTime> _lastRequestTimes = {};

  SecureHttpClient({
    http.Client? client,
    this.config = const SecureHttpConfig(),
  }) : _client = client ?? http.Client();

  /// Validate that a URL is allowed
  bool _isAllowedUrl(Uri uri) {
    // Must be HTTPS (except for localhost in debug)
    if (uri.scheme != 'https') {
      // Allow http for localhost in debug builds
      if (uri.scheme == 'http' && uri.host == 'localhost') {
        return true;
      }
      logger.warning('Blocked non-HTTPS URL: $uri');
      return false;
    }

    // Check allowed domains if configured
    if (config.allowedDomains != null) {
      final host = uri.host.toLowerCase();
      final isAllowed = config.allowedDomains!.any(
        (domain) => host == domain || host.endsWith('.$domain'),
      );

      if (!isAllowed) {
        logger.warning('Blocked URL from non-allowed domain: $uri');
        return false;
      }
    }

    return true;
  }

  /// Apply rate limiting for a host
  Future<void> _applyRateLimit(String host) async {
    final lastRequest = _lastRequestTimes[host];
    if (lastRequest != null) {
      final elapsed = DateTime.now().difference(lastRequest);
      if (elapsed < config.minRequestInterval) {
        final waitTime = config.minRequestInterval - elapsed;
        await Future.delayed(waitTime);
      }
    }
    _lastRequestTimes[host] = DateTime.now();
  }

  /// Validate response size
  bool _isResponseSizeValid(http.Response response) {
    final contentLength = response.contentLength ?? response.bodyBytes.length;
    if (contentLength > config.maxResponseSize) {
      logger.warning(
        'Response size ($contentLength) exceeds maximum (${config.maxResponseSize})',
      );
      return false;
    }
    return true;
  }

  /// Perform a secure GET request
  Future<SecureHttpResult> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final uri = Uri.parse(url);

      // Validate URL
      if (!_isAllowedUrl(uri)) {
        return SecureHttpResult(
          statusCode: 403,
          error: 'URL not allowed: $url',
          duration: stopwatch.elapsed,
        );
      }

      // Apply rate limiting
      await _applyRateLimit(uri.host);

      // Build headers
      final requestHeaders = {
        'User-Agent': config.userAgent,
        ...?headers,
      };

      // Make request with timeout
      final response = await _client
          .get(uri, headers: requestHeaders)
          .timeout(config.connectionTimeout + config.readTimeout);

      stopwatch.stop();

      // Validate response size
      if (!_isResponseSizeValid(response)) {
        return SecureHttpResult(
          statusCode: 413,
          error: 'Response too large',
          duration: stopwatch.elapsed,
        );
      }

      return SecureHttpResult(
        statusCode: response.statusCode,
        body: response.body,
        headers: response.headers,
        duration: stopwatch.elapsed,
      );
    } on TimeoutException {
      stopwatch.stop();
      logger.warning('Request timeout: $url');
      return SecureHttpResult(
        statusCode: 408,
        error: 'Request timeout',
        duration: stopwatch.elapsed,
      );
    } on FormatException catch (e) {
      stopwatch.stop();
      logger.warning('Invalid URL format: $url - $e');
      return SecureHttpResult(
        statusCode: 400,
        error: 'Invalid URL format',
        duration: stopwatch.elapsed,
      );
    } catch (e, stackTrace) {
      stopwatch.stop();
      logger.error('HTTP request failed: $url', e, stackTrace);
      return SecureHttpResult(
        statusCode: 0,
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Perform a secure POST request
  Future<SecureHttpResult> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    String contentType = 'application/json',
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final uri = Uri.parse(url);

      // Validate URL
      if (!_isAllowedUrl(uri)) {
        return SecureHttpResult(
          statusCode: 403,
          error: 'URL not allowed: $url',
          duration: stopwatch.elapsed,
        );
      }

      // Apply rate limiting
      await _applyRateLimit(uri.host);

      // Build headers
      final requestHeaders = {
        'User-Agent': config.userAgent,
        'Content-Type': contentType,
        ...?headers,
      };

      // Encode body
      final encodedBody = body is String ? body : jsonEncode(body);

      // Make request with timeout
      final response = await _client
          .post(uri, headers: requestHeaders, body: encodedBody)
          .timeout(config.connectionTimeout + config.readTimeout);

      stopwatch.stop();

      // Validate response size
      if (!_isResponseSizeValid(response)) {
        return SecureHttpResult(
          statusCode: 413,
          error: 'Response too large',
          duration: stopwatch.elapsed,
        );
      }

      return SecureHttpResult(
        statusCode: response.statusCode,
        body: response.body,
        headers: response.headers,
        duration: stopwatch.elapsed,
      );
    } on TimeoutException {
      stopwatch.stop();
      logger.warning('Request timeout: $url');
      return SecureHttpResult(
        statusCode: 408,
        error: 'Request timeout',
        duration: stopwatch.elapsed,
      );
    } on FormatException catch (e) {
      stopwatch.stop();
      logger.warning('Invalid URL format: $url - $e');
      return SecureHttpResult(
        statusCode: 400,
        error: 'Invalid URL format',
        duration: stopwatch.elapsed,
      );
    } catch (e, stackTrace) {
      stopwatch.stop();
      logger.error('HTTP POST request failed: $url', e, stackTrace);
      return SecureHttpResult(
        statusCode: 0,
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Clear rate limit history
  void clearRateLimits() {
    _lastRequestTimes.clear();
  }

  /// Dispose resources
  void dispose() {
    _client.close();
    _lastRequestTimes.clear();
  }
}

/// API response validator
class ApiResponseValidator {
  /// Validate that a JSON response has required fields
  static bool validateRequiredFields(
    Map<String, dynamic>? json,
    List<String> requiredFields,
  ) {
    if (json == null) return false;
    for (final field in requiredFields) {
      if (!json.containsKey(field)) {
        logger.warning('Missing required field: $field');
        return false;
      }
    }
    return true;
  }

  /// Validate that a string field is present and not empty
  static bool validateStringField(
    Map<String, dynamic>? json,
    String field, {
    int maxLength = 10000,
  }) {
    if (json == null) return false;
    final value = json[field];
    if (value is! String) return false;
    if (value.isEmpty) return false;
    if (value.length > maxLength) {
      logger.warning('Field $field exceeds max length: ${value.length} > $maxLength');
      return false;
    }
    return true;
  }

  /// Validate that a list field is present and has valid length
  static bool validateListField(
    Map<String, dynamic>? json,
    String field, {
    int minLength = 0,
    int maxLength = 10000,
  }) {
    if (json == null) return false;
    final value = json[field];
    if (value is! List) return false;
    if (value.length < minLength) return false;
    if (value.length > maxLength) {
      logger.warning('Field $field exceeds max length: ${value.length} > $maxLength');
      return false;
    }
    return true;
  }

  /// Sanitize a string value from API response
  static String sanitizeString(String? value, {String defaultValue = ''}) {
    if (value == null || value.isEmpty) return defaultValue;
    // Remove null bytes and control characters (except newlines and tabs)
    return value
        .replaceAll('\x00', '')
        .replaceAll(RegExp(r'[\x01-\x08\x0B\x0C\x0E-\x1F]'), '');
  }
}

/// Global secure HTTP client instances
final secureContentClient = SecureHttpClient(
  config: SecureHttpConfig.content,
);

final secureApiClient = SecureHttpClient(
  config: SecureHttpConfig.api,
);
