// Feedback Service
// Provides sound effects, haptic feedback, and toast notifications
// for gamification elements and user interactions.
// Especially important for Junior segment engagement

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/accessibility/accessibility_utils.dart';
import 'package:crack_the_code/core/widgets/toast/toast_notification.dart';

/// Feedback types for different interactions
enum FeedbackType {
  // General interactions
  tap,
  success,
  error,
  warning,

  // Gamification specific
  xpGain,
  levelUp,
  badgeUnlock,
  streakMilestone,
  quizCorrect,
  quizIncorrect,
  quizComplete,

  // Navigation
  pageTransition,
  modalOpen,
  modalClose,
}

/// Feedback intensity levels
enum FeedbackIntensity {
  light,
  medium,
  heavy,
}

/// Feedback Service for haptic and sound feedback
class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  /// Whether feedback is enabled based on segment settings
  bool get _isHapticEnabled => AccessibilityConfig.settings.enableHapticFeedback;
  bool get _isSoundEnabled => AccessibilityConfig.settings.enableSoundEffects;

  /// Trigger feedback for a specific type
  Future<void> trigger(FeedbackType type) async {
    if (!_isHapticEnabled && !_isSoundEnabled) return;

    switch (type) {
      case FeedbackType.tap:
        await _lightImpact();
        break;

      case FeedbackType.success:
        await _successFeedback();
        break;

      case FeedbackType.error:
        await _errorFeedback();
        break;

      case FeedbackType.warning:
        await _warningFeedback();
        break;

      case FeedbackType.xpGain:
        await _xpGainFeedback();
        break;

      case FeedbackType.levelUp:
        await _levelUpFeedback();
        break;

      case FeedbackType.badgeUnlock:
        await _badgeUnlockFeedback();
        break;

      case FeedbackType.streakMilestone:
        await _streakMilestoneFeedback();
        break;

      case FeedbackType.quizCorrect:
        await _quizCorrectFeedback();
        break;

      case FeedbackType.quizIncorrect:
        await _quizIncorrectFeedback();
        break;

      case FeedbackType.quizComplete:
        await _quizCompleteFeedback();
        break;

      case FeedbackType.pageTransition:
        await _lightImpact();
        break;

      case FeedbackType.modalOpen:
        await _mediumImpact();
        break;

      case FeedbackType.modalClose:
        await _lightImpact();
        break;
    }
  }

  /// Light haptic impact
  Future<void> _lightImpact() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Medium haptic impact
  Future<void> _mediumImpact() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Heavy haptic impact
  Future<void> _heavyImpact() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Selection click
  Future<void> _selectionClick() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Success feedback pattern
  Future<void> _successFeedback() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Error feedback pattern
  Future<void> _errorFeedback() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Warning feedback pattern
  Future<void> _warningFeedback() async {
    if (!_isHapticEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// XP gain celebration pattern (Junior segment)
  Future<void> _xpGainFeedback() async {
    if (!_isHapticEnabled) return;

    // Quick light tap for XP gain
    await HapticFeedback.lightImpact();
  }

  /// Level up celebration pattern (Junior segment)
  Future<void> _levelUpFeedback() async {
    if (!_isHapticEnabled) return;

    // Celebratory pattern: heavy - pause - medium - light
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Badge unlock celebration pattern (Junior segment)
  Future<void> _badgeUnlockFeedback() async {
    if (!_isHapticEnabled) return;

    // Exciting pattern for badge unlock
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Streak milestone celebration pattern
  Future<void> _streakMilestoneFeedback() async {
    if (!_isHapticEnabled) return;

    // Pattern for streak achievement
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.lightImpact();
  }

  /// Quiz correct answer feedback
  Future<void> _quizCorrectFeedback() async {
    if (!_isHapticEnabled) return;

    // Positive feedback for correct answer
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// Quiz incorrect answer feedback
  Future<void> _quizIncorrectFeedback() async {
    if (!_isHapticEnabled) return;

    // Gentle negative feedback (not harsh for Junior)
    if (SegmentConfig.isCrackTheCode) {
      // Softer feedback for younger students
      await HapticFeedback.lightImpact();
    } else {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Quiz complete celebration
  Future<void> _quizCompleteFeedback() async {
    if (!_isHapticEnabled) return;

    // Full celebration pattern
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  // ============= Toast Notification Methods =============

  /// Show an info toast notification
  void showInfo(String message, {ToastDuration duration = ToastDuration.medium}) {
    toastManager.info(message, duration: duration);
  }

  /// Show a success toast with haptic feedback
  void showSuccess(String message, {ToastDuration duration = ToastDuration.medium}) {
    trigger(FeedbackType.success);
    toastManager.success(message, duration: duration);
  }

  /// Show a warning toast with haptic feedback
  void showWarning(String message, {ToastDuration duration = ToastDuration.medium}) {
    trigger(FeedbackType.warning);
    toastManager.warning(message, duration: duration);
  }

  /// Show an error toast with haptic feedback
  void showError(String message, {ToastDuration duration = ToastDuration.long}) {
    trigger(FeedbackType.error);
    toastManager.error(message, duration: duration);
  }

  /// Show an undoable action toast
  void showUndoable({
    required String message,
    required VoidCallback onUndo,
  }) {
    toastManager.undoable(message: message, onUndo: onUndo);
  }

  /// Show XP gained toast with celebration feedback
  void showXpGained(int xp) {
    trigger(FeedbackType.xpGain);
    toastManager.success('+$xp XP earned!');
  }

  /// Show level up toast with celebration feedback
  void showLevelUp(int newLevel) {
    trigger(FeedbackType.levelUp);
    toastManager.show(ToastData(
      message: 'Level $newLevel reached!',
      type: ToastType.success,
      duration: ToastDuration.long,
      icon: Icons.emoji_events,
    ));
  }

  /// Show badge unlocked toast with celebration feedback
  void showBadgeUnlocked(String badgeName) {
    trigger(FeedbackType.badgeUnlock);
    toastManager.show(ToastData(
      message: 'Badge Unlocked: $badgeName',
      type: ToastType.success,
      duration: ToastDuration.long,
      icon: Icons.military_tech,
    ));
  }

  /// Show streak milestone toast with celebration feedback
  void showStreakMilestone(int days) {
    trigger(FeedbackType.streakMilestone);
    toastManager.show(ToastData(
      message: '$days day streak!',
      type: ToastType.success,
      duration: ToastDuration.medium,
      icon: Icons.local_fire_department,
    ));
  }
}

/// Global feedback service instance
final feedbackService = FeedbackService();

/// Extension for easy feedback triggering
extension FeedbackExtension on FeedbackType {
  Future<void> trigger() async {
    await feedbackService.trigger(this);
  }
}

/// Mixin for widgets that need feedback
mixin FeedbackMixin {
  void triggerFeedback(FeedbackType type) {
    feedbackService.trigger(type);
  }

  void triggerTapFeedback() {
    feedbackService.trigger(FeedbackType.tap);
  }

  void triggerSuccessFeedback() {
    feedbackService.trigger(FeedbackType.success);
  }

  void triggerErrorFeedback() {
    feedbackService.trigger(FeedbackType.error);
  }
}

/// Wrapper widget that triggers haptic feedback on tap
class HapticFeedbackWrapper extends StatelessWidget {
  final Widget child;
  final FeedbackType feedbackType;
  final VoidCallback? onTap;

  const HapticFeedbackWrapper({
    super.key,
    required this.child,
    this.feedbackType = FeedbackType.tap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        feedbackService.trigger(feedbackType);
        onTap?.call();
      },
      child: child,
    );
  }
}
