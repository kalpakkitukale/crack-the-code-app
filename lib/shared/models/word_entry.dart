class WordEntry {
  final String word;
  final int tier;
  final List<String> phonogramBreakdown;
  final List<String> soundBreakdown;
  final List<int> ruleNumbers;
  final int difficulty;
  final int frequency;
  final int gradeLevel;
  final String? audioFile;
  final String? emoji;
  final String? partOfSpeech;
  final Map<String, String> meanings;
  final Map<String, String> sentences;
  final Map<String, String> spellingNotes;

  const WordEntry({
    required this.word,
    required this.phonogramBreakdown,
    required this.soundBreakdown,
    this.tier = 1,
    this.ruleNumbers = const [],
    this.difficulty = 1,
    this.frequency = 0,
    this.gradeLevel = 1,
    this.audioFile,
    this.emoji,
    this.partOfSpeech,
    this.meanings = const {},
    this.sentences = const {},
    this.spellingNotes = const {},
  });

  String meaningForLevel(String level) =>
      meanings[level] ?? meanings['starter'] ?? '';

  String sentenceForLevel(String level) =>
      sentences[level] ?? sentences['starter'] ?? '';

  String spellingNoteForLevel(String level) =>
      spellingNotes[level] ?? spellingNotes['starter'] ?? '';

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      word: json['word'] as String,
      tier: json['tier'] as int? ?? 1,
      phonogramBreakdown: (json['phonogramBreakdown'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      soundBreakdown: (json['soundBreakdown'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      ruleNumbers: (json['ruleNumbers'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      difficulty: json['difficulty'] as int? ?? 1,
      frequency: json['frequency'] as int? ?? 0,
      gradeLevel: json['gradeLevel'] as int? ?? 1,
      audioFile: json['audioFile'] as String?,
      emoji: json['emoji'] as String?,
      partOfSpeech: json['partOfSpeech'] as String?,
      meanings: _parseStringMap(json['meanings']),
      sentences: _parseStringMap(json['sentences']),
      spellingNotes: _parseStringMap(json['spellingNotes']),
    );
  }

  static Map<String, String> _parseStringMap(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'tier': tier,
        'phonogramBreakdown': phonogramBreakdown,
        'soundBreakdown': soundBreakdown,
        'ruleNumbers': ruleNumbers,
        'difficulty': difficulty,
        'frequency': frequency,
        'gradeLevel': gradeLevel,
        if (audioFile != null) 'audioFile': audioFile,
        if (emoji != null) 'emoji': emoji,
        if (partOfSpeech != null) 'partOfSpeech': partOfSpeech,
        if (meanings.isNotEmpty) 'meanings': meanings,
        if (sentences.isNotEmpty) 'sentences': sentences,
        if (spellingNotes.isNotEmpty) 'spellingNotes': spellingNotes,
      };
}
