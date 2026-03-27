import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/trial_provider.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/presentation/screens/trial/daily_sound_lesson_screen.dart';

class TrialHomeScreen extends ConsumerWidget {
  const TrialHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final strings = AppStrings(profile.language);
    final lang = profile.language.name;
    final progress = ref.watch(trialProgressProvider);
    final trialDays = ref.watch(trialDaysProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const KKAvatar(size: 64),
              const SizedBox(height: 16),
              Text(
                progress.startDate == null
                    ? strings.kkWelcome
                    : '${strings.greeting(profile.nickname)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Master all 45 sounds in 7 days — FREE!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.totalMastered / 45,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${progress.totalMastered} / 45 sounds mastered',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),

              const SizedBox(height: 24),

              // Day cards
              Expanded(
                child: trialDays.when(
                  data: (days) => ListView.builder(
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final isCompleted = progress.currentDay > day.day;
                      final isCurrent = progress.currentDay == day.day;
                      final isLocked = progress.currentDay < day.day;

                      return _DayCard(
                        day: day,
                        lang: lang,
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        isLocked: isLocked,
                        onTap: isCurrent || isCompleted
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DailySoundLessonScreen(trialDay: day),
                                ))
                            : null,
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final TrialDay day;
  final String lang;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final VoidCallback? onTap;

  const _DayCard({
    required this.day,
    required this.lang,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCurrent
        ? const Color(0xFFFFD700)
        : isCompleted
            ? const Color(0xFF4CAF50)
            : Colors.white.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent
              ? color.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent ? color.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, color: color, size: 22)
                    : day.isCelebration
                        ? const Text('🎉', style: TextStyle(fontSize: 20))
                        : Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${day.day}: ${day.titleForLang(lang)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    day.isCelebration
                        ? 'All 45 sounds mastered!'
                        : '${day.soundCount} sounds',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A0618),
                  ),
                ),
              ),
            if (isLocked)
              Icon(Icons.lock, size: 18, color: Colors.white.withValues(alpha: 0.15)),
          ],
        ),
      ),
    );
  }
}
