// Parental Control Settings Entity
// Stores parental control configuration for the Junior app segment

/// Daily screen time limits in minutes
enum ScreenTimeLimit {
  minutes30(30, '30 minutes'),
  minutes60(60, '1 hour'),
  minutes90(90, '1.5 hours'),
  minutes120(120, '2 hours'),
  unlimited(-1, 'Unlimited');

  const ScreenTimeLimit(this.minutes, this.displayName);
  final int minutes;
  final String displayName;

  bool get hasLimit => minutes > 0;

  static ScreenTimeLimit fromMinutes(int minutes) {
    return ScreenTimeLimit.values.firstWhere(
      (limit) => limit.minutes == minutes,
      orElse: () => ScreenTimeLimit.unlimited,
    );
  }
}

/// Content difficulty filter levels
enum DifficultyFilter {
  easyOnly('Easy Only', 'Show only easy content'),
  easyMedium('Easy + Medium', 'Show easy and medium content'),
  all('All Levels', 'Show all difficulty levels');

  const DifficultyFilter(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Parental control settings
class ParentalSettings {
  /// Whether parental controls are enabled
  final bool isEnabled;

  /// Hashed PIN for parental access (4-digit)
  final String? pinHash;

  /// Daily screen time limit
  final ScreenTimeLimit screenTimeLimit;

  /// Whether to show timer to child
  final bool showTimerToChild;

  /// Content difficulty filter
  final DifficultyFilter difficultyFilter;

  /// List of hidden subject IDs
  final List<String> hiddenSubjects;

  /// Whether weekly email reports are enabled
  final bool weeklyReportsEnabled;

  /// Parent's email for reports
  final String? parentEmail;

  /// Last PIN change timestamp
  final DateTime? pinChangedAt;

  /// Last settings update timestamp
  final DateTime? updatedAt;

  const ParentalSettings({
    this.isEnabled = false,
    this.pinHash,
    this.screenTimeLimit = ScreenTimeLimit.minutes60,
    this.showTimerToChild = true,
    this.difficultyFilter = DifficultyFilter.all,
    this.hiddenSubjects = const [],
    this.weeklyReportsEnabled = false,
    this.parentEmail,
    this.pinChangedAt,
    this.updatedAt,
  });

  /// Create a copy with updated fields
  ParentalSettings copyWith({
    bool? isEnabled,
    String? pinHash,
    ScreenTimeLimit? screenTimeLimit,
    bool? showTimerToChild,
    DifficultyFilter? difficultyFilter,
    List<String>? hiddenSubjects,
    bool? weeklyReportsEnabled,
    String? parentEmail,
    DateTime? pinChangedAt,
    DateTime? updatedAt,
  }) {
    return ParentalSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      pinHash: pinHash ?? this.pinHash,
      screenTimeLimit: screenTimeLimit ?? this.screenTimeLimit,
      showTimerToChild: showTimerToChild ?? this.showTimerToChild,
      difficultyFilter: difficultyFilter ?? this.difficultyFilter,
      hiddenSubjects: hiddenSubjects ?? this.hiddenSubjects,
      weeklyReportsEnabled: weeklyReportsEnabled ?? this.weeklyReportsEnabled,
      parentEmail: parentEmail ?? this.parentEmail,
      pinChangedAt: pinChangedAt ?? this.pinChangedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'pinHash': pinHash,
      'screenTimeLimit': screenTimeLimit.minutes,
      'showTimerToChild': showTimerToChild,
      'difficultyFilter': difficultyFilter.name,
      'hiddenSubjects': hiddenSubjects,
      'weeklyReportsEnabled': weeklyReportsEnabled,
      'parentEmail': parentEmail,
      'pinChangedAt': pinChangedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory ParentalSettings.fromJson(Map<String, dynamic> json) {
    return ParentalSettings(
      isEnabled: json['isEnabled'] as bool? ?? false,
      pinHash: json['pinHash'] as String?,
      screenTimeLimit: ScreenTimeLimit.fromMinutes(
        json['screenTimeLimit'] as int? ?? 60,
      ),
      showTimerToChild: json['showTimerToChild'] as bool? ?? true,
      difficultyFilter: DifficultyFilter.values.firstWhere(
        (f) => f.name == json['difficultyFilter'],
        orElse: () => DifficultyFilter.all,
      ),
      hiddenSubjects: (json['hiddenSubjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      weeklyReportsEnabled: json['weeklyReportsEnabled'] as bool? ?? false,
      parentEmail: json['parentEmail'] as String?,
      pinChangedAt: json['pinChangedAt'] != null
          ? DateTime.parse(json['pinChangedAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParentalSettings &&
        other.isEnabled == isEnabled &&
        other.pinHash == pinHash &&
        other.screenTimeLimit == screenTimeLimit &&
        other.showTimerToChild == showTimerToChild &&
        other.difficultyFilter == difficultyFilter &&
        other.weeklyReportsEnabled == weeklyReportsEnabled &&
        other.parentEmail == parentEmail;
  }

  @override
  int get hashCode {
    return Object.hash(
      isEnabled,
      pinHash,
      screenTimeLimit,
      showTimerToChild,
      difficultyFilter,
      weeklyReportsEnabled,
      parentEmail,
    );
  }
}

/// Screen time usage tracking for today
class ScreenTimeUsage {
  /// Date for this usage record
  final DateTime date;

  /// Total minutes used today
  final int minutesUsed;

  /// Session start times
  final List<DateTime> sessionStarts;

  /// Session end times
  final List<DateTime> sessionEnds;

  /// Whether limit was reached today
  final bool limitReached;

  /// Time limit was extended by parent
  final bool wasExtended;

  const ScreenTimeUsage({
    required this.date,
    this.minutesUsed = 0,
    this.sessionStarts = const [],
    this.sessionEnds = const [],
    this.limitReached = false,
    this.wasExtended = false,
  });

  /// Check if today's usage is for the same calendar day
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get remaining minutes for today
  int remainingMinutes(ScreenTimeLimit limit) {
    if (!limit.hasLimit) return -1;
    return (limit.minutes - minutesUsed).clamp(0, limit.minutes);
  }

  /// Get usage percentage
  double usagePercentage(ScreenTimeLimit limit) {
    if (!limit.hasLimit) return 0.0;
    return (minutesUsed / limit.minutes).clamp(0.0, 1.0);
  }

  /// Create a copy with updated fields
  ScreenTimeUsage copyWith({
    DateTime? date,
    int? minutesUsed,
    List<DateTime>? sessionStarts,
    List<DateTime>? sessionEnds,
    bool? limitReached,
    bool? wasExtended,
  }) {
    return ScreenTimeUsage(
      date: date ?? this.date,
      minutesUsed: minutesUsed ?? this.minutesUsed,
      sessionStarts: sessionStarts ?? this.sessionStarts,
      sessionEnds: sessionEnds ?? this.sessionEnds,
      limitReached: limitReached ?? this.limitReached,
      wasExtended: wasExtended ?? this.wasExtended,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'minutesUsed': minutesUsed,
      'sessionStarts': sessionStarts.map((d) => d.toIso8601String()).toList(),
      'sessionEnds': sessionEnds.map((d) => d.toIso8601String()).toList(),
      'limitReached': limitReached,
      'wasExtended': wasExtended,
    };
  }

  /// Create from JSON map
  factory ScreenTimeUsage.fromJson(Map<String, dynamic> json) {
    return ScreenTimeUsage(
      date: DateTime.parse(json['date'] as String),
      minutesUsed: json['minutesUsed'] as int? ?? 0,
      sessionStarts: (json['sessionStarts'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      sessionEnds: (json['sessionEnds'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      limitReached: json['limitReached'] as bool? ?? false,
      wasExtended: json['wasExtended'] as bool? ?? false,
    );
  }

  /// Create an empty usage for today
  factory ScreenTimeUsage.today() {
    return ScreenTimeUsage(
      date: DateTime.now(),
    );
  }
}
