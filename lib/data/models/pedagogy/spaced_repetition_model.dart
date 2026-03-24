/// SpacedRepetitionModel - Data model for spaced repetition scheduling
library;

/// Data model for spaced repetition with database serialization
class SpacedRepetitionModel {
  final String id;
  final String conceptId;
  final String studentId;
  final int intervalDays;
  final double easeFactor;
  final int consecutiveCorrect;
  final DateTime nextReviewDate;
  final DateTime? lastReviewDate;
  final int totalReviews;
  final int correctReviews;

  const SpacedRepetitionModel({
    required this.id,
    required this.conceptId,
    required this.studentId,
    required this.intervalDays,
    required this.easeFactor,
    required this.consecutiveCorrect,
    required this.nextReviewDate,
    this.lastReviewDate,
    required this.totalReviews,
    required this.correctReviews,
  });

  /// Convert model to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'concept_id': conceptId,
      'student_id': studentId,
      'interval_days': intervalDays,
      'ease_factor': easeFactor,
      'consecutive_correct': consecutiveCorrect,
      'next_review_date': nextReviewDate.millisecondsSinceEpoch,
      'last_review_date': lastReviewDate?.millisecondsSinceEpoch,
      'total_reviews': totalReviews,
      'correct_reviews': correctReviews,
    };
  }

  /// Create model from database map
  factory SpacedRepetitionModel.fromMap(Map<String, dynamic> map) {
    return SpacedRepetitionModel(
      id: map['id'] as String,
      conceptId: map['concept_id'] as String,
      studentId: map['student_id'] as String,
      intervalDays: map['interval_days'] as int,
      easeFactor: (map['ease_factor'] as num).toDouble(),
      consecutiveCorrect: map['consecutive_correct'] as int,
      nextReviewDate: DateTime.fromMillisecondsSinceEpoch(
        map['next_review_date'] as int,
      ),
      lastReviewDate: map['last_review_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_review_date'] as int)
          : null,
      totalReviews: map['total_reviews'] as int,
      correctReviews: map['correct_reviews'] as int,
    );
  }

  /// Get accuracy percentage
  double get accuracy {
    if (totalReviews == 0) return 0;
    return (correctReviews / totalReviews) * 100;
  }

  /// Check if review is due
  bool get isDue => DateTime.now().isAfter(nextReviewDate);

  /// Get days until next review
  int get daysUntilReview {
    return nextReviewDate.difference(DateTime.now()).inDays;
  }

  /// Check if overdue
  bool get isOverdue {
    final daysPast = DateTime.now().difference(nextReviewDate).inDays;
    return daysPast > 0;
  }

  /// Get days overdue
  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(nextReviewDate).inDays;
  }

  /// Create a copy with modified fields
  SpacedRepetitionModel copyWith({
    String? id,
    String? conceptId,
    String? studentId,
    int? intervalDays,
    double? easeFactor,
    int? consecutiveCorrect,
    DateTime? nextReviewDate,
    DateTime? lastReviewDate,
    int? totalReviews,
    int? correctReviews,
  }) {
    return SpacedRepetitionModel(
      id: id ?? this.id,
      conceptId: conceptId ?? this.conceptId,
      studentId: studentId ?? this.studentId,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      totalReviews: totalReviews ?? this.totalReviews,
      correctReviews: correctReviews ?? this.correctReviews,
    );
  }

  @override
  String toString() {
    return 'SpacedRepetitionModel(id: $id, conceptId: $conceptId, '
        'interval: $intervalDays days, nextReview: $nextReviewDate)';
  }
}
