import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/lesson.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/episode_provider.dart';
import 'package:crack_the_code/shared/providers/content_gating_provider.dart';
import 'package:crack_the_code/shared/l10n/app_strings.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';

class EpisodeListScreen extends ConsumerWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final strings = AppStrings(profile.language);
    final lang = profile.language.name;
    final episodes = ref.watch(episodesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text(strings.theCourse),
      ),
      body: episodes.when(
        data: (episodeList) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: episodeList.length + 1, // +1 for header
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader(strings);
            }
            final episode = episodeList[index - 1];
            final isFree =
                ref.watch(isEpisodeFreeProvider(episode.number));

            return _EpisodeCard(
              episode: episode,
              lang: lang,
              isFree: isFree,
              strings: strings,
              onTap: () => _openEpisode(context, episode, isFree, lang),
            );
          },
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(AppStrings strings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.12),
            const Color(0xFFFFD700).withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const KKAvatar(size: 64),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.kkAdventure,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '26 episodes · 3 formats',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${strings.kkAdventure} · ${strings.audioLesson} · ${strings.videoGuide}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openEpisode(
      BuildContext context, Episode episode, bool isFree, String lang) {
    if (!isFree) {
      _showPremiumDialog(context);
      return;
    }
    _showEpisodeFormatSheet(context, episode, lang);
  }

  void _showEpisodeFormatSheet(
      BuildContext context, Episode episode, String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1832),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              episode.titleForLang(lang),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              episode.descForLang(lang),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            _FormatButton(
              icon: '🎬',
              label: "KK's Adventure",
              subtitle: 'Premium animated',
              isPremium: true,
              onTap: () {
                Navigator.pop(context);
                // Play animated video
              },
            ),
            const SizedBox(height: 8),
            _FormatButton(
              icon: '🎧',
              label: 'Audio Lesson',
              subtitle: 'FREE · Like a podcast',
              isPremium: false,
              onTap: () {
                Navigator.pop(context);
                // Play NLM audio
              },
            ),
            const SizedBox(height: 8),
            _FormatButton(
              icon: '📺',
              label: 'Video Guide',
              subtitle: 'FREE · Visual presentation',
              isPremium: false,
              onTap: () {
                Navigator.pop(context);
                // Play NLM video
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1832),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('👑 Premium Content',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'This episode is part of the premium course.\n\nUnlock all 26 episodes with KK\'s animated adventures!',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
            ),
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  final Episode episode;
  final String lang;
  final bool isFree;
  final AppStrings strings;
  final VoidCallback onTap;

  const _EpisodeCard({
    required this.episode,
    required this.lang,
    required this.isFree,
    required this.strings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isFree
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFree
                ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Episode number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFree
                    ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isFree
                    ? Text(
                        '${episode.number}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFFD700),
                        ),
                      )
                    : Icon(Icons.lock,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.titleForLang(lang),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isFree
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${episode.duration} · ${isFree ? "3 formats" : strings.premium}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
            if (isFree)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  strings.free,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final bool isPremium;
  final VoidCallback onTap;

  const _FormatButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isPremium,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isPremium
              ? const Color(0xFFFFD700).withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPremium
                ? const Color(0xFFFFD700).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.08),
          ),
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
            if (isPremium) const Text('👑', style: TextStyle(fontSize: 16)),
            const Icon(Icons.play_circle_outline,
                color: Colors.white38, size: 24),
          ],
        ),
      ),
    );
  }
}
