/// Content repository interface for accessing educational content
///
/// This interface defines the contract for content-related data operations.
/// It follows the Repository pattern and returns Either<Failure, Success>
/// for proper error handling.
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/content/board.dart';
import 'package:crack_the_code/domain/entities/content/subject.dart';
import 'package:crack_the_code/domain/entities/content/chapter.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/entities/search/unified_search_results.dart';

/// Repository interface for content operations
abstract class ContentRepository {
  /// Get all available boards (CBSE, ICSE, etc.)
  Future<Either<Failure, List<Board>>> getBoards();

  /// Get a specific board by ID
  Future<Either<Failure, Board>> getBoardById(String boardId);

  /// Get all subjects for a specific board, class, and stream
  Future<Either<Failure, List<Subject>>> getSubjects({
    required String boardId,
    required String classId,
    required String streamId,
  });

  /// Get a specific subject by ID
  Future<Either<Failure, Subject>> getSubjectById(String subjectId);

  /// Get all chapters for a specific subject
  Future<Either<Failure, List<Chapter>>> getChapters(String subjectId);

  /// Get a specific chapter by ID
  Future<Either<Failure, Chapter>> getChapterById({
    required String subjectId,
    required String chapterId,
  });

  /// Get all videos for a specific chapter
  Future<Either<Failure, List<Video>>> getVideos({
    required String subjectId,
    required String chapterId,
  });

  /// Get videos for a specific topic
  Future<Either<Failure, List<Video>>> getVideosByTopic({
    required String subjectId,
    required String chapterId,
    required String topicId,
  });

  /// Get a specific video by ID
  Future<Either<Failure, Video>> getVideoById(String videoId);

  /// Search videos by query
  Future<Either<Failure, List<Video>>> searchVideos({
    required String query,
    String? difficulty,
    String? language,
    List<String>? examRelevance,
  });

  /// Get videos filtered by criteria
  Future<Either<Failure, List<Video>>> getFilteredVideos({
    String? subjectId,
    String? chapterId,
    String? topicId,
    String? difficulty,
    String? language,
    List<String>? examRelevance,
    List<String>? tags,
  });

  /// Unified search across all content types (subjects, chapters, topics, videos)
  ///
  /// Returns a [UnifiedSearchResults] containing all matching results sorted by relevance.
  /// Results are scored based on match quality and content type.
  Future<Either<Failure, UnifiedSearchResults>> searchContent({
    required String query,
    String? subjectFilter,
    String? difficulty,
    int maxResultsPerType = 10,
  });

  /// Get all subjects from all boards for filter dropdowns
  Future<Either<Failure, List<Subject>>> getAllSubjects();
}
