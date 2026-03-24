import 'package:crack_the_code/core/errors/failures.dart';

/// User-friendly error messages mapper
/// Converts technical errors into friendly, actionable messages
class ErrorMessages {
  /// Get user-friendly message from Failure
  static String getErrorMessage(Failure failure) {
    if (failure is DatabaseFailure) {
      return _getDatabaseErrorMessage(failure.message);
    } else if (failure is NetworkFailure) {
      return _getNetworkErrorMessage(failure.message);
    } else if (failure is CacheFailure) {
      return _getCacheErrorMessage(failure.message);
    } else if (failure is ValidationFailure) {
      return _getValidationErrorMessage(failure.message);
    } else if (failure is ServerFailure) {
      return _getServerErrorMessage(failure.message);
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Database error messages
  static String _getDatabaseErrorMessage(String technicalMessage) {
    final message = technicalMessage.toLowerCase();

    if (message.contains('no such table') || message.contains('no such column')) {
      return 'Data structure needs updating. Please restart the app.';
    }

    if (message.contains('locked') || message.contains('busy')) {
      return 'Database is busy. Please wait a moment and try again.';
    }

    if (message.contains('corrupt') || message.contains('malformed')) {
      return 'Data may be corrupted. Please reinstall the app if this persists.';
    }

    if (message.contains('readonly') || message.contains('read-only')) {
      return 'Cannot save changes. Check storage permissions.';
    }

    if (message.contains('disk full') || message.contains('no space')) {
      return 'Device storage is full. Please free up some space.';
    }

    return 'Failed to access local data. Please restart the app.';
  }

  /// Network error messages
  static String _getNetworkErrorMessage(String technicalMessage) {
    final message = technicalMessage.toLowerCase();

    if (message.contains('timeout') || message.contains('timed out')) {
      return 'Connection timed out. Please check your internet and try again.';
    }

    if (message.contains('no internet') || message.contains('offline') || message.contains('network unreachable')) {
      return 'No internet connection. Please check your connection.';
    }

    if (message.contains('host') || message.contains('dns')) {
      return 'Cannot reach server. Please check your internet connection.';
    }

    if (message.contains('ssl') || message.contains('certificate')) {
      return 'Secure connection failed. Please check your device\'s date and time.';
    }

    return 'Network error. Please check your connection and try again.';
  }

  /// Cache error messages
  static String _getCacheErrorMessage(String technicalMessage) {
    final message = technicalMessage.toLowerCase();

    if (message.contains('not found') || message.contains('missing')) {
      return 'Cached data not available. Content will load from server.';
    }

    if (message.contains('expired') || message.contains('stale')) {
      return 'Cached data is outdated. Refreshing content...';
    }

    return 'Failed to access cached data. Content may take longer to load.';
  }

  /// Validation error messages
  static String _getValidationErrorMessage(String technicalMessage) {
    final message = technicalMessage.toLowerCase();

    if (message.contains('empty') || message.contains('required')) {
      return 'Please fill in all required fields.';
    }

    if (message.contains('invalid') || message.contains('format')) {
      return 'Invalid input format. Please check and try again.';
    }

    if (message.contains('length') || message.contains('too short') || message.contains('too long')) {
      return 'Input length is invalid. Please check the requirements.';
    }

    return 'Invalid input. Please check your entries and try again.';
  }

  /// Server error messages
  static String _getServerErrorMessage(String technicalMessage) {
    final message = technicalMessage.toLowerCase();

    if (message.contains('404') || message.contains('not found')) {
      return 'Content not found. It may have been removed.';
    }

    if (message.contains('401') || message.contains('unauthorized')) {
      return 'Authentication required. Please sign in again.';
    }

    if (message.contains('403') || message.contains('forbidden')) {
      return 'Access denied. You don\'t have permission for this action.';
    }

    if (message.contains('500') || message.contains('internal server')) {
      return 'Server error. Please try again later.';
    }

    if (message.contains('503') || message.contains('unavailable')) {
      return 'Service temporarily unavailable. Please try again later.';
    }

    return 'Server error. Please try again later.';
  }

  /// Get action label for retry button
  static String getRetryActionLabel(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Retry';
    } else if (failure is DatabaseFailure) {
      return 'Refresh';
    } else if (failure is CacheFailure) {
      return 'Reload';
    } else {
      return 'Try Again';
    }
  }

  /// Check if failure is retryable
  static bool isRetryable(Failure failure) {
    if (failure is ValidationFailure) {
      // Validation errors need user input changes, not retry
      return false;
    }

    final message = failure.message.toLowerCase();

    // Non-retryable conditions
    if (message.contains('corrupt') ||
        message.contains('malformed') ||
        message.contains('readonly') ||
        message.contains('disk full') ||
        message.contains('403') ||
        message.contains('forbidden')) {
      return false;
    }

    return true;
  }

  /// Get help text for specific errors
  static String? getHelpText(Failure failure) {
    final message = failure.message.toLowerCase();

    if (message.contains('no internet') || message.contains('offline')) {
      return 'Check WiFi or mobile data settings';
    }

    if (message.contains('disk full') || message.contains('no space')) {
      return 'Go to Settings > Storage to free up space';
    }

    if (message.contains('ssl') || message.contains('certificate')) {
      return 'Verify your device\'s date and time are correct';
    }

    if (message.contains('corrupt')) {
      return 'You may need to clear app data or reinstall';
    }

    return null;
  }

  /// Get icon for error type
  static String getErrorIcon(Failure failure) {
    if (failure is NetworkFailure) {
      return '📡';
    } else if (failure is DatabaseFailure) {
      return '💾';
    } else if (failure is CacheFailure) {
      return '🗂️';
    } else if (failure is ValidationFailure) {
      return '✏️';
    } else if (failure is ServerFailure) {
      return '🌐';
    } else {
      return '⚠️';
    }
  }
}
