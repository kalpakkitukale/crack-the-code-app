/// Data model representing a phonogram with its sounds, words, and metadata.
///
/// Each phonogram (e.g., SH, A, TH) has 1-4 sounds, each with example words
/// grouped by difficulty level. This model drives the PhonogramDetailCard UI.
library;

/// Age level tiers matching the card game variants
enum AgeLevel {
  /// Ages 2-4: My First Sounds — large visuals, minimal text
  tiny,

  /// Ages 5-7: Sound Explorer — simple words, guided reading
  starter,

  /// Ages 8-10: Code Breaker — full word grids, breakdowns
  explorer,

  /// Ages 11-14: Code Master — advanced words, etymology hints
  master,
}

/// Category of a phonogram — determines accent color throughout the UI
enum PhonogramCategory {
  vowel,
  consonant,
  team, // letter teams like SH, TH, CH
  advancedTeam, // multi-letter like OUGH, TION
}

/// A single sound that a phonogram can make
class PhonogramSound {
  final String id;

  /// IPA or simplified notation, e.g. "/sh/" or "/a/ as in apple"
  final String notation;

  /// Frequency label: "most common", "less common", "rare"
  final String frequency;

  /// Example words grouped by difficulty
  final List<PhonogramWord> easyWords;
  final List<PhonogramWord> moreWords;
  final List<PhonogramWord> challengeWords;

  /// Age-adaptive explanation of this sound
  final Map<AgeLevel, String> explanations;

  const PhonogramSound({
    required this.id,
    required this.notation,
    required this.frequency,
    this.easyWords = const [],
    this.moreWords = const [],
    this.challengeWords = const [],
    this.explanations = const {},
  });

  /// All words across difficulty levels
  List<PhonogramWord> get allWords => [
        ...easyWords,
        ...moreWords,
        ...challengeWords,
      ];
}

/// A word example within a phonogram sound
class PhonogramWord {
  final String word;
  final String emoji;

  /// The phonogram letters within this word (uppercase),
  /// used for highlighting. e.g., "SH" in "SHIP"
  final String phonogramLetters;

  /// Start index of the phonogram in the uppercase word
  final int highlightStart;

  /// Length of the phonogram highlight
  final int highlightLength;

  /// Phoneme breakdown tiles, e.g. ["SH", "I", "P"]
  final List<String> breakdown;

  /// Age-adaptive meaning
  final Map<AgeLevel, String> meanings;

  /// Example sentence
  final String? sentence;

  /// Spelling note/tip
  final String? spellingNote;

  /// Audio asset path for pronunciation
  final String? audioPath;

  const PhonogramWord({
    required this.word,
    required this.emoji,
    required this.phonogramLetters,
    required this.highlightStart,
    required this.highlightLength,
    this.breakdown = const [],
    this.meanings = const {},
    this.sentence,
    this.spellingNote,
    this.audioPath,
  });
}

/// The main phonogram entity
class Phonogram {
  final String id;

  /// Display text: "SH", "A", "TH", "OU", etc.
  final String letters;

  final PhonogramCategory category;

  /// Position in the 74-phonogram sequence (1-74)
  final int sequenceNumber;

  /// All sounds this phonogram can make (1-4)
  final List<PhonogramSound> sounds;

  /// Whether this phonogram has been unlocked by the user
  final bool isUnlocked;

  /// Mastery percentage (0.0 - 1.0)
  final double mastery;

  /// Audio asset path for the phonogram name
  final String? audioPath;

  const Phonogram({
    required this.id,
    required this.letters,
    required this.category,
    required this.sequenceNumber,
    this.sounds = const [],
    this.isUnlocked = true,
    this.mastery = 0.0,
    this.audioPath,
  });

  /// Number of distinct sounds
  int get soundCount => sounds.length;

  /// Whether this is a multi-sound phonogram
  bool get isMultiSound => sounds.length > 1;
}
