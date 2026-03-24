// Profile Management Screen
// Allows users to create, edit, switch, and delete student profiles

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';

class ProfileManagementScreen extends ConsumerStatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  ConsumerState<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState
    extends ConsumerState<ProfileManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProfileDialog(context),
            tooltip: 'Add Student',
          ),
        ],
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              children: [
                // Active profile section
                Text(
                  'Current Student',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                _buildActiveProfileCard(profileState.profile, colorScheme),
                const SizedBox(height: AppTheme.spacingLg),

                // All profiles section
                if (profileState.allProfiles.length > 1) ...[
                  Text(
                    'Switch Student',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  ...profileState.allProfiles
                      .where((p) => p.id != profileState.profile.id)
                      .map((profile) =>
                          _buildProfileTile(profile, colorScheme)),
                  const SizedBox(height: AppTheme.spacingLg),
                ],

                // Add new profile button
                OutlinedButton.icon(
                  onPressed: () => _showAddProfileDialog(context),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Another Student'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildActiveProfileCard(UserProfile profile, ColorScheme colorScheme) {
    final avatar = profile.avatar;
    final settings = SegmentConfig.settings;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        side: BorderSide(color: colorScheme.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Color(avatar?['color'] as int? ?? 0xFFFFB74D),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  avatar?['icon'] as String? ?? '🐻',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${settings.gradePrefix} ${profile.grade ?? settings.minGrade}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
            // Edit button
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditProfileDialog(context, profile),
              tooltip: 'Edit Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(UserProfile profile, ColorScheme colorScheme) {
    final avatar = profile.avatar;
    final settings = SegmentConfig.settings;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: ListTile(
        onTap: () => _switchToProfile(profile),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(avatar?['color'] as int? ?? 0xFFFFB74D),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              avatar?['icon'] as String? ?? '🐻',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(profile.displayName),
        subtitle: Text('${settings.gradePrefix} ${profile.grade ?? settings.minGrade}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditProfileDialog(context, profile),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20, color: colorScheme.error),
              onPressed: () => _confirmDeleteProfile(context, profile),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _switchToProfile(UserProfile profile) async {
    await ref.read(userProfileProvider.notifier).switchProfile(profile.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${profile.displayName}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  Future<void> _showAddProfileDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _ProfileFormDialog(),
    );

    if (result != null && mounted) {
      await ref.read(userProfileProvider.notifier).createProfile(
            name: result['name'] as String,
            grade: result['grade'] as int,
            avatarId: result['avatarId'] as String?,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${result['name']}'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  Future<void> _showEditProfileDialog(
      BuildContext context, UserProfile profile) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _ProfileFormDialog(profile: profile),
    );

    if (result != null && mounted) {
      final updatedProfile = profile.copyWith(
        name: result['name'] as String,
        grade: result['grade'] as int,
        avatarId: result['avatarId'] as String?,
      );
      await ref.read(userProfileProvider.notifier).updateProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated ${result['name']}'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteProfile(
      BuildContext context, UserProfile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student?'),
        content: Text(
          'Are you sure you want to delete ${profile.displayName}\'s profile? '
          'This will remove all their progress and data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(userProfileProvider.notifier)
          .deleteProfile(profile.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Deleted ${profile.displayName}'
                  : 'Cannot delete the only profile',
            ),
            backgroundColor: success
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

/// Dialog for adding or editing a profile
class _ProfileFormDialog extends StatefulWidget {
  final UserProfile? profile;

  const _ProfileFormDialog({this.profile});

  @override
  State<_ProfileFormDialog> createState() => _ProfileFormDialogState();
}

class _ProfileFormDialogState extends State<_ProfileFormDialog> {
  late TextEditingController _nameController;
  late int _selectedGrade;
  late String _selectedAvatarId;

  @override
  void initState() {
    super.initState();
    final settings = SegmentConfig.settings;
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _selectedGrade = widget.profile?.grade ?? settings.minGrade;
    _selectedAvatarId = widget.profile?.avatarId ??
        ProfileAvatars.avatars.first['id'] as String;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = SegmentConfig.settings;
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.profile != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Student' : 'Add Student'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar selection
            Text(
              'Choose Avatar',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Wrap(
              spacing: AppTheme.spacingSm,
              runSpacing: AppTheme.spacingSm,
              children: ProfileAvatars.avatars.map((avatar) {
                final isSelected = avatar['id'] == _selectedAvatarId;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarId = avatar['id'] as String;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(avatar['color'] as int),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: colorScheme.primary, width: 3)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        avatar['icon'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Name input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                hintText: 'Enter name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: !isEditing,
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Grade selection
            Text(
              'Select Grade',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Wrap(
              spacing: AppTheme.spacingSm,
              children: List.generate(
                settings.maxGrade - settings.minGrade + 1,
                (index) {
                  final grade = settings.minGrade + index;
                  final isSelected = grade == _selectedGrade;
                  return ChoiceChip(
                    label: Text('${settings.gradePrefix} $grade'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedGrade = grade;
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a name')),
              );
              return;
            }
            Navigator.pop(context, {
              'name': _nameController.text.trim(),
              'grade': _selectedGrade,
              'avatarId': _selectedAvatarId,
            });
          },
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
