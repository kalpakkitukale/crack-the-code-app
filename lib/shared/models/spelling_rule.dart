class RuleExample {
  final String word;
  final String explanation;
  final String audioFile;

  const RuleExample({
    required this.word,
    required this.explanation,
    this.audioFile = '',
  });

  factory RuleExample.fromJson(Map<String, dynamic> json) {
    return RuleExample(
      word: json['word'] as String,
      explanation: json['explanation'] as String? ?? '',
      audioFile: json['audioFile'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'explanation': explanation,
        'audioFile': audioFile,
      };
}

class SpellingRule {
  final int ruleNum;
  final String category;
  final String title;
  final String shortDescription;
  final String fullExplanation;
  final List<RuleExample> examples;
  final List<String> yesWords;
  final List<String> noWords;
  final List<String> relatedPhonogramIds;

  const SpellingRule({
    required this.ruleNum,
    required this.category,
    required this.title,
    required this.shortDescription,
    this.fullExplanation = '',
    this.examples = const [],
    this.yesWords = const [],
    this.noWords = const [],
    this.relatedPhonogramIds = const [],
  });

  factory SpellingRule.fromJson(Map<String, dynamic> json) {
    return SpellingRule(
      ruleNum: json['ruleNum'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      fullExplanation: json['fullExplanation'] as String? ?? '',
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => RuleExample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      yesWords: (json['yesWords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      noWords: (json['noWords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      relatedPhonogramIds: (json['relatedPhonogramIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'ruleNum': ruleNum,
        'category': category,
        'title': title,
        'shortDescription': shortDescription,
        'fullExplanation': fullExplanation,
        'examples': examples.map((e) => e.toJson()).toList(),
        'yesWords': yesWords,
        'noWords': noWords,
        'relatedPhonogramIds': relatedPhonogramIds,
      };
}
