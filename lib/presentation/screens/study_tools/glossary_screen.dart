/// Glossary Screen for chapter terms and definitions
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/services/audio_player_service.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/domain/entities/study_tools/glossary_term.dart';
import 'package:streamshaala/presentation/providers/study_tools/glossary_provider.dart';

/// Glossary Screen
/// Displays searchable glossary terms for a chapter
class GlossaryScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const GlossaryScreen({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends ConsumerState<GlossaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final termsAsync = ref.watch(glossaryNotifierProvider(widget.chapterId));
    final isJunior = SegmentConfig.isJunior;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossary'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SearchBar(
            controller: _searchController,
            onChanged: (query) {
              setState(() => _searchQuery = query);
              ref
                  .read(glossaryNotifierProvider(widget.chapterId).notifier)
                  .search(query);
            },
          ),
        ),
      ),
      body: termsAsync.when(
        loading: () => const _GlossaryShimmer(),
        error: (error, _) => _buildErrorState(context, error.toString()),
        data: (terms) {
          if (terms.isEmpty) {
            if (_searchQuery.isNotEmpty) {
              return _buildNoResultsState(context);
            }
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            itemCount: terms.length,
            itemBuilder: (context, index) => _GlossaryTermCard(
              term: terms[index],
              isJunior: isJunior,
              searchQuery: _searchQuery,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
              'No Glossary Terms',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Glossary terms for this chapter have not been added yet.',
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

  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Try a different search term.',
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
}

/// Search bar widget
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search terms...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}

/// Glossary term card widget
class _GlossaryTermCard extends StatefulWidget {
  final GlossaryTerm term;
  final bool isJunior;
  final String searchQuery;

  const _GlossaryTermCard({
    required this.term,
    required this.isJunior,
    required this.searchQuery,
  });

  @override
  State<_GlossaryTermCard> createState() => _GlossaryTermCardState();
}

class _GlossaryTermCardState extends State<_GlossaryTermCard> {
  bool _isExpanded = false;
  bool _isPlayingAudio = false;
  bool _isLoadingAudio = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Term header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (Junior segment or if available)
                  if (widget.isJunior && widget.term.hasImage)
                    Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spacingMd),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.term.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 60,
                            height: 60,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 60,
                            height: 60,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Term and definition
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildHighlightedText(
                                context,
                                widget.term.term,
                                widget.searchQuery,
                                widget.isJunior
                                    ? Theme.of(context).textTheme.titleLarge
                                    : Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (widget.term.hasPronunciation)
                              Text(
                                widget.term.pronunciation!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        _buildHighlightedText(
                          context,
                          widget.term.definition,
                          widget.searchQuery,
                          widget.isJunior
                              ? Theme.of(context).textTheme.bodyLarge
                              : Theme.of(context).textTheme.bodyMedium,
                          maxLines: _isExpanded ? null : 2,
                        ),
                      ],
                    ),
                  ),

                  // Expand indicator
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),

              // Expanded content
              if (_isExpanded) ...[
                const SizedBox(height: AppTheme.spacingMd),
                const Divider(),

                // Example usage
                if (widget.term.hasExample) ...[
                  const SizedBox(height: AppTheme.spacingSm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: Text(
                          widget.term.exampleUsage!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Audio button (show for all segments if audio available)
                if (widget.term.hasAudio) ...[
                  const SizedBox(height: AppTheme.spacingMd),
                  ElevatedButton.icon(
                    onPressed: _isLoadingAudio ? null : _playAudio,
                    icon: _isLoadingAudio
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_isPlayingAudio ? Icons.stop : Icons.volume_up),
                    label: Text(_isPlayingAudio ? 'Stop' : 'Listen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPlayingAudio
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                ],

                // Difficulty badge
                const SizedBox(height: AppTheme.spacingSm),
                Row(
                  children: [
                    _DifficultyBadge(difficulty: widget.term.difficulty),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    String query,
    TextStyle? style, {
    int? maxLines,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }

  Future<void> _playAudio() async {
    if (!widget.term.hasAudio) return;

    // If already playing, stop
    if (_isPlayingAudio) {
      await audioPlayerService.stop();
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
          _isLoadingAudio = false;
        });
      }
      return;
    }

    // Start loading
    setState(() => _isLoadingAudio = true);

    try {
      final audioUrl = widget.term.audioUrl!;
      bool success;

      // Check if it's an asset or URL
      if (audioUrl.startsWith('assets/')) {
        success = await audioPlayerService.playFromAsset(audioUrl);
      } else {
        success = await audioPlayerService.playFromUrl(audioUrl);
      }

      if (mounted) {
        if (success) {
          setState(() {
            _isPlayingAudio = true;
            _isLoadingAudio = false;
          });

          // Listen for playback completion
          audioPlayerService.player.playerStateStream.listen((state) {
            if (state.processingState == ProcessingState.completed && mounted) {
              setState(() {
                _isPlayingAudio = false;
              });
            }
          });
        } else {
          setState(() => _isLoadingAudio = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to play audio'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
          _isLoadingAudio = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audio error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Difficulty badge widget
class _DifficultyBadge extends StatelessWidget {
  final TermDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Color _getColor() {
    switch (difficulty) {
      case TermDifficulty.easy:
        return Colors.green;
      case TermDifficulty.medium:
        return Colors.orange;
      case TermDifficulty.hard:
        return Colors.red;
    }
  }

  String _getLabel() {
    switch (difficulty) {
      case TermDifficulty.easy:
        return 'Easy';
      case TermDifficulty.medium:
        return 'Medium';
      case TermDifficulty.hard:
        return 'Advanced';
    }
  }
}

/// Shimmer loading for glossary
class _GlossaryShimmer extends StatelessWidget {
  const _GlossaryShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          children: List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: AppTheme.spacingMd),
              child: SkeletonBox(height: 100, width: double.infinity),
            ),
          ),
        ),
      ),
    );
  }
}
