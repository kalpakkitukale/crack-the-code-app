import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// PerformanceChart - Chart wrapper widget for quiz performance visualization
///
/// Uses fl_chart library for professional, interactive chart visualizations.
///
/// Supports three chart types:
/// - Line chart: Score trend over time
/// - Bar chart: Performance by subject/topic
/// - Pie chart: Question type distribution
class PerformanceChart extends StatelessWidget {
  final PerformanceChartType chartType;
  final List<PerformanceDataPoint> data;
  final double height;
  final String? title;
  final String? subtitle;

  const PerformanceChart({
    super.key,
    required this.chartType,
    required this.data,
    this.height = 200,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title and subtitle
        if (title != null) ...[
          Text(
            title!,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spacingMd),
        ],

        // Chart container
        Container(
          height: height,
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: _buildChart(context),
        ),

        // Legend
        if (data.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingMd),
          _buildLegend(context),
        ],
      ],
    );
  }

  /// Build chart based on type
  Widget _buildChart(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyState(context);
    }

    switch (chartType) {
      case PerformanceChartType.line:
        return _buildLineChart(context);
      case PerformanceChartType.bar:
        return _buildBarChart(context);
      case PerformanceChartType.pie:
        return _buildPieChart(context);
    }
  }

  /// Build empty state with child-friendly messaging
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_graph,
            size: 48,
            color: context.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Start learning to see your progress!',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Line chart implementation using fl_chart
  Widget _buildLineChart(BuildContext context) {
    // Validate minimum data points for line chart
    if (data.length < 2) {
      return _buildInsufficientDataState(context);
    }

    final maxValue =
        data.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();
    final minValue =
        data.map((e) => e.value).reduce((a, b) => a < b ? a : b).toDouble();

    // Validate maxValue is usable
    if (maxValue <= 0 || !maxValue.isFinite) {
      return _buildInvalidDataState(context);
    }

    // Create spots for line chart
    final spots = List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index].value),
    );

    return Padding(
      padding: const EdgeInsets.only(
        right: AppTheme.spacingMd,
        top: AppTheme.spacingSm,
      ),
      child: LineChart(
        LineChartData(
          minY: minValue > 0 ? 0 : minValue - (maxValue - minValue) * 0.1,
          maxY: maxValue + (maxValue - minValue) * 0.1,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: context.colorScheme.primary,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: context.colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: context.isDarkMode
                        ? context.colorScheme.surface
                        : Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: context.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spacingXs),
                    child: Text(
                      data[index].label,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxValue - minValue) / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: context.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${data[spot.x.toInt()].label}\n${spot.y.toStringAsFixed(1)}',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Build insufficient data state for line charts with child-friendly messaging
  Widget _buildInsufficientDataState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rocket_launch,
            size: 48,
            color: context.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Keep learning to see your progress!',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Complete more quizzes to unlock your chart',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build invalid data state with child-friendly messaging
  Widget _buildInvalidDataState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 48,
            color: context.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Your chart is getting ready!',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Take a quiz to start tracking your progress',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Bar chart implementation using fl_chart
  Widget _buildBarChart(BuildContext context) {
    final maxValue =
        data.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

    // Create bar chart groups
    final barGroups = List.generate(
      data.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].value,
            color: data[index].color ?? context.colorScheme.primary,
            width: 20,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusSm),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                data[index].color ?? context.colorScheme.primary,
                (data[index].color ?? context.colorScheme.primary)
                    .withValues(alpha: 0.6),
              ],
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(
        right: AppTheme.spacingMd,
        top: AppTheme.spacingSm,
      ),
      child: BarChart(
        BarChartData(
          maxY: maxValue * 1.2,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spacingXs),
                    child: Text(
                      data[index].label,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: context.colorScheme.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${data[groupIndex].label}\n${rod.toY.toStringAsFixed(1)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Pie chart implementation using fl_chart
  Widget _buildPieChart(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    // Create pie chart sections
    final sections = List.generate(
      data.length,
      (index) {
        final value = data[index].value;
        final percentage = (value / total * 100);
        final color = data[index].color ??
            _getDefaultColor(index, context.colorScheme.primary);

        return PieChartSectionData(
          value: value,
          title: '${percentage.toStringAsFixed(1)}%',
          color: color,
          radius: height * 0.3,
          titleStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: _getContrastColor(color),
          ),
          badgeWidget: null,
        );
      },
    );

    return Row(
      children: [
        // Pie chart visualization
        Expanded(
          flex: 2,
          child: Center(
            child: SizedBox(
              width: height * 0.8,
              height: height * 0.8,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: height * 0.15,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                  ),
                ),
              ),
            ),
          ),
        ),

        // Values list
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              final percentage = (point.value / total * 100).toStringAsFixed(1);
              final color = point.color ??
                  _getDefaultColor(index, context.colorScheme.primary);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingXs,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        point.label,
                        style: context.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Get default color for pie chart sections
  Color _getDefaultColor(int index, Color primary) {
    final colors = [
      primary,
      primary.withValues(alpha: 0.8),
      primary.withValues(alpha: 0.6),
      primary.withValues(alpha: 0.4),
      primary.withValues(alpha: 0.2),
    ];
    return colors[index % colors.length];
  }

  /// Get contrasting color for text on colored background
  Color _getContrastColor(Color background) {
    // Calculate relative luminance using updated Color API
    final r = (background.r * 255.0).round() & 0xff;
    final g = (background.g * 255.0).round() & 0xff;
    final b = (background.b * 255.0).round() & 0xff;
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Build legend
  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacingMd,
      runSpacing: AppTheme.spacingSm,
      children: data.map((point) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: point.color ?? context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              point.label,
              style: context.textTheme.labelSmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Performance chart types
enum PerformanceChartType {
  line,
  bar,
  pie,
}

/// Performance data point for charts
class PerformanceDataPoint {
  final String label;
  final double value;
  final Color? color;
  final DateTime? timestamp; // For time-series data

  const PerformanceDataPoint({
    required this.label,
    required this.value,
    this.color,
    this.timestamp,
  });
}
