import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Breadcrumb navigation item
class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

/// Breadcrumb navigation bar
/// Shows hierarchical navigation path
class BreadcrumbBar extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbBar({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _buildBreadcrumbs(context),
        ),
      ),
    );
  }

  List<Widget> _buildBreadcrumbs(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final widgets = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      // Add breadcrumb item
      widgets.add(
        InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: AppTheme.spacingXs,
            ),
            child: Text(
              item.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isLast
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      );

      // Add separator (except after last item)
      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
