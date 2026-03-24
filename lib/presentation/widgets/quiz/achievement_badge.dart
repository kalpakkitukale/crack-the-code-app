import 'package:flutter/material.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// AchievementBadge - Achievement badge widget
///
/// Displays an achievement/milestone badge with:
/// - Icon
/// - Title
/// - Description
/// - Locked/unlocked state
/// - Progress indicator (optional)
/// - Earned date (for unlocked badges)
class AchievementBadge extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double? progress; // 0.0 to 1.0, null = no progress bar
  final Color? color;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.unlockedAt,
    this.progress,
    this.color,
    this.onTap,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.isUnlocked) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppTheme.primaryBlue;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isUnlocked ? _scaleAnimation.value : 1.0,
          child: Transform.rotate(
            angle: widget.isUnlocked ? _rotationAnimation.value : 0.0,
            child: Card(
              clipBehavior: Clip.antiAlias,
              color: widget.isUnlocked
                  ? null
                  : context.colorScheme.surfaceContainerHighest,
              child: InkWell(
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge icon
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle with glow effect
                          if (widget.isUnlocked)
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: effectiveColor.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),

                          // Icon container
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: widget.isUnlocked
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        effectiveColor,
                                        effectiveColor.withValues(alpha: 0.7),
                                      ],
                                    )
                                  : null,
                              color: widget.isUnlocked
                                  ? null
                                  : context.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.2),
                              border: Border.all(
                                color: widget.isUnlocked
                                    ? effectiveColor.withValues(alpha: 0.3)
                                    : context.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                width: 3,
                              ),
                            ),
                            child: Icon(
                              widget.icon,
                              size: 30,
                              color: widget.isUnlocked
                                  ? AppTheme.lightOnPrimary
                                  : context.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.4),
                              semanticLabel: widget.title,
                            ),
                          ),

                          // Lock icon overlay for locked badges
                          if (!widget.isUnlocked)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colorScheme.outline,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingSm),

                      // Title
                      Text(
                        widget.title,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.isUnlocked
                              ? effectiveColor
                              : context.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Description
                      Text(
                        widget.description,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: widget.isUnlocked
                              ? context.colorScheme.onSurfaceVariant
                              : context.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Progress bar (for locked badges with progress)
                      if (!widget.isUnlocked && widget.progress != null) ...[
                        const SizedBox(height: AppTheme.spacingSm),
                        Column(
                          children: [
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusRound,
                              ),
                              child: LinearProgressIndicator(
                                value: widget.progress,
                                minHeight: 6,
                                backgroundColor: context.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  effectiveColor.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Progress text
                            Text(
                              '${(widget.progress! * 100).toInt()}% complete',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Unlocked date (for unlocked badges)
                      if (widget.isUnlocked && widget.unlockedAt != null) ...[
                        const SizedBox(height: AppTheme.spacingSm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                            vertical: AppTheme.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: effectiveColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusRound,
                            ),
                          ),
                          child: Text(
                            _formatDate(widget.unlockedAt!),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: effectiveColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Format date for display
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Earned today';
    } else if (difference.inDays == 1) {
      return 'Earned yesterday';
    } else if (difference.inDays < 7) {
      return 'Earned ${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return 'Earned ${(difference.inDays / 7).floor()}w ago';
    } else {
      return 'Earned ${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// AchievementBadgeCompact - Compact badge for list views
class AchievementBadgeCompact extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isUnlocked;
  final Color? color;

  const AchievementBadgeCompact({
    super.key,
    required this.title,
    required this.icon,
    required this.isUnlocked,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.primaryBlue;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: isUnlocked
            ? effectiveColor.withValues(alpha: 0.1)
            : context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isUnlocked
              ? effectiveColor.withValues(alpha: 0.3)
              : context.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? effectiveColor.withValues(alpha: 0.2)
                  : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: isUnlocked
                  ? effectiveColor
                  : context.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // Title
          Text(
            title,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? effectiveColor
                  : context.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
            ),
          ),

          // Lock icon
          if (!isUnlocked) ...[
            const SizedBox(width: AppTheme.spacingXs),
            Icon(
              Icons.lock,
              size: 14,
              color:
                  context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ],
        ],
      ),
    );
  }
}

/// Predefined achievement types
enum AchievementType {
  firstQuiz,
  perfectScore,
  sevenDayStreak,
  hundredQuizzes,
  subjectMaster,
  speedster,
  persistent,
  topScorer,
}

/// AchievementData - Helper class for predefined achievements
class AchievementData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const AchievementData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  static AchievementData get(AchievementType type) {
    switch (type) {
      case AchievementType.firstQuiz:
        return const AchievementData(
          title: 'First Steps',
          description: 'Complete your first quiz',
          icon: Icons.flag,
          color: AppTheme.primaryBlue,
        );
      case AchievementType.perfectScore:
        return const AchievementData(
          title: 'Perfect Score',
          description: 'Score 100% on a quiz',
          icon: Icons.emoji_events,
          color: AppTheme.achievementGold,
        );
      case AchievementType.sevenDayStreak:
        return const AchievementData(
          title: '7-Day Streak',
          description: 'Complete quizzes for 7 consecutive days',
          icon: Icons.local_fire_department,
          color: AppTheme.performanceNeedsImprovement,
        );
      case AchievementType.hundredQuizzes:
        return const AchievementData(
          title: 'Century',
          description: 'Complete 100 quizzes',
          icon: Icons.celebration,
          color: AppTheme.statusInProgressIcon,
        );
      case AchievementType.subjectMaster:
        return const AchievementData(
          title: 'Subject Master',
          description: 'Achieve 90%+ average in a subject',
          icon: Icons.school,
          color: AppTheme.successColor,
        );
      case AchievementType.speedster:
        return const AchievementData(
          title: 'Speedster',
          description: 'Complete a quiz in record time',
          icon: Icons.speed,
          color: AppTheme.accentColor,
        );
      case AchievementType.persistent:
        return const AchievementData(
          title: 'Persistent',
          description: 'Retry and pass a failed quiz',
          icon: Icons.refresh,
          color: AppTheme.warningColor,
        );
      case AchievementType.topScorer:
        return const AchievementData(
          title: 'Top Scorer',
          description: 'Score in top 10% of class',
          icon: Icons.workspace_premium,
          color: AppTheme.errorColor,
        );
    }
  }
}
