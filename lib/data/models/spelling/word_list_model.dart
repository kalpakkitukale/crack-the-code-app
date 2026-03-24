import 'package:crack_the_code/domain/entities/spelling/word_list.dart';

class WordListModel {
  final String id;
  final String name;
  final String description;
  final int gradeLevel;
  final String category;
  final String? phonicsPattern;
  final List<String> wordIds;
  final String difficulty;
  final int estimatedMinutes;
  final int weekNumber;
  final String? iconName;

  const WordListModel({
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

  factory WordListModel.fromJson(Map<String, dynamic> json) {
    // Extract word IDs from embedded words array or from wordIds
    List<String> wordIds;
    if (json['words'] is List) {
      wordIds = (json['words'] as List<dynamic>)
          .map((w) => w is Map ? w['id'] as String : w as String)
          .toList();
    } else if (json['wordIds'] is List) {
      wordIds = (json['wordIds'] as List<dynamic>).cast<String>();
    } else {
      wordIds = [];
    }

    return WordListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      gradeLevel: json['gradeLevel'] as int? ?? 1,
      category: json['category'] as String? ?? 'phonics_pattern',
      phonicsPattern: json['phonicsPattern'] as String?,
      wordIds: wordIds,
      difficulty: json['difficulty'] as String? ?? 'easy',
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 15,
      weekNumber: json['weekNumber'] as int? ?? 1,
      iconName: json['iconName'] as String?,
    );
  }

  WordList toEntity() {
    return WordList(
      id: id,
      name: name,
      description: description,
      gradeLevel: gradeLevel,
      category: category,
      phonicsPattern: phonicsPattern,
      wordIds: wordIds,
      difficulty: difficulty,
      estimatedMinutes: estimatedMinutes,
      weekNumber: weekNumber,
      iconName: iconName,
    );
  }
}
