enum AppLanguage { en, hi, mr }

enum AgeLevel { tiny, starter, explorer, master, adult }

class PlayerProfile {
  final String nickname;
  final String avatarId;
  final bool isPremium;
  final AppLanguage language;
  final AgeLevel ageLevel;
  final int coins;
  final int xp;
  final int level;
  final DateTime createdAt;
  final DateTime lastPlayedAt;

  const PlayerProfile({
    required this.nickname,
    this.avatarId = 'avatar_01',
    this.isPremium = false,
    this.language = AppLanguage.en,
    this.ageLevel = AgeLevel.starter,
    this.coins = 0,
    this.xp = 0,
    this.level = 1,
    required this.createdAt,
    required this.lastPlayedAt,
  });

  factory PlayerProfile.defaultProfile() {
    final now = DateTime.now();
    return PlayerProfile(
      nickname: 'Player',
      createdAt: now,
      lastPlayedAt: now,
    );
  }

  /// Grid columns for phonogram tiles based on age level
  int get gridColumns => switch (ageLevel) {
        AgeLevel.tiny => 3,
        AgeLevel.starter => 4,
        AgeLevel.explorer => 5,
        AgeLevel.master => 6,
        AgeLevel.adult => 6,
      };

  /// Font scale multiplier based on age level
  double get fontScale => switch (ageLevel) {
        AgeLevel.tiny => 1.4,
        AgeLevel.starter => 1.2,
        AgeLevel.explorer => 1.1,
        AgeLevel.master => 1.0,
        AgeLevel.adult => 1.0,
      };

  /// Celebration animation duration in ms
  int get celebrationDuration => switch (ageLevel) {
        AgeLevel.tiny => 3000,
        AgeLevel.starter => 2500,
        AgeLevel.explorer => 2000,
        AgeLevel.master => 1500,
        AgeLevel.adult => 1000,
      };

  /// Key for age-adaptive content lookup
  String get ageLevelKey => ageLevel.name;

  PlayerProfile copyWith({
    String? nickname,
    String? avatarId,
    bool? isPremium,
    AppLanguage? language,
    AgeLevel? ageLevel,
    int? coins,
    int? xp,
    int? level,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) {
    return PlayerProfile(
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      isPremium: isPremium ?? this.isPremium,
      language: language ?? this.language,
      ageLevel: ageLevel ?? this.ageLevel,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      nickname: json['nickname'] as String? ?? 'Player',
      avatarId: json['avatarId'] as String? ?? 'avatar_01',
      isPremium: json['isPremium'] as bool? ?? false,
      language: AppLanguage.values[json['language'] as int? ?? 0],
      ageLevel: AgeLevel.values[json['ageLevel'] as int? ?? 1],
      coins: json['coins'] as int? ?? 0,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'avatarId': avatarId,
        'isPremium': isPremium,
        'language': language.index,
        'ageLevel': ageLevel.index,
        'coins': coins,
        'xp': xp,
        'level': level,
        'createdAt': createdAt.toIso8601String(),
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
      };
}
