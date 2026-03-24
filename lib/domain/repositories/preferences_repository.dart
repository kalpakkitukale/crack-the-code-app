/// Preferences repository interface for managing user preferences
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/user_preference.dart';

/// Repository interface for preferences operations
abstract class PreferencesRepository {
  /// Save or update a preference
  Future<Either<Failure, UserPreference>> savePreference(UserPreference preference);

  /// Get a preference by key
  Future<Either<Failure, UserPreference?>> getPreference(String key);

  /// Get string value for a key
  Future<Either<Failure, String?>> getString(String key);

  /// Get boolean value for a key
  Future<Either<Failure, bool>> getBool(String key, {bool defaultValue = false});

  /// Get integer value for a key
  Future<Either<Failure, int>> getInt(String key, {int defaultValue = 0});

  /// Get double value for a key
  Future<Either<Failure, double>> getDouble(String key, {double defaultValue = 0.0});

  /// Get all preferences
  Future<Either<Failure, List<UserPreference>>> getAllPreferences();

  /// Delete a preference by key
  Future<Either<Failure, void>> deletePreference(String key);

  /// Clear all preferences
  Future<Either<Failure, void>> clearAllPreferences();

  /// Check if a preference exists
  Future<Either<Failure, bool>> hasPreference(String key);
}
