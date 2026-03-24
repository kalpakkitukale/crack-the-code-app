import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/widgets/phonogram_tile_widget.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int _step = 0; // 0=welcome, 1=first phonogram, 2=second, 3=third, 4=done

  final _guidePhonogramIds = ['01', '07', '27']; // A, B, SH
  final _messages = [
    "Hey! I'm KK! 👋\nWelcome to your Sound Collection!",
    "English has 74 secret sound codes.\nLet's find the first one!",
    "Great! Now try this one!",
    "One more! This one is special\n— two letters, one sound!",
    "You're a natural! 🎉\nNow explore on your own!",
  ];

  @override
  Widget build(BuildContext context) {
    final phonogramRepo = ref.watch(phonogramRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const KKAvatar(size: 72),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _messages[_step.clamp(0, _messages.length - 1)],
                    key: ValueKey(_step),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Show phonogram tile for steps 1-3
                if (_step >= 1 && _step <= 3) ...[
                  Builder(builder: (context) {
                    final idx = (_step - 1).clamp(0, 2);
                    final p = phonogramRepo.getById(_guidePhonogramIds[idx]);
                    if (p == null) return const SizedBox.shrink();
                    return Column(
                      children: [
                        PhonogramTileWidget(
                          phonogram: p,
                          size: 100,
                          onTap: () {
                            ref
                                .read(soundBoardProgressProvider.notifier)
                                .recordTap(p.id);
                            // Auto-advance after short delay
                            Future.delayed(
                                const Duration(milliseconds: 800), () {
                              if (mounted) setState(() => _step++);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '👆 Tap me!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    );
                  }),
                ],

                // Welcome step - big start button
                if (_step == 0) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _step = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: const Color(0xFF0A0618),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        '✨ TAP TO START ✨',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],

                // Done step - continue to main app
                if (_step >= 4) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(soundBoardProgressProvider.notifier)
                            .completeOnboarding();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: const Color(0xFF0A0618),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        "LET'S GO! 🚀",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
