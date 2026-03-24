/// Horizontal filter chips bar for quiz history filtering
library;

import 'package:flutter/material.dart';
import 'package:streamshaala/core/models/assessment_type.dart';

/// Callback for assessment type filter changes
typedef AssessmentTypeFilterCallback = void Function(AssessmentType?);

/// Callback for recommendations filter changes
typedef RecommendationsFilterCallback = void Function(bool);

/// Horizontal scrollable filter chips for quiz history
class FilterChipsBar extends StatelessWidget {
  final AssessmentType? selectedType;
  final bool showOnlyWithRecommendations;
  final AssessmentTypeFilterCallback onTypeChanged;
  final RecommendationsFilterCallback onRecommendationsFilterChanged;
  final VoidCallback? onAdvancedFilters;

  const FilterChipsBar({
    super.key,
    this.selectedType,
    required this.showOnlyWithRecommendations,
    required this.onTypeChanged,
    required this.onRecommendationsFilterChanged,
    this.onAdvancedFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // All quizzes chip
          _FilterChip(
            label: 'All',
            icon: Icons.apps,
            isSelected: selectedType == null && !showOnlyWithRecommendations,
            onTap: () {
              onTypeChanged(null);
              onRecommendationsFilterChanged(false);
            },
            color: theme.colorScheme.primary,
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Readiness Check filter
          _FilterChip(
            label: 'Readiness',
            icon: AssessmentType.readiness.icon,
            isSelected: selectedType == AssessmentType.readiness,
            onTap: () => onTypeChanged(AssessmentType.readiness),
            color: AssessmentType.readiness.primaryColor,
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Knowledge Check filter
          _FilterChip(
            label: 'Knowledge',
            icon: AssessmentType.knowledge.icon,
            isSelected: selectedType == AssessmentType.knowledge,
            onTap: () => onTypeChanged(AssessmentType.knowledge),
            color: AssessmentType.knowledge.primaryColor,
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Practice Quiz filter
          _FilterChip(
            label: 'Practice',
            icon: AssessmentType.practice.icon,
            isSelected: selectedType == AssessmentType.practice,
            onTap: () => onTypeChanged(AssessmentType.practice),
            color: AssessmentType.practice.primaryColor,
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Divider
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: theme.dividerColor,
          ),
          const SizedBox(width: 8),

          // With Recommendations filter
          _FilterChip(
            label: 'Has Learning Path',
            icon: Icons.lightbulb_outline,
            isSelected: showOnlyWithRecommendations,
            onTap: () =>
                onRecommendationsFilterChanged(!showOnlyWithRecommendations),
            color: Colors.amber[700]!,
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Advanced filters button (if provided)
          if (onAdvancedFilters != null) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAdvancedFilters,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.dividerColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tune,
                        size: 16,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (isDark ? color.withValues(alpha: 0.3) : color.withValues(alpha: 0.15))
        : Colors.transparent;

    final borderColor = isSelected
        ? color
        : Theme.of(context).dividerColor;

    final textColor = isSelected
        ? color
        : Theme.of(context).textTheme.bodyMedium?.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: textColor,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact filter summary badge (shows active filter count)
class ActiveFiltersIndicator extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onTap;

  const ActiveFiltersIndicator({
    super.key,
    required this.activeFilterCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (activeFilterCount == 0) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              '$activeFilterCount filter${activeFilterCount > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
