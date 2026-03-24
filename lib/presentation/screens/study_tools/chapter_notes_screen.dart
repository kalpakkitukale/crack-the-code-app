/// Chapter Notes Screen for viewing and managing study notes
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_note.dart';
import 'package:streamshaala/presentation/providers/study_tools/chapter_notes_provider.dart';
import 'package:streamshaala/presentation/providers/user/user_profile_provider.dart';
import 'package:streamshaala/presentation/screens/study_tools/widgets/note_editor.dart';

/// Chapter Notes Screen
/// Displays curated and personal notes for a chapter
class ChapterNotesScreen extends ConsumerWidget {
  final String chapterId;
  final String subjectId;

  const ChapterNotesScreen({
    super.key,
    required this.chapterId,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileId = ref.watch(activeProfileProvider).id;
    final notesAsync = ref.watch(
      chapterNotesProvider(chapterId, subjectId, profileId),
    );
    final isJunior = SegmentConfig.isJunior;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: notesAsync.when(
        loading: () => const _NotesShimmer(),
        error: (error, _) => _buildErrorState(context, error.toString()),
        data: (notesData) => _NotesContent(
          chapterId: chapterId,
          profileId: profileId,
          notesData: notesData,
          isJunior: isJunior,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(context, ref, profileId),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteEditor(BuildContext context, WidgetRef ref, String profileId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => NoteEditorSheet(
        chapterId: chapterId,
        profileId: profileId,
        onSave: (content, title, tags) async {
          final notifier = ref.read(
            personalNotesNotifierProvider(chapterId, profileId).notifier,
          );
          final success = await notifier.addNote(
            content: content,
            title: title,
            tags: tags,
          );
          if (context.mounted) {
            Navigator.pop(context);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note saved')),
              );
              // Invalidate the main notes provider to refresh
              ref.invalidate(
                chapterNotesProvider(chapterId, subjectId, profileId),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to save note'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
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
              'Failed to load notes',
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

/// Notes content widget
class _NotesContent extends StatelessWidget {
  final String chapterId;
  final String profileId;
  final ChapterNotesData notesData;
  final bool isJunior;

  const _NotesContent({
    required this.chapterId,
    required this.profileId,
    required this.notesData,
    required this.isJunior,
  });

  @override
  Widget build(BuildContext context) {
    if (notesData.totalCount == 0) {
      return _buildEmptyState(context);
    }

    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      children: [
        // Curated notes section
        if (notesData.curatedNotes.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.auto_awesome,
            title: 'Study Tips',
            count: notesData.curatedNotes.length,
            iconColor: Colors.amber,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          ...notesData.curatedNotes.map(
            (note) => _NoteCard(
              note: note,
              isJunior: isJunior,
              isCurated: true,
              chapterId: chapterId,
              profileId: profileId,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
        ],

        // Personal notes section
        _SectionHeader(
          icon: Icons.edit_note,
          title: 'My Notes',
          count: notesData.personalNotes.length,
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        if (notesData.personalNotes.isEmpty)
          _EmptyPersonalNotes()
        else
          ...notesData.personalNotes.map(
            (note) => _NoteCard(
              note: note,
              isJunior: isJunior,
              isCurated: false,
              chapterId: chapterId,
              profileId: profileId,
            ),
          ),

        // Add some space at bottom for FAB
        const SizedBox(height: 80),
      ],
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
              Icons.note_alt_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Notes Yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Tap the + button to add your first note.',
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
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color iconColor;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

/// Note card widget
class _NoteCard extends ConsumerWidget {
  final ChapterNote note;
  final bool isJunior;
  final bool isCurated;
  final String chapterId;
  final String profileId;

  const _NoteCard({
    required this.note,
    required this.isJunior,
    required this.isCurated,
    required this.chapterId,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(note.id),
      direction: isCurated ? DismissDirection.none : DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (isCurated) return false;
        return await _showDeleteConfirmation(context);
      },
      onDismissed: (direction) {
        ref
            .read(personalNotesNotifierProvider(chapterId, profileId).notifier)
            .deleteNote(note.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppTheme.spacingMd),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
        child: InkWell(
          onTap: isCurated ? null : () => _showNoteOptions(context, ref),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pin indicator
                    if (note.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                        child: Icon(
                          Icons.push_pin,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                    // Title or content preview
                    Expanded(
                      child: note.title != null && note.title!.isNotEmpty
                          ? Text(
                              note.title!,
                              style: isJunior
                                  ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      )
                                  : Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Curated badge
                    if (isCurated)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 12,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tip',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.amber[700],
                                  ),
                            ),
                          ],
                        ),
                      ),

                    // Options menu (personal notes only)
                    if (!isCurated)
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () => _showNoteOptions(context, ref),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),

                // Content
                if (note.title != null && note.title!.isNotEmpty)
                  const SizedBox(height: AppTheme.spacingSm),
                Text(
                  note.content,
                  style: isJunior
                      ? Theme.of(context).textTheme.bodyLarge
                      : Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),

                // Tags
                if (note.tags.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacingSm),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: note.tags
                        .map((tag) => _TagChip(tag: tag))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Note?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showNoteOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
              ),
              title: Text(note.isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(personalNotesNotifierProvider(chapterId, profileId).notifier)
                    .togglePin(note.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await _showDeleteConfirmation(context);
                if (confirm && context.mounted) {
                  ref
                      .read(personalNotesNotifierProvider(chapterId, profileId).notifier)
                      .deleteNote(note.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => NoteEditorSheet(
        chapterId: chapterId,
        profileId: profileId,
        initialNote: note,
        onSave: (content, title, tags) async {
          final updatedNote = note.copyWith(
            content: content,
            title: title,
            tags: tags,
            updatedAt: DateTime.now(),
          );
          final notifier = ref.read(
            personalNotesNotifierProvider(chapterId, profileId).notifier,
          );
          final success = await notifier.updateNote(updatedNote);
          if (context.mounted) {
            Navigator.pop(context);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note updated')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update note'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

/// Tag chip widget
class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '#$tag',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

/// Empty personal notes widget
class _EmptyPersonalNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            Icon(
              Icons.edit_note,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'No personal notes yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              'Tap + to add your first note',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for notes
class _NotesShimmer extends StatelessWidget {
  const _NotesShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(height: 24, width: 150),
            const SizedBox(height: AppTheme.spacingSm),
            ...List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: SkeletonBox(height: 100, width: double.infinity),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const SkeletonBox(height: 24, width: 120),
            const SizedBox(height: AppTheme.spacingSm),
            ...List.generate(
              2,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: SkeletonBox(height: 80, width: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
