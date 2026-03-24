/// Preference data model for database operations
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/user/user_preference.dart';

/// Preference model for SQLite database
class PreferenceModel {
  final String key;
  final String value;

  const PreferenceModel({
    required this.key,
    required this.value,
  });

  /// Convert from database map
  factory PreferenceModel.fromMap(Map<String, dynamic> map) {
    return PreferenceModel(
      key: map[PreferencesTable.columnKey] as String,
      value: map[PreferencesTable.columnValue] as String,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      PreferencesTable.columnKey: key,
      PreferencesTable.columnValue: value,
    };
  }

  /// Convert to domain entity
  UserPreference toEntity() {
    return UserPreference(
      key: key,
      value: value,
    );
  }

  /// Create from domain entity
  factory PreferenceModel.fromEntity(UserPreference preference) {
    return PreferenceModel(
      key: preference.key,
      value: preference.value,
    );
  }
}
