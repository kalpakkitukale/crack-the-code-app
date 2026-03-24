import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/models/word_entry.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';

class TierProgress {
  final Set<int> unlockedTiers;
  final Map<int, double> tierMasteryPercent;

  const TierProgress({
    this.unlockedTiers = const {1},
    this.tierMasteryPercent = const {},
  });

  int get currentTier {
    int max = 1;
    for (final t in unlockedTiers) {
      if (t > max) max = t;
    }
    return max;
  }

  bool isTierUnlocked(int tier) => unlockedTiers.contains(tier);

  double masteryForTier(int tier) => tierMasteryPercent[tier] ?? 0.0;

  static const tierNames = {
    1: 'Foundation',
    2: 'Builder',
    3: 'Explorer',
    4: 'Adventurer',
    5: 'Challenger',
    6: 'Scholar',
    7: 'Expert',
    8: 'Champion',
    9: 'Genius',
    10: 'Legend',
  };

  String tierName(int tier) => tierNames[tier] ?? 'Tier $tier';
}

final tierProgressProvider =
    NotifierProvider<TierProgressNotifier, TierProgress>(
        TierProgressNotifier.new);

class TierProgressNotifier extends Notifier<TierProgress> {
  @override
  TierProgress build() {
    final mastery = ref.watch(phonogramMasteryProvider);
    final wordRepo = ref.watch(wordRepositoryProvider);
    return _compute(mastery, wordRepo);
  }

  TierProgress _compute(
      Map<String, MasteryData> mastery, dynamic wordRepo) {
    // Tier 1 is always unlocked
    final unlocked = <int>{1};
    final masteryPercent = <int, double>{};

    for (int tier = 1; tier <= 10; tier++) {
      final words = (wordRepo as dynamic).getWordsForTier(tier) as List<WordEntry>;
      if (words.isEmpty) continue;

      // Count words where all phonograms in breakdown are at "seen" or higher
      int masteredCount = 0;
      for (final word in words) {
        bool allSeen = true;
        for (final phonogram in word.soundBreakdown) {
          final m = mastery[phonogram];
          if (m == null || m.level.index < MasteryLevel.seen.index) {
            allSeen = false;
            break;
          }
        }
        // Fallback: if no soundBreakdown, count it as seen if any phonogram from breakdown is heard
        if (word.soundBreakdown.isEmpty && word.phonogramBreakdown.isNotEmpty) {
          allSeen = word.phonogramBreakdown.every((p) {
            return mastery.values.any((m) =>
                m.level.index >= MasteryLevel.heard.index);
          });
        }
        if (allSeen) masteredCount++;
      }

      final percent = words.isEmpty ? 0.0 : masteredCount / words.length;
      masteryPercent[tier] = percent;

      // Unlock next tier if 50% of current tier is mastered
      if (percent >= 0.5 && tier < 10) {
        unlocked.add(tier + 1);
      }
    }

    return TierProgress(
      unlockedTiers: unlocked,
      tierMasteryPercent: masteryPercent,
    );
  }
}

// Convenience: words for a specific phonogram filtered by unlocked tiers
final wordsForPhonogramProvider =
    Provider.family<List<WordEntry>, String>((ref, phonogramText) {
  final tiers = ref.watch(tierProgressProvider).unlockedTiers;
  final wordRepo = ref.watch(wordRepositoryProvider);
  return wordRepo.getWordsForPhonogramInTiers(phonogramText, tiers);
});

// All unlocked words
final unlockedWordsProvider = Provider<List<WordEntry>>((ref) {
  final tiers = ref.watch(tierProgressProvider).unlockedTiers;
  final wordRepo = ref.watch(wordRepositoryProvider);
  return wordRepo.getUnlockedWords(tiers);
});
