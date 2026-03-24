import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/presentation/providers/user/quiz_history_provider.dart';
import 'package:streamshaala/presentation/widgets/practice/quiz_selection_sheet.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';

/// Practice Screen (Preboard segment)
/// Mock tests, quiz history, and practice recommendations
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  @override
  void initState() {
    super.initState();
    // Quiz history will be loaded when the widget is built
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildQuickActions(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildQuizHistorySummary(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildPracticeRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),
            const SizedBox(height: AppTheme.spacingLg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildQuickActions()),
                const SizedBox(width: AppTheme.spacingLg),
                Expanded(child: _buildQuizHistorySummary()),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            _buildPracticeRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeBanner(),
                const SizedBox(height: AppTheme.spacingXl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildQuickActions()),
                    const SizedBox(width: AppTheme.spacingXl),
                    Expanded(child: _buildQuizHistorySummary()),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXl),
                _buildPracticeRecommendations(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Practice & Mock Tests',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.push(RouteConstants.quizHistory);
          },
          icon: const Icon(Icons.history),
          tooltip: 'Quiz History',
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // WELCOME BANNER
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withValues(alpha:0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: context.colorScheme.onPrimary,
                size: 32,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  'Board Exam Practice',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Take mock tests and practice quizzes to ace your board exams',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onPrimary.withValues(alpha:0.9),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // QUICK ACTIONS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildActionCard(
          icon: Icons.quiz,
          title: 'Start Practice Quiz',
          subtitle: 'Test your knowledge',
          color: Colors.blue,
          onTap: () => _showQuizSelectionSheet(context),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildActionCard(
          icon: Icons.timer,
          title: 'Mock Test',
          subtitle: 'Full-length practice test',
          color: Colors.orange,
          onTap: () => _showMockTestSheet(context),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildActionCard(
          icon: Icons.trending_up,
          title: 'Weak Areas',
          subtitle: 'Practice your weak topics',
          color: Colors.red,
          onTap: () => _showWeakAreasSheet(context),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(alpha:0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurface.withValues(alpha:0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // QUIZ HISTORY SUMMARY
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildQuizHistorySummary() {
    final recentQuizzes = ref.watch(recentQuizzesProvider(5));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Quizzes',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(RouteConstants.quizHistory);
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        recentQuizzes.when(
          data: (quizzes) {
            if (quizzes.isEmpty) {
              return _buildEmptyQuizHistory();
            }
            return Column(children: _buildRecentQuizzesList(quizzes));
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => _buildEmptyQuizHistory(),
        ),
      ],
    );
  }

  Widget _buildEmptyQuizHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 48,
              color: context.colorScheme.primary.withValues(alpha:0.3),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No Quizzes Yet',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Start practicing to see your history',
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha:0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecentQuizzesList(List<QuizAttempt> quizzes) {
    return quizzes.map((quiz) {
      final scorePercent = (quiz.score * 100).toInt();
      final passed = quiz.passed;

      return Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: passed ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: passed ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Text(
                '$scorePercent%',
                style: TextStyle(
                  color: passed ? Colors.green.shade700 : Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          title: Text(
            quiz.topicName ?? quiz.chapterName ?? 'Quiz',
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Icon(
                passed ? Icons.check_circle : Icons.refresh,
                size: 14,
                color: passed ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                '${passed ? "Passed" : "Retry"} • ${_formatQuizDate(quiz.completedAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: context.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          onTap: () {
            // Navigate to quiz review
            context.push('/quiz/review', extra: quiz);
          },
        ),
      );
    }).toList();
  }

  String _formatQuizDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PRACTICE RECOMMENDATIONS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPracticeRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Practice',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        _buildRecommendationCard(
          icon: Icons.science,
          title: 'Science - Chapter 1',
          subtitle: 'Revise Chemical Reactions',
          progress: 0.6,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildRecommendationCard(
          icon: Icons.calculate,
          title: 'Mathematics - Algebra',
          subtitle: 'Practice Quadratic Equations',
          progress: 0.4,
        ),
        const SizedBox(height: AppTheme.spacingSm),
        _buildRecommendationCard(
          icon: Icons.public,
          title: 'Social Science - History',
          subtitle: 'Review Nationalism in India',
          progress: 0.8,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to recommended practice - show quiz selection
          _showQuizSelectionSheet(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: context.colorScheme.primary),
                  const SizedBox(width: AppTheme.spacingSm),
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
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                            color:
                                context.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: context.colorScheme.primary.withValues(alpha: 0.1),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toInt()}% Complete',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BOTTOM SHEET METHODS
  // ═══════════════════════════════════════════════════════════════════════

  /// Show quiz selection bottom sheet
  void _showQuizSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => QuizSelectionSheet(
          scrollController: scrollController,
          onQuizSelected: (entityId, assessmentType) {
            Navigator.pop(sheetContext);
            // Navigate to quiz screen
            final studentId = ref.read(effectiveUserIdProvider);
            context.push(
              RouteConstants.getQuizPath(entityId, studentId),
              extra: {'assessmentType': assessmentType.queryValue},
            );
          },
        ),
      ),
    );
  }

  /// Show mock test selection sheet
  void _showMockTestSheet(BuildContext context) {
    final isJunior = SegmentConfig.isJunior;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timer,
                size: 48,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              isJunior ? 'Coming Soon!' : 'Mock Tests Coming Soon',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              isJunior
                  ? 'Full practice tests will be here soon!\nKeep practicing with topic quizzes for now.'
                  : 'Full-length mock tests with timer and detailed analysis will be available soon.\n\nIn the meantime, practice with chapter and topic quizzes.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _showQuizSelectionSheet(context);
                },
                child: Text(isJunior ? 'Practice Now!' : 'Start Practice Quiz'),
              ),
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show weak areas sheet
  void _showWeakAreasSheet(BuildContext context) {
    final isJunior = SegmentConfig.isJunior;
    final stats = ref.read(quizStatisticsProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isJunior ? 'Areas to Improve' : 'Weak Areas Analysis',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isJunior ? 'Practice these to get better!' : 'Based on your quiz performance',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Divider(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),

            // Content
            Expanded(
              child: stats.when(
                data: (data) {
                  // For now, show a placeholder since weak areas analysis requires more data
                  return _buildWeakAreasPlaceholder(sheetContext, isJunior);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => _buildWeakAreasPlaceholder(sheetContext, isJunior),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeakAreasPlaceholder(BuildContext sheetContext, bool isJunior) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 48,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(height: 16),
                Text(
                  isJunior ? 'Keep Taking Quizzes!' : 'Take More Quizzes to See Analysis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isJunior
                      ? 'The more quizzes you take, the better we can help you improve!'
                      : 'Complete more quizzes across different topics to generate a detailed weak areas analysis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tip cards
          _buildTipCard(
            icon: Icons.lightbulb_outline,
            title: isJunior ? 'Pro Tip!' : 'How it works',
            description: isJunior
                ? 'Take quizzes on different chapters to see where you need more practice.'
                : 'We analyze your quiz performance to identify concepts you struggle with, then recommend targeted practice.',
            color: Colors.amber,
          ),

          const SizedBox(height: 12),

          _buildTipCard(
            icon: Icons.star_outline,
            title: isJunior ? 'Goal' : 'Your Goal',
            description: isJunior
                ? 'Try to get 3 stars on every topic!'
                : 'Score 80% or higher consistently to master a topic.',
            color: Colors.green,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _showQuizSelectionSheet(context);
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(isJunior ? 'Start Practicing!' : 'Start a Quiz'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.withValues(alpha: 0.8), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
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
