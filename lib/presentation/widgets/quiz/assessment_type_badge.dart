/// Badge widget for displaying quiz assessment type with themed styling
library;

import 'package:flutter/material.dart';
import 'package:streamshaala/core/models/assessment_type.dart';

/// Displays an assessment type badge with color-coded styling
///
/// - Readiness: Purple theme
/// - Knowledge: Teal theme
/// - Practice: Blue theme
class AssessmentTypeBadge extends StatelessWidget {
  final AssessmentType type;
  final bool compact;
  final bool showIcon;

  const AssessmentTypeBadge({
    super.key,
    required this.type,
    this.compact = false,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: isDark ? type.backgroundColorDark : type.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: type.borderColor.withOpacity(isDark ? 0.3 : 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              type.icon,
              size: compact ? 14 : 16,
              color: type.primaryColor,
            ),
            SizedBox(width: compact ? 4 : 6),
          ],
          Text(
            compact ? type.shortLabel : type.displayName,
            style: TextStyle(
              color: type.primaryColor,
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Larger variant of assessment badge with subtitle
class AssessmentTypeBannerBadge extends StatelessWidget {
  final AssessmentType type;

  const AssessmentTypeBannerBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? type.backgroundColorDark : type.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: type.borderColor.withOpacity(isDark ? 0.3 : 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: type.primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type.iconFilled,
              size: 24,
              color: type.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: type.primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  type.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: type.primaryColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
