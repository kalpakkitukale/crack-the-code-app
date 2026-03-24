import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_mastery.dart';
import 'package:crack_the_code/presentation/providers/pedagogy/mastery_provider.dart';

/// Mastery Dashboard Screen - Shows concept mastery overview
class MasteryDashboardScreen extends ConsumerStatefulWidget {
  final String studentId;

  const MasteryDashboardScreen({
    super.key,
    required this.studentId,
  });

  @override
  ConsumerState<MasteryDashboardScreen> createState() => _MasteryDashboardScreenState();
}

class _MasteryDashboardScreenState extends ConsumerState<MasteryDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadMastery();
  }

  Future<void> _loadMastery() async {
    await Future.microtask(() {
      ref.read(masteryProvider.notifier).loadMastery(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(masteryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mastery Dashboard'),
        actions: [
          if (state.hasReviewsDue)
            IconButton(
              icon: Badge(
                label: Text('${state.reviewsDueCount}'),
                child: const Icon(Icons.refresh),
              ),
              onPressed: () => context.go('/daily-review/${widget.studentId}'),
              tooltip: 'Daily Reviews',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMastery,
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(MasteryState state) {
    if (state.isLoading && state.conceptMasteries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildErrorView(state.error!);
    }

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(state);
          case DeviceType.tablet:
            return _buildTabletLayout(state);
          case DeviceType.desktop:
            return _buildDesktopLayout(state);
        }
      },
    );
  }

  Widget _buildMobileLayout(MasteryState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildOverviewCard(state)),
        SliverToBoxAdapter(child: _buildQuickActions(state)),
        if (state.hasGaps)
          SliverToBoxAdapter(child: _buildGapsSection(state)),
        SliverToBoxAdapter(child: _buildMasteryBreakdown(state)),
      ],
    );
  }

  Widget _buildTabletLayout(MasteryState state) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildOverviewCard(state),
                SizedBox(height: AppTheme.spacingMd),
                _buildQuickActions(state),
              ],
            ),
          ),
          SizedBox(width: AppTheme.spacingMd),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state.hasGaps) _buildGapsSection(state),
                  _buildMasteryBreakdown(state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(MasteryState state) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Column(
              children: [
                _buildOverviewCard(state),
                SizedBox(height: AppTheme.spacingMd),
                _buildQuickActions(state),
              ],
            ),
          ),
          SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.hasGaps) _buildGapsSection(state),
                  _buildMasteryBreakdown(state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(MasteryState state) {
    final overallMastery = state.overallMastery;
    final color = _getMasteryColor(overallMastery);

    return Card(
      margin: EdgeInsets.all(AppTheme.spacingMd),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            Text(
              'Overall Mastery',
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.spacingMd),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: overallMastery / 100,
                    strokeWidth: 10,
                    backgroundColor: context.colorScheme.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${overallMastery.toStringAsFixed(0)}%',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      _getMasteryLabel(overallMastery),
                      style: context.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'Mastered',
                  value: '${state.masteredCount}',
                  color: Colors.green,
                ),
                _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'Learning',
                  value: '${state.learningCount}',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.warning,
                  label: 'Gaps',
                  value: '${state.gapsCount}',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildQuickActions(MasteryState state) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: context.textTheme.titleSmall,
            ),
            SizedBox(height: AppTheme.spacingSm),
            if (state.hasReviewsDue)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withValues(alpha: 0.2),
                  child: const Icon(Icons.refresh, color: Colors.blue),
                ),
                title: const Text('Daily Reviews'),
                subtitle: Text('${state.reviewsDueCount} concepts due'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.go('/daily-review/${widget.studentId}'),
              ),
            if (state.hasGaps)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withValues(alpha: 0.2),
                  child: const Icon(Icons.auto_fix_high, color: Colors.orange),
                ),
                title: const Text('Fix Gaps'),
                subtitle: Text('${state.gapsCount} concepts need attention'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showGapFixOptions(context, state),
              ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple.withValues(alpha: 0.2),
                child: const Icon(Icons.grid_view, color: Colors.purple),
              ),
              title: const Text('Concept Map'),
              subtitle: const Text('Visualize your progress'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/concept-map/${widget.studentId}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGapsSection(MasteryState state) {
    return Card(
      margin: EdgeInsets.all(AppTheme.spacingMd),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange),
                SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Concepts Needing Attention',
                  style: context.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingSm),
            ...state.currentGaps.take(5).map((gap) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: _getMasteryColor(gap.currentMastery).withValues(alpha: 0.2),
                child: Text(
                  '${gap.currentMastery.toStringAsFixed(0)}%',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(gap.conceptName),
              subtitle: Text('Grade ${gap.gradeLevel}'),
              trailing: TextButton(
                onPressed: () => _startGapFix(gap.conceptId),
                child: const Text('Fix'),
              ),
            )),
            if (state.currentGaps.length > 5)
              TextButton(
                onPressed: () => _showAllGaps(context, state),
                child: Text('View all ${state.currentGaps.length} gaps'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryBreakdown(MasteryState state) {
    // Group masteries by level
    final byLevel = <MasteryLevel, List<ConceptMastery>>{};
    for (final mastery in state.conceptMasteries.values) {
      byLevel.putIfAbsent(mastery.level, () => []).add(mastery);
    }

    return Card(
      margin: EdgeInsets.all(AppTheme.spacingMd),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mastery Breakdown',
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.spacingMd),
            ...MasteryLevel.values.map((level) {
              final concepts = byLevel[level] ?? [];
              if (concepts.isEmpty) return const SizedBox.shrink();

              return ExpansionTile(
                leading: Icon(
                  _getMasteryIcon(level),
                  color: _getLevelColor(level),
                ),
                title: Text(level.name.toUpperCase()),
                subtitle: Text('${concepts.length} concepts'),
                children: concepts.map((mastery) => ListTile(
                  title: Text(mastery.conceptId),
                  subtitle: Text('${mastery.masteryScore.toStringAsFixed(0)}%'),
                  trailing: Text(
                    mastery.lastAssessed != null
                        ? _formatDate(mastery.lastAssessed!)
                        : 'Not assessed',
                    style: context.textTheme.labelSmall,
                  ),
                )).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getMasteryColor(double mastery) {
    if (mastery >= 80) return Colors.green;
    if (mastery >= 60) return Colors.blue;
    if (mastery >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getMasteryLabel(double mastery) {
    if (mastery >= 90) return 'Excellent';
    if (mastery >= 80) return 'Proficient';
    if (mastery >= 60) return 'Familiar';
    if (mastery >= 40) return 'Learning';
    return 'Beginner';
  }

  IconData _getMasteryIcon(MasteryLevel level) {
    switch (level) {
      case MasteryLevel.notLearned:
        return Icons.help_outline;
      case MasteryLevel.learning:
        return Icons.school;
      case MasteryLevel.familiar:
        return Icons.thumb_up_outlined;
      case MasteryLevel.proficient:
        return Icons.star_outline;
      case MasteryLevel.mastered:
        return Icons.emoji_events;
    }
  }

  Color _getLevelColor(MasteryLevel level) {
    switch (level) {
      case MasteryLevel.notLearned:
        return Colors.grey;
      case MasteryLevel.learning:
        return Colors.orange;
      case MasteryLevel.familiar:
        return Colors.blue;
      case MasteryLevel.proficient:
        return Colors.green;
      case MasteryLevel.mastered:
        return Colors.amber;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}';
  }

  void _startGapFix(String conceptId) {
    context.go('/practice/$conceptId');
  }

  void _showGapFixOptions(BuildContext context, MasteryState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fix Your Gaps',
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: AppTheme.spacingMd),
            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text('Start Foundation Path'),
              subtitle: const Text('Fix all gaps in order'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to foundation path
              },
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('Fix Highest Priority'),
              subtitle: Text(state.currentGaps.isNotEmpty
                  ? state.currentGaps.first.conceptName
                  : 'No gaps'),
              onTap: () {
                Navigator.pop(context);
                if (state.currentGaps.isNotEmpty) {
                  _startGapFix(state.currentGaps.first.conceptId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAllGaps(BuildContext context, MasteryState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              Text(
                'All Gaps (${state.currentGaps.length})',
                style: context.textTheme.titleLarge,
              ),
              SizedBox(height: AppTheme.spacingMd),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.currentGaps.length,
                  itemBuilder: (context, index) {
                    final gap = state.currentGaps[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getMasteryColor(gap.currentMastery),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(gap.conceptName),
                      subtitle: Text(
                        'Grade ${gap.gradeLevel} - ${gap.currentMastery.toStringAsFixed(0)}%',
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () {
                          Navigator.pop(context);
                          _startGapFix(gap.conceptId);
                        },
                        child: const Text('Fix'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
          SizedBox(height: AppTheme.spacingMd),
          Text(error),
          SizedBox(height: AppTheme.spacingMd),
          FilledButton(
            onPressed: _loadMastery,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
