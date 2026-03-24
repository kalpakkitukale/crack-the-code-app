import 'dart:ui';

enum PhonogramCategory {
  singleVowel,
  singleConsonant,
  consonantTeam,
  vowelTeam,
  rControlled,
  ghCombo,
  special,
}

extension PhonogramCategoryX on PhonogramCategory {
  String get displayName => switch (this) {
        PhonogramCategory.singleVowel => 'Vowels',
        PhonogramCategory.singleConsonant => 'Consonants',
        PhonogramCategory.consonantTeam => 'Consonant Teams',
        PhonogramCategory.vowelTeam => 'Vowel Teams',
        PhonogramCategory.rControlled => 'R-Controlled',
        PhonogramCategory.ghCombo => 'GH Combos',
        PhonogramCategory.special => 'Special',
      };

  Color get color => switch (this) {
        PhonogramCategory.singleVowel => const Color(0xFFE57373),
        PhonogramCategory.singleConsonant => const Color(0xFF2196F3),
        PhonogramCategory.consonantTeam => const Color(0xFF4CAF50),
        PhonogramCategory.vowelTeam => const Color(0xFFFF9800),
        PhonogramCategory.rControlled => const Color(0xFF9C27B0),
        PhonogramCategory.ghCombo => const Color(0xFFFFD700),
        PhonogramCategory.special => const Color(0xFFBDBDBD),
      };

  Color get colorLight => color.withValues(alpha: 0.2);

  String get emoji => switch (this) {
        PhonogramCategory.singleVowel => '🔴',
        PhonogramCategory.singleConsonant => '🔵',
        PhonogramCategory.consonantTeam => '🟢',
        PhonogramCategory.vowelTeam => '🟠',
        PhonogramCategory.rControlled => '🟣',
        PhonogramCategory.ghCombo => '🟡',
        PhonogramCategory.special => '⚪',
      };

  int get tileCount => switch (this) {
        PhonogramCategory.singleVowel => 6,
        PhonogramCategory.singleConsonant => 20,
        PhonogramCategory.consonantTeam => 14,
        PhonogramCategory.vowelTeam => 18,
        PhonogramCategory.rControlled => 5,
        PhonogramCategory.ghCombo => 4,
        PhonogramCategory.special => 7,
      };

  static PhonogramCategory fromString(String value) {
    return PhonogramCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PhonogramCategory.special,
    );
  }
}
