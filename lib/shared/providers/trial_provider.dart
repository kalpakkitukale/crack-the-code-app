import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TrialDay {
  final int day;
  final Map<String, String> title;
  final List<String> soundIds;
  final int soundCount;
  final bool isCelebration;
  final bool isReview;

  const TrialDay({
    required this.day,
    required this.title,
    this.soundIds = const [],
    this.soundCount = 0,
    this.isCelebration = false,
    this.isReview = false,
  });

  String titleForLang(String lang) => title[lang] ?? title['en'] ?? '';

  factory TrialDay.fromJson(Map<String, dynamic> json) {
    return TrialDay(
      day: json['day'] as int,
      title: (json['title'] as Map?)?.map((k, v) => MapEntry(k.toString(), v.toString())) ?? {},
      soundIds: (json['soundIds'] as List?)?.map((e) => e.toString()).toList() ?? [],
      soundCount: json['soundCount'] as int? ?? 0,
      isCelebration: json['isCelebration'] as bool? ?? false,
      isReview: json['isReview'] as bool? ?? false,
    );
  }
}

class TrialProgress {
  final int currentDay;
  final Set<String> masteredSoundIds;
  final bool trialCompleted;
  final DateTime? startDate;

  const TrialProgress({
    this.currentDay = 1,
    this.masteredSoundIds = const {},
    this.trialCompleted = false,
    this.startDate,
  });

  int get totalMastered => masteredSoundIds.length;
  bool isSoundMastered(String id) => masteredSoundIds.contains(id);

  TrialProgress copyWith({
    int? currentDay,
    Set<String>? masteredSoundIds,
    bool? trialCompleted,
    DateTime? startDate,
  }) => TrialProgress(
    currentDay: currentDay ?? this.currentDay,
    masteredSoundIds: masteredSoundIds ?? this.masteredSoundIds,
    trialCompleted: trialCompleted ?? this.trialCompleted,
    startDate: startDate ?? this.startDate,
  );

  factory TrialProgress.fromJson(Map<String, dynamic> json) => TrialProgress(
    currentDay: json['currentDay'] as int? ?? 1,
    masteredSoundIds: ((json['masteredSoundIds'] as List?) ?? []).map((e) => e.toString()).toSet(),
    trialCompleted: json['trialCompleted'] as bool? ?? false,
    startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    'currentDay': currentDay,
    'masteredSoundIds': masteredSoundIds.toList(),
    'trialCompleted': trialCompleted,
    'startDate': startDate?.toIso8601String(),
  };
}

// Trial days data
final trialDaysProvider = FutureProvider<List<TrialDay>>((ref) async {
  final json = await rootBundle.loadString('assets/data/trial_days.json');
  final list = jsonDecode(json) as List<dynamic>;
  return list.map((e) => TrialDay.fromJson(e as Map<String, dynamic>)).toList();
});

const _boxName = 'trial_progress';

final trialProgressProvider =
    NotifierProvider<TrialProgressNotifier, TrialProgress>(TrialProgressNotifier.new);

class TrialProgressNotifier extends Notifier<TrialProgress> {
  @override
  TrialProgress build() {
    try {
      final box = Hive.box<String>(_boxName);
      final json = box.get('progress');
      if (json == null) return const TrialProgress();
      return TrialProgress.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const TrialProgress();
    }
  }

  Future<void> startTrial() async {
    state = state.copyWith(
      currentDay: 1,
      startDate: DateTime.now(),
    );
    await _save();
  }

  Future<void> masterSound(String soundId) async {
    state = state.copyWith(
      masteredSoundIds: {...state.masteredSoundIds, soundId},
    );
    await _save();
  }

  Future<void> completeDay(int day) async {
    final nextDay = day + 1;
    if (nextDay > 7) {
      state = state.copyWith(currentDay: 7, trialCompleted: true);
    } else {
      state = state.copyWith(currentDay: nextDay);
    }
    await _save();
  }

  Future<void> completeTrial() async {
    state = state.copyWith(trialCompleted: true);
    await _save();
  }

  Future<void> _save() async {
    try {
      final box = Hive.box<String>(_boxName);
      await box.put('progress', jsonEncode(state.toJson()));
    } catch (_) {}
  }
}
