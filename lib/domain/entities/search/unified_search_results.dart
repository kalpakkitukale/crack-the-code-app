import 'package:equatable/equatable.dart';
import 'search_result.dart';

/// Container for unified search results across all content types
class UnifiedSearchResults extends Equatable {
  /// All search results sorted by relevance score
  final List<SearchResult> results;

  /// The search query that produced these results
  final String query;

  /// Total count of results
  final int totalCount;

  const UnifiedSearchResults({
    required this.results,
    required this.query,
    required this.totalCount,
  });

  /// Create empty results
  factory UnifiedSearchResults.empty() {
    return const UnifiedSearchResults(
      results: [],
      query: '',
      totalCount: 0,
    );
  }

  /// Check if there are no results
  bool get isEmpty => results.isEmpty;

  /// Check if there are results
  bool get isNotEmpty => results.isNotEmpty;

  /// Get results filtered by type
  List<SearchResult> getByType(SearchResultType type) {
    return results.where((r) => r.type == type).toList();
  }

  /// Get subject results
  List<SearchResult> get subjects => getByType(SearchResultType.subject);

  /// Get chapter results
  List<SearchResult> get chapters => getByType(SearchResultType.chapter);

  /// Get topic results
  List<SearchResult> get topics => getByType(SearchResultType.topic);

  /// Get video results
  List<SearchResult> get videos => getByType(SearchResultType.video);

  /// Count of each type
  int get subjectCount => subjects.length;
  int get chapterCount => chapters.length;
  int get topicCount => topics.length;
  int get videoCount => videos.length;

  @override
  List<Object?> get props => [results, query, totalCount];

  UnifiedSearchResults copyWith({
    List<SearchResult>? results,
    String? query,
    int? totalCount,
  }) {
    return UnifiedSearchResults(
      results: results ?? this.results,
      query: query ?? this.query,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
