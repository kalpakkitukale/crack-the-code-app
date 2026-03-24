import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/domain/entities/user/progress.dart';

/// Weekly Activity Chart Widget
/// Shows learning activity for the past 7 days
class WeeklyChart extends ConsumerWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressState = ref.watch(progressProvider);

    // Calculate weekly data
    final weeklyData = _calculateWeeklyData(progressState.watchHistory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final day = weeklyData[index];
                    final maxValue = weeklyData.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b);
                    final height = maxValue > 0 ? (day['count'] as int) / maxValue * 100 : 20.0;
                    final isToday = day['isToday'] as bool;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            // Count badge
                            if (day['count'] as int > 0)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${day['count']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            if (day['count'] as int > 0)
                              const SizedBox(height: 4),

                            // Bar
                            Container(
                              height: height.clamp(20.0, 100.0),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? colorScheme.primary
                                    : colorScheme.primary.withValues(alpha: 0.7),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Day label
                            Text(
                              day['label'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                color: isToday
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppTheme.spacingMd),

                // Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      icon: Icons.video_library,
                      label: 'Videos',
                      value: weeklyData.fold<int>(0, (sum, day) => sum + (day['count'] as int)).toString(),
                      color: Colors.blue,
                      colorScheme: colorScheme,
                    ),
                    _buildSummaryItem(
                      icon: Icons.today,
                      label: 'Active Days',
                      value: weeklyData.where((day) => (day['count'] as int) > 0).length.toString(),
                      color: Colors.green,
                      colorScheme: colorScheme,
                    ),
                    _buildSummaryItem(
                      icon: Icons.trending_up,
                      label: 'Best Day',
                      value: weeklyData.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b).toString(),
                      color: Colors.orange,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _calculateWeeklyData(List<Progress> history) {
    final now = DateTime.now();
    final weeklyData = <Map<String, dynamic>>[];

    // Initialize 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Count videos watched on this day
      int count = 0;
      for (final progress in history) {
        final progressDate = DateTime.fromMillisecondsSinceEpoch(
          progress.lastWatched.millisecondsSinceEpoch,
        );
        final progressKey = '${progressDate.year}-${progressDate.month.toString().padLeft(2, '0')}-${progressDate.day.toString().padLeft(2, '0')}';

        if (progressKey == dateKey) {
          count++;
        }
      }

      weeklyData.add({
        'label': _getDayLabel(date),
        'count': count,
        'isToday': i == 0,
      });
    }

    return weeklyData;
  }

  String _getDayLabel(DateTime date) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
