class SoundBoardProgress {
  final Set<String> exploredPhonogramIds;
  final int totalTaps;
  final Map<int, List<String>> wordsBuiltByTier;
  final DateTime? lastPlayed;
  final bool onboardingComplete;
  final String? lastSuggestedPhonogramId;

  const SoundBoardProgress({
    this.exploredPhonogramIds = const {},
    this.totalTaps = 0,
    this.wordsBuiltByTier = const {},
    this.lastPlayed,
    this.onboardingComplete = false,
    this.lastSuggestedPhonogramId,
  });

  int get totalExplored => exploredPhonogramIds.length;
  int get totalAvailable => 73;
  double get explorationPercent =>
      totalAvailable == 0 ? 0 : totalExplored / totalAvailable;
  bool isExplored(String id) => exploredPhonogramIds.contains(id);

  int get totalWordsBuilt =>
      wordsBuiltByTier.values.fold(0, (a, b) => a + b.length);

  SoundBoardProgress copyWith({
    Set<String>? exploredPhonogramIds,
    int? totalTaps,
    Map<int, List<String>>? wordsBuiltByTier,
    DateTime? lastPlayed,
    bool? onboardingComplete,
    String? lastSuggestedPhonogramId,
  }) {
    return SoundBoardProgress(
      exploredPhonogramIds:
          exploredPhonogramIds ?? this.exploredPhonogramIds,
      totalTaps: totalTaps ?? this.totalTaps,
      wordsBuiltByTier: wordsBuiltByTier ?? this.wordsBuiltByTier,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      lastSuggestedPhonogramId:
          lastSuggestedPhonogramId ?? this.lastSuggestedPhonogramId,
    );
  }

  factory SoundBoardProgress.fromJson(Map<String, dynamic> json) {
    final wordsMap = <int, List<String>>{};
    if (json['wordsBuiltByTier'] is Map) {
      (json['wordsBuiltByTier'] as Map).forEach((k, v) {
        wordsMap[int.parse(k.toString())] =
            (v as List).map((e) => e.toString()).toList();
      });
    }
    return SoundBoardProgress(
      exploredPhonogramIds:
          ((json['exploredPhonogramIds'] as List?) ?? [])
              .map((e) => e.toString())
              .toSet(),
      totalTaps: json['totalTaps'] as int? ?? 0,
      wordsBuiltByTier: wordsMap,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.tryParse(json['lastPlayed'] as String)
          : null,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      lastSuggestedPhonogramId:
          json['lastSuggestedPhonogramId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'exploredPhonogramIds': exploredPhonogramIds.toList(),
        'totalTaps': totalTaps,
        'wordsBuiltByTier': wordsBuiltByTier
            .map((k, v) => MapEntry(k.toString(), v)),
        'lastPlayed': lastPlayed?.toIso8601String(),
        'onboardingComplete': onboardingComplete,
        'lastSuggestedPhonogramId': lastSuggestedPhonogramId,
      };
}
