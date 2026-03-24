import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';

class ContentConfig {
  final Map<String, dynamic> free;
  final Map<String, dynamic> premium;
  final Map<String, dynamic> pricing;
  final List<Map<String, dynamic>> physicalGames;

  ContentConfig({
    required this.free,
    required this.premium,
    required this.pricing,
    required this.physicalGames,
  });

  // Free content checks
  bool get learnTheSoundsFree => free['learnTheSoundsAllLessons'] == true;
  bool get soundBoardFree => free['soundBoardFull'] == true;
  bool get dailyDecoderFree => free['dailyDecoderFull'] == true;
  bool get wordBuilderFree => free['wordBuilderFull'] == true;
  List<int> get freeEpisodeNumbers =>
      (free['freeEpisodes'] as List?)?.map((e) => e as int).toList() ?? [0, 1];
  int get flashcardsPerDay => free['flashcardsPerDay'] as int? ?? 50;
  int get quizzesPerDay => free['quizzesPerDay'] as int? ?? 5;
  int get spellingBeeMaxTier => free['spellingBeeMaxTier'] as int? ?? 2;
  int get glossaryMaxWords => free['glossaryMaxWords'] as int? ?? 1000;
  int get physicalGameFreeModes => free['physicalGameFreeModes'] as int? ?? 6;
  int get previewDurationSeconds => free['previewDurationSeconds'] as int? ?? 120;
  int get maxWordTier => free['maxWordTier'] as int? ?? 2;

  // Pricing
  int get yearlyPrice => pricing['yearly'] as int? ?? 499;
  int get monthlyPrice => pricing['monthly'] as int? ?? 99;
  int get trialDays => pricing['trialDays'] as int? ?? 7;
  String get currency => pricing['currency'] as String? ?? 'INR';

  factory ContentConfig.fromJson(Map<String, dynamic> json) {
    return ContentConfig(
      free: json['free'] as Map<String, dynamic>? ?? {},
      premium: json['premium'] as Map<String, dynamic>? ?? {},
      pricing: json['pricing'] as Map<String, dynamic>? ?? {},
      physicalGames: (json['physicalGames'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}

final contentConfigProvider = FutureProvider<ContentConfig>((ref) async {
  final jsonString =
      await rootBundle.loadString('assets/data/content_config.json');
  final json = jsonDecode(jsonString) as Map<String, dynamic>;
  return ContentConfig.fromJson(json);
});

// Convenience: is this episode free?
final isEpisodeFreeProvider =
    Provider.family<bool, int>((ref, episodeNumber) {
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return true;

  final config = ref.watch(contentConfigProvider).valueOrNull;
  if (config == null) return episodeNumber <= 1; // default: first 2 free
  return config.freeEpisodeNumbers.contains(episodeNumber);
});

// Convenience: can user access this feature?
final canAccessFeatureProvider =
    Provider.family<bool, String>((ref, feature) {
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return true;

  final config = ref.watch(contentConfigProvider).valueOrNull;
  if (config == null) return true; // default: allow during loading

  return switch (feature) {
    'learn_the_sounds' => config.learnTheSoundsFree,
    'sound_board' => config.soundBoardFree,
    'daily_decoder' => config.dailyDecoderFree,
    'word_builder' => config.wordBuilderFree,
    'mind_maps' => isPremium,
    'all_games' => isPremium,
    _ => true,
  };
});
