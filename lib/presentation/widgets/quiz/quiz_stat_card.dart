import 'package:flutter/material.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// QuizStatCard - Statistics overview card widget
///
/// Displays a single statistic with:
/// - Icon
/// - Value (with optional animation)
/// - Label
/// - Optional subtitle
/// - Optional trend indicator
class QuizStatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? subtitle;
  final Color? color;
  final Color? backgroundColor;
  final bool animateValue;
  final double? trend; // Positive = up, negative = down, null = no trend
  final VoidCallback? onTap;

  const QuizStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.subtitle,
    this.color,
    this.backgroundColor,
    this.animateValue = false,
    this.trend,
    this.onTap,
  });

  @override
  State<QuizStatCard> createState() => _QuizStatCardState();
}

class _QuizStatCardState extends State<QuizStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.animationNormal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    if (widget.animateValue) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? context.colorScheme.primary;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? effectiveColor.withValues(alpha: 0.1);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  effectiveBackgroundColor,
                  effectiveBackgroundColor.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and trend indicator
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: effectiveColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Icon(
                        widget.icon,
                        color: effectiveColor,
                        size: 18,
                        semanticLabel: widget.label,
                      ),
                    ),
                    const Spacer(),
                    if (widget.trend != null) _buildTrendIndicator(context),
                  ],
                ),

                // Use Flexible wrapper for text content to prevent overflow
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),

                      // Value
                      Text(
                        widget.value,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: effectiveColor,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      // Label
                      Text(
                        widget.label,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Subtitle (optional)
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          widget.subtitle!,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build trend indicator (up/down arrow with percentage)
  Widget _buildTrendIndicator(BuildContext context) {
    if (widget.trend == null) return const SizedBox.shrink();

    final isPositive = widget.trend! >= 0;
    final trendColor = isPositive ? AppTheme.successColor : AppTheme.errorColor;
    final trendIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trendIcon,
            size: 16,
            color: trendColor,
          ),
          const SizedBox(width: 2),
          Text(
            '${widget.trend!.abs().toStringAsFixed(0)}%',
            style: context.textTheme.labelSmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// QuizStatCardCompact - Compact version for smaller spaces
class QuizStatCardCompact extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  const QuizStatCardCompact({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: effectiveColor,
            size: 32,
            semanticLabel: label,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
                ),
                Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
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

/// QuizStatCardGrid - Grid wrapper for multiple stat cards
class QuizStatCardGrid extends StatelessWidget {
  final List<QuizStatCard> cards;
  final int crossAxisCount;
  final double spacing;

  const QuizStatCardGrid({
    super.key,
    required this.cards,
    this.crossAxisCount = 2,
    this.spacing = AppTheme.spacingMd,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.2, // Reduced from 1.4 to provide more height and fix overflow
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }
}
