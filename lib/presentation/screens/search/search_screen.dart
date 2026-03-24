import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/widgets/empty/empty_state_widget.dart';
import 'package:crack_the_code/core/utils/debouncer.dart';
import 'package:crack_the_code/domain/entities/search/search_result.dart';
import 'package:crack_the_code/presentation/providers/content/search_provider.dart';
import 'package:crack_the_code/presentation/widgets/search/search_suggestion_tile.dart';
import 'package:crack_the_code/presentation/widgets/search/search_result_tile.dart';

/// Search screen for finding subjects, chapters, topics, and videos
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 150));

  @override
  void initState() {
    super.initState();
    // Restore search text from provider state after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreSearchState();
    });
  }

  /// Restore search text from provider state when screen is shown
  void _restoreSearchState() {
    final searchState = ref.read(searchProvider);
    if (searchState.query.isNotEmpty) {
      // Restore previous search query
      _searchController.text = searchState.query;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchState.query.length),
      );
      // Don't request focus if we have results (returning from navigation)
      if (!searchState.showResults) {
        _searchFocusNode.requestFocus();
      }
    } else {
      // Fresh search - focus the text field
      _searchFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      ref.read(searchProvider.notifier).onQueryChanged(query);
    });
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    ref.read(searchProvider.notifier).onSuggestionSelected(suggestion);
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(searchProvider.notifier).search(query);
      _searchFocusNode.unfocus();
    }
  }

  void _onClear() {
    _searchController.clear();
    ref.read(searchProvider.notifier).clear();
    _searchFocusNode.requestFocus();
  }

  void _onResultTap(SearchResult result) {
    // Get the current search query to pass as filter
    final searchQuery = ref.read(searchProvider).query;
    final encodedQuery = Uri.encodeComponent(searchQuery);

    // Navigate based on result type using correct route patterns
    switch (result.type) {
      case SearchResultType.subject:
        if (result.boardId != null && result.subjectId != null) {
          // Navigate to chapters screen for the subject
          context.push('/browse/board/${result.boardId}/subject/${result.subjectId}/chapters');
        }
        break;
      case SearchResultType.chapter:
        if (result.boardId != null && result.subjectId != null && result.chapterId != null) {
          // Navigate to topics/videos screen with search filter
          context.push('/browse/board/${result.boardId}/subject/${result.subjectId}/chapter/${result.chapterId}/videos?filter=$encodedQuery');
        }
        break;
      case SearchResultType.topic:
        if (result.boardId != null && result.subjectId != null && result.chapterId != null) {
          // Navigate to topics/videos screen with search filter
          context.push('/browse/board/${result.boardId}/subject/${result.subjectId}/chapter/${result.chapterId}/videos?filter=$encodedQuery');
        }
        break;
      case SearchResultType.video:
        // Navigate to video player using the video ID (which is the YouTube ID)
        context.push('/video/${result.id}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search subjects, topics, videos...',
            border: InputBorder.none,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          style: theme.textTheme.bodyLarge,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _onSearch(),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: _onClear,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear search',
            ),
        ],
      ),
      body: _buildContent(searchState),
    );
  }

  Widget _buildContent(SearchState state) {
    // Show suggestions if typing
    if (state.showSuggestions && state.suggestions.isNotEmpty) {
      return _buildSuggestions(state);
    }

    // Show results if searched
    if (state.showResults) {
      if (state.isLoading) {
        return _buildLoadingState();
      }
      if (state.hasNoResults) {
        return _buildNoResults(state.query);
      }
      return _buildResults(state);
    }

    // Show empty state (recent + popular)
    return _buildEmptyState(state);
  }

  Widget _buildEmptyState(SearchState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      children: [
        // Recent Searches
        if (state.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(searchProvider.notifier).clearRecentSearches();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          ...state.recentSearches.map((search) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(search),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    ref.read(searchProvider.notifier).removeRecentSearch(search);
                  },
                ),
                onTap: () {
                  _searchController.text = search;
                  ref.read(searchProvider.notifier).search(search);
                },
                contentPadding: EdgeInsets.zero,
              )),
          const SizedBox(height: AppTheme.spacingLg),
        ],

        // Popular Keywords
        if (state.popularKeywords.isNotEmpty) ...[
          Text(
            'Popular Searches',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Wrap(
            spacing: AppTheme.spacingSm,
            runSpacing: AppTheme.spacingSm,
            children: state.popularKeywords.map((keyword) {
              return ActionChip(
                label: Text(
                  keyword,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  _searchController.text = keyword;
                  ref.read(searchProvider.notifier).search(keyword);
                },
                backgroundColor: colorScheme.surfaceContainerHighest,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              );
            }).toList(),
          ),
        ],

        // Empty placeholder if nothing to show
        if (state.recentSearches.isEmpty && state.popularKeywords.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: EmptyStateWidget(
                icon: Icons.search,
                title: 'Start Searching',
                message: 'Search for subjects, chapters, topics, or videos',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSuggestions(SearchState state) {
    return ListView.builder(
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return SearchSuggestionTile(
          suggestion: suggestion,
          query: state.query,
          onTap: () => _onSuggestionTap(suggestion),
        );
      },
    );
  }

  Widget _buildResults(SearchState state) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count header
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Text(
            '${state.results.length} result${state.results.length == 1 ? '' : 's'} for "${state.query}"',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.separated(
            itemCount: state.results.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: AppTheme.spacingMd + 40 + AppTheme.spacingMd,
              endIndent: AppTheme.spacingMd,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final result = state.results[index];
              return SearchResultTile(
                result: result,
                onTap: () => _onResultTap(result),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) => const SearchResultTileSkeleton(),
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No Results Found',
        message: 'No content found for "$query".\nTry different keywords.',
      ),
    );
  }
}
