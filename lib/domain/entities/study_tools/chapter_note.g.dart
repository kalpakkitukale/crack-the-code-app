// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterNoteImpl _$$ChapterNoteImplFromJson(Map<String, dynamic> json) =>
    _$ChapterNoteImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      profileId: json['profileId'] as String?,
      subjectId: json['subjectId'] as String?,
      content: json['content'] as String,
      title: json['title'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isPinned: json['isPinned'] as bool? ?? false,
      noteType:
          $enumDecodeNullable(_$NoteTypeEnumMap, json['noteType']) ??
          NoteType.personal,
      segment: json['segment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChapterNoteImplToJson(_$ChapterNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'profileId': instance.profileId,
      'subjectId': instance.subjectId,
      'content': instance.content,
      'title': instance.title,
      'tags': instance.tags,
      'isPinned': instance.isPinned,
      'noteType': _$NoteTypeEnumMap[instance.noteType]!,
      'segment': instance.segment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$NoteTypeEnumMap = {
  NoteType.curated: 'curated',
  NoteType.personal: 'personal',
};
