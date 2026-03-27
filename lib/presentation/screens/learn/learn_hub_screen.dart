import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/lesson.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/lesson_provider.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/presentation/screens/learn/lesson_screen.dart';
import 'package:crack_the_code/presentation/screens/learn/episode_list_screen.dart';

class LearnHubScreen extends ConsumerWidget {
  const LearnHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final strings = AppStrings(profile.language);
    final lessons = ref.watch(lessonsProvider);
    final lessonProgress = ref.watch(lessonProgressProvider);
    final lang = profile.language.name;

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
                  strings.tabLearn,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // SECTION: Learn the 74 Sounds (FREE)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(
                      strings.learnTheSounds,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        strings.free,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Lesson cards
            lessons.when(
              data: (lessonList) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final lesson = lessonList[index];
                    final progress = lessonProgress[lesson.lessonId];
                    final completed = progress?.completed ?? false;
                    final unlocked = ref
                        .read(lessonProgressProvider.notifier)
                        .isLessonUnlocked(
                            lesson.lessonId, lesson.prerequisite);

                    return _LessonCard(
                      lesson: lesson,
                      lang: lang,
                      completed: completed,
                      unlocked: unlocked,
                      phonogramsLearned:
                          progress?.phonogramsLearned ?? 0,
                      onTap: unlocked
                          ? () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LessonScreen(lesson: lesson),
                                ),
                              )
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Complete Lesson ${lesson.prerequisite} first to unlock this!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                    );
                  },
                  childCount: lessonList.length,
                ),
              ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),

            // SECTION: The Course (Premium)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  children: [
                    Text(
                      strings.theCourse,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '👑',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Course banner
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const EpisodeListScreen()),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFD700).withValues(alpha: 0.15),
                        const Color(0xFFFFD700).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            const Color(0xFFFFD700).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const KKAvatar(size: 56, animate: false),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.kkAdventure,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFD700),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '26 episodes · 3 formats · 3 languages',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: Color(0xFFFFD700)),
                    ],
                  ),
                ),
              ),
            ),

            // SECTION: Study Tools
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  strings.studyTools,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _StudyToolCard(
                      icon: '📝',
                      label: strings.flashcards,
                      color: const Color(0xFF9C27B0),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Flashcards — Coming soon! Data is ready.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _StudyToolCard(
                      icon: '📖',
                      label: strings.glossary,
                      color: const Color(0xFF2196F3),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Glossary — Coming soon! 274 terms ready.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _StudyToolCard(
                      icon: '🗺️',
                      label: strings.mindMaps,
                      color: const Color(0xFF4CAF50),
                      isPremium: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mind Maps — Premium feature. Coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final String lang;
  final bool completed;
  final bool unlocked;
  final int phonogramsLearned;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.lesson,
    required this.lang,
    required this.completed,
    required this.unlocked,
    required this.phonogramsLearned,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(lesson.color.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unlocked
              ? color.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unlocked
                ? color.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Status icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: completed
                    ? color.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: completed
                    ? Icon(Icons.check, color: color, size: 20)
                    : unlocked
                        ? Text(lesson.emoji,
                            style: const TextStyle(fontSize: 18))
                        : Icon(Icons.lock,
                            color: Colors.white.withValues(alpha: 0.2),
                            size: 18),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson ${lesson.lessonId}: ${lesson.titleForLang(lang)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: unlocked
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${lesson.phonogramCount} sounds · ${lesson.estimatedMinutes} min',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  if (unlocked && !completed && phonogramsLearned > 0) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: phonogramsLearned / lesson.phonogramCount,
                        minHeight: 3,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (unlocked && !completed)
              Icon(Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

class _StudyToolCard extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final bool isPremium;
  final VoidCallback onTap;

  const _StudyToolCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              if (isPremium) ...[
                const SizedBox(height: 4),
                const Text('👑',
                    style: TextStyle(fontSize: 10)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
