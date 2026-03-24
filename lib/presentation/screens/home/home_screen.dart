import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/presentation/providers/content/board_provider.dart';
import 'package:streamshaala/presentation/providers/content/subject_provider.dart';
import 'package:streamshaala/presentation/providers/user/user_profile_provider.dart';
import 'package:streamshaala/presentation/screens/home/widgets/welcome_header.dart';
import 'package:streamshaala/presentation/screens/home/widgets/continue_watching_section.dart';
import 'package:streamshaala/presentation/screens/home/widgets/subjects_grid_section.dart';
import 'package:streamshaala/presentation/screens/home/widgets/recent_videos_section.dart';
import 'package:streamshaala/presentation/screens/home/widgets/quick_stats_section.dart';
import 'package:streamshaala/presentation/screens/home/widgets/quiz_quick_access_section.dart';
import 'package:streamshaala/presentation/screens/home/widgets/daily_challenge_card.dart';
import 'package:streamshaala/presentation/screens/home/widgets/study_zone_section.dart';
import 'package:streamshaala/presentation/widgets/home/continue_path_card.dart';
import 'package:streamshaala/presentation/widgets/home/junior_quiz_progress_section.dart';
import 'package:streamshaala/presentation/widgets/home/recommended_quizzes_section.dart';
import 'package:streamshaala/presentation/widgets/parental/screen_time_overlay.dart';
import 'package:streamshaala/presentation/providers/gamification/gamification_provider.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';
import 'package:streamshaala/core/widgets/profile_switcher.dart';
import 'package:streamshaala/presentation/screens/settings/profile_management_screen.dart';
import 'package:streamshaala/presentation/screens/spelling/spelling_home_screen.dart';

/// Home Dashboard Screen
/// Displays welcome header, continue watching, subjects grid, and recent videos
/// Layout adapts based on segment (Junior/Senior)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data only if not already loaded
    Future.microtask(() {
      _loadDataIfNeeded();
    });
  }

  /// Load data only if not already loaded (prevents redundant API calls)
  void _loadDataIfNeeded() {
    final settings = SegmentConfig.settings;

    // Load boards only if not already loaded
    final boardState = ref.read(boardProvider);
    if (boardState.boards.isEmpty && !boardState.isLoading) {
      ref.read(boardProvider.notifier).loadBoards();
    }

    // Load subjects only if not already loaded
    final subjectState = ref.read(subjectProvider);
    if (subjectState.subjects.isEmpty && !subjectState.isLoading) {
      if (SegmentConfig.isJunior) {
        // For Junior, load based on user's selected grade
        final userState = ref.read(userProfileProvider);
        final grade = userState.profile.grade ?? settings.minGrade;
        ref.read(subjectProvider.notifier).loadSubjects(
              boardId: settings.defaultBoardId,
              classId: 'class_$grade',
              streamId: 'general', // Default stream for Junior (no subject streams)
            );
      } else {
        // For Senior, load default (CBSE Class 12 Science)
        ref.read(subjectProvider.notifier).loadSubjects(
              boardId: 'cbse',
              classId: 'class_12',
              streamId: 'science_pcm',
            );
      }
    }

    // Progress provider auto-loads, only refresh if empty
    final progressState = ref.read(progressProvider);
    if (progressState.progressMap.isEmpty && !progressState.isLoading) {
      ref.read(progressProvider.notifier).refresh();
    }

    // Load gamification data for Junior segment only if not loaded
    if (SegmentConfig.isJunior) {
      final gamificationState = ref.read(gamificationProvider);
      if (gamificationState.studentData == null && !gamificationState.isLoading) {
        final studentId = ref.read(effectiveUserIdProvider);
        ref.read(gamificationProvider.notifier).loadGamification(studentId);
        ref.read(gamificationProvider.notifier).updateStreak(studentId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // For spelling segment, show the spelling home screen
    if (SegmentConfig.isSpelling) {
      return const SpellingHomeScreen();
    }

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout();
          case DeviceType.tablet:
            return _buildTabletLayout();
          case DeviceType.desktop:
            return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    final settings = SegmentConfig.settings;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildSliverAppBar(),

              // Content - different for Junior vs Senior
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacingMd * settings.touchTargetScale,
                  AppTheme.spacingMd * settings.touchTargetScale,
                  AppTheme.spacingMd * settings.touchTargetScale,
                  100, // Bottom navigation bar + extra spacing
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    SegmentConfig.isJunior
                        ? _buildJuniorMobileContent()
                        : _buildSeniorMobileContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // DEBUG: Floating action button (only for non-Junior)
      floatingActionButton: !SegmentConfig.isJunior
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/debug/test-recommendations'),
              icon: const Icon(Icons.science),
              label: const Text('Test'),
              backgroundColor: Colors.deepPurple,
              tooltip: 'Test Recommendations System',
            )
          : null,
    );
  }

  /// Junior-specific mobile content layout
  /// Simplified, larger elements, more gamification focus
  List<Widget> _buildJuniorMobileContent() {
    final settings = SegmentConfig.settings;
    final spacing = AppTheme.spacingLg * settings.touchTargetScale;

    return [
      // Welcome Header (larger for Junior)
      const _JuniorWelcomeHeader(),
      SizedBox(height: spacing),

      // Screen Time Indicator (if enabled)
      if (settings.showScreenTimeControls) ...[
        const ScreenTimeIndicator(),
        SizedBox(height: spacing),
      ],

      // Streak & XP Banner (prominent for Junior)
      if (settings.showStreakBanner) ...[
        const _JuniorStreakBanner(),
        SizedBox(height: spacing),
      ],

      // Daily Challenge (playful card)
      if (settings.showDailyChallenge) ...[
        const DailyChallengeCard(),
        SizedBox(height: spacing),
      ],

      // Continue Learning Path
      const ContinuePathCard(),
      SizedBox(height: spacing),

      // Quiz Adventures Section (kid-friendly quiz progress)
      const JuniorQuizProgressSection(),
      SizedBox(height: spacing),

      // Recommended Quizzes (areas needing practice)
      const RecommendedQuizzesSection(),
      SizedBox(height: spacing),

      // Subjects Grid (larger cards)
      const SubjectsGridSection(columns: 2),
      SizedBox(height: spacing),

      // Study Zone (flashcard review)
      const StudyZoneSection(),
      SizedBox(height: spacing),

      // Continue Watching (if any)
      const ContinueWatchingSection(),
    ];
  }

  /// Senior/default mobile content layout
  /// Comprehensive, full-featured
  List<Widget> _buildSeniorMobileContent() {
    return [
      // Welcome Header
      const WelcomeHeader(),
      const SizedBox(height: AppTheme.spacingLg),

      // Quick Stats
      const QuickStatsSection(),
      const SizedBox(height: AppTheme.spacingLg),

      // Continue Learning Path (if active)
      const ContinuePathCard(),
      const SizedBox(height: AppTheme.spacingLg),

      // Daily Challenge
      const DailyChallengeCard(),
      const SizedBox(height: AppTheme.spacingLg),

      // Quiz Quick Access
      const QuizQuickAccessSection(),
      const SizedBox(height: AppTheme.spacingLg),

      // Recommended Quizzes (areas needing practice)
      const RecommendedQuizzesSection(),
      const SizedBox(height: AppTheme.spacingLg),

      // Continue Watching
      const ContinueWatchingSection(),
      const SizedBox(height: AppTheme.spacingLg),

      // Study Zone (flashcard review)
      const StudyZoneSection(),
      const SizedBox(height: AppTheme.spacingLg),

      // Subjects Grid
      const SubjectsGridSection(columns: 2),
      const SizedBox(height: AppTheme.spacingLg),

      // Recent Videos
      const RecentVideosSection(),
    ];
  }

  Widget _buildTabletLayout() {
    final settings = SegmentConfig.settings;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildSliverAppBar(),

              // Content
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacingLg * settings.touchTargetScale,
                  AppTheme.spacingLg * settings.touchTargetScale,
                  AppTheme.spacingLg * settings.touchTargetScale,
                  100,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    SegmentConfig.isJunior
                        ? _buildJuniorTabletContent()
                        : _buildSeniorTabletContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildJuniorTabletContent() {
    final settings = SegmentConfig.settings;
    final spacing = AppTheme.spacingLg * settings.touchTargetScale;

    return [
      const _JuniorWelcomeHeader(),
      SizedBox(height: spacing),

      if (settings.showScreenTimeControls) ...[
        const ScreenTimeIndicator(),
        SizedBox(height: spacing),
      ],

      if (settings.showStreakBanner) ...[
        const _JuniorStreakBanner(),
        SizedBox(height: spacing),
      ],

      if (settings.showDailyChallenge) ...[
        const DailyChallengeCard(),
        SizedBox(height: spacing),
      ],

      const ContinuePathCard(),
      SizedBox(height: spacing),

      // Quiz Adventures Section
      const JuniorQuizProgressSection(),
      SizedBox(height: spacing),

      // Recommended Quizzes (areas needing practice)
      const RecommendedQuizzesSection(),
      SizedBox(height: spacing),

      const SubjectsGridSection(columns: 3),
      SizedBox(height: spacing),

      // Study Zone (flashcard review)
      const StudyZoneSection(),
      SizedBox(height: spacing),

      const ContinueWatchingSection(),
    ];
  }

  List<Widget> _buildSeniorTabletContent() {
    return [
      const WelcomeHeader(),
      const SizedBox(height: AppTheme.spacingLg),
      const QuickStatsSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const ContinuePathCard(),
      const SizedBox(height: AppTheme.spacingLg),
      const DailyChallengeCard(),
      const SizedBox(height: AppTheme.spacingLg),
      const QuizQuickAccessSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const RecommendedQuizzesSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const ContinueWatchingSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const StudyZoneSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const SubjectsGridSection(columns: 3),
      const SizedBox(height: AppTheme.spacingLg),
      const RecentVideosSection(),
    ];
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildSliverAppBar(),

              // Content with max width constraint
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXl,
                  vertical: AppTheme.spacingLg,
                ),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: SegmentConfig.isJunior
                            ? _buildJuniorDesktopContent()
                            : _buildSeniorDesktopContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildJuniorDesktopContent() {
    final settings = SegmentConfig.settings;
    final spacing = AppTheme.spacingLg * settings.touchTargetScale;

    return [
      const _JuniorWelcomeHeader(),
      SizedBox(height: spacing),

      if (settings.showStreakBanner) ...[
        const _JuniorStreakBanner(),
        SizedBox(height: spacing),
      ],

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                if (settings.showDailyChallenge) const DailyChallengeCard(),
                SizedBox(height: spacing),
                const ContinuePathCard(),
                SizedBox(height: spacing),
                // Quiz Adventures Section
                const JuniorQuizProgressSection(),
                SizedBox(height: spacing),
                // Recommended Quizzes (areas needing practice)
                const RecommendedQuizzesSection(),
                SizedBox(height: spacing),
                const ContinueWatchingSection(),
              ],
            ),
          ),
          SizedBox(width: spacing),
          const Expanded(
            flex: 4,
            child: SubjectsGridSection(columns: 2),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSeniorDesktopContent() {
    return [
      const WelcomeHeader(),
      const SizedBox(height: AppTheme.spacingLg),
      const QuickStatsSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const DailyChallengeCard(),
      const SizedBox(height: AppTheme.spacingLg),
      const QuizQuickAccessSection(),
      const SizedBox(height: AppTheme.spacingLg),
      const RecommendedQuizzesSection(),
      const SizedBox(height: AppTheme.spacingLg),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ContinueWatchingSection(),
                SizedBox(height: AppTheme.spacingLg),
                RecentVideosSection(),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          const Expanded(
            flex: 4,
            child: SubjectsGridSection(columns: 2),
          ),
        ],
      ),
    ];
  }

  SliverAppBar _buildSliverAppBar() {
    final settings = SegmentConfig.settings;

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: SegmentConfig.isJunior ? 64 : 56,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            SegmentConfig.isJunior ? Icons.rocket_launch : Icons.school,
            color: context.colorScheme.primary,
            size: SegmentConfig.isJunior ? 28 : 24,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              settings.appName,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
                fontSize: SegmentConfig.isJunior ? 22 : 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // Screen Time Indicator (Junior only, in app bar)
        // Use Flexible to prevent overflow when time string is long
        if (settings.showScreenTimeControls) ...[
          const Flexible(child: ScreenTimeIndicator()),
          const SizedBox(width: 4),
        ],

        // Bookmarks
        IconButton(
          onPressed: () => context.go(RouteConstants.bookmarks),
          icon: const Icon(Icons.bookmark_border),
          tooltip: 'Bookmarks',
          iconSize: SegmentConfig.isJunior ? 28 : 24,
        ),

        // Settings
        IconButton(
          onPressed: () => context.push(RouteConstants.settings),
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
          iconSize: SegmentConfig.isJunior ? 28 : 24,
        ),

        // Profile Switcher (Junior only)
        if (SegmentConfig.isJunior) ...[
          const SizedBox(width: 4),
          ProfileSwitcherButton(
            size: 36,
            onManageProfiles: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileManagementScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ] else ...[
          const SizedBox(width: 4),
        ],
      ],
    );
  }

  Future<void> _onRefresh() async {
    // Refresh all data
    await Future.wait([
      ref.read(boardProvider.notifier).refresh(),
      ref.read(subjectProvider.notifier).refresh(),
      ref.read(progressProvider.notifier).refresh(),
    ]);
  }
}

/// Junior-specific welcome header with playful design
class _JuniorWelcomeHeader extends ConsumerWidget {
  const _JuniorWelcomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userState = ref.watch(userProfileProvider);
    final settings = SegmentConfig.settings;

    final greeting = _getTimeBasedGreeting();
    final grade = userState.profile.grade ?? settings.minGrade;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(settings.cardBorderRadius),
      ),
      child: Row(
        children: [
          // Character Avatar (if enabled)
          if (settings.showCharacterAvatar)
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.face,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
          if (settings.showCharacterAvatar) const SizedBox(width: 16),

          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${settings.gradePrefix} $grade Explorer',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }
}

/// Junior-specific streak and XP banner with real gamification data
class _JuniorStreakBanner extends ConsumerWidget {
  const _JuniorStreakBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = SegmentConfig.settings;

    // Use select() with a record to only rebuild when specific fields change
    // This avoids rebuilding when unrelated fields like allBadges, badgeProgress change
    final gamificationData = ref.watch(
      gamificationProvider.select((s) => (
        streak: s.currentStreak,
        xp: s.totalXp,
        badgeCount: s.unlockedBadgeCount,
        level: s.level,
        levelProgress: s.levelProgress,
        isActiveToday: s.isActiveToday,
        hasXpAward: s.lastXpAward != null,
        hasNewBadges: s.newlyUnlockedBadges?.isNotEmpty ?? false,
      )),
    );

    final streak = gamificationData.streak;
    final xp = gamificationData.xp;
    final badgeCount = gamificationData.badgeCount;
    final level = gamificationData.level;
    final levelProgress = gamificationData.levelProgress;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(settings.cardBorderRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Streak with fire animation
              _AnimatedStatItem(
                icon: Icons.local_fire_department,
                iconColor: streak > 0 ? Colors.orange : Colors.grey,
                value: '$streak',
                label: 'Day Streak',
                showPulse: streak > 0 && gamificationData.isActiveToday,
              ),

              // Divider
              Container(
                height: 40,
                width: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),

              // XP with level indicator
              _AnimatedStatItem(
                icon: Icons.star,
                iconColor: Colors.amber,
                value: _formatXp(xp),
                label: 'Level $level',
                showPulse: gamificationData.hasXpAward,
              ),

              // Divider
              Container(
                height: 40,
                width: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),

              // Badges
              _AnimatedStatItem(
                icon: Icons.military_tech,
                iconColor: Colors.purple,
                value: '$badgeCount',
                label: 'Badges',
                showPulse: gamificationData.hasNewBadges,
              ),
            ],
          ),

          // Level progress bar
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level $level Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${(levelProgress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: levelProgress,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return '$xp';
  }
}

/// Animated stat item with optional pulse effect
class _AnimatedStatItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool showPulse;

  const _AnimatedStatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.showPulse = false,
  });

  @override
  State<_AnimatedStatItem> createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<_AnimatedStatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.showPulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_AnimatedStatItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.showPulse && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: widget.showPulse ? _scaleAnimation.value : 1.0,
                child: child,
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 24),
            ),
            const SizedBox(width: 4),
            Text(
              widget.value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.iconColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          widget.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
