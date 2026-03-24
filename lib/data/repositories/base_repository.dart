/// Base Repository
///
/// Provides common error handling and utility methods for all repositories.
/// Reduces boilerplate code by centralizing exception-to-failure conversion.
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart'
    hide FormatException, TimeoutException;
import 'package:streamshaala/core/errors/exceptions.dart' as app_exceptions;
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Mixin providing standardized error handling for repository implementations.
///
/// Use this mixin in repository classes to get automatic exception-to-failure
/// conversion without duplicating try-catch blocks throughout the codebase.
///
/// Example:
/// ```dart
/// class BookmarkRepositoryImpl with RepositoryErrorHandler implements BookmarkRepository {
///   final BookmarkDao _dao;
///
///   @override
///   Future<Either<Failure, List<Bookmark>>> getAllBookmarks() {
///     return executeWithErrorHandling(
///       operation: () async {
///         final models = await _dao.getAll();
///         return models.map((m) => m.toEntity()).toList();
///       },
///       operationName: 'getAllBookmarks',
///     );
///   }
/// }
/// ```
mixin RepositoryErrorHandler {
  /// Execute a repository operation with comprehensive error handling.
  ///
  /// Converts all custom exceptions to their corresponding Failure types:
  /// - [DatabaseException] → [DatabaseFailure]
  /// - [NotFoundException] → [NotFoundFailure]
  /// - [ValidationException] → [ValidationFailure]
  /// - [CacheException] → [CacheFailure]
  /// - [DuplicateException] → [DuplicateFailure]
  /// - [StorageException] → [StorageFailure]
  /// - [app_exceptions.TimeoutException] → [TimeoutFailure]
  /// - [JsonParseException] → [JsonParseFailure]
  /// - [AssetNotFoundException] → [AssetNotFoundFailure]
  /// - [app_exceptions.FormatException] → [FormatFailure]
  /// - [PlatformException] → [PlatformFailure]
  /// - Other exceptions → [UnknownFailure]
  Future<Either<Failure, T>> executeWithErrorHandling<T>({
    required Future<T> Function() operation,
    required String operationName,
    String? entityType,
    String? entityId,
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error in $operationName', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Database operation failed: $operationName',
        details: e.message,
      ));
    } on NotFoundException catch (e) {
      logger.warning('Not found in $operationName: ${e.message}');
      return Left(NotFoundFailure(
        message: e.message,
        entityType: entityType ?? e.entityType,
        entityId: entityId ?? e.entityId,
      ));
    } on ValidationException catch (e) {
      logger.warning('Validation error in $operationName: ${e.message}');
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        details: e.details,
      ));
    } on CacheException catch (e, stackTrace) {
      logger.error('Cache error in $operationName', e, stackTrace);
      return Left(CacheFailure(
        message: 'Cache operation failed',
        details: e.message,
      ));
    } on DuplicateException catch (e) {
      logger.warning('Duplicate in $operationName: ${e.message}');
      return Left(DuplicateFailure(
        message: e.message,
        entityType: entityType ?? e.entityType,
        duplicateKey: e.duplicateKey,
      ));
    } on StorageException catch (e, stackTrace) {
      logger.error('Storage error in $operationName', e, stackTrace);
      return Left(StorageFailure(
        message: 'Storage operation failed: $operationName',
        details: e.message,
      ));
    } on app_exceptions.TimeoutException catch (e, stackTrace) {
      logger.error('Timeout in $operationName', e, stackTrace);
      return Left(TimeoutFailure(
        message: 'Operation timed out: $operationName',
        timeout: e.timeout,
        details: e.message,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error in $operationName', e, stackTrace);
      return Left(JsonParseFailure(
        message: 'Failed to parse JSON: $operationName',
        filePath: e.filePath,
        details: e.message,
      ));
    } on AssetNotFoundException catch (e) {
      logger.warning('Asset not found in $operationName: ${e.assetPath}');
      return Left(AssetNotFoundFailure(
        message: e.message,
        assetPath: e.assetPath,
      ));
    } on app_exceptions.FormatException catch (e) {
      logger.warning('Format error in $operationName: ${e.message}');
      return Left(FormatFailure(
        message: e.message,
        expectedFormat: e.expectedFormat,
        actualFormat: e.actualFormat,
      ));
    } on PlatformException catch (e, stackTrace) {
      logger.error('Platform error in $operationName', e, stackTrace);
      return Left(PlatformFailure(
        message: 'Platform operation failed: $operationName',
        platform: e.platform,
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error in $operationName', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Execute a void operation with comprehensive error handling.
  ///
  /// Same exception handling as [executeWithErrorHandling] but for operations
  /// that don't return a value.
  Future<Either<Failure, void>> executeVoidWithErrorHandling({
    required Future<void> Function() operation,
    required String operationName,
    String? entityType,
    String? entityId,
  }) async {
    try {
      await operation();
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error in $operationName', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Database operation failed: $operationName',
        details: e.message,
      ));
    } on NotFoundException catch (e) {
      logger.warning('Not found in $operationName: ${e.message}');
      return Left(NotFoundFailure(
        message: e.message,
        entityType: entityType ?? e.entityType,
        entityId: entityId ?? e.entityId,
      ));
    } on ValidationException catch (e) {
      logger.warning('Validation error in $operationName: ${e.message}');
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        details: e.details,
      ));
    } on CacheException catch (e, stackTrace) {
      logger.error('Cache error in $operationName', e, stackTrace);
      return Left(CacheFailure(
        message: 'Cache operation failed',
        details: e.message,
      ));
    } on DuplicateException catch (e) {
      logger.warning('Duplicate in $operationName: ${e.message}');
      return Left(DuplicateFailure(
        message: e.message,
        entityType: entityType ?? e.entityType,
        duplicateKey: e.duplicateKey,
      ));
    } on StorageException catch (e, stackTrace) {
      logger.error('Storage error in $operationName', e, stackTrace);
      return Left(StorageFailure(
        message: 'Storage operation failed: $operationName',
        details: e.message,
      ));
    } on app_exceptions.TimeoutException catch (e, stackTrace) {
      logger.error('Timeout in $operationName', e, stackTrace);
      return Left(TimeoutFailure(
        message: 'Operation timed out: $operationName',
        timeout: e.timeout,
        details: e.message,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error in $operationName', e, stackTrace);
      return Left(JsonParseFailure(
        message: 'Failed to parse JSON: $operationName',
        filePath: e.filePath,
        details: e.message,
      ));
    } on AssetNotFoundException catch (e) {
      logger.warning('Asset not found in $operationName: ${e.assetPath}');
      return Left(AssetNotFoundFailure(
        message: e.message,
        assetPath: e.assetPath,
      ));
    } on app_exceptions.FormatException catch (e) {
      logger.warning('Format error in $operationName: ${e.message}');
      return Left(FormatFailure(
        message: e.message,
        expectedFormat: e.expectedFormat,
        actualFormat: e.actualFormat,
      ));
    } on PlatformException catch (e, stackTrace) {
      logger.error('Platform error in $operationName', e, stackTrace);
      return Left(PlatformFailure(
        message: 'Platform operation failed: $operationName',
        platform: e.platform,
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error in $operationName', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Log an info message with optional profile context
  void logInfo(String message, {String? profileId}) {
    final suffix = profileId != null ? ' (profile: $profileId)' : '';
    logger.info('$message$suffix');
  }

  /// Log a debug message with optional profile context
  void logDebug(String message, {String? profileId}) {
    final suffix = profileId != null ? ' (profile: $profileId)' : '';
    logger.debug('$message$suffix');
  }

  /// Log a warning message with optional profile context
  void logWarning(String message, {String? profileId}) {
    final suffix = profileId != null ? ' (profile: $profileId)' : '';
    logger.warning('$message$suffix');
  }
}

/// Base class for repository implementations providing common error handling.
///
/// Prefer using [RepositoryErrorHandler] mixin instead for more flexibility.
/// This abstract class is provided for backwards compatibility.
abstract class BaseRepository with RepositoryErrorHandler {}

/// Mixin for repositories that support multi-profile operations
mixin ProfileScopedRepository {
  /// Current profile ID for scoped operations
  String? profileId;

  /// Get the profile suffix for IDs
  String getProfileSuffix() => profileId != null ? '_$profileId' : '';

  /// Create a profile-scoped ID
  String scopeId(String baseId) => profileId != null ? '${baseId}_$profileId' : baseId;
}
