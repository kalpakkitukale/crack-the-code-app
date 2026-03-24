// App Store Configuration
// Contains metadata for Play Store and App Store listings for each segment
// Used for generating store listings and in-app "About" screens

import 'package:streamshaala/core/config/segment_config.dart';

/// App Store metadata configuration per segment
class AppStoreConfig {
  /// Get configuration for current segment
  static AppStoreMetadata get current {
    switch (SegmentConfig.current) {
      case AppSegment.junior:
        return junior;
      case AppSegment.middle:
        return middle;
      case AppSegment.preboard:
        return preboard;
      case AppSegment.senior:
        return senior;
      case AppSegment.spelling:
        return spelling;
    }
  }

  /// Junior segment (Grades 1-7)
  static const junior = AppStoreMetadata(
    // Basic info
    appName: 'StreamShaala Junior',
    shortDescription: 'Fun learning app for Grades 1-7',
    fullDescription: '''
StreamShaala Junior makes learning fun and engaging for young students in Grades 1-7!

KEY FEATURES:
- Watch fun video lessons on Math, Science, English, and more
- Take quizzes to test what you learned
- Earn stars and badges as you progress
- Track your learning streak
- Parents can monitor progress and set screen time limits

SUBJECTS COVERED:
- Mathematics
- Science
- English
- Environmental Studies (EVS)
- Hindi
- Social Studies

WHY KIDS LOVE IT:
- Colorful, kid-friendly design
- Fun animations and celebrations
- Easy-to-use interface
- Rewards for learning

WHY PARENTS TRUST IT:
- Age-appropriate content
- Parental controls built-in
- Progress reports
- Screen time management
- Safe, ad-free experience

Download now and make learning an adventure!
''',

    // Store categorization
    primaryCategory: 'Education',
    secondaryCategory: 'Kids',
    contentRating: ContentRating.everyone,
    targetAgeMin: 6,
    targetAgeMax: 12,

    // Package identifiers
    androidPackageName: 'com.streamshaala.junior',
    iosBundleId: 'com.streamshaala.junior',

    // Contact info
    developerName: 'StreamShaala Education',
    developerEmail: 'support@streamshaala.com',
    privacyPolicyUrl: 'https://streamshaala.com/privacy',
    termsOfServiceUrl: 'https://streamshaala.com/terms',
    supportUrl: 'https://streamshaala.com/support',

    // Keywords for ASO
    keywords: [
      'kids learning',
      'education app',
      'CBSE learning',
      'grade 1 learning',
      'grade 2 learning',
      'grade 3 learning',
      'grade 4 learning',
      'grade 5 learning',
      'grade 6 learning',
      'grade 7 learning',
      'math for kids',
      'science for kids',
      'English learning',
      'educational videos',
      'quiz app for kids',
      'parental controls',
      'safe learning app',
    ],

    // Screenshots requirements
    screenshotGuidelines: ScreenshotGuidelines(
      phonePortraitCount: 5,
      tabletPortraitCount: 3,
      requiredScenes: [
        'Home screen with subjects',
        'Video player with kid-friendly controls',
        'Quiz interface',
        'Badge/achievement display',
        'Parental controls screen',
      ],
    ),

    // Localization
    supportedLanguages: ['en', 'hi'],
    defaultLanguage: 'en',
  );

  /// Middle segment (Grades 7-9)
  static const middle = AppStoreMetadata(
    appName: 'StreamShaala',
    shortDescription: 'Learn smarter with video lessons for Grades 7-9',
    fullDescription: '''
StreamShaala helps middle school students master their subjects with engaging video lessons and practice quizzes.

KEY FEATURES:
- Comprehensive video lessons aligned to CBSE curriculum
- Topic-wise practice quizzes
- Track your progress across subjects
- Bookmark videos for revision
- Dark mode for comfortable studying

SUBJECTS COVERED:
- Mathematics
- Science (Physics, Chemistry, Biology)
- Social Science (History, Geography, Civics)
- English
- Hindi

LEARNING FEATURES:
- Chapter-wise organized content
- Multiple difficulty levels
- Detailed explanations
- Progress tracking
- Offline notes (coming soon)

Perfect for Grades 7, 8, and 9 students preparing for school exams!

Download now and start learning smarter.
''',

    primaryCategory: 'Education',
    secondaryCategory: null,
    contentRating: ContentRating.everyone,
    targetAgeMin: 12,
    targetAgeMax: 15,

    androidPackageName: 'com.streamshaala.middle',
    iosBundleId: 'com.streamshaala.middle',

    developerName: 'StreamShaala Education',
    developerEmail: 'support@streamshaala.com',
    privacyPolicyUrl: 'https://streamshaala.com/privacy',
    termsOfServiceUrl: 'https://streamshaala.com/terms',
    supportUrl: 'https://streamshaala.com/support',

    keywords: [
      'CBSE learning',
      'grade 8 learning',
      'grade 9 learning',
      'middle school',
      'video lessons',
      'science learning',
      'math learning',
      'education app',
      'study app',
      'exam preparation',
    ],

    screenshotGuidelines: ScreenshotGuidelines(
      phonePortraitCount: 5,
      tabletPortraitCount: 3,
      requiredScenes: [
        'Subject selection screen',
        'Video lesson player',
        'Quiz interface',
        'Progress dashboard',
        'Chapter list view',
      ],
    ),

    supportedLanguages: ['en', 'hi'],
    defaultLanguage: 'en',
  );

  /// Pre-Board segment (Grade 10)
  static const preboard = AppStoreMetadata(
    appName: 'StreamShaala Board Prep',
    shortDescription: 'Ace your Grade 10 board exams',
    fullDescription: '''
StreamShaala Board Prep is your ultimate companion for Grade 10 board exam preparation!

EXAM-FOCUSED FEATURES:
- Complete CBSE Grade 10 syllabus coverage
- Chapter-wise video explanations
- Previous year question practice
- Topic-wise mock tests
- Performance analytics
- Weak topic identification

SUBJECTS:
- Mathematics
- Science (Physics, Chemistry, Biology)
- Social Science
- English
- Hindi

BOARD EXAM PREPARATION:
- Important questions highlighted
- Exam tips and strategies
- Time management guidance
- Last-minute revision notes
- Formula sheets

PRACTICE & TEST:
- Chapter-wise quizzes
- Full-length mock tests
- Instant results and analysis
- Compare with toppers

Get ready to ace your board exams with StreamShaala Board Prep!
''',

    primaryCategory: 'Education',
    secondaryCategory: null,
    contentRating: ContentRating.everyone,
    targetAgeMin: 15,
    targetAgeMax: 16,

    androidPackageName: 'com.streamshaala.preboard',
    iosBundleId: 'com.streamshaala.preboard',

    developerName: 'StreamShaala Education',
    developerEmail: 'support@streamshaala.com',
    privacyPolicyUrl: 'https://streamshaala.com/privacy',
    termsOfServiceUrl: 'https://streamshaala.com/terms',
    supportUrl: 'https://streamshaala.com/support',

    keywords: [
      'board exam preparation',
      'CBSE class 10',
      'grade 10 exam',
      'board exam app',
      'mock test',
      'previous year papers',
      '10th class',
      'exam prep',
      'CBSE preparation',
      'science class 10',
      'math class 10',
    ],

    screenshotGuidelines: ScreenshotGuidelines(
      phonePortraitCount: 5,
      tabletPortraitCount: 3,
      requiredScenes: [
        'Exam dashboard with countdown',
        'Mock test interface',
        'Performance analytics',
        'Video lesson player',
        'Previous year questions',
      ],
    ),

    supportedLanguages: ['en', 'hi'],
    defaultLanguage: 'en',
  );

  /// Senior segment (Grades 11-12)
  static const senior = AppStoreMetadata(
    appName: 'StreamShaala',
    shortDescription: 'Master Grades 11-12 with expert video lessons',
    fullDescription: '''
StreamShaala is the comprehensive learning platform for Grades 11-12 students preparing for board exams and competitive entrance tests.

COMPREHENSIVE COVERAGE:
- Complete CBSE Class 11 & 12 syllabus
- Science stream: Physics, Chemistry, Biology, Mathematics
- Commerce stream: Accountancy, Business Studies, Economics
- Detailed video explanations by expert teachers

ADVANCED FEATURES:
- Personalized learning recommendations
- Gap analysis and concept mastery tracking
- Spaced repetition for better retention
- Bookmark and organize content
- Dark mode for late-night study sessions

EXAM PREPARATION:
- Board exam focused content
- JEE/NEET preparation support
- Previous year question analysis
- Topic-wise practice tests
- Performance tracking

PEDAGOGY SYSTEM:
- Concept dependency mapping
- Foundation path learning
- Readiness assessments
- Knowledge gap identification
- Personalized recommendations

Take your board exam and entrance test preparation to the next level!
''',

    primaryCategory: 'Education',
    secondaryCategory: null,
    contentRating: ContentRating.everyone,
    targetAgeMin: 16,
    targetAgeMax: 18,

    androidPackageName: 'com.streamshaala',
    iosBundleId: 'com.streamshaala',

    developerName: 'StreamShaala Education',
    developerEmail: 'support@streamshaala.com',
    privacyPolicyUrl: 'https://streamshaala.com/privacy',
    termsOfServiceUrl: 'https://streamshaala.com/terms',
    supportUrl: 'https://streamshaala.com/support',

    keywords: [
      'class 11 learning',
      'class 12 learning',
      'CBSE preparation',
      'JEE preparation',
      'NEET preparation',
      'physics class 12',
      'chemistry class 12',
      'board exam',
      'video lessons',
      'education app',
      'study app',
    ],

    screenshotGuidelines: ScreenshotGuidelines(
      phonePortraitCount: 5,
      tabletPortraitCount: 3,
      requiredScenes: [
        'Subject selection with streams',
        'Video lesson player',
        'Pedagogy recommendations',
        'Quiz interface',
        'Progress analytics',
      ],
    ),

    supportedLanguages: ['en', 'hi'],
    defaultLanguage: 'en',
  );

  /// Spelling segment (Grades 1-8) - English Spelling Learning
  static const spelling = AppStoreMetadata(
    appName: 'SpellShaala',
    shortDescription: 'Fun English spelling app for kids',
    fullDescription: '''
SpellShaala makes learning English spelling fun and effective for students in Grades 1-8!

KEY FEATURES:
- Word of the Day with pronunciation and meaning
- Spelling Bee challenges with progressive difficulty
- Dictation practice with text-to-speech
- Interactive flashcards with spaced repetition
- Phonics pattern lessons
- Word family mind maps
- Personal word journal
- Fun quizzes: unscramble, fill-in-blanks, multiple choice

LEARNING APPROACH:
- Phonics-based spelling patterns
- Visual word associations
- Mnemonic hints for tricky words
- Spaced repetition for long-term retention
- Progressive difficulty by grade level

GAMIFICATION:
- Earn stars and badges for mastering words
- Daily spelling streaks
- Spelling Bee competitions
- XP rewards for consistent practice

PARENT FEATURES:
- Progress tracking
- Screen time controls
- Grade-appropriate word lists
- Safe, ad-free experience

COMING SOON:
- Pronunciation practice with speech recognition
- Sentence building exercises
- Handwriting practice
- Creative writing prompts

Download now and become a spelling champion!
''',
    primaryCategory: 'Education',
    secondaryCategory: 'Word',
    contentRating: ContentRating.everyone,
    targetAgeMin: 5,
    targetAgeMax: 14,

    androidPackageName: 'com.streamshaala.spelling',
    iosBundleId: 'com.streamshaala.spelling',

    developerName: 'StreamShaala Education',
    developerEmail: 'support@streamshaala.com',
    privacyPolicyUrl: 'https://streamshaala.com/privacy',
    termsOfServiceUrl: 'https://streamshaala.com/terms',
    supportUrl: 'https://streamshaala.com/support',

    keywords: [
      'spelling app',
      'english spelling',
      'spelling bee',
      'phonics',
      'vocabulary builder',
      'word games for kids',
      'learn to spell',
      'spelling practice',
      'english vocabulary',
      'spelling quiz',
      'kids education',
      'spelling test',
      'word learning',
    ],

    screenshotGuidelines: ScreenshotGuidelines(
      phonePortraitCount: 5,
      tabletPortraitCount: 3,
      requiredScenes: [
        'Word of the Day screen',
        'Spelling practice with dictation',
        'Spelling Bee challenge',
        'Flashcard study mode',
        'Progress and badges dashboard',
      ],
    ),

    supportedLanguages: ['en'],
    defaultLanguage: 'en',
  );
}

/// App Store metadata model
class AppStoreMetadata {
  // Basic info
  final String appName;
  final String shortDescription;
  final String fullDescription;

  // Store categorization
  final String primaryCategory;
  final String? secondaryCategory;
  final ContentRating contentRating;
  final int targetAgeMin;
  final int targetAgeMax;

  // Package identifiers
  final String androidPackageName;
  final String iosBundleId;

  // Contact info
  final String developerName;
  final String developerEmail;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String supportUrl;

  // ASO
  final List<String> keywords;

  // Screenshots
  final ScreenshotGuidelines screenshotGuidelines;

  // Localization
  final List<String> supportedLanguages;
  final String defaultLanguage;

  const AppStoreMetadata({
    required this.appName,
    required this.shortDescription,
    required this.fullDescription,
    required this.primaryCategory,
    this.secondaryCategory,
    required this.contentRating,
    required this.targetAgeMin,
    required this.targetAgeMax,
    required this.androidPackageName,
    required this.iosBundleId,
    required this.developerName,
    required this.developerEmail,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.supportUrl,
    required this.keywords,
    required this.screenshotGuidelines,
    required this.supportedLanguages,
    required this.defaultLanguage,
  });

  /// Get target age range string
  String get targetAgeRange => '$targetAgeMin-$targetAgeMax';

  /// Get keywords as comma-separated string (for store submission)
  String get keywordsString => keywords.join(', ');
}

/// Content rating enum
enum ContentRating {
  everyone('Everyone', 'PEGI 3', '4+'),
  everyone10Plus('Everyone 10+', 'PEGI 7', '9+'),
  teen('Teen', 'PEGI 12', '12+'),
  mature('Mature 17+', 'PEGI 16', '17+');

  final String playStoreRating;
  final String pegiRating;
  final String appStoreRating;

  const ContentRating(this.playStoreRating, this.pegiRating, this.appStoreRating);
}

/// Screenshot guidelines
class ScreenshotGuidelines {
  final int phonePortraitCount;
  final int tabletPortraitCount;
  final List<String> requiredScenes;

  const ScreenshotGuidelines({
    required this.phonePortraitCount,
    required this.tabletPortraitCount,
    required this.requiredScenes,
  });
}
