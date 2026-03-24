import 'package:flutter/material.dart';
import 'package:crack_the_code/core/config/segment_config.dart';

class SpellingOnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SpellingOnboardingScreen(
      {super.key, required this.onComplete});

  @override
  State<SpellingOnboardingScreen> createState() =>
      _SpellingOnboardingScreenState();
}

class _SpellingOnboardingScreenState
    extends State<SpellingOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.abc,
      title: 'Welcome, Speller!',
      subtitle:
          'Learn to spell hundreds of English words with fun activities',
      color: Color(0xFFFF6B35),
      emoji: 'A B C',
    ),
    _OnboardingPage(
      icon: Icons.mic,
      title: 'Hear & Spell',
      subtitle:
          'Listen to words and type their spelling. Practice makes perfect!',
      color: Color(0xFF2EC4B6),
      emoji: 'C-A-T',
    ),
    _OnboardingPage(
      icon: Icons.emoji_events,
      title: 'Spelling Bee',
      subtitle:
          'Challenge yourself in exciting spelling bee competitions!',
      color: Color(0xFFFFD700),
      emoji: 'CHAMPION',
    ),
    _OnboardingPage(
      icon: Icons.star,
      title: 'Become a Spelling Star!',
      subtitle:
          'Earn badges, build streaks, and master new words every day',
      color: Color(0xFF9B59B6),
      emoji: 'YOU GOT THIS!',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onComplete,
                child: const Text('Skip'),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) => _pages[index],
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline
                            .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration:
                            const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      widget.onComplete();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _pages[_currentPage].color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1
                        ? 'Next'
                        : SegmentConfig
                            .settings.onboardingButtonText,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String emoji;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with colored circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 70, color: color),
          ),

          const SizedBox(height: 24),

          // Styled text display
          Text(
            emoji,
            style:
                theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style:
                theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface
                  .withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
