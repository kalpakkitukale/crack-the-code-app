import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/presentation/providers/user/progress_provider.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/stats_overview.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/subject_progress.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/watch_history.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/streak_calendar.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/quick_actions.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/enhanced_weekly_chart.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/subject_pie_chart.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/milestones.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/empty_progress_state.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/quiz_progress.dart';

/// Progress Tracking Screen
/// Shows user's learning analytics and progress
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Load progress data
    Future.microtask(() {
      ref.read(progressProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildTabBar(),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            _OverviewTab(),
            _SubjectsTab(),
            _HistoryTab(),
            _QuizzesTab(),
            _StreakTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildTabBar(),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            _OverviewTab(),
            _SubjectsTab(),
            _HistoryTab(),
            _QuizzesTab(),
            _StreakTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: _buildTabBar(),
              ),
            ),
          ),
        ],
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: TabBarView(
              controller: _tabController,
              children: const [
                _OverviewTab(),
                _SubjectsTab(),
                _HistoryTab(),
                _QuizzesTab(),
                _StreakTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Your Progress',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Export progress report
          },
          icon: const Icon(Icons.download),
          tooltip: 'Export Report',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Subjects'),
        Tab(text: 'History'),
        Tab(text: 'Quizzes'),
        Tab(text: 'Streak'),
      ],
    );
  }
}

/// Overview Tab
class _OverviewTab extends ConsumerWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressProvider);

    // Show empty state for completely new users
    if (!progressState.isLoading &&
        !progressState.isLoadingHistory &&
        progressState.watchHistory.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(progressProvider.notifier).refresh();
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: EmptyProgressState(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(progressProvider.notifier).refresh();
      },
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatsOverview(),
            SizedBox(height: AppTheme.spacingLg),
            QuickActions(),
            SizedBox(height: AppTheme.spacingLg),
            QuizProgress(),
            SizedBox(height: AppTheme.spacingLg),
            EnhancedWeeklyChart(),
            SizedBox(height: AppTheme.spacingLg),
            SubjectPieChart(),
            SizedBox(height: AppTheme.spacingLg),
            Milestones(),
            SizedBox(height: AppTheme.spacingLg),
            SubjectProgress(limit: 3),
            SizedBox(height: AppTheme.spacingLg),
            WatchHistory(limit: 5),
          ],
        ),
      ),
    );
  }
}

/// Subjects Tab
class _SubjectsTab extends StatelessWidget {
  const _SubjectsTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        children: [
          SubjectProgress(),
        ],
      ),
    );
  }
}

/// History Tab
class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        children: [
          WatchHistory(),
        ],
      ),
    );
  }
}

/// Quizzes Tab - PHASE 4
class _QuizzesTab extends ConsumerWidget {
  const _QuizzesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Performance',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          Text(
            'Track your quiz attempts and analyze your performance',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Quiz History Card
          Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(RouteConstants.quizHistory),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSm),
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          child: Icon(
                            Icons.history,
                            color: context.colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quiz History',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'View all completed quizzes and review your answers',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Quiz Statistics Card
          Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(RouteConstants.quizStatistics),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSm),
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          child: Icon(
                            Icons.analytics_outlined,
                            color: context.colorScheme.secondary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quiz Statistics',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Analyze your performance with detailed charts and insights',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Streak Tab
class _StreakTab extends StatelessWidget {
  const _StreakTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        children: [
          StreakCalendar(),
        ],
      ),
    );
  }
}
