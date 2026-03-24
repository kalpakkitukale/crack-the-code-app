class Lesson {
  final int lessonId;
  final Map<String, String> title;
  final Map<String, String> subtitle;
  final Map<String, String> kkIntro;
  final String categoryKey;
  final List<String> phonogramIds;
  final int phonogramCount;
  final int estimatedMinutes;
  final int quizQuestions;
  final int? prerequisite;
  final String color;
  final String emoji;

  const Lesson({
    required this.lessonId,
    required this.title,
    required this.subtitle,
    required this.kkIntro,
    required this.categoryKey,
    required this.phonogramIds,
    required this.phonogramCount,
    required this.estimatedMinutes,
    required this.quizQuestions,
    this.prerequisite,
    required this.color,
    required this.emoji,
  });

  String titleForLang(String lang) => title[lang] ?? title['en'] ?? '';
  String subtitleForLang(String lang) => subtitle[lang] ?? subtitle['en'] ?? '';
  String kkIntroForLang(String lang) => kkIntro[lang] ?? kkIntro['en'] ?? '';

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'] as int,
      title: _parseStringMap(json['title']),
      subtitle: _parseStringMap(json['subtitle']),
      kkIntro: _parseStringMap(json['kkIntro']),
      categoryKey: json['categoryKey'] as String,
      phonogramIds: (json['phonogramIds'] as List).map((e) => e.toString()).toList(),
      phonogramCount: json['phonogramCount'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int,
      quizQuestions: json['quizQuestions'] as int,
      prerequisite: json['prerequisite'] as int?,
      color: json['color'] as String,
      emoji: json['emoji'] as String,
    );
  }

  static Map<String, String> _parseStringMap(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }
}

class LessonProgress {
  final int lessonId;
  final bool completed;
  final int phonogramsLearned;
  final int quizScore;
  final DateTime? completedAt;

  const LessonProgress({
    required this.lessonId,
    this.completed = false,
    this.phonogramsLearned = 0,
    this.quizScore = 0,
    this.completedAt,
  });

  LessonProgress copyWith({
    bool? completed,
    int? phonogramsLearned,
    int? quizScore,
    DateTime? completedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      completed: completed ?? this.completed,
      phonogramsLearned: phonogramsLearned ?? this.phonogramsLearned,
      quizScore: quizScore ?? this.quizScore,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as int,
      completed: json['completed'] as bool? ?? false,
      phonogramsLearned: json['phonogramsLearned'] as int? ?? 0,
      quizScore: json['quizScore'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'completed': completed,
        'phonogramsLearned': phonogramsLearned,
        'quizScore': quizScore,
        'completedAt': completedAt?.toIso8601String(),
      };
}

class Episode {
  final String id;
  final int number;
  final Map<String, String> title;
  final Map<String, String> description;
  final String duration;
  final bool isFree;
  final Map<String, String> audioLessonUrl;
  final Map<String, String> videoGuideUrl;
  final Map<String, String> kkAdventureUrl;
  final List<String> phonogramsIntroduced;
  final List<int> rulesIntroduced;

  const Episode({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.duration,
    required this.isFree,
    this.audioLessonUrl = const {},
    this.videoGuideUrl = const {},
    this.kkAdventureUrl = const {},
    this.phonogramsIntroduced = const [],
    this.rulesIntroduced = const [],
  });

  String titleForLang(String lang) => title[lang] ?? title['en'] ?? '';
  String descForLang(String lang) => description[lang] ?? description['en'] ?? '';

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      number: json['number'] as int,
      title: Lesson._parseStringMap(json['title']),
      description: Lesson._parseStringMap(json['description']),
      duration: json['duration'] as String? ?? '',
      isFree: json['isFree'] as bool? ?? false,
      audioLessonUrl: Lesson._parseStringMap(json['audioLessonUrl'] ?? {}),
      videoGuideUrl: Lesson._parseStringMap(json['videoGuideUrl'] ?? {}),
      kkAdventureUrl: Lesson._parseStringMap(json['kkAdventureUrl'] ?? {}),
      phonogramsIntroduced: (json['phonogramsIntroduced'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rulesIntroduced: (json['rulesIntroduced'] as List?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}
