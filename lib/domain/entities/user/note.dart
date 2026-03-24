/// Note entity for video notes
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String videoId,
    required String content,
    int? timestampSeconds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Note;

  const Note._();

  /// Check if note has timestamp
  bool get hasTimestamp => timestampSeconds != null;

  /// Get formatted timestamp (HH:MM:SS or MM:SS)
  String? get formattedTimestamp {
    if (timestampSeconds == null) return null;

    final hours = timestampSeconds! ~/ 3600;
    final minutes = (timestampSeconds! % 3600) ~/ 60;
    final seconds = timestampSeconds! % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Check if note was recently updated (within last 24 hours)
  bool get isRecentlyUpdated {
    final now = DateTime.now();
    final dayAgo = now.subtract(const Duration(hours: 24));
    return updatedAt.isAfter(dayAgo);
  }

  /// Check if note was modified after creation
  bool get wasModified => updatedAt.isAfter(createdAt);

  /// Get preview of content (first 100 characters)
  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  /// Get word count
  int get wordCount {
    return content.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
}
