enum MasteryLevel {
  unheard,
  heard,
  seen,
  built,
  mastered,
}

class MasteryData {
  final MasteryLevel level;
  final int timesCorrect;
  final int timesWrong;
  final DateTime lastPracticed;

  const MasteryData({
    this.level = MasteryLevel.unheard,
    this.timesCorrect = 0,
    this.timesWrong = 0,
    required this.lastPracticed,
  });

  factory MasteryData.initial() => MasteryData(
        lastPracticed: DateTime.now(),
      );

  double get accuracy {
    final total = timesCorrect + timesWrong;
    return total == 0 ? 0.0 : timesCorrect / total;
  }

  MasteryData copyWith({
    MasteryLevel? level,
    int? timesCorrect,
    int? timesWrong,
    DateTime? lastPracticed,
  }) {
    return MasteryData(
      level: level ?? this.level,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      timesWrong: timesWrong ?? this.timesWrong,
      lastPracticed: lastPracticed ?? this.lastPracticed,
    );
  }

  factory MasteryData.fromJson(Map<String, dynamic> json) {
    return MasteryData(
      level: MasteryLevel.values[json['level'] as int? ?? 0],
      timesCorrect: json['timesCorrect'] as int? ?? 0,
      timesWrong: json['timesWrong'] as int? ?? 0,
      lastPracticed: json['lastPracticed'] != null
          ? DateTime.parse(json['lastPracticed'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level.index,
        'timesCorrect': timesCorrect,
        'timesWrong': timesWrong,
        'lastPracticed': lastPracticed.toIso8601String(),
      };
}
