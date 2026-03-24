// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconPath: json['iconPath'] as String,
  category: $enumDecode(_$BadgeCategoryEnumMap, json['category']),
  condition: _conditionFromJson(json['condition'] as Map<String, dynamic>),
  xpBonus: (json['xpBonus'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconPath': instance.iconPath,
      'category': _$BadgeCategoryEnumMap[instance.category]!,
      'condition': _conditionToJson(instance.condition),
      'xpBonus': instance.xpBonus,
    };

const _$BadgeCategoryEnumMap = {
  BadgeCategory.learning: 'learning',
  BadgeCategory.streak: 'streak',
  BadgeCategory.mastery: 'mastery',
  BadgeCategory.special: 'special',
};

_$BadgeProgressImpl _$$BadgeProgressImplFromJson(Map<String, dynamic> json) =>
    _$BadgeProgressImpl(
      badgeId: json['badgeId'] as String,
      studentId: json['studentId'] as String,
      badge: Badge.fromJson(json['badge'] as Map<String, dynamic>),
      progress: (json['progress'] as num).toDouble(),
      isUnlocked: json['isUnlocked'] as bool,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$$BadgeProgressImplToJson(_$BadgeProgressImpl instance) =>
    <String, dynamic>{
      'badgeId': instance.badgeId,
      'studentId': instance.studentId,
      'badge': instance.badge,
      'progress': instance.progress,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };
