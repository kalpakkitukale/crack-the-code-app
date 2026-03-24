/// Q&A repository implementation
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/json/study_tools_json_datasource.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/video_qa_dao.dart';
import 'package:crack_the_code/domain/entities/study_tools/video_question.dart';
import 'package:crack_the_code/domain/repositories/study_tools/qa_repository.dart';

/// Implementation of QARepository using JSON-first loading with database caching
/// FAQs are read-only from JSON; only upvotes are stored in database
class QARepositoryImpl implements QARepository {
  final VideoQADao _qaDao;
  final StudyToolsJsonDataSource _jsonDataSource;

  /// Optional profile ID for multi-profile support
  String? profileId;

  /// Subject and chapter IDs for JSON lookup (set by provider)
  String? subjectId;
  String? chapterId;

  QARepositoryImpl(this._qaDao, this._jsonDataSource);

  @override
  Future<Either<Failure, List<VideoQuestion>>> getQuestionsByVideoId(
    String videoId,
  ) async {
    try {
      logger.info('Getting questions for video: $videoId');

      // 1. Check database cache first
      var models = await _qaDao.getByVideoId(videoId, profileId: profileId);

      // 2. If empty and subject/chapter IDs are set, load from JSON
      if (models.isEmpty && subjectId != null && chapterId != null) {
        // Ensure FAQs are loaded
        await _jsonDataSource.loadFaqs(
          subjectId: subjectId!,
          chapterId: chapterId!,
        );

        // Get from JSON cache
        final jsonModels = _jsonDataSource.getFaqsByVideoId(
          subjectId: subjectId!,
          chapterId: chapterId!,
          videoId: videoId,
        );

        if (jsonModels.isNotEmpty) {
          // Cache to database (with profile ID if set)
          for (var faq in jsonModels) {
            if (profileId != null && profileId!.isNotEmpty) {
              faq = faq.copyWithProfileId(profileId!);
            }
            await _qaDao.insert(faq);
          }
          models = jsonModels;
          logger.info('FAQs loaded from JSON and cached: ${models.length} questions');
        }
      }

      final questions = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${questions.length} questions');
      return Right(questions);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting questions', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get questions',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting questions', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<VideoQuestion>>> getAnsweredQuestions(
    String videoId,
  ) async {
    try {
      logger.info('Getting answered questions for video: $videoId');

      // Ensure questions are loaded
      await getQuestionsByVideoId(videoId);

      final models = await _qaDao.getByStatus(videoId, 'answered');
      final questions = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${questions.length} answered questions');
      return Right(questions);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting answered questions', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get questions',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting answered questions', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<VideoQuestion>>> getPendingQuestions(
    String videoId,
  ) async {
    try {
      logger.info('Getting pending questions for video: $videoId');

      // Ensure questions are loaded
      await getQuestionsByVideoId(videoId);

      final models = await _qaDao.getByStatus(videoId, 'pending');
      final questions = models.map((model) => model.toEntity()).toList();

      logger.info('Retrieved ${questions.length} pending questions');
      return Right(questions);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting pending questions', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get questions',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting pending questions', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, VideoQuestion>> askQuestion(
    VideoQuestion question,
  ) async {
    // FAQs are read-only in offline-first mode
    // User-generated questions are no longer supported
    return Left(UnknownFailure(
      message: 'Adding questions is not supported in offline mode',
      details: 'FAQs are pre-curated and read-only',
    ));
  }

  @override
  Future<Either<Failure, VideoQuestion>> answerQuestion(
    String questionId,
    String answer,
  ) async {
    // Answering is not supported in offline mode
    return Left(UnknownFailure(
      message: 'Answering questions is not supported in offline mode',
      details: 'FAQs are pre-curated and read-only',
    ));
  }

  @override
  Future<Either<Failure, void>> upvoteQuestion(String questionId) async {
    try {
      logger.info('Upvoting question: $questionId');

      await _qaDao.upvote(questionId);

      logger.info('Question upvoted successfully');
      return const Right(null);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error upvoting question', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to upvote question',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error upvoting question', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuestion(String questionId) async {
    // Deleting pre-curated FAQs is not supported
    return Left(UnknownFailure(
      message: 'Deleting FAQs is not supported',
      details: 'FAQs are pre-curated and read-only',
    ));
  }

  @override
  Future<Either<Failure, int>> getQuestionCount(String videoId) async {
    try {
      logger.debug('Getting question count for video: $videoId');

      // Ensure questions are loaded
      await getQuestionsByVideoId(videoId);

      final count = await _qaDao.getCountByVideoId(videoId);

      return Right(count);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting count', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get question count',
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
}
