/// Chapter entity representing a chapter within a subject
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/content/topic.dart';

part 'chapter.freezed.dart';

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required int number,
    required String name,
    String? description,
    required List<Topic> topics,
    @Default([]) List<String> keywords,
  }) = _Chapter;

  const Chapter._();

  /// Get total number of videos across all topics
  int get totalVideoCount => topics.fold(0, (sum, topic) => sum + topic.videoCount);

  /// Find a topic by ID
  Topic? findTopic(String topicId) {
    try {
      return topics.firstWhere((t) => t.id == topicId);
    } catch (e) {
      return null;
    }
  }

  /// Get topics by difficulty level
  List<Topic> getTopicsByDifficulty(String difficulty) {
    return topics.where((t) => t.difficulty == difficulty).toList();
  }

  /// Get all unique difficulty levels in this chapter
  Set<String> get difficultyLevels {
    return topics.map((t) => t.difficulty).toSet();
  }
}
