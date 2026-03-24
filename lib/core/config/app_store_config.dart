// App Store Configuration for Crack the Code

import 'package:crack_the_code/core/config/segment_config.dart';

/// App Store metadata configuration
class AppStoreConfig {
  /// Get configuration for current segment
  static AppStoreMetadata get current => crackTheCode;

  /// Crack the Code — English Spelling Learning for All Ages
  static const crackTheCode = AppStoreMetadata(
    appName: 'Crack the Code',
    shortDescription: 'Master English spelling with 74 phonograms, 38 rules & fun games',
    fullDescription: '''
Crack the Code reveals the hidden rules that make English spelling logical and learnable!

WHAT YOU'LL LEARN:
- 74 phonograms (letter combinations that make sounds)
- 38 spelling rules that explain 98% of English words
- 112 sounds with pronunciation guides
- Word families and spelling patterns

KEY FEATURES:
- Word of the Day with pronunciation
- Spelling Bee challenges with progressive difficulty
- Interactive flashcards with spaced repetition
- Phonogram pattern lessons
- Dictation practice
- 6 fun digital games
- Daily challenges to build streaks

FOR ALL AGES:
- Tiny (2-4): Big visuals, simple sounds
- Starter (5-7): Core phonograms, guided practice
- Explorer (8-10): All rules, word building
- Master (11-14): Advanced patterns, etymology
- Adults: Full course, self-paced

GAMIFICATION:
- Earn stars and badges for mastering phonograms
- Daily spelling streaks
- XP rewards for consistent practice
- Spelling Bee competitions

PARENT FEATURES:
- Progress tracking
- Screen time controls
- Age-appropriate content
- Safe, ad-free experience

LANGUAGES:
- English interface
- Hindi pronunciation guides
- Marathi pronunciation guides

Download now and crack the code of English spelling!
''',
    primaryCategory: 'Education',
    secondaryCategory: 'Word',
    contentRating: ContentRating.everyone,
    targetAgeMin: 2,
    targetAgeMax: 99,

    androidPackageName: 'com.crackthecode.app',
    iosBundleId: 'com.crackthecode.app',

    developerName: 'Crack the Code Education',
    developerEmail: 'support@crackthecode.app',
    privacyPolicyUrl: 'https://crackthecode.app/privacy',
    termsOfServiceUrl: 'https://crackthecode.app/terms',
    supportUrl: 'https://crackthecode.app/support',

    keywords: [
      'english spelling',
      'spelling app',
      'phonics',
      'phonograms',
      'spelling rules',
      'spelling bee',
      'learn to spell',
      'vocabulary builder',
      'english learning',
      'spelling practice',
      'word games',
      'kids education',
      'spelling test',
    ],

    screenshotGuidelines: ScreenshotGuidelines(
      phonePortraitCount: 5,
      tabletPortraitCount: 3,
      requiredScenes: [
        'Home screen with daily challenge',
        'Phonogram learning with pronunciation',
        'Spelling practice / dictation',
        'Game mode (Spelling Bee)',
        'Progress and badges dashboard',
      ],
    ),

    supportedLanguages: ['en', 'hi', 'mr'],
    defaultLanguage: 'en',
  );
}

/// App Store metadata model
class AppStoreMetadata {
  final String appName;
  final String shortDescription;
  final String fullDescription;
  final String primaryCategory;
  final String? secondaryCategory;
  final ContentRating contentRating;
  final int targetAgeMin;
  final int targetAgeMax;
  final String androidPackageName;
  final String iosBundleId;
  final String developerName;
  final String developerEmail;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String supportUrl;
  final List<String> keywords;
  final ScreenshotGuidelines screenshotGuidelines;
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

  String get targetAgeRange => '$targetAgeMin-$targetAgeMax';
  String get keywordsString => keywords.join(', ');
}

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
