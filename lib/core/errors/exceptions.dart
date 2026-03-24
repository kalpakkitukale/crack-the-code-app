/// Custom exception classes for StreamShaala
///
/// These exceptions are thrown in the data layer and converted to Failures
/// in the repository implementations for proper error handling.
library;

/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when database operations fail
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when JSON parsing fails
class JsonParseException extends AppException {
  final String filePath;

  const JsonParseException({
    required super.message,
    required this.filePath,
    super.code,
    super.details,
  });

  @override
  String toString() => 'JsonParseException: $message at $filePath${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when an asset file is not found
class AssetNotFoundException extends AppException {
  final String assetPath;

  const AssetNotFoundException({
    required super.message,
    required this.assetPath,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AssetNotFoundException: $message - Asset: $assetPath';
}

/// Thrown when a requested item is not found
class NotFoundException extends AppException {
  final String entityType;
  final String entityId;

  const NotFoundException({
    required super.message,
    required this.entityType,
    required this.entityId,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NotFoundException: $entityType with ID "$entityId" not found';
}

/// Thrown when data validation fails
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code,
    super.details,
  });

  @override
  String toString() {
    final buffer = StringBuffer('ValidationException: $message');
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      buffer.write('\nField Errors:');
      fieldErrors!.forEach((field, error) {
        buffer.write('\n  - $field: $error');
      });
    }
    return buffer.toString();
  }
}

/// Thrown when a cache operation fails
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CacheException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when platform-specific operations fail
class PlatformException extends AppException {
  final String platform;

  const PlatformException({
    required super.message,
    required this.platform,
    super.code,
    super.details,
  });

  @override
  String toString() => 'PlatformException [$platform]: $message';
}

/// Thrown when storage operations fail (file system, preferences, etc.)
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'StorageException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when data format is invalid
class FormatException extends AppException {
  final String expectedFormat;
  final String actualFormat;

  const FormatException({
    required super.message,
    required this.expectedFormat,
    required this.actualFormat,
    super.code,
    super.details,
  });

  @override
  String toString() => 'FormatException: $message - Expected: $expectedFormat, Got: $actualFormat';
}

/// Thrown when an operation times out
class TimeoutException extends AppException {
  final Duration timeout;

  const TimeoutException({
    required super.message,
    required this.timeout,
    super.code,
    super.details,
  });

  @override
  String toString() => 'TimeoutException: $message - Timeout: ${timeout.inSeconds}s';
}

/// Thrown when duplicate data is encountered
class DuplicateException extends AppException {
  final String entityType;
  final String duplicateKey;

  const DuplicateException({
    required super.message,
    required this.entityType,
    required this.duplicateKey,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DuplicateException: $entityType with key "$duplicateKey" already exists';
}
