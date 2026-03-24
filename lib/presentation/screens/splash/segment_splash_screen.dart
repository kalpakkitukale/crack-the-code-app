// Segment-Specific Splash Screen
// Shows appropriate branding and animation based on segment

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Segment-aware splash screen with animated branding
class SegmentSplashScreen extends StatefulWidget {
  const SegmentSplashScreen({super.key});

  @override
  State<SegmentSplashScreen> createState() => _SegmentSplashScreenState();
}

class _SegmentSplashScreenState extends State<SegmentSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate after animation completes
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_complete') ?? false;
    final hasCompletedGradeSelection = prefs.getBool('grade_selection_complete') ?? false;

    // Check if user has completed onboarding (for first-time users)
    if (!hasCompletedOnboarding) {
      if (mounted) context.go('/onboarding');
      return;
    }

    // Check Firebase authentication state
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final isAuthenticated = firebaseUser != null;

    // If not authenticated, go to login
    if (!isAuthenticated) {
      if (mounted) context.go('/login');
      return;
    }

    // For Junior segment, check if grade selection is complete
    if (SegmentConfig.current == AppSegment.crackTheCode) {
      if (!hasCompletedGradeSelection) {
        if (mounted) context.go('/grade-selection');
        return;
      }
    }

    // For Spelling segment, check if grade selection is complete
    if (SegmentConfig.isCrackTheCode) {
      if (!hasCompletedGradeSelection) {
        if (mounted) context.go('/grade-selection');
        return;
      }
    }

    // All checks passed, go to home
    if (mounted) {
      if (SegmentConfig.isCrackTheCode) {
        context.go(RouteConstants.spellingHome);
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final segment = SegmentConfig.current;
    final splashConfig = _getSplashConfig(segment);

    return Scaffold(
      backgroundColor: splashConfig.backgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with scale animation
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildLogo(splashConfig),
                ),

                const SizedBox(height: 24),

                // App name with fade animation
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    splashConfig.appName,
                    style: TextStyle(
                      color: splashConfig.textColor,
                      fontSize: splashConfig.titleFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline with fade animation
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Text(
                    splashConfig.tagline,
                    style: TextStyle(
                      color: splashConfig.textColor.withValues(alpha: 0.8),
                      fontSize: splashConfig.taglineFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Loading indicator for Junior/Spelling (more playful)
                if (segment == AppSegment.crackTheCode || segment == AppSegment.crackTheCode) ...[
                  const SizedBox(height: 48),
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildJuniorLoadingIndicator(splashConfig),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo(SplashConfig config) {
    final segment = SegmentConfig.current;

    if (segment == AppSegment.crackTheCode) {
      // Playful logo for Junior with gradient background
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              config.primaryColor,
              config.secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: config.primaryColor.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.school_rounded,
            size: 72,
            color: Colors.white,
          ),
        ),
      );
    }

    // Standard logo for other segments
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: config.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: config.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _getLogoIcon(segment),
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _getLogoIcon(AppSegment segment) {
    switch (segment) {
      case AppSegment.crackTheCode:
        return Icons.school_rounded;
      case AppSegment.crackTheCode:
        return Icons.menu_book_rounded;
      case AppSegment.crackTheCode:
        return Icons.assignment_rounded;
      case AppSegment.crackTheCode:
        return Icons.auto_stories_rounded;
      case AppSegment.crackTheCode:
        return Icons.spellcheck_rounded;
    }
  }

  Widget _buildJuniorLoadingIndicator(SplashConfig config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 200)),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: config.primaryColor.withValues(alpha: 0.3 + (value * 0.7)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }

  SplashConfig _getSplashConfig(AppSegment segment) {
    switch (segment) {
      case AppSegment.crackTheCode:
        return SplashConfig(
          backgroundColor: const Color(0xFF4A90E2), // Bright blue
          primaryColor: const Color(0xFFFFD93D), // Happy yellow
          secondaryColor: const Color(0xFFFF6B9D), // Playful pink
          textColor: Colors.white,
          appName: 'Crack the Code',
          tagline: 'Learning is fun!',
          titleFontSize: 28,
          taglineFontSize: 16,
        );

      case AppSegment.crackTheCode:
        return SplashConfig(
          backgroundColor: const Color(0xFF2C3E50), // Dark blue-gray
          primaryColor: const Color(0xFF3498DB), // Bright blue
          secondaryColor: const Color(0xFF2ECC71), // Green
          textColor: Colors.white,
          appName: 'Crack the Code',
          tagline: 'Your learning companion',
          titleFontSize: 26,
          taglineFontSize: 14,
        );

      case AppSegment.crackTheCode:
        return SplashConfig(
          backgroundColor: const Color(0xFF1A1A2E), // Deep navy
          primaryColor: const Color(0xFF6C5CE7), // Purple
          secondaryColor: const Color(0xFF00CEC9), // Teal
          textColor: Colors.white,
          appName: 'Crack the Code',
          tagline: 'Ace your boards',
          titleFontSize: 24,
          taglineFontSize: 14,
        );

      case AppSegment.crackTheCode:
        return SplashConfig(
          backgroundColor: const Color(0xFF0D1B2A), // Dark navy
          primaryColor: AppTheme.primaryBlue,
          secondaryColor: const Color(0xFF48CAE4), // Light blue
          textColor: Colors.white,
          appName: 'Crack the Code',
          tagline: 'Master your subjects',
          titleFontSize: 26,
          taglineFontSize: 14,
        );

      case AppSegment.crackTheCode:
        return SplashConfig(
          backgroundColor: const Color(0xFF1B5E20), // Deep green
          primaryColor: const Color(0xFF66BB6A), // Green
          secondaryColor: const Color(0xFFFFD54F), // Amber
          textColor: Colors.white,
          appName: 'Crack the Code',
          tagline: 'Master every word!',
          titleFontSize: 28,
          taglineFontSize: 16,
        );
    }
  }
}

/// Configuration for splash screen appearance
class SplashConfig {
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final String appName;
  final String tagline;
  final double titleFontSize;
  final double taglineFontSize;

  const SplashConfig({
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.appName,
    required this.tagline,
    required this.titleFontSize,
    required this.taglineFontSize,
  });
}
