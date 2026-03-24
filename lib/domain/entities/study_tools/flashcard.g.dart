// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlashcardImpl _$$FlashcardImplFromJson(Map<String, dynamic> json) =>
    _$FlashcardImpl(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      hint: json['hint'] as String?,
      imageUrl: json['imageUrl'] as String?,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      difficulty:
          $enumDecodeNullable(
            _$FlashcardDifficultyEnumMap,
            json['difficulty'],
          ) ??
          FlashcardDifficulty.medium,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FlashcardImplToJson(_$FlashcardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deckId': instance.deckId,
      'front': instance.front,
      'back': instance.back,
      'hint': instance.hint,
      'imageUrl': instance.imageUrl,
      'orderIndex': instance.orderIndex,
      'difficulty': _$FlashcardDifficultyEnumMap[instance.difficulty]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FlashcardDifficultyEnumMap = {
  FlashcardDifficulty.easy: 'easy',
  FlashcardDifficulty.medium: 'medium',
  FlashcardDifficulty.hard: 'hard',
};

_$FlashcardDeckImpl _$$FlashcardDeckImplFromJson(Map<String, dynamic> json) =>
    _$FlashcardDeckImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      topicId: json['topicId'] as String?,
      chapterId: json['chapterId'] as String?,
      cardCount: (json['cardCount'] as num?)?.toInt() ?? 0,
      segment: json['segment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cards:
          (json['cards'] as List<dynamic>?)
              ?.map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FlashcardDeckImplToJson(_$FlashcardDeckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'topicId': instance.topicId,
      'chapterId': instance.chapterId,
      'cardCount': instance.cardCount,
      'segment': instance.segment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'cards': instance.cards,
    };
