import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/widgets/phonogram_tile_widget.dart';
import 'package:crack_the_code/games/sound_board/providers/sound_board_providers.dart';

class TodaySoundCard extends ConsumerWidget {
  final void Function(String phonogramId) onPhonogramTapped;

  const TodaySoundCard({super.key, required this.onPhonogramTapped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggested = ref.watch(todaySuggestedPhonogramProvider);
    final progress = ref.watch(soundBoardProgressProvider);

    if (suggested == null) {
      return _buildCard(
        color: const Color(0xFFFFD700),
        child: const Center(
          child: Text(
            'All sounds discovered! You\'re amazing! 🎉',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
      );
    }

    final isNew = !progress.isExplored(suggested.id);

    return _buildCard(
      color: suggested.color,
      child: Row(
        children: [
          PhonogramTileWidget(
            phonogram: suggested,
            size: 80,
            isGreyedOut: false,
            onTap: () => onPhonogramTapped(suggested.id),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isNew ? "TODAY'S DISCOVERY" : "PRACTICE THIS SOUND",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: suggested.color,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isNew
                      ? 'Tap to discover ${suggested.text}!'
                      : 'Keep practicing ${suggested.text}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (isNew) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${suggested.soundCount} sound${suggested.soundCount > 1 ? "s" : ""} to explore',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }

  Widget _buildCard({required Color color, required Widget child}) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}
