/// Validation Helpers for Repository Operations
///
/// Provides input validation, sanitization, and SQL injection prevention
/// for all database operations throughout the application.
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';

/// Maximum allowed lengths for various input types
class InputLimits {
  static const int id = 128;
  static const int shortText = 255;
  static const int mediumText = 1000;
  static const int longText = 10000;
  static const int searchQuery = 100;
  static const int noteContent = 50000;
  static const int profileName = 50;
  static const int email = 254;
  static const int url = 2048;
}

/// Validation utility for repository operations
class ValidationHelpers {
  /// Validate that a required string is not null or empty
  static Either<Failure, String> validateRequiredString(
    String? value,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return Left(ValidationFailure(
        message: '$fieldName is required and cannot be empty',
        fieldErrors: {fieldName: 'Required field is empty'},
      ));
    }
    return Right(value.trim());
  }

  /// Validate that an ID is valid (not empty and reasonable format)
  static Either<Failure, String> validateId(
    String? id,
    String idType,
  ) {
    if (id == null || id.trim().isEmpty) {
      return Left(ValidationFailure(
        message: '$idType is required',
        fieldErrors: {idType: 'ID cannot be empty'},
      ));
    }
    return Right(id.trim());
  }

  /// Validate multiple required IDs at once
  /// Returns Left with first validation error, or Right with all validated IDs
  static Either<Failure, Map<String, String>> validateRequiredIds(
    Map<String, String?> idsToValidate,
  ) {
    final validatedIds = <String, String>{};

    for (final entry in idsToValidate.entries) {
      final result = validateId(entry.value, entry.key);
      final validated = result.fold(
        (failure) => null,
        (validId) => validId,
      );

      if (validated == null) {
        return Left(ValidationFailure(
          message: '${entry.key} is required',
          fieldErrors: {entry.key: 'Required ID is missing or empty'},
        ));
      }

      validatedIds[entry.key] = validated;
    }

    return Right(validatedIds);
  }

  /// Validate that a number is positive
  static Either<Failure, int> validatePositiveInt(
    int? value,
    String fieldName,
  ) {
    if (value == null || value <= 0) {
      return Left(ValidationFailure(
        message: '$fieldName must be a positive number',
        fieldErrors: {fieldName: 'Must be greater than 0'},
      ));
    }
    return Right(value);
  }

  /// Validate that a number is non-negative
  static Either<Failure, int> validateNonNegativeInt(
    int? value,
    String fieldName,
  ) {
    if (value == null || value < 0) {
      return Left(ValidationFailure(
        message: '$fieldName must be a non-negative number',
        fieldErrors: {fieldName: 'Cannot be negative'},
      ));
    }
    return Right(value);
  }

  /// Validate that a double is within range
  static Either<Failure, double> validateDoubleRange(
    double? value,
    String fieldName, {
    double min = 0.0,
    double max = 1.0,
  }) {
    if (value == null || value < min || value > max) {
      return Left(ValidationFailure(
        message: '$fieldName must be between $min and $max',
        fieldErrors: {fieldName: 'Value out of range'},
      ));
    }
    return Right(value);
  }

  /// Validate that a list is not empty
  static Either<Failure, List<T>> validateNonEmptyList<T>(
    List<T>? list,
    String fieldName,
  ) {
    if (list == null || list.isEmpty) {
      return Left(ValidationFailure(
        message: '$fieldName cannot be empty',
        fieldErrors: {fieldName: 'List is empty'},
      ));
    }
    return Right(list);
  }

  /// Validate string length within limits
  static Either<Failure, String> validateStringLength(
    String? value,
    String fieldName, {
    int minLength = 0,
    int maxLength = InputLimits.shortText,
  }) {
    if (value == null) {
      if (minLength > 0) {
        return Left(ValidationFailure(
          message: '$fieldName is required',
          fieldErrors: {fieldName: 'Required field is null'},
        ));
      }
      return const Right('');
    }

    final trimmed = value.trim();
    if (trimmed.length < minLength) {
      return Left(ValidationFailure(
        message: '$fieldName must be at least $minLength characters',
        fieldErrors: {fieldName: 'Too short (min $minLength)'},
      ));
    }

    if (trimmed.length > maxLength) {
      return Left(ValidationFailure(
        message: '$fieldName must not exceed $maxLength characters',
        fieldErrors: {fieldName: 'Too long (max $maxLength)'},
      ));
    }

    return Right(trimmed);
  }

  /// Validate email format
  static Either<Failure, String> validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return Left(ValidationFailure(
        message: 'Email is required',
        fieldErrors: {'email': 'Required field is empty'},
      ));
    }

    final trimmed = email.trim().toLowerCase();

    // Basic email regex - RFC 5322 simplified
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    if (!emailRegex.hasMatch(trimmed)) {
      return Left(ValidationFailure(
        message: 'Invalid email format',
        fieldErrors: {'email': 'Invalid format'},
      ));
    }

    if (trimmed.length > InputLimits.email) {
      return Left(ValidationFailure(
        message: 'Email is too long',
        fieldErrors: {'email': 'Exceeds maximum length'},
      ));
    }

    return Right(trimmed);
  }

  /// Validate URL format
  static Either<Failure, String> validateUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return Left(ValidationFailure(
        message: 'URL is required',
        fieldErrors: {'url': 'Required field is empty'},
      ));
    }

    final trimmed = url.trim();

    try {
      final uri = Uri.parse(trimmed);
      if (!uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        return Left(ValidationFailure(
          message: 'URL must use HTTP or HTTPS protocol',
          fieldErrors: {'url': 'Invalid protocol'},
        ));
      }

      if (trimmed.length > InputLimits.url) {
        return Left(ValidationFailure(
          message: 'URL is too long',
          fieldErrors: {'url': 'Exceeds maximum length'},
        ));
      }

      return Right(trimmed);
    } catch (e) {
      return Left(ValidationFailure(
        message: 'Invalid URL format',
        fieldErrors: {'url': 'Cannot parse URL'},
      ));
    }
  }
}

/// SQL sanitization utilities to prevent injection attacks
class SqlSanitizer {
  /// Characters that have special meaning in SQL LIKE patterns
  static const _likeSpecialChars = ['%', '_', '[', ']', '^'];

  /// Escape special characters in a LIKE pattern
  /// This prevents user input from being interpreted as wildcards
  ///
  /// Example: "test_%" becomes "test\_\%" when escaped
  static String escapeLikePattern(String input, {String escapeChar = '\\'}) {
    var result = input;

    // First escape the escape character itself
    result = result.replaceAll(escapeChar, '$escapeChar$escapeChar');

    // Then escape LIKE special characters
    for (final char in _likeSpecialChars) {
      result = result.replaceAll(char, '$escapeChar$char');
    }

    return result;
  }

  /// Sanitize a search query for safe use in LIKE patterns
  /// Returns the sanitized query wrapped with % for partial matching
  static String sanitizeSearchQuery(String query, {int maxLength = InputLimits.searchQuery}) {
    // Trim and limit length
    var sanitized = query.trim();
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }

    // Escape special characters
    sanitized = escapeLikePattern(sanitized);

    return '%$sanitized%';
  }

  /// Remove any null bytes from input (SQLite doesn't handle them well)
  static String removeNullBytes(String input) {
    return input.replaceAll('\x00', '');
  }

  /// Sanitize general string input for database storage
  /// Removes null bytes and trims whitespace
  static String sanitizeForStorage(String input) {
    return removeNullBytes(input.trim());
  }

  /// Validate that an ID contains only safe characters
  /// IDs should be alphanumeric with limited special characters
  static bool isValidId(String id) {
    // Allow alphanumeric, underscore, hyphen, and period
    final idRegex = RegExp(r'^[a-zA-Z0-9_\-\.]+$');
    return id.isNotEmpty &&
        id.length <= InputLimits.id &&
        idRegex.hasMatch(id);
  }

  /// Sanitize an ID, returning null if invalid
  static String? sanitizeId(String? id) {
    if (id == null || id.trim().isEmpty) return null;

    final trimmed = id.trim();
    if (!isValidId(trimmed)) return null;

    return trimmed;
  }
}

/// HTML/XSS sanitization utilities for display content
class HtmlSanitizer {
  /// Characters that need HTML encoding
  static const _htmlEntities = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#x27;',
    '/': '&#x2F;',
  };

  /// Encode special HTML characters to prevent XSS
  /// Use this when displaying user-generated content
  static String encodeHtml(String input) {
    var result = input;
    for (final entry in _htmlEntities.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Remove all HTML tags from input
  /// Use this to strip any HTML from user input before storage
  static String stripHtmlTags(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Sanitize user input for safe storage and display
  /// Strips HTML tags and removes potentially dangerous content
  static String sanitizeUserInput(String input) {
    var sanitized = stripHtmlTags(input);
    sanitized = SqlSanitizer.removeNullBytes(sanitized);
    return sanitized.trim();
  }
}

/// Extension on String for quick validation
extension StringValidation on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.trim().isNotEmpty;
}
