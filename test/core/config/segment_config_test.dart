/// SegmentConfig tests for all 4 segments
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/config/segment_config.dart';

void main() {
  group('SegmentConfig', () {
    // =========================================================================
    // INITIALIZATION TESTS
    // =========================================================================
    group('Initialization', () {
      test('junior_initializesCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);

        expect(SegmentConfig.isInitialized, true);
        expect(SegmentConfig.current, AppSegment.crackTheCode);
        expect(SegmentConfig.isCrackTheCode, true);
        expect(SegmentConfig.isCrackTheCode, false);
      });

      test('middle_initializesCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);

        expect(SegmentConfig.current, AppSegment.crackTheCode);
        expect(SegmentConfig.isCrackTheCode, false);
        expect(SegmentConfig.isCrackTheCode, false);
      });

      test('preboard_initializesCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);

        expect(SegmentConfig.current, AppSegment.crackTheCode);
        expect(SegmentConfig.isCrackTheCode, false);
        expect(SegmentConfig.isCrackTheCode, false);
      });

      test('senior_initializesCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);

        expect(SegmentConfig.current, AppSegment.crackTheCode);
        expect(SegmentConfig.isCrackTheCode, false);
        expect(SegmentConfig.isCrackTheCode, true);
      });

      test('spelling_initializesCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);

        expect(SegmentConfig.current, AppSegment.crackTheCode);
        expect(SegmentConfig.isCrackTheCode, true);
        expect(SegmentConfig.isCrackTheCode, false);
      });
    });

    // =========================================================================
    // GRADE RANGE TESTS
    // =========================================================================
    group('Grade Ranges', () {
      test('junior_hasGrades1To7', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        final settings = SegmentConfig.settings;

        expect(settings.minGrade, 1);
        expect(settings.maxGrade, 7);
        expect(settings.grades, [1, 2, 3, 4, 5, 6, 7]);
      });

      test('middle_hasGrades7To9', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        final settings = SegmentConfig.settings;

        expect(settings.minGrade, 7);
        expect(settings.maxGrade, 9);
        expect(settings.grades, [7, 8, 9]);
      });

      test('preboard_hasGrade10Only', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        final settings = SegmentConfig.settings;

        expect(settings.minGrade, 10);
        expect(settings.maxGrade, 10);
        expect(settings.grades, [10]);
      });

      test('senior_hasGrades11To12', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        final settings = SegmentConfig.settings;

        expect(settings.minGrade, 11);
        expect(settings.maxGrade, 12);
        expect(settings.grades, [11, 12]);
      });

      test('spelling_hasGrades1To8', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        final settings = SegmentConfig.settings;

        expect(settings.minGrade, 1);
        expect(settings.maxGrade, 8);
        expect(settings.grades, [1, 2, 3, 4, 5, 6, 7, 8]);
      });

      test('isGradeInRange_worksCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        final settings = SegmentConfig.settings;

        expect(settings.isGradeInRange(1), true);
        expect(settings.isGradeInRange(2), true);
        expect(settings.isGradeInRange(3), true);
        expect(settings.isGradeInRange(4), true);
        expect(settings.isGradeInRange(5), true);
        expect(settings.isGradeInRange(6), true);
        expect(settings.isGradeInRange(7), true);
        expect(settings.isGradeInRange(0), false);
        expect(settings.isGradeInRange(8), false);
      });
    });

    // =========================================================================
    // FEATURE FLAGS MATRIX TEST
    // =========================================================================
    group('Feature Flags', () {
      final featureMatrix = {
        AppSegment.crackTheCode: {
          'showParentalControls': true,
          'showScreenTimeControls': true,
          'showStreams': false,
          'showBoards': false,
          'showSearchInBottomNav': true,  // Updated: now true
          'showDetailedStats': false,
          'showConceptCharts': false,
          'showCharacterAvatar': true,
        },
        AppSegment.crackTheCode: {
          'showParentalControls': false,
          'showScreenTimeControls': false,
          'showStreams': false,
          'showBoards': false,
          'showSearchInBottomNav': true,  // Updated: now true
          'showDetailedStats': true,
          'showConceptCharts': true,
          'showCharacterAvatar': false,
        },
        AppSegment.crackTheCode: {
          'showParentalControls': false,
          'showScreenTimeControls': false,
          'showStreams': false,
          'showBoards': true,
          'showSearchInBottomNav': true,
          'showDetailedStats': true,
          'showConceptCharts': true,
          'showCharacterAvatar': false,
        },
        AppSegment.crackTheCode: {
          'showParentalControls': false,
          'showScreenTimeControls': false,
          'showStreams': true,
          'showBoards': true,
          'showSearchInBottomNav': true,
          'showDetailedStats': true,
          'showConceptCharts': true,
          'showCharacterAvatar': false,
        },
        AppSegment.crackTheCode: {
          'showParentalControls': true,
          'showScreenTimeControls': true,
          'showStreams': false,
          'showBoards': false,
          'showSearchInBottomNav': false,
          'showDetailedStats': false,
          'showConceptCharts': false,
          'showCharacterAvatar': true,
        },
      };

      for (final entry in featureMatrix.entries) {
        final segment = entry.key;
        final expected = entry.value;

        group(segment.name, () {
          setUp(() => SegmentConfig.initialize(segment));

          test('showParentalControls_is_${expected['showParentalControls']}', () {
            expect(
              SegmentConfig.settings.showParentalControls,
              expected['showParentalControls'],
            );
          });

          test('showScreenTimeControls_is_${expected['showScreenTimeControls']}', () {
            expect(
              SegmentConfig.settings.showScreenTimeControls,
              expected['showScreenTimeControls'],
            );
          });

          test('showStreams_is_${expected['showStreams']}', () {
            expect(SegmentConfig.settings.showStreams, expected['showStreams']);
          });

          test('showBoards_is_${expected['showBoards']}', () {
            expect(SegmentConfig.settings.showBoards, expected['showBoards']);
          });

          test('showSearchInBottomNav_is_${expected['showSearchInBottomNav']}', () {
            expect(
              SegmentConfig.settings.showSearchInBottomNav,
              expected['showSearchInBottomNav'],
            );
          });

          test('showDetailedStats_is_${expected['showDetailedStats']}', () {
            expect(
              SegmentConfig.settings.showDetailedStats,
              expected['showDetailedStats'],
            );
          });

          test('showCharacterAvatar_is_${expected['showCharacterAvatar']}', () {
            expect(
              SegmentConfig.settings.showCharacterAvatar,
              expected['showCharacterAvatar'],
            );
          });
        });
      }
    });

    // =========================================================================
    // UI SCALING TESTS
    // =========================================================================
    group('UI Scaling', () {
      test('junior_hasLargerFontScale', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.fontScale, 1.25);
      });

      test('middle_hasModerateFontScale', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.fontScale, 1.15);
      });

      test('preboard_hasDefaultFontScale', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.fontScale, 1.0);
      });

      test('senior_hasDefaultFontScale', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.fontScale, 1.0);
      });

      test('junior_hasLargerTouchTargets', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.touchTargetScale, 1.2);
        expect(SegmentConfig.settings.minTouchTarget, 48.0 * 1.2);
      });

      test('senior_hasDefaultTouchTargets', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.touchTargetScale, 1.0);
        expect(SegmentConfig.settings.minTouchTarget, 48.0);
      });

      test('junior_hasRounderCorners', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.borderRadiusScale, 1.5);
        expect(SegmentConfig.settings.defaultBorderRadius, 12.0 * 1.5);
      });
    });

    // =========================================================================
    // GAMIFICATION TESTS
    // =========================================================================
    group('Gamification', () {
      test('junior_hasHighGamification', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.gamificationIntensity,
          GamificationIntensity.high,
        );
        expect(SegmentConfig.settings.isGamificationProminent, true);
      });

      test('middle_hasMediumGamification', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.gamificationIntensity,
          GamificationIntensity.medium,
        );
      });

      test('preboard_hasLowGamification', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.gamificationIntensity,
          GamificationIntensity.low,
        );
      });

      test('senior_hasLowGamification', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.gamificationIntensity,
          GamificationIntensity.low,
        );
        expect(SegmentConfig.settings.isGamificationProminent, false);
      });

      test('spelling_hasHighGamification', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.gamificationIntensity,
          GamificationIntensity.high,
        );
        expect(SegmentConfig.settings.isGamificationProminent, true);
      });
    });

    // =========================================================================
    // XP MULTIPLIER TESTS
    // =========================================================================
    group('XP Multiplier', () {
      test('junior_has1Point5Multiplier', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.xpMultiplier, 1.5);
      });

      test('middle_has1Point25Multiplier', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.xpMultiplier, 1.25);
      });

      test('preboard_has1Point0Multiplier', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.xpMultiplier, 1.0);
      });

      test('senior_has1Point0Multiplier', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.xpMultiplier, 1.0);
      });

      test('spelling_has1Point5Multiplier', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.xpMultiplier, 1.5);
      });

      test('xpCalculation_appliesMultiplierCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        const baseXp = 100;
        final multipliedXp = baseXp * SegmentConfig.settings.xpMultiplier;
        expect(multipliedXp, 150.0);
      });
    });

    // =========================================================================
    // QUIZ CONFIGURATION TESTS
    // =========================================================================
    group('Quiz Configuration', () {
      test('junior_maxQuestions5', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.defaultQuizQuestionCount, 5);
        expect(SegmentConfig.settings.maxQuizQuestionCount, 10);
      });

      test('middle_maxQuestions10', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.defaultQuizQuestionCount, 10);
        expect(SegmentConfig.settings.maxQuizQuestionCount, 15);
      });

      test('preboard_maxQuestions20', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.defaultQuizQuestionCount, 20);
        expect(SegmentConfig.settings.maxQuizQuestionCount, 30);
      });

      test('senior_maxQuestions20', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.defaultQuizQuestionCount, 20);
        expect(SegmentConfig.settings.maxQuizQuestionCount, 30);
      });

      test('junior_hasFriendlyTimerFormat', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.timerDisplayFormat,
          TimerDisplayFormat.friendly,
        );
      });

      test('senior_hasStandardTimerFormat', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.timerDisplayFormat,
          TimerDisplayFormat.standard,
        );
      });

      test('junior_hasSimplifiedQuizResults', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.simplifiedQuizResults, true);
      });

      test('senior_hasDetailedQuizResults', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.simplifiedQuizResults, false);
      });

      test('spelling_hasDefaultQuizQuestionCount10', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.defaultQuizQuestionCount, 10);
        expect(SegmentConfig.settings.maxQuizQuestionCount, 20);
      });

      test('spelling_hasFriendlyTimerFormat', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(
          SegmentConfig.settings.timerDisplayFormat,
          TimerDisplayFormat.friendly,
        );
      });

      test('spelling_hasSimplifiedQuizResults', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.simplifiedQuizResults, true);
      });
    });

    // =========================================================================
    // DATABASE NAME UNIQUENESS TESTS
    // =========================================================================
    group('Database Names', () {
      test('eachSegment_hasUniqueDatabaseName', () {
        final dbNames = <String>{};

        for (final segment in AppSegment.values) {
          SegmentConfig.initialize(segment);
          final dbName = SegmentConfig.settings.databaseName;

          expect(
            dbNames.contains(dbName),
            false,
            reason: 'Database name $dbName for ${segment.name} is not unique',
          );
          dbNames.add(dbName);
        }

        expect(dbNames.length, AppSegment.values.length);
      });

      test('junior_hasJuniorDatabase', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.databaseName, 'crackthecode.db');
      });

      test('middle_hasMiddleDatabase', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.databaseName, 'crackthecode.db');
      });

      test('preboard_hasPreboardDatabase', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.databaseName, 'crackthecode.db');
      });

      test('senior_hasOriginalDatabase', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.databaseName, 'crackthecode.db');
      });

      test('spelling_hasSpellshaalaDatabase', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.databaseName, 'crackthecode.db');
      });
    });

    // =========================================================================
    // NAVIGATION CONFIGURATION TESTS
    // =========================================================================
    group('Navigation Configuration', () {
      test('junior_has3BottomNavItems', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.bottomNavItemCount, 3);
      });

      test('middle_has4BottomNavItems', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.bottomNavItemCount, 4);
      });

      test('preboard_has4BottomNavItems', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.bottomNavItemCount, 4);
      });

      test('senior_has4BottomNavItems', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.bottomNavItemCount, 4);
      });

      test('junior_hasSimplifiedBrowseHierarchy', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.simplifiedBrowseHierarchy, true);
      });

      test('senior_hasFullBrowseHierarchy', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.simplifiedBrowseHierarchy, false);
      });

      test('spelling_has4BottomNavItems', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.bottomNavItemCount, 4);
      });

      test('spelling_hasSimplifiedBrowseHierarchy', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.simplifiedBrowseHierarchy, true);
      });

      test('spelling_showsPracticeInBottomNav', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showPracticeInBottomNav, true);
        expect(SegmentConfig.settings.showSearchInBottomNav, false);
        expect(SegmentConfig.settings.showLibraryInBottomNav, false);
      });
    });

    // =========================================================================
    // ONBOARDING CONFIGURATION TESTS
    // =========================================================================
    group('Onboarding Configuration', () {
      test('junior_showsGradeSelectionOnly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showGradeSelection, true);
        expect(SegmentConfig.settings.showBoardSelection, false);
        expect(SegmentConfig.settings.showStreamSelection, false);
      });

      test('preboard_showsBoardSelectionOnly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showGradeSelection, false);
        expect(SegmentConfig.settings.showBoardSelection, true);
        expect(SegmentConfig.settings.showStreamSelection, false);
      });

      test('senior_showsAllSelections', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showGradeSelection, true);
        expect(SegmentConfig.settings.showBoardSelection, true);
        expect(SegmentConfig.settings.showStreamSelection, true);
      });

      test('junior_hasFriendlyButtonText', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.onboardingButtonText, "Let's Go!");
      });

      test('senior_hasStandardButtonText', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.onboardingButtonText, 'Get Started');
      });

      test('spelling_showsGradeSelectionOnly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showGradeSelection, true);
        expect(SegmentConfig.settings.showBoardSelection, false);
        expect(SegmentConfig.settings.showStreamSelection, false);
      });

      test('spelling_hasSpellingButtonText', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.onboardingButtonText, "Let's Spell!");
      });
    });

    // =========================================================================
    // HELPER METHODS TESTS
    // =========================================================================
    group('Helper Methods', () {
      test('gradeDisplayName_formatsCorrectly', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.gradeDisplayName(5), 'Grade 5');

        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.gradeDisplayName(12), 'Class 12');
      });

      test('isKidFriendly_trueForJunior', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.isKidFriendly, true);
      });

      test('isKidFriendly_falseForSenior', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.isKidFriendly, false);
      });

      test('requiresParentalControls_trueForJunior', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.requiresParentalControls, true);
      });

      test('requiresParentalControls_falseForSenior', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.requiresParentalControls, false);
      });

      test('isKidFriendly_trueForSpelling', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.isKidFriendly, true);
      });

      test('requiresParentalControls_trueForSpelling', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.requiresParentalControls, true);
      });

      test('showsStreams_trueForSeniorOnly', () {
        for (final segment in AppSegment.values) {
          SegmentConfig.initialize(segment);
          final expected = segment == AppSegment.crackTheCode;
          expect(
            SegmentConfig.showsStreams,
            expected,
            reason: '${segment.name} showsStreams should be $expected',
          );
        }
      });
    });

    // =========================================================================
    // VIDEO CONFIGURATION TESTS
    // =========================================================================
    group('Video Configuration', () {
      test('junior_hasLowerMaxSpeed', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.maxVideoSpeed, 1.5);
      });

      test('senior_hasHigherMaxSpeed', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.maxVideoSpeed, 2.0);
      });

      test('junior_showsRelatedFromSameGrade', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showRelatedVideosFromSameGrade, true);
      });

      test('senior_showsAllRelated', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showRelatedVideosFromSameGrade, false);
      });

      test('spelling_hasLowerMaxSpeed', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.maxVideoSpeed, 1.5);
      });

      test('spelling_showsRelatedFromSameGrade', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);
        expect(SegmentConfig.settings.showRelatedVideosFromSameGrade, true);
      });
    });

    // =========================================================================
    // SPELLING CONFIGURATION TESTS
    // =========================================================================
    group('Spelling Configuration', () {
      setUp(() => SegmentConfig.initialize(AppSegment.crackTheCode));

      test('spelling_hasWordOfTheDay', () {
        expect(SegmentConfig.settings.showWordOfTheDay, true);
      });

      test('spelling_hasSpellingBee', () {
        expect(SegmentConfig.settings.showSpellingBee, true);
      });

      test('spelling_hasPhonicsPatterns', () {
        expect(SegmentConfig.settings.showPhonicsPatterns, true);
      });

      test('spelling_hasDictation', () {
        expect(SegmentConfig.settings.enableDictation, true);
      });

      test('spelling_hasWordJournal', () {
        expect(SegmentConfig.settings.showWordJournal, true);
      });

      test('spelling_hasMnemonics', () {
        expect(SegmentConfig.settings.showMnemonics, true);
      });

      test('spelling_speechRecognitionDisabledByDefault', () {
        expect(SegmentConfig.settings.enableSpeechRecognition, false);
      });

      test('spelling_dailyWordGoalIs5', () {
        expect(SegmentConfig.settings.dailyWordGoal, 5);
      });

      test('spelling_hasSpacedRepetition', () {
        expect(SegmentConfig.settings.enableSpacedRepetition, true);
      });

      test('spelling_hasHighGamification', () {
        expect(SegmentConfig.settings.gamificationIntensity, GamificationIntensity.high);
      });
    });

    // =========================================================================
    // SETTINGS FOR SPECIFIC SEGMENT TESTS
    // =========================================================================
    group('settingsFor', () {
      test('returnsCorrectSettingsWithoutChangingCurrent', () {
        SegmentConfig.initialize(AppSegment.crackTheCode);

        final seniorSettings = SegmentConfig.settingsFor(AppSegment.crackTheCode);

        expect(seniorSettings.appName, 'Crack the Code');
        expect(seniorSettings.minGrade, 11);
        expect(SegmentConfig.current, AppSegment.crackTheCode, reason: 'Current unchanged');
      });
    });
  });
}
