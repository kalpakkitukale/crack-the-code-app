import 'package:flutter/foundation.dart';

// Segment Configuration for StreamShaala Multi-Variant Architecture
//
// This is the SINGLE SOURCE OF TRUTH for all segment-specific behavior.
// Each app variant (Junior, Middle, PreBoard, Senior) has its own settings
// defined here, controlling UI, features, content, and behavior.
//
// Usage:
//   // In main_junior.dart
//   SegmentConfig.initialize(AppSegment.junior);
//
//   // Anywhere in the app
//   final settings = SegmentConfig.settings;
//   if (settings.showParentalControls) { ... }

/// App segment types
enum AppSegment {
  /// Grades 1-7 (Elementary) - Ages 6-12
  junior,

  /// Grades 7-9 (Middle School) - Ages 12-14
  middle,

  /// Grade 10 (Board Exam Prep) - Age 15
  preboard,

  /// Grades 11-12 (Senior Secondary) - Ages 16-18
  senior,

  /// English Spelling Learning - Ages 5-14
  spelling,
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

  static AppSegment _current = AppSegment.senior;
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

  /// Check if current segment is Junior
  static bool get isJunior => _current == AppSegment.junior;

  /// Check if current segment is Middle
  static bool get isMiddle => _current == AppSegment.middle;

  /// Check if current segment is PreBoard
  static bool get isPreBoard => _current == AppSegment.preboard;

  /// Check if current segment is Senior
  static bool get isSenior => _current == AppSegment.senior;

  /// Check if current segment is Spelling
  static bool get isSpelling => _current == AppSegment.spelling;

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

  /// Settings for each segment
  static const Map<AppSegment, SegmentSettings> _settingsMap = {
    // ═══════════════════════════════════════════════════════════════════════
    // JUNIOR (Grades 1-7) - Elementary Students
    // ═══════════════════════════════════════════════════════════════════════
    AppSegment.junior: SegmentSettings(
      // Identity
      appName: 'StreamShaala Junior',
      appDescription: 'Fun learning for young minds',
      segmentId: 'junior',

      // Grade Range
      minGrade: 1,
      maxGrade: 7,
      gradePrefix: 'Grade', // "Grade 4" vs "Class 12"

      // Content
      contentPath: 'assets/data/boards/cbse_elementary.json',
      showStreams: false, // No PCM/PCB/Commerce for elementary
      showBoards: false, // Assume CBSE for now
      defaultBoardId: 'cbse_elementary',

      // UI Configuration
      uiComplexity: UIComplexity.simple,
      fontScale: 1.25, // 25% larger text
      touchTargetScale: 1.2, // 20% larger buttons
      borderRadiusScale: 1.5, // Rounder corners (friendlier)
      iconScale: 1.2, // Larger icons

      // Navigation
      bottomNavItemCount: 3, // Home, Search, Progress
      showSearchInBottomNav: true,
      showLibraryInBottomNav: false,
      showPracticeInBottomNav: false,
      simplifiedBrowseHierarchy: true, // Subject → Chapter → Video

      // Features
      showParentalControls: true,
      showScreenTimeControls: true,
      showDailyChallenge: true,
      showCharacterAvatar: true,
      showDetailedStats: false, // Too complex for kids
      showConceptCharts: false, // Too complex for kids

      // Gamification
      gamificationIntensity: GamificationIntensity.high,
      showXpProminently: true,
      showBadgesOnHome: true,
      showStreakBanner: true,
      celebrationAnimationDuration: 2500, // Longer celebrations
      xpMultiplier: 1.5, // More XP to feel rewarding

      // Quiz Settings
      defaultQuizQuestionCount: 5,
      maxQuizQuestionCount: 10,
      defaultQuizTimeSeconds: 600, // 10 minutes
      quizPassingScore: 0.6, // 60% to pass
      showQuizTimer: true,
      timerDisplayFormat: TimerDisplayFormat.friendly, // "5 minutes left"
      showHintsProminently: true,
      maxHintsPerQuestion: 2,
      simplifiedQuizResults: true, // Stars instead of charts

      // Video Settings
      defaultVideoSpeed: 1.0,
      maxVideoSpeed: 1.5, // Limit max speed for kids
      showRelatedVideosFromSameGrade: true,

      // Theme
      useBrightColors: true,
      primaryColorHex: '#4A90E2', // Friendly blue
      accentColorHex: '#7ED321', // Cheerful green

      // Onboarding
      onboardingPageCount: 3,
      showBoardSelection: false,
      showStreamSelection: false,
      showGradeSelection: true,
      onboardingButtonText: "Let's Go!",

      // Database
      databaseName: 'streamshaala_junior.db',

      // Learning Materials (Junior-specific)
      showQASection: false, // Q&A hidden for young learners
      enableRichTextNotes: false, // Simple text notes only
      showFlashcardAnimations: true, // Fun animations for engagement
      showGlossaryAudio: true, // Audio pronunciation for vocabulary
      showGlossaryImages: true, // Visual aids for young learners
      summaryStyle: 'visual', // Visual bullets with icons
      enableSpacedRepetition: false, // Keep it simple
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // MIDDLE (Grades 7-9) - Middle School Students
    // ═══════════════════════════════════════════════════════════════════════
    AppSegment.middle: SegmentSettings(
      appName: 'StreamShaala',
      appDescription: 'Smart learning for growing minds',
      segmentId: 'middle',

      minGrade: 7,
      maxGrade: 9,
      gradePrefix: 'Grade',

      contentPath: 'assets/data/boards/cbse_middle.json',
      showStreams: false,
      showBoards: false,
      defaultBoardId: 'cbse',

      uiComplexity: UIComplexity.moderate,
      fontScale: 1.15,
      touchTargetScale: 1.1,
      borderRadiusScale: 1.25,
      iconScale: 1.1,

      bottomNavItemCount: 4, // Home, Search, Library, Progress
      showSearchInBottomNav: true,
      showLibraryInBottomNav: true,
      showPracticeInBottomNav: false,
      simplifiedBrowseHierarchy: true,

      showParentalControls: false,
      showScreenTimeControls: false,
      showDailyChallenge: true,
      showCharacterAvatar: false,
      showDetailedStats: true,
      showConceptCharts: true,

      gamificationIntensity: GamificationIntensity.medium,
      showXpProminently: true,
      showBadgesOnHome: true,
      showStreakBanner: true,
      celebrationAnimationDuration: 2000,
      xpMultiplier: 1.25,

      defaultQuizQuestionCount: 10,
      maxQuizQuestionCount: 15,
      defaultQuizTimeSeconds: 900, // 15 minutes
      quizPassingScore: 0.65,
      showQuizTimer: true,
      timerDisplayFormat: TimerDisplayFormat.standard, // "15:00"
      showHintsProminently: true,
      maxHintsPerQuestion: 2,
      simplifiedQuizResults: false,

      defaultVideoSpeed: 1.0,
      maxVideoSpeed: 1.75,
      showRelatedVideosFromSameGrade: true,

      useBrightColors: false,
      primaryColorHex: '#2196F3',
      accentColorHex: '#4CAF50',

      onboardingPageCount: 4,
      showBoardSelection: false,
      showStreamSelection: false,
      showGradeSelection: true,
      onboardingButtonText: 'Get Started',

      databaseName: 'streamshaala_middle.db',

      // Learning Materials (Middle-specific)
      showQASection: true, // Read-only Q&A access
      enableRichTextNotes: false, // Basic formatting
      showFlashcardAnimations: false, // Standard flashcards
      showGlossaryAudio: false, // Standard glossary
      showGlossaryImages: false, // Standard glossary
      summaryStyle: 'standard', // Standard bullet points
      enableSpacedRepetition: false, // Not yet
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // PREBOARD (Grade 10) - Board Exam Preparation
    // ═══════════════════════════════════════════════════════════════════════
    AppSegment.preboard: SegmentSettings(
      appName: 'StreamShaala Board Prep',
      appDescription: 'Excel in your board exams',
      segmentId: 'preboard',

      minGrade: 10,
      maxGrade: 10,
      gradePrefix: 'Class',

      contentPath: 'assets/data/boards/cbse_grade10.json',
      showStreams: false,
      showBoards: true, // CBSE, ICSE options
      defaultBoardId: 'cbse',

      uiComplexity: UIComplexity.advanced,
      fontScale: 1.0,
      touchTargetScale: 1.0,
      borderRadiusScale: 1.0,
      iconScale: 1.0,

      bottomNavItemCount: 4, // Home, Search, Practice, Progress
      showSearchInBottomNav: true,
      showLibraryInBottomNav: false,
      showPracticeInBottomNav: true,
      simplifiedBrowseHierarchy: false,

      showParentalControls: false,
      showScreenTimeControls: false,
      showDailyChallenge: true,
      showCharacterAvatar: false,
      showDetailedStats: true,
      showConceptCharts: true,

      gamificationIntensity: GamificationIntensity.low,
      showXpProminently: false,
      showBadgesOnHome: false,
      showStreakBanner: true,
      celebrationAnimationDuration: 1500,
      xpMultiplier: 1.0,

      defaultQuizQuestionCount: 20,
      maxQuizQuestionCount: 30,
      defaultQuizTimeSeconds: 1800, // 30 minutes
      quizPassingScore: 0.7,
      showQuizTimer: true,
      timerDisplayFormat: TimerDisplayFormat.standard,
      showHintsProminently: false,
      maxHintsPerQuestion: 1,
      simplifiedQuizResults: false,

      defaultVideoSpeed: 1.0,
      maxVideoSpeed: 2.0,
      showRelatedVideosFromSameGrade: true,

      useBrightColors: false,
      primaryColorHex: '#1976D2',
      accentColorHex: '#388E3C',

      onboardingPageCount: 4,
      showBoardSelection: true,
      showStreamSelection: false,
      showGradeSelection: false, // Only Grade 10
      onboardingButtonText: 'Start Preparing',

      databaseName: 'streamshaala_preboard.db',

      // Learning Materials (PreBoard-specific)
      showQASection: true, // Full Q&A access
      enableRichTextNotes: true, // Rich text with export
      showFlashcardAnimations: false, // Exam-focused flashcards
      showGlossaryAudio: false, // Standard glossary
      showGlossaryImages: false, // Standard glossary
      summaryStyle: 'exam', // Exam-focused summaries
      enableSpacedRepetition: true, // Help retention for exams
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SENIOR (Grades 11-12) - Current Production App
    // ═══════════════════════════════════════════════════════════════════════
    AppSegment.senior: SegmentSettings(
      appName: 'StreamShaala',
      appDescription:
          'Multi-platform educational video aggregator for Indian students',
      segmentId: 'senior',

      minGrade: 11,
      maxGrade: 12,
      gradePrefix: 'Class',

      contentPath: 'assets/data/boards/cbse.json',
      showStreams: true, // PCM, PCB, Commerce, Arts
      showBoards: true,
      defaultBoardId: 'cbse',

      uiComplexity: UIComplexity.advanced,
      fontScale: 1.0,
      touchTargetScale: 1.0,
      borderRadiusScale: 1.0,
      iconScale: 1.0,

      bottomNavItemCount: 4, // Home, Search, Library, Progress
      showSearchInBottomNav: true,
      showLibraryInBottomNav: true,
      showPracticeInBottomNav: false,
      simplifiedBrowseHierarchy: false,

      showParentalControls: false,
      showScreenTimeControls: false,
      showDailyChallenge: true,
      showCharacterAvatar: false,
      showDetailedStats: true,
      showConceptCharts: true,

      gamificationIntensity: GamificationIntensity.low,
      showXpProminently: false,
      showBadgesOnHome: false,
      showStreakBanner: true,
      celebrationAnimationDuration: 1500,
      xpMultiplier: 1.0,

      defaultQuizQuestionCount: 20,
      maxQuizQuestionCount: 30,
      defaultQuizTimeSeconds: 1500, // 25 minutes
      quizPassingScore: 0.7,
      showQuizTimer: true,
      timerDisplayFormat: TimerDisplayFormat.standard,
      showHintsProminently: false,
      maxHintsPerQuestion: 1,
      simplifiedQuizResults: false,

      defaultVideoSpeed: 1.0,
      maxVideoSpeed: 2.0,
      showRelatedVideosFromSameGrade: false, // Show all related

      useBrightColors: false,
      primaryColorHex: '#2196F3',
      accentColorHex: '#4CAF50',

      onboardingPageCount: 4,
      showBoardSelection: true,
      showStreamSelection: true,
      showGradeSelection: true,
      onboardingButtonText: 'Get Started',

      databaseName: 'streamshaala.db', // Keep existing for migration

      // Learning Materials (Senior-specific)
      showQASection: true, // Full Q&A access
      enableRichTextNotes: true, // Full rich text with export
      showFlashcardAnimations: false, // No animations, focus on content
      showGlossaryAudio: false, // Standard glossary
      showGlossaryImages: false, // Standard glossary, technical terms
      summaryStyle: 'detailed', // Detailed summaries with formulas
      enableSpacedRepetition: true, // SM-2 algorithm for retention
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SPELLING (Grades 1-8) - English Spelling Learning
    // ═══════════════════════════════════════════════════════════════════════
    AppSegment.spelling: SegmentSettings(
      // Identity
      appName: 'SpellShaala',
      appDescription: 'Master English spelling with fun activities',
      segmentId: 'spelling',

      // Grade Range
      minGrade: 1,
      maxGrade: 8,
      gradePrefix: 'Grade',

      // Content
      contentPath: 'assets/data/boards/english_spelling.json',
      showStreams: false,
      showBoards: false,
      defaultBoardId: 'english_spelling',

      // UI Configuration
      uiComplexity: UIComplexity.simple,
      fontScale: 1.2,
      touchTargetScale: 1.15,
      borderRadiusScale: 1.3,
      iconScale: 1.15,

      // Navigation
      bottomNavItemCount: 4, // Home, Explorer, Practice, Progress
      showSearchInBottomNav: false,
      showLibraryInBottomNav: false,
      showPracticeInBottomNav: true,
      simplifiedBrowseHierarchy: true,

      // Features
      showParentalControls: true,
      showScreenTimeControls: true,
      showDailyChallenge: true,
      showCharacterAvatar: true,
      showDetailedStats: false,
      showConceptCharts: false,

      // Gamification
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

      // Theme
      useBrightColors: true,
      primaryColorHex: '#FF6B35', // Warm orange - energetic
      accentColorHex: '#2EC4B6', // Teal - calming contrast

      // Onboarding
      onboardingPageCount: 4,
      showBoardSelection: false,
      showStreamSelection: false,
      showGradeSelection: true,
      onboardingButtonText: "Let's Spell!",

      // Database
      databaseName: 'spellshaala.db',

      // Learning Materials
      showQASection: false,
      enableRichTextNotes: false,
      showFlashcardAnimations: true,
      showGlossaryAudio: true,
      showGlossaryImages: true,
      summaryStyle: 'visual',
      enableSpacedRepetition: true,

      // Spelling-specific
      showWordOfTheDay: true,
      showSpellingBee: true,
      showPhonicsPatterns: true,
      showWordJournal: true,
      enableDictation: true,
      enableSpeechRecognition: false, // Future
      enableHandwriting: false, // Future
      enableWritingExercises: false, // Future
      dailyWordGoal: 5,
      spellingBeeRounds: 5,
      showEtymology: false, // Too complex for young learners by default
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
