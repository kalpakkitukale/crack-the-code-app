import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Service to manage search keywords loaded from JSON
class SearchKeywordsService {
  List<String> _allKeywords = [];
  List<String> _popularKeywords = [];
  bool _isLoaded = false;

  /// Singleton instance
  static final SearchKeywordsService _instance = SearchKeywordsService._internal();
  factory SearchKeywordsService() => _instance;
  SearchKeywordsService._internal();

  /// Whether keywords have been loaded
  bool get isLoaded => _isLoaded;

  /// Get all keywords
  List<String> get allKeywords => List.unmodifiable(_allKeywords);

  /// Get popular keywords
  List<String> get popularKeywords => List.unmodifiable(_popularKeywords);

  /// Load keywords from JSON file
  Future<void> loadKeywords() async {
    if (_isLoaded) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/search_keywords.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;

      _allKeywords = (data['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      _popularKeywords = (data['popular'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      _isLoaded = true;
      logger.info('Loaded ${_allKeywords.length} keywords, ${_popularKeywords.length} popular');
    } catch (e, stackTrace) {
      logger.error('Failed to load search keywords', e, stackTrace);
      _allKeywords = [];
      _popularKeywords = [];
    }
  }

  /// Get suggestions based on user input
  /// Returns keywords that contain the query (case-insensitive)
  List<String> getSuggestions(String query, {int maxResults = 10}) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final suggestions = _allKeywords
        .where((keyword) => keyword.toLowerCase().contains(lowerQuery))
        .take(maxResults)
        .toList();

    // Sort by relevance - exact matches first, then starts with, then contains
    suggestions.sort((a, b) {
      final aLower = a.toLowerCase();
      final bLower = b.toLowerCase();

      // Exact match comes first
      if (aLower == lowerQuery && bLower != lowerQuery) return -1;
      if (bLower == lowerQuery && aLower != lowerQuery) return 1;

      // Starts with comes second
      if (aLower.startsWith(lowerQuery) && !bLower.startsWith(lowerQuery)) return -1;
      if (bLower.startsWith(lowerQuery) && !aLower.startsWith(lowerQuery)) return 1;

      // Alphabetical for the rest
      return aLower.compareTo(bLower);
    });

    return suggestions;
  }

  /// Get popular keywords for display when search is empty
  List<String> getPopularKeywords({int maxResults = 8}) {
    return _popularKeywords.take(maxResults).toList();
  }

  /// Check if a keyword exists in the master list
  bool hasKeyword(String keyword) {
    return _allKeywords.any(
      (k) => k.toLowerCase() == keyword.toLowerCase(),
    );
  }

  /// Add a new keyword (for dynamic updates)
  void addKeyword(String keyword) {
    if (!hasKeyword(keyword)) {
      _allKeywords.add(keyword);
    }
  }

  /// Clear loaded keywords (for testing)
  void clear() {
    _allKeywords = [];
    _popularKeywords = [];
    _isLoaded = false;
  }
}
