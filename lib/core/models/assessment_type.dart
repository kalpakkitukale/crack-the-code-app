import 'package:flutter/material.dart';

/// Represents the type of assessment being taken.
///
/// This enum distinguishes between two fundamentally different quiz contexts:
/// - PRE-assessment (Readiness Check): Diagnostic before learning
/// - POST-assessment (Knowledge Check): Validation after learning
enum AssessmentType {
  /// PRE-assessment: Gap analysis and readiness check before learning.
  ///
  /// Purpose: Identify knowledge gaps, personalize learning path
  /// Context: First-time approach to a subject, diagnostic
  /// Outcome: Recommendations for what to learn first
  readiness,

  /// POST-assessment: Knowledge validation after learning.
  ///
  /// Purpose: Validate understanding, measure progress
  /// Context: After watching videos or completing chapters
  /// Outcome: Confirmation of mastery or areas needing review
  knowledge,

  /// Regular practice quiz for skill building.
  ///
  /// Purpose: General practice without specific diagnostic purpose
  /// Context: Ongoing practice and skill reinforcement
  /// Outcome: Score and performance feedback
  practice,
}

/// Extension methods for AssessmentType to provide UI-related properties.
extension AssessmentTypeExtension on AssessmentType {
  /// The display name shown in the UI.
  String get displayName {
    switch (this) {
      case AssessmentType.readiness:
        return 'Readiness Check';
      case AssessmentType.knowledge:
        return 'Knowledge Check';
      case AssessmentType.practice:
        return 'Practice';
    }
  }

  /// Short label for compact UI elements.
  String get shortLabel {
    switch (this) {
      case AssessmentType.readiness:
        return 'Readiness';
      case AssessmentType.knowledge:
        return 'Knowledge';
      case AssessmentType.practice:
        return 'Practice';
    }
  }

  /// The subtitle describing the assessment purpose.
  String get subtitle {
    switch (this) {
      case AssessmentType.readiness:
        return 'Discover your starting point';
      case AssessmentType.knowledge:
        return 'Validate your learning';
      case AssessmentType.practice:
        return 'Skill Practice';
    }
  }

  /// Detailed description of the assessment purpose.
  String get description {
    switch (this) {
      case AssessmentType.readiness:
        return 'This diagnostic quiz will identify your knowledge gaps and help personalize your learning path.';
      case AssessmentType.knowledge:
        return 'This quiz tests what you have learned and measures your understanding of the material.';
      case AssessmentType.practice:
        return 'Practice your skills and reinforce your knowledge through this quiz.';
    }
  }

  /// The icon representing this assessment type.
  IconData get icon {
    switch (this) {
      case AssessmentType.readiness:
        return Icons.psychology_outlined;
      case AssessmentType.knowledge:
        return Icons.fact_check_outlined;
      case AssessmentType.practice:
        return Icons.edit_outlined;
    }
  }

  /// The filled icon variant for selected/active states.
  IconData get iconFilled {
    switch (this) {
      case AssessmentType.readiness:
        return Icons.psychology;
      case AssessmentType.knowledge:
        return Icons.fact_check;
      case AssessmentType.practice:
        return Icons.edit;
    }
  }

  /// Primary color for this assessment type.
  ///
  /// - Readiness: Purple/Violet - represents discovery, exploration
  /// - Knowledge: Teal/Cyan - represents validation, achievement
  /// - Practice: Blue - represents practice and skill building
  Color get primaryColor {
    switch (this) {
      case AssessmentType.readiness:
        return const Color(0xFF7C4DFF); // Deep Purple accent
      case AssessmentType.knowledge:
        return const Color(0xFF00ACC1); // Cyan 600
      case AssessmentType.practice:
        return const Color(0xFF2196F3); // Blue 500
    }
  }

  /// Light background color for containers and badges.
  Color get backgroundColor {
    switch (this) {
      case AssessmentType.readiness:
        return const Color(0xFFEDE7F6); // Purple 50
      case AssessmentType.knowledge:
        return const Color(0xFFE0F7FA); // Cyan 50
      case AssessmentType.practice:
        return const Color(0xFFE3F2FD); // Blue 50
    }
  }

  /// Dark variant for dark mode backgrounds.
  Color get backgroundColorDark {
    switch (this) {
      case AssessmentType.readiness:
        return const Color(0xFF311B92).withValues(alpha: 0.2); // Deep Purple 900
      case AssessmentType.knowledge:
        return const Color(0xFF006064).withValues(alpha: 0.2); // Cyan 900
      case AssessmentType.practice:
        return const Color(0xFF0D47A1).withValues(alpha: 0.2); // Blue 900
    }
  }

  /// Border color for outlined elements.
  Color get borderColor {
    switch (this) {
      case AssessmentType.readiness:
        return const Color(0xFFB388FF); // Purple A100
      case AssessmentType.knowledge:
        return const Color(0xFF80DEEA); // Cyan 200
      case AssessmentType.practice:
        return const Color(0xFF90CAF9); // Blue 200
    }
  }

  /// Message shown before starting the quiz.
  String get introMessage {
    switch (this) {
      case AssessmentType.readiness:
        return 'This quick assessment will help us understand your current knowledge level and recommend the best learning path for you.';
      case AssessmentType.knowledge:
        return 'Let\'s check how well you understood the material. Answer these questions to validate your learning.';
      case AssessmentType.practice:
        return 'Practice your skills with this quiz. Use it to reinforce your knowledge and track your progress.';
    }
  }

  /// Message shown during the quiz as a reminder.
  String get helperText {
    switch (this) {
      case AssessmentType.readiness:
        return 'Don\'t worry about wrong answers - this helps us find where to focus your learning.';
      case AssessmentType.knowledge:
        return 'Take your time to demonstrate what you\'ve learned.';
      case AssessmentType.practice:
        return 'Take your time and do your best. Practice makes perfect!';
    }
  }

  /// Message prefix for results screen based on outcome.
  String getResultsMessage({required bool passed, required double score}) {
    switch (this) {
      case AssessmentType.readiness:
        if (score >= 80) {
          return 'Excellent foundation! You\'re well-prepared to tackle advanced topics.';
        } else if (score >= 60) {
          return 'Good starting point! We\'ve identified some areas to strengthen.';
        } else if (score >= 40) {
          return 'We\'ve found your learning priorities. Let\'s build your foundation.';
        } else {
          return 'Great start! We now know exactly where to begin your learning journey.';
        }
      case AssessmentType.knowledge:
        if (passed) {
          if (score >= 90) {
            return 'Outstanding mastery! You\'ve thoroughly understood this material.';
          } else if (score >= 80) {
            return 'Excellent work! You\'ve demonstrated strong understanding.';
          } else {
            return 'Well done! You\'ve passed the knowledge check.';
          }
        } else {
          return 'Keep learning! Review the material and try again when ready.';
        }
      case AssessmentType.practice:
        if (score >= 90) {
          return 'Excellent practice session! You\'re mastering this material.';
        } else if (score >= 75) {
          return 'Great work! Keep practicing to reach mastery.';
        } else if (score >= 60) {
          return 'Good effort! Regular practice will improve your skills.';
        } else {
          return 'Keep practicing! Review the material and try again.';
        }
    }
  }

  /// The query parameter value used in URLs.
  String get queryValue {
    switch (this) {
      case AssessmentType.readiness:
        return 'readiness';
      case AssessmentType.knowledge:
        return 'knowledge';
      case AssessmentType.practice:
        return 'practice';
    }
  }

  /// Parse assessment type from query parameter string.
  ///
  /// Returns [AssessmentType.practice] as default if the value is invalid
  /// or not provided (backward compatibility).
  static AssessmentType fromQueryValue(String? value) {
    if (value == null || value.isEmpty) {
      // Default to practice for backward compatibility
      return AssessmentType.practice;
    }
    switch (value.toLowerCase()) {
      case 'readiness':
      case 'pre':
      case 'diagnostic':
        return AssessmentType.readiness;
      case 'knowledge':
      case 'post':
      case 'validation':
        return AssessmentType.knowledge;
      case 'practice':
      case 'regular':
        return AssessmentType.practice;
      default:
        return AssessmentType.practice;
    }
  }

  /// Semantic label for screen readers.
  String get semanticLabel {
    switch (this) {
      case AssessmentType.readiness:
        return 'Readiness Check assessment. This is a diagnostic quiz to identify your knowledge gaps before learning.';
      case AssessmentType.knowledge:
        return 'Knowledge Check assessment. This quiz validates what you have learned.';
      case AssessmentType.practice:
        return 'Practice quiz. This quiz helps you practice and reinforce your skills.';
    }
  }
}
