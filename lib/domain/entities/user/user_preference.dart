/// User preference entity for app settings
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preference.freezed.dart';

@freezed
class UserPreference with _$UserPreference {
  const factory UserPreference({
    required String key,
    required String value,
  }) = _UserPreference;

  const UserPreference._();

  /// Get value as boolean
  bool get asBool {
    return value.toLowerCase() == 'true';
  }

  /// Get value as integer
  int? get asInt {
    return int.tryParse(value);
  }

  /// Get value as double
  double? get asDouble {
    return double.tryParse(value);
  }
}

/// Predefined preference keys
class PreferenceKeys {
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String autoPlayNext = 'auto_play_next';
  static const String videoQuality = 'video_quality';
  static const String playbackSpeed = 'playback_speed';
  static const String subtitlesEnabled = 'subtitles_enabled';
}

/// Theme mode values
enum ThemeMode {
  light,
  dark,
  system;

  String get value => name;

  static ThemeMode fromString(String value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

/// Video quality values
enum VideoQuality {
  auto,
  high,
  medium,
  low;

  String get value => name;

  static VideoQuality fromString(String value) {
    return VideoQuality.values.firstWhere(
      (quality) => quality.name == value,
      orElse: () => VideoQuality.auto,
    );
  }
}

/// Playback speed values
enum PlaybackSpeed {
  x0_25(0.25),
  x0_5(0.5),
  x0_75(0.75),
  x1_0(1.0),
  x1_25(1.25),
  x1_5(1.5),
  x1_75(1.75),
  x2_0(2.0);

  final double value;

  const PlaybackSpeed(this.value);

  static PlaybackSpeed fromValue(double value) {
    return PlaybackSpeed.values.firstWhere(
      (speed) => speed.value == value,
      orElse: () => PlaybackSpeed.x1_0,
    );
  }

  static PlaybackSpeed fromString(String value) {
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) return PlaybackSpeed.x1_0;
    return fromValue(doubleValue);
  }
}
