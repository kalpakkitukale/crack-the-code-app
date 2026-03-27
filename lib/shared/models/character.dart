class Character {
  final String id;
  final String name;
  final String phonogram;
  final String sound;
  final String soundId;
  final int level;
  final String levelColor;
  final Map<String, String> introduction;
  final List<String> easyWords;
  final List<String> mediumWords;

  const Character({
    required this.id,
    required this.name,
    required this.phonogram,
    required this.sound,
    required this.soundId,
    required this.level,
    required this.levelColor,
    this.introduction = const {},
    this.easyWords = const [],
    this.mediumWords = const [],
  });

  String introForLang(String lang) => introduction[lang] ?? introduction['en'] ?? '';
  List<String> get allWords => [...easyWords, ...mediumWords];

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      phonogram: json['phonogram'] as String,
      sound: json['sound'] as String,
      soundId: json['soundId'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      levelColor: json['levelColor'] as String? ?? 'green',
      introduction: _m(json['introduction']),
      easyWords: (json['easyWords'] as List?)?.map((e) => e.toString()).toList() ?? [],
      mediumWords: (json['mediumWords'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  static Map<String, String> _m(dynamic v) {
    if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v.toString()));
    return {};
  }
}
