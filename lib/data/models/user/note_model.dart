/// Note data model for database operations
library;

import 'package:streamshaala/core/constants/database_constants.dart';
import 'package:streamshaala/domain/entities/user/note.dart';

/// Note model for SQLite database
class NoteModel {
  final String id;
  final String videoId;
  final String profileId;
  final String content;
  final int? timestampSeconds;
  final int createdAt;
  final int updatedAt;

  const NoteModel({
    required this.id,
    required this.videoId,
    this.profileId = '',
    required this.content,
    this.timestampSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from database map
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[NotesTable.columnId] as String,
      videoId: map[NotesTable.columnVideoId] as String,
      profileId: map[NotesTable.columnProfileId] as String? ?? '',
      content: map[NotesTable.columnContent] as String,
      timestampSeconds: map[NotesTable.columnTimestampSeconds] as int?,
      createdAt: map[NotesTable.columnCreatedAt] as int,
      updatedAt: map[NotesTable.columnUpdatedAt] as int,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      NotesTable.columnId: id,
      NotesTable.columnVideoId: videoId,
      NotesTable.columnProfileId: profileId,
      NotesTable.columnContent: content,
      NotesTable.columnTimestampSeconds: timestampSeconds,
      NotesTable.columnCreatedAt: createdAt,
      NotesTable.columnUpdatedAt: updatedAt,
    };
  }

  /// Convert to domain entity
  Note toEntity() {
    return Note(
      id: id,
      videoId: videoId,
      content: content,
      timestampSeconds: timestampSeconds,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  /// Create from domain entity
  factory NoteModel.fromEntity(Note note, {String profileId = ''}) {
    return NoteModel(
      id: note.id,
      videoId: note.videoId,
      profileId: profileId,
      content: note.content,
      timestampSeconds: note.timestampSeconds,
      createdAt: note.createdAt.millisecondsSinceEpoch,
      updatedAt: note.updatedAt.millisecondsSinceEpoch,
    );
  }

  /// Create a copy with a new profile ID
  NoteModel copyWithProfileId(String profileId) {
    return NoteModel(
      id: id,
      videoId: videoId,
      profileId: profileId,
      content: content,
      timestampSeconds: timestampSeconds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
