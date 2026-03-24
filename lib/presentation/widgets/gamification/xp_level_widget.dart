import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/presentation/providers/gamification/gamification_provider.dart';

/// XP and Level display widget
/// Uses derived xpLevelDataProvider to only rebuild when XP/level data changes
class XpLevelWidget extends ConsumerWidget {
  final bool showDetails;
  final bool compact;

  const XpLevelWidget({
    super.key,
    this.showDetails = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use derived provider for focused rebuilds
    final xpData = ref.watch(xpLevelDataProvider);

    if (compact) {
      return _buildCompact(context, xpData);
    }

    return _buildFull(context, xpData);
  }

  Widget _buildCompact(BuildContext context, XpLevelData xpData) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLevelBadge(context, xpData.level),
          SizedBox(width: AppTheme.spacingXs),
          Text(
            '${xpData.totalXp} XP',
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context, XpLevelData xpData) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildLevelBadge(context, xpData.level, size: 48),
                SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level ${xpData.level}',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        xpData.levelTitle,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${xpData.totalXp}',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Total XP',
                      style: context.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            if (showDetails) ...[
              SizedBox(height: AppTheme.spacingMd),
              _buildProgressBar(context, xpData),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context, int level, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getLevelColors(level),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getLevelColors(level).first.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$level',
          style: TextStyle(
            color: AppTheme.lightOnPrimary,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, XpLevelData xpData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${xpData.xpProgress} XP',
              style: context.textTheme.labelSmall,
            ),
            Text(
              '${xpData.xpForNextLevel} XP for Level ${xpData.level + 1}',
              style: context.textTheme.labelSmall,
            ),
          ],
        ),
        SizedBox(height: AppTheme.spacingXs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          child: LinearProgressIndicator(
            value: xpData.levelProgress,
            minHeight: 8,
            backgroundColor: context.colorScheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getLevelColors(xpData.level).first,
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getLevelColors(int level) {
    return AppTheme.getXPLevelGradient(level);
  }
}

/// XP award animation widget
class XpAwardAnimation extends StatefulWidget {
  final int xpAmount;
  final VoidCallback onComplete;

  const XpAwardAnimation({
    super.key,
    required this.xpAmount,
    required this.onComplete,
  });

  @override
  State<XpAwardAnimation> createState() => _XpAwardAnimationState();
}

class _XpAwardAnimationState extends State<XpAwardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.2),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 20,
      ),
    ]).animate(_controller);

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 20,
      ),
    ]).animate(_controller);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.xpGold,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.xpGold.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppTheme.lightOnPrimary),
                    const SizedBox(width: AppTheme.spacingXs),
                    Text(
                      '+${widget.xpAmount} XP',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
