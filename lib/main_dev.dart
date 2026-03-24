// DEV ENTRY POINT — Skip Firebase, go directly to Sound Board
//
// Run with: flutter run -t lib/main_dev.dart
//
// This bypasses all Firebase initialization, auth, push notifications,
// deep links, etc. Just loads game data and shows Sound Board.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crack_the_code/shared/repositories/phonogram_repository.dart';
import 'package:crack_the_code/shared/repositories/rule_repository.dart';
import 'package:crack_the_code/shared/repositories/word_repository.dart';
import 'package:crack_the_code/shared/repositories/audio_repository.dart';
import 'package:crack_the_code/shared/services/audio_service.dart';
import 'package:crack_the_code/shared/services/storage_service.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/screens/sound_board_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Initialize storage
  final storage = GameStorageService();
  await storage.init();

  // 3. Load repositories
  final phonogramRepo = PhonogramRepository();
  final ruleRepo = RuleRepository();
  final wordRepo = WordRepository();

  await Future.wait([
    phonogramRepo.loadFromAssets(),
    ruleRepo.loadFromAssets(),
    wordRepo.loadFromAssets(),
  ]);

  // 4. Initialize audio
  final audioService = AudioService();
  await audioService.initialize();
  final audioRepo = AudioRepository(audioService);

  debugPrint('✅ Loaded: ${phonogramRepo.totalPhonograms} phonograms, '
      '${phonogramRepo.totalSounds} sounds, '
      '${ruleRepo.getAll().length} rules, '
      '${wordRepo.totalWords} words');

  // 5. Run app
  runApp(
    ProviderScope(
      overrides: [
        gameStorageServiceProvider.overrideWithValue(storage),
        phonogramRepositoryProvider.overrideWithValue(phonogramRepo),
        ruleRepositoryProvider.overrideWithValue(ruleRepo),
        wordRepositoryProvider.overrideWithValue(wordRepo),
        audioServiceProvider.overrideWithValue(audioService),
        audioRepositoryProvider.overrideWithValue(audioRepo),
      ],
      child: const CrackTheCodeDevApp(),
    ),
  );
}

class CrackTheCodeDevApp extends StatelessWidget {
  const CrackTheCodeDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crack the Code — Dev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0618),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFFF6B35),
          surface: Color(0xFF1A1832),
        ),
      ),
      home: const SoundBoardHome(),
    );
  }
}
