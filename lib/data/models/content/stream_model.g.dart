// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamModel _$StreamModelFromJson(Map<String, dynamic> json) => StreamModel(
  id: json['id'] as String,
  name: json['name'] as String,
  subjects: (json['subjects'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$StreamModelToJson(StreamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subjects': instance.subjects,
    };
