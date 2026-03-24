/// JSON data source for loading content from asset files
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/constants/asset_constants.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/models/content/board_model.dart';
import 'package:crack_the_code/data/models/content/subject_model.dart';
import 'package:crack_the_code/data/models/content/video_model.dart';

/// Data source for reading JSON content files
class ContentJsonDataSource {
  /// Cache for loaded boards
  final Map<String, BoardModel> _boardsCache = {};

  /// Cache for loaded subjects
  final Map<String, SubjectModel> _subjectsCache = {};

  /// Cache for loaded videos
  final Map<String, List<VideoModel>> _videosCache = {};

  /// Load all boards
  /// Loads boards appropriate for the current app segment
  Future<List<BoardModel>> loadBoards() async {
    try {
      logger.info('Loading boards from JSON assets for segment: ${SegmentConfig.current.name}');

      final boards = <BoardModel>[];

      // Load appropriate CBSE board based on segment
      if (SegmentConfig.isCrackTheCode) {
        // For Junior segment (Grades 4-7), load elementary board
        try {
          final cbseElementary = await _loadBoard(JsonAssets.cbseElementaryBoard, 'cbse_elementary');
          boards.add(cbseElementary);
          _boardsCache['cbse_elementary'] = cbseElementary;
          logger.info('Loaded CBSE Elementary board for Junior segment');
        } catch (e) {
          logger.warning('Failed to load CBSE Elementary board: $e');
        }
      } else {
        // For Senior/Middle/PreBoard segments, load regular CBSE board
        try {
          final cbse = await _loadBoard(JsonAssets.cbseBoard, 'cbse');
          boards.add(cbse);
          _boardsCache['cbse'] = cbse;
          logger.info('Loaded CBSE board for ${SegmentConfig.current.name} segment');
        } catch (e) {
          logger.warning('Failed to load CBSE board: $e');
        }
      }

      // Load ICSE board (available for all segments except Junior)
      if (!SegmentConfig.isCrackTheCode) {
        try {
          final icse = await _loadBoard(JsonAssets.icseBoard, 'icse');
          boards.add(icse);
          _boardsCache['icse'] = icse;
        } catch (e) {
          logger.warning('Failed to load ICSE board: $e');
        }
      }

      // Load state boards (available for all segments except Junior)
      if (!SegmentConfig.isCrackTheCode) {
        try {
          final stateBoards = await _loadBoard(JsonAssets.stateBoards, 'state_boards');
          boards.add(stateBoards);
          _boardsCache['state_boards'] = stateBoards;
        } catch (e) {
          logger.warning('Failed to load state boards: $e');
        }
      }

      logger.info('Loaded ${boards.length} boards for ${SegmentConfig.current.name} segment');
      return boards;
    } catch (e, stackTrace) {
      logger.error('Failed to load boards', e, stackTrace);
      throw AssetNotFoundException(
        message: 'Failed to load boards: ${e.toString()}',
        assetPath: 'boards/*',
        details: e,
      );
    }
  }

  /// Load a specific board by ID
  Future<BoardModel> loadBoardById(String boardId) async {
    try {
      // Check cache first
      if (_boardsCache.containsKey(boardId)) {
        logger.debug('Board $boardId loaded from cache');
        return _boardsCache[boardId]!;
      }

      // Determine file path
      String assetPath;
      switch (boardId.toLowerCase()) {
        case 'cbse':
          assetPath = JsonAssets.cbseBoard;
          break;
        case 'cbse_elementary':
          assetPath = JsonAssets.cbseElementaryBoard;
          break;
        case 'icse':
          assetPath = JsonAssets.icseBoard;
          break;
        case 'state_boards':
          assetPath = JsonAssets.stateBoards;
          break;
        default:
          throw NotFoundException(
            message: 'Board not found',
            entityType: 'Board',
            entityId: boardId,
          );
      }

      final board = await _loadBoard(assetPath, boardId);
      _boardsCache[boardId] = board;
      return board;
    } catch (e, stackTrace) {
      logger.error('Failed to load board: $boardId', e, stackTrace);
      if (e is NotFoundException) rethrow;
      throw AssetNotFoundException(
        message: 'Failed to load board: ${e.toString()}',
        assetPath: 'boards/$boardId.json',
        details: e,
      );
    }
  }

  /// Load a subject by ID
  Future<SubjectModel> loadSubjectById(String subjectId) async {
    try {
      // Check cache first
      if (_subjectsCache.containsKey(subjectId)) {
        logger.debug('Subject $subjectId loaded from cache');
        return _subjectsCache[subjectId]!;
      }

      final assetPath = JsonAssets.subject(subjectId);
      logger.info('Loading subject from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final subject = SubjectModel.fromJson(jsonData);

      _subjectsCache[subjectId] = subject;
      logger.info('Subject loaded: ${subject.name}');
      return subject;
    } catch (e, stackTrace) {
      logger.error('Failed to load subject: $subjectId', e, stackTrace);

      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        throw AssetNotFoundException(
          message: 'Subject file not found',
          assetPath: JsonAssets.subject(subjectId),
          details: e,
        );
      }

      throw JsonParseException(
        message: 'Failed to parse subject JSON: ${e.toString()}',
        filePath: JsonAssets.subject(subjectId),
        details: e,
      );
    }
  }

  /// Load videos for a specific chapter
  Future<List<VideoModel>> loadVideos({
    required String subjectId,
    required String chapterId,
  }) async {
    try {
      final cacheKey = '${subjectId}_$chapterId';

      // Check cache first
      if (_videosCache.containsKey(cacheKey)) {
        logger.debug('Videos for $cacheKey loaded from cache');
        return _videosCache[cacheKey]!;
      }

      final assetPath = JsonAssets.videos(subjectId, chapterId);
      logger.info('🔍 LOADING VIDEOS - SubjectId: $subjectId, ChapterId: $chapterId');
      logger.info('🔍 CONSTRUCTED PATH: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      logger.info('✅ FILE LOADED SUCCESSFULLY');

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final videosJson = jsonData['videos'] as List<dynamic>;

      final videos = videosJson
          .map((videoJson) => VideoModel.fromJson(videoJson as Map<String, dynamic>))
          .toList();

      _videosCache[cacheKey] = videos;
      logger.info('✅ Loaded ${videos.length} videos for $cacheKey');
      logger.info('🎥 First video: ${videos.isNotEmpty ? videos[0].title : "NONE"}');
      logger.info('🎥 First video YouTubeId: ${videos.isNotEmpty ? videos[0].youtubeId : "NONE"}');
      return videos;
    } catch (e, stackTrace) {
      logger.error('Failed to load videos: $subjectId/$chapterId', e, stackTrace);

      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        throw AssetNotFoundException(
          message: 'Videos file not found',
          assetPath: JsonAssets.videos(subjectId, chapterId),
          details: e,
        );
      }

      throw JsonParseException(
        message: 'Failed to parse videos JSON: ${e.toString()}',
        filePath: JsonAssets.videos(subjectId, chapterId),
        details: e,
      );
    }
  }

  /// Load a board from asset file
  Future<BoardModel> _loadBoard(String assetPath, String boardId) async {
    try {
      logger.debug('Loading board from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final board = BoardModel.fromJson(jsonData);

      logger.debug('Board loaded: ${board.name}');
      return board;
    } catch (e, stackTrace) {
      logger.error('Failed to load board from $assetPath', e, stackTrace);

      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        throw AssetNotFoundException(
          message: 'Board file not found',
          assetPath: assetPath,
          details: e,
        );
      }

      throw JsonParseException(
        message: 'Failed to parse board JSON: ${e.toString()}',
        filePath: assetPath,
        details: e,
      );
    }
  }

  /// Clear all caches
  void clearCache() {
    logger.info('Clearing JSON data source cache');
    _boardsCache.clear();
    _subjectsCache.clear();
    _videosCache.clear();
  }

  /// Clear specific cache
  void clearBoardCache(String boardId) {
    _boardsCache.remove(boardId);
  }

  void clearSubjectCache(String subjectId) {
    _subjectsCache.remove(subjectId);
  }

  void clearVideosCache(String subjectId, String chapterId) {
    final cacheKey = '${subjectId}_$chapterId';
    _videosCache.remove(cacheKey);
  }
}
