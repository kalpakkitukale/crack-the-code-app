import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/widgets/coin_counter.dart';

class GamesHubScreen extends ConsumerWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0618),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey ${profile.nickname}! 👋',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'What shall we play today?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0x99FFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CoinCounter(),
                  ],
                ),
              ),
            ),

            // Games Grid
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildListDelegate([
                  _GameCard(
                    title: 'Sound Board',
                    subtitle: 'Tap & Hear All Sounds',
                    icon: '🔊',
                    color: const Color(0xFFE57373),
                    isFree: true,
                    onTap: () => _showComingSoon(context, 'Sound Board'),
                  ),
                  _GameCard(
                    title: 'Sound Quest',
                    subtitle: '7 Worlds · 560 Levels',
                    icon: '🗺️',
                    color: const Color(0xFF4CAF50),
                    isFree: true,
                    onTap: () => _showComingSoon(context, 'Sound Quest'),
                  ),
                  _GameCard(
                    title: 'Rule Master',
                    subtitle: '38 Rules · 44 Puzzles',
                    icon: '🧩',
                    color: const Color(0xFF2196F3),
                    isFree: true,
                    onTap: () => _showComingSoon(context, 'Rule Master'),
                  ),
                  _GameCard(
                    title: 'Word Crusher',
                    subtitle: 'Match-3 Spelling',
                    icon: '💎',
                    color: const Color(0xFF9C27B0),
                    isFree: true,
                    onTap: () => _showComingSoon(context, 'Word Crusher'),
                  ),
                  _GameCard(
                    title: 'Rule Runner',
                    subtitle: 'Endless Runner',
                    icon: '🏃',
                    color: const Color(0xFFFF9800),
                    isFree: true,
                    onTap: () => _showComingSoon(context, 'Rule Runner'),
                  ),
                  _GameCard(
                    title: 'Daily Decoder',
                    subtitle: 'New Puzzle Every Day!',
                    icon: '📅',
                    color: const Color(0xFFFFD700),
                    isFree: true,
                    onTap: () => _showComingSoon(context, 'Daily Decoder'),
                  ),
                ]),
              ),
            ),

            // Classroom Arena (full width)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _GameCard(
                  title: 'Classroom Arena',
                  subtitle: 'Host or Join · Up to 40 Players',
                  icon: '🏟️',
                  color: const Color(0xFF00BCD4),
                  isFree: true,
                  isWide: true,
                  onTap: () => _showComingSoon(context, 'Classroom Arena'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String gameName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$gameName — Coming soon!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final bool isFree;
  final bool isWide;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isFree = false,
    this.isWide = false,
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
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 32)),
                const Spacer(),
                if (isFree)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'FREE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4CAF50),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),
            if (!isWide) const Spacer(),
            if (isWide) const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isWide ? 18 : 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isWide ? 13 : 12,
                color: color.withValues(alpha: 0.7),
              ),
            ),
            if (!isWide) ...[
              const SizedBox(height: 8),
              // Progress bar placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0,
                  minHeight: 4,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
