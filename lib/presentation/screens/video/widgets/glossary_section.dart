/// Glossary Section widget for video player
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/domain/entities/study_tools/glossary_term.dart';
import 'package:crack_the_code/presentation/providers/study_tools/glossary_provider.dart';
import 'package:crack_the_code/core/widgets/loaders/shimmer_loading.dart';

/// Glossary section in video player tabs
/// Shows glossary terms related to the current video's chapter
class GlossarySection extends ConsumerStatefulWidget {
  final String? chapterId;
  final String? subjectId;

  const GlossarySection({
    super.key,
    this.chapterId,
    this.subjectId,
  });

  @override
  ConsumerState<GlossarySection> createState() => _GlossarySectionState();
}

class _GlossarySectionState extends ConsumerState<GlossarySection> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chapterId == null || widget.chapterId!.isEmpty) {
      return _buildEmptyState(context, 'No chapter associated with this video');
    }

    final glossaryAsync = ref.watch(glossaryNotifierProvider(widget.chapterId!));
    final isJunior = SegmentConfig.isCrackTheCode;

    // Initialize with subject context if available
    if (widget.subjectId != null) {
      ref.read(glossaryNotifierProvider(widget.chapterId!).notifier)
        .setSubjectId(widget.subjectId!);
    }

    return glossaryAsync.when(
      loading: () => const _GlossaryShimmer(),
      error: (error, _) => _buildErrorState(context, error.toString()),
      data: (terms) {
        // Filter terms based on search query
        final filteredTerms = _searchQuery.isEmpty
            ? terms
            : terms.where((term) =>
                term.term.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                term.definition.toLowerCase().contains(_searchQuery.toLowerCase())
              ).toList();

        if (terms.isEmpty) {
          return _buildEmptyState(context, 'No glossary terms available for this chapter');
        }

        return Column(
          children: [
            // Search bar
            _buildSearchBar(context),

            // Terms count and View All
            _buildHeader(context, filteredTerms.length, terms.length),

            // Terms list
            Expanded(
              child: filteredTerms.isEmpty
                  ? _buildNoSearchResults(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm,
                      ),
                      itemCount: filteredTerms.length,
                      itemBuilder: (context, index) => _GlossaryTermCard(
                        term: filteredTerms[index],
                        isJunior: isJunior,
                        onTap: () => _showTermDetails(context, filteredTerms[index]),
                      ),
                    ),
            ),

            // View All Button
            if (terms.length > 5)
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToFullGlossary(context),
                    icon: const Icon(Icons.menu_book),
                    label: const Text('View All Terms'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search terms...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int shownCount, int totalCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _searchQuery.isEmpty
                ? '$totalCount terms'
                : '$shownCount of $totalCount terms',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (_searchQuery.isEmpty && totalCount > 0)
            TextButton.icon(
              onPressed: () => _navigateToFullGlossary(context),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Full Glossary'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No terms found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Try a different search term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Glossary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Failed to load glossary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermDetails(BuildContext context, GlossaryTerm term) {
    final isJunior = SegmentConfig.isCrackTheCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getDifficultyColor(term.difficulty).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.menu_book,
                size: 20,
                color: _getDifficultyColor(term.difficulty),
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Expanded(
              child: Text(
                term.term,
                style: isJunior
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pronunciation
              if (term.hasPronunciation) ...[
                Row(
                  children: [
                    Icon(
                      Icons.volume_up,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      term.pronunciation!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
              ],

              // Definition
              Text(
                'Definition',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                term.definition,
                style: isJunior
                    ? Theme.of(context).textTheme.bodyLarge
                    : Theme.of(context).textTheme.bodyMedium,
              ),

              // Example
              if (term.hasExample) ...[
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Example',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    term.exampleUsage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],

              // Difficulty badge
              const SizedBox(height: AppTheme.spacingMd),
              _DifficultyBadge(difficulty: term.difficulty),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToFullGlossary(BuildContext context) {
    if (widget.chapterId != null) {
      // Navigate to full glossary screen
      context.push(
        RouteConstants.getGlossaryPath(widget.chapterId!),
        extra: {'subjectId': widget.subjectId},
      );
    }
  }

  Color _getDifficultyColor(TermDifficulty difficulty) {
    return switch (difficulty) {
      TermDifficulty.easy => Colors.green,
      TermDifficulty.medium => Colors.orange,
      TermDifficulty.hard => Colors.red,
    };
  }
}

/// Compact glossary term card for tab view
class _GlossaryTermCard extends StatelessWidget {
  final GlossaryTerm term;
  final bool isJunior;
  final VoidCallback onTap;

  const _GlossaryTermCard({
    required this.term,
    required this.isJunior,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Term icon with difficulty color
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(term.difficulty).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  term.firstLetter,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(term.difficulty),
                      ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),

              // Term and definition
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term.term,
                      style: isJunior
                          ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              )
                          : Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      term.definitionPreview,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Expand icon
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(TermDifficulty difficulty) {
    return switch (difficulty) {
      TermDifficulty.easy => Colors.green,
      TermDifficulty.medium => Colors.orange,
      TermDifficulty.hard => Colors.red,
    };
  }
}

/// Difficulty badge widget
class _DifficultyBadge extends StatelessWidget {
  final TermDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (difficulty) {
      TermDifficulty.easy => (Colors.green, 'Easy'),
      TermDifficulty.medium => (Colors.orange, 'Medium'),
      TermDifficulty.hard => (Colors.red, 'Hard'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading state for glossary
class _GlossaryShimmer extends StatelessWidget {
  const _GlossaryShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          children: [
            // Search bar shimmer
            SkeletonBox(
              height: 48,
              width: double.infinity,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            // Term cards shimmer
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: SkeletonBox(
                  height: 72,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
