import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/providers/user/subject_progress_provider.dart';

/// Subject Distribution Pie Chart
/// Shows time/video distribution across subjects
class SubjectPieChart extends ConsumerWidget {
  const SubjectPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subjectProgressAsync = ref.watch(subjectProgressListProvider);

    return subjectProgressAsync.when(
      data: (subjects) {
        if (subjects.isEmpty) {
          return _buildEmptyState(theme);
        }

        // Calculate total videos for percentage
        final totalVideos = subjects.fold<int>(0, (sum, s) => sum + s.completedVideos);

        if (totalVideos == 0) {
          return _buildEmptyState(theme);
        }

        // Prepare data for pie chart (top 5 subjects)
        final topSubjects = subjects.take(5).toList();
        final colors = [
          Colors.blue,
          Colors.orange,
          Colors.green,
          Colors.purple,
          Colors.red,
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject Distribution',
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
                    // Pie Chart
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: List.generate(
                            topSubjects.length,
                            (index) {
                              final subject = topSubjects[index];
                              final percentage = (subject.completedVideos / totalVideos * 100).toInt();
                              final color = colors[index % colors.length];

                              return PieChartSectionData(
                                value: subject.completedVideos.toDouble(),
                                title: '$percentage%',
                                color: color,
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                badgeWidget: percentage > 10
                                    ? null
                                    : Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: color, width: 2),
                                        ),
                                        child: Text(
                                          '$percentage%',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                badgePositionPercentageOffset: 1.3,
                              );
                            },
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              // Handle touch events if needed
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // Legend
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        topSubjects.length,
                        (index) {
                          final subject = topSubjects[index];
                          final color = colors[index % colors.length];

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                subject.subjectName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${subject.completedVideos})',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingXl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => _buildEmptyState(theme),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'No subject data yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              'Start watching videos to see your subject distribution',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
