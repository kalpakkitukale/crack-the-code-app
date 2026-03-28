import 'package:flutter/material.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';

class EpisodePlayerScreen extends StatelessWidget {
  final String title;
  final String format; // 'audio', 'video', 'adventure'
  final String url;
  final String language;

  const EpisodePlayerScreen({
    super.key,
    required this.title,
    required this.format,
    required this.url,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final hasContent = url.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: hasContent
              ? _buildPlayer()
              : _buildComingSoon(),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    // When URLs are populated, this will play audio/video
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          format == 'audio' ? Icons.headphones : Icons.play_circle_outline,
          size: 80,
          color: const Color(0xFFFFD700),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('$format · $language',
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4))),
        const SizedBox(height: 24),
        // TODO: Implement actual audio/video player when URLs are ready
        Text('Player will load from:\n$url',
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.3)),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildComingSoon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const KKAvatar(size: 64),
        const SizedBox(height: 20),
        const Text('Content Being Created!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 12),
        Text(
          format == 'adventure'
              ? "KK's animated adventure for this episode is being produced with premium animation."
              : format == 'audio'
                  ? 'The audio lesson for this episode is being recorded. Check back soon!'
                  : 'The video guide for this episode is being created. Check back soon!',
          style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          format == 'adventure' ? '🎬' : format == 'audio' ? '🎧' : '📺',
          style: const TextStyle(fontSize: 48),
        ),
      ],
    );
  }
}
