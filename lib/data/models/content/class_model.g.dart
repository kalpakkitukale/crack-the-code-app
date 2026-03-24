// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
  id: json['id'] as String,
  name: json['name'] as String,
  streams: (json['streams'] as List<dynamic>)
      .map((e) => StreamModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'streams': instance.streams.map((e) => e.toJson()).toList(),
    };
