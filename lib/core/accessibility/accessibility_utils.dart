// Accessibility Utilities
// Provides accessibility helpers for all segments with enhanced support for Junior

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:streamshaala/core/config/segment_config.dart';

/// Accessibility configuration based on segment
class AccessibilityConfig {
  /// Get current accessibility settings based on segment
  static AccessibilitySettings get settings {
    final segment = SegmentConfig.current;

    switch (segment) {
      case AppSegment.junior:
      case AppSegment.spelling:
        return const AccessibilitySettings(
          // Junior/Spelling gets enhanced accessibility for younger users
          minTouchTargetSize: 48.0,
          focusHighlightWidth: 3.0,
          announceNavigationChanges: true,
          useSimpleLanguage: true,
          enableHapticFeedback: true,
          enableSoundEffects: true,
          textScaleFactor: 1.1,
        );
      case AppSegment.middle:
        return const AccessibilitySettings(
          minTouchTargetSize: 44.0,
          focusHighlightWidth: 2.0,
          announceNavigationChanges: true,
          useSimpleLanguage: false,
          enableHapticFeedback: true,
          enableSoundEffects: false,
          textScaleFactor: 1.0,
        );
      case AppSegment.preboard:
      case AppSegment.senior:
        return const AccessibilitySettings(
          minTouchTargetSize: 44.0,
          focusHighlightWidth: 2.0,
          announceNavigationChanges: false,
          useSimpleLanguage: false,
          enableHapticFeedback: false,
          enableSoundEffects: false,
          textScaleFactor: 1.0,
        );
    }
  }
}

/// Segment-specific accessibility settings
class AccessibilitySettings {
  final double minTouchTargetSize;
  final double focusHighlightWidth;
  final bool announceNavigationChanges;
  final bool useSimpleLanguage;
  final bool enableHapticFeedback;
  final bool enableSoundEffects;
  final double textScaleFactor;

  const AccessibilitySettings({
    required this.minTouchTargetSize,
    required this.focusHighlightWidth,
    required this.announceNavigationChanges,
    required this.useSimpleLanguage,
    required this.enableHapticFeedback,
    required this.enableSoundEffects,
    required this.textScaleFactor,
  });
}

/// Accessibility helper methods
class A11y {
  /// Wrap a widget with semantic label for screen readers
  static Widget semanticLabel({
    required Widget child,
    required String label,
    String? hint,
    bool isButton = false,
    bool isHeader = false,
    bool excludeSemantics = false,
    VoidCallback? onTap,
  }) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      onTap: onTap,
      child: child,
    );
  }

  /// Create accessible button wrapper
  static Widget accessibleButton({
    required Widget child,
    required String label,
    required VoidCallback onPressed,
    String? hint,
    bool enabled = true,
  }) {
    final settings = AccessibilityConfig.settings;

    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: settings.minTouchTargetSize,
          minHeight: settings.minTouchTargetSize,
        ),
        child: child,
      ),
    );
  }

  /// Create accessible icon with label
  static Widget accessibleIcon({
    required IconData icon,
    required String label,
    double? size,
    Color? color,
  }) {
    return Semantics(
      label: label,
      child: Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: label,
      ),
    );
  }

  /// Announce message to screen reader
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Get simplified text for Junior segment
  static String simplifyText(String text, String simpleVersion) {
    final settings = AccessibilityConfig.settings;
    return settings.useSimpleLanguage ? simpleVersion : text;
  }

  /// Create focus node with visible focus indicator for Junior
  static FocusNode createFocusNode({String? debugLabel}) {
    return FocusNode(debugLabel: debugLabel);
  }
}

/// Accessible tap target wrapper
/// Ensures minimum touch target size for accessibility
class AccessibleTapTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? semanticHint;

  const AccessibleTapTarget({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    final settings = AccessibilityConfig.settings;
    final minSize = settings.minTouchTargetSize;

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: onTap != null,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minSize,
            minHeight: minSize,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Focus highlight wrapper for keyboard navigation
class FocusHighlight extends StatefulWidget {
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;
  final VoidCallback? onFocusChange;

  const FocusHighlight({
    super.key,
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
  });

  @override
  State<FocusHighlight> createState() => _FocusHighlightState();
}

class _FocusHighlightState extends State<FocusHighlight> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
    widget.onFocusChange?.call();
  }

  @override
  Widget build(BuildContext context) {
    final settings = AccessibilityConfig.settings;
    final theme = Theme.of(context);

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: _hasFocus
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: settings.focusHighlightWidth,
                ),
              )
            : null,
        child: widget.child,
      ),
    );
  }
}

/// Screen reader announcement helper
class ScreenReaderAnnouncement {
  /// Announce navigation to new screen
  static void announceScreenChange(BuildContext context, String screenName) {
    final settings = AccessibilityConfig.settings;
    if (settings.announceNavigationChanges) {
      A11y.announce(context, 'Navigated to $screenName');
    }
  }

  /// Announce action completion
  static void announceAction(BuildContext context, String action) {
    A11y.announce(context, action);
  }

  /// Announce error
  static void announceError(BuildContext context, String error) {
    A11y.announce(context, 'Error: $error');
  }

  /// Announce success for Junior (with encouraging language)
  static void announceSuccess(BuildContext context, String message) {
    final settings = AccessibilityConfig.settings;
    final announcement = settings.useSimpleLanguage
        ? 'Great job! $message'
        : message;
    A11y.announce(context, announcement);
  }
}

/// Extension for adding accessibility to existing widgets
extension AccessibilityExtension on Widget {
  /// Add semantic label to widget
  Widget withSemantics({
    required String label,
    String? hint,
    bool isButton = false,
    bool isHeader = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      child: this,
    );
  }

  /// Ensure minimum touch target size
  Widget withMinTouchTarget() {
    final settings = AccessibilityConfig.settings;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: settings.minTouchTargetSize,
        minHeight: settings.minTouchTargetSize,
      ),
      child: this,
    );
  }

  /// Exclude from semantics tree
  Widget excludeFromSemantics() {
    return ExcludeSemantics(child: this);
  }
}

/// Color contrast utilities for WCAG compliance
class ColorContrast {
  /// WCAG AA minimum contrast ratio for normal text (4.5:1)
  static const double wcagAANormalText = 4.5;

  /// WCAG AA minimum contrast ratio for large text (3:1)
  static const double wcagAALargeText = 3.0;

  /// WCAG AAA minimum contrast ratio for normal text (7:1)
  static const double wcagAAANormalText = 7.0;

  /// WCAG AAA minimum contrast ratio for large text (4.5:1)
  static const double wcagAAALargeText = 4.5;

  /// Calculate relative luminance of a color (WCAG formula)
  static double relativeLuminance(Color color) {
    double r = color.r / 255;
    double g = color.g / 255;
    double b = color.b / 255;

    r = r <= 0.03928 ? r / 12.92 : math.pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = g <= 0.03928 ? g / 12.92 : math.pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = b <= 0.03928 ? b / 12.92 : math.pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors
  static double contrastRatio(Color foreground, Color background) {
    final l1 = relativeLuminance(foreground);
    final l2 = relativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if colors meet WCAG AA contrast for normal text
  static bool meetsWcagAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= wcagAANormalText;
  }

  /// Check if colors meet WCAG AA contrast for large text (18pt+ or 14pt bold)
  static bool meetsWcagAALargeText(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= wcagAALargeText;
  }

  /// Check if colors meet WCAG AAA contrast for normal text
  static bool meetsWcagAAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= wcagAAANormalText;
  }

  /// Get a color that ensures WCAG AA contrast with background
  /// Returns the preferred color if it meets contrast, otherwise adjusts
  static Color ensureContrast(
    Color preferredColor,
    Color background, {
    double minRatio = wcagAANormalText,
  }) {
    if (contrastRatio(preferredColor, background) >= minRatio) {
      return preferredColor;
    }

    // Determine if we need lighter or darker color
    final bgLuminance = relativeLuminance(background);
    final needsDarker = bgLuminance > 0.5;

    // Adjust color by increasing/decreasing brightness
    HSLColor hsl = HSLColor.fromColor(preferredColor);
    double step = 0.05;
    int maxIterations = 20;

    for (int i = 0; i < maxIterations; i++) {
      final newLightness = needsDarker
          ? (hsl.lightness - step * i).clamp(0.0, 1.0)
          : (hsl.lightness + step * i).clamp(0.0, 1.0);

      final adjusted = hsl.withLightness(newLightness).toColor();
      if (contrastRatio(adjusted, background) >= minRatio) {
        return adjusted;
      }
    }

    // Fallback to black or white
    return needsDarker ? Colors.black : Colors.white;
  }

  /// Get the best text color (black or white) for a background
  static Color textColorFor(Color background) {
    final luminance = relativeLuminance(background);
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Debug helper to check contrast ratio and log warnings
  static void debugCheckContrast(
    String context,
    Color foreground,
    Color background,
  ) {
    final ratio = contrastRatio(foreground, background);
    final meetsAA = ratio >= wcagAANormalText;

    if (!meetsAA) {
      debugPrint(
        'WARNING: $context has contrast ratio $ratio '
        '(WCAG AA requires $wcagAANormalText)',
      );
    }
  }
}

/// Accessibility labels for common UI elements
class A11yLabels {
  // Navigation
  static const String backButton = 'Go back';
  static const String homeButton = 'Go to home';
  static const String menuButton = 'Open menu';
  static const String closeButton = 'Close';
  static const String searchButton = 'Search';

  // Video player
  static const String playButton = 'Play video';
  static const String pauseButton = 'Pause video';
  static const String fullscreenButton = 'Enter fullscreen';
  static const String exitFullscreenButton = 'Exit fullscreen';
  static const String muteButton = 'Mute sound';
  static const String unmuteButton = 'Unmute sound';

  // Quiz
  static const String nextQuestion = 'Go to next question';
  static const String previousQuestion = 'Go to previous question';
  static const String submitQuiz = 'Submit your answers';
  static const String correctAnswer = 'Correct answer';
  static const String incorrectAnswer = 'Incorrect answer';

  // Gamification (Junior)
  static const String streakCount = 'Your learning streak';
  static const String xpPoints = 'Experience points earned';
  static const String levelProgress = 'Your current level progress';
  static const String badge = 'Achievement badge';
  static const String badgeLocked = 'Badge not yet earned';
  static const String badgeUnlocked = 'Badge earned';

  // Content
  static const String videoCard = 'Video lesson';
  static const String subjectCard = 'Subject';
  static const String chapterCard = 'Chapter';
  static const String quizCard = 'Practice quiz';

  // Actions
  static const String bookmark = 'Bookmark this video';
  static const String removeBookmark = 'Remove bookmark';
  static const String share = 'Share';
  static const String download = 'Download for offline';

  // Junior-specific simplified labels
  static String forJunior(String standard, String simple) {
    return AccessibilityConfig.settings.useSimpleLanguage ? simple : standard;
  }
}
