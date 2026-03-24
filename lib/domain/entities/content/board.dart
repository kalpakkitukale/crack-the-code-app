/// Board entity representing an educational board (CBSE, ICSE, etc.)
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/domain/entities/content/class_level.dart';

part 'board.freezed.dart';

@freezed
class Board with _$Board {
  const factory Board({
    required String id,
    required String name,
    required String fullName,
    required String description,
    String? icon,
    required List<ClassLevel> classes,
  }) = _Board;

  const Board._();

  /// Get total number of classes
  int get totalClasses => classes.length;

  /// Get total number of streams across all classes
  int get totalStreams => classes.fold(0, (sum, classLevel) => sum + classLevel.streams.length);

  /// Find a class by ID
  ClassLevel? findClass(String classId) {
    try {
      return classes.firstWhere((c) => c.id == classId);
    } catch (e) {
      return null;
    }
  }
}
