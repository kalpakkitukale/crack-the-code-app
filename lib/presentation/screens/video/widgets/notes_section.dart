import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Notes Section
/// Allows users to take timestamped notes while watching videos
class NotesSection extends StatefulWidget {
  /// Callback to get the current video timestamp in seconds
  final double Function()? getCurrentTimestamp;

  const NotesSection({
    super.key,
    this.getCurrentTimestamp,
  });

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _notes = [];
  int? _editingIndex;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Notes List
        Expanded(
          child: _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 64,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'No notes yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Add notes while watching the video',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(
                      index,
                      _notes[index]['timestamp']!,
                      _notes[index]['note']!,
                      colorScheme,
                    );
                  },
                ),
        ),

        // Add/Edit Note Input
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_editingIndex != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Editing note',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _cancelEdit,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: _editingIndex != null ? 'Edit your note...' : 'Add a note...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingSm,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _addNote(),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  IconButton(
                    onPressed: _addNote,
                    icon: Icon(_editingIndex != null ? Icons.check : Icons.send),
                    tooltip: _editingIndex != null ? 'Save' : 'Add Note',
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(int index, String timestamp, String note, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _editNote(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit note',
                ),
                const SizedBox(width: AppTheme.spacingSm),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => _deleteNote(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Delete note',
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              note,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _editNote(int index) {
    final note = _notes[index];
    _noteController.text = note['note']!;
    setState(() {
      _editingIndex = index;
    });
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notes.removeAt(index);
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;

    setState(() {
      if (_editingIndex != null) {
        // Update existing note
        _notes[_editingIndex!]['note'] = _noteController.text.trim();
        _editingIndex = null;
      } else {
        // Add new note with current video timestamp
        final timestamp = _formatTimestamp(widget.getCurrentTimestamp?.call() ?? 0);
        _notes.add({
          'timestamp': timestamp,
          'note': _noteController.text.trim(),
        });
      }
      _noteController.clear();
    });
  }

  /// Format seconds into MM:SS or HH:MM:SS format
  String _formatTimestamp(double seconds) {
    final totalSeconds = seconds.round();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final secs = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      _noteController.clear();
    });
  }
}
