import 'dart:async';
import 'dart:convert';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/content/board.dart';
import 'package:streamshaala/domain/entities/content/chapter.dart';
import 'package:streamshaala/domain/entities/content/subject.dart';
import 'package:streamshaala/domain/entities/content/video.dart';

/// High-performance content index for O(1) lookups
/// Maintains in-memory indexes for fast access to content relationships
class ContentIndex {
  static final ContentIndex _instance = ContentIndex._internal();
  factory ContentIndex() => _instance;
  ContentIndex._internal();

  // Primary indexes
  final Map<String, Board> _boards = {};
  final Map<String, Subject> _subjects = {};
  final Map<String, Chapter> _chapters = {};
  final Map<String, Video> _videos = {};

  // Relationship indexes
  final Map<String, List<String>> _boardToClasses = {};
  final Map<String, List<String>> _classToStreams = {};
  final Map<String, List<String>> _streamToSubjects = {};
  final Map<String, List<String>> _subjectToChapters = {};
  final Map<String, List<String>> _chapterToVideos = {};

  // Reverse relationship indexes
  final Map<String, String> _classToBoard = {};
  final Map<String, String> _streamToClass = {};
  final Map<String, String> _subjectToStream = {};
  final Map<String, String> _chapterToSubject = {};
  final Map<String, String> _videoToChapter = {};

  // Search indexes
  final Map<String, Set<String>> _titleIndex = {};
  final Map<String, Set<String>> _tagIndex = {};

  // YouTube ID index for quick lookup by YouTube video ID
  final Map<String, Video> _youtubeIdIndex = {};

  bool _isInitialized = false;
  final _initCompleter = Completer<void>();

  /// Initialize the content index
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_initCompleter.isCompleted) return await _initCompleter.future;

    logger.info('📚 Initializing Content Index...');

    try {
      // Note: Database caching removed for simplification
      // Content is now loaded on-demand from JSON files via repository

      // Build indexes (will be empty initially, populated on first access)
      _buildIndexes();

      _isInitialized = true;
      _initCompleter.complete();

      logger.info('✅ Content Index initialized (in-memory only)');
    } catch (e) {
      logger.error('Failed to initialize Content Index: $e');
      _initCompleter.completeError(e);
      rethrow;
    }
  }

  /// Ensure index is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initCompleter.future;
    }
  }

  /// Load content from database (DISABLED - database caching removed)
  /// Content is now loaded on-demand from JSON files via repository
  Future<void> _loadFromDatabase() async {
    // Database caching removed for simplification
    // Content loads directly from JSON assets instead
    logger.debug('Database caching disabled, using in-memory only');
  }

  /// Build all indexes
  void _buildIndexes() {
    // Clear existing indexes
    _clearIndexes();

    // Build relationship indexes from loaded data
    _buildRelationshipIndexes();

    // Build search indexes
    _buildSearchIndexes();
  }

  /// Clear all indexes
  void _clearIndexes() {
    _boardToClasses.clear();
    _classToStreams.clear();
    _streamToSubjects.clear();
    _subjectToChapters.clear();
    _chapterToVideos.clear();
    _titleIndex.clear();
    _tagIndex.clear();
    _youtubeIdIndex.clear();
  }

  /// Build relationship indexes
  void _buildRelationshipIndexes() {
    // Build forward relationships
    _subjectToStream.forEach((subjectId, streamId) {
      _streamToSubjects.putIfAbsent(streamId, () => []).add(subjectId);
    });

    _chapterToSubject.forEach((chapterId, subjectId) {
      _subjectToChapters.putIfAbsent(subjectId, () => []).add(chapterId);
    });

    _videoToChapter.forEach((videoId, chapterId) {
      _chapterToVideos.putIfAbsent(chapterId, () => []).add(videoId);
    });
  }

  /// Build search indexes
  void _buildSearchIndexes() {
    // Index video titles
    _videos.forEach((id, video) {
      _indexTitle(video.title, id);
      for (final tag in video.tags) {
        _indexTag(tag, id);
      }
    });

    // Index chapter titles
    _chapters.forEach((id, chapter) {
      _indexTitle(chapter.name, id);
    });

    // Index subject names
    _subjects.forEach((id, subject) {
      _indexTitle(subject.name, id);
    });
  }

  /// Index a title for search
  void _indexTitle(String title, String entityId) {
    final words = title.toLowerCase().split(RegExp(r'\s+'));
    for (final word in words) {
      if (word.isNotEmpty) {
        _titleIndex.putIfAbsent(word, () => {}).add(entityId);
      }
    }
  }

  /// Index a tag
  void _indexTag(String tag, String entityId) {
    final normalizedTag = tag.toLowerCase().trim();
    if (normalizedTag.isNotEmpty) {
      _tagIndex.putIfAbsent(normalizedTag, () => {}).add(entityId);
    }
  }

  // ==================== Query Methods ====================

  /// Get board by ID - O(1)
  Board? getBoard(String boardId) {
    return _boards[boardId];
  }

  /// Get subject by ID - O(1)
  Subject? getSubject(String subjectId) {
    return _subjects[subjectId];
  }

  /// Get chapter by ID - O(1)
  Chapter? getChapter(String chapterId) {
    return _chapters[chapterId];
  }

  /// Get video by ID - O(1)
  Video? getVideo(String videoId) {
    return _videos[videoId];
  }

  /// Get video by YouTube ID - O(1)
  /// Returns the video entity for a given YouTube video ID
  Video? getVideoByYoutubeId(String youtubeId) {
    return _youtubeIdIndex[youtubeId];
  }

  /// Get all boards - O(1)
  List<Board> getAllBoards() {
    return _boards.values.toList();
  }

  /// Get subjects for a stream - O(1)
  List<Subject> getSubjectsForStream(String streamId) {
    final subjectIds = _streamToSubjects[streamId] ?? [];
    return subjectIds.map((id) => _subjects[id]).whereType<Subject>().toList();
  }

  /// Get chapters for a subject - O(1)
  List<Chapter> getChaptersForSubject(String subjectId) {
    final chapterIds = _subjectToChapters[subjectId] ?? [];
    return chapterIds.map((id) => _chapters[id]).whereType<Chapter>().toList();
  }

  /// Get videos for a chapter - O(1)
  List<Video> getVideosForChapter(String chapterId) {
    final videoIds = _chapterToVideos[chapterId] ?? [];
    return videoIds.map((id) => _videos[id]).whereType<Video>().toList();
  }

  /// Get parent subject for a chapter - O(1)
  Subject? getParentSubject(String chapterId) {
    final subjectId = _chapterToSubject[chapterId];
    return subjectId != null ? _subjects[subjectId] : null;
  }

  /// Get parent chapter for a video - O(1)
  Chapter? getParentChapter(String videoId) {
    final chapterId = _videoToChapter[videoId];
    return chapterId != null ? _chapters[chapterId] : null;
  }

  /// Search content by title - O(m) where m is number of matching words
  List<String> searchByTitle(String query) {
    final words = query.toLowerCase().split(RegExp(r'\s+'));
    final results = <String>{};

    for (final word in words) {
      if (_titleIndex.containsKey(word)) {
        results.addAll(_titleIndex[word]!);
      }
    }

    return results.toList();
  }

  /// Search content by tag - O(1)
  List<String> searchByTag(String tag) {
    final normalizedTag = tag.toLowerCase().trim();
    return (_tagIndex[normalizedTag] ?? {}).toList();
  }

  /// Get content path (breadcrumb) for an entity
  List<String> getContentPath(String entityId) {
    final path = <String>[];

    // Check if it's a video
    final video = _videos[entityId];
    if (video != null) {
      path.add(video.title);

      // Add chapter
      final chapterId = _videoToChapter[entityId];
      final chapter = chapterId != null ? _chapters[chapterId] : null;
      if (chapter != null) {
        path.insert(0, chapter.name);

        // Add subject
        final subjectId = _chapterToSubject[chapterId];
        final subject = subjectId != null ? _subjects[subjectId] : null;
        if (subject != null) {
          path.insert(0, subject.name);
        }
      }
      return path;
    }

    // Check if it's a chapter
    final chapter = _chapters[entityId];
    if (chapter != null) {
      path.add(chapter.name);

      // Add subject
      final subjectId = _chapterToSubject[entityId];
      final subject = subjectId != null ? _subjects[subjectId] : null;
      if (subject != null) {
        path.insert(0, subject.name);
      }
      return path;
    }

    // Check if it's a subject
    final subject = _subjects[entityId];
    if (subject != null) {
      path.add(subject.name);
    }

    return path;
  }

  // ==================== Update Methods ====================

  /// Update the index with new board data
  Future<void> indexBoard(Board board) async {
    await _ensureInitialized();

    _boards[board.id] = board;

    // Update database with minimal metadata
    await _saveToDatabase('board', board.id, null, {
      'name': board.name,
      'fullName': board.fullName,
      'description': board.description,
    });

    logger.info('Indexed board: ${board.name}');
  }

  /// Update the index with new subject data
  Future<void> indexSubject(Subject subject, String streamId) async {
    await _ensureInitialized();

    _subjects[subject.id] = subject;
    _subjectToStream[subject.id] = streamId;
    _streamToSubjects.putIfAbsent(streamId, () => []).add(subject.id);

    // Index chapters
    for (final chapter in subject.chapters) {
      await indexChapter(chapter, subject.id);
    }

    // Update database with minimal metadata
    await _saveToDatabase('subject', subject.id, streamId, {
      'name': subject.name,
      'icon': subject.icon,
      'color': subject.color,
      'totalChapters': subject.totalChapters,
    });

    logger.info('Indexed subject: ${subject.name}');
  }

  /// Update the index with new chapter data
  Future<void> indexChapter(Chapter chapter, String subjectId) async {
    await _ensureInitialized();

    _chapters[chapter.id] = chapter;
    _chapterToSubject[chapter.id] = subjectId;
    _subjectToChapters.putIfAbsent(subjectId, () => []).add(chapter.id);

    // Index title for search
    _indexTitle(chapter.name, chapter.id);

    // Update database with minimal metadata
    await _saveToDatabase('chapter', chapter.id, subjectId, {
      'name': chapter.name,
      'number': chapter.number,
      'description': chapter.description,
    });
  }

  /// Update the index with new video data
  Future<void> indexVideo(Video video, String chapterId) async {
    await _ensureInitialized();

    _videos[video.id] = video;
    _videoToChapter[video.id] = chapterId;
    _chapterToVideos.putIfAbsent(chapterId, () => []).add(video.id);

    // Index by YouTube ID for quiz loading from watch history
    _youtubeIdIndex[video.youtubeId] = video;

    // Index for search
    _indexTitle(video.title, video.id);
    for (final tag in video.tags) {
      _indexTag(tag, video.id);
    }

    // Update database with minimal metadata
    await _saveToDatabase('video', video.id, chapterId, {
      'title': video.title,
      'youtubeId': video.youtubeId,
      'channelName': video.channelName,
      'thumbnailUrl': video.thumbnailUrl,
      'duration': video.duration,
      'tags': video.tags,
    });
  }

  /// Save entity to database (DISABLED - database caching removed)
  Future<void> _saveToDatabase(
    String entityType,
    String entityId,
    String? parentId,
    Map<String, dynamic> data,
  ) async {
    // Database caching removed for simplification
    // All data is now in-memory only
    return;
  }

  // ==================== Statistics ====================

  /// Get index statistics
  Map<String, dynamic> getStatistics() {
    return {
      'boards': _boards.length,
      'subjects': _subjects.length,
      'chapters': _chapters.length,
      'videos': _videos.length,
      'title_index_words': _titleIndex.length,
      'tag_index_entries': _tagIndex.length,
      'total_relationships': _streamToSubjects.length +
          _subjectToChapters.length +
          _chapterToVideos.length,
      'is_initialized': _isInitialized,
    };
  }

  /// Clear and rebuild the entire index
  Future<void> rebuild() async {
    logger.warning('Rebuilding content index...');

    _isInitialized = false;
    _clearIndexes();
    _boards.clear();
    _subjects.clear();
    _chapters.clear();
    _videos.clear();

    await initialize();

    logger.info('Content index rebuilt');
  }

  // ==================== Helper Methods ====================

  Board _parseBoardFromMetadata(String id, Map<String, dynamic> metadata) {
    // Parse board from metadata (simplified)
    return Board(
      id: id,
      name: metadata['name'] ?? '',
      fullName: metadata['fullName'] ?? '',
      description: metadata['description'] ?? '',
      icon: metadata['icon'] ?? '',
      classes: [], // Classes would be loaded separately
    );
  }

  Subject _parseSubjectFromMetadata(String id, Map<String, dynamic> metadata) {
    return Subject(
      id: id,
      name: metadata['name'] ?? '',
      icon: metadata['icon'],
      color: metadata['color'],
      boardId: '', // Not stored in index
      classId: '', // Not stored in index
      streamId: '', // Not stored in index
      totalChapters: metadata['totalChapters'] ?? 0,
      chapters: [], // Chapters loaded separately
    );
  }

  Chapter _parseChapterFromMetadata(String id, Map<String, dynamic> metadata) {
    return Chapter(
      id: id,
      number: metadata['number'] ?? 0,
      name: metadata['name'] ?? '',
      description: metadata['description'],
      topics: [], // Topics loaded separately
    );
  }

  Video _parseVideoFromMetadata(String id, Map<String, dynamic> metadata) {
    final duration = metadata['duration'] as int? ?? 0;
    return Video(
      id: id,
      title: metadata['title'] ?? '',
      description: '', // Not stored in index
      youtubeId: metadata['youtubeId'] ?? id,
      youtubeUrl: 'https://www.youtube.com/watch?v=${metadata['youtubeId'] ?? id}',
      thumbnailUrl: metadata['thumbnailUrl'] ?? '',
      duration: duration,
      durationDisplay: _formatDuration(duration),
      channelName: metadata['channelName'] ?? '',
      channelId: '', // Not stored in index
      language: 'English', // Default
      topicId: '', // Not stored in index
      difficulty: 'intermediate', // Default
      examRelevance: [], // Not stored in index
      rating: 0.0, // Not stored in index
      viewCount: 0, // Not stored in index
      tags: (metadata['tags'] as List?)?.cast<String>() ?? [],
      dateAdded: DateTime.now(), // Not stored
      lastUpdated: DateTime.now(), // Not stored
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
}