import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';
import 'package:crack_the_code/presentation/screens/spelling/spelling_bee_screen.dart';
import 'package:crack_the_code/presentation/screens/spelling/spelling_practice_screen.dart';
import 'package:crack_the_code/presentation/screens/spelling/unscramble_screen.dart';
import 'package:crack_the_code/presentation/screens/spelling/word_match_screen.dart';
import 'package:crack_the_code/presentation/screens/spelling/daily_challenge_screen.dart';

class PracticeHubScreen extends ConsumerWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final strings = AppStrings(profile.language);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  strings.tabPractice,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Daily Challenge
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFD700).withValues(alpha: 0.15),
                      const Color(0xFFFF6B35).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.dailyChallenge,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Spell 5 words with today\'s phonogram',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const DailyChallengeScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Start',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),

            // Activity grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildListDelegate([
                  _ActivityCard(
                    icon: '🐝',
                    label: strings.spellingBee,
                    subtitle: 'Listen and spell',
                    color: const Color(0xFFFFD700),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SpellingBeeScreen(gradeLevel: 1, roundCount: 5))),
                  ),
                  _ActivityCard(
                    icon: '📝',
                    label: strings.dictation,
                    subtitle: 'Write what you hear',
                    color: const Color(0xFF4ECDC4),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SpellingPracticeScreen(wordListId: 'grade_1', activityType: 'dictation'))),
                  ),
                  _ActivityCard(
                    icon: '🔀',
                    label: strings.unscramble,
                    subtitle: 'Rearrange the letters',
                    color: const Color(0xFFFF8C42),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const UnscrambleScreen(wordListId: 'grade_1'))),
                  ),
                  _ActivityCard(
                    icon: '🔗',
                    label: strings.wordMatch,
                    subtitle: 'Pair sounds with words',
                    color: const Color(0xFF50C878),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const WordMatchScreen(wordListId: 'grade_1'))),
                  ),
                ]),
              ),
            ),

            // Quiz section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  strings.quizzes,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: _QuizCard(
                icon: '👂',
                label: 'Phonogram Recognition',
                subtitle: 'Hear the sound, pick the spelling',
                onTap: () => _showComingSoon(context, 'Phonogram Recognition Quiz'),
              ),
            ),
            SliverToBoxAdapter(
              child: _QuizCard(
                icon: '📜',
                label: 'Spelling Rules',
                subtitle: 'Apply the 38 rules',
                onTap: () => _showComingSoon(context, 'Spelling Rules Quiz'),
              ),
            ),
            SliverToBoxAdapter(
              child: _QuizCard(
                icon: '✏️',
                label: 'Word Spelling',
                subtitle: 'Spell the word correctly',
                onTap: () => _showComingSoon(context, 'Word Spelling Quiz'),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — Coming soon!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.12),
              color.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 36)),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuizCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4))),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
