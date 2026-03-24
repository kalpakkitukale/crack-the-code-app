/// Q&A repository interface for managing video questions and answers
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/study_tools/video_question.dart';

/// Repository interface for video Q&A operations
abstract class QARepository {
  /// Get all questions for a video
  Future<Either<Failure, List<VideoQuestion>>> getQuestionsByVideoId(String videoId);

  /// Get answered questions only
  Future<Either<Failure, List<VideoQuestion>>> getAnsweredQuestions(String videoId);

  /// Get pending questions only
  Future<Either<Failure, List<VideoQuestion>>> getPendingQuestions(String videoId);

  /// Ask a new question
  Future<Either<Failure, VideoQuestion>> askQuestion(VideoQuestion question);

  /// Answer a question
  Future<Either<Failure, VideoQuestion>> answerQuestion(
    String questionId,
    String answer,
  );

  /// Upvote a question
  Future<Either<Failure, void>> upvoteQuestion(String questionId);

  /// Delete a question
  Future<Either<Failure, void>> deleteQuestion(String questionId);

  /// Get question count for a video
  Future<Either<Failure, int>> getQuestionCount(String videoId);
}
