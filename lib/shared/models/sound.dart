import 'package:crack_the_code/shared/models/example_word.dart';

class Sound {
  final String id;
  final String notation;
  final Map<String, String> name;
  final String type;
  final String subType;
  final List<String> phonogramIds;
  final int trialDay;
  final Map<String, String> mouthPosition;
  final List<ExampleWord> exampleWords;

  const Sound({
    required this.id,
    required this.notation,
    required this.name,
    required this.type,
    required this.subType,
    this.phonogramIds = const [],
    this.trialDay = 1,
    this.mouthPosition = const {},
    this.exampleWords = const [],
  });

  String nameForLang(String lang) => name[lang] ?? name['en'] ?? '';
  String mouthFor(String lang) => mouthPosition[lang] ?? mouthPosition['en'] ?? '';
  bool get isConsonant => type == 'consonant';
  bool get isVowel => type == 'vowel';

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      id: json['id'] as String,
      notation: json['notation'] as String,
      name: _m(json['name']),
      type: json['type'] as String? ?? 'consonant',
      subType: json['subType'] as String? ?? '',
      phonogramIds: (json['phonogramIds'] as List?)?.map((e) => e.toString()).toList() ?? [],
      trialDay: json['trialDay'] as int? ?? 1,
      mouthPosition: _m(json['mouthPosition']),
      exampleWords: (json['exampleWords'] as List?)
              ?.map((e) => ExampleWord.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  static Map<String, String> _m(dynamic v) {
    if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v.toString()));
    return {};
  }
}
