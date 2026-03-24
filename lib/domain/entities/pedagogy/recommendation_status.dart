/// Status of saved recommendations for a quiz
enum RecommendationStatus {
  /// No recommendations (perfect score or no weak areas)
  none,

  /// Recommendations generated but not yet viewed
  available,

  /// User has viewed recommendations
  viewed,

  /// User started learning path from recommendations
  inProgress,

  /// User completed learning path
  completed,

  /// Recommendations are >30 days old, suggest regenerate
  outdated;

  /// Get user-friendly display text
  String get displayText {
    switch (this) {
      case RecommendationStatus.none:
        return 'No Recommendations';
      case RecommendationStatus.available:
        return 'New';
      case RecommendationStatus.viewed:
        return 'Viewed';
      case RecommendationStatus.inProgress:
        return 'In Progress';
      case RecommendationStatus.completed:
        return 'Completed';
      case RecommendationStatus.outdated:
        return 'Outdated';
    }
  }

  /// Get icon name for this status
  String get iconName {
    switch (this) {
      case RecommendationStatus.none:
        return 'check_circle';
      case RecommendationStatus.available:
        return 'fiber_new';
      case RecommendationStatus.viewed:
        return 'visibility';
      case RecommendationStatus.inProgress:
        return 'play_circle_outline';
      case RecommendationStatus.completed:
        return 'check_circle';
      case RecommendationStatus.outdated:
        return 'schedule';
    }
  }

  /// Check if this is an active status (not none or outdated)
  bool get isActive {
    return this != RecommendationStatus.none &&
        this != RecommendationStatus.outdated;
  }
}
