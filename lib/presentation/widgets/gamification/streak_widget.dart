import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/presentation/providers/gamification/gamification_provider.dart';

/// Streak display widget
/// Uses derived streakDataProvider to only rebuild when streak data changes
class StreakWidget extends ConsumerWidget {
  final bool showDetails;
  final bool compact;

  const StreakWidget({
    super.key,
    this.showDetails = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use derived provider for focused rebuilds
    final streakData = ref.watch(streakDataProvider);

    if (compact) {
      return _buildCompact(context, streakData);
    }

    return _buildFull(context, streakData);
  }

  Widget _buildCompact(BuildContext context, StreakData streakData) {
    final isAtRisk = streakData.isStreakAtRisk && streakData.currentStreak > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: isAtRisk
            ? AppTheme.warningColor.withValues(alpha: 0.2)
            : AppTheme.streakFire.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: isAtRisk
            ? Border.all(color: AppTheme.warningColor, width: 2)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: isAtRisk ? AppTheme.warningColor : AppTheme.streakFire,
            size: 18,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Text(
            '${streakData.currentStreak}',
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isAtRisk ? AppTheme.warningColor : AppTheme.streakFire,
            ),
          ),
          if (isAtRisk) ...[
            const SizedBox(width: AppTheme.spacingXs),
            const Icon(Icons.warning, color: AppTheme.warningColor, size: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context, StreakData streakData) {
    final isAtRisk = streakData.isStreakAtRisk && streakData.currentStreak > 0;

    return Card(
      color: isAtRisk
          ? AppTheme.warningColor.withValues(alpha: 0.1)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildFlameIcon(streakData.currentStreak, isAtRisk),
                SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${streakData.currentStreak} Day Streak',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (streakData.currentStreak >= 7) ...[
                            const SizedBox(width: AppTheme.spacingXs),
                            const Icon(
                              Icons.verified,
                              color: AppTheme.primaryBlue,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _getStreakMessage(streakData),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isAtRisk
                              ? AppTheme.warningColor
                              : context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showDetails)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${streakData.longestStreak}',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Longest',
                        style: context.textTheme.labelSmall,
                      ),
                    ],
                  ),
              ],
            ),
            if (showDetails) ...[
              SizedBox(height: AppTheme.spacingMd),
              _buildWeekView(context, streakData),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFlameIcon(int streak, bool isAtRisk) {
    final color = isAtRisk
        ? AppTheme.warningColor
        : streak >= 30
            ? AppTheme.errorDark
            : streak >= 7
                ? AppTheme.streakFire
                : AppTheme.warningLight300;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            color: color,
            size: 28,
          ),
          if (isAtRisk)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.warningColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightSurface,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.priority_high,
                  size: 10,
                  color: AppTheme.lightSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekView(BuildContext context, StreakData streakData) {
    final today = DateTime.now();
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final todayIndex = today.weekday - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final isPast = index < todayIndex;
        final isToday = index == todayIndex;
        final isActiveToday = streakData.isActiveToday;

        // For visualization, assume consecutive days up to streak
        final dayIsActive = isPast && index >= (todayIndex - streakData.currentStreak + 1);

        return Column(
          children: [
            Text(
              days[index],
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: dayIsActive || (isToday && isActiveToday)
                    ? AppTheme.streakFire
                    : isToday
                        ? AppTheme.warningColor.withValues(alpha: 0.3)
                        : context.colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: AppTheme.streakFire, width: 2)
                    : null,
              ),
              child: dayIsActive || (isToday && isActiveToday)
                  ? Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: context.colorScheme.onPrimary,
                    )
                  : null,
            ),
          ],
        );
      }),
    );
  }

  String _getStreakMessage(StreakData streakData) {
    if (streakData.isStreakAtRisk && streakData.currentStreak > 0) {
      return 'Learn today to keep your streak!';
    }
    if (streakData.isActiveToday) {
      return 'Great job! Come back tomorrow!';
    }
    if (streakData.currentStreak >= 30) {
      return 'Incredible dedication!';
    }
    if (streakData.currentStreak >= 7) {
      return 'A full week! Keep it up!';
    }
    if (streakData.currentStreak >= 3) {
      return 'Building momentum!';
    }
    if (streakData.currentStreak == 0) {
      return 'Start your streak today!';
    }
    return 'Keep learning daily!';
  }
}

/// Streak milestone celebration widget
class StreakMilestoneCelebration extends StatelessWidget {
  final int streak;
  final VoidCallback onDismiss;

  const StreakMilestoneCelebration({
    super.key,
    required this.streak,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.streakFire, AppTheme.warningColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 64,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              '$streak Day Streak!',
              style: context.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              _getMilestoneMessage(streak),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            FilledButton(
              onPressed: onDismiss,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: AppTheme.streakFire,
              ),
              child: const Text('Keep Going!'),
            ),
          ],
        ),
      ),
    );
  }

  String _getMilestoneMessage(int streak) {
    if (streak >= 365) return 'A FULL YEAR! You\'re legendary!';
    if (streak >= 100) return '100 days! Unstoppable!';
    if (streak >= 30) return 'A month of learning! Amazing!';
    if (streak >= 7) return 'A week straight! Great habit!';
    if (streak >= 3) return 'Three days in a row! Nice start!';
    return 'Keep the momentum going!';
  }
}
