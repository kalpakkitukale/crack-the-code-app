/// Note Editor widget for creating and editing personal notes
library;

import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/study_tools/chapter_note.dart';

/// Callback type for saving a note
typedef NoteEditorCallback = Future<void> Function(
  String content,
  String? title,
  List<String> tags,
);

/// Note Editor Sheet for creating/editing notes
class NoteEditorSheet extends StatefulWidget {
  final String chapterId;
  final String profileId;
  final ChapterNote? initialNote;
  final NoteEditorCallback onSave;

  const NoteEditorSheet({
    super.key,
    required this.chapterId,
    required this.profileId,
    this.initialNote,
    required this.onSave,
  });

  @override
  State<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<NoteEditorSheet> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;
  late List<String> _tags;
  bool _isSaving = false;

  bool get isEditing => widget.initialNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialNote?.title ?? '');
    _contentController = TextEditingController(text: widget.initialNote?.content ?? '');
    _tagController = TextEditingController();
    _tags = List<String>.from(widget.initialNote?.tags ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Note' : 'New Note',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Title field (optional)
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title (optional)',
                  hintText: 'Give your note a title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Content field
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Note content',
                  hintText: 'Write your note here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Tags section
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Tag input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add a tag...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        prefixIcon: const Icon(Icons.tag),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingSm,
                        ),
                      ),
                      onSubmitted: (_) => _addTag(),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  IconButton.filled(
                    onPressed: _addTag,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Tag chips
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: AppTheme.spacingSm,
                  runSpacing: AppTheme.spacingSm,
                  children: _tags
                      .map((tag) => InputChip(
                            label: Text(tag),
                            onDeleted: () => _removeTag(tag),
                            deleteIcon: const Icon(Icons.close, size: 16),
                          ))
                      .toList(),
                ),

              const SizedBox(height: AppTheme.spacingLg),

              // Save button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveNote,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditing ? 'Update Note' : 'Save Note'),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }

  void _addTag() {
    final tag = _tagController.text.trim().toLowerCase();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _saveNote() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some content'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final title = _titleController.text.trim();
    await widget.onSave(
      content,
      title.isNotEmpty ? title : null,
      _tags,
    );

    if (mounted) {
      setState(() => _isSaving = false);
    }
  }
}
