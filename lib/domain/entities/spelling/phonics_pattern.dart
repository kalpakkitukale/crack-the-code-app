/// Represents a phonics/spelling pattern rule
class PhonicsPattern {
  final String id;
  final String name;
  final String pattern; // e.g., "silent_e", "double_consonant"
  final String description;
  final String rule; // The actual spelling rule
  final List<String> exampleWords;
  final List<String> exceptions;
  final int gradeLevel;
  final String difficulty;
  final String? tip;

  const PhonicsPattern({
    required this.id,
    required this.name,
    required this.pattern,
    required this.description,
    required this.rule,
    this.exampleWords = const [],
    this.exceptions = const [],
    required this.gradeLevel,
    required this.difficulty,
    this.tip,
  });

  @override
  String toString() => 'PhonicsPattern(id: $id, name: $name)';
}
