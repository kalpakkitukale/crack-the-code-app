// Celebration Overlay Widget
// Fun, playful celebration animations for Junior segment achievements

import 'dart:math' as math;
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/services/feedback_service.dart';
import 'package:streamshaala/domain/entities/gamification/badge.dart';
import 'package:streamshaala/presentation/providers/gamification/gamification_provider.dart';

/// Celebration Wrapper Widget
/// Wraps content and shows celebration overlays for level-ups and achievements
class CelebrationWrapper extends ConsumerWidget {
  final Widget child;

  const CelebrationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamificationState = ref.watch(gamificationProvider);
    final settings = SegmentConfig.settings;

    return Stack(
      children: [
        // Main content
        child,

        // Level-up celebration (only for Junior)
        if (gamificationState.showLevelUpAnimation &&
            settings.gamificationIntensity == GamificationIntensity.high)
          LevelUpCelebration(
            level: gamificationState.level,
            onDismiss: () {
              ref.read(gamificationProvider.notifier).dismissLevelUpAnimation();
            },
          ),

        // Badge unlock celebration
        if (gamificationState.showBadgeUnlockedDialog &&
            gamificationState.newlyUnlockedBadges?.isNotEmpty == true)
          BadgeUnlockedCelebration(
            badges: gamificationState.newlyUnlockedBadges!,
            onDismiss: () {
              ref.read(gamificationProvider.notifier).dismissBadgeUnlockedDialog();
            },
          ),
      ],
    );
  }
}

/// Level-up celebration with fun animation
class LevelUpCelebration extends StatefulWidget {
  final int level;
  final VoidCallback onDismiss;

  const LevelUpCelebration({
    super.key,
    required this.level,
    required this.onDismiss,
  });

  @override
  State<LevelUpCelebration> createState() => _LevelUpCelebrationState();
}

class _LevelUpCelebrationState extends State<LevelUpCelebration>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;

  final List<_Particle> _particles = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Trigger haptic feedback for level-up celebration
    feedbackService.trigger(FeedbackType.levelUp);

    // Main animation for the level badge
    _mainController = AnimationController(
      duration: Duration(
        milliseconds: SegmentConfig.settings.celebrationAnimationDuration,
      ),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_mainController);

    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Generate particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble() * 2 - 1,
        y: _random.nextDouble() * 2 - 1,
        color: _getParticleColor(i),
        size: _random.nextDouble() * 8 + 4,
        speed: _random.nextDouble() * 0.5 + 0.5,
      ));
    }

    _mainController.forward();
    _particleController.repeat();

    // Auto-dismiss after animation
    Future.delayed(
      Duration(milliseconds: SegmentConfig.settings.celebrationAnimationDuration + 500),
      () {
        if (mounted) widget.onDismiss();
      },
    );
  }

  Color _getParticleColor(int index) {
    final colors = [
      Colors.amber,
      Colors.orange,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            color: Colors.black.withValues(alpha: 0.7 * _fadeAnimation.value),
            child: Stack(
              children: [
                // Particles
                ...List.generate(_particles.length, (index) {
                  final particle = _particles[index];
                  return AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, _) {
                      final progress = _particleController.value;
                      final x = particle.x * 200 * progress * particle.speed;
                      final y = particle.y * 200 * progress * particle.speed - 50;

                      return Positioned(
                        left: MediaQuery.of(context).size.width / 2 + x,
                        top: MediaQuery.of(context).size.height / 2 + y,
                        child: Opacity(
                          opacity: (1 - progress).clamp(0.0, 1.0),
                          child: Container(
                            width: particle.size,
                            height: particle.size,
                            decoration: BoxDecoration(
                              color: particle.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Main content
                Center(
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Star burst
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.amber.withValues(alpha: 0.8),
                                  Colors.orange.withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withValues(alpha: 0.6),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    Text(
                                      '${widget.level}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Text
                          Text(
                            'LEVEL UP!',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You reached Level ${widget.level}!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tap to dismiss
                Positioned.fill(
                  child: GestureDetector(
                    onTap: widget.onDismiss,
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speed;

  _Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
  });
}

/// Badge unlock celebration
class BadgeUnlockedCelebration extends StatefulWidget {
  final List<Badge> badges;
  final VoidCallback onDismiss;

  const BadgeUnlockedCelebration({
    super.key,
    required this.badges,
    required this.onDismiss,
  });

  @override
  State<BadgeUnlockedCelebration> createState() => _BadgeUnlockedCelebrationState();
}

class _BadgeUnlockedCelebrationState extends State<BadgeUnlockedCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Trigger haptic feedback for badge unlock celebration
    feedbackService.trigger(FeedbackType.badgeUnlock);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = widget.badges.first;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            color: Colors.black.withValues(alpha: 0.8),
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge icon with glow
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade300,
                              Colors.purple.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.military_tech,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Badge Unlocked!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Badge name
                      Text(
                        badge.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        badge.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Continue button
                      FilledButton(
                        onPressed: widget.onDismiss,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: const Size(150, 48),
                        ),
                        child: const Text('Awesome!'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// XP Gain Toast - shows briefly when XP is earned
class XpGainToast extends StatefulWidget {
  final int xpAmount;
  final String? reason;

  const XpGainToast({
    super.key,
    required this.xpAmount,
    this.reason,
  });

  @override
  State<XpGainToast> createState() => _XpGainToastState();
}

class _XpGainToastState extends State<XpGainToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                '+${widget.xpAmount} XP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.reason != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.reason!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Show XP gain toast as overlay
void showXpGainToast(BuildContext context, int xpAmount, {String? reason}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: XpGainToast(xpAmount: xpAmount, reason: reason),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // Remove after delay
  Future.delayed(const Duration(seconds: 2), () {
    entry.remove();
  });
}
