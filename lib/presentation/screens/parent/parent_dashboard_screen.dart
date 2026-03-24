// Parent Dashboard Screen
// Comprehensive view for parents to monitor child's learning activity
// Includes: Today's Activity, This Week Summary, Progress Overview, Learning Insights,
// Recommendations, and Quick Settings
// Reference: JUNIOR_APP_DETAILED_PLAN.md Section 9.4

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/providers/parental/parental_controls_provider.dart';
import 'package:crack_the_code/presentation/providers/gamification/gamification_provider.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';

/// Parent Dashboard Screen
/// Shows comprehensive activity and progress data for parents
/// Enhanced with learning insights and personalized recommendations
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentalState = ref.watch(parentalControlsProvider);
    final gamificationState = ref.watch(gamificationProvider);
    final progressState = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Parental Settings',
            onPressed: () => context.push('/settings/parental-controls'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh all data
          await ref.read(progressProvider.notifier).loadStatistics();
          await ref.read(progressProvider.notifier).loadWatchHistory();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Child info header with level and streak
            _ChildInfoHeader(gamificationState: gamificationState),
            const SizedBox(height: 20),

            // Today's Activity Summary
            _TodaysActivityCard(
              parentalState: parentalState,
              gamificationState: gamificationState,
              progressState: progressState,
            ),
            const SizedBox(height: 16),

            // Learning Insights Card - NEW
            _LearningInsightsCard(
              gamificationState: gamificationState,
              progressState: progressState,
            ),
            const SizedBox(height: 16),

            // This Week Summary
            _ThisWeekCard(
              gamificationState: gamificationState,
              progressState: progressState,
            ),
            const SizedBox(height: 16),

            // Recommendations for Parents - NEW
            _ParentRecommendationsCard(
              gamificationState: gamificationState,
              progressState: progressState,
            ),
            const SizedBox(height: 16),

            // Progress Overview
            _ProgressOverviewCard(progressState: progressState),
            const SizedBox(height: 16),

            // Quick Actions
            _QuickActionsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Child Info Header
class _ChildInfoHeader extends StatelessWidget {
  final GamificationState gamificationState;

  const _ChildInfoHeader({required this.gamificationState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 32,
              backgroundColor: colorScheme.primary,
              child: Text(
                'L${gamificationState.level}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gamificationState.levelTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level ${gamificationState.level} • ${gamificationState.totalXp} XP',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // XP Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: gamificationState.levelProgress,
                      backgroundColor: colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // Streak display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '${gamificationState.currentStreak}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'day streak',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Today's Activity Card
class _TodaysActivityCard extends ConsumerWidget {
  final ParentalControlsState parentalState;
  final GamificationState gamificationState;
  final ProgressState progressState;

  const _TodaysActivityCard({
    required this.parentalState,
    required this.gamificationState,
    required this.progressState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get today's quizzes
    final recentQuizzesAsync = ref.watch(recentQuizzesProvider(10));

    final todayVideos = _getTodayVideosCount(progressState);
    final todayQuizzes = recentQuizzesAsync.when(
      data: (quizzes) => _getTodayQuizzesCount(quizzes),
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "Today's Activity",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Activity grid
            Row(
              children: [
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.timer_outlined,
                    value: '${parentalState.usage.minutesUsed}',
                    label: 'min',
                    sublabel: 'Time Spent',
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.play_circle_outline,
                    value: '$todayVideos',
                    label: '',
                    sublabel: 'Videos',
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.quiz_outlined,
                    value: '$todayQuizzes',
                    label: '',
                    sublabel: 'Quizzes',
                    color: const Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActivityTile(
                    icon: Icons.star_outline,
                    value: '+${_getTodayXp(gamificationState)}',
                    label: '',
                    sublabel: 'XP',
                    color: const Color(0xFFFFD700),
                  ),
                ),
              ],
            ),

            // Screen time progress
            if (parentalState.settings.screenTimeLimit.hasLimit) ...[
              const Divider(height: 32),
              _ScreenTimeProgress(parentalState: parentalState),
            ],
          ],
        ),
      ),
    );
  }

  int _getTodayVideosCount(ProgressState state) {
    final today = DateTime.now();
    return state.watchHistory.where((p) {
      return p.lastWatched.year == today.year &&
          p.lastWatched.month == today.month &&
          p.lastWatched.day == today.day;
    }).length;
  }

  int _getTodayQuizzesCount(List<dynamic> quizzes) {
    final today = DateTime.now();
    return quizzes.where((q) {
      final date = q.completedAt ?? q.startedAt;
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).length;
  }

  int _getTodayXp(GamificationState state) {
    // Approximate today's XP based on activity
    return state.lastXpAward?.xpAwarded ?? 0;
  }
}

/// Activity Tile Widget
class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String sublabel;
  final Color color;

  const _ActivityTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (label.isNotEmpty)
                  TextSpan(
                    text: ' $label',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen Time Progress
class _ScreenTimeProgress extends StatelessWidget {
  final ParentalControlsState parentalState;

  const _ScreenTimeProgress({required this.parentalState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final usage = parentalState.usage;
    final limit = parentalState.settings.screenTimeLimit;
    final progress = usage.usagePercentage(limit);
    final remaining = parentalState.remainingMinutes;

    Color progressColor;
    if (progress >= 0.9) {
      progressColor = AppTheme.errorColor;
    } else if (progress >= 0.7) {
      progressColor = AppTheme.warningColor;
    } else {
      progressColor = AppTheme.successColor;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Screen Time',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              remaining > 0
                  ? '$remaining min remaining'
                  : 'Limit reached',
              style: theme.textTheme.bodySmall?.copyWith(
                color: remaining > 0
                    ? colorScheme.onSurfaceVariant
                    : AppTheme.errorColor,
                fontWeight: remaining <= 0 ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(progressColor),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${usage.minutesUsed} of ${limit.minutes ?? "∞"} minutes',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// This Week Summary Card
class _ThisWeekCard extends StatelessWidget {
  final GamificationState gamificationState;
  final ProgressState progressState;

  const _ThisWeekCard({
    required this.gamificationState,
    required this.progressState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final weekStats = _getWeekStats(progressState);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_view_week, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'This Week',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Week summary grid
            Row(
              children: [
                Expanded(
                  child: _WeekStatTile(
                    label: 'Total Time',
                    value: _formatDuration(weekStats['totalMinutes'] as int),
                    icon: Icons.access_time,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _WeekStatTile(
                    label: 'Subjects',
                    value: '${weekStats['subjects']}',
                    icon: Icons.school,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _WeekStatTile(
                    label: 'Streak',
                    value: '${gamificationState.currentStreak} days',
                    icon: Icons.local_fire_department,
                    valueColor: AppTheme.warningColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _WeekStatTile(
                    label: 'Badges',
                    value: '${gamificationState.unlockedBadgeCount}',
                    icon: Icons.emoji_events,
                    valueColor: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getWeekStats(ProgressState state) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weekHistory = state.watchHistory.where((p) {
      return p.lastWatched.isAfter(weekAgo);
    }).toList();

    final totalMinutes = weekHistory.fold<int>(
      0,
      (sum, p) => sum + (p.watchDuration ~/ 60),
    );

    // Count unique video channels as proxy for subjects
    final subjects = weekHistory
        .map((p) => p.channelName)
        .where((s) => s != null)
        .toSet()
        .length;

    return {
      'totalMinutes': totalMinutes,
      'subjects': subjects,
      'videosWatched': weekHistory.length,
    };
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}

/// Week Stat Tile
class _WeekStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _WeekStatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: valueColor ?? colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress Overview Card
class _ProgressOverviewCard extends StatelessWidget {
  final ProgressState progressState;

  const _ProgressOverviewCard({required this.progressState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final subjectProgress = _getSubjectProgress(progressState);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Progress Overview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (subjectProgress.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No learning activity yet',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...subjectProgress.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SubjectProgressRow(
                  subjectName: entry.key,
                  progress: entry.value['progress'] as double,
                  videosWatched: entry.value['videos'] as int,
                  color: _getSubjectColor(entry.key),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, dynamic>> _getSubjectProgress(ProgressState state) {
    final Map<String, Map<String, dynamic>> progress = {};

    for (final p in state.watchHistory) {
      // Use channel name as a proxy for subject (or title prefix)
      final subject = p.channelName ?? p.title?.split(' ').first ?? 'Videos';
      if (!progress.containsKey(subject)) {
        progress[subject] = {'videos': 0, 'completed': 0, 'total': 10};
      }
      progress[subject]!['videos'] = (progress[subject]!['videos'] as int) + 1;
      if (p.completed) {
        progress[subject]!['completed'] = (progress[subject]!['completed'] as int) + 1;
      }
    }

    // Calculate progress percentage
    for (final entry in progress.entries) {
      final completed = entry.value['completed'] as int;
      final total = entry.value['total'] as int;
      entry.value['progress'] = (completed / total).clamp(0.0, 1.0);
    }

    return progress;
  }

  Color _getSubjectColor(String subject) {
    final colors = {
      'Mathematics': const Color(0xFF4ECDC4),
      'Science': const Color(0xFF95E1D3),
      'English': const Color(0xFFFFBE76),
      'Hindi': const Color(0xFFFF6B9D),
      'EVS': const Color(0xFFAABB77),
      'Social Science': const Color(0xFF9B59B6),
    };
    return colors[subject] ?? AppTheme.primaryBlue;
  }
}

/// Subject Progress Row
class _SubjectProgressRow extends StatelessWidget {
  final String subjectName;
  final double progress;
  final int videosWatched;
  final Color color;

  const _SubjectProgressRow({
    required this.subjectName,
    required this.progress,
    required this.videosWatched,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  subjectName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              '$videosWatched videos',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Quick Actions Card
class _QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.timer,
                    label: 'Time Limits',
                    onTap: () => context.push('/settings/parental-controls'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.tune,
                    label: 'Content Filter',
                    onTap: () => context.push('/settings/parental-controls'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.download,
                    label: 'Export Report',
                    onTap: () => _showExportDialog(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Progress Report'),
        content: const Text(
          'Progress report export will be available in a future update. '
          'You can view detailed activity in the Progress Overview section above.',
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
}

/// Quick Action Button
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Learning Insights Card - Shows analysis of child's learning patterns
class _LearningInsightsCard extends StatelessWidget {
  final GamificationState gamificationState;
  final ProgressState progressState;

  const _LearningInsightsCard({
    required this.gamificationState,
    required this.progressState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final insights = _generateInsights();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Learning Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Insights list
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InsightTile(
                icon: insight['icon'] as IconData,
                title: insight['title'] as String,
                description: insight['description'] as String,
                color: insight['color'] as Color,
                isPositive: insight['isPositive'] as bool,
              ),
            )),

            if (insights.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'More insights will appear as your child learns more!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateInsights() {
    final insights = <Map<String, dynamic>>[];

    // Streak insight
    if (gamificationState.currentStreak >= 3) {
      insights.add({
        'icon': Icons.local_fire_department,
        'title': 'Great consistency!',
        'description': 'Your child has maintained a ${gamificationState.currentStreak}-day learning streak. Keep it up!',
        'color': AppTheme.warningColor,
        'isPositive': true,
      });
    } else if (gamificationState.currentStreak == 0) {
      insights.add({
        'icon': Icons.timer_off,
        'title': 'Time to get back on track',
        'description': 'Your child hasn\'t studied today. A short 10-minute session can help build consistency.',
        'color': AppTheme.warningColor,
        'isPositive': false,
      });
    }

    // Progress insight based on watch history
    final todayWatched = progressState.watchHistory.where((p) {
      final today = DateTime.now();
      return p.lastWatched.year == today.year &&
          p.lastWatched.month == today.month &&
          p.lastWatched.day == today.day;
    }).length;

    if (todayWatched >= 3) {
      insights.add({
        'icon': Icons.star,
        'title': 'Active learner today!',
        'description': 'Your child has watched $todayWatched videos today. Great engagement!',
        'color': AppTheme.successColor,
        'isPositive': true,
      });
    }

    // Level progress insight
    if (gamificationState.levelProgress > 0.7) {
      insights.add({
        'icon': Icons.trending_up,
        'title': 'Almost at the next level!',
        'description': 'Just ${((1 - gamificationState.levelProgress) * 100).toInt()}% more to reach Level ${gamificationState.level + 1}.',
        'color': AppTheme.primaryBlue,
        'isPositive': true,
      });
    }

    // Completion insight
    final completedVideos = progressState.watchHistory.where((p) => p.completed).length;
    if (completedVideos > 0 && completedVideos % 5 == 0) {
      insights.add({
        'icon': Icons.check_circle,
        'title': 'Milestone reached!',
        'description': 'Your child has completed $completedVideos videos. Celebrate this achievement!',
        'color': AppTheme.successColor,
        'isPositive': true,
      });
    }

    return insights.take(3).toList(); // Show max 3 insights
  }
}

/// Insight Tile Widget
class _InsightTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isPositive;

  const _InsightTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isPositive) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.thumb_up_alt,
                        size: 14,
                        color: AppTheme.successColor,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Parent Recommendations Card - Actionable suggestions for parents
class _ParentRecommendationsCard extends StatelessWidget {
  final GamificationState gamificationState;
  final ProgressState progressState;

  const _ParentRecommendationsCard({
    required this.gamificationState,
    required this.progressState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recommendations = _generateRecommendations();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tips_and_updates,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendations for You',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ways to support your child\'s learning',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recommendations list
            ...recommendations.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RecommendationTile(
                icon: rec['icon'] as IconData,
                title: rec['title'] as String,
                actionLabel: rec['actionLabel'] as String?,
                onAction: rec['onAction'] as VoidCallback?,
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateRecommendations() {
    final recommendations = <Map<String, dynamic>>[];

    // Screen time recommendation
    recommendations.add({
      'icon': Icons.schedule,
      'title': 'Set a consistent study time each day to build a routine',
      'actionLabel': null,
      'onAction': null,
    });

    // Streak maintenance
    if (gamificationState.currentStreak > 0) {
      recommendations.add({
        'icon': Icons.celebration,
        'title': 'Celebrate the ${gamificationState.currentStreak}-day streak! Small rewards motivate learning',
        'actionLabel': null,
        'onAction': null,
      });
    }

    // Engagement recommendation
    final watchedToday = progressState.watchHistory.where((p) {
      final today = DateTime.now();
      return p.lastWatched.year == today.year &&
          p.lastWatched.month == today.month &&
          p.lastWatched.day == today.day;
    }).length;

    if (watchedToday == 0) {
      recommendations.add({
        'icon': Icons.play_circle,
        'title': 'Encourage a short learning session today. Even 10 minutes helps!',
        'actionLabel': null,
        'onAction': null,
      });
    }

    // Quiz recommendation
    recommendations.add({
      'icon': Icons.quiz,
      'title': 'After watching videos, quizzes help reinforce learning',
      'actionLabel': null,
      'onAction': null,
    });

    // Variety recommendation
    if (progressState.watchHistory.length > 5) {
      final subjects = progressState.watchHistory
          .map((p) => p.channelName)
          .where((s) => s != null)
          .toSet();
      if (subjects.length <= 1) {
        recommendations.add({
          'icon': Icons.explore,
          'title': 'Encourage exploring different subjects for well-rounded learning',
          'actionLabel': null,
          'onAction': null,
        });
      }
    }

    return recommendations.take(4).toList(); // Show max 4 recommendations
  }
}

/// Recommendation Tile Widget
class _RecommendationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _RecommendationTile({
    required this.icon,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionLabel!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
