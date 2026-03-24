/// Chapter Note entity for chapter-level notes (curated and personal)
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_note.freezed.dart';
part 'chapter_note.g.dart';

/// Type of note - determines ownership and editability
enum NoteType {
  /// Curated notes from content team - shared, read-only for students
  curated,
  /// Personal notes created by students - profile-specific, editable
  personal,
}

/// Chapter Note entity
/// Represents either a curated study note (from content team) or a personal note (from student)
@freezed
class ChapterNote with _$ChapterNote {
  const factory ChapterNote({
    required String id,
    required String chapterId,
    /// Profile ID of the note owner. Null for curated notes (shared), non-null for personal notes
    String? profileId,
    /// Subject ID for JSON lookup (curated notes)
    String? subjectId,
    required String content,
    String? title,
    @Default([]) List<String> tags,
    @Default(false) bool isPinned,
    @Default(NoteType.personal) NoteType noteType,
    required String segment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChapterNote;

  const ChapterNote._();

  factory ChapterNote.fromJson(Map<String, dynamic> json) =>
      _$ChapterNoteFromJson(json);

  /// Check if this is a curated (shared) note
  bool get isCurated => noteType == NoteType.curated;

  /// Check if this is a personal note
  bool get isPersonal => noteType == NoteType.personal;

  /// Check if the note has a title
  bool get hasTitle => title != null && title!.isNotEmpty;

  /// Check if the note has tags
  bool get hasTags => tags.isNotEmpty;

  /// Get a preview of the content (first 100 characters)
  String get contentPreview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  /// Get display title (title or first line of content)
  String get displayTitle {
    if (hasTitle) return title!;
    final firstLine = content.split('\n').first;
    if (firstLine.length <= 50) return firstLine;
    return '${firstLine.substring(0, 50)}...';
  }

  /// Create a new personal note
  factory ChapterNote.createPersonal({
    required String chapterId,
    required String profileId,
    required String content,
    String? title,
    List<String> tags = const [],
    required String segment,
  }) {
    final now = DateTime.now();
    return ChapterNote(
      id: 'pnote_${profileId}_${now.millisecondsSinceEpoch}',
      chapterId: chapterId,
      profileId: profileId,
      content: content,
      title: title,
      tags: tags,
      isPinned: false,
      noteType: NoteType.personal,
      segment: segment,
      createdAt: now,
      updatedAt: now,
    );
  }
}
