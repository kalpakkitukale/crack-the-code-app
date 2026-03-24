/// Chapter Summary repository interface
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_summary.dart';

/// Repository interface for chapter summary operations
abstract class ChapterSummaryRepository {
  /// Get summary for a specific chapter
  /// Set [forceRefresh] to true to bypass cache and reload from JSON
  Future<Either<Failure, ChapterSummary?>> getSummary(
    String chapterId,
    String subjectId,
    String segment, {
    bool forceRefresh = false,
  });

  /// Get all summaries for a subject
  Future<Either<Failure, List<ChapterSummary>>> getSubjectSummaries(
    String subjectId,
    String segment,
  );

  /// Check if a chapter has a summary available
  Future<Either<Failure, bool>> hasSummary(
    String chapterId,
    String subjectId,
    String segment,
  );

  /// Save a summary (for caching from JSON)
  Future<Either<Failure, ChapterSummary>> saveSummary(ChapterSummary summary);

  /// Delete summary for a chapter (for cache refresh)
  Future<Either<Failure, void>> deleteSummary(String chapterId);
}
