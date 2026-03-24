/// UI Enhancement utilities for polished user experience
library;

import 'package:flutter/material.dart';

/// Animation durations for consistent timing across the app
class AnimationDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration verySlow = Duration(milliseconds: 500);

  /// Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// Dialog animation duration
  static const Duration dialog = Duration(milliseconds: 250);

  /// Bottom sheet animation duration
  static const Duration bottomSheet = Duration(milliseconds: 300);
}

/// Animation curves for smooth transitions
class AnimationCurves {
  /// Default ease curve
  static const Curve ease = Curves.easeInOut;

  /// Ease in curve
  static const Curve easeIn = Curves.easeIn;

  /// Ease out curve
  static const Curve easeOut = Curves.easeOut;

  /// Bounce effect
  static const Curve bounce = Curves.bounceOut;

  /// Elastic effect
  static const Curve elastic = Curves.elasticOut;

  /// Fast out slow in (Material Design standard)
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Emphasized curve (Material Design 3)
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
}

/// Shadow elevations for consistent depth
class ShadowElevations {
  /// No elevation
  static const double none = 0.0;

  /// Subtle elevation (1dp)
  static const double subtle = 1.0;

  /// Low elevation (2dp)
  static const double low = 2.0;

  /// Medium elevation (4dp)
  static const double medium = 4.0;

  /// High elevation (8dp)
  static const double high = 8.0;

  /// Very high elevation (16dp)
  static const double veryHigh = 16.0;

  /// Modal elevation (24dp)
  static const double modal = 24.0;
}

/// Custom shadows for enhanced visuals
class CustomShadows {
  /// Soft shadow for cards
  static List<BoxShadow> cardShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Elevated shadow for floating elements
  static List<BoxShadow> elevatedShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Subtle glow effect
  static List<BoxShadow> glowEffect(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 0),
        ),
      ];

  /// Bottom navigation shadow
  static List<BoxShadow> bottomNavShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ];
}

/// Gradient helpers for visual interest
class GradientHelpers {
  /// Create a shimmer gradient for loading states
  static LinearGradient shimmerGradient(Color baseColor) {
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.6),
        baseColor.withValues(alpha: 0.3),
        baseColor.withValues(alpha: 0.6),
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Create a subtle gradient overlay
  static LinearGradient subtleOverlay(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.05),
      ],
    );
  }

  /// Create a vibrant gradient
  static LinearGradient vibrantGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [startColor, endColor],
    );
  }
}

/// Interactive feedback helpers
class InteractiveFeedback {
  /// Create a ripple effect configuration
  static Color rippleColor(Color baseColor) {
    return baseColor.withValues(alpha: 0.12);
  }

  /// Create a highlight color for hover states
  static Color hoverColor(Color baseColor) {
    return baseColor.withValues(alpha: 0.08);
  }

  /// Create a splash color for pressed states
  static Color splashColor(Color baseColor) {
    return baseColor.withValues(alpha: 0.15);
  }

  /// Create a focus color for accessibility
  static Color focusColor(Color baseColor) {
    return baseColor.withValues(alpha: 0.12);
  }
}

/// Border and outline helpers
class BorderHelpers {
  /// Create a subtle border
  static Border subtleBorder(Color color) {
    return Border.all(
      color: color.withValues(alpha: 0.12),
      width: 1.0,
    );
  }

  /// Create a prominent border
  static Border prominentBorder(Color color) {
    return Border.all(
      color: color.withValues(alpha: 0.24),
      width: 1.5,
    );
  }

  /// Create a dashed border
  static BoxDecoration dashedBorder({
    required Color color,
    double width = 1.0,
    double dashLength = 5.0,
    double dashGap = 3.0,
  }) {
    return BoxDecoration(
      border: Border.all(color: color.withValues(alpha: 0.3), width: width),
      borderRadius: BorderRadius.circular(8),
    );
  }
}

/// Animated widgets helpers
class AnimatedWidgets {
  /// Create a fade transition
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Create a scale transition
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Create a slide transition
  static Widget slideTransition({
    required Widget child,
    required Animation<Offset> animation,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }

  /// Create a combined fade and scale transition
  static Widget fadeScaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: AnimationCurves.emphasized,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Loading state helpers
class LoadingHelpers {
  /// Create a shimmer loading placeholder
  static Widget shimmerPlaceholder({
    required double width,
    required double height,
    required Color baseColor,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: GradientHelpers.shimmerGradient(baseColor),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }

  /// Create a skeleton loader
  static Widget skeletonLoader({
    required Widget child,
    required bool isLoading,
    required Color baseColor,
  }) {
    if (!isLoading) return child;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            baseColor.withValues(alpha: 0.3),
            baseColor.withValues(alpha: 0.1),
            baseColor.withValues(alpha: 0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

/// Empty state helpers
class EmptyStateHelpers {
  /// Create a standard empty state widget
  static Widget createEmptyState({
    required IconData icon,
    required String title,
    required String message,
    required ThemeData theme,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action,
            ],
          ],
        ),
      ),
    );
  }
}

/// Accessibility helpers
class AccessibilityHelpers {
  /// Create a semantic label for better screen reader support
  static String createSemanticLabel({
    required String label,
    String? hint,
    String? value,
  }) {
    final parts = <String>[label];
    if (value != null) parts.add(value);
    if (hint != null) parts.add(hint);
    return parts.join(', ');
  }

  /// Check if text scaling is within recommended bounds
  static bool isTextScaleReasonable(double scale) {
    return scale >= 0.8 && scale <= 1.5;
  }

  /// Get minimum touch target size for accessibility
  static const double minTouchTarget = 48.0;

  /// Ensure widget meets minimum touch target
  static Widget ensureTouchTarget({
    required Widget child,
    double minSize = minTouchTarget,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: child,
    );
  }
}

/// Color manipulation helpers
class ColorHelpers {
  /// Lighten a color by a percentage
  static Color lighten(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + percentage).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Darken a color by a percentage
  static Color darken(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - percentage).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Adjust color saturation
  static Color saturate(Color color, double percentage) {
    assert(percentage >= -1 && percentage <= 1);
    final hsl = HSLColor.fromColor(color);
    final saturation = (hsl.saturation + percentage).clamp(0.0, 1.0);
    return hsl.withSaturation(saturation).toColor();
  }
}
