// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardModel _$BoardModelFromJson(Map<String, dynamic> json) => BoardModel(
  id: json['id'] as String,
  name: json['name'] as String,
  fullName: json['fullName'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String?,
  classes: (json['classes'] as List<dynamic>)
      .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BoardModelToJson(BoardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'description': instance.description,
      'icon': instance.icon,
      'classes': instance.classes.map((e) => e.toJson()).toList(),
    };
