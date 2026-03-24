// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlashcardProgressImpl _$$FlashcardProgressImplFromJson(
  Map<String, dynamic> json,
) => _$FlashcardProgressImpl(
  id: json['id'] as String,
  cardId: json['cardId'] as String,
  profileId: json['profileId'] as String,
  known: json['known'] as bool? ?? false,
  easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
  intervalDays: (json['intervalDays'] as num?)?.toInt() ?? 1,
  nextReviewDate: json['nextReviewDate'] == null
      ? null
      : DateTime.parse(json['nextReviewDate'] as String),
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
  lastReviewedAt: json['lastReviewedAt'] == null
      ? null
      : DateTime.parse(json['lastReviewedAt'] as String),
);

Map<String, dynamic> _$$FlashcardProgressImplToJson(
  _$FlashcardProgressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'cardId': instance.cardId,
  'profileId': instance.profileId,
  'known': instance.known,
  'easeFactor': instance.easeFactor,
  'intervalDays': instance.intervalDays,
  'nextReviewDate': instance.nextReviewDate?.toIso8601String(),
  'reviewCount': instance.reviewCount,
  'correctCount': instance.correctCount,
  'lastReviewedAt': instance.lastReviewedAt?.toIso8601String(),
};

_$FlashcardStudySessionImpl _$$FlashcardStudySessionImplFromJson(
  Map<String, dynamic> json,
) => _$FlashcardStudySessionImpl(
  deckId: json['deckId'] as String,
  profileId: json['profileId'] as String,
  totalCards: (json['totalCards'] as num).toInt(),
  knownCards: (json['knownCards'] as num).toInt(),
  unknownCards: (json['unknownCards'] as num).toInt(),
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  completedAt: DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$FlashcardStudySessionImplToJson(
  _$FlashcardStudySessionImpl instance,
) => <String, dynamic>{
  'deckId': instance.deckId,
  'profileId': instance.profileId,
  'totalCards': instance.totalCards,
  'knownCards': instance.knownCards,
  'unknownCards': instance.unknownCards,
  'duration': instance.duration.inMicroseconds,
  'completedAt': instance.completedAt.toIso8601String(),
};

_$DeckProgressImpl _$$DeckProgressImplFromJson(Map<String, dynamic> json) =>
    _$DeckProgressImpl(
      deckId: json['deckId'] as String,
      profileId: json['profileId'] as String,
      totalCards: (json['totalCards'] as num).toInt(),
      reviewedCards: (json['reviewedCards'] as num).toInt(),
      masteredCards: (json['masteredCards'] as num).toInt(),
      dueCards: (json['dueCards'] as num).toInt(),
      averageAccuracy: (json['averageAccuracy'] as num).toDouble(),
      lastStudiedAt: json['lastStudiedAt'] == null
          ? null
          : DateTime.parse(json['lastStudiedAt'] as String),
    );

Map<String, dynamic> _$$DeckProgressImplToJson(_$DeckProgressImpl instance) =>
    <String, dynamic>{
      'deckId': instance.deckId,
      'profileId': instance.profileId,
      'totalCards': instance.totalCards,
      'reviewedCards': instance.reviewedCards,
      'masteredCards': instance.masteredCards,
      'dueCards': instance.dueCards,
      'averageAccuracy': instance.averageAccuracy,
      'lastStudiedAt': instance.lastStudiedAt?.toIso8601String(),
    };
