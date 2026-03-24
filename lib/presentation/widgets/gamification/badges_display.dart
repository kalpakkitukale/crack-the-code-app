// Badges Display Widget
// Shows badges in a grid format for Junior segment

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/accessibility/accessibility_utils.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/domain/entities/gamification/badge.dart';
import 'package:streamshaala/presentation/providers/gamification/gamification_provider.dart';

/// Badges Grid Display
/// Shows all badges with unlocked/locked states
class BadgesGridDisplay extends ConsumerWidget {
  final int columns;
  final bool showLocked;
  final bool compactMode;

  const BadgesGridDisplay({
    super.key,
    this.columns = 3,
    this.showLocked = true,
    this.compactMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamificationState = ref.watch(gamificationProvider);
    final allBadges = gamificationState.allBadges;
    final unlockedBadges = gamificationState.unlockedBadges;
    final unlockedIds = unlockedBadges.map((b) => b.id).toSet();

    if (allBadges.isEmpty) {
      return const _EmptyBadgesState();
    }

    // Filter badges if not showing locked
    final displayBadges = showLocked
        ? allBadges
        : allBadges.where((b) => unlockedIds.contains(b.id)).toList();

    if (displayBadges.isEmpty) {
      return const _NoBadgesUnlockedState();
    }

    final settings = SegmentConfig.settings;
    final spacing = compactMode ? 8.0 : 12.0 * settings.touchTargetScale;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: compactMode ? 1.0 : 0.85,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: displayBadges.length,
      itemBuilder: (context, index) {
        final badge = displayBadges[index];
        final isUnlocked = unlockedIds.contains(badge.id);

        return BadgeCard(
          badge: badge,
          isUnlocked: isUnlocked,
          compactMode: compactMode,
          onTap: () => _showBadgeDetails(context, badge, isUnlocked),
        );
      },
    );
  }

  void _showBadgeDetails(BuildContext context, Badge badge, bool isUnlocked) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BadgeDetailsSheet(
        badge: badge,
        isUnlocked: isUnlocked,
      ),
    );
  }
}

/// Individual Badge Card
class BadgeCard extends StatelessWidget {
  final Badge badge;
  final bool isUnlocked;
  final bool compactMode;
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.isUnlocked,
    this.compactMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;

    // Build accessible label for screen readers
    final statusLabel = isUnlocked
        ? A11yLabels.badgeUnlocked
        : A11yLabels.badgeLocked;
    final semanticLabel = '${badge.name} badge. $statusLabel. ${badge.description}';

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnlocked
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(settings.cardBorderRadius),
          border: Border.all(
            color: isUnlocked
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: compactMode ? 40 : 56,
                  height: compactMode ? 40 : 56,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? _getBadgeColor(badge.category)
                        : Colors.grey.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getBadgeIcon(badge.category),
                    color: isUnlocked ? Colors.white : Colors.grey,
                    size: compactMode ? 24 : 32,
                  ),
                ),
                // Lock overlay for locked badges
                if (!isUnlocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock,
                        size: compactMode ? 12 : 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),

            if (!compactMode) ...[
              const SizedBox(height: 8),

              // Badge name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  badge.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }

  Color _getBadgeColor(BadgeCategory category) {
    switch (category) {
      case BadgeCategory.streak:
        return Colors.orange;
      case BadgeCategory.learning:
        return Colors.blue;
      case BadgeCategory.mastery:
        return Colors.purple;
      case BadgeCategory.special:
        return Colors.amber;
    }
  }

  IconData _getBadgeIcon(BadgeCategory category) {
    switch (category) {
      case BadgeCategory.streak:
        return Icons.local_fire_department;
      case BadgeCategory.learning:
        return Icons.school;
      case BadgeCategory.mastery:
        return Icons.emoji_events;
      case BadgeCategory.special:
        return Icons.star;
    }
  }
}

/// Badge Details Bottom Sheet
class BadgeDetailsSheet extends StatelessWidget {
  final Badge badge;
  final bool isUnlocked;

  const BadgeDetailsSheet({
    super.key,
    required this.badge,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(settings.cardBorderRadius * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Badge icon with glow
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: isUnlocked
                  ? LinearGradient(
                      colors: [
                        _getBadgeColor(badge.category).withValues(alpha: 0.8),
                        _getBadgeColor(badge.category),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isUnlocked ? null : Colors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: _getBadgeColor(badge.category).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _getBadgeIcon(badge.category),
              color: isUnlocked ? Colors.white : Colors.grey,
              size: 50,
            ),
          ),
          const SizedBox(height: 20),

          // Badge name
          Text(
            badge.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? _getBadgeColor(badge.category)
                  : theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isUnlocked ? 'Unlocked!' : 'Locked',
              style: TextStyle(
                color: isUnlocked ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            badge.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          // Condition hint (if locked)
          if (!isUnlocked) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'How to unlock: ${_getConditionHint(badge.condition)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // XP bonus
          if (badge.xpBonus > 0) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+${badge.xpBonus} XP',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // Close button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isUnlocked ? 'Awesome!' : 'Got it'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _getConditionHint(BadgeCondition condition) {
    return switch (condition) {
      VideosWatchedCondition(:final count) => 'Watch $count videos',
      QuizzesPassedCondition(:final count) => 'Pass $count quizzes',
      PerfectScoresCondition(:final count) => 'Get $count perfect scores',
      StreakDaysCondition(:final days) => 'Maintain a $days day streak',
      ConceptsMasteredCondition(:final count) => 'Master $count concepts',
      GapsFixedCondition(:final count) => 'Fix $count learning gaps',
      ReviewsCompletedCondition(:final count) => 'Complete $count reviews',
      PathsCompletedCondition(:final count) => 'Complete $count learning paths',
      SubjectMasteredCondition(:final count) => 'Master $count subjects',
      ConsecutiveCheckpointsCondition(:final count) => 'Complete $count checkpoints in a row',
      EarlyMorningCondition(:final count) => 'Study before 7 AM $count times',
      LateNightCondition(:final count) => 'Study after 10 PM $count times',
    };
  }

  Color _getBadgeColor(BadgeCategory category) {
    switch (category) {
      case BadgeCategory.streak:
        return Colors.orange;
      case BadgeCategory.learning:
        return Colors.blue;
      case BadgeCategory.mastery:
        return Colors.purple;
      case BadgeCategory.special:
        return Colors.amber;
    }
  }

  IconData _getBadgeIcon(BadgeCategory category) {
    switch (category) {
      case BadgeCategory.streak:
        return Icons.local_fire_department;
      case BadgeCategory.learning:
        return Icons.school;
      case BadgeCategory.mastery:
        return Icons.emoji_events;
      case BadgeCategory.special:
        return Icons.star;
    }
  }
}

/// Empty state when no badges are defined
class _EmptyBadgesState extends StatelessWidget {
  const _EmptyBadgesState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.military_tech_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'Badges coming soon!',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state when no badges are unlocked
class _NoBadgesUnlockedState extends StatelessWidget {
  const _NoBadgesUnlockedState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No badges yet!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep learning to earn your first badge!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact badges row for home screen
class BadgesRow extends ConsumerWidget {
  final int maxBadges;

  const BadgesRow({
    super.key,
    this.maxBadges = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamificationState = ref.watch(gamificationProvider);
    final unlockedBadges = gamificationState.unlockedBadges;

    if (unlockedBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayBadges = unlockedBadges.take(maxBadges).toList();
    final remaining = unlockedBadges.length - maxBadges;

    return SizedBox(
      height: 56,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...displayBadges.map((badge) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BadgeCard(
                  badge: badge,
                  isUnlocked: true,
                  compactMode: true,
                ),
              )),
          if (remaining > 0)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '+$remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
