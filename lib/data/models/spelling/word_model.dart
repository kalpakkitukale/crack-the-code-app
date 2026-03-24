import 'package:streamshaala/domain/entities/spelling/word.dart';

class WordModel {
  final String id;
  final String word;
  final String phonetic;
  final String definition;
  final List<String> meanings;
  final String partOfSpeech;
  final List<String> exampleSentences;
  final String? etymology;
  final String? imageUrl;
  final List<String> synonyms;
  final List<String> antonyms;
  final String difficulty;
  final int gradeLevel;
  final List<String> phonicsPatterns;
  final String? wordFamily;
  final String? prefix;
  final String? suffix;
  final String? rootWord;
  final List<String> commonMisspellings;
  final String? mnemonicHint;
  final List<String> tags;
  final int syllableCount;
  final String? audioUrl;

  const WordModel({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.definition,
    this.meanings = const [],
    required this.partOfSpeech,
    this.exampleSentences = const [],
    this.etymology,
    this.imageUrl,
    this.synonyms = const [],
    this.antonyms = const [],
    required this.difficulty,
    required this.gradeLevel,
    this.phonicsPatterns = const [],
    this.wordFamily,
    this.prefix,
    this.suffix,
    this.rootWord,
    this.commonMisspellings = const [],
    this.mnemonicHint,
    this.tags = const [],
    this.syllableCount = 1,
    this.audioUrl,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String,
      word: json['word'] as String,
      phonetic: json['phonetic'] as String? ?? '',
      definition: json['definition'] as String,
      meanings: (json['meanings'] as List<dynamic>?)?.cast<String>() ?? [],
      partOfSpeech: json['partOfSpeech'] as String? ?? 'noun',
      exampleSentences:
          (json['exampleSentences'] as List<dynamic>?)?.cast<String>() ?? [],
      etymology: json['etymology'] as String?,
      imageUrl: json['imageUrl'] as String?,
      synonyms: (json['synonyms'] as List<dynamic>?)?.cast<String>() ?? [],
      antonyms: (json['antonyms'] as List<dynamic>?)?.cast<String>() ?? [],
      difficulty: json['difficulty'] as String? ?? 'easy',
      gradeLevel: json['gradeLevel'] as int? ?? 1,
      phonicsPatterns:
          (json['phonicsPatterns'] as List<dynamic>?)?.cast<String>() ?? [],
      wordFamily: json['wordFamily'] as String?,
      prefix: json['prefix'] as String?,
      suffix: json['suffix'] as String?,
      rootWord: json['rootWord'] as String?,
      commonMisspellings:
          (json['commonMisspellings'] as List<dynamic>?)?.cast<String>() ?? [],
      mnemonicHint: json['mnemonicHint'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      syllableCount: json['syllableCount'] as int? ?? 1,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'phonetic': phonetic,
      'definition': definition,
      'meanings': meanings,
      'partOfSpeech': partOfSpeech,
      'exampleSentences': exampleSentences,
      'etymology': etymology,
      'imageUrl': imageUrl,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'difficulty': difficulty,
      'gradeLevel': gradeLevel,
      'phonicsPatterns': phonicsPatterns,
      'wordFamily': wordFamily,
      'prefix': prefix,
      'suffix': suffix,
      'rootWord': rootWord,
      'commonMisspellings': commonMisspellings,
      'mnemonicHint': mnemonicHint,
      'tags': tags,
      'syllableCount': syllableCount,
      'audioUrl': audioUrl,
    };
  }

  Word toEntity() {
    return Word(
      id: id,
      word: word,
      phonetic: phonetic,
      definition: definition,
      meanings: meanings,
      partOfSpeech: partOfSpeech,
      exampleSentences: exampleSentences,
      etymology: etymology,
      imageUrl: imageUrl,
      synonyms: synonyms,
      antonyms: antonyms,
      difficulty: difficulty,
      gradeLevel: gradeLevel,
      phonicsPatterns: phonicsPatterns,
      wordFamily: wordFamily,
      prefix: prefix,
      suffix: suffix,
      rootWord: rootWord,
      commonMisspellings: commonMisspellings,
      mnemonicHint: mnemonicHint,
      tags: tags,
      syllableCount: syllableCount,
      audioUrl: audioUrl,
    );
  }

  static WordModel fromEntity(Word entity) {
    return WordModel(
      id: entity.id,
      word: entity.word,
      phonetic: entity.phonetic,
      definition: entity.definition,
      meanings: entity.meanings,
      partOfSpeech: entity.partOfSpeech,
      exampleSentences: entity.exampleSentences,
      etymology: entity.etymology,
      imageUrl: entity.imageUrl,
      synonyms: entity.synonyms,
      antonyms: entity.antonyms,
      difficulty: entity.difficulty,
      gradeLevel: entity.gradeLevel,
      phonicsPatterns: entity.phonicsPatterns,
      wordFamily: entity.wordFamily,
      prefix: entity.prefix,
      suffix: entity.suffix,
      rootWord: entity.rootWord,
      commonMisspellings: entity.commonMisspellings,
      mnemonicHint: entity.mnemonicHint,
      tags: entity.tags,
      syllableCount: entity.syllableCount,
      audioUrl: entity.audioUrl,
    );
  }
}
