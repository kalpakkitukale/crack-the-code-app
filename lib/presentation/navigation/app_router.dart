import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/entities/pedagogy/learning_path_context.dart';
import 'package:streamshaala/domain/entities/recommendation/learning_path.dart';
import 'package:streamshaala/presentation/screens/home/home_screen.dart';
import 'package:streamshaala/presentation/screens/search/search_screen.dart';
import 'package:streamshaala/presentation/screens/settings/settings_screen.dart';
import 'package:streamshaala/presentation/screens/settings/privacy_policy_screen.dart';
import 'package:streamshaala/presentation/screens/browse/board_screen.dart';
import 'package:streamshaala/presentation/screens/browse/subject_screen.dart';
import 'package:streamshaala/presentation/screens/browse/chapter_screen.dart';
import 'package:streamshaala/presentation/screens/browse/topic_screen.dart';
import 'package:streamshaala/presentation/screens/video/video_player_screen.dart';
import 'package:streamshaala/presentation/screens/progress/progress_screen.dart';
import 'package:streamshaala/presentation/screens/progress/all_subjects_screen.dart';
import 'package:streamshaala/presentation/screens/progress/all_history_screen.dart';
import 'package:streamshaala/presentation/screens/bookmarks/bookmarks_screen.dart';
import 'package:streamshaala/presentation/screens/collections/collections_screen.dart';
import 'package:streamshaala/presentation/screens/collections/collection_detail_screen.dart';
import 'package:streamshaala/presentation/screens/library/library_screen.dart';
import 'package:streamshaala/presentation/screens/practice/practice_screen.dart';
import 'package:streamshaala/presentation/screens/quiz/quiz_taking_screen.dart';
import 'package:streamshaala/presentation/screens/quiz/quiz_results_screen.dart';
import 'package:streamshaala/presentation/screens/quiz/quiz_review_screen.dart';
import 'package:streamshaala/presentation/screens/quiz/quiz_history_screen.dart';
import 'package:streamshaala/presentation/screens/quiz/quiz_statistics_screen.dart';
import 'package:streamshaala/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:streamshaala/presentation/screens/onboarding/junior_onboarding_screen.dart';
import 'package:streamshaala/presentation/screens/onboarding/grade_selection_screen.dart';
import 'package:streamshaala/presentation/screens/settings/parental_controls_screen.dart';
import 'package:streamshaala/presentation/screens/parent/parent_dashboard_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/pre_assessment_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/foundation_path_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/mastery_dashboard_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/recommendations_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/daily_review_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/concept_map_screen.dart';
import 'package:streamshaala/presentation/screens/pedagogy/revision_screen.dart';
import 'package:streamshaala/domain/entities/pedagogy/quiz_recommendation.dart';
import 'package:streamshaala/presentation/screens/debug/test_recommendations_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/mind_map_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/glossary_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/flashcard_decks_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/flashcard_study_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/chapter_study_hub_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/review_due_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/chapter_summary_screen.dart';
import 'package:streamshaala/presentation/screens/study_tools/chapter_notes_screen.dart';
import 'package:streamshaala/presentation/screens/auth/login_screen.dart';
import 'package:streamshaala/presentation/screens/splash/segment_splash_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/spelling_home_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/spelling_practice_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/spelling_bee_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/word_explorer_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/spelling_progress_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/unscramble_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/fill_in_blank_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/word_match_screen.dart';
import 'package:streamshaala/presentation/screens/onboarding/spelling_onboarding_screen.dart';

/// App router configuration using go_router
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode, // Only log diagnostics in debug builds
    initialLocation: RouteConstants.splash, // Start with splash screen
    routes: [
      // Splash screen route (entry point)
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SegmentSplashScreen(),
      ),

      // Main shell route with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // This will be replaced with actual scaffold with bottom nav
          return _ScaffoldWithNavBar(child: child);
        },
        routes: [
          // Home route
          GoRoute(
            path: RouteConstants.home,
            name: RouteConstants.homeRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),

          // Browse route - Board selection
          GoRoute(
            path: RouteConstants.browse,
            name: RouteConstants.browseRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const BoardScreen(),
            ),
          ),

          // Search route
          GoRoute(
            path: RouteConstants.search,
            name: RouteConstants.searchRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),

          // Progress route
          GoRoute(
            path: RouteConstants.progress,
            name: RouteConstants.progressRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProgressScreen(),
            ),
          ),

          // Library route (Middle & Senior segments)
          GoRoute(
            path: RouteConstants.library,
            name: RouteConstants.libraryRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LibraryScreen(),
            ),
          ),

          // Practice route (Preboard segment)
          GoRoute(
            path: RouteConstants.practice,
            name: RouteConstants.practiceRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const PracticeScreen(),
            ),
          ),

          // Spelling Home route (SpellShaala variant)
          GoRoute(
            path: RouteConstants.spellingHome,
            name: RouteConstants.spellingHomeRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SpellingHomeScreen(),
            ),
          ),

          // Word Explorer route
          GoRoute(
            path: '/word-explorer',
            name: RouteConstants.wordExplorerRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const WordExplorerScreen(),
            ),
          ),

          // Spelling Progress route
          GoRoute(
            path: RouteConstants.spellingProgress,
            name: RouteConstants.spellingProgressRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SpellingProgressScreen(),
            ),
          ),

          // Settings route
          GoRoute(
            path: RouteConstants.settings,
            name: RouteConstants.settingsRoute,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),

      // Video player route (full screen, outside shell)
      GoRoute(
        path: RouteConstants.video,
        name: RouteConstants.videoRoute,
        builder: (context, state) {
          final videoId = state.pathParameters['videoId'] ?? '';
          // Get topicId from query parameters
          final topicId = state.uri.queryParameters['topicId'];
          // state.extra can be LearningPathContext or a Map with additional data
          LearningPathContext? pathContext;
          if (state.extra is LearningPathContext) {
            pathContext = state.extra as LearningPathContext;
          } else if (state.extra is Map<String, dynamic>) {
            final extra = state.extra as Map<String, dynamic>;
            pathContext = extra['pathContext'] as LearningPathContext?;
          }
          return VideoPlayerScreen(
            videoId: videoId,
            topicId: topicId,
            pathContext: pathContext,
          );
        },
      ),

      // Bookmarks route
      GoRoute(
        path: RouteConstants.bookmarks,
        name: RouteConstants.bookmarksRoute,
        builder: (context, state) {
          return const BookmarksScreen();
        },
      ),

      // Progress - All Subjects route
      GoRoute(
        path: '/progress/all-subjects',
        name: 'allSubjects',
        builder: (context, state) {
          return const AllSubjectsScreen();
        },
      ),

      // Progress - All History route
      GoRoute(
        path: '/progress/all-history',
        name: 'allHistory',
        builder: (context, state) {
          return const AllHistoryScreen();
        },
      ),

      // Browse hierarchy routes (outside shell)
      GoRoute(
        path: '/browse/board/:boardId/subjects',
        builder: (context, state) {
          final boardId = state.pathParameters['boardId'] ?? '';
          final classId = state.uri.queryParameters['classId'];
          final streamId = state.uri.queryParameters['streamId'];
          return SubjectScreen(
            boardId: boardId,
            classId: classId,
            streamId: streamId,
          );
        },
      ),
      GoRoute(
        path: '/browse/board/:boardId/subject/:subjectId/chapters',
        builder: (context, state) {
          final boardId = state.pathParameters['boardId'] ?? '';
          final subjectId = state.pathParameters['subjectId'] ?? '';
          return ChapterScreen(boardId: boardId, subjectId: subjectId);
        },
      ),
      GoRoute(
        path: '/browse/board/:boardId/subject/:subjectId/chapter/:chapterId/videos',
        builder: (context, state) {
          final boardId = state.pathParameters['boardId'] ?? '';
          final subjectId = state.pathParameters['subjectId'] ?? '';
          final chapterId = state.pathParameters['chapterId'] ?? '';
          final filterKeyword = state.uri.queryParameters['filter'];
          return TopicScreen(
            boardId: boardId,
            subjectId: subjectId,
            chapterId: chapterId,
            filterKeyword: filterKeyword,
          );
        },
      ),

      // Collections routes
      GoRoute(
        path: RouteConstants.collections,
        name: RouteConstants.collectionsRoute,
        builder: (context, state) {
          return const CollectionsScreen();
        },
        routes: [
          GoRoute(
            path: ':collectionId',
            name: RouteConstants.collectionDetailRoute,
            builder: (context, state) {
              final collectionId = state.pathParameters['collectionId'] ?? '';
              return CollectionDetailScreen(collectionId: collectionId);
            },
          ),
        ],
      ),

      // Quiz routes (full screen, outside shell)
      GoRoute(
        path: '/quiz/:entityId/:studentId',
        name: RouteConstants.quizRoute,
        builder: (context, state) {
          final entityId = state.pathParameters['entityId'] ?? '';
          final studentId = state.pathParameters['studentId'] ?? '';
          // Read assessment type from query parameter (defaults to 'knowledge' for backward compatibility)
          final assessmentType = state.uri.queryParameters['type'] ?? 'knowledge';

          // Extract path context from extra parameter
          LearningPathContext? pathContext;
          final extra = state.extra;

          if (extra is LearningPathContext) {
            pathContext = extra;
          } else if (extra is Map<String, dynamic>) {
            pathContext = extra['pathContext'] as LearningPathContext?;
          }

          return QuizTakingScreen(
            entityId: entityId,
            studentId: studentId,
            assessmentType: assessmentType,
            pathContext: pathContext,
          );
        },
        routes: [
          GoRoute(
            path: 'results',
            name: RouteConstants.quizResultsRoute,
            builder: (context, state) {
              final entityId = state.pathParameters['entityId'] ?? '';
              // Read assessment type from query parameter (defaults to 'knowledge' for backward compatibility)
              final assessmentType = state.uri.queryParameters['type'] ?? 'knowledge';
              // Read recommendations history ID from query parameter (for loading from history)
              final recHistoryId = state.uri.queryParameters['recHistoryId'];

              // Extract result and pathContext from extra parameter
              QuizResult? result;
              LearningPathContext? pathContext;

              final extra = state.extra;
              if (extra is QuizResult) {
                result = extra;
              } else if (extra is Map<String, dynamic>) {
                result = extra['result'] as QuizResult?;
                pathContext = extra['pathContext'] as LearningPathContext?;
              }

              return QuizResultsScreen(
                entityId: entityId,
                result: result,
                assessmentType: assessmentType,
                pathContext: pathContext,
                recommendationsHistoryId: recHistoryId,
              );
            },
            routes: [
              GoRoute(
                path: 'review',
                name: RouteConstants.quizReviewRoute,
                builder: (context, state) {
                  final result = state.extra as QuizResult;
                  final showWrongOnly = state.uri.queryParameters['wrongOnly'] == 'true';
                  return QuizReviewScreen(
                    result: result,
                    showWrongOnly: showWrongOnly,
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // Quiz History route (full screen, outside shell)
      GoRoute(
        path: RouteConstants.quizHistory,
        name: RouteConstants.quizHistoryRoute,
        builder: (context, state) {
          return const QuizHistoryScreen();
        },
      ),

      // Quiz Statistics route (full screen, outside shell)
      GoRoute(
        path: RouteConstants.quizStatistics,
        name: RouteConstants.quizStatisticsRoute,
        builder: (context, state) {
          return const QuizStatisticsScreen();
        },
      ),

      // ============ STUDY TOOLS ROUTES ============

      // Mind Map route
      GoRoute(
        path: '/study-tools/mind-map/:chapterId',
        name: 'mindMap',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'] ?? '';
          return MindMapScreen(chapterId: chapterId);
        },
      ),

      // Glossary route
      GoRoute(
        path: '/study-tools/glossary/:chapterId',
        name: 'glossary',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'] ?? '';
          return GlossaryScreen(chapterId: chapterId);
        },
      ),

      // Flashcard Decks route (browse decks in a chapter)
      GoRoute(
        path: '/study-tools/flashcard-decks/:chapterId',
        name: 'flashcardDecks',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'] ?? '';
          final subjectId = state.uri.queryParameters['subjectId'] ?? '';
          return FlashcardDecksScreen(
            chapterId: chapterId,
            subjectId: subjectId,
          );
        },
      ),

      // Flashcard Study route
      GoRoute(
        path: '/study-tools/flashcards/:deckId',
        name: 'flashcardStudy',
        builder: (context, state) {
          final deckId = state.pathParameters['deckId'] ?? '';
          return FlashcardStudyScreen(deckId: deckId);
        },
      ),

      // Chapter Study Hub route
      GoRoute(
        path: '/study-hub/:chapterId',
        name: 'studyHub',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'] ?? '';
          final subjectId = state.uri.queryParameters['subjectId'] ?? '';
          return ChapterStudyHubScreen(
            chapterId: chapterId,
            subjectId: subjectId,
          );
        },
      ),

      // Chapter Summary route
      GoRoute(
        path: '/study-hub/:chapterId/summary',
        name: 'chapterSummary',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'] ?? '';
          final subjectId = state.uri.queryParameters['subjectId'] ?? '';
          return ChapterSummaryScreen(
            chapterId: chapterId,
            subjectId: subjectId,
          );
        },
      ),

      // Chapter Notes route
      GoRoute(
        path: '/study-hub/:chapterId/notes',
        name: 'chapterNotes',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'] ?? '';
          final subjectId = state.uri.queryParameters['subjectId'] ?? '';
          return ChapterNotesScreen(
            chapterId: chapterId,
            subjectId: subjectId,
          );
        },
      ),

      // Review Due Flashcards route
      GoRoute(
        path: '/review-due',
        name: 'reviewDue',
        builder: (context, state) {
          return const ReviewDueScreen();
        },
      ),

      // ============ SPELLING ROUTES (SpellShaala) ============

      // Spelling Practice route (dictation)
      GoRoute(
        path: '/spelling-practice',
        name: RouteConstants.spellingPracticeRoute,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final wordListId = args['wordListId'] as String? ?? '';
          final activityType = args['activityType'] as String? ?? 'dictation';
          return SpellingPracticeScreen(
            wordListId: wordListId,
            activityType: activityType,
          );
        },
      ),

      // Spelling Bee route
      GoRoute(
        path: '/spelling-bee',
        name: RouteConstants.spellingBeeRoute,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final gradeLevel = args['gradeLevel'] as int? ?? 1;
          final roundCount = args['roundCount'] as int? ?? 5;
          return SpellingBeeScreen(
            gradeLevel: gradeLevel,
            roundCount: roundCount,
          );
        },
      ),

      // Unscramble activity route
      GoRoute(
        path: '/spelling-unscramble',
        name: 'spellingUnscramble',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final wordListId = args['wordListId'] as String? ?? '';
          return UnscrambleScreen(wordListId: wordListId);
        },
      ),

      // Fill in the blank activity route
      GoRoute(
        path: '/spelling-fill-blank',
        name: 'spellingFillBlank',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final wordListId = args['wordListId'] as String? ?? '';
          return FillInBlankScreen(wordListId: wordListId);
        },
      ),

      // Word Match activity route
      GoRoute(
        path: '/spelling-word-match',
        name: 'spellingWordMatch',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final wordListId = args['wordListId'] as String? ?? '';
          return WordMatchScreen(wordListId: wordListId);
        },
      ),

      // Login route (full screen, outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      // Onboarding route - segment aware (full screen, outside shell)
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) {
          // Use Junior onboarding for Junior segment
          if (SegmentConfig.current == AppSegment.junior) {
            return const JuniorOnboardingScreen();
          }
          if (SegmentConfig.current == AppSegment.spelling) {
            return SpellingOnboardingScreen(
              onComplete: () {
                // Navigate to grade selection after onboarding
                GoRouter.of(context).go('/grade-selection');
              },
            );
          }
          return const OnboardingScreen();
        },
      ),

      // Grade Selection route (Junior only, after onboarding)
      GoRoute(
        path: '/grade-selection',
        name: 'gradeSelection',
        builder: (context, state) {
          return const GradeSelectionScreen();
        },
      ),

      // Parental Controls route
      GoRoute(
        path: '/parental-controls',
        name: 'parentalControls',
        builder: (context, state) {
          return const ParentalControlsScreen();
        },
      ),

      // Parent Dashboard route (comprehensive activity view)
      GoRoute(
        path: '/parent-dashboard',
        name: 'parentDashboard',
        builder: (context, state) {
          return const ParentDashboardScreen();
        },
      ),

      // Privacy Policy route (full screen, outside shell)
      GoRoute(
        path: '/privacy-policy',
        name: 'privacyPolicy',
        builder: (context, state) {
          return const PrivacyPolicyScreen();
        },
      ),

      // ============ PEDAGOGY SYSTEM ROUTES ============

      // Pre-Assessment route
      GoRoute(
        path: '/pre-assessment/:subjectId/:targetGrade',
        name: 'preAssessment',
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId'] ?? '';
          final targetGrade = int.tryParse(state.pathParameters['targetGrade'] ?? '6') ?? 6;
          final subjectName = state.uri.queryParameters['name'] ?? 'Subject';
          final studentId = state.uri.queryParameters['studentId'] ?? 'default_student';
          return PreAssessmentScreen(
            subjectId: subjectId,
            subjectName: subjectName,
            targetGrade: targetGrade,
            studentId: studentId,
          );
        },
      ),

      // Foundation Path route
      GoRoute(
        path: '/foundation-path/:pathId',
        name: 'foundationPath',
        builder: (context, state) {
          final pathId = state.pathParameters['pathId'] ?? '';
          // Check if path object was passed via extra (for resume)
          final extra = state.extra;
          if (extra is LearningPath) {
            return FoundationPathScreen.withPath(initialPath: extra);
          }
          return FoundationPathScreen(pathId: pathId);
        },
      ),

      // Foundation Path route without ID (for resume with path object)
      GoRoute(
        path: '/foundation-path',
        name: 'resumeFoundationPath',
        builder: (context, state) {
          final path = state.extra as LearningPath?;
          if (path != null) {
            return FoundationPathScreen.withPath(initialPath: path);
          }
          // Fallback - this shouldn't happen, but provide empty path ID
          return const FoundationPathScreen(pathId: '');
        },
      ),

      // Revision route (for learning path revision nodes)
      GoRoute(
        path: '/revision/:nodeId',
        name: 'revision',
        builder: (context, state) {
          final nodeId = state.pathParameters['nodeId'] ?? '';
          final pathContext = state.extra as LearningPathContext;
          return RevisionScreen(
            nodeId: nodeId,
            pathContext: pathContext,
          );
        },
      ),

      // Mastery Dashboard route
      GoRoute(
        path: '/mastery-dashboard/:studentId',
        name: 'masteryDashboard',
        builder: (context, state) {
          final studentId = state.pathParameters['studentId'] ?? 'default_student';
          return MasteryDashboardScreen(studentId: studentId);
        },
      ),

      // Recommendations route
      GoRoute(
        path: RouteConstants.recommendations,
        name: RouteConstants.recommendationsRoute,
        builder: (context, state) {
          final bundle = state.extra as RecommendationsBundle;
          return RecommendationsScreen(bundle: bundle);
        },
      ),

      // Daily Review route
      GoRoute(
        path: '/daily-review/:studentId',
        name: 'dailyReview',
        builder: (context, state) {
          final studentId = state.pathParameters['studentId'] ?? 'default_student';
          return DailyReviewScreen(studentId: studentId);
        },
      ),

      // Concept Map route
      GoRoute(
        path: '/concept-map/:studentId',
        name: 'conceptMap',
        builder: (context, state) {
          final studentId = state.pathParameters['studentId'] ?? 'default_student';
          return ConceptMapScreen(studentId: studentId);
        },
      ),

      // Practice Mode route (placeholder)
      GoRoute(
        path: '/practice/:conceptId',
        name: 'practiceMode',
        builder: (context, state) {
          final conceptId = state.pathParameters['conceptId'] ?? '';
          final studentId = state.uri.queryParameters['studentId'] ?? 'default_student';
          // Use quiz screen for practice
          return QuizTakingScreen(entityId: conceptId, studentId: studentId);
        },
      ),

      // ============ DEBUG/TEST ROUTES ============
      // These routes are only available in debug builds

      if (kDebugMode)
        // Test Recommendations Screen (for testing without content database)
        GoRoute(
          path: '/debug/test-recommendations',
          name: 'testRecommendations',
          builder: (context, state) {
            return const TestRecommendationsScreen();
          },
        ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),

    // Redirect handler
    redirect: (context, state) async {
      final currentPath = state.uri.toString();
      final isJunior = SegmentConfig.current == AppSegment.junior;

      // Don't redirect if on splash screen - let splash handle navigation
      if (currentPath == '/' || currentPath == RouteConstants.splash) {
        return null;
      }

      // Don't redirect if already on onboarding - let it complete
      if (currentPath == '/onboarding') {
        return null;
      }

      // Check if user has completed onboarding FIRST (before any other checks)
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding =
          prefs.getBool('onboarding_complete') ?? false;

      // Redirect to onboarding if not completed (regardless of auth status or target route)
      if (!hasCompletedOnboarding) {
        return '/onboarding';
      }

      // Don't redirect if already on login page (and onboarding is complete)
      if (currentPath == '/login') {
        return null;
      }

      // Check Firebase authentication state
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final isAuthenticated = firebaseUser != null;

      // If not authenticated, redirect to login
      if (!isAuthenticated) {
        return '/login';
      }

      // Don't redirect if on grade selection
      if (currentPath == '/grade-selection') {
        return null;
      }

      // For Junior segment, check if grade selection is complete
      if (isJunior) {
        final hasCompletedGradeSelection =
            prefs.getBool('grade_selection_complete') ?? false;
        if (!hasCompletedGradeSelection) {
          return '/grade-selection';
        }
      }

      // For Spelling segment, check if grade selection is complete
      if (SegmentConfig.isSpelling) {
        final hasCompletedGradeSelection =
            prefs.getBool('grade_selection_complete') ?? false;
        if (!hasCompletedGradeSelection) {
          return '/grade-selection';
        }
      }

      return null;
    },
  );
}

/// Temporary scaffold with bottom navigation
/// This will be replaced with actual adaptive navigation scaffold
class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  @override
  Widget build(BuildContext context) {
    final showSearch = SegmentConfig.settings.showSearchInBottomNav;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: _buildNavigationDestinations(showSearch),
      ),
    );
  }

  /// Build navigation destinations based on segment configuration
  /// Spelling (4 items): Home, Explore, Practice, Progress
  /// Junior (3 items): Home, Search, Progress
  /// Middle (4 items): Home, Search, Library, Progress
  /// Preboard (4 items): Home, Search, Practice, Progress
  /// Senior (4 items): Home, Search, Library, Progress
  List<NavigationDestination> _buildNavigationDestinations(bool showSearch) {
    final settings = SegmentConfig.settings;
    final destinations = <NavigationDestination>[];

    // Spelling segment has its own navigation layout
    if (SegmentConfig.isInitialized && SegmentConfig.isSpelling) {
      return const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.edit_outlined),
          selectedIcon: Icon(Icons.edit),
          label: 'Practice',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'Progress',
        ),
      ];
    }

    // Always add Home and Search
    destinations.addAll([
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.search_outlined),
        selectedIcon: Icon(Icons.search),
        label: 'Search',
      ),
    ]);

    // Add segment-specific middle item (Library or Practice)
    if (settings.showLibraryInBottomNav) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.library_books_outlined),
          selectedIcon: Icon(Icons.library_books),
          label: 'Library',
        ),
      );
    } else if (settings.showPracticeInBottomNav) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.quiz_outlined),
          selectedIcon: Icon(Icons.quiz),
          label: 'Practice',
        ),
      );
    }

    // Always add Progress as the last item
    destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.trending_up_outlined),
        selectedIcon: Icon(Icons.trending_up),
        label: 'Progress',
      ),
    );

    return destinations;
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final settings = SegmentConfig.settings;

    // Spelling segment has custom navigation
    if (SegmentConfig.isInitialized && SegmentConfig.isSpelling) {
      if (location.startsWith(RouteConstants.spellingHome)) return 0;
      if (location.startsWith('/word-explorer')) return 1;
      if (location.startsWith('/spelling-practice') || location.startsWith(RouteConstants.practice)) return 2;
      if (location.startsWith(RouteConstants.spellingProgress)) return 3;
      return 0;
    }

    // Position 0: Home
    if (location.startsWith(RouteConstants.home)) return 0;

    // Position 1: Search
    if (location.startsWith(RouteConstants.search)) return 1;

    // Position 2: Library/Practice (segment-specific) or Progress (Junior only)
    if (settings.showLibraryInBottomNav && location.startsWith(RouteConstants.library)) {
      return 2;
    }
    if (settings.showPracticeInBottomNav && location.startsWith(RouteConstants.practice)) {
      return 2;
    }

    // Progress position depends on whether there's a middle item (Library/Practice)
    if (location.startsWith(RouteConstants.progress)) {
      return (settings.showLibraryInBottomNav || settings.showPracticeInBottomNav) ? 3 : 2;
    }

    return 0; // Default to Home
  }

  void _onItemTapped(int index, BuildContext context) {
    final settings = SegmentConfig.settings;

    // Spelling segment custom navigation
    if (SegmentConfig.isInitialized && SegmentConfig.isSpelling) {
      switch (index) {
        case 0: context.go(RouteConstants.spellingHome); break;
        case 1: context.go('/word-explorer'); break;
        case 2: context.go(RouteConstants.spellingHome); break; // Practice from home
        case 3: context.go(RouteConstants.spellingProgress); break;
      }
      return;
    }

    switch (index) {
      case 0:
        context.go(RouteConstants.home);
        break;
      case 1:
        context.go(RouteConstants.search);
        break;
      case 2:
        if (settings.showLibraryInBottomNav) {
          context.go(RouteConstants.library);
        } else if (settings.showPracticeInBottomNav) {
          context.go(RouteConstants.practice);
        } else {
          context.go(RouteConstants.progress);
        }
        break;
      case 3:
        context.go(RouteConstants.progress);
        break;
    }
  }
}
