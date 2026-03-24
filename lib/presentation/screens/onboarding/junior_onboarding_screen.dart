// Junior Onboarding Screen
// Playful, engaging onboarding experience for younger students (Grades 1-7)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Junior onboarding page data model
class _JuniorOnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String encouragement;

  const _JuniorOnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.encouragement,
  });
}

/// Junior Onboarding Screen
/// Designed for younger students with larger elements and playful animations
class JuniorOnboardingScreen extends ConsumerStatefulWidget {
  const JuniorOnboardingScreen({super.key});

  @override
  ConsumerState<JuniorOnboardingScreen> createState() =>
      _JuniorOnboardingScreenState();
}

class _JuniorOnboardingScreenState
    extends ConsumerState<JuniorOnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  /// Junior-friendly onboarding pages
  static const List<_JuniorOnboardingPage> _pages = [
    _JuniorOnboardingPage(
      title: 'Welcome, Explorer!',
      subtitle: 'Get ready for an amazing learning adventure!',
      icon: Icons.rocket_launch,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFFA5B4FC),
      encouragement: 'Let\'s go!',
    ),
    _JuniorOnboardingPage(
      title: 'Watch Fun Videos',
      subtitle: 'Learn cool stuff with videos made just for you!',
      icon: Icons.play_circle_filled,
      primaryColor: Color(0xFF22C55E),
      secondaryColor: Color(0xFF86EFAC),
      encouragement: 'So exciting!',
    ),
    _JuniorOnboardingPage(
      title: 'Take Fun Quizzes',
      subtitle: 'Test what you learned and earn awesome stars!',
      icon: Icons.star,
      primaryColor: Color(0xFFF59E0B),
      secondaryColor: Color(0xFFFDE68A),
      encouragement: 'You\'re a star!',
    ),
    _JuniorOnboardingPage(
      title: 'Become a Champion!',
      subtitle: 'Earn badges and show off your superpowers!',
      icon: Icons.emoji_events,
      primaryColor: Color(0xFFEC4899),
      secondaryColor: Color(0xFFFBCFE8),
      encouragement: 'Let\'s start!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    await ref.read(userProfileProvider.notifier).completeOnboarding();
    if (mounted) {
      // Navigate to grade selection for Junior
      context.go('/grade-selection');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    final currentPageData = _pages[_currentPage];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentPageData.primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button (hidden on last page)
              SizedBox(
                height: 48,
                child: !isLastPage
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: TextButton(
                            onPressed: _completeOnboarding,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: currentPageData.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index], index == _currentPage);
                  },
                ),
              ),

              // Bottom section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Page indicator with fun styling
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: WormEffect(
                        activeDotColor: currentPageData.primaryColor,
                        dotColor: currentPageData.secondaryColor,
                        dotHeight: 12,
                        dotWidth: 12,
                        spacing: 12,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Navigation button with bounce animation
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, isLastPage ? -_bounceAnimation.value : 0),
                          child: child,
                        );
                      },
                      child: FilledButton(
                        onPressed: _nextPage,
                        style: FilledButton.styleFrom(
                          backgroundColor: currentPageData.primaryColor,
                          minimumSize: const Size(double.infinity, 64),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLastPage
                                  ? currentPageData.encouragement
                                  : 'Next',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              isLastPage
                                  ? Icons.celebration
                                  : Icons.arrow_forward,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_JuniorOnboardingPage page, bool isCurrent) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isCurrent ? 1.0 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: isCurrent ? scale : 0.8,
                  child: child,
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: page.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: page.primaryColor.withValues(alpha: 0.3),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Icon(
                    page.icon,
                    size: 90,
                    color: page.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Title with fun styling
            Text(
              page.title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: page.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Subtitle
            Text(
              page.subtitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
