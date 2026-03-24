// Screen Time Overlay Widget
// Shows warnings and blocks when screen time limit is approaching or exceeded

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/providers/parental/parental_controls_provider.dart';

/// Screen Time Wrapper Widget
/// Wraps the app content and shows overlay when screen time is limited
class ScreenTimeWrapper extends ConsumerWidget {
  final Widget child;

  const ScreenTimeWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parentalControlsProvider);

    // If parental controls not enabled, just show the child
    if (!state.settings.isEnabled) {
      return child;
    }

    // Show warning or block overlay
    return Stack(
      children: [
        // Main content
        child,

        // Warning overlay (5 minutes remaining)
        if (state.shouldShowTimeWarning && !state.isScreenTimeLimitReached)
          const _TimeWarningBanner(),

        // Block overlay (limit reached)
        if (state.isScreenTimeLimitReached) const _TimeLimitReachedOverlay(),
      ],
    );
  }
}

/// Warning banner shown when 5 minutes remaining
class _TimeWarningBanner extends ConsumerWidget {
  const _TimeWarningBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = ref.watch(remainingTimeStringProvider);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.warningColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.warningColor.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Almost out of time!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      remaining ?? 'A few minutes left',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Dismiss temporarily (will reappear on next check)
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full screen overlay when time limit is reached
class _TimeLimitReachedOverlay extends ConsumerStatefulWidget {
  const _TimeLimitReachedOverlay();

  @override
  ConsumerState<_TimeLimitReachedOverlay> createState() =>
      _TimeLimitReachedOverlayState();
}

class _TimeLimitReachedOverlayState
    extends ConsumerState<_TimeLimitReachedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _fadeAnimation.value,
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: SafeArea(
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Moon icon (time to rest)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bedtime,
                          size: 60,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Time for a Break!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Message
                      Text(
                        "You've used all your learning time for today.\n"
                        'Great job studying! Come back tomorrow.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Parent unlock button
                      OutlinedButton.icon(
                        onPressed: () => _showParentUnlockDialog(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Parent: Extend Time'),
                      ),
                      const SizedBox(height: 16),

                      // Info text
                      Text(
                        'Ask a parent to extend your time',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showParentUnlockDialog(BuildContext context) {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Parent Access'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter parent PIN to extend screen time'),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              decoration: const InputDecoration(
                labelText: 'PIN',
                prefixIcon: Icon(Icons.lock),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final notifier = ref.read(parentalControlsProvider.notifier);
              final result = await notifier.enterParentMode(pinController.text);
              if (!context.mounted) return;
              if (result == PinVerificationResult.success) {
                Navigator.pop(context);
                _showExtendTimeDialog(context);
              } else {
                final message = result == PinVerificationResult.lockedOut
                    ? 'Too many attempts. Please try again later.'
                    : 'Incorrect PIN';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showExtendTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extend Screen Time'),
        content: const Text('How much extra time do you want to add?'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(parentalControlsProvider.notifier).extendScreenTime(15);
              ref.read(parentalControlsProvider.notifier).exitParentMode();
              Navigator.pop(context);
            },
            child: const Text('15 min'),
          ),
          TextButton(
            onPressed: () {
              ref.read(parentalControlsProvider.notifier).extendScreenTime(30);
              ref.read(parentalControlsProvider.notifier).exitParentMode();
              Navigator.pop(context);
            },
            child: const Text('30 min'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(parentalControlsProvider.notifier).extendScreenTime(60);
              ref.read(parentalControlsProvider.notifier).exitParentMode();
              Navigator.pop(context);
            },
            child: const Text('1 hour'),
          ),
        ],
      ),
    );
  }
}

/// Screen time indicator widget for app bar or status area
class ScreenTimeIndicator extends ConsumerWidget {
  const ScreenTimeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parentalControlsProvider);
    final remaining = ref.watch(remainingTimeStringProvider);

    // Don't show if parental controls disabled or no time limit
    if (!state.settings.isEnabled ||
        !state.settings.screenTimeLimit.hasLimit ||
        !state.settings.showTimerToChild) {
      return const SizedBox.shrink();
    }

    final remainingMinutes = state.remainingMinutes;
    Color color;
    if (remainingMinutes <= 5) {
      color = AppTheme.errorColor;
    } else if (remainingMinutes <= 15) {
      color = AppTheme.warningColor;
    } else {
      color = AppTheme.successColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            remaining ?? '',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
