/// Topic entity representing a topic within a chapter
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';

@freezed
class Topic with _$Topic {
  const factory Topic({
    required String id,
    required String name,
    required String difficulty,
    required int videoCount,
    @Default([]) List<String> keywords,
  }) = _Topic;

  const Topic._();

  /// Check if this is a basic difficulty topic
  bool get isBasic => difficulty.toLowerCase() == 'basic';

  /// Check if this is an intermediate difficulty topic
  bool get isIntermediate => difficulty.toLowerCase() == 'intermediate';

  /// Check if this is an advanced difficulty topic
  bool get isAdvanced => difficulty.toLowerCase() == 'advanced';
}
