import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/tier_progress_provider.dart';
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

            // Today's Sound
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TodaySoundCard(
                  onPhonogramTapped: (id) {
                    ref
                        .read(soundBoardProgressProvider.notifier)
                        .recordTap(id);
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
}
