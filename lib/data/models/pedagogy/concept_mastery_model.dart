/// ConceptMasteryModel - Data model for concept mastery tracking
library;

import 'package:streamshaala/domain/entities/pedagogy/concept_mastery.dart';

/// Data model for concept mastery with database serialization
class ConceptMasteryModel {
  final String id;
  final String conceptId;
  final String studentId;
  final double masteryScore;
  final MasteryLevel level;
  final DateTime lastAssessed;
  final int totalAttempts;
  final bool isGap;
  final DateTime? nextReviewDate;
  final int reviewStreak;
  final double? preQuizScore;
  final double? checkpointScore;
  final double? postQuizScore;
  final double? practiceScore;
  final double? spacedRepScore;
  final int? gradeLevel;

  const ConceptMasteryModel({
    required this.id,
    required this.conceptId,
    required this.studentId,
    required this.masteryScore,
    required this.level,
    required this.lastAssessed,
    required this.totalAttempts,
    required this.isGap,
    this.nextReviewDate,
    this.reviewStreak = 0,
    this.preQuizScore,
    this.checkpointScore,
    this.postQuizScore,
    this.practiceScore,
    this.spacedRepScore,
    this.gradeLevel,
  });

  /// Convert model to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'concept_id': conceptId,
      'student_id': studentId,
      'mastery_score': masteryScore,
      'level': level.name,
      'last_assessed': lastAssessed.millisecondsSinceEpoch,
      'total_attempts': totalAttempts,
      'is_gap': isGap ? 1 : 0,
      'next_review_date': nextReviewDate?.millisecondsSinceEpoch,
      'review_streak': reviewStreak,
      'pre_quiz_score': preQuizScore,
      'checkpoint_score': checkpointScore,
      'post_quiz_score': postQuizScore,
      'practice_score': practiceScore,
      'spaced_rep_score': spacedRepScore,
      'grade_level': gradeLevel,
    };
  }

  /// Create model from database map
  factory ConceptMasteryModel.fromMap(Map<String, dynamic> map) {
    return ConceptMasteryModel(
      id: map['id'] as String,
      conceptId: map['concept_id'] as String,
      studentId: map['student_id'] as String,
      masteryScore: (map['mastery_score'] as num).toDouble(),
      level: _parseMasteryLevel(map['level'] as String),
      lastAssessed: DateTime.fromMillisecondsSinceEpoch(
        map['last_assessed'] as int,
      ),
      totalAttempts: map['total_attempts'] as int,
      isGap: (map['is_gap'] as int) == 1,
      nextReviewDate: map['next_review_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['next_review_date'] as int)
          : null,
      reviewStreak: map['review_streak'] as int? ?? 0,
      preQuizScore: (map['pre_quiz_score'] as num?)?.toDouble(),
      checkpointScore: (map['checkpoint_score'] as num?)?.toDouble(),
      postQuizScore: (map['post_quiz_score'] as num?)?.toDouble(),
      practiceScore: (map['practice_score'] as num?)?.toDouble(),
      spacedRepScore: (map['spaced_rep_score'] as num?)?.toDouble(),
      gradeLevel: map['grade_level'] as int?,
    );
  }

  /// Convert model to domain entity
  ConceptMastery toEntity() {
    return ConceptMastery(
      id: id,
      conceptId: conceptId,
      studentId: studentId,
      masteryScore: masteryScore,
      level: level,
      lastAssessed: lastAssessed,
      totalAttempts: totalAttempts,
      isGap: isGap,
      nextReviewDate: nextReviewDate,
      reviewStreak: reviewStreak,
      preQuizScore: preQuizScore,
      checkpointScore: checkpointScore,
      postQuizScore: postQuizScore,
      practiceScore: practiceScore,
      spacedRepScore: spacedRepScore,
      gradeLevel: gradeLevel,
    );
  }

  /// Create model from domain entity
  factory ConceptMasteryModel.fromEntity(ConceptMastery entity) {
    return ConceptMasteryModel(
      id: entity.id,
      conceptId: entity.conceptId,
      studentId: entity.studentId,
      masteryScore: entity.masteryScore,
      level: entity.level,
      lastAssessed: entity.lastAssessed,
      totalAttempts: entity.totalAttempts,
      isGap: entity.isGap,
      nextReviewDate: entity.nextReviewDate,
      reviewStreak: entity.reviewStreak,
      preQuizScore: entity.preQuizScore,
      checkpointScore: entity.checkpointScore,
      postQuizScore: entity.postQuizScore,
      practiceScore: entity.practiceScore,
      spacedRepScore: entity.spacedRepScore,
      gradeLevel: entity.gradeLevel,
    );
  }

  /// Parse mastery level from string
  static MasteryLevel _parseMasteryLevel(String levelStr) {
    switch (levelStr) {
      case 'notLearned':
        return MasteryLevel.notLearned;
      case 'learning':
        return MasteryLevel.learning;
      case 'familiar':
        return MasteryLevel.familiar;
      case 'proficient':
        return MasteryLevel.proficient;
      case 'mastered':
        return MasteryLevel.mastered;
      default:
        return MasteryLevel.notLearned;
    }
  }

  /// Create a copy with modified fields
  ConceptMasteryModel copyWith({
    String? id,
    String? conceptId,
    String? studentId,
    double? masteryScore,
    MasteryLevel? level,
    DateTime? lastAssessed,
    int? totalAttempts,
    bool? isGap,
    DateTime? nextReviewDate,
    int? reviewStreak,
    double? preQuizScore,
    double? checkpointScore,
    double? postQuizScore,
    double? practiceScore,
    double? spacedRepScore,
    int? gradeLevel,
  }) {
    return ConceptMasteryModel(
      id: id ?? this.id,
      conceptId: conceptId ?? this.conceptId,
      studentId: studentId ?? this.studentId,
      masteryScore: masteryScore ?? this.masteryScore,
      level: level ?? this.level,
      lastAssessed: lastAssessed ?? this.lastAssessed,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      isGap: isGap ?? this.isGap,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      reviewStreak: reviewStreak ?? this.reviewStreak,
      preQuizScore: preQuizScore ?? this.preQuizScore,
      checkpointScore: checkpointScore ?? this.checkpointScore,
      postQuizScore: postQuizScore ?? this.postQuizScore,
      practiceScore: practiceScore ?? this.practiceScore,
      spacedRepScore: spacedRepScore ?? this.spacedRepScore,
      gradeLevel: gradeLevel ?? this.gradeLevel,
    );
  }

  @override
  String toString() {
    return 'ConceptMasteryModel(id: $id, conceptId: $conceptId, '
        'masteryScore: ${masteryScore.toStringAsFixed(1)}%, level: ${level.name})';
  }
}
