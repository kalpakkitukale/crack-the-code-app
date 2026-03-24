/// Represents a word in the spelling learning system
class Word {
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
  final String difficulty; // easy, medium, hard
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

  const Word({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Word && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Word(id: $id, word: $word, grade: $gradeLevel)';
}
