/// Failure classes for error handling in StreamShaala
///
/// Failures represent errors that occurred during operations.
/// They are used in the repository layer to return Either<Failure, Success>
/// following Clean Architecture principles.
library;

import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when database operations fail
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DatabaseFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when JSON parsing fails
class JsonParseFailure extends Failure {
  final String filePath;

  const JsonParseFailure({
    required super.message,
    required this.filePath,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, filePath];

  @override
  String toString() => 'JsonParseFailure: $message at $filePath${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when an asset is not found
class AssetNotFoundFailure extends Failure {
  final String assetPath;

  const AssetNotFoundFailure({
    required super.message,
    required this.assetPath,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, assetPath];

  @override
  String toString() => 'AssetNotFoundFailure: $message - Asset: $assetPath';
}

/// Failure when a requested item is not found
class NotFoundFailure extends Failure {
  final String entityType;
  final String entityId;

  const NotFoundFailure({
    required super.message,
    required this.entityType,
    required this.entityId,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, entityType, entityId];

  @override
  String toString() => 'NotFoundFailure: $entityType with ID "$entityId" not found';
}

/// Failure when data validation fails
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, fieldErrors];

  @override
  String toString() {
    final buffer = StringBuffer('ValidationFailure: $message');
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      buffer.write('\nField Errors:');
      fieldErrors!.forEach((field, error) {
        buffer.write('\n  - $field: $error');
      });
    }
    return buffer.toString();
  }
}

/// Failure when cache operations fail
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CacheFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when network operations fail
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NetworkFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when server operations fail
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ServerFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when platform-specific operations fail
class PlatformFailure extends Failure {
  final String platform;

  const PlatformFailure({
    required super.message,
    required this.platform,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, platform];

  @override
  String toString() => 'PlatformFailure [$platform]: $message';
}

/// Failure when storage operations fail
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'StorageFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure when data format is invalid
class FormatFailure extends Failure {
  final String expectedFormat;
  final String actualFormat;

  const FormatFailure({
    required super.message,
    required this.expectedFormat,
    required this.actualFormat,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, expectedFormat, actualFormat];

  @override
  String toString() => 'FormatFailure: $message - Expected: $expectedFormat, Got: $actualFormat';
}

/// Failure when an operation times out
class TimeoutFailure extends Failure {
  final Duration timeout;

  const TimeoutFailure({
    required super.message,
    required this.timeout,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, timeout];

  @override
  String toString() => 'TimeoutFailure: $message - Timeout: ${timeout.inSeconds}s';
}

/// Failure when duplicate data is encountered
class DuplicateFailure extends Failure {
  final String entityType;
  final String duplicateKey;

  const DuplicateFailure({
    required super.message,
    required this.entityType,
    required this.duplicateKey,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, code, details, entityType, duplicateKey];

  @override
  String toString() => 'DuplicateFailure: $entityType with key "$duplicateKey" already exists';
}

/// Failure when authentication operations fail
class AuthFailure extends Failure {
  const AuthFailure(String message, {String? code, dynamic details})
      : super(message: message, code: code, details: details);

  @override
  String toString() => 'AuthFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Failure related to user sync operations
class UserSyncFailure extends Failure {
  const UserSyncFailure(String message) : super(message: message);

  @override
  String toString() => 'UserSyncFailure: $message';
}

/// Failure when an unexpected error occurs
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.details,
  });

  @override
  String toString() => 'UnknownFailure: $message${code != null ? ' (Code: $code)' : ''}';
}
