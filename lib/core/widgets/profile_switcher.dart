// Profile Switcher Widget
// A compact widget for switching between student profiles

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';
import 'package:crack_the_code/presentation/providers/content/subject_provider.dart';

/// A compact profile avatar button that opens a profile switcher
class ProfileSwitcherButton extends ConsumerWidget {
  final double size;
  final VoidCallback? onManageProfiles;

  const ProfileSwitcherButton({
    super.key,
    this.size = 36,
    this.onManageProfiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final activeProfile = profileState.profile;
    final allProfiles = profileState.allProfiles;
    final avatar = activeProfile.avatar;
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(avatar?['color'] as int? ?? 0xFFFFB74D),
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            avatar?['icon'] as String? ?? '🐻',
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
      ),
      itemBuilder: (context) {
        return [
          // Active profile header
          PopupMenuItem<String>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeProfile.displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${SegmentConfig.settings.gradePrefix} ${activeProfile.grade ?? SegmentConfig.settings.minGrade}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),

          // Other profiles to switch to
          if (allProfiles.length > 1)
            ...allProfiles
                .where((p) => p.id != activeProfile.id)
                .map((profile) {
              final profileAvatar = profile.avatar;
              return PopupMenuItem<String>(
                value: profile.id,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            Color(profileAvatar?['color'] as int? ?? 0xFFFFB74D),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          profileAvatar?['icon'] as String? ?? '🐻',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.displayName),
                          Text(
                            '${SegmentConfig.settings.gradePrefix} ${profile.grade ?? SegmentConfig.settings.minGrade}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

          // Manage profiles option
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'manage',
            child: Row(
              children: [
                Icon(
                  Icons.manage_accounts,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Manage Students',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) async {
        if (value == 'manage') {
          onManageProfiles?.call();
        } else {
          // Switch profile
          await ref.read(userProfileProvider.notifier).switchProfile(value);

          // Reload subjects for new profile's grade
          final newProfile = allProfiles.firstWhere(
            (p) => p.id == value,
            orElse: () => activeProfile,
          );
          final settings = SegmentConfig.settings;
          ref.read(subjectProvider.notifier).loadSubjects(
                boardId: settings.defaultBoardId,
                classId: 'class_${newProfile.grade ?? settings.minGrade}',
                streamId: 'general',
              );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switched to ${newProfile.displayName}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }
      },
    );
  }
}

/// A horizontal list of profile avatars for quick switching
class ProfileSwitcherRow extends ConsumerWidget {
  final double avatarSize;
  final EdgeInsets padding;

  const ProfileSwitcherRow({
    super.key,
    this.avatarSize = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final activeProfile = profileState.profile;
    final allProfiles = profileState.allProfiles;
    final colorScheme = Theme.of(context).colorScheme;

    if (allProfiles.length <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      height: avatarSize + 24, // Avatar + label
      padding: padding,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: allProfiles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final profile = allProfiles[index];
          final profileAvatar = profile.avatar;
          final isActive = profile.id == activeProfile.id;

          return GestureDetector(
            onTap: isActive
                ? null
                : () async {
                    await ref
                        .read(userProfileProvider.notifier)
                        .switchProfile(profile.id);

                    // Reload subjects for new profile's grade
                    final settings = SegmentConfig.settings;
                    ref.read(subjectProvider.notifier).loadSubjects(
                          boardId: settings.defaultBoardId,
                          classId: 'class_${profile.grade ?? settings.minGrade}',
                          streamId: 'general',
                        );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Switched to ${profile.displayName}'),
                          backgroundColor: colorScheme.primary,
                        ),
                      );
                    }
                  },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: Color(profileAvatar?['color'] as int? ?? 0xFFFFB74D),
                    shape: BoxShape.circle,
                    border: isActive
                        ? Border.all(color: colorScheme.primary, width: 3)
                        : Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      profileAvatar?['icon'] as String? ?? '🐻',
                      style: TextStyle(fontSize: avatarSize * 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: avatarSize + 8,
                  child: Text(
                    profile.name ?? 'Student',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: isActive ? FontWeight.bold : null,
                          color: isActive ? colorScheme.primary : null,
                        ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
