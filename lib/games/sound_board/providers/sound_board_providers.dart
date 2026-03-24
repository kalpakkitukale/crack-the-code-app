import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crack_the_code/shared/models/category.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/tier_progress_provider.dart';
import 'package:crack_the_code/games/sound_board/models/sound_board_progress.dart';
import 'package:crack_the_code/games/sound_board/models/word_builder_state.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

// ═══════════════════════════════════════════════════════════════
// Progress Tracking
// ═══════════════════════════════════════════════════════════════

const _boxName = 'sound_board_progress';

final soundBoardProgressProvider =
    NotifierProvider<SoundBoardProgressNotifier, SoundBoardProgress>(
        SoundBoardProgressNotifier.new);

class SoundBoardProgressNotifier extends Notifier<SoundBoardProgress> {
  @override
  SoundBoardProgress build() {
    _ensureBox();
    final box = Hive.box<String>(_boxName);
    final json = box.get('progress');
    if (json == null) return const SoundBoardProgress();
    return SoundBoardProgress.fromJson(
        jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> _ensureBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  Future<void> recordTap(String phonogramId) async {
    final isNew = !state.exploredPhonogramIds.contains(phonogramId);
    final newExplored = {...state.exploredPhonogramIds, phonogramId};
    state = state.copyWith(
      exploredPhonogramIds: newExplored,
      totalTaps: state.totalTaps + 1,
      lastPlayed: DateTime.now(),
    );
    await _save();

    // Update unified mastery
    final phonogram =
        ref.read(phonogramRepositoryProvider).getById(phonogramId);
    if (phonogram != null) {
      for (final sound in phonogram.sounds) {
        await ref
            .read(phonogramMasteryProvider.notifier)
            .recordCorrect(sound.soundId, MasteryLevel.heard);
      }
    }

    // Show discovery message if new
    if (isNew && phonogram != null) {
      ref.read(kkMessageProvider.notifier).state =
          KKMessage.discovery(phonogram.text);
    }
  }

  Future<void> recordWordBuilt(String word, int tier) async {
    final tierWords =
        Map<int, List<String>>.from(state.wordsBuiltByTier);
    final list = List<String>.from(tierWords[tier] ?? []);
    if (!list.contains(word)) {
      list.add(word);
      tierWords[tier] = list;
      state = state.copyWith(wordsBuiltByTier: tierWords);
      await _save();
    }
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingComplete: true);
    await _save();
  }

  Future<void> _save() async {
    await _ensureBox();
    final box = Hive.box<String>(_boxName);
    await box.put('progress', jsonEncode(state.toJson()));
  }
}

// ═══════════════════════════════════════════════════════════════
// View Mode
// ═══════════════════════════════════════════════════════════════

enum CollectionFilter { all, mastered, notFound, byGroup }

final collectionFilterProvider =
    StateProvider<CollectionFilter>((ref) => CollectionFilter.all);

final selectedCategoryProvider =
    StateProvider<PhonogramCategory?>((ref) => null);

// ═══════════════════════════════════════════════════════════════
// Multi-Sound Cycling
// ═══════════════════════════════════════════════════════════════

final currentSoundIndexProvider =
    StateProvider.family<int, String>((ref, phonogramId) => 0);

// ═══════════════════════════════════════════════════════════════
// Mastery per Phonogram (minimum across all sounds)
// ═══════════════════════════════════════════════════════════════

final phonogramMasteryLevelProvider =
    Provider.family<MasteryLevel, String>((ref, phonogramId) {
  final mastery = ref.watch(phonogramMasteryProvider);
  final repo = ref.watch(phonogramRepositoryProvider);
  final phonogram = repo.getById(phonogramId);
  if (phonogram == null || phonogram.sounds.isEmpty) {
    return MasteryLevel.unheard;
  }

  MasteryLevel min = MasteryLevel.mastered;
  for (final sound in phonogram.sounds) {
    final level =
        mastery[sound.soundId]?.level ?? MasteryLevel.unheard;
    if (level.index < min.index) min = level;
  }
  return min;
});

// ═══════════════════════════════════════════════════════════════
// KK Messages
// ═══════════════════════════════════════════════════════════════

final kkMessageProvider = StateProvider<KKMessage>((ref) {
  return KKMessage.greeting();
});

// ═══════════════════════════════════════════════════════════════
// Today's Suggested Phonogram
// ═══════════════════════════════════════════════════════════════

final todaySuggestedPhonogramProvider = Provider<Phonogram?>((ref) {
  final progress = ref.watch(soundBoardProgressProvider);
  final phonograms = ref.watch(phonogramsProvider);

  // Find first undiscovered phonogram
  for (final p in phonograms) {
    if (!progress.isExplored(p.id)) return p;
  }

  // All discovered — suggest weakest mastery
  MasteryLevel weakest = MasteryLevel.mastered;
  Phonogram? weakestPhonogram;
  for (final p in phonograms) {
    final level = ref.watch(phonogramMasteryLevelProvider(p.id));
    if (level.index < weakest.index) {
      weakest = level;
      weakestPhonogram = p;
    }
  }
  return weakestPhonogram;
});

// ═══════════════════════════════════════════════════════════════
// Word Builder
// ═══════════════════════════════════════════════════════════════

final wordBuilderStateProvider =
    NotifierProvider<WordBuilderNotifier, WordBuilderState>(
        WordBuilderNotifier.new);

class WordBuilderNotifier extends Notifier<WordBuilderState> {
  Timer? _checkTimer;

  @override
  WordBuilderState build() => WordBuilderState.empty();

  void addPhonogram(String phonogramId, String phonogramText) {
    state = state.copyWith(
      selectedPhonogramIds: [...state.selectedPhonogramIds, phonogramId],
      selectedTexts: [...state.selectedTexts, phonogramText],
      clearResult: true,
      clearWordEntry: true,
    );
    _scheduleCheck();
  }

  void undo() {
    if (state.selectedPhonogramIds.isEmpty) return;
    state = state.copyWith(
      selectedPhonogramIds: state.selectedPhonogramIds
          .sublist(0, state.selectedPhonogramIds.length - 1),
      selectedTexts:
          state.selectedTexts.sublist(0, state.selectedTexts.length - 1),
      clearResult: true,
      clearWordEntry: true,
    );
  }

  void clear() {
    _checkTimer?.cancel();
    state = WordBuilderState.empty();
  }

  Future<void> checkWord() async {
    _checkTimer?.cancel();
    if (state.selectedTexts.isEmpty) return;
    state = state.copyWith(isChecking: true);

    final wordRepo = ref.read(wordRepositoryProvider);
    final assembled = state.assembledText;
    final isValid = wordRepo.isValidWord(assembled);

    if (isValid) {
      final entry = wordRepo.getWordEntry(assembled);
      final tiers = ref.read(tierProgressProvider).unlockedTiers;
      final isBonus = entry != null && !tiers.contains(entry.tier);

      state = state.copyWith(
        isChecking: false,
        validatedWord: assembled.toUpperCase(),
        validatedWordEntry: entry,
        result: WordBuilderResult.valid,
        isBonusWord: isBonus,
      );

      // Record progress
      final tier = entry?.tier ?? 1;
      await ref
          .read(soundBoardProgressProvider.notifier)
          .recordWordBuilt(assembled.toUpperCase(), tier);

      // Award coins
      final coins = isBonus ? 10 : 5;
      await ref.read(playerProfileProvider.notifier).addCoins(coins);
      await ref.read(playerProfileProvider.notifier).addXp(coins);

      // Update mastery for phonograms used
      for (final soundId in (entry?.soundBreakdown ?? <String>[])) {
        await ref
            .read(phonogramMasteryProvider.notifier)
            .recordCorrect(soundId, MasteryLevel.built);
      }

      // KK message
      if (isBonus) {
        ref.read(kkMessageProvider.notifier).state =
            KKMessage.bonusWord(assembled.toUpperCase(), entry.tier);
      } else {
        ref.read(kkMessageProvider.notifier).state =
            KKMessage.wordBuilt(assembled.toUpperCase());
      }
    } else {
      state = state.copyWith(
        isChecking: false,
        result: WordBuilderResult.invalid,
        clearWordEntry: true,
      );
      ref.read(kkMessageProvider.notifier).state = KKMessage.wordInvalid();

      // Auto-clear after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (state.isInvalid) {
          state = state.copyWith(clearResult: true);
        }
      });
    }
  }

  void _scheduleCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer(const Duration(seconds: 3), checkWord);
  }
}

// ═══════════════════════════════════════════════════════════════
// Search
// ═══════════════════════════════════════════════════════════════

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Phonogram>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(phonogramRepositoryProvider).search(query);
});

// ═══════════════════════════════════════════════════════════════
// Streak
// ═══════════════════════════════════════════════════════════════

final streakProvider = Provider<int>((ref) {
  final progress = ref.watch(soundBoardProgressProvider);
  if (progress.lastPlayed == null) return 0;
  final now = DateTime.now();
  final last = progress.lastPlayed!;
  final diff = now.difference(last).inDays;
  if (diff == 0) return 1; // played today
  return 0;
});
