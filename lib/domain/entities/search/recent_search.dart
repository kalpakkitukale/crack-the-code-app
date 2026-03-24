import 'package:equatable/equatable.dart';

/// Represents a recent search query for persistence
class RecentSearch extends Equatable {
  /// The search query text
  final String query;

  /// When the search was performed
  final DateTime timestamp;

  /// Number of results found (optional)
  final int? resultCount;

  const RecentSearch({
    required this.query,
    required this.timestamp,
    this.resultCount,
  });

  @override
  List<Object?> get props => [query, timestamp, resultCount];

  /// Create from JSON (for SharedPreferences persistence)
  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch(
      query: json['query'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      resultCount: json['resultCount'] as int?,
    );
  }

  /// Convert to JSON (for SharedPreferences persistence)
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'resultCount': resultCount,
    };
  }

  RecentSearch copyWith({
    String? query,
    DateTime? timestamp,
    int? resultCount,
  }) {
    return RecentSearch(
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
      resultCount: resultCount ?? this.resultCount,
    );
  }
}
