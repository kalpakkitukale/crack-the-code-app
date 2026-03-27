// DEV ENTRY POINT — Skip Firebase, test full 5-tab app
//
// Run with: flutter run -t lib/main_dev.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crack_the_code/shared/repositories/phonogram_repository.dart';
import 'package:crack_the_code/shared/repositories/rule_repository.dart';
import 'package:crack_the_code/shared/repositories/word_repository.dart';
import 'package:crack_the_code/shared/repositories/audio_repository.dart';
import 'package:crack_the_code/shared/repositories/sound_repository.dart';
import 'package:crack_the_code/shared/repositories/character_repository.dart';
import 'package:crack_the_code/shared/repositories/level_repository.dart';
import 'package:crack_the_code/shared/services/audio_service.dart';
import 'package:crack_the_code/shared/services/storage_service.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';
import 'package:crack_the_code/games/sound_board/screens/sound_board_home.dart';
import 'package:crack_the_code/presentation/screens/learn/learn_hub_screen.dart';
import 'package:crack_the_code/presentation/screens/practice/practice_hub_screen.dart';
import 'package:crack_the_code/presentation/screens/games/games_hub_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final storage = GameStorageService();
  await storage.init();

  final phonogramRepo = PhonogramRepository();
  final ruleRepo = RuleRepository();
  final wordRepo = WordRepository();
  final soundRepo = SoundRepository();
  final characterRepo = CharacterRepository();
  final levelRepo = LevelRepository();

  await Future.wait([
    phonogramRepo.loadFromAssets(),
    ruleRepo.loadFromAssets(),
    wordRepo.loadFromAssets(),
    soundRepo.loadFromAssets(),
    characterRepo.loadFromAssets(),
    levelRepo.loadFromAssets(),
  ]);

  final audioService = AudioService();
  await audioService.initialize();
  final audioRepo = AudioRepository(audioService);

  // Register phonogram sounds for TTS fallback
  final soundMap = <String, String>{};
  for (final phonogram in phonogramRepo.getAll()) {
    for (final sound in phonogram.sounds) {
      final exWord = sound.exampleWords.isNotEmpty
          ? sound.exampleWords.first.word
          : '';
      soundMap[sound.soundId] = exWord.isNotEmpty
          ? '${sound.notation.replaceAll("/", "")}, as in $exWord'
          : sound.notation.replaceAll("/", "");
    }
  }
  audioService.registerPhonogramSounds(soundMap);

  debugPrint('✅ Loaded: ${phonogramRepo.totalPhonograms} phonograms, '
      '${phonogramRepo.totalSounds} sounds, '
      '${ruleRepo.getAll().length} rules, '
      '${wordRepo.totalWords} words, '
      '${soundRepo.totalSounds} base sounds, '
      '${characterRepo.totalCharacters} characters, '
      '${levelRepo.getAll().length} levels');

  runApp(
    ProviderScope(
      overrides: [
        gameStorageServiceProvider.overrideWithValue(storage),
        phonogramRepositoryProvider.overrideWithValue(phonogramRepo),
        ruleRepositoryProvider.overrideWithValue(ruleRepo),
        wordRepositoryProvider.overrideWithValue(wordRepo),
        audioServiceProvider.overrideWithValue(audioService),
        audioRepositoryProvider.overrideWithValue(audioRepo),
        soundRepositoryProvider.overrideWithValue(soundRepo),
        characterRepositoryProvider.overrideWithValue(characterRepo),
        levelRepositoryProvider.overrideWithValue(levelRepo),
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
      title: 'Crack the Code',
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
      home: const _AppShell(),
    );
  }
}

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell();

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(playerProfileProvider);
    final strings = AppStrings(profile.language);

    final screens = [
      const SoundBoardHome(),
      const LearnHubScreen(),
      const PracticeHubScreen(),
      const GamesHubScreen(),
      _buildProgressPlaceholder(strings),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF0A0618).withValues(alpha: 0.95),
        indicatorColor: const Color(0xFFFFD700).withValues(alpha: 0.15),
        height: 70,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon:
                const Icon(Icons.home, color: Color(0xFFFFD700)),
            label: strings.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon:
                const Icon(Icons.menu_book, color: Color(0xFFFFD700)),
            label: strings.tabLearn,
          ),
          NavigationDestination(
            icon: const Icon(Icons.edit_outlined),
            selectedIcon:
                const Icon(Icons.edit, color: Color(0xFFFFD700)),
            label: strings.tabPractice,
          ),
          NavigationDestination(
            icon: const Icon(Icons.sports_esports_outlined),
            selectedIcon: const Icon(Icons.sports_esports,
                color: Color(0xFFFFD700)),
            label: strings.tabGames,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events,
                color: Color(0xFFFFD700)),
            label: strings.tabProgress,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressPlaceholder(AppStrings strings) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                strings.myProgress,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming in Phase 9',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
