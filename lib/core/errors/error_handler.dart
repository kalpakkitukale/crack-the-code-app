/// Error handling utilities for consistent error propagation
///
/// Provides standardized patterns for error handling across the codebase,
/// ensuring exceptions are properly logged, tracked, and propagated.
library;

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Error handler for standardized error management
class ErrorHandler {
  /// Execute an async operation with standardized error handling
  /// Returns Either<Failure, T> for functional error handling
  static Future<Either<Failure, T>> guardAsync<T>({
    required Future<T> Function() operation,
    required String operationName,
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (e, stackTrace) {
      logger.error('$operationName failed', e, stackTrace);

      final failure = onError?.call(e, stackTrace) ??
          UnknownFailure(
            message: '$operationName failed: ${e.toString()}',
            details: e,
          );

      return Left(failure);
    }
  }

  /// Execute a sync operation with standardized error handling
  static Either<Failure, T> guardSync<T>({
    required T Function() operation,
    required String operationName,
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) {
    try {
      final result = operation();
      return Right(result);
    } catch (e, stackTrace) {
      logger.error('$operationName failed', e, stackTrace);

      final failure = onError?.call(e, stackTrace) ??
          UnknownFailure(
            message: '$operationName failed: ${e.toString()}',
            details: e,
          );

      return Left(failure);
    }
  }

  /// Execute an async operation that may return null on failure
  /// Logs error but allows graceful degradation for non-critical operations
  static Future<T?> guardNullable<T>({
    required Future<T?> Function() operation,
    required String operationName,
    T? fallback,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      logger.warning('$operationName failed (non-critical): $e', stackTrace);
      return fallback;
    }
  }

  /// Execute a database operation with appropriate error handling
  static Future<Either<Failure, T>> guardDatabase<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async {
    return guardAsync(
      operation: operation,
      operationName: operationName,
      onError: (e, stackTrace) => DatabaseFailure(
        message: '$operationName failed: ${e.toString()}',
        details: e,
      ),
    );
  }

  /// Execute a network operation with appropriate error handling
  static Future<Either<Failure, T>> guardNetwork<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async {
    return guardAsync(
      operation: operation,
      operationName: operationName,
      onError: (e, stackTrace) => NetworkFailure(
        message: '$operationName failed: ${e.toString()}',
        details: e,
      ),
    );
  }

  /// Execute a cache operation with appropriate error handling
  static Future<Either<Failure, T>> guardCache<T>({
    required Future<T> Function() operation,
    required String operationName,
  }) async {
    return guardAsync(
      operation: operation,
      operationName: operationName,
      onError: (e, stackTrace) => CacheFailure(
        message: '$operationName failed: ${e.toString()}',
        details: e,
      ),
    );
  }

  /// Convert an exception to an appropriate Failure type
  static Failure toFailure(Object error, {String? context}) {
    final contextPrefix = context != null ? '$context: ' : '';

    if (error is Failure) {
      return error;
    }

    if (error is FormatException) {
      return FormatFailure(
        message: '$contextPrefix${error.message}',
        expectedFormat: 'valid format',
        actualFormat: 'invalid',
        details: error,
      );
    }

    if (error is TimeoutException) {
      return TimeoutFailure(
        message: '$contextPrefix${error.message ?? 'Operation timed out'}',
        timeout: error.duration ?? const Duration(seconds: 30),
        details: error,
      );
    }

    return UnknownFailure(
      message: '$contextPrefix${error.toString()}',
      details: error,
    );
  }
}

/// Extension on Either for convenient error handling
extension EitherExtensions<L, R> on Either<L, R> {
  /// Execute an action on the right value, returning the original Either
  Either<L, R> tap(void Function(R value) action) {
    fold((_) {}, action);
    return this;
  }

  /// Get the right value or throw
  R getOrThrow() {
    return fold(
      (failure) => throw failure,
      (value) => value,
    );
  }

  /// Get the right value or return a default
  R getOrDefault(R defaultValue) {
    return fold(
      (_) => defaultValue,
      (value) => value,
    );
  }

  /// Get the right value or compute a default
  R getOrElse(R Function(L failure) orElse) {
    return fold(
      orElse,
      (value) => value,
    );
  }
}

/// Mixin for providers that need standardized error handling
mixin ErrorHandlingMixin {
  /// Handle an error in the provider context
  void handleError(Object error, StackTrace stackTrace, String context) {
    logger.error('$context failed', error, stackTrace);
  }

  /// Execute an async operation with error handling for providers
  Future<T?> safeExecute<T>({
    required Future<T> Function() operation,
    required String operationName,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      handleError(e, stackTrace, operationName);
      onError?.call(e, stackTrace);
      return null;
    }
  }
}
