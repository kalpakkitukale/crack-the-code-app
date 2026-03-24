// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_gamification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentGamificationImpl _$$StudentGamificationImplFromJson(
  Map<String, dynamic> json,
) => _$StudentGamificationImpl(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  lastActiveDate: json['lastActiveDate'] == null
      ? null
      : DateTime.parse(json['lastActiveDate'] as String),
  unlockedBadgeIds:
      (json['unlockedBadgeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$StudentGamificationImplToJson(
  _$StudentGamificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'totalXp': instance.totalXp,
  'level': instance.level,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'lastActiveDate': instance.lastActiveDate?.toIso8601String(),
  'unlockedBadgeIds': instance.unlockedBadgeIds,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
