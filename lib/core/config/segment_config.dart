import 'package:flutter/foundation.dart';

// Segment Configuration for Crack the Code
//
// Single app with adaptive experience based on user's age level.
// The app detects age/level and adjusts UI, difficulty, and content.
//
// Usage:
//   SegmentConfig.initialize(AppSegment.crackTheCode);
//   final settings = SegmentConfig.settings;

/// App segment types — single product, adaptive experience
enum AppSegment {
  /// Crack the Code — English Spelling Learning for all ages (2-14+)
  crackTheCode,
}

/// UI complexity levels for different age groups
enum UIComplexity {
  /// Large fonts, big buttons, minimal options (for kids)
  simple,

  /// Balanced UI (for early teens)
  moderate,

  /// Full-featured UI (for older students)
  advanced,
}

/// Gamification intensity levels
enum GamificationIntensity {
  /// Heavy gamification - badges, celebrations, XP prominently displayed
  high,

  /// Moderate gamification - present but not overwhelming
  medium,

  /// Light gamification - subtle, not distracting from studies
  low,
}

/// Main configuration class for segment-specific settings
class SegmentConfig {
  SegmentConfig._();

  static AppSegment _current = AppSegment.crackTheCode;
  static bool _initialized = false;

  /// Initialize the segment configuration
  /// Must be called before runApp() in main function
  static void initialize(AppSegment segment) {
    _current = segment;
    _initialized = true;
    if (kDebugMode) {
      print('🎯 SegmentConfig initialized: ${segment.name}');
      print('   App Name: ${settings.appName}');
      print('   Grades: ${settings.minGrade}-${settings.maxGrade}');
      print('   UI Complexity: ${settings.uiComplexity.name}');
    }
  }

  /// Get the current segment
  static AppSegment get current {
    _assertInitialized();
    return _current;
  }

  /// Check if initialized
  static bool get isInitialized => _initialized;

  /// Get settings for current segment
  static SegmentSettings get settings {
    _assertInitialized();
    return _settingsMap[_current]!;
  }

  /// Get settings for a specific segment
  static SegmentSettings settingsFor(AppSegment segment) {
    return _settingsMap[segment]!;
  }

  /// Check if current segment is Crack the Code (always true now)
  static bool get isCrackTheCode => _current == AppSegment.crackTheCode;

  /// Check if current segment requires parental controls
  static bool get requiresParentalControls => settings.showParentalControls;

  /// Check if current segment shows streams (PCM/PCB/Commerce)
  static bool get showsStreams => settings.showStreams;

  static void _assertInitialized() {
    assert(
      _initialized,
      'SegmentConfig not initialized. Call SegmentConfig.initialize() in main().',
    );
  }

  /// Settings for Crack the Code — single adaptive app
  static const Map<AppSegment, SegmentSettings> _settingsMap = {
    // ═══════════════════════════════════════════════════════════════════════
    // CRACK THE CODE — English Spelling for All Ages
    // UI adapts based on user's selected age level at first launch
    // ═══════════════════════════════════════════════════════════════════════
    AppSegment.crackTheCode: SegmentSettings(
      // Identity
      appName: 'Crack the Code',
      appDescription: 'The Hidden Rules That Make English Easy',
      segmentId: 'crackthecode',

      // Age Range (all ages)
      minGrade: 1,
      maxGrade: 14,
      gradePrefix: 'Level',

      // Content
      contentPath: 'assets/data/english_spelling.json',
      showStreams: false,
      showBoards: false,
      defaultBoardId: 'english_spelling',

      // UI Configuration — adaptive, starts kid-friendly
      uiComplexity: UIComplexity.simple,
      fontScale: 1.15,
      touchTargetScale: 1.1,
      borderRadiusScale: 1.3,
      iconScale: 1.1,

      // Navigation
      bottomNavItemCount: 4, // Home, Explore, Practice, Progress
      showSearchInBottomNav: false,
      showLibraryInBottomNav: false,
      showPracticeInBottomNav: true,
      simplifiedBrowseHierarchy: true,

      // Features
      showParentalControls: true,
      showScreenTimeControls: true,
      showDailyChallenge: true,
      showCharacterAvatar: true,
      showDetailedStats: true,
      showConceptCharts: false,

      // Gamification — high for engagement
      gamificationIntensity: GamificationIntensity.high,
      showXpProminently: true,
      showBadgesOnHome: true,
      showStreakBanner: true,
      celebrationAnimationDuration: 2500,
      xpMultiplier: 1.5,

      // Quiz Settings
      defaultQuizQuestionCount: 10,
      maxQuizQuestionCount: 20,
      defaultQuizTimeSeconds: 600, // 10 minutes
      quizPassingScore: 0.7,
      showQuizTimer: true,
      timerDisplayFormat: TimerDisplayFormat.friendly,
      showHintsProminently: true,
      maxHintsPerQuestion: 2,
      simplifiedQuizResults: true,

      // Video Settings
      defaultVideoSpeed: 1.0,
      maxVideoSpeed: 1.5,
      showRelatedVideosFromSameGrade: true,

      // Theme — Navy + Gold (Crack the Code brand)
      useBrightColors: true,
      primaryColorHex: '#0a0618', // Navy
      accentColorHex: '#FFD700', // Gold

      // Onboarding
      onboardingPageCount: 4,
      showBoardSelection: false,
      showStreamSelection: false,
      showGradeSelection: true, // Age level selection
      onboardingButtonText: "Let's Crack the Code!",

      // Database
      databaseName: 'crackthecode.db',

      // Learning Materials
      showQASection: false,
      enableRichTextNotes: false,
      showFlashcardAnimations: true,
      showGlossaryAudio: true,
      showGlossaryImages: true,
      summaryStyle: 'visual',
      enableSpacedRepetition: true,

      // Spelling features
      showWordOfTheDay: true,
      showSpellingBee: true,
      showPhonicsPatterns: true,
      showWordJournal: true,
      enableDictation: true,
      enableSpeechRecognition: false,
      enableHandwriting: false,
      enableWritingExercises: false,
      dailyWordGoal: 5,
      spellingBeeRounds: 5,
      showEtymology: false,
      showMnemonics: true,
    ),
  };
}

/// Timer display format for quizzes
enum TimerDisplayFormat {
  /// Shows "5:23" format
  standard,

  /// Shows "5 minutes left" format (kid-friendly)
  friendly,
}

/// Settings for a specific segment
class SegmentSettings {
  // ═══════════════════════════════════════════════════════════════════════
  // Identity
  // ═══════════════════════════════════════════════════════════════════════
  final String appName;
  final String appDescription;
  final String segmentId;

  // ═══════════════════════════════════════════════════════════════════════
  // Grade Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final int minGrade;
  final int maxGrade;
  final String gradePrefix;

  // ═══════════════════════════════════════════════════════════════════════
  // Content Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final String contentPath;
  final bool showStreams;
  final bool showBoards;
  final String defaultBoardId;

  // ═══════════════════════════════════════════════════════════════════════
  // UI Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final UIComplexity uiComplexity;
  final double fontScale;
  final double touchTargetScale;
  final double borderRadiusScale;
  final double iconScale;

  // ═══════════════════════════════════════════════════════════════════════
  // Navigation Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final int bottomNavItemCount;
  final bool showSearchInBottomNav;
  final bool showLibraryInBottomNav;
  final bool showPracticeInBottomNav;
  final bool simplifiedBrowseHierarchy;

  // ═══════════════════════════════════════════════════════════════════════
  // Feature Flags
  // ═══════════════════════════════════════════════════════════════════════
  final bool showParentalControls;
  final bool showScreenTimeControls;
  final bool showDailyChallenge;
  final bool showCharacterAvatar;
  final bool showDetailedStats;
  final bool showConceptCharts;

  // ═══════════════════════════════════════════════════════════════════════
  // Gamification Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final GamificationIntensity gamificationIntensity;
  final bool showXpProminently;
  final bool showBadgesOnHome;
  final bool showStreakBanner;
  final int celebrationAnimationDuration;
  final double xpMultiplier;

  // ═══════════════════════════════════════════════════════════════════════
  // Quiz Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final int defaultQuizQuestionCount;
  final int maxQuizQuestionCount;
  final int defaultQuizTimeSeconds;
  final double quizPassingScore;
  final bool showQuizTimer;
  final TimerDisplayFormat timerDisplayFormat;
  final bool showHintsProminently;
  final int maxHintsPerQuestion;
  final bool simplifiedQuizResults;

  // ═══════════════════════════════════════════════════════════════════════
  // Video Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final double defaultVideoSpeed;
  final double maxVideoSpeed;
  final bool showRelatedVideosFromSameGrade;

  // ═══════════════════════════════════════════════════════════════════════
  // Theme Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final bool useBrightColors;
  final String primaryColorHex;
  final String accentColorHex;

  // ═══════════════════════════════════════════════════════════════════════
  // Onboarding Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final int onboardingPageCount;
  final bool showBoardSelection;
  final bool showStreamSelection;
  final bool showGradeSelection;
  final String onboardingButtonText;

  // ═══════════════════════════════════════════════════════════════════════
  // Database Configuration
  // ═══════════════════════════════════════════════════════════════════════
  final String databaseName;

  // ═══════════════════════════════════════════════════════════════════════
  // Learning Materials Configuration
  // ═══════════════════════════════════════════════════════════════════════
  /// Whether to show Q&A section in video player
  final bool showQASection;
  /// Whether to enable rich text in notes (formatting, export)
  final bool enableRichTextNotes;
  /// Whether to show animations in flashcards
  final bool showFlashcardAnimations;
  /// Whether to show audio pronunciation in glossary
  final bool showGlossaryAudio;
  /// Whether to show images in glossary terms
  final bool showGlossaryImages;
  /// Style of summaries: 'visual' | 'standard' | 'exam' | 'detailed'
  final String summaryStyle;
  /// Whether to enable spaced repetition for flashcards
  final bool enableSpacedRepetition;

  // ═══════════════════════════════════════════════════════════════════════
  // Spelling Configuration
  // ═══════════════════════════════════════════════════════════════════════
  /// Whether to show Word of the Day feature
  final bool showWordOfTheDay;
  /// Whether to show Spelling Bee challenges
  final bool showSpellingBee;
  /// Whether to show Phonics Patterns lessons
  final bool showPhonicsPatterns;
  /// Whether to show Word Journal
  final bool showWordJournal;
  /// Whether to enable dictation practice
  final bool enableDictation;
  /// Whether to enable speech recognition (Future: speaking)
  final bool enableSpeechRecognition;
  /// Whether to enable handwriting practice (Future: writing)
  final bool enableHandwriting;
  /// Whether to enable writing exercises (Future: writing)
  final bool enableWritingExercises;
  /// Daily word learning goal
  final int dailyWordGoal;
  /// Number of rounds in Spelling Bee
  final int spellingBeeRounds;
  /// Whether to show word etymology
  final bool showEtymology;
  /// Whether to show mnemonic hints
  final bool showMnemonics;

  const SegmentSettings({
    // Identity
    required this.appName,
    required this.appDescription,
    required this.segmentId,
    // Grade
    required this.minGrade,
    required this.maxGrade,
    required this.gradePrefix,
    // Content
    required this.contentPath,
    required this.showStreams,
    required this.showBoards,
    required this.defaultBoardId,
    // UI
    required this.uiComplexity,
    required this.fontScale,
    required this.touchTargetScale,
    required this.borderRadiusScale,
    required this.iconScale,
    // Navigation
    required this.bottomNavItemCount,
    required this.showSearchInBottomNav,
    required this.showLibraryInBottomNav,
    required this.showPracticeInBottomNav,
    required this.simplifiedBrowseHierarchy,
    // Features
    required this.showParentalControls,
    required this.showScreenTimeControls,
    required this.showDailyChallenge,
    required this.showCharacterAvatar,
    required this.showDetailedStats,
    required this.showConceptCharts,
    // Gamification
    required this.gamificationIntensity,
    required this.showXpProminently,
    required this.showBadgesOnHome,
    required this.showStreakBanner,
    required this.celebrationAnimationDuration,
    required this.xpMultiplier,
    // Quiz
    required this.defaultQuizQuestionCount,
    required this.maxQuizQuestionCount,
    required this.defaultQuizTimeSeconds,
    required this.quizPassingScore,
    required this.showQuizTimer,
    required this.timerDisplayFormat,
    required this.showHintsProminently,
    required this.maxHintsPerQuestion,
    required this.simplifiedQuizResults,
    // Video
    required this.defaultVideoSpeed,
    required this.maxVideoSpeed,
    required this.showRelatedVideosFromSameGrade,
    // Theme
    required this.useBrightColors,
    required this.primaryColorHex,
    required this.accentColorHex,
    // Onboarding
    required this.onboardingPageCount,
    required this.showBoardSelection,
    required this.showStreamSelection,
    required this.showGradeSelection,
    required this.onboardingButtonText,
    // Database
    required this.databaseName,
    // Learning Materials
    this.showQASection = true,
    this.enableRichTextNotes = true,
    this.showFlashcardAnimations = false,
    this.showGlossaryAudio = false,
    this.showGlossaryImages = false,
    this.summaryStyle = 'standard',
    this.enableSpacedRepetition = false,
    // Spelling Configuration
    this.showWordOfTheDay = false,
    this.showSpellingBee = false,
    this.showPhonicsPatterns = false,
    this.showWordJournal = false,
    this.enableDictation = false,
    this.enableSpeechRecognition = false,
    this.enableHandwriting = false,
    this.enableWritingExercises = false,
    this.dailyWordGoal = 5,
    this.spellingBeeRounds = 5,
    this.showEtymology = false,
    this.showMnemonics = false,
  });

  /// Get list of grades for this segment
  List<int> get grades =>
      List.generate(maxGrade - minGrade + 1, (i) => minGrade + i);

  /// Get grade display name (e.g., "Grade 4" or "Class 12")
  String gradeDisplayName(int grade) => '$gradePrefix $grade';

  /// Check if a grade is within this segment's range
  bool isGradeInRange(int grade) => grade >= minGrade && grade <= maxGrade;

  /// Get minimum touch target size based on scale
  double get minTouchTarget => 48.0 * touchTargetScale;

  /// Get default border radius based on scale
  double get defaultBorderRadius => 12.0 * borderRadiusScale;

  /// Get card border radius based on scale
  double get cardBorderRadius => 16.0 * borderRadiusScale;

  /// Check if this is a kid-friendly segment
  bool get isKidFriendly => uiComplexity == UIComplexity.simple;

  /// Check if gamification should be prominent
  bool get isGamificationProminent =>
      gamificationIntensity == GamificationIntensity.high;

  @override
  String toString() {
    return 'SegmentSettings(appName: $appName, grades: $minGrade-$maxGrade)';
  }
}
