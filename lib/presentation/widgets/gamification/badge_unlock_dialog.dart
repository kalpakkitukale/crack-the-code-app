import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/gamification/badge.dart' as gamification;

/// Badge unlock celebration dialog
class BadgeUnlockDialog extends StatefulWidget {
  final List<gamification.Badge> badges;
  final VoidCallback onDismiss;

  const BadgeUnlockDialog({
    super.key,
    required this.badges,
    required this.onDismiss,
  });

  @override
  State<BadgeUnlockDialog> createState() => _BadgeUnlockDialogState();
}

class _BadgeUnlockDialogState extends State<BadgeUnlockDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  int _currentBadgeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.2),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _rotationAnimation = Tween<double>(begin: -0.1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNextBadge() {
    if (_currentBadgeIndex < widget.badges.length - 1) {
      setState(() {
        _currentBadgeIndex++;
      });
      _controller.reset();
      _controller.forward();
    } else {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = widget.badges[_currentBadgeIndex];
    final hasMore = _currentBadgeIndex < widget.badges.length - 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: [
            BoxShadow(
              color: _getCategoryColor(badge.category).withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Confetti effect placeholder
            Text(
              'Achievement Unlocked!',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
            SizedBox(height: AppTheme.spacingLg),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: _buildBadgeIcon(context, badge),
                  ),
                );
              },
            ),
            SizedBox(height: AppTheme.spacingMd),
            Text(
              badge.name,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppTheme.spacingSm),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
            if (badge.xpBonus > 0) ...[
              SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: AppTheme.spacingXs),
                    Text(
                      '+${badge.xpBonus} XP Bonus',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: AppTheme.spacingLg),
            if (widget.badges.length > 1)
              Text(
                'Badge ${_currentBadgeIndex + 1} of ${widget.badges.length}',
                style: context.textTheme.labelSmall,
              ),
            SizedBox(height: AppTheme.spacingSm),
            FilledButton(
              onPressed: _showNextBadge,
              child: Text(hasMore ? 'Next Badge' : 'Awesome!'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context, gamification.Badge badge) {
    final color = _getCategoryColor(badge.category);

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.1),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
      child: Center(
        child: Icon(
          _getCategoryIcon(badge.category),
          size: 48,
          color: color,
        ),
      ),
    );
  }

  Color _getCategoryColor(gamification.BadgeCategory category) {
    switch (category) {
      case gamification.BadgeCategory.learning:
        return Colors.blue;
      case gamification.BadgeCategory.streak:
        return Colors.deepOrange;
      case gamification.BadgeCategory.mastery:
        return Colors.purple;
      case gamification.BadgeCategory.special:
        return Colors.amber;
    }
  }

  IconData _getCategoryIcon(gamification.BadgeCategory category) {
    switch (category) {
      case gamification.BadgeCategory.learning:
        return Icons.school;
      case gamification.BadgeCategory.streak:
        return Icons.local_fire_department;
      case gamification.BadgeCategory.mastery:
        return Icons.emoji_events;
      case gamification.BadgeCategory.special:
        return Icons.star;
    }
  }
}

/// Badge card widget for displaying in lists
class BadgeCard extends StatelessWidget {
  final gamification.Badge badge;
  final bool isUnlocked;
  final double? progress;
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.isUnlocked,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(badge.category);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            gradient: isUnlocked
                ? LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBadgeIcon(context),
              SizedBox(height: AppTheme.spacingSm),
              Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                  color: isUnlocked ? null : context.colorScheme.outline,
                ),
              ),
              if (progress != null && !isUnlocked) ...[
                SizedBox(height: AppTheme.spacingXs),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: context.colorScheme.surfaceContainerHigh,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(
                  '${(progress! * 100).toStringAsFixed(0)}%',
                  style: context.textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context) {
    final color = _getCategoryColor(badge.category);

    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isUnlocked
                ? color.withValues(alpha: 0.2)
                : context.colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(
              color: isUnlocked ? color : context.colorScheme.outline,
              width: isUnlocked ? 2 : 1,
            ),
          ),
          child: Center(
            child: isUnlocked
                ? Icon(
                    _getCategoryIcon(badge.category),
                    size: 28,
                    color: color,
                  )
                : Icon(
                    Icons.lock_outline,
                    size: 24,
                    color: context.colorScheme.outline,
                  ),
          ),
        ),
        if (isUnlocked)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Color _getCategoryColor(gamification.BadgeCategory category) {
    switch (category) {
      case gamification.BadgeCategory.learning:
        return Colors.blue;
      case gamification.BadgeCategory.streak:
        return Colors.deepOrange;
      case gamification.BadgeCategory.mastery:
        return Colors.purple;
      case gamification.BadgeCategory.special:
        return Colors.amber;
    }
  }

  IconData _getCategoryIcon(gamification.BadgeCategory category) {
    switch (category) {
      case gamification.BadgeCategory.learning:
        return Icons.school;
      case gamification.BadgeCategory.streak:
        return Icons.local_fire_department;
      case gamification.BadgeCategory.mastery:
        return Icons.emoji_events;
      case gamification.BadgeCategory.special:
        return Icons.star;
    }
  }
}
