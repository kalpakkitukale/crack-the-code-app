import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/app_settings.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/models/player_profile.dart';
import 'package:crack_the_code/shared/models/spelling_rule.dart';
import 'package:crack_the_code/shared/repositories/audio_repository.dart';
import 'package:crack_the_code/shared/repositories/phonogram_repository.dart';
import 'package:crack_the_code/shared/repositories/rule_repository.dart';
import 'package:crack_the_code/shared/repositories/word_repository.dart';
import 'package:crack_the_code/shared/repositories/sound_repository.dart';
import 'package:crack_the_code/shared/repositories/character_repository.dart';
import 'package:crack_the_code/shared/repositories/level_repository.dart';
import 'package:crack_the_code/shared/models/sound.dart';
import 'package:crack_the_code/shared/models/character.dart';
import 'package:crack_the_code/shared/models/level.dart';
import 'package:crack_the_code/shared/services/audio_service.dart';
import 'package:crack_the_code/shared/services/storage_service.dart';

// ═══════════════════════════════════════════════════════════════
// Data Repositories (overridden at startup with loaded instances)
// ═══════════════════════════════════════════════════════════════

final phonogramRepositoryProvider = Provider<PhonogramRepository>((ref) {
  throw UnimplementedError(
      'phonogramRepositoryProvider must be overridden in ProviderScope');
});

final ruleRepositoryProvider = Provider<RuleRepository>((ref) {
  throw UnimplementedError(
      'ruleRepositoryProvider must be overridden in ProviderScope');
});

final wordRepositoryProvider = Provider<WordRepository>((ref) {
  throw UnimplementedError(
      'wordRepositoryProvider must be overridden in ProviderScope');
});

// New repositories (5-level system)
final soundRepositoryProvider = Provider<SoundRepository>((ref) {
  throw UnimplementedError('soundRepositoryProvider must be overridden');
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  throw UnimplementedError('characterRepositoryProvider must be overridden');
});

final levelRepositoryProvider = Provider<LevelRepository>((ref) {
  throw UnimplementedError('levelRepositoryProvider must be overridden');
});

// ═══════════════════════════════════════════════════════════════
// Convenience Accessors
// ═══════════════════════════════════════════════════════════════

final phonogramsProvider = Provider<List<Phonogram>>((ref) {
  return ref.watch(phonogramRepositoryProvider).getAll();
});

final rulesProvider = Provider<List<SpellingRule>>((ref) {
  return ref.watch(ruleRepositoryProvider).getAll();
});

final allSoundsProvider = Provider<List<Sound>>((ref) {
  return ref.watch(soundRepositoryProvider).getAll();
});

final allCharactersProvider = Provider<List<Character>>((ref) {
  return ref.watch(characterRepositoryProvider).getAll();
});

final allLevelsProvider = Provider<List<Level>>((ref) {
  return ref.watch(levelRepositoryProvider).getAll();
});

// ═══════════════════════════════════════════════════════════════
// Services
// ═══════════════════════════════════════════════════════════════

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepository(ref.watch(audioServiceProvider));
});

final gameStorageServiceProvider = Provider<GameStorageService>((ref) {
  throw UnimplementedError(
      'gameStorageServiceProvider must be overridden in ProviderScope');
});

// ═══════════════════════════════════════════════════════════════
// Player Profile
// ═══════════════════════════════════════════════════════════════

final playerProfileProvider =
    NotifierProvider<PlayerProfileNotifier, PlayerProfile>(
        PlayerProfileNotifier.new);

class PlayerProfileNotifier extends Notifier<PlayerProfile> {
  @override
  PlayerProfile build() {
    final storage = ref.watch(gameStorageServiceProvider);
    return storage.getProfile() ?? PlayerProfile.defaultProfile();
  }

  Future<void> updateNickname(String name) async {
    state = state.copyWith(nickname: name);
    await _save();
  }

  Future<void> updateAgeLevel(AgeLevel level) async {
    state = state.copyWith(ageLevel: level);
    await _save();
  }

  Future<void> addCoins(int amount) async {
    state = state.copyWith(coins: state.coins + amount);
    await _save();
  }

  Future<void> addXp(int amount) async {
    final newXp = state.xp + amount;
    final newLevel = _calculateLevel(newXp);
    state = state.copyWith(xp: newXp, level: newLevel);
    await _save();
  }

  Future<void> setPremium(bool value) async {
    state = state.copyWith(isPremium: value);
    await _save();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    state = state.copyWith(language: lang);
    await _save();
  }

  Future<void> recordPlay() async {
    state = state.copyWith(lastPlayedAt: DateTime.now());
    await _save();
  }

  Future<void> _save() async {
    await ref.read(gameStorageServiceProvider).saveProfile(state);
  }

  int _calculateLevel(int xp) {
    int level = 0;
    int threshold = 0;
    while (threshold <= xp) {
      level++;
      threshold += level * 100;
    }
    return level;
  }
}

// ═══════════════════════════════════════════════════════════════
// Phonogram Mastery
// ═══════════════════════════════════════════════════════════════

final phonogramMasteryProvider =
    NotifierProvider<PhonogramMasteryNotifier, Map<String, MasteryData>>(
        PhonogramMasteryNotifier.new);

class PhonogramMasteryNotifier extends Notifier<Map<String, MasteryData>> {
  @override
  Map<String, MasteryData> build() {
    return ref.read(gameStorageServiceProvider).getAllPhonogramMastery();
  }

  Future<void> recordCorrect(String soundId, MasteryLevel newLevel) async {
    final current = state[soundId] ?? MasteryData.initial();
    final updated = current.copyWith(
      timesCorrect: current.timesCorrect + 1,
      level: _higherLevel(current.level, newLevel),
      lastPracticed: DateTime.now(),
    );
    state = {...state, soundId: updated};
    await ref
        .read(gameStorageServiceProvider)
        .savePhonogramMastery(soundId, updated);
  }

  Future<void> recordWrong(String soundId) async {
    final current = state[soundId] ?? MasteryData.initial();
    final updated = current.copyWith(
      timesWrong: current.timesWrong + 1,
      lastPracticed: DateTime.now(),
    );
    state = {...state, soundId: updated};
    await ref
        .read(gameStorageServiceProvider)
        .savePhonogramMastery(soundId, updated);
  }

  MasteryLevel _higherLevel(MasteryLevel a, MasteryLevel b) =>
      a.index >= b.index ? a : b;
}

// ═══════════════════════════════════════════════════════════════
// Rule Mastery
// ═══════════════════════════════════════════════════════════════

final ruleMasteryProvider =
    NotifierProvider<RuleMasteryNotifier, Map<int, MasteryData>>(
        RuleMasteryNotifier.new);

class RuleMasteryNotifier extends Notifier<Map<int, MasteryData>> {
  @override
  Map<int, MasteryData> build() {
    return ref.read(gameStorageServiceProvider).getAllRuleMastery();
  }

  Future<void> recordCorrect(int ruleNum, MasteryLevel newLevel) async {
    final current = state[ruleNum] ?? MasteryData.initial();
    final updated = current.copyWith(
      timesCorrect: current.timesCorrect + 1,
      level: newLevel.index > current.level.index ? newLevel : current.level,
      lastPracticed: DateTime.now(),
    );
    state = {...state, ruleNum: updated};
    await ref
        .read(gameStorageServiceProvider)
        .saveRuleMastery(ruleNum, updated);
  }

  Future<void> recordWrong(int ruleNum) async {
    final current = state[ruleNum] ?? MasteryData.initial();
    final updated = current.copyWith(
      timesWrong: current.timesWrong + 1,
      lastPracticed: DateTime.now(),
    );
    state = {...state, ruleNum: updated};
    await ref
        .read(gameStorageServiceProvider)
        .saveRuleMastery(ruleNum, updated);
  }
}

// ═══════════════════════════════════════════════════════════════
// Settings
// ═══════════════════════════════════════════════════════════════

final gameSettingsProvider =
    NotifierProvider<GameSettingsNotifier, AppSettings>(
        GameSettingsNotifier.new);

class GameSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.read(gameStorageServiceProvider).getSettings();
  }

  Future<void> update(AppSettings settings) async {
    state = settings;
    await ref.read(gameStorageServiceProvider).saveSettings(settings);
  }

  Future<void> setSoundVolume(double volume) async {
    await update(state.copyWith(soundVolume: volume));
    await ref.read(audioRepositoryProvider).setVolume(volume);
  }

  Future<void> toggleHindi(bool value) async {
    await update(state.copyWith(showHindiPronunciation: value));
  }

  Future<void> toggleMarathi(bool value) async {
    await update(state.copyWith(showMarathiPronunciation: value));
  }
}

// ═══════════════════════════════════════════════════════════════
// Premium Status (shortcut)
// ═══════════════════════════════════════════════════════════════

final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(playerProfileProvider).isPremium;
});
