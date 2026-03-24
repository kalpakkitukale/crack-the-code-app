import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';
import 'package:crack_the_code/games/sound_board/models/word_builder_state.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/widgets/word_detail_sheet.dart';
import 'package:crack_the_code/shared/widgets/coin_counter.dart';

class WordBuilderScreen extends ConsumerWidget {
  const WordBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordBuilderStateProvider);
    final notifier = ref.read(wordBuilderStateProvider.notifier);
    final phonograms = ref.watch(phonogramsProvider);
    final progress = ref.watch(soundBoardProgressProvider);
    final profile = ref.watch(playerProfileProvider);
    final kkMessage = ref.watch(kkMessageProvider);

    // Only show discovered phonograms as active
    final discovered = progress.exploredPhonogramIds;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: const Text('WORD BUILDER'),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 2,
        ),
        actions: const [CoinCounter(), SizedBox(width: 12)],
      ),
      body: Column(
        children: [
          // Build area
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1832),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: state.isValid
                    ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
                    : state.isInvalid
                        ? const Color(0xFFFF9800).withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // Selected phonograms as chips
                if (state.isEmpty)
                  SizedBox(
                    height: 48,
                    child: Center(
                      child: Text(
                        'Tap sounds below to build a word',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: state.selectedTexts
                                  .asMap()
                                  .entries
                                  .map((e) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Chip(
                                    label: Text(e.value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFFD700))),
                                    backgroundColor:
                                        const Color(0xFFFFD700)
                                            .withValues(alpha: 0.12),
                                    side: BorderSide(
                                        color: const Color(0xFFFFD700)
                                            .withValues(alpha: 0.2)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.undo, size: 20),
                          color: Colors.white54,
                          onPressed: state.isEmpty ? null : notifier.undo,
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          color: Colors.white54,
                          onPressed: state.isEmpty ? null : notifier.clear,
                        ),
                      ],
                    ),
                  ),

                // Assembled word (large text)
                if (!state.isEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.assembledText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: state.isValid
                          ? const Color(0xFF4CAF50)
                          : state.isInvalid
                              ? const Color(0xFFFF9800)
                              : Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],

                // Result section
                if (state.isValid && state.validatedWordEntry != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.validatedWordEntry!.emoji != null)
                        Text(state.validatedWordEntry!.emoji!,
                            style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 8),
                      Text(
                        state.isBonusWord
                            ? 'Bonus! +10 🪙'
                            : 'Nice! +5 🪙',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: state.isBonusWord
                              ? const Color(0xFFFFD700)
                              : const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.validatedWordEntry!
                        .meaningForLevel(profile.ageLevelKey),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => WordDetailSheet(
                          word: state.validatedWordEntry!,
                          ageLevel: profile.ageLevelKey,
                        ),
                      );
                    },
                    child: const Text('See full card →',
                        style: TextStyle(color: Color(0xFFFFD700))),
                  ),
                ] else if (state.isInvalid) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Hmm, not a word. Try again!',
                    style: TextStyle(fontSize: 14, color: Color(0xFFFF9800)),
                  ),
                ],
              ],
            ),
          ),

          // Check button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isEmpty ? null : notifier.checkWord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF0A0618),
                  disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  state.isChecking ? 'CHECKING...' : 'CHECK WORD ✓',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // KK message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const KKAvatar(size: 32, animate: false),
                const SizedBox(width: 8),
                Expanded(child: KKSpeechBubble(message: kkMessage)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Phonogram grid (only discovered ones active)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1832),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: profile.gridColumns + 1,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: phonograms.length,
                itemBuilder: (context, index) {
                  final p = phonograms[index];
                  final isActive = discovered.contains(p.id);

                  return GestureDetector(
                    onTap: isActive
                        ? () => notifier.addPhonogram(p.id, p.text)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive
                            ? p.color.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isActive
                              ? p.color.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          p.text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? p.color
                                : Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
