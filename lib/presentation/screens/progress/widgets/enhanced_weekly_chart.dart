import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/domain/entities/user/progress.dart';

/// Enhanced Weekly Activity Chart Widget using fl_chart
/// Shows learning activity for the past 7 days with beautiful visualization
class EnhancedWeeklyChart extends ConsumerWidget {
  const EnhancedWeeklyChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressState = ref.watch(progressProvider);

    // Calculate weekly data
    final weeklyData = _calculateWeeklyData(progressState.watchHistory);
    final maxValue = weeklyData.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Activity',
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
                // Chart
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (maxValue + 2).toDouble(),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final day = weeklyData[groupIndex];
                            return BarTooltipItem(
                              '${day['label']}\n${rod.toY.toInt()} videos',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < weeklyData.length) {
                                final day = weeklyData[value.toInt()];
                                final isToday = day['isToday'] as bool;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    day['label'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                      color: isToday
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.max || value == 0) return const SizedBox();
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: List.generate(
                        weeklyData.length,
                        (index) {
                          final day = weeklyData[index];
                          final count = (day['count'] as int).toDouble();
                          final isToday = day['isToday'] as bool;

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: count == 0 ? 0.5 : count,
                                color: isToday
                                    ? colorScheme.primary
                                    : colorScheme.primary.withValues(alpha: 0.7),
                                width: 20,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: (maxValue + 2).toDouble(),
                                  color: colorScheme.surfaceVariant,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),

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
