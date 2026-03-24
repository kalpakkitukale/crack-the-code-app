import 'package:crack_the_code/shared/models/example_word.dart';

class PhonogramSound {
  final String soundId;
  final String phonogramId;
  final String notation;
  final String audioFile;
  final String hindiText;
  final String marathiText;
  final String hindiAudio;
  final String marathiAudio;
  final List<ExampleWord> exampleWords;

  const PhonogramSound({
    required this.soundId,
    required this.phonogramId,
    required this.notation,
    required this.audioFile,
    this.hindiText = '',
    this.marathiText = '',
    this.hindiAudio = '',
    this.marathiAudio = '',
    this.exampleWords = const [],
  });

  factory PhonogramSound.fromJson(Map<String, dynamic> json) {
    return PhonogramSound(
      soundId: json['soundId'] as String,
      phonogramId: json['phonogramId'] as String,
      notation: json['notation'] as String,
      audioFile: json['audioFile'] as String? ?? '',
      hindiText: json['hindiText'] as String? ?? '',
      marathiText: json['marathiText'] as String? ?? '',
      hindiAudio: json['hindiAudio'] as String? ?? '',
      marathiAudio: json['marathiAudio'] as String? ?? '',
      exampleWords: (json['exampleWords'] as List<dynamic>?)
              ?.map((e) => ExampleWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'soundId': soundId,
        'phonogramId': phonogramId,
        'notation': notation,
        'audioFile': audioFile,
        'hindiText': hindiText,
        'marathiText': marathiText,
        'hindiAudio': hindiAudio,
        'marathiAudio': marathiAudio,
        'exampleWords': exampleWords.map((e) => e.toJson()).toList(),
      };
}
