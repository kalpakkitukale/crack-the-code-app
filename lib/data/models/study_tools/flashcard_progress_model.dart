/// Flashcard Progress data model for database operations
library;

import 'package:crack_the_code/core/constants/database_constants.dart';
import 'package:crack_the_code/domain/entities/study_tools/flashcard_progress.dart';

/// Flashcard Progress model for SQLite database
class FlashcardProgressModel {
  final String id;
  final String cardId;
  final String profileId;
  final int known;
  final double easeFactor;
  final int intervalDays;
  final int? nextReviewDate;
  final int reviewCount;
  final int correctCount;
  final int? lastReviewedAt;

  const FlashcardProgressModel({
    required this.id,
    required this.cardId,
    this.profileId = '',
    required this.known,
    required this.easeFactor,
    required this.intervalDays,
    this.nextReviewDate,
    required this.reviewCount,
    required this.correctCount,
    this.lastReviewedAt,
  });

  /// Convert from database map
  factory FlashcardProgressModel.fromMap(Map<String, dynamic> map) {
    return FlashcardProgressModel(
      id: map[FlashcardProgressTable.columnId] as String,
      cardId: map[FlashcardProgressTable.columnCardId] as String,
      profileId: map[FlashcardProgressTable.columnProfileId] as String? ?? '',
      known: map[FlashcardProgressTable.columnKnown] as int? ?? 0,
      easeFactor: (map[FlashcardProgressTable.columnEaseFactor] as num?)?.toDouble() ?? 2.5,
      intervalDays: map[FlashcardProgressTable.columnIntervalDays] as int? ?? 1,
      nextReviewDate: map[FlashcardProgressTable.columnNextReviewDate] as int?,
      reviewCount: map[FlashcardProgressTable.columnReviewCount] as int? ?? 0,
      correctCount: map[FlashcardProgressTable.columnCorrectCount] as int? ?? 0,
      lastReviewedAt: map[FlashcardProgressTable.columnLastReviewedAt] as int?,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      FlashcardProgressTable.columnId: id,
      FlashcardProgressTable.columnCardId: cardId,
      FlashcardProgressTable.columnProfileId: profileId,
      FlashcardProgressTable.columnKnown: known,
      FlashcardProgressTable.columnEaseFactor: easeFactor,
      FlashcardProgressTable.columnIntervalDays: intervalDays,
      FlashcardProgressTable.columnNextReviewDate: nextReviewDate,
      FlashcardProgressTable.columnReviewCount: reviewCount,
      FlashcardProgressTable.columnCorrectCount: correctCount,
      FlashcardProgressTable.columnLastReviewedAt: lastReviewedAt,
    };
  }

  /// Convert to domain entity
  FlashcardProgress toEntity() {
    return FlashcardProgress(
      id: id,
      cardId: cardId,
      profileId: profileId,
      known: known == 1,
      easeFactor: easeFactor,
      intervalDays: intervalDays,
      nextReviewDate: nextReviewDate != null
          ? DateTime.fromMillisecondsSinceEpoch(nextReviewDate!)
          : null,
      reviewCount: reviewCount,
      correctCount: correctCount,
      lastReviewedAt: lastReviewedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(lastReviewedAt!)
          : null,
    );
  }

  /// Create from domain entity
  factory FlashcardProgressModel.fromEntity(FlashcardProgress progress) {
    return FlashcardProgressModel(
      id: progress.id,
      cardId: progress.cardId,
      profileId: progress.profileId,
      known: progress.known ? 1 : 0,
      easeFactor: progress.easeFactor,
      intervalDays: progress.intervalDays,
      nextReviewDate: progress.nextReviewDate?.millisecondsSinceEpoch,
      reviewCount: progress.reviewCount,
      correctCount: progress.correctCount,
      lastReviewedAt: progress.lastReviewedAt?.millisecondsSinceEpoch,
    );
  }

  /// Create a copy with a new profile ID
  FlashcardProgressModel copyWithProfileId(String profileId) {
    return FlashcardProgressModel(
      id: id,
      cardId: cardId,
      profileId: profileId,
      known: known,
      easeFactor: easeFactor,
      intervalDays: intervalDays,
      nextReviewDate: nextReviewDate,
      reviewCount: reviewCount,
      correctCount: correctCount,
      lastReviewedAt: lastReviewedAt,
    );
  }
}
