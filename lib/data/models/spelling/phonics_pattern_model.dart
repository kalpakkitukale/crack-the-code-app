import 'package:streamshaala/domain/entities/spelling/phonics_pattern.dart';

class PhonicsPatternModel {
  final String id;
  final String name;
  final String pattern;
  final String description;
  final String rule;
  final List<String> exampleWords;
  final List<String> exceptions;
  final int gradeLevel;
  final String difficulty;
  final String? tip;

  const PhonicsPatternModel({
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

  factory PhonicsPatternModel.fromJson(Map<String, dynamic> json) {
    return PhonicsPatternModel(
      id: json['id'] as String,
      name: json['name'] as String,
      pattern: json['pattern'] as String,
      description: json['description'] as String? ?? '',
      rule: json['rule'] as String? ?? '',
      exampleWords:
          (json['exampleWords'] as List<dynamic>?)?.cast<String>() ?? [],
      exceptions:
          (json['exceptions'] as List<dynamic>?)?.cast<String>() ?? [],
      gradeLevel: json['gradeLevel'] as int? ?? 1,
      difficulty: json['difficulty'] as String? ?? 'easy',
      tip: json['tip'] as String?,
    );
  }

  PhonicsPattern toEntity() {
    return PhonicsPattern(
      id: id,
      name: name,
      pattern: pattern,
      description: description,
      rule: rule,
      exampleWords: exampleWords,
      exceptions: exceptions,
      gradeLevel: gradeLevel,
      difficulty: difficulty,
      tip: tip,
    );
  }
}
