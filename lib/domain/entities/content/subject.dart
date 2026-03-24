/// Subject entity representing an academic subject (Physics, Chemistry, etc.)
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';

part 'subject.freezed.dart';

@freezed
class Subject with _$Subject {
  const factory Subject({
    required String id,
    required String name,
    String? icon,
    String? color,
    required String boardId,
    required String classId,
    required String streamId,
    required int totalChapters,
    required List<Chapter> chapters,
    @Default([]) List<String> keywords,
  }) = _Subject;

  const Subject._();

  /// Get total number of topics across all chapters
  int get totalTopics => chapters.fold(0, (sum, chapter) => sum + chapter.topics.length);

  /// Get total number of videos across all chapters
  int get totalVideos => chapters.fold(0, (sum, chapter) => sum + chapter.totalVideoCount);

  /// Find a chapter by ID
  Chapter? findChapter(String chapterId) {
    try {
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (e) {
      return null;
    }
  }

  /// Find a chapter by number
  Chapter? findChapterByNumber(int number) {
    try {
      return chapters.firstWhere((c) => c.number == number);
    } catch (e) {
      return null;
    }
  }
}
