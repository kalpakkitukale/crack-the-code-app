import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';

/// Centralized semantic color utilities for consistent theming across the app.
///
/// This utility class provides consistent color mapping for:
/// - Score-based colors (success, warning, error)
/// - Subject-specific colors
/// - Gap severity indicators
/// - Status indicators
///
/// Using this class ensures:
/// - Consistent color usage across all screens
/// - Easy theme updates in one place
/// - Better dark mode support
/// - Accessibility compliance
class SemanticColors {
  SemanticColors._();

  /// Get color based on score percentage.
  ///
  /// Returns:
  /// - Green (success) for scores >= 80%
  /// - Orange (warning) for scores >= 60%
  /// - Red (error) for scores < 60%
  static Color getScoreColor(double percentage) {
    if (percentage >= 80) return AppTheme.successColor;
    if (percentage >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  /// Get subject-specific color for consistent visual mapping.
  ///
  /// This provides visual consistency across cards, badges, and charts.
  static Color getSubjectColor(String subjectName) {
    final lower = subjectName.toLowerCase();
    if (lower.contains('physics')) return AppTheme.primaryBlue;
    if (lower.contains('chemistry')) return AppTheme.primaryGreen;
    if (lower.contains('math') || lower.contains('maths')) return AppTheme.warningColor;
    if (lower.contains('biology')) return const Color(0xFFE91E63); // Pink
    return AppTheme.accentColor;
  }

  /// Get subject-specific icon for consistent visual identity.
  static IconData getSubjectIcon(String subjectName) {
    final lower = subjectName.toLowerCase();
    if (lower.contains('physics')) return Icons.science;
    if (lower.contains('chemistry')) return Icons.biotech;
    if (lower.contains('math') || lower.contains('maths')) return Icons.calculate;
    if (lower.contains('biology')) return Icons.local_florist;
    return Icons.school;
  }

  /// Get color for gap severity indicators.
  ///
  /// Used in recommendations and diagnostic screens.
  static Color getSeverityColor(GapSeverity severity) {
    switch (severity) {
      case GapSeverity.critical:
        return AppTheme.errorColor; // Red
      case GapSeverity.severe:
        return AppTheme.warningColor; // Orange
      case GapSeverity.moderate:
        return const Color(0xFFFFA000); // Amber
      case GapSeverity.mild:
        return AppTheme.primaryBlue; // Blue
    }
  }

  /// Get color for streak status indicators.
  ///
  /// Used in gamification widgets.
  static Color getStreakColor(bool isAtRisk) {
    return isAtRisk ? AppTheme.warningColor : AppTheme.successColor;
  }

  /// Get color for completion status.
  ///
  /// Returns green for completed, blue for in-progress, grey for not started.
  static Color getCompletionColor(BuildContext context, {
    required bool isCompleted,
    bool isInProgress = false,
  }) {
    if (isCompleted) return AppTheme.successColor;
    if (isInProgress) return AppTheme.primaryBlue;
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3);
  }

  /// Get color for assessment type badges.
  static Color getAssessmentTypeColor(String assessmentType) {
    switch (assessmentType.toLowerCase()) {
      case 'readiness':
        return AppTheme.primaryBlue;
      case 'knowledge':
        return AppTheme.successColor;
      case 'practice':
        return AppTheme.warningColor;
      default:
        return AppTheme.accentColor;
    }
  }
}
