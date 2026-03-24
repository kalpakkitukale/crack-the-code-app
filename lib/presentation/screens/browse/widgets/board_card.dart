import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Board card widget to display educational board information
class BoardCard extends StatelessWidget {
  final String name;
  final String fullName;
  final IconData icon;
  final Color color;
  final int studentCount;
  final String classRange;
  final VoidCallback? onTap;

  const BoardCard({
    super.key,
    required this.name,
    required this.fullName,
    required this.icon,
    required this.color,
    required this.studentCount,
    required this.classRange,
    this.onTap,
  });

  String _buildSemanticLabel() {
    final buffer = StringBuffer('$name. $fullName.');
    buffer.write(' Classes: $classRange.');
    buffer.write(' Double tap to select this board.');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: _buildSemanticLabel(),
      button: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingSm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Board icon
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Board name
              Flexible(
                child: Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),

              // Full name
              Flexible(
                child: Text(
                  fullName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),

              // Class range
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    classRange,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  String _formatStudentCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K+ Students';
    }
    return '$count Students';
  }
}
