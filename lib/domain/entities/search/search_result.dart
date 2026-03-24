import 'package:equatable/equatable.dart';

/// Enum representing the type of content in search results
enum SearchResultType {
  subject,
  chapter,
  topic,
  video,
}

/// Extension to provide display properties for SearchResultType
extension SearchResultTypeExtension on SearchResultType {
  String get displayName {
    switch (this) {
      case SearchResultType.subject:
        return 'Subject';
      case SearchResultType.chapter:
        return 'Chapter';
      case SearchResultType.topic:
        return 'Topic';
      case SearchResultType.video:
        return 'Video';
    }
  }

  String get icon {
    switch (this) {
      case SearchResultType.subject:
        return 'book';
      case SearchResultType.chapter:
        return 'library_books';
      case SearchResultType.topic:
        return 'topic';
      case SearchResultType.video:
        return 'play_circle';
    }
  }
}

/// A unified search result that can represent any searchable content type
class SearchResult extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final SearchResultType type;
  final double relevanceScore;

  // Navigation context - needed to navigate to the content
  final String? boardId;
  final String? subjectId;
  final String? chapterId;
  final String? topicId;

  // Additional metadata
  final String? thumbnailUrl;
  final String? difficulty;
  final List<String>? tags;
  final String? duration;
  final String? channelName;
  final int? chapterCount;

  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.relevanceScore,
    this.boardId,
    this.subjectId,
    this.chapterId,
    this.topicId,
    this.thumbnailUrl,
    this.difficulty,
    this.tags,
    this.duration,
    this.channelName,
    this.chapterCount,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        type,
        relevanceScore,
        boardId,
        subjectId,
        chapterId,
        topicId,
        thumbnailUrl,
        difficulty,
        tags,
        duration,
        channelName,
        chapterCount,
      ];

  /// Create a SearchResult from a Subject
  factory SearchResult.fromSubject({
    required String id,
    required String name,
    required double score,
    String? boardId,
    int? chapterCount,
  }) {
    return SearchResult(
      id: id,
      title: name,
      subtitle: chapterCount != null ? '$chapterCount chapters' : 'Subject',
      type: SearchResultType.subject,
      relevanceScore: score,
      boardId: boardId,
      subjectId: id,
      chapterCount: chapterCount,
    );
  }

  /// Create a SearchResult from a Chapter
  factory SearchResult.fromChapter({
    required String id,
    required String name,
    required String subjectName,
    required double score,
    String? boardId,
    String? subjectId,
  }) {
    return SearchResult(
      id: id,
      title: name,
      subtitle: subjectName,
      type: SearchResultType.chapter,
      relevanceScore: score,
      boardId: boardId,
      subjectId: subjectId,
      chapterId: id,
    );
  }

  /// Create a SearchResult from a Topic
  factory SearchResult.fromTopic({
    required String id,
    required String name,
    required String breadcrumb,
    required double score,
    String? boardId,
    String? subjectId,
    String? chapterId,
    String? difficulty,
  }) {
    return SearchResult(
      id: id,
      title: name,
      subtitle: breadcrumb,
      type: SearchResultType.topic,
      relevanceScore: score,
      boardId: boardId,
      subjectId: subjectId,
      chapterId: chapterId,
      topicId: id,
      difficulty: difficulty,
    );
  }

  /// Create a SearchResult from a Video
  factory SearchResult.fromVideo({
    required String id,
    required String title,
    required String breadcrumb,
    required double score,
    String? boardId,
    String? subjectId,
    String? chapterId,
    String? topicId,
    String? thumbnailUrl,
    String? difficulty,
    List<String>? tags,
    String? duration,
    String? channelName,
  }) {
    return SearchResult(
      id: id,
      title: title,
      subtitle: breadcrumb,
      type: SearchResultType.video,
      relevanceScore: score,
      boardId: boardId,
      subjectId: subjectId,
      chapterId: chapterId,
      topicId: topicId,
      thumbnailUrl: thumbnailUrl,
      difficulty: difficulty,
      tags: tags,
      duration: duration,
      channelName: channelName,
    );
  }

  SearchResult copyWith({
    String? id,
    String? title,
    String? subtitle,
    SearchResultType? type,
    double? relevanceScore,
    String? boardId,
    String? subjectId,
    String? chapterId,
    String? topicId,
    String? thumbnailUrl,
    String? difficulty,
    List<String>? tags,
    String? duration,
    String? channelName,
    int? chapterCount,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      boardId: boardId ?? this.boardId,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      topicId: topicId ?? this.topicId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      duration: duration ?? this.duration,
      channelName: channelName ?? this.channelName,
      chapterCount: chapterCount ?? this.chapterCount,
    );
  }
}
