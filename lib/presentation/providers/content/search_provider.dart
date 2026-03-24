import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/services/search_keywords_service.dart';
import 'package:streamshaala/domain/entities/search/search_result.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// Search Provider
/// Manages search functionality with autocomplete suggestions and keyword-based results

const String _recentSearchesKey = 'recent_searches';
const int _maxRecentSearches = 10;

class SearchState {
  final String query;
  final List<String> suggestions;
  final List<SearchResult> results;
  final List<String> recentSearches;
  final List<String> popularKeywords;
  final bool isLoading;
  final bool showSuggestions;
  final bool showResults;
  final String? error;

  const SearchState({
    this.query = '',
    this.suggestions = const [],
    this.results = const [],
    this.recentSearches = const [],
    this.popularKeywords = const [],
    this.isLoading = false,
    this.showSuggestions = false,
    this.showResults = false,
    this.error,
  });

  factory SearchState.initial() => const SearchState();

  SearchState copyWith({
    String? query,
    List<String>? suggestions,
    List<SearchResult>? results,
    List<String>? recentSearches,
    List<String>? popularKeywords,
    bool? isLoading,
    bool? showSuggestions,
    bool? showResults,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
      popularKeywords: popularKeywords ?? this.popularKeywords,
      isLoading: isLoading ?? this.isLoading,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      showResults: showResults ?? this.showResults,
      error: error,
    );
  }

  /// Show empty state (recent searches + popular keywords)
  bool get showEmptyState => query.isEmpty && !showResults;

  /// Has no results after search
  bool get hasNoResults => showResults && results.isEmpty && !isLoading;

  /// Has results to display
  bool get hasResults => results.isNotEmpty;
}

class SearchNotifier extends StateNotifier<SearchState> {
  final ContentRepository _contentRepository;
  final SearchKeywordsService _keywordsService;

  SearchNotifier(this._contentRepository, this._keywordsService)
      : super(SearchState.initial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    logger.info('Initializing SearchNotifier');

    // Load keywords from JSON
    await _keywordsService.loadKeywords();

    // Load recent searches from SharedPreferences
    await _loadRecentSearches();

    // Load popular keywords
    final popularKeywords = _keywordsService.getPopularKeywords(maxResults: 8);

    state = state.copyWith(
      popularKeywords: popularKeywords,
    );

    logger.info('SearchNotifier initialized with ${popularKeywords.length} popular keywords');
  }

  /// Called when user types in search bar
  void onQueryChanged(String query) {
    logger.debug('Query changed: $query');

    if (query.isEmpty) {
      state = state.copyWith(
        query: '',
        suggestions: [],
        showSuggestions: false,
        showResults: false,
      );
      return;
    }

    // Get suggestions from keywords service
    final suggestions = _keywordsService.getSuggestions(query, maxResults: 10);

    state = state.copyWith(
      query: query,
      suggestions: suggestions,
      showSuggestions: suggestions.isNotEmpty,
      showResults: false,
    );
  }

  /// Called when user selects a suggestion
  Future<void> onSuggestionSelected(String keyword) async {
    logger.info('Suggestion selected: $keyword');
    await search(keyword);
  }

  /// Perform search with keyword
  Future<void> search(String keyword) async {
    final trimmedKeyword = keyword.trim();
    if (trimmedKeyword.isEmpty) {
      logger.info('Search keyword is empty, clearing');
      clear();
      return;
    }

    logger.info('Searching for: $trimmedKeyword');

    state = state.copyWith(
      query: trimmedKeyword,
      isLoading: true,
      showSuggestions: false,
      showResults: true,
      error: null,
    );

    // Save to recent searches
    await _saveRecentSearch(trimmedKeyword);

    final result = await _contentRepository.searchContent(
      query: trimmedKeyword,
    );

    result.fold(
      (failure) {
        logger.error('Search failed: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
          results: [],
        );
      },
      (unifiedResults) {
        logger.info('Search completed: ${unifiedResults.results.length} results');
        state = state.copyWith(
          results: unifiedResults.results,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  /// Clear search and return to empty state
  void clear() {
    logger.info('Clearing search');
    state = state.copyWith(
      query: '',
      suggestions: [],
      results: [],
      showSuggestions: false,
      showResults: false,
      error: null,
    );
  }

  /// Remove a specific recent search
  Future<void> removeRecentSearch(String search) async {
    logger.info('Removing recent search: $search');
    final updated = List<String>.from(state.recentSearches)..remove(search);
    state = state.copyWith(recentSearches: updated);
    await _persistRecentSearches(updated);
  }

  /// Clear all recent searches
  Future<void> clearRecentSearches() async {
    logger.info('Clearing all recent searches');
    state = state.copyWith(recentSearches: []);
    await _persistRecentSearches([]);
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList(_recentSearchesKey) ?? [];
      state = state.copyWith(recentSearches: searches);
      logger.info('Loaded ${searches.length} recent searches');
    } catch (e) {
      logger.error('Failed to load recent searches: $e');
    }
  }

  Future<void> _saveRecentSearch(String keyword) async {
    // Add to front, remove duplicates, limit to max
    final updated = [
      keyword,
      ...state.recentSearches.where((s) => s.toLowerCase() != keyword.toLowerCase()),
    ].take(_maxRecentSearches).toList();

    state = state.copyWith(recentSearches: updated);
    await _persistRecentSearches(updated);
  }

  Future<void> _persistRecentSearches(List<String> searches) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentSearchesKey, searches);
      logger.debug('Persisted ${searches.length} recent searches');
    } catch (e) {
      logger.error('Failed to persist recent searches: $e');
    }
  }
}

/// Provider for SearchKeywordsService
final searchKeywordsServiceProvider = Provider<SearchKeywordsService>((ref) {
  return SearchKeywordsService();
});

/// Main search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    injectionContainer.contentRepository,
    ref.watch(searchKeywordsServiceProvider),
  );
});
