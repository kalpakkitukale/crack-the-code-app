import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/models/player_profile.dart';
import 'package:crack_the_code/shared/models/app_settings.dart';

class GameStorageService {
  static const String _profileBox = 'game_player_profile';
  static const String _phonogramMasteryBox = 'game_phonogram_mastery';
  static const String _ruleMasteryBox = 'game_rule_mastery';
  static const String _settingsBox = 'game_settings';
  static const String _streakBox = 'game_streaks';

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<String>(_profileBox),
      Hive.openBox<String>(_phonogramMasteryBox),
      Hive.openBox<String>(_ruleMasteryBox),
      Hive.openBox<String>(_settingsBox),
      Hive.openBox<String>(_streakBox),
      // Game-specific boxes
      Hive.openBox<String>('sound_board_progress'),
      Hive.openBox<String>('lesson_progress'),
      Hive.openBox<String>('trial_progress'),
      Hive.openBox<String>('character_collection'),
      Hive.openBox<String>('level_progress'),
    ]);
    _initialized = true;
  }

  // Player Profile (stored as JSON string for simplicity — no adapters needed)
  PlayerProfile? getProfile() {
    final box = Hive.box<String>(_profileBox);
    final json = box.get('current');
    if (json == null) return null;
    return PlayerProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveProfile(PlayerProfile profile) async {
    final box = Hive.box<String>(_profileBox);
    await box.put('current', jsonEncode(profile.toJson()));
  }

  // Phonogram Mastery
  MasteryData? getPhonogramMastery(String soundId) {
    final box = Hive.box<String>(_phonogramMasteryBox);
    final json = box.get(soundId);
    if (json == null) return null;
    return MasteryData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> savePhonogramMastery(String soundId, MasteryData data) async {
    final box = Hive.box<String>(_phonogramMasteryBox);
    await box.put(soundId, jsonEncode(data.toJson()));
  }

  Map<String, MasteryData> getAllPhonogramMastery() {
    final box = Hive.box<String>(_phonogramMasteryBox);
    final result = <String, MasteryData>{};
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        result[key as String] =
            MasteryData.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }
    }
    return result;
  }

  // Rule Mastery
  MasteryData? getRuleMastery(int ruleNum) {
    final box = Hive.box<String>(_ruleMasteryBox);
    final json = box.get(ruleNum.toString());
    if (json == null) return null;
    return MasteryData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveRuleMastery(int ruleNum, MasteryData data) async {
    final box = Hive.box<String>(_ruleMasteryBox);
    await box.put(ruleNum.toString(), jsonEncode(data.toJson()));
  }

  Map<int, MasteryData> getAllRuleMastery() {
    final box = Hive.box<String>(_ruleMasteryBox);
    final result = <int, MasteryData>{};
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        result[int.parse(key as String)] =
            MasteryData.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }
    }
    return result;
  }

  // Settings
  AppSettings getSettings() {
    final box = Hive.box<String>(_settingsBox);
    final json = box.get('current');
    if (json == null) return AppSettings.defaults();
    return AppSettings.fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box<String>(_settingsBox);
    await box.put('current', jsonEncode(settings.toMap()));
  }

  // Per-game boxes (opened on demand)
  Future<Box<String>> openGameBox(String gameName) {
    return Hive.openBox<String>('game_${gameName}_progress');
  }
}
