import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/constants/app_constants.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/presentation/providers/user/theme_provider.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';
import 'package:crack_the_code/presentation/providers/content/subject_provider.dart';
import 'package:crack_the_code/presentation/providers/parental/parental_controls_provider.dart';
import 'package:crack_the_code/presentation/providers/auth/auth_provider.dart';
import 'package:crack_the_code/presentation/screens/settings/profile_management_screen.dart';
import 'package:flutter/services.dart';
import 'dart:io';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _autoPlay = false;
  bool _wifiOnly = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Student Profiles Section (Junior only)
          if (SegmentConfig.isCrackTheCode) ...[
            _buildStudentProfilesSection(),
            const Divider(),
          ],

          // Parental Controls Section (Junior only)
          if (SegmentConfig.settings.showParentalControls) ...[
            _buildParentalControlsSection(),
            const Divider(),
          ],

          // Grade Selection Section (Junior only)
          if (SegmentConfig.isCrackTheCode) ...[
            _buildGradeSelectionSection(),
            const Divider(),
          ],

          // Board & Class Selection Section (All segments)
          _buildBoardAndClassSection(),
          const Divider(),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildThemeSelector(),
          const Divider(),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          _buildSwitchTile(
            title: 'Auto-play next video',
            subtitle: 'Automatically play the next video in playlist',
            value: _autoPlay,
            onChanged: (value) {
              setState(() => _autoPlay = value);
            },
          ),
          _buildSwitchTile(
            title: 'Download over WiFi only',
            subtitle: 'Only download videos when connected to WiFi',
            value: _wifiOnly,
            onChanged: (value) {
              setState(() => _wifiOnly = value);
            },
          ),
          _buildSwitchTile(
            title: 'Notifications',
            subtitle: 'Receive notifications for new content',
            value: _notifications,
            onChanged: (value) {
              setState(() => _notifications = value);
            },
          ),
          const Divider(),

          // Data Management Section
          _buildSectionHeader('Data Management'),
          Semantics(
            label: 'Cache Size: 45 megabytes. Tap Clear button to clear cache.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.folder_outlined, color: colorScheme.primary),
              title: const Text('Cache Size'),
              subtitle: const Text('45 MB'),
              trailing: TextButton(
                onPressed: () {
                  _showClearCacheDialog();
                },
                child: const Text('Clear'),
              ),
            ),
          ),
          Semantics(
            label: 'Downloaded Videos: 12 videos, 2.3 gigabytes. Tap to manage downloads.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.download_outlined, color: colorScheme.primary),
              title: const Text('Downloaded Videos'),
              subtitle: const Text('12 videos, 2.3 GB'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDownloadsComingSoonDialog();
              },
            ),
          ),
          Semantics(
            label: 'Clear All Data. Warning: This will remove all bookmarks, notes, and progress. Tap to clear.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.delete_outline, color: colorScheme.error),
              title: const Text('Clear All Data'),
              subtitle: const Text('Remove all bookmarks, notes, and progress'),
              onTap: () {
                _showClearDataDialog();
              },
            ),
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          Semantics(
            label: 'App Version: ${AppConstants.appVersion}',
            child: ListTile(
              leading: Icon(Icons.info_outline, color: colorScheme.primary),
              title: const Text('App Version'),
              subtitle: Text(AppConstants.appVersion),
            ),
          ),
          Semantics(
            label: 'Terms of Service. Tap to view.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.description_outlined, color: colorScheme.primary),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showTermsOfServiceDialog();
              },
            ),
          ),
          Semantics(
            label: 'Privacy Policy. Tap to view.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: colorScheme.primary),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/privacy-policy');
              },
            ),
          ),
          Semantics(
            label: 'Help and Support. Tap to view help information.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.help_outline, color: colorScheme.primary),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showHelpDialog();
              },
            ),
          ),
          // Account Section
          _buildSectionHeader('Account'),
          Semantics(
            label: 'Logout. Tap to sign out of your account.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.logout, color: colorScheme.primary),
              title: const Text('Logout'),
              subtitle: const Text('Sign out of your account'),
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ),
          const Divider(),

          Semantics(
            label: 'Exit App. Tap to close the application.',
            button: true,
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: colorScheme.error),
              title: const Text('Exit App'),
              onTap: () {
                _showExitDialog();
              },
            ),
          ),

          const SizedBox(height: AppTheme.spacingXl),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Text(
              '${AppConstants.appName} - Educational Video Aggregator',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingLg,
        AppTheme.spacingMd,
        AppTheme.spacingSm,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  /// Build parental controls section for Junior segment
  Widget _buildParentalControlsSection() {
    final parentalState = ref.watch(parentalControlsProvider);
    final remainingTime = ref.watch(remainingTimeStringProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('For Parents'),

        // Screen time status (if enabled)
        if (parentalState.settings.isEnabled &&
            parentalState.settings.showTimerToChild &&
            remainingTime != null)
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Screen Time Today',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        remainingTime,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Parental controls tile
        Semantics(
          label: parentalState.settings.isEnabled
              ? 'Parent Controls enabled. Tap to manage settings.'
              : 'Parent Controls. Tap to set up.',
          button: true,
          child: ListTile(
            leading: Icon(
              Icons.family_restroom,
              color: parentalState.settings.isEnabled
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            title: const Text('Parent Controls'),
            subtitle: Text(
              parentalState.settings.isEnabled
                  ? 'Screen time: ${parentalState.settings.screenTimeLimit.displayName}'
                  : 'Set up parental controls',
            ),
            trailing: parentalState.settings.isEnabled
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.successColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Active',
                          style: TextStyle(
                            color: AppTheme.successColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/parental-controls');
            },
          ),
        ),
      ],
    );
  }

  /// Build student profiles section for Junior segment
  Widget _buildStudentProfilesSection() {
    // Use select() to only rebuild when profile or allProfiles change
    final profileData = ref.watch(
      userProfileProvider.select((s) => (
        profile: s.profile,
        allProfiles: s.allProfiles,
      )),
    );
    final activeProfile = profileData.profile;
    final allProfiles = profileData.allProfiles;
    final colorScheme = Theme.of(context).colorScheme;
    final avatar = activeProfile.avatar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Profiles'),

        // Active profile card
        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          child: ListTile(
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
            title: Text(
              activeProfile.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              allProfiles.length > 1
                  ? '${allProfiles.length} students'
                  : '1 student',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileManagementScreen(),
                ),
              );
            },
          ),
        ),

        // Quick switch for multiple profiles
        if (allProfiles.length > 1) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            child: Text(
              'Quick Switch',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              itemCount: allProfiles.length,
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
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Switched to ${profile.displayName}'),
                                backgroundColor: colorScheme.primary,
                              ),
                            );
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spacingSm),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(profileAvatar?['color'] as int? ?? 0xFFFFB74D),
                            shape: BoxShape.circle,
                            border: isActive
                                ? Border.all(color: colorScheme.primary, width: 3)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              profileAvatar?['icon'] as String? ?? '🐻',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.name ?? 'Student',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: isActive ? FontWeight.bold : null,
                                color: isActive ? colorScheme.primary : null,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  /// Build grade selection section for Junior segment
  Widget _buildGradeSelectionSection() {
    // Use select() to only rebuild when profile.grade changes
    final currentGrade = ref.watch(
      userProfileProvider.select((s) => s.profile.grade),
    ) ?? SegmentConfig.settings.minGrade;
    final colorScheme = Theme.of(context).colorScheme;
    final settings = SegmentConfig.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Grade Selection'),

        // Current grade display
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.school,
                color: colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Grade',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      '${settings.gradePrefix} $currentGrade',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppTheme.spacingSm),

        // Grade selection tiles
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          child: Text(
            'Change Grade',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),

        // Grade options
        for (int grade = settings.minGrade; grade <= settings.maxGrade; grade++)
          RadioListTile<int>(
            title: Text('${settings.gradePrefix} $grade'),
            subtitle: Text(_getGradeDescription(grade)),
            value: grade,
            groupValue: currentGrade,
            activeColor: colorScheme.primary,
            onChanged: (value) async {
              if (value != null && value != currentGrade) {
                await _changeGrade(value);
              }
            },
          ),
      ],
    );
  }

  /// Get description for each grade
  String _getGradeDescription(int grade) {
    switch (grade) {
      case 4:
        return 'Mathematics, Science, English, EVS, Hindi';
      case 5:
        return 'Mathematics, Science, English, EVS, Hindi';
      case 6:
        return 'Mathematics, Science, English, Social Science, Hindi';
      case 7:
        return 'Mathematics, Science, English, Social Science, Hindi';
      default:
        return 'Standard subjects for Grade $grade';
    }
  }

  /// Change the user's grade and reload subjects
  Future<void> _changeGrade(int newGrade) async {
    final settings = SegmentConfig.settings;

    // Update grade in user profile
    await ref.read(userProfileProvider.notifier).setGrade(newGrade);

    // Reload subjects for new grade
    ref.read(subjectProvider.notifier).loadSubjects(
          boardId: settings.defaultBoardId,
          classId: 'class_$newGrade',
          streamId: 'general',
        );

    // Show confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${settings.gradePrefix} $newGrade'),
          backgroundColor: AppTheme.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Build Board & Class selection section (All segments)
  Widget _buildBoardAndClassSection() {
    final userState = ref.watch(userProfileProvider);
    final currentGrade = userState.profile.grade ?? SegmentConfig.settings.minGrade;
    final colorScheme = Theme.of(context).colorScheme;
    final settings = SegmentConfig.settings;

    // Get current board name (would come from board provider in full implementation)
    final String currentBoardName = _getCurrentBoardName();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Board & Class'),

        // Change Board
        ListTile(
          leading: Icon(Icons.library_books, color: colorScheme.primary),
          title: const Text('Change Board'),
          subtitle: Text(currentBoardName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to board selection
            context.push(RouteConstants.browse);
          },
        ),

        // Change Class/Grade (for non-Junior or if grade selection not shown above)
        if (!SegmentConfig.isCrackTheCode)
          ListTile(
            leading: Icon(Icons.grade, color: colorScheme.primary),
            title: const Text('Change Class'),
            subtitle: Text('${settings.gradePrefix} $currentGrade'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showClassPicker(context);
            },
          ),
      ],
    );
  }

  /// Get current board name (placeholder - would use board provider in full implementation)
  String _getCurrentBoardName() {
    final settings = SegmentConfig.settings;
    switch (settings.defaultBoardId) {
      case 'cbse_elementary':
        return 'CBSE Elementary';
      case 'cbse':
        return 'CBSE';
      case 'icse':
        return 'ICSE';
      default:
        return settings.defaultBoardId.toUpperCase();
    }
  }

  /// Show class/grade picker dialog
  void _showClassPicker(BuildContext context) {
    final settings = SegmentConfig.settings;
    final userState = ref.read(userProfileProvider);
    final currentGrade = userState.profile.grade ?? settings.minGrade;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Class'),
        content: SizedBox(
          width: double.minPositive,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: settings.maxGrade - settings.minGrade + 1,
            itemBuilder: (context, index) {
              final grade = settings.minGrade + index;
              return RadioListTile<int>(
                title: Text('${settings.gradePrefix} $grade'),
                value: grade,
                groupValue: currentGrade,
                onChanged: (value) async {
                  if (value != null) {
                    await _changeGrade(value);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    final currentTheme = ref.watch(themeProvider);

    return Column(
      children: [
        RadioListTile<AppThemeMode>(
          title: const Text('Light'),
          subtitle: const Text('Use light theme'),
          value: AppThemeMode.light,
          groupValue: currentTheme,
          onChanged: (value) {
            if (value != null) {
              ref.read(themeProvider.notifier).setTheme(value);
            }
          },
        ),
        RadioListTile<AppThemeMode>(
          title: const Text('Dark'),
          subtitle: const Text('Use dark theme'),
          value: AppThemeMode.dark,
          groupValue: currentTheme,
          onChanged: (value) {
            if (value != null) {
              ref.read(themeProvider.notifier).setTheme(value);
            }
          },
        ),
        RadioListTile<AppThemeMode>(
          title: const Text('System'),
          subtitle: const Text('Follow system theme'),
          value: AppThemeMode.system,
          groupValue: currentTheme,
          onChanged: (value) {
            if (value != null) {
              ref.read(themeProvider.notifier).setTheme(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _clearCache();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will remove all bookmarks, notes, and progress data. '
          'This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout? You will need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first

              // Sign out using auth provider
              await ref.read(authNotifierProvider.notifier).signOut();

              // Clear onboarding state so next launch shows login
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarding_complete', false);

              // Navigate to splash/login screen
              if (mounted) {
                context.go('/');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit? When you restart, the app will begin from the launch screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first

              // Clear onboarding state so next launch starts from beginning
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarding_complete', false);

              // Exit the application
              exit(0);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showDownloadsComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Downloads'),
        content: const Text(
          'Offline video downloads are coming soon! '
          'This feature will allow you to download videos for offline viewing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Builder(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Crack the Code Terms of Service\n\n',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '1. Acceptance of Terms\n'
                  'By using Crack the Code, you agree to these terms of service.\n\n'
                  '2. Educational Use\n'
                  'This app is designed for educational purposes for 12th standard students in India.\n\n'
                  '3. Content\n'
                  'All video content is aggregated from YouTube and other public sources. '
                  'We do not claim ownership of the educational content.\n\n'
                  '4. User Responsibility\n'
                  'Users are responsible for their own learning and progress tracking.\n\n'
                  '5. Privacy\n'
                  'We respect your privacy. See our Privacy Policy for more details.\n\n'
                  '6. Changes\n'
                  'We reserve the right to modify these terms at any time.\n\n'
                  'Last updated: December 2025',
                ),
              ],
            ),
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: SingleChildScrollView(
          child: Builder(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How to use Crack the Code\n\n',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '• Browse: Explore subjects, chapters, and topics\n'
                  '• Watch Videos: Tap any video to start learning\n'
                  '• Take Quizzes: Test your knowledge at 4 difficulty levels\n'
                  '• Track Progress: Monitor your learning journey\n'
                  '• Bookmarks: Save videos for quick access\n'
                  '• Foundation Path: Follow a structured learning path\n'
                  '• Recommendations: Get personalized video suggestions\n\n',
                ),
                Text(
                  'Need more help?\n\n',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Email: support@crackthecode.app\n'
                  'Version: ${AppConstants.appVersion}\n\n'
                  'For feature requests or bug reports, please contact our support team.',
                ),
              ],
            ),
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

  /// Clear cached image and temporary files
  Future<void> _clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        // Delete cache directory contents
        final files = cacheDir.listSync();
        for (var file in files) {
          try {
            if (file is File) {
              await file.delete();
            } else if (file is Directory) {
              await file.delete(recursive: true);
            }
          } catch (e) {
            // Continue deleting other files even if one fails
            debugPrint('Failed to delete ${file.path}: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing cache: $e')),
        );
      }
    }
  }

  /// Clear all user data including bookmarks, notes, and progress
  Future<void> _clearAllData() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = '${appDir.path}/database/crackthecode_unified.db';
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        // Close any existing database connections and delete the file
        await dbFile.delete();
        debugPrint('Database deleted successfully');
      }

      // Also clear cache
      await _clearCache();
    } catch (e) {
      debugPrint('Error clearing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing data: $e')),
        );
      }
    }
  }
}
