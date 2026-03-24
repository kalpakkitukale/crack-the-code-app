/// Glossary repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/study_tools_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/glossary_dao.dart';
import 'package:streamshaala/data/models/study_tools/glossary_term_model.dart';
import 'package:streamshaala/domain/entities/study_tools/glossary_term.dart';
import 'package:streamshaala/domain/repositories/study_tools/glossary_repository.dart';

/// Implementation of GlossaryRepository using JSON-first loading with database caching
class GlossaryRepositoryImpl implements GlossaryRepository {
  final GlossaryDao _glossaryDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  /// Subject ID for JSON lookup (set by provider)
  String? subjectId;

  GlossaryRepositoryImpl(this._glossaryDao, this._jsonDataSource);

  @override
  Future<Either<Failure, List<GlossaryTerm>>> getTermsByChapterId(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.info('Getting glossary terms for chapter: $chapterId');

      // 1. Check database cache first
      final cached = await _glossaryDao.getByChapterId(chapterId, segment);
      if (cached.isNotEmpty) {
        logger.debug('Glossary found in database cache: ${cached.length} terms');
        return Right(cached.map((model) => model.toEntity()).toList());
      }

      // 2. Load from JSON if subject ID is set
      if (subjectId != null) {
        final jsonModels = await _jsonDataSource.loadGlossary(
          subjectId: subjectId!,
          chapterId: chapterId,
          segment: segment,
        );

        if (jsonModels.isNotEmpty) {
          // Cache to database
          await _glossaryDao.insertAll(jsonModels);
          logger.info('Glossary loaded from JSON and cached: ${jsonModels.length} terms');
          return Right(jsonModels.map((model) => model.toEntity()).toList());
        }
      }

      logger.info('No glossary terms found');
      return const Right([]);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting glossary terms', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get glossary terms',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting glossary terms', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<GlossaryTerm>>> searchTerms(
    String query,
    String chapterId,
    String segment,
  ) async {
    try {
      logger.info('Searching glossary terms: $query in chapter: $chapterId');

      // First ensure terms are loaded
      await getTermsByChapterId(chapterId, segment);

      // Then search in database
      final models = await _glossaryDao.searchTerms(query, chapterId, segment);
      final terms = models.map((model) => model.toEntity()).toList();

      logger.info('Found ${terms.length} matching terms');
      return Right(terms);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error searching terms', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to search glossary terms',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error searching terms', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, GlossaryTerm?>> getTermById(String termId) async {
    try {
      logger.debug('Getting term by ID: $termId');

      final model = await _glossaryDao.getById(termId);
      final term = model?.toEntity();

      return Right(term);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting term', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get glossary term',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting term', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, GlossaryTerm>> saveTerm(GlossaryTerm term) async {
    try {
      logger.info('Saving glossary term: ${term.term}');

      final model = GlossaryTermModel.fromEntity(term);
      await _glossaryDao.insert(model);

      logger.info('Term saved successfully');
      return Right(term);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving term', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save glossary term',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving term', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveTerms(List<GlossaryTerm> terms) async {
    try {
      logger.info('Saving ${terms.length} glossary terms');

      final models = terms.map((t) => GlossaryTermModel.fromEntity(t)).toList();
      await _glossaryDao.insertAll(models);

      logger.info('Terms saved successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error saving terms', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to save glossary terms',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error saving terms', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getTermCount(
    String chapterId,
    String segment,
  ) async {
    try {
      logger.debug('Getting term count for chapter: $chapterId');

      // First ensure terms are loaded
      await getTermsByChapterId(chapterId, segment);

      final count = await _glossaryDao.getCountByChapterId(chapterId, segment);

      return Right(count);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting count', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get term count',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting count', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTermsByChapterId(String chapterId) async {
    try {
      logger.info('Deleting glossary terms for chapter: $chapterId');

      await _glossaryDao.deleteByChapterId(chapterId);

      logger.info('Terms deleted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting terms', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete glossary terms',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting terms', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
