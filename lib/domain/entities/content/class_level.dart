/// Class level entity representing a grade/standard (Class 12, Class 11, etc.)
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/content/stream.dart';

part 'class_level.freezed.dart';

@freezed
class ClassLevel with _$ClassLevel {
  const factory ClassLevel({
    required String id,
    required String name,
    required List<Stream> streams,
  }) = _ClassLevel;

  const ClassLevel._();

  /// Get total number of streams
  int get totalStreams => streams.length;

  /// Find a stream by ID
  Stream? findStream(String streamId) {
    try {
      return streams.firstWhere((s) => s.id == streamId);
    } catch (e) {
      return null;
    }
  }

  /// Get all subject IDs across all streams
  Set<String> get allSubjectIds {
    final Set<String> subjectIds = {};
    for (final stream in streams) {
      subjectIds.addAll(stream.subjects);
    }
    return subjectIds;
  }
}
