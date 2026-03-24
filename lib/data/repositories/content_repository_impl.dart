/// Content repository implementation using JSON data source
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/content_json_datasource.dart';
import 'package:streamshaala/domain/entities/content/board.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';
import 'package:streamshaala/domain/entities/content/subject.dart';
import 'package:streamshaala/domain/entities/content/video.dart';
import 'package:streamshaala/domain/entities/search/search_result.dart';
import 'package:streamshaala/domain/entities/search/unified_search_results.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';

/// Implementation of ContentRepository using JSON assets
class ContentRepositoryImpl implements ContentRepository {
  final ContentJsonDataSource _jsonDataSource;

  const ContentRepositoryImpl(this._jsonDataSource);

  @override
  Future<Either<Failure, List<Board>>> getBoards() async {
    try {
      logger.info('Getting all boards');

      final models = await _jsonDataSource.loadBoards();
      final entities = models.map((m) => m.toEntity()).toList();

      logger.info('Retrieved ${entities.length} boards');
      return Right(entities);
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found while loading boards', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Failed to load boards',
        entityType: 'Board',
        entityId: 'all',
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while loading boards', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid board data format',
        fieldErrors: {'boards': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error while loading boards', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading boards',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Board>> getBoardById(String boardId) async {
    try {
      logger.info('Getting board by ID: $boardId');

      final model = await _jsonDataSource.loadBoardById(boardId);
      final entity = model.toEntity();

      logger.info('Board retrieved: ${entity.name}');
      return Right(entity);
    } on NotFoundException catch (e, stackTrace) {
      logger.error('Board not found: $boardId', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Board not found',
        entityType: 'Board',
        entityId: boardId,
      ));
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found for board: $boardId', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Board file not found',
        entityType: 'Board',
        entityId: boardId,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error for board: $boardId', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid board data format',
        fieldErrors: {'board': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting board: $boardId', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading board',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Subject>>> getSubjects({
    required String boardId,
    required String classId,
    required String streamId,
  }) async {
    try {
      logger.info('Getting subjects for board: $boardId, class: $classId, stream: $streamId');

      // Load the board to get its structure
      final boardModel = await _jsonDataSource.loadBoardById(boardId);
      final board = boardModel.toEntity();

      // Find the class
      final classEntity = board.classes.firstWhere(
        (c) => c.id == classId,
        orElse: () => throw NotFoundException(
          message: 'Class not found',
          entityType: 'Class',
          entityId: classId,
        ),
      );

      // Find the stream
      final streamEntity = classEntity.streams.firstWhere(
        (s) => s.id == streamId,
        orElse: () => throw NotFoundException(
          message: 'Stream not found',
          entityType: 'Stream',
          entityId: streamId,
        ),
      );

      // Load the actual Subject entities based on the subject IDs
      final subjectIds = streamEntity.subjects;
      final subjects = <Subject>[];

      for (final subjectId in subjectIds) {
        try {
          final subjectModel = await _jsonDataSource.loadSubjectById(subjectId);
          subjects.add(subjectModel.toEntity());
        } catch (e) {
          logger.warning('Could not load subject: $subjectId', e);
          // Continue loading other subjects even if one fails
        }
      }

      logger.info('Retrieved ${subjects.length} subjects');
      return Right(subjects);
    } on NotFoundException catch (e, stackTrace) {
      logger.error('Entity not found while getting subjects', e, stackTrace);
      return Left(NotFoundFailure(
        message: e.message,
        entityType: e.entityType,
        entityId: e.entityId,
      ));
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found while getting subjects', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Board file not found',
        entityType: 'Board',
        entityId: boardId,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while getting subjects', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid data format',
        fieldErrors: {'subjects': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting subjects', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading subjects',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Subject>> getSubjectById(String subjectId) async {
    try {
      logger.info('Getting subject by ID: $subjectId');

      final model = await _jsonDataSource.loadSubjectById(subjectId);
      final entity = model.toEntity();

      logger.info('Subject retrieved: ${entity.name}');
      return Right(entity);
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found for subject: $subjectId', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Subject file not found',
        entityType: 'Subject',
        entityId: subjectId,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error for subject: $subjectId', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid subject data format',
        fieldErrors: {'subject': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting subject: $subjectId', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading subject',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Chapter>>> getChapters(String subjectId) async {
    try {
      logger.info('Getting chapters for subject: $subjectId');

      final subjectModel = await _jsonDataSource.loadSubjectById(subjectId);
      final subject = subjectModel.toEntity();
      final chapters = subject.chapters;

      logger.info('Retrieved ${chapters.length} chapters');
      return Right(chapters);
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found while getting chapters', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Subject file not found',
        entityType: 'Subject',
        entityId: subjectId,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while getting chapters', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid subject data format',
        fieldErrors: {'chapters': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting chapters', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading chapters',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Chapter>> getChapterById({
    required String subjectId,
    required String chapterId,
  }) async {
    try {
      logger.info('Getting chapter by ID: $chapterId in subject: $subjectId');

      final subjectModel = await _jsonDataSource.loadSubjectById(subjectId);
      final subject = subjectModel.toEntity();

      final chapter = subject.chapters.firstWhere(
        (c) => c.id == chapterId,
        orElse: () => throw NotFoundException(
          message: 'Chapter not found',
          entityType: 'Chapter',
          entityId: chapterId,
        ),
      );

      logger.info('Chapter retrieved: ${chapter.name}');
      return Right(chapter);
    } on NotFoundException catch (e, stackTrace) {
      logger.error('Chapter not found: $chapterId', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Chapter not found',
        entityType: 'Chapter',
        entityId: chapterId,
      ));
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found while getting chapter', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Subject file not found',
        entityType: 'Subject',
        entityId: subjectId,
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while getting chapter', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid subject data format',
        fieldErrors: {'chapter': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting chapter', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading chapter',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getVideos({
    required String subjectId,
    required String chapterId,
  }) async {
    try {
      logger.info('Getting videos for subject: $subjectId, chapter: $chapterId');

      final models = await _jsonDataSource.loadVideos(
        subjectId: subjectId,
        chapterId: chapterId,
      );
      final entities = models.map((m) => m.toEntity()).toList();

      logger.info('Retrieved ${entities.length} videos');
      return Right(entities);
    } on AssetNotFoundException catch (e) {
      logger.info('No videos file for $subjectId/$chapterId - returning empty list');
      return const Right([]);
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while loading videos', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid videos data format',
        fieldErrors: {'videos': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error loading videos', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading videos',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getVideosByTopic({
    required String subjectId,
    required String chapterId,
    required String topicId,
  }) async {
    try {
      logger.info('Getting videos for topic: $topicId in chapter: $chapterId');

      final models = await _jsonDataSource.loadVideos(
        subjectId: subjectId,
        chapterId: chapterId,
      );

      // Filter videos by topic
      final filteredModels = models.where((v) => v.topicId == topicId).toList();
      final entities = filteredModels.map((m) => m.toEntity()).toList();

      logger.info('Retrieved ${entities.length} videos for topic: $topicId');
      return Right(entities);
    } on AssetNotFoundException catch (e) {
      logger.info('No videos file for $subjectId/$chapterId (topic: $topicId) - returning empty list');
      return const Right([]);
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while loading videos by topic', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid videos data format',
        fieldErrors: {'videos': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error loading videos by topic', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading videos by topic',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Video>> getVideoById(String videoId) async {
    try {
      logger.info('Getting video by ID: $videoId');

      // Note: This is a simplified implementation that searches through all cached videos
      // In a production app, you might want to implement a more efficient lookup mechanism
      // For now, we'll throw a not found exception as we need chapter/subject context
      throw NotFoundException(
        message: 'Video lookup by ID alone is not supported. Please use getVideos with subject and chapter context.',
        entityType: 'Video',
        entityId: videoId,
      );
    } on NotFoundException catch (e, stackTrace) {
      logger.error('Video not found: $videoId', e, stackTrace);
      return Left(NotFoundFailure(
        message: e.message,
        entityType: 'Video',
        entityId: videoId,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting video: $videoId', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading video',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Video>>> searchVideos({
    required String query,
    String? difficulty,
    String? language,
    List<String>? examRelevance,
  }) async {
    try {
      logger.info('Searching videos with query: $query');

      // Normalize query for better matching
      final normalizedQuery = query.toLowerCase().trim();
      if (normalizedQuery.isEmpty) {
        logger.info('Search query is empty, returning empty list');
        return const Right([]);
      }

      // Split query into search terms for better matching
      final searchTerms = normalizedQuery.split(RegExp(r'\s+'));

      // Load all videos from all subjects
      final allVideos = <Video>[];
      final seenVideoIds = <String>{}; // Track unique videos to prevent duplicates

      // Load all subjects first
      final boardsResult = await getBoards();
      if (boardsResult.isLeft()) {
        logger.error('Failed to load boards for search');
        return const Right([]);
      }

      final boards = boardsResult.getOrElse(() => []);

      for (final board in boards) {
        for (final classEntity in board.classes) {
          for (final stream in classEntity.streams) {
            for (final subjectId in stream.subjects) {
              try {
                // Load subject to get chapters
                final subjectModel = await _jsonDataSource.loadSubjectById(subjectId);
                final subject = subjectModel.toEntity();

                // Load videos for each chapter
                for (final chapter in subject.chapters) {
                  try {
                    final videos = await _jsonDataSource.loadVideos(
                      subjectId: subjectId,
                      chapterId: chapter.id,
                    );

                    // Convert to entities and add subject/chapter context
                    for (final videoModel in videos) {
                      final video = videoModel.toEntity();

                      // Only add unique videos (check by youtubeId to prevent duplicates)
                      if (!seenVideoIds.contains(video.youtubeId)) {
                        seenVideoIds.add(video.youtubeId);
                        // Store video with additional context for search ranking
                        allVideos.add(video.copyWith(
                          // Add subject name to tags for better search
                          tags: [...video.tags, subject.name, chapter.name],
                        ));
                      }
                    }
                  } catch (e) {
                    logger.debug('Could not load videos for chapter ${chapter.id}: $e');
                    // Continue loading other chapters
                  }
                }
              } catch (e) {
                logger.debug('Could not load subject $subjectId: $e');
                // Continue loading other subjects
              }
            }
          }
        }
      }

      logger.info('Loaded ${allVideos.length} unique videos for search (from ${seenVideoIds.length} total)');

      // Calculate relevance scores for each video
      final scoredVideos = <(Video, double)>[];

      for (final video in allVideos) {
        double score = 0.0;

        // Title matching (highest weight)
        final titleLower = video.title.toLowerCase();
        for (final term in searchTerms) {
          if (titleLower.contains(term)) {
            // Exact word match gets higher score
            if (RegExp(r'\b' + RegExp.escape(term) + r'\b').hasMatch(titleLower)) {
              score += 10.0;
            } else {
              score += 5.0;
            }

            // Bonus if term appears at the beginning of title
            if (titleLower.startsWith(term)) {
              score += 3.0;
            }
          }
        }

        // Description matching (medium weight)
        final descriptionLower = video.description.toLowerCase();
        for (final term in searchTerms) {
          if (descriptionLower.contains(term)) {
            score += 3.0;
          }
        }

        // Tags matching (medium weight)
        for (final tag in video.tags) {
          final tagLower = tag.toLowerCase();
          for (final term in searchTerms) {
            if (tagLower.contains(term)) {
              // Exact tag match gets higher score
              if (tagLower == term) {
                score += 5.0;
              } else {
                score += 2.0;
              }
            }
          }
        }

        // Channel name matching (low weight)
        final channelLower = video.channelName.toLowerCase();
        for (final term in searchTerms) {
          if (channelLower.contains(term)) {
            score += 1.0;
          }
        }

        // Boost score based on video quality indicators
        if (video.isHighlyRated) {
          score *= 1.2; // 20% boost for highly rated videos
        }
        if (video.isPopular) {
          score *= 1.1; // 10% boost for popular videos
        }

        // Only include videos with a positive score
        if (score > 0) {
          scoredVideos.add((video, score));
        }
      }

      // Sort by score (highest first)
      scoredVideos.sort((a, b) => b.$2.compareTo(a.$2));

      // Extract just the videos
      var searchResults = scoredVideos.map((e) => e.$1).toList();

      logger.info('Found ${searchResults.length} matching videos before filtering');

      // Apply filters if provided
      if (difficulty != null) {
        searchResults = searchResults
            .where((v) => v.difficulty.toLowerCase() == difficulty.toLowerCase())
            .toList();
        logger.info('After difficulty filter: ${searchResults.length} videos');
      }

      if (language != null) {
        searchResults = searchResults
            .where((v) => v.language.toLowerCase() == language.toLowerCase())
            .toList();
        logger.info('After language filter: ${searchResults.length} videos');
      }

      if (examRelevance != null && examRelevance.isNotEmpty) {
        searchResults = searchResults
            .where((v) => examRelevance.any((exam) =>
                v.examRelevance.any((e) => e.toLowerCase() == exam.toLowerCase())))
            .toList();
        logger.info('After exam relevance filter: ${searchResults.length} videos');
      }

      // Limit results to prevent UI overload (can be made configurable)
      const maxResults = 50;
      if (searchResults.length > maxResults) {
        searchResults = searchResults.take(maxResults).toList();
        logger.info('Limited results to $maxResults videos');
      }

      logger.info('Search completed: ${searchResults.length} results for query "$query"');
      return Right(searchResults);
    } catch (e, stackTrace) {
      logger.error('Unknown error searching videos', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while searching videos',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getFilteredVideos({
    String? subjectId,
    String? chapterId,
    String? topicId,
    String? difficulty,
    String? language,
    List<String>? examRelevance,
    List<String>? tags,
  }) async {
    try {
      logger.info('Getting filtered videos');

      // If subject and chapter are provided, load and filter
      if (subjectId != null && chapterId != null) {
        final models = await _jsonDataSource.loadVideos(
          subjectId: subjectId,
          chapterId: chapterId,
        );

        var filteredModels = models;

        // Apply topic filter
        if (topicId != null) {
          filteredModels = filteredModels.where((v) => v.topicId == topicId).toList();
        }

        // Apply difficulty filter
        if (difficulty != null) {
          filteredModels = filteredModels.where((v) => v.difficulty == difficulty).toList();
        }

        // Apply language filter
        if (language != null) {
          filteredModels = filteredModels.where((v) => v.language == language).toList();
        }

        // Apply exam relevance filter
        if (examRelevance != null && examRelevance.isNotEmpty) {
          filteredModels = filteredModels.where((v) {
            return examRelevance.any((exam) => v.examRelevance.contains(exam));
          }).toList();
        }

        // Apply tags filter
        if (tags != null && tags.isNotEmpty) {
          filteredModels = filteredModels.where((v) {
            return tags.any((tag) => v.tags.contains(tag));
          }).toList();
        }

        final entities = filteredModels.map((m) => m.toEntity()).toList();
        logger.info('Retrieved ${entities.length} filtered videos');
        return Right(entities);
      }

      // If no subject/chapter context, return empty list
      logger.warning('Filtered videos requires subject and chapter context. Returning empty list.');
      return const Right([]);
    } on AssetNotFoundException catch (e, stackTrace) {
      logger.error('Asset not found while filtering videos', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Videos file not found',
        entityType: 'Video',
        entityId: '$subjectId/$chapterId',
      ));
    } on JsonParseException catch (e, stackTrace) {
      logger.error('JSON parse error while filtering videos', e, stackTrace);
      return Left(ValidationFailure(
        message: 'Invalid videos data format',
        fieldErrors: {'videos': e.message},
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error filtering videos', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while filtering videos',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, UnifiedSearchResults>> searchContent({
    required String query,
    String? subjectFilter,
    String? difficulty,
    int maxResultsPerType = 10,
  }) async {
    try {
      logger.info('Searching content with keyword: $query');

      final keyword = query.toLowerCase().trim();
      if (keyword.isEmpty) {
        logger.info('Search keyword is empty, returning empty results');
        return Right(UnifiedSearchResults.empty());
      }

      final allResults = <SearchResult>[];

      // Load all boards to get content structure
      final boardsResult = await getBoards();
      if (boardsResult.isLeft()) {
        logger.error('Failed to load boards for search');
        return Right(UnifiedSearchResults.empty());
      }

      final boards = boardsResult.getOrElse(() => []);
      final seenVideoIds = <String>{};

      for (final board in boards) {
        for (final classEntity in board.classes) {
          for (final stream in classEntity.streams) {
            for (final subjectId in stream.subjects) {
              // Apply subject filter if provided
              if (subjectFilter != null && subjectId != subjectFilter) {
                continue;
              }

              try {
                // Load subject
                final subjectModel = await _jsonDataSource.loadSubjectById(subjectId);
                final subject = subjectModel.toEntity();

                // Check if keyword matches subject keywords
                final subjectScore = _calculateKeywordScore(
                  keyword: keyword,
                  keywords: subject.keywords,
                  type: SearchResultType.subject,
                );
                if (subjectScore > 0) {
                  allResults.add(SearchResult.fromSubject(
                    id: subject.id,
                    name: subject.name,
                    score: subjectScore,
                    boardId: board.id,
                    chapterCount: subject.chapters.length,
                  ));
                }

                // Check chapters
                for (final chapter in subject.chapters) {
                  final chapterScore = _calculateKeywordScore(
                    keyword: keyword,
                    keywords: chapter.keywords,
                    type: SearchResultType.chapter,
                  );
                  if (chapterScore > 0) {
                    allResults.add(SearchResult.fromChapter(
                      id: chapter.id,
                      name: chapter.name,
                      subjectName: subject.name,
                      score: chapterScore,
                      boardId: board.id,
                      subjectId: subject.id,
                    ));
                  }

                  // Check topics
                  for (final topic in chapter.topics) {
                    final topicScore = _calculateKeywordScore(
                      keyword: keyword,
                      keywords: topic.keywords,
                      type: SearchResultType.topic,
                    );
                    if (topicScore > 0) {
                      // Apply difficulty filter
                      if (difficulty != null &&
                          topic.difficulty.toLowerCase() != difficulty.toLowerCase()) {
                        continue;
                      }
                      allResults.add(SearchResult.fromTopic(
                        id: topic.id,
                        name: topic.name,
                        breadcrumb: '${subject.name} > ${chapter.name}',
                        score: topicScore,
                        boardId: board.id,
                        subjectId: subject.id,
                        chapterId: chapter.id,
                        difficulty: topic.difficulty,
                      ));
                    }
                  }

                  // Check videos (use tags as keywords)
                  try {
                    final videos = await _jsonDataSource.loadVideos(
                      subjectId: subjectId,
                      chapterId: chapter.id,
                    );

                    for (final videoModel in videos) {
                      final video = videoModel.toEntity();

                      // Skip duplicates
                      if (seenVideoIds.contains(video.youtubeId)) {
                        continue;
                      }
                      seenVideoIds.add(video.youtubeId);

                      // Apply difficulty filter
                      if (difficulty != null &&
                          video.difficulty.toLowerCase() != difficulty.toLowerCase()) {
                        continue;
                      }

                      final videoScore = _calculateKeywordScore(
                        keyword: keyword,
                        keywords: video.tags,
                        type: SearchResultType.video,
                      );
                      if (videoScore > 0) {
                        allResults.add(SearchResult.fromVideo(
                          id: video.id,
                          title: video.title,
                          breadcrumb: '${subject.name} > ${chapter.name}',
                          score: videoScore,
                          boardId: board.id,
                          subjectId: subject.id,
                          chapterId: chapter.id,
                          topicId: video.topicId,
                          thumbnailUrl: video.thumbnailUrl,
                          difficulty: video.difficulty,
                          tags: video.tags,
                          duration: video.durationDisplay,
                          channelName: video.channelName,
                        ));
                      }
                    }
                  } catch (e) {
                    logger.debug('Could not load videos for chapter ${chapter.id}: $e');
                  }
                }
              } catch (e) {
                logger.debug('Could not load subject $subjectId: $e');
              }
            }
          }
        }
      }

      // Sort all results by score (descending)
      allResults.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

      logger.info('Search completed: ${allResults.length} results for keyword "$query"');

      return Right(UnifiedSearchResults(
        results: allResults,
        query: query,
        totalCount: allResults.length,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error searching content', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while searching content',
        details: e.toString(),
      ));
    }
  }

  /// Calculate score based on keyword position in keywords list
  /// Score = content_type_weight - (keyword_position * 5)
  double _calculateKeywordScore({
    required String keyword,
    required List<String> keywords,
    required SearchResultType type,
  }) {
    // Find keyword position (1-indexed)
    int position = -1;
    for (int i = 0; i < keywords.length; i++) {
      final k = keywords[i].toLowerCase();
      if (k.contains(keyword) || keyword.contains(k)) {
        position = i + 1;
        break;
      }
    }

    if (position == -1) return 0; // No match

    // Content type weight
    double typeWeight;
    switch (type) {
      case SearchResultType.subject:
        typeWeight = 100;
      case SearchResultType.chapter:
        typeWeight = 80;
      case SearchResultType.topic:
        typeWeight = 60;
      case SearchResultType.video:
        typeWeight = 40;
    }

    // Score = typeWeight - (position * 5)
    return typeWeight - (position * 5);
  }

  @override
  Future<Either<Failure, List<Subject>>> getAllSubjects() async {
    try {
      logger.info('Getting all subjects');

      final allSubjects = <Subject>[];
      final seenSubjectIds = <String>{};

      // Load all boards to get all subject IDs
      final boardsResult = await getBoards();
      if (boardsResult.isLeft()) {
        logger.error('Failed to load boards for getAllSubjects');
        return const Right([]);
      }

      final boards = boardsResult.getOrElse(() => []);

      for (final board in boards) {
        for (final classEntity in board.classes) {
          for (final stream in classEntity.streams) {
            for (final subjectId in stream.subjects) {
              // Skip if already loaded
              if (seenSubjectIds.contains(subjectId)) {
                continue;
              }

              try {
                final subjectModel = await _jsonDataSource.loadSubjectById(subjectId);
                final subject = subjectModel.toEntity();
                allSubjects.add(subject);
                seenSubjectIds.add(subjectId);
              } catch (e) {
                logger.debug('Could not load subject $subjectId: $e');
              }
            }
          }
        }
      }

      logger.info('Retrieved ${allSubjects.length} unique subjects');
      return Right(allSubjects);
    } catch (e, stackTrace) {
      logger.error('Unknown error getting all subjects', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while loading all subjects',
        details: e.toString(),
      ));
    }
  }
}
