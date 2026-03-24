// Common initialization code for Crack the Code
//
// This file contains shared app initialization logic.
// Do not run this file directly - use main.dart.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/theme/segment_theme_factory.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/firebase_options.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/presentation/navigation/app_router.dart';
import 'package:crack_the_code/presentation/providers/user/theme_provider.dart';
import 'package:crack_the_code/presentation/widgets/parental/screen_time_overlay.dart';
import 'package:crack_the_code/presentation/widgets/gamification/celebration_overlay.dart';

// Platform consistency imports
import 'package:crack_the_code/core/platform/platform_consistency_manager.dart';
import 'package:crack_the_code/core/services/video_metadata_service.dart';
import 'package:crack_the_code/core/services/content_index.dart';
import 'package:crack_the_code/core/services/deep_link_service.dart';
import 'package:crack_the_code/core/services/push_notification_service.dart';
import 'package:crack_the_code/core/utils/progress_migration.dart';
import 'package:crack_the_code/core/utils/performance_utils.dart';
import 'package:crack_the_code/core/utils/encryption_helper.dart';

/// Initialize Firebase Crashlytics with error handlers
Future<void> _initializeCrashlytics() async {
  // Disable Crashlytics in debug mode to avoid noise during development
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    logger.debug('Crashlytics disabled in debug mode');
    return;
  }

  // Enable Crashlytics collection in release mode
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Set user identifier if available
  final segment = SegmentConfig.current.name;
  await FirebaseCrashlytics.instance.setCustomKey('app_segment', segment);

  // Pass all uncaught errors from the Flutter framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    logger.error(
      'Flutter framework error',
      errorDetails.exception,
      errorDetails.stack,
    );
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught async errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('Uncaught async error', error, stack);
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

/// Main entry point for Crack the Code app
void runCrackTheCodeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SegmentConfig.settings;

  try {
    logger.info(
        '🚀 Starting ${settings.appName} with unified platform architecture...');
    logger.info('   Segment: ${SegmentConfig.current.name}');
    logger.info('   Grades: ${settings.minGrade}-${settings.maxGrade}');

    // Initialize Firebase
    logger.info('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.info('✅ Firebase initialized successfully');

    // Initialize Firebase Crashlytics
    logger.info('📊 Initializing Crashlytics...');
    await _initializeCrashlytics();
    logger.info('✅ Crashlytics initialized');

    // Initialize encryption helper for secure data storage
    logger.info('🔐 Initializing encryption...');
    await encryptionHelper.initialize();
    logger.info('✅ Encryption initialized');

    // Initialize push notifications
    logger.info('🔔 Initializing push notifications...');
    await pushNotificationService.initialize();
    if (pushNotificationService.isInitialized) {
      logger.info('✅ Push notifications initialized');
      // Token is not logged in production for security
    } else {
      logger.warning('⚠️ Push notifications not available (permission denied or error)');
    }

    // Initialize deep link service for email magic link authentication
    logger.info('🔗 Initializing deep link service...');
    await DeepLinkService.instance.initialize();
    logger.info('✅ Deep link service initialized');

    // Configure image cache for better performance
    logger.info('🖼️ Configuring image cache...');
    ImageCacheHelper.configure();

    // Initialize platform consistency manager
    logger.info('🔄 Ensuring platform consistency...');
    await PlatformConsistencyManager().initializeConsistently();

    // Initialize dependency injection
    logger.info('💉 Initializing dependency injection...');
    await injectionContainer.initialize();

    // Initialize content services
    logger.info('📚 Initializing content services...');
    await ContentIndex().initialize();
    await VideoMetadataService().initialize();

    // Run progress migration to fix completion status and metadata
    logger.info('🔧 Running progress migration...');
    await ProgressMigration.migrateIfNeeded();

    logger.info('✅ All systems initialized successfully!');

    // Get consistency report
    final consistencyReport =
        await PlatformConsistencyManager().getConsistencyReport();
    logger.info('📋 Platform Consistency Report:');
    logger.info('  - Platform: ${consistencyReport['platform_os']}');
    logger.info('  - Platform ID: ${consistencyReport['platform_id']}');
    logger.info('  - Data Consistent: ${consistencyReport['is_consistent']}');
    logger.info('  - Checksum: ${consistencyReport['data_checksum']}');

    // Get content index stats
    final indexStats = ContentIndex().getStatistics();
    logger.info('🔍 Content Index Statistics:');
    logger.info('  - Boards: ${indexStats['boards']}');
    logger.info('  - Subjects: ${indexStats['subjects']}');
    logger.info('  - Chapters: ${indexStats['chapters']}');
    logger.info('  - Videos: ${indexStats['videos']}');

    runApp(
      const ProviderScope(
        child: CrackTheCodeApp(),
      ),
    );
  } catch (e, stackTrace) {
    logger.error('❌ Failed to initialize application', e, stackTrace);

    // Report initialization failure to Crashlytics (if initialized)
    if (!kDebugMode) {
      try {
        await FirebaseCrashlytics.instance.recordError(
          e,
          stackTrace,
          reason: 'Application initialization failed',
          fatal: true,
        );
      } catch (_) {
        // Crashlytics may not be initialized yet
      }
    }

    // Show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Restart app
                      runCrackTheCodeApp();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Main app widget for Crack the Code
class CrackTheCodeApp extends ConsumerWidget {
  const CrackTheCodeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get segment settings
    final settings = SegmentConfig.settings;

    // Watch the theme state and get notifier
    ref.watch(themeProvider); // Watch for rebuilds
    final themeNotifier = ref.read(themeProvider.notifier);

    return MaterialApp.router(
      title: settings.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration - uses segment-aware themes
      theme: SegmentThemeFactory.lightTheme(),
      darkTheme: SegmentThemeFactory.darkTheme(),
      themeMode: themeNotifier.themeMode,

      // Router configuration
      routerConfig: AppRouter.router,

      // Accessibility and parental controls wrapper
      // Segment-specific font scaling is handled by SegmentThemeFactory
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        // Clamp system text scale to reasonable bounds for readability
        // Junior already has larger fonts (1.25x), so limit max scale
        final systemScale = mediaQuery.textScaler.scale(1.0);
        final maxScale = settings.fontScale > 1.0 ? 1.3 : 1.5;
        final clampedScale = systemScale.clamp(0.8, maxScale);

        Widget content = child!;

        // Wrap with screen time overlay for Junior segment
        if (settings.showParentalControls) {
          content = ScreenTimeWrapper(child: content);
        }

        // Wrap with celebration overlay for high gamification intensity (Junior)
        if (settings.gamificationIntensity == GamificationIntensity.high) {
          content = CelebrationWrapper(child: content);
        }

        if (systemScale != clampedScale) {
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(clampedScale),
            ),
            child: content,
          );
        }
        return content;
      },
    );
  }
}
