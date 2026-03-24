import 'package:flutter/services.dart';

/// Service for providing haptic feedback
///
/// Provides tactile feedback for user interactions to enhance
/// the user experience with physical responses to actions.
class HapticService {
  /// Trigger success haptic feedback
  ///
  /// Use when the user successfully completes an action
  /// (e.g., completing a quiz, finishing a video)
  static void success({bool heavy = false}) {
    if (heavy) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Trigger selection haptic feedback
  ///
  /// Use for UI selections and taps (e.g., selecting an answer, tapping a button)
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Trigger error haptic feedback
  ///
  /// Use when the user encounters an error or invalid action
  static void error() {
    HapticFeedback.mediumImpact();
  }

  /// Trigger light haptic feedback
  ///
  /// Use for subtle UI feedback (e.g., scrolling through items)
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Trigger vibration for important events
  ///
  /// Use sparingly for milestone achievements or critical notifications
  static void vibrate() {
    HapticFeedback.vibrate();
  }
}
