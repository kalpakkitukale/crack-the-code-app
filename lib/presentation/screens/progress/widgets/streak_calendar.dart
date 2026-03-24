import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Streak Calendar Widget
/// GitHub-style contribution calendar showing study streak
class StreakCalendar extends StatelessWidget {
  const StreakCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Streak',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Streak Stats
        Row(
          children: [
            _buildStreakStat(
              icon: Icons.local_fire_department,
              label: 'Current',
              value: '12',
              color: Colors.orange,
              colorScheme: colorScheme,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            _buildStreakStat(
              icon: Icons.emoji_events,
              label: 'Longest',
              value: '28',
              color: Colors.amber,
              colorScheme: colorScheme,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Calendar Grid
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last 30 Days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _buildCalendarGrid(colorScheme),
                const SizedBox(height: AppTheme.spacingMd),
                _buildLegend(colorScheme),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spacingLg),

        // Milestones
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Milestones',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _buildMilestone('7 Day Streak', true),
                _buildMilestone('14 Day Streak', false),
                _buildMilestone('30 Day Streak', false),
                _buildMilestone('100 Day Streak', false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(ColorScheme colorScheme) {
    // Mock data for last 30 days (0 = no activity, 1-3 = low-high activity)
    final days = List.generate(30, (index) {
      if (index >= 18) return 3; // Last 12 days - high activity
      if (index >= 10) return 2; // Days 10-17 - medium activity
      if (index >= 5) return 1; // Days 5-9 - low activity
      return 0; // Days 0-4 - no activity
    }).reversed.toList();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: days.map((level) {
        Color color;
        if (level == 0) {
          color = colorScheme.surfaceVariant;
        } else if (level == 1) {
          color = Colors.green.withValues(alpha: 0.3);
        } else if (level == 2) {
          color = Colors.green.withValues(alpha: 0.6);
        } else {
          color = Colors.green;
        }

        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegend(ColorScheme colorScheme) {
    return Row(
      children: [
        Text(
          'Less',
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(4, (index) {
          Color color;
          if (index == 0) {
            color = colorScheme.surfaceVariant;
          } else if (index == 1) {
            color = Colors.green.withValues(alpha: 0.3);
          } else if (index == 2) {
            color = Colors.green.withValues(alpha: 0.6);
          } else {
            color = Colors.green;
          }

          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(
          'More',
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestone(String title, bool achieved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: achieved ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            title,
            style: TextStyle(
              decoration: achieved ? TextDecoration.lineThrough : null,
              color: achieved ? Colors.grey : null,
            ),
          ),
        ],
      ),
    );
  }
}
