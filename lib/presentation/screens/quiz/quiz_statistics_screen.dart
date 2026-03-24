import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/utils/semantic_colors.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_statistics.dart';
import 'package:crack_the_code/domain/entities/quiz/subject_statistics.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';
import 'package:crack_the_code/presentation/widgets/quiz/achievement_badge.dart';
import 'package:crack_the_code/presentation/widgets/quiz/empty_quiz_state.dart';
import 'package:crack_the_code/presentation/widgets/quiz/performance_chart.dart';
import 'package:crack_the_code/presentation/widgets/quiz/quiz_stat_card.dart';
import 'package:crack_the_code/presentation/widgets/quiz/subject_breakdown_card.dart';

/// QuizStatisticsScreen - Comprehensive quiz statistics dashboard
///
/// Features:
/// - Overview cards showing total quizzes, average score, streak, and time spent
/// - Performance charts (line, bar, pie)
/// - Subject-wise breakdown with detailed statistics
/// - Achievement badges with progress tracking
/// - Personalized insights and recommendations
/// - Responsive layouts for all devices
class QuizStatisticsScreen extends ConsumerStatefulWidget {
  const QuizStatisticsScreen({super.key});

  @override
  ConsumerState<QuizStatisticsScreen> createState() =>
      _QuizStatisticsScreenState();
}

class _QuizStatisticsScreenState extends ConsumerState<QuizStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock achievements - TODO: Implement achievement tracking in future phase
  late List<_MockAchievement> _achievements;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMockAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load mock achievements
  /// TODO: Replace with actual achievement tracking in future phase
  void _loadMockAchievements() {
    _achievements = [
      _MockAchievement(
        type: AchievementType.firstQuiz,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      _MockAchievement(
        type: AchievementType.perfectScore,
        isUnlocked: false,
        progress: 0.0,
      ),
      _MockAchievement(
        type: AchievementType.sevenDayStreak,
        isUnlocked: false,
        progress: 0.0,
      ),
      _MockAchievement(
        type: AchievementType.hundredQuizzes,
        isUnlocked: false,
        progress: 0.0,
      ),
      _MockAchievement(
        type: AchievementType.subjectMaster,
        isUnlocked: false,
        progress: 0.0,
      ),
      _MockAchievement(
        type: AchievementType.speedster,
        isUnlocked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(quizStatisticsProvider);

    return statsAsync.when(
      loading: () => _buildLoadingScaffold(),
      error: (error, stack) => _buildErrorScaffold(error.toString()),
      data: (statistics) {
        // Update achievement progress based on real data
        _updateAchievementProgress(statistics);

        return ResponsiveBuilder(
          builder: (context, deviceType) {
            switch (deviceType) {
              case DeviceType.mobile:
                return _buildMobileLayout(statistics);
              case DeviceType.tablet:
                return _buildTabletLayout(statistics);
              case DeviceType.desktop:
                return _buildDesktopLayout(statistics);
            }
          },
        );
      },
    );
  }

  /// Update achievement progress based on real statistics
  void _updateAchievementProgress(QuizStatistics statistics) {
    for (var achievement in _achievements) {
      switch (achievement.type) {
        case AchievementType.firstQuiz:
          achievement.isUnlocked = statistics.totalAttempts > 0;
          if (achievement.isUnlocked && achievement.unlockedAt == null) {
            achievement.unlockedAt = statistics.lastQuizDate;
          }
          break;
        case AchievementType.perfectScore:
          achievement.isUnlocked = statistics.perfectScoreCount > 0;
          achievement.progress = statistics.perfectScoreCount > 0 ? 1.0 : 0.0;
          break;
        case AchievementType.sevenDayStreak:
          achievement.isUnlocked = statistics.currentStreak >= 7;
          achievement.progress = (statistics.currentStreak / 7).clamp(0.0, 1.0);
          break;
        case AchievementType.hundredQuizzes:
          achievement.isUnlocked = statistics.totalAttempts >= 100;
          achievement.progress = (statistics.totalAttempts / 100).clamp(0.0, 1.0);
          break;
        case AchievementType.subjectMaster:
          final hasMasteredSubject = statistics.subjectBreakdown.values
              .any((subject) => subject.averageScore >= 90);
          achievement.isUnlocked = hasMasteredSubject;
          achievement.progress = statistics.averageScore / 100;
          break;
        case AchievementType.speedster:
          // Would need to track average time vs expected time
          achievement.isUnlocked = false;
          break;
        case AchievementType.persistent:
          // Would need to track retry and pass data
          achievement.isUnlocked = false;
          break;
        case AchievementType.topScorer:
          // Would need class/leaderboard data
          achievement.isUnlocked = false;
          break;
      }
    }
  }

  /// Build loading scaffold
  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Statistics'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Build error scaffold
  Widget _buildErrorScaffold(String error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Statistics'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Failed to load statistics',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                error,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(quizStatisticsProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build mobile layout (single column with tabs)
  Widget _buildMobileLayout(QuizStatistics statistics) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Statistics'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          // Use tab alignment to distribute tabs evenly
          tabAlignment: TabAlignment.fill,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          tabs: const [
            Tab(icon: Icon(Icons.analytics, size: 20), text: 'Overview'),
            Tab(icon: Icon(Icons.subject, size: 20), text: 'Subjects'),
            Tab(icon: Icon(Icons.emoji_events, size: 20), text: 'Badges'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(statistics, compact: true),
          _buildSubjectsTab(statistics, compact: true),
          _buildAchievementsTab(compact: true),
        ],
      ),
    );
  }

  /// Build tablet layout (two-column with tabs)
  Widget _buildTabletLayout(QuizStatistics statistics) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Statistics'),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.fill,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Overview'),
            Tab(icon: Icon(Icons.subject), text: 'Subjects'),
            Tab(icon: Icon(Icons.emoji_events), text: 'Achievements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(statistics, compact: false),
          _buildSubjectsTab(statistics, compact: false),
          _buildAchievementsTab(compact: false),
        ],
      ),
    );
  }

  /// Build desktop layout (all sections visible)
  Widget _buildDesktopLayout(QuizStatistics statistics) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Overview section
                _buildOverviewSection(statistics, enhanced: true),
                const SizedBox(height: AppTheme.spacingXxl),

                // Subjects and Achievements side by side
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildSubjectsSection(statistics, enhanced: true),
                    ),
                    const SizedBox(width: AppTheme.spacingLg),
                    Expanded(
                      flex: 2,
                      child: _buildAchievementsSection(enhanced: true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build overview tab
  Widget _buildOverviewTab(QuizStatistics statistics, {bool compact = false}) {
    if (statistics.totalAttempts == 0) {
      return EmptyQuizState(
        type: EmptyStateType.noStatistics,
        onAction: _handleStartLearning,
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? AppTheme.spacingMd : AppTheme.spacingLg),
      child: _buildOverviewSection(statistics, compact: compact),
    );
  }

  /// Build subjects tab
  Widget _buildSubjectsTab(QuizStatistics statistics, {bool compact = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? AppTheme.spacingMd : AppTheme.spacingLg),
      child: _buildSubjectsSection(statistics, compact: compact),
    );
  }

  /// Build achievements tab
  Widget _buildAchievementsTab({bool compact = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? AppTheme.spacingMd : AppTheme.spacingLg),
      child: _buildAchievementsSection(compact: compact),
    );
  }

  /// Build overview section
  Widget _buildOverviewSection(
    QuizStatistics statistics, {
    bool compact = false,
    bool enhanced = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Overview cards
        _buildOverviewCards(statistics, compact: compact, enhanced: enhanced),
        SizedBox(height: enhanced ? AppTheme.spacingXxl : (compact ? AppTheme.spacingSm : AppTheme.spacingLg)),

        // Performance charts
        _buildPerformanceCharts(statistics, compact: compact, enhanced: enhanced),
        SizedBox(height: enhanced ? AppTheme.spacingXxl : (compact ? AppTheme.spacingSm : AppTheme.spacingLg)),

        // Insights
        _buildInsightsCard(statistics, compact: compact),
      ],
    );
  }

  /// Build overview cards
  Widget _buildOverviewCards(
    QuizStatistics statistics, {
    bool compact = false,
    bool enhanced = false,
  }) {
    final crossAxisCount = compact ? 2 : enhanced ? 4 : 2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: compact ? AppTheme.spacingSm : AppTheme.spacingMd,
      mainAxisSpacing: compact ? AppTheme.spacingSm : AppTheme.spacingMd,
      childAspectRatio: enhanced ? 1.2 : 1.4,
      children: [
        QuizStatCard(
          icon: Icons.quiz,
          value: '${statistics.totalAttempts}',
          label: 'Total Quizzes',
          subtitle: 'Completed',
          color: AppTheme.primaryBlue,
          animateValue: true,
        ),
        QuizStatCard(
          icon: Icons.percent,
          value: '${statistics.averageScore.toStringAsFixed(1)}%',
          label: 'Average Score',
          subtitle: 'Overall',
          color: AppTheme.successColor,
          animateValue: true,
        ),
        QuizStatCard(
          icon: Icons.local_fire_department,
          value: '${statistics.currentStreak}',
          label: 'Current Streak',
          subtitle: 'Days',
          color: AppTheme.warningColor,
          animateValue: true,
        ),
        QuizStatCard(
          icon: Icons.access_time,
          value: '${statistics.totalTimeSpent.inHours}h',
          label: 'Total Time',
          subtitle: 'Spent Learning',
          color: AppTheme.statusInProgressBorder,
          animateValue: true,
        ),
      ],
    );
  }

  /// Build performance charts
  Widget _buildPerformanceCharts(
    QuizStatistics statistics, {
    bool compact = false,
    bool enhanced = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        Text(
          'Performance Trends',
          style: (enhanced
                  ? context.textTheme.headlineSmall
                  : context.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Score trend chart (needs historical data - using placeholder for now)
        PerformanceChart(
          chartType: PerformanceChartType.line,
          data: _generateScoreTrendData(statistics),
          height: compact ? 160 : 200,
          title: 'Score Trend',
          subtitle: 'Recent performance',
        ),
        SizedBox(height: compact ? AppTheme.spacingSm : AppTheme.spacingMd),

        // Bar chart - Performance by subject
        if (statistics.subjectBreakdown.isNotEmpty)
          PerformanceChart(
            chartType: PerformanceChartType.bar,
            data: _generateSubjectPerformanceData(statistics),
            height: compact ? 160 : 200,
            title: 'Performance by Subject',
            subtitle: 'Average score',
          ),
        if (statistics.subjectBreakdown.isNotEmpty)
          SizedBox(height: compact ? AppTheme.spacingSm : AppTheme.spacingMd),

        // Pie chart - Pass/Fail distribution
        PerformanceChart(
          chartType: PerformanceChartType.pie,
          data: _generatePassFailData(statistics),
          height: compact ? 160 : 200,
          title: 'Pass/Fail Distribution',
        ),
      ],
    );
  }

  /// Build insights card
  Widget _buildInsightsCard(QuizStatistics statistics, {bool compact = false}) {
    final strongestSubject = statistics.subjectsByPerformance.isNotEmpty
        ? statistics.subjectsByPerformance.first
        : null;
    final weakestSubject = statistics.subjectsByPerformance.isNotEmpty
        ? statistics.subjectsByPerformance.last
        : null;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          compact ? AppTheme.spacingMd : AppTheme.spacingLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: context.colorScheme.primary,
                  size: compact ? 24 : 28,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Insights & Recommendations',
                  style: (compact
                          ? context.textTheme.titleMedium
                          : context.textTheme.titleLarge)
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Performance level
            _buildInsightItem(
              icon: Icons.assessment,
              color: _getPerformanceLevelColor(statistics.performanceLevel),
              title: 'Performance Level: ${statistics.performanceLevel.displayName}',
              subtitle: statistics.performanceLevel.description,
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Strongest subject
            if (strongestSubject != null) ...[
              _buildInsightItem(
                icon: Icons.star,
                color: AppTheme.successColor,
                title: 'Strongest Subject: ${strongestSubject.subjectName}',
                subtitle:
                    '${strongestSubject.averageScore.toStringAsFixed(1)}% average score',
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],

            // Weakest subject (if different from strongest)
            if (weakestSubject != null &&
                weakestSubject.subjectId != strongestSubject?.subjectId) ...[
              _buildInsightItem(
                icon: Icons.trending_up,
                color: AppTheme.warningColor,
                title: 'Practice More: ${weakestSubject.subjectName}',
                subtitle:
                    '${weakestSubject.averageScore.toStringAsFixed(1)}% average - Room for improvement',
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],

            // Improvement suggestion
            _buildInsightItem(
              icon: Icons.recommend,
              color: AppTheme.primaryBlue,
              title: 'Recommendation',
              subtitle: statistics.improvementSuggestion,
            ),
          ],
        ),
      ),
    );
  }

  /// Get color for performance level
  Color _getPerformanceLevelColor(PerformanceLevel level) {
    switch (level) {
      case PerformanceLevel.excellent:
        return AppTheme.performanceExcellent;
      case PerformanceLevel.good:
        return AppTheme.performanceGood;
      case PerformanceLevel.average:
        return AppTheme.performanceAverage;
      case PerformanceLevel.needsImprovement:
        return AppTheme.performanceNeedsImprovement;
      case PerformanceLevel.struggling:
        return AppTheme.performanceStruggling;
    }
  }

  /// Build insight item
  Widget _buildInsightItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  subtitle,
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

  /// Build subjects section
  Widget _buildSubjectsSection(
    QuizStatistics statistics, {
    bool compact = false,
    bool enhanced = false,
  }) {
    final subjects = statistics.subjectsByPerformance;

    if (subjects.isEmpty) {
      return const EmptyQuizStateCompact(
        message: 'No subject data available',
        icon: Icons.subject,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
            child: Text(
              'Subject-wise Breakdown',
              style: (enhanced
                      ? context.textTheme.headlineSmall
                      : context.textTheme.titleLarge)
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // Subject cards
        ...subjects.map((subject) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
            child: SubjectBreakdownCard(
              subjectName: subject.subjectName,
              totalAttempts: subject.totalAttempts,
              averageScore: subject.averageScore,
              bestScore: subject.bestScore.toDouble(),
              onViewDetails: () => _viewSubjectDetails(subject),
            ),
          );
        }),
      ],
    );
  }

  /// Build achievements section
  Widget _buildAchievementsSection({
    bool compact = false,
    bool enhanced = false,
  }) {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
            child: Row(
              children: [
                Text(
                  'Achievements',
                  style: (enhanced
                          ? context.textTheme.headlineSmall
                          : context.textTheme.titleLarge)
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  ),
                  child: Text(
                    '$unlockedCount/${_achievements.length} Unlocked',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Achievement badges grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 2 : 3,
            crossAxisSpacing: compact ? AppTheme.spacingSm : AppTheme.spacingMd,
            mainAxisSpacing: compact ? AppTheme.spacingSm : AppTheme.spacingMd,
            childAspectRatio: 0.9,
          ),
          itemCount: _achievements.length,
          itemBuilder: (context, index) {
            final achievement = _achievements[index];
            // Handle null achievement type
            if (achievement.type == null) {
              return const SizedBox.shrink(); // Skip invalid achievements
            }

            final data = AchievementData.get(achievement.type!);

            return AchievementBadge(
              title: data.title,
              description: data.description,
              icon: data.icon,
              isUnlocked: achievement.isUnlocked,
              unlockedAt: achievement.unlockedAt,
              progress: achievement.progress,
              color: data.color,
              onTap: () => _viewAchievementDetails(achievement),
            );
          },
        ),
      ],
    );
  }

  /// Generate score trend data from historical quiz attempts
  List<PerformanceDataPoint> _generateScoreTrendData(QuizStatistics statistics) {
    // Get real historical score data from the last 30 days
    final scoreTrendData = ref.watch(scoreTrendDataProvider(30));

    return scoreTrendData.when(
      data: (data) {
        if (data.isEmpty) {
          // If no data available, show empty chart
          return [];
        }

        // Convert score trend data to performance data points
        final dataPoints = <PerformanceDataPoint>[];

        // Filter and validate entries before processing
        final validEntries = data.entries.where((entry) {
          // Validate that value is finite and within valid score range
          return entry.value.isFinite &&
                 entry.value >= 0 &&
                 entry.value <= 100;
        }).toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        for (final entry in validEntries) {
          // Parse date from string (format: YYYY-MM-DD)
          final dateParts = entry.key.split('-');
          if (dateParts.length == 3) {
            final date = DateTime(
              int.parse(dateParts[0]),
              int.parse(dateParts[1]),
              int.parse(dateParts[2]),
            );

            dataPoints.add(PerformanceDataPoint(
              label: '${date.day}/${date.month}',
              value: entry.value,
              timestamp: date,
            ));
          }
        }

        return dataPoints;
      },
      loading: () {
        // While loading, show minimal placeholder
        return [];
      },
      error: (_, __) {
        // On error, show empty chart
        return [];
      },
    );
  }

  /// Generate subject performance data
  List<PerformanceDataPoint> _generateSubjectPerformanceData(
      QuizStatistics statistics) {
    return statistics.subjectBreakdown.values
        .where((subject) => subject.averageScore.isFinite)
        .map((subject) {
      return PerformanceDataPoint(
        label: subject.subjectName,
        value: subject.averageScore,
        color: _getSubjectColor(subject.subjectName),
      );
    }).toList();
  }

  /// Generate pass/fail distribution data
  List<PerformanceDataPoint> _generatePassFailData(QuizStatistics statistics) {
    return [
      PerformanceDataPoint(
        label: 'Passed',
        value: statistics.totalPassed.toDouble(),
        color: AppTheme.successColor,
      ),
      PerformanceDataPoint(
        label: 'Failed',
        value: statistics.totalFailed.toDouble(),
        color: AppTheme.performanceStruggling,
      ),
    ];
  }

  /// Get subject color
  Color _getSubjectColor(String subjectName) {
    return SemanticColors.getSubjectColor(subjectName);
  }

  /// Handle start learning - Navigate to home screen for quiz selection
  void _handleStartLearning() {
    // Navigate to home screen where users can browse content and take quizzes
    context.go(RouteConstants.home);
  }

  /// View subject details
  void _viewSubjectDetails(SubjectStatistics subject) {
    // Subject details screen not yet implemented
    // TODO: Navigate to subject-specific statistics showing:
    // - Quiz history for this subject
    // - Performance trend chart
    // - Topic-wise breakdown
    // - Strengths and weaknesses
  }

  /// View achievement details
  void _viewAchievementDetails(_MockAchievement achievement) {
    // Handle null achievement type
    if (achievement.type == null) {
      return; // Skip showing details for invalid achievements
    }

    final data = AchievementData.get(achievement.type!);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(data.icon, color: data.color),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(child: Text(data.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.description),
            const SizedBox(height: AppTheme.spacingMd),
            if (achievement.isUnlocked) ...[
              Text(
                'Unlocked on ${_formatDate(achievement.unlockedAt!)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ] else if (achievement.progress != null && achievement.progress! > 0) ...[
              const SizedBox(height: AppTheme.spacingSm),
              LinearProgressIndicator(
                value: achievement.progress,
                backgroundColor:
                    context.colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(data.color),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                '${(achievement.progress! * 100).toInt()}% complete',
                style: context.textTheme.bodySmall,
              ),
            ] else ...[
              Text(
                'Keep learning to unlock this achievement!',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }
}

/// Mock achievement data class
/// TODO: Implement proper achievement tracking system
class _MockAchievement {
  final AchievementType type;
  bool isUnlocked;
  DateTime? unlockedAt;
  double? progress;

  _MockAchievement({
    required this.type,
    required this.isUnlocked,
    this.unlockedAt,
    this.progress,
  });
}
