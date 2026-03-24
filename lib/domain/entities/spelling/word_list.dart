/// A curated list of words for a specific lesson or category
class WordList {
  final String id;
  final String name;
  final String description;
  final int gradeLevel;
  final String category; // phonics_pattern, sight_words, theme, spelling_bee, academic
  final String? phonicsPattern;
  final List<String> wordIds;
  final String difficulty; // easy, medium, hard
  final int estimatedMinutes;
  final int weekNumber;
  final String? iconName;

  const WordList({
    required this.id,
    required this.name,
    required this.description,
    required this.gradeLevel,
    required this.category,
    this.phonicsPattern,
    required this.wordIds,
    required this.difficulty,
    this.estimatedMinutes = 15,
    this.weekNumber = 1,
    this.iconName,
  });

  int get wordCount => wordIds.length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WordList && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WordList(id: $id, name: $name, words: $wordCount)';
}
