/// Quiz attempt status enumeration
///
/// Represents the current state of a quiz attempt
library;

/// Status of a quiz attempt
enum QuizAttemptStatus {
  /// Quiz is in progress (not yet submitted)
  inProgress('in_progress'),

  /// Quiz has been completed and submitted
  completed('completed'),

  /// Quiz was abandoned (started but not completed)
  abandoned('abandoned');

  const QuizAttemptStatus(this.value);

  final String value;

  /// Parse status from string value
  static QuizAttemptStatus fromString(String value) {
    switch (value) {
      case 'in_progress':
        return QuizAttemptStatus.inProgress;
      case 'completed':
        return QuizAttemptStatus.completed;
      case 'abandoned':
        return QuizAttemptStatus.abandoned;
      default:
        // Default to completed for backward compatibility with existing data
        return QuizAttemptStatus.completed;
    }
  }

  /// Check if this attempt is completed
  bool get isCompleted => this == QuizAttemptStatus.completed;

  /// Check if this attempt is in progress
  bool get isInProgress => this == QuizAttemptStatus.inProgress;

  /// Check if this attempt was abandoned
  bool get isAbandoned => this == QuizAttemptStatus.abandoned;
}
