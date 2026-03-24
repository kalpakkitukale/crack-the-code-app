/// Chapter Note model for database and JSON serialization
library;

import 'dart:convert';

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_note.dart';

/// Model class for ChapterNote with database and JSON conversion
class ChapterNoteModel {
  final String id;
  final String chapterId;
  final String? profileId;
  final String? subjectId;
  final String content;
  final String? title;
  final String tagsJson;
  final int isPinned;
  final String noteType;
  final String segment;
  final int createdAt;
  final int updatedAt;

  const ChapterNoteModel({
    required this.id,
    required this.chapterId,
    this.profileId,
    this.subjectId,
    required this.content,
    this.title,
    required this.tagsJson,
    required this.isPinned,
    required this.noteType,
    required this.segment,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get tags as list
  List<String> get tags {
    try {
      final decoded = jsonDecode(tagsJson) as List<dynamic>;
      return decoded.cast<String>();
    } catch (_) {
      return [];
    }
  }

  /// Convert from database map
  factory ChapterNoteModel.fromMap(Map<String, dynamic> map) {
    return ChapterNoteModel(
      id: map[ChapterNotesTable.columnId] as String,
      chapterId: map[ChapterNotesTable.columnChapterId] as String,
      profileId: map[ChapterNotesTable.columnProfileId] as String?,
      subjectId: map[ChapterNotesTable.columnSubjectId] as String?,
      content: map[ChapterNotesTable.columnContent] as String,
      title: map[ChapterNotesTable.columnTitle] as String?,
      tagsJson: map[ChapterNotesTable.columnTags] as String? ?? '[]',
      isPinned: map[ChapterNotesTable.columnIsPinned] as int? ?? 0,
      noteType: map[ChapterNotesTable.columnNoteType] as String? ?? 'personal',
      segment: map[ChapterNotesTable.columnSegment] as String,
      createdAt: map[ChapterNotesTable.columnCreatedAt] as int,
      updatedAt: map[ChapterNotesTable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      ChapterNotesTable.columnId: id,
      ChapterNotesTable.columnChapterId: chapterId,
      ChapterNotesTable.columnProfileId: profileId,
      ChapterNotesTable.columnSubjectId: subjectId,
      ChapterNotesTable.columnContent: content,
      ChapterNotesTable.columnTitle: title,
      ChapterNotesTable.columnTags: tagsJson,
      ChapterNotesTable.columnIsPinned: isPinned,
      ChapterNotesTable.columnNoteType: noteType,
      ChapterNotesTable.columnSegment: segment,
      ChapterNotesTable.columnCreatedAt: createdAt,
      ChapterNotesTable.columnUpdatedAt: updatedAt,
    };
  }

  /// Convert to domain entity
  ChapterNote toEntity() {
    return ChapterNote(
      id: id,
      chapterId: chapterId,
      profileId: profileId,
      subjectId: subjectId,
      content: content,
      title: title,
      tags: tags,
      isPinned: isPinned == 1,
      noteType: noteType == 'curated' ? NoteType.curated : NoteType.personal,
      segment: segment,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  /// Create from domain entity
  factory ChapterNoteModel.fromEntity(ChapterNote note) {
    return ChapterNoteModel(
      id: note.id,
      chapterId: note.chapterId,
      profileId: note.profileId,
      subjectId: note.subjectId,
      content: note.content,
      title: note.title,
      tagsJson: jsonEncode(note.tags),
      isPinned: note.isPinned ? 1 : 0,
      noteType: note.noteType == NoteType.curated ? 'curated' : 'personal',
      segment: note.segment,
      createdAt: note.createdAt.millisecondsSinceEpoch,
      updatedAt: note.updatedAt.millisecondsSinceEpoch,
    );
  }

  /// Create from JSON (for loading curated notes from asset files)
  factory ChapterNoteModel.fromJson(
    Map<String, dynamic> json,
    String chapterId,
    String subjectId,
    String segment,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final tags = json['tags'] as List<dynamic>?;

    return ChapterNoteModel(
      id: json['id'] as String? ?? 'cnote_${chapterId}_$now',
      chapterId: chapterId,
      profileId: null, // Curated notes have no profile ID
      subjectId: subjectId,
      content: json['content'] as String? ?? '',
      title: json['title'] as String?,
      tagsJson: tags != null ? jsonEncode(tags) : '[]',
      isPinned: (json['isPinned'] as bool? ?? false) ? 1 : 0,
      noteType: 'curated', // Notes from JSON are always curated
      segment: segment,
      createdAt: json['createdAt'] as int? ?? now,
      updatedAt: json['updatedAt'] as int? ?? now,
    );
  }
}
