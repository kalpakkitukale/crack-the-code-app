import 'package:crack_the_code/shared/models/mastery_data.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final DateTime earnedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    this.iconAsset = '',
    required this.earnedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconAsset: json['iconAsset'] as String? ?? '',
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconAsset': iconAsset,
        'earnedAt': earnedAt.toIso8601String(),
      };
}

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime lastPlayDate;

  const StreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastPlayDate,
  });

  factory StreakData.initial() => StreakData(lastPlayDate: DateTime.now());

  bool get isActiveToday {
    final now = DateTime.now();
    return lastPlayDate.year == now.year &&
        lastPlayDate.month == now.month &&
        lastPlayDate.day == now.day;
  }

  StreakData recordPlay() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final isConsecutive = lastPlayDate.year == yesterday.year &&
        lastPlayDate.month == yesterday.month &&
        lastPlayDate.day == yesterday.day;

    if (isActiveToday) return this;

    final newStreak = isConsecutive ? currentStreak + 1 : 1;
    return StreakData(
      currentStreak: newStreak,
      longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      lastPlayDate: now,
    );
  }

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastPlayDate: json['lastPlayDate'] != null
          ? DateTime.parse(json['lastPlayDate'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastPlayDate': lastPlayDate.toIso8601String(),
      };
}

class UnifiedProgress {
  final Map<String, MasteryData> phonogramMastery;
  final Map<int, MasteryData> ruleMastery;
  final List<Badge> badges;
  final StreakData streaks;
  final int totalCoins;
  final int totalXp;

  const UnifiedProgress({
    this.phonogramMastery = const {},
    this.ruleMastery = const {},
    this.badges = const [],
    required this.streaks,
    this.totalCoins = 0,
    this.totalXp = 0,
  });

  factory UnifiedProgress.initial() => UnifiedProgress(
        streaks: StreakData.initial(),
      );

  int get phonogramsMastered => phonogramMastery.values
      .where((m) => m.level == MasteryLevel.mastered)
      .length;

  int get rulesMastered =>
      ruleMastery.values.where((m) => m.level == MasteryLevel.mastered).length;

  int get phonogramsHeard => phonogramMastery.values
      .where((m) => m.level.index >= MasteryLevel.heard.index)
      .length;
}
