/// StudyToolCard widget for Chapter Study Hub
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// A card widget for displaying study tools in the Chapter Study Hub
class StudyToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final Widget? badge;
  final bool isLarge;

  const StudyToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
    this.badge,
    this.isLarge = false,
  });

  bool get isEnabled => onTap != null;

  String _buildSemanticLabel() {
    final buffer = StringBuffer('$title. $subtitle.');
    if (!isEnabled) {
      buffer.write(' Not available.');
    } else {
      buffer.write(' Double tap to open.');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isJunior = SegmentConfig.isCrackTheCode;
    final cardPadding = isJunior ? AppTheme.spacingLg : AppTheme.spacingMd;
    final iconSize = isJunior ? 36.0 : 28.0;
    final titleStyle = isJunior
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.titleSmall;
    final subtitleStyle = isJunior
        ? Theme.of(context).textTheme.bodyMedium
        : Theme.of(context).textTheme.bodySmall;

    final effectiveColor = isEnabled ? color : Colors.grey;

    return Semantics(
      label: _buildSemanticLabel(),
      button: isEnabled,
      enabled: isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Card(
        elevation: isEnabled ? 2 : 0,
        shadowColor: effectiveColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  effectiveColor.withValues(alpha: 0.05),
                  effectiveColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: isLarge ? _buildLargeLayout(
              context,
              iconSize,
              titleStyle,
              subtitleStyle,
            ) : _buildCompactLayout(
              context,
              iconSize,
              titleStyle,
              subtitleStyle,
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCompactLayout(
    BuildContext context,
    double iconSize,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildIconContainer(context, iconSize),
            if (badge != null) ...[
              const Spacer(),
              Flexible(child: badge!),
            ],
          ],
        ),
        const SizedBox(height: AppTheme.spacingXs),
        Flexible(
          child: Text(
            title,
            style: titleStyle?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        Flexible(
          child: Text(
            subtitle,
            style: subtitleStyle?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeLayout(
    BuildContext context,
    double iconSize,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  ) {
    return Row(
      children: [
        _buildIconContainer(context, iconSize * 1.2),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: titleStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: subtitleStyle?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: AppTheme.spacingSm),
          badge!,
        ],
        Icon(
          Icons.chevron_right,
          color: color,
        ),
      ],
    );
  }

  Widget _buildIconContainer(BuildContext context, double iconSize) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: color,
      ),
    );
  }
}

/// Badge widget for showing due items count
class DueBadge extends StatelessWidget {
  final int count;

  const DueBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count due',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Badge widget for showing mastered count
class MasteredBadge extends StatelessWidget {
  final int mastered;
  final int total;

  const MasteredBadge({
    super.key,
    required this.mastered,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();

    final percentage = (mastered / total * 100).round();
    final color = percentage >= 80
        ? Colors.green
        : percentage >= 50
            ? Colors.orange
            : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$percentage%',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Badge widget for showing personal notes count
class PersonalBadge extends StatelessWidget {
  final int count;

  const PersonalBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
