import 'package:flutter/material.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/utils/semantic_colors.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';

/// QuizFilterChips - Filter chip row widget
///
/// Displays filterable chips for quiz history with:
/// - Subject filter
/// - Quiz level filter
/// - Date range filter
/// - Performance filter
/// - Clear all filters button
class QuizFilterChips extends StatelessWidget {
  final Set<String> selectedSubjects;
  final Set<QuizLevel> selectedLevels;
  final DateRangeFilter selectedDateRange;
  final PerformanceFilter selectedPerformance;
  final List<String> availableSubjects;
  final Function(String) onSubjectToggle;
  final Function(QuizLevel) onLevelToggle;
  final Function(DateRangeFilter) onDateRangeChanged;
  final Function(PerformanceFilter) onPerformanceChanged;
  final VoidCallback onClearAll;

  const QuizFilterChips({
    super.key,
    required this.selectedSubjects,
    required this.selectedLevels,
    required this.selectedDateRange,
    required this.selectedPerformance,
    required this.availableSubjects,
    required this.onSubjectToggle,
    required this.onLevelToggle,
    required this.onDateRangeChanged,
    required this.onPerformanceChanged,
    required this.onClearAll,
  });

  bool get hasActiveFilters =>
      selectedSubjects.isNotEmpty ||
      selectedLevels.isNotEmpty ||
      selectedDateRange != DateRangeFilter.all ||
      selectedPerformance != PerformanceFilter.all;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with clear button
        Row(
          children: [
            Icon(
              Icons.filter_list,
              size: 20,
              color: context.colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              'Filters',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (hasActiveFilters)
              TextButton.icon(
                onPressed: onClearAll,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),

        const SizedBox(height: AppTheme.spacingSm),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Subject filter
              _buildSubjectFilter(context),
              const SizedBox(width: AppTheme.spacingSm),

              // Level filter
              _buildLevelFilter(context),
              const SizedBox(width: AppTheme.spacingSm),

              // Date range filter
              _buildDateRangeFilter(context),
              const SizedBox(width: AppTheme.spacingSm),

              // Performance filter
              _buildPerformanceFilter(context),
            ],
          ),
        ),

        // Active filters summary
        if (hasActiveFilters) ...[
          const SizedBox(height: AppTheme.spacingMd),
          _buildActiveFiltersSummary(context),
        ],
      ],
    );
  }

  /// Build subject filter chips
  Widget _buildSubjectFilter(BuildContext context) {
    return _FilterChipDropdown(
      label: 'Subject',
      icon: Icons.subject,
      selectedCount: selectedSubjects.length,
      color: AppTheme.primaryBlue,
      items: availableSubjects,
      selectedItems: selectedSubjects,
      onToggle: onSubjectToggle,
      getItemLabel: (subject) => subject,
      getItemColor: _getSubjectColor,
    );
  }

  /// Build level filter chips
  Widget _buildLevelFilter(BuildContext context) {
    return _FilterChipDropdown<QuizLevel>(
      label: 'Level',
      icon: Icons.layers,
      selectedCount: selectedLevels.length,
      color: AppTheme.primaryGreen,
      items: QuizLevel.values,
      selectedItems: selectedLevels,
      onToggle: onLevelToggle,
      getItemLabel: _getLevelLabel,
    );
  }

  /// Build date range filter
  Widget _buildDateRangeFilter(BuildContext context) {
    return PopupMenuButton<DateRangeFilter>(
      onSelected: onDateRangeChanged,
      itemBuilder: (context) => DateRangeFilter.values.map((range) {
        return PopupMenuItem(
          value: range,
          child: Row(
            children: [
              if (selectedDateRange == range)
                Icon(
                  Icons.check,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
              if (selectedDateRange != range) const SizedBox(width: 18),
              const SizedBox(width: AppTheme.spacingXs),
              Text(_getDateRangeLabel(range)),
            ],
          ),
        );
      }).toList(),
      child: Chip(
        avatar: Icon(
          Icons.calendar_today,
          size: 18,
          color: selectedDateRange != DateRangeFilter.all
              ? AppTheme.warningColor
              : context.colorScheme.onSurfaceVariant,
        ),
        label: Text(_getDateRangeLabel(selectedDateRange)),
        deleteIcon: selectedDateRange != DateRangeFilter.all
            ? const Icon(Icons.close, size: 18)
            : null,
        onDeleted: selectedDateRange != DateRangeFilter.all
            ? () => onDateRangeChanged(DateRangeFilter.all)
            : null,
        backgroundColor: selectedDateRange != DateRangeFilter.all
            ? AppTheme.warningColor.withValues(alpha: 0.1)
            : null,
        side: BorderSide(
          color: selectedDateRange != DateRangeFilter.all
              ? AppTheme.warningColor.withValues(alpha: 0.3)
              : context.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  /// Build performance filter
  Widget _buildPerformanceFilter(BuildContext context) {
    return PopupMenuButton<PerformanceFilter>(
      onSelected: onPerformanceChanged,
      itemBuilder: (context) => PerformanceFilter.values.map((performance) {
        return PopupMenuItem(
          value: performance,
          child: Row(
            children: [
              if (selectedPerformance == performance)
                Icon(
                  Icons.check,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
              if (selectedPerformance != performance) const SizedBox(width: 18),
              const SizedBox(width: AppTheme.spacingXs),
              Text(_getPerformanceLabel(performance)),
            ],
          ),
        );
      }).toList(),
      child: Chip(
        avatar: Icon(
          Icons.analytics,
          size: 18,
          color: selectedPerformance != PerformanceFilter.all
              ? AppTheme.successColor
              : context.colorScheme.onSurfaceVariant,
        ),
        label: Text(_getPerformanceLabel(selectedPerformance)),
        deleteIcon: selectedPerformance != PerformanceFilter.all
            ? const Icon(Icons.close, size: 18)
            : null,
        onDeleted: selectedPerformance != PerformanceFilter.all
            ? () => onPerformanceChanged(PerformanceFilter.all)
            : null,
        backgroundColor: selectedPerformance != PerformanceFilter.all
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : null,
        side: BorderSide(
          color: selectedPerformance != PerformanceFilter.all
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : context.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  /// Build active filters summary
  Widget _buildActiveFiltersSummary(BuildContext context) {
    final filters = <String>[];

    if (selectedSubjects.isNotEmpty) {
      filters.add('${selectedSubjects.length} ${selectedSubjects.length == 1 ? 'subject' : 'subjects'}');
    }
    if (selectedLevels.isNotEmpty) {
      filters.add('${selectedLevels.length} ${selectedLevels.length == 1 ? 'level' : 'levels'}');
    }
    if (selectedDateRange != DateRangeFilter.all) {
      filters.add(_getDateRangeLabel(selectedDateRange));
    }
    if (selectedPerformance != PerformanceFilter.all) {
      filters.add(_getPerformanceLabel(selectedPerformance));
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Expanded(
            child: Text(
              'Showing results for: ${filters.join(', ')}',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get subject color
  Color _getSubjectColor(String subject) {
    return SemanticColors.getSubjectColor(subject);
  }

  /// Get level label
  String _getLevelLabel(QuizLevel level) {
    switch (level) {
      case QuizLevel.video:
        return 'Video Quiz';
      case QuizLevel.topic:
        return 'Topic Quiz';
      case QuizLevel.chapter:
        return 'Chapter Quiz';
      case QuizLevel.subject:
        return 'Subject Quiz';
    }
  }

  /// Get date range label
  String _getDateRangeLabel(DateRangeFilter range) {
    switch (range) {
      case DateRangeFilter.all:
        return 'All Time';
      case DateRangeFilter.today:
        return 'Today';
      case DateRangeFilter.thisWeek:
        return 'This Week';
      case DateRangeFilter.thisMonth:
        return 'This Month';
    }
  }

  /// Get performance label
  String _getPerformanceLabel(PerformanceFilter performance) {
    switch (performance) {
      case PerformanceFilter.all:
        return 'All';
      case PerformanceFilter.passed:
        return 'Passed (>60%)';
      case PerformanceFilter.failed:
        return 'Failed (<60%)';
    }
  }
}

/// Filter chip dropdown widget
class _FilterChipDropdown<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final int selectedCount;
  final Color color;
  final List<T> items;
  final Set<T> selectedItems;
  final Function(T) onToggle;
  final String Function(T) getItemLabel;
  final Color Function(T)? getItemColor;

  const _FilterChipDropdown({
    required this.label,
    required this.icon,
    required this.selectedCount,
    required this.color,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    required this.getItemLabel,
    this.getItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onToggle,
      itemBuilder: (context) => items.map((item) {
        final isSelected = selectedItems.contains(item);
        final itemColor = getItemColor?.call(item);

        return PopupMenuItem(
          value: item,
          child: Row(
            children: [
              if (isSelected)
                Icon(Icons.check, size: 18, color: itemColor ?? color),
              if (!isSelected) const SizedBox(width: 18),
              const SizedBox(width: AppTheme.spacingXs),
              if (itemColor != null) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: itemColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingXs),
              ],
              Expanded(child: Text(getItemLabel(item))),
            ],
          ),
        );
      }).toList(),
      child: Chip(
        avatar: Icon(
          icon,
          size: 18,
          color: selectedCount > 0 ? color : context.colorScheme.onSurfaceVariant,
        ),
        label: Text(
          selectedCount > 0 ? '$label ($selectedCount)' : label,
        ),
        deleteIcon: selectedCount > 0 ? const Icon(Icons.close, size: 18) : null,
        onDeleted: selectedCount > 0
            ? () {
                for (final item in selectedItems.toList()) {
                  onToggle(item);
                }
              }
            : null,
        backgroundColor: selectedCount > 0 ? color.withValues(alpha: 0.1) : null,
        side: BorderSide(
          color: selectedCount > 0
              ? color.withValues(alpha: 0.3)
              : context.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

/// Date range filter enum
enum DateRangeFilter {
  all,
  today,
  thisWeek,
  thisMonth,
}

/// Performance filter enum
enum PerformanceFilter {
  all,
  passed,
  failed,
}
