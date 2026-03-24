/// Glossary repository interface for managing glossary terms
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/study_tools/glossary_term.dart';

/// Repository interface for glossary term operations
abstract class GlossaryRepository {
  /// Get all terms for a chapter and segment
  Future<Either<Failure, List<GlossaryTerm>>> getTermsByChapterId(
    String chapterId,
    String segment,
  );

  /// Search terms within a chapter
  Future<Either<Failure, List<GlossaryTerm>>> searchTerms(
    String query,
    String chapterId,
    String segment,
  );

  /// Get a specific term by ID
  Future<Either<Failure, GlossaryTerm?>> getTermById(String termId);

  /// Save a term
  Future<Either<Failure, GlossaryTerm>> saveTerm(GlossaryTerm term);

  /// Save multiple terms at once
  Future<Either<Failure, void>> saveTerms(List<GlossaryTerm> terms);

  /// Get term count for a chapter
  Future<Either<Failure, int>> getTermCount(String chapterId, String segment);

  /// Delete all terms for a chapter
  Future<Either<Failure, void>> deleteTermsByChapterId(String chapterId);
}
