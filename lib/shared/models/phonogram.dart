import 'dart:ui';

import 'package:crack_the_code/shared/models/category.dart';
import 'package:crack_the_code/shared/models/example_word.dart';
import 'package:crack_the_code/shared/models/phonogram_sound.dart';

class Phonogram {
  final String id;
  final String text;
  final PhonogramCategory category;
  final String colorHex;
  final List<PhonogramSound> sounds;
  final List<ExampleWord> detailWords;
  final String funFact;
  final String hindiText;
  final String marathiText;

  const Phonogram({
    required this.id,
    required this.text,
    required this.category,
    required this.colorHex,
    this.sounds = const [],
    this.detailWords = const [],
    this.funFact = '',
    this.hindiText = '',
    this.marathiText = '',
  });

  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  int get soundCount => sounds.length;
  bool get isMultiSound => sounds.length > 1;

  factory Phonogram.fromJson(Map<String, dynamic> json) {
    return Phonogram(
      id: json['id'] as String,
      text: json['text'] as String,
      category: PhonogramCategoryX.fromString(json['category'] as String),
      colorHex: json['colorHex'] as String? ?? '#BDBDBD',
      sounds: (json['sounds'] as List<dynamic>?)
              ?.map((e) => PhonogramSound.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      detailWords: (json['detailWords'] as List<dynamic>?)
              ?.map((e) {
                if (e is Map<String, dynamic>) {
                  return ExampleWord.fromJson(e);
                }
                // Plain string like "CAT" — convert to ExampleWord
                final word = e.toString();
                return ExampleWord(
                  word: word,
                  emoji: '',
                  audioFile: 'words/${word.toLowerCase()}.ogg',
                );
              })
              .toList() ??
          [],
      funFact: json['funFact'] as String? ?? '',
      hindiText: json['hindiText'] as String? ?? '',
      marathiText: json['marathiText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'category': category.name,
        'colorHex': colorHex,
        'sounds': sounds.map((e) => e.toJson()).toList(),
        'detailWords': detailWords.map((e) => e.toJson()).toList(),
        'funFact': funFact,
        'hindiText': hindiText,
        'marathiText': marathiText,
      };
}
