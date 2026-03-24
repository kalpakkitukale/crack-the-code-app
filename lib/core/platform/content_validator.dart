import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/content/board.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';
import 'package:streamshaala/domain/entities/content/subject.dart';
import 'package:streamshaala/domain/entities/content/video.dart';

/// Validates content consistency across platforms
/// Ensures all platforms have the same content structure and data
class ContentValidator {
  static final ContentValidator _instance = ContentValidator._internal();
  factory ContentValidator() => _instance;
  ContentValidator._internal();

  /// Validate board data structure
  ValidationResult validateBoard(Board board) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields
    if (board.id.isEmpty) errors.add('Board ID is empty');
    if (board.name.isEmpty) errors.add('Board name is empty');

    // Check for classes
    if (board.classes.isEmpty) {
      warnings.add('Board has no classes');
    } else {
      // Validate each class
      for (final classItem in board.classes) {
        if (classItem.id.isEmpty) errors.add('Class ID is empty for ${classItem.name}');
        if (classItem.name.isEmpty) errors.add('Class name is empty');

        // Check for streams
        if (classItem.streams.isEmpty) {
          warnings.add('Class ${classItem.name} has no streams');
        } else {
          for (final stream in classItem.streams) {
            if (stream.id.isEmpty) errors.add('Stream ID is empty for ${stream.name}');
            if (stream.name.isEmpty) errors.add('Stream name is empty');

            if (stream.subjects.isEmpty) {
              warnings.add('Stream ${stream.name} has no subjects');
            }
          }
        }
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      checksum: _calculateChecksum(board),
    );
  }

  /// Validate subject data structure
  ValidationResult validateSubject(Subject subject) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields
    if (subject.id.isEmpty) errors.add('Subject ID is empty');
    if (subject.name.isEmpty) errors.add('Subject name is empty');

    // Check for chapters
    if (subject.chapters.isEmpty) {
      warnings.add('Subject has no chapters');
    } else {
      // Validate each chapter
      for (final chapter in subject.chapters) {
        final chapterValidation = validateChapter(chapter);
        errors.addAll(chapterValidation.errors);
        warnings.addAll(chapterValidation.warnings);
      }
    }

    // Check for consistency in chapter ordering
    final chapterOrders = subject.chapters.map((c) => c.number).toSet();
    if (chapterOrders.length != subject.chapters.length) {
      errors.add('Duplicate chapter order values found');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      checksum: _calculateChecksum(subject),
    );
  }

  /// Validate chapter data structure
  ValidationResult validateChapter(Chapter chapter) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields
    if (chapter.id.isEmpty) errors.add('Chapter ID is empty');
    if (chapter.name.isEmpty) errors.add('Chapter name is empty');

    // Check for videos via topics
    if (chapter.totalVideoCount == 0) {
      warnings.add('Chapter ${chapter.name} has no videos');
    }

    // Validate chapter number
    if (chapter.number < 0) {
      errors.add('Chapter ${chapter.name} has invalid order: ${chapter.number}');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      checksum: _calculateChecksum(chapter),
    );
  }

  /// Validate video data structure
  ValidationResult validateVideo(Video video) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields
    if (video.id.isEmpty) errors.add('Video ID is empty');
    if (video.title.isEmpty) errors.add('Video title is empty');

    // YouTube specific validation
    if (video.youtubeId.isEmpty) {
      errors.add('YouTube ID is empty for video: ${video.title}');
    } else if (!_isValidYouTubeId(video.youtubeId)) {
      errors.add('Invalid YouTube ID format: ${video.youtubeId}');
    }

    // Optional but recommended fields
    if (video.duration == 0) {
      warnings.add('Video ${video.title} has no duration set');
    }

    if (video.thumbnailUrl.isEmpty) {
      warnings.add('Video ${video.title} has no thumbnail');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      checksum: _calculateChecksum(video),
    );
  }

  /// Validate content consistency across platforms
  Future<CrossPlatformValidation> validateCrossPlatform({
    required Map<String, dynamic> iosContent,
    required Map<String, dynamic> androidContent,
  }) async {
    logger.info('🔍 Validating cross-platform content consistency...');

    final inconsistencies = <String>[];
    final structuralDifferences = <String>[];

    // Compare board counts
    final iosBoards = iosContent['boards'] as List? ?? [];
    final androidBoards = androidContent['boards'] as List? ?? [];

    if (iosBoards.length != androidBoards.length) {
      inconsistencies.add(
        'Board count mismatch: iOS has ${iosBoards.length}, Android has ${androidBoards.length}'
      );
    }

    // Compare board IDs
    final iosBoardIds = iosBoards.map((b) => b['id']).toSet();
    final androidBoardIds = androidBoards.map((b) => b['id']).toSet();

    final iosOnly = iosBoardIds.difference(androidBoardIds);
    final androidOnly = androidBoardIds.difference(iosBoardIds);

    if (iosOnly.isNotEmpty) {
      inconsistencies.add('Boards only on iOS: ${iosOnly.join(', ')}');
    }
    if (androidOnly.isNotEmpty) {
      inconsistencies.add('Boards only on Android: ${androidOnly.join(', ')}');
    }

    // Deep compare common boards
    for (final boardId in iosBoardIds.intersection(androidBoardIds)) {
      final iosBoard = iosBoards.firstWhere((b) => b['id'] == boardId);
      final androidBoard = androidBoards.firstWhere((b) => b['id'] == boardId);

      _compareBoards(iosBoard, androidBoard, inconsistencies, structuralDifferences);
    }

    // Calculate overall checksum
    final iosChecksum = _calculateContentChecksum(iosContent);
    final androidChecksum = _calculateContentChecksum(androidContent);

    return CrossPlatformValidation(
      isConsistent: inconsistencies.isEmpty && structuralDifferences.isEmpty,
      inconsistencies: inconsistencies,
      structuralDifferences: structuralDifferences,
      iosChecksum: iosChecksum,
      androidChecksum: androidChecksum,
      checksumMatch: iosChecksum == androidChecksum,
    );
  }

  /// Compare two board structures
  void _compareBoards(
    Map<String, dynamic> board1,
    Map<String, dynamic> board2,
    List<String> inconsistencies,
    List<String> differences,
  ) {
    final boardId = board1['id'];

    // Compare classes
    final classes1 = board1['classes'] as List? ?? [];
    final classes2 = board2['classes'] as List? ?? [];

    if (classes1.length != classes2.length) {
      differences.add('Board $boardId: class count differs (${classes1.length} vs ${classes2.length})');
    }

    // Compare subjects for each class/stream
    for (final class1 in classes1) {
      final classId = class1['id'];
      final class2 = classes2.firstWhere(
        (c) => c['id'] == classId,
        orElse: () => null,
      );

      if (class2 == null) {
        inconsistencies.add('Class $classId missing in board $boardId on one platform');
        continue;
      }

      final streams1 = class1['streams'] as List? ?? [];
      final streams2 = class2['streams'] as List? ?? [];

      for (final stream1 in streams1) {
        final streamId = stream1['id'];
        final stream2 = streams2.firstWhere(
          (s) => s['id'] == streamId,
          orElse: () => null,
        );

        if (stream2 == null) {
          inconsistencies.add('Stream $streamId missing in class $classId on one platform');
          continue;
        }

        final subjects1 = (stream1['subjects'] as List? ?? []).cast<String>().toSet();
        final subjects2 = (stream2['subjects'] as List? ?? []).cast<String>().toSet();

        if (!subjects1.equals(subjects2)) {
          inconsistencies.add(
            'Subject mismatch in $boardId/$classId/$streamId: '
            '${subjects1.difference(subjects2).union(subjects2.difference(subjects1)).join(', ')}'
          );
        }
      }
    }
  }

  /// Validate YouTube ID format
  bool _isValidYouTubeId(String id) {
    // YouTube IDs are typically 11 characters with specific pattern
    final regex = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return regex.hasMatch(id);
  }

  /// Calculate checksum for any content object
  String _calculateChecksum(dynamic content) {
    final json = jsonEncode(content);
    return sha256.convert(utf8.encode(json)).toString().substring(0, 16);
  }

  /// Calculate checksum for entire content structure
  String _calculateContentChecksum(Map<String, dynamic> content) {
    // Sort keys for consistent ordering
    final sortedJson = jsonEncode(_sortMap(content));
    return sha256.convert(utf8.encode(sortedJson)).toString();
  }

  /// Recursively sort map keys for consistent JSON
  dynamic _sortMap(dynamic obj) {
    if (obj is Map) {
      final sorted = <String, dynamic>{};
      final keys = obj.keys.toList()..sort();
      for (final key in keys) {
        sorted[key] = _sortMap(obj[key]);
      }
      return sorted;
    } else if (obj is List) {
      return obj.map(_sortMap).toList();
    }
    return obj;
  }

  /// Generate validation report
  Map<String, dynamic> generateReport(List<ValidationResult> results) {
    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'totalValidations': results.length,
      'passed': results.where((r) => r.isValid).length,
      'failed': results.where((r) => !r.isValid).length,
      'totalErrors': results.fold(0, (sum, r) => sum + r.errors.length),
      'totalWarnings': results.fold(0, (sum, r) => sum + r.warnings.length),
      'details': results.map((r) => r.toJson()).toList(),
    };

    return report;
  }
}

/// Validation result for a single content item
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final String checksum;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'errors': errors,
    'warnings': warnings,
    'checksum': checksum,
  };
}

/// Cross-platform validation result
class CrossPlatformValidation {
  final bool isConsistent;
  final List<String> inconsistencies;
  final List<String> structuralDifferences;
  final String iosChecksum;
  final String androidChecksum;
  final bool checksumMatch;

  CrossPlatformValidation({
    required this.isConsistent,
    required this.inconsistencies,
    required this.structuralDifferences,
    required this.iosChecksum,
    required this.androidChecksum,
    required this.checksumMatch,
  });

  Map<String, dynamic> toJson() => {
    'isConsistent': isConsistent,
    'inconsistencies': inconsistencies,
    'structuralDifferences': structuralDifferences,
    'iosChecksum': iosChecksum,
    'androidChecksum': androidChecksum,
    'checksumMatch': checksumMatch,
  };
}

/// Extension to compare sets
extension SetExtension<T> on Set<T> {
  bool equals(Set<T> other) {
    return length == other.length && difference(other).isEmpty;
  }
}