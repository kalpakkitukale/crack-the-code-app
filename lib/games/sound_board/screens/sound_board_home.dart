import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/widgets/coin_counter.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/widgets/today_sound_card.dart';
import 'package:crack_the_code/games/sound_board/widgets/collection_overview_card.dart';
import 'package:crack_the_code/games/sound_board/widgets/word_builder_entry_card.dart';
import 'package:crack_the_code/games/sound_board/widgets/tier_progress_card.dart';
import 'package:crack_the_code/games/sound_board/screens/full_collection_screen.dart';
import 'package:crack_the_code/games/sound_board/screens/word_builder_screen.dart';
import 'package:crack_the_code/games/sound_board/screens/onboarding_flow.dart';
import 'package:crack_the_code/games/sound_board/widgets/tier_overview_sheet.dart';
import 'package:crack_the_code/games/sound_board/widgets/settings_sheet.dart';
import 'package:crack_the_code/shared/providers/lesson_provider.dart';
import 'package:crack_the_code/presentation/screens/learn/lesson_screen.dart';
class SoundBoardHome extends ConsumerWidget {
  const SoundBoardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(soundBoardProgressProvider);
    final profile = ref.watch(playerProfileProvider);
    final kkMessage = ref.watch(kkMessageProvider);

    // Show onboarding on first launch
    if (!progress.onboardingComplete) {
      return const OnboardingFlow();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header: KK + greeting + coins
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const KKAvatar(size: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey ${profile.nickname}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          KKSpeechBubble(message: kkMessage),
                        ],
                      ),
                    ),
                    const CoinCounter(),
                  ],
                ),
              ),
            ),

            // Continue Lesson
            SliverToBoxAdapter(
              child: _buildContinueLesson(context, ref),
            ),

            // Today's Sound
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TodaySoundCard(
                  onPhonogramTapped: (id) {
                    // Record progress
                    ref
                        .read(soundBoardProgressProvider.notifier)
                        .recordTap(id);
                    // Play sound
                    final phonogram = ref
                        .read(phonogramRepositoryProvider)
                        .getById(id);
                    if (phonogram != null && phonogram.sounds.isNotEmpty) {
                      final sound = phonogram.sounds.first;
                      final ex = sound.exampleWords.isNotEmpty
                          ? sound.exampleWords.first.word
                          : null;
                      ref.read(audioRepositoryProvider).playPhonogram(
                            sound.soundId,
                            notation: sound.notation,
                            exampleWord: ex,
                          );
                    }
                  },
                ),
              ),
            ),

            // Collection Overview
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: CollectionOverviewCard(
                  onOpenCollection: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const FullCollectionScreen(),
                    ));
                  },
                ),
              ),
            ),

            // Word Builder
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: WordBuilderEntryCard(
                  onOpen: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const WordBuilderScreen(),
                    ));
                  },
                ),
              ),
            ),

            // Tier Progress
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TierProgressCard(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF1A1832),
                      builder: (_) => const TierOverviewSheet(),
                    );
                  },
                ),
              ),
            ),

            // Settings button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF1A1832),
                        builder: (_) => const SettingsSheet(),
                      );
                    },
                    icon: Icon(Icons.settings,
                        color: Colors.white.withValues(alpha: 0.4)),
                    label: Text('Settings',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueLesson(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsProvider);
    final lessonProgress = ref.watch(lessonProgressProvider);

    return lessons.when(
      data: (lessonList) {
        final notifier = ref.read(lessonProgressProvider.notifier);
        final next = notifier.nextLesson(lessonList);
        if (next == null) return const SizedBox.shrink(); // all complete

        final lang = ref.watch(playerProfileProvider).language.name;
        final progress = lessonProgress[next.lessonId];
        final learned = progress?.phonogramsLearned ?? 0;
        final color =
            Color(int.parse(next.color.replaceFirst('#', '0xFF')));

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => LessonScreen(lesson: next))),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.12),
                    color.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child:
                          Text(next.emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTINUE LESSON',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Lesson ${next.lessonId}: ${next.titleForLang(lang)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (learned > 0) ...[
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: learned / next.phonogramCount,
                              minHeight: 3,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.08),
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.play_circle_fill,
                      color: color, size: 32),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
