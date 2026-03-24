/// Stream entity representing an academic stream (Science, Commerce, Arts)
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream.freezed.dart';

@freezed
class Stream with _$Stream {
  const factory Stream({
    required String id,
    required String name,
    required List<String> subjects,
  }) = _Stream;

  const Stream._();

  /// Get total number of subjects
  int get totalSubjects => subjects.length;

  /// Check if stream contains a specific subject
  bool hasSubject(String subjectId) => subjects.contains(subjectId);
}
