import 'dart:ui';

class Level {
  final int number;
  final Map<String, String> name;
  final String color;
  final String colorName;
  final int stars;
  final int ageMin;
  final int ageMax;
  final int durationWeeks;
  final int phonogramCount;
  final int ruleCount;
  final int characterCount;
  final int totalCards;

  const Level({
    required this.number,
    required this.name,
    required this.color,
    required this.colorName,
    this.stars = 1,
    this.ageMin = 3,
    this.ageMax = 14,
    this.durationWeeks = 9,
    this.phonogramCount = 50,
    this.ruleCount = 15,
    this.characterCount = 70,
    this.totalCards = 130,
  });

  String nameForLang(String lang) => name[lang] ?? name['en'] ?? '';
  Color get colorValue => Color(int.parse(color.replaceFirst('#', '0xFF')));
  String get starDisplay => '★' * stars;

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      number: json['number'] as int,
      name: _m(json['name']),
      color: json['color'] as String? ?? '#4CAF50',
      colorName: json['colorName'] as String? ?? 'green',
      stars: json['stars'] as int? ?? 1,
      ageMin: json['ageMin'] as int? ?? 3,
      ageMax: json['ageMax'] as int? ?? 14,
      durationWeeks: json['durationWeeks'] as int? ?? 9,
      phonogramCount: json['phonogramCount'] as int? ?? 50,
      ruleCount: json['ruleCount'] as int? ?? 15,
      characterCount: json['characterCount'] as int? ?? 70,
      totalCards: json['totalCards'] as int? ?? 130,
    );
  }

  static Map<String, String> _m(dynamic v) {
    if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v.toString()));
    return {};
  }
}
