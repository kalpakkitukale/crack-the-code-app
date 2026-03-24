import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/pedagogy/pre_assessment.dart';
import 'package:streamshaala/presentation/providers/pedagogy/pre_assessment_provider.dart';

/// Pre-Assessment Screen - Subject-level diagnostic assessment
class PreAssessmentScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final String subjectName;
  final int targetGrade;
  final String studentId;

  const PreAssessmentScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.targetGrade,
    required this.studentId,
  });

  @override
  ConsumerState<PreAssessmentScreen> createState() => _PreAssessmentScreenState();
}

class _PreAssessmentScreenState extends ConsumerState<PreAssessmentScreen> {
  @override
  void initState() {
    super.initState();
    _startAssessment();
  }

  Future<void> _startAssessment() async {
    await Future.microtask(() async {
      await ref.read(preAssessmentProvider.notifier).startAssessment(
        studentId: widget.studentId,
        subjectId: widget.subjectId,
        subjectName: widget.subjectName,
        targetGrade: widget.targetGrade,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preAssessmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} Readiness Check'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PreAssessmentState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildErrorView(state.error!);
    }

    if (state.isComplete) {
      return _buildResultView(state);
    }

    if (state.activeAssessment == null) {
      return const Center(child: Text('Starting assessment...'));
    }

    return _buildAssessmentView(state);
  }

  Widget _buildAssessmentView(PreAssessmentState state) {
    final assessment = state.activeAssessment!;
    final questionIds = assessment.questionIds;
    final currentIndex = assessment.currentQuestionIndex;

    if (currentIndex >= questionIds.length) {
      return const Center(child: CircularProgressIndicator());
    }

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(assessment);
          case DeviceType.tablet:
            return _buildTabletLayout(assessment);
          case DeviceType.desktop:
            return _buildDesktopLayout(assessment);
        }
      },
    );
  }

  Widget _buildMobileLayout(PreAssessment assessment) {
    return SafeArea(
      child: Column(
        children: [
          _buildPhaseIndicator(assessment.currentPhase),
          _buildProgressBar(assessment),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppTheme.spacingMd),
              child: _buildQuestionCard(assessment),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(PreAssessment assessment) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            _buildPhaseIndicator(assessment.currentPhase),
            _buildProgressBar(assessment),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildQuestionCard(assessment),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(PreAssessment assessment) {
    return SafeArea(
      child: Row(
        children: [
          // Side panel with progress
          Container(
            width: 300,
            padding: EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerLowest,
              border: Border(
                right: BorderSide(color: context.colorScheme.outline.withValues(alpha: 0.2)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase ${assessment.currentPhase.index + 1}/3',
                  style: context.textTheme.titleLarge,
                ),
                SizedBox(height: AppTheme.spacingSm),
                Text(_getPhaseDescription(assessment.currentPhase)),
                SizedBox(height: AppTheme.spacingLg),
                _buildProgressDetails(assessment),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingLg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _buildQuestionCard(assessment),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator(PreAssessmentPhase phase) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPhaseChip('Quick Check', phase == PreAssessmentPhase.quickScreening),
          SizedBox(width: AppTheme.spacingSm),
          Icon(Icons.arrow_forward, size: 16, color: context.colorScheme.outline),
          SizedBox(width: AppTheme.spacingSm),
          _buildPhaseChip('Deep Dive', phase == PreAssessmentPhase.deepDive),
          SizedBox(width: AppTheme.spacingSm),
          Icon(Icons.arrow_forward, size: 16, color: context.colorScheme.outline),
          SizedBox(width: AppTheme.spacingSm),
          _buildPhaseChip('Boundary', phase == PreAssessmentPhase.boundaryDetection),
        ],
      ),
    );
  }

  Widget _buildPhaseChip(String label, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: isActive ? context.colorScheme.primary : context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: isActive ? context.colorScheme.onPrimary : context.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildProgressBar(PreAssessment assessment) {
    final progress = assessment.currentQuestionIndex / assessment.questionIds.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: context.colorScheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.primary),
          ),
          SizedBox(height: AppTheme.spacingXs),
          Text(
            'Question ${assessment.currentQuestionIndex + 1} of ${assessment.questionIds.length}',
            style: context.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDetails(PreAssessment assessment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: context.textTheme.titleMedium,
        ),
        SizedBox(height: AppTheme.spacingSm),
        Text(
          '${assessment.currentQuestionIndex} of ${assessment.questionIds.length} questions',
          style: context.textTheme.bodyMedium,
        ),
        SizedBox(height: AppTheme.spacingSm),
        LinearProgressIndicator(
          value: assessment.currentQuestionIndex / assessment.questionIds.length,
        ),
      ],
    );
  }

  Widget _buildQuestionCard(PreAssessment assessment) {
    final questionId = assessment.questionIds[assessment.currentQuestionIndex];
    final selectedAnswer = assessment.answers[questionId];

    // Since we only have question IDs, display a placeholder
    // In a full implementation, this would load the actual question
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Question ${assessment.currentQuestionIndex + 1}',
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.spacingSm),
            Text(
              'Question ID: $questionId',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
            SizedBox(height: AppTheme.spacingLg),
            // Placeholder options
            ...['A', 'B', 'C', 'D'].map((option) => _buildOptionTile(
              option,
              selectedAnswer == option,
              () => _submitAnswer(questionId, option),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String option, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? context.colorScheme.primary : context.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            color: isSelected
                ? context.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? context.colorScheme.primary : context.colorScheme.outline,
              ),
              SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: Text(
                  'Option $option',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitAnswer(String questionId, String answer) async {
    await ref.read(preAssessmentProvider.notifier).submitAnswer(
      questionId: questionId,
      answer: answer,
    );
  }

  Widget _buildResultView(PreAssessmentState state) {
    final result = state.result!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingLg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              _buildReadinessIndicator(result.overallReadiness),
              SizedBox(height: AppTheme.spacingLg),
              _buildGradeBreakdown(result.gradeScores),
              SizedBox(height: AppTheme.spacingLg),
              if (state.identifiedGaps.isNotEmpty) ...[
                _buildGapsList(state),
                SizedBox(height: AppTheme.spacingLg),
              ],
              _buildActionButtons(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadinessIndicator(double readiness) {
    final color = readiness >= 80
        ? Colors.green
        : readiness >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            Text(
              'Your Readiness',
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.spacingMd),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: readiness / 100,
                    strokeWidth: 12,
                    backgroundColor: context.colorScheme.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${readiness.toStringAsFixed(0)}%',
                      style: context.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      _getReadinessLabel(readiness),
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getReadinessLabel(double readiness) {
    if (readiness >= 90) return 'Excellent!';
    if (readiness >= 80) return 'Good';
    if (readiness >= 70) return 'Fair';
    if (readiness >= 60) return 'Needs Work';
    return 'Foundation Needed';
  }

  Widget _buildGradeBreakdown(Map<int, double> gradeScores) {
    final sortedGrades = gradeScores.keys.toList()..sort();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By Grade',
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: AppTheme.spacingSm),
            ...sortedGrades.map((grade) {
              final score = gradeScores[grade]!;
              return Padding(
                padding: EdgeInsets.only(bottom: AppTheme.spacingSm),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Class $grade'),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: score / 100,
                        backgroundColor: context.colorScheme.surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          score >= 60 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingSm),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${score.toStringAsFixed(0)}%',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGapsList(PreAssessmentState state) {
    return Card(
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
                  'Concepts to Review (${state.identifiedGaps.length})',
                  style: context.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingSm),
            ...state.identifiedGaps.take(5).map((gap) => ListTile(
              leading: CircleAvatar(
                backgroundColor: _getSeverityColor(gap.currentMastery),
                child: Text(
                  'C${gap.gradeLevel}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(gap.conceptName),
              subtitle: Text('Current: ${gap.currentMastery.toStringAsFixed(0)}%'),
              trailing: Text('~${gap.estimatedFixMinutes} min'),
            )),
            if (state.identifiedGaps.length > 5)
              Padding(
                padding: EdgeInsets.only(top: AppTheme.spacingSm),
                child: Text(
                  '+${state.identifiedGaps.length - 5} more gaps',
                  style: context.textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(double mastery) {
    if (mastery < 30) return Colors.red;
    if (mastery < 50) return Colors.orange;
    return Colors.yellow.shade700;
  }

  Widget _buildActionButtons(PreAssessmentState state) {
    final hasGaps = state.identifiedGaps.isNotEmpty;
    final result = state.result!;

    return Column(
      children: [
        if (hasGaps && state.recommendedPath != null)
          FilledButton.icon(
            onPressed: () => _startFoundationPath(state),
            icon: const Icon(Icons.route),
            label: Text(
              'Start Foundation Path (~${result.estimatedFixMinutes} min)',
            ),
          ),
        SizedBox(height: AppTheme.spacingSm),
        OutlinedButton(
          onPressed: () => context.go('/subjects/${widget.subjectId}/chapters'),
          child: Text(
            hasGaps ? 'Skip & Start Class ${widget.targetGrade}' : 'Start Class ${widget.targetGrade}',
          ),
        ),
      ],
    );
  }

  void _startFoundationPath(PreAssessmentState state) {
    // Navigate to foundation path screen
    context.go('/foundation-path/${state.recommendedPath!.id}');
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
            onPressed: _startAssessment,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getPhaseDescription(PreAssessmentPhase phase) {
    switch (phase) {
      case PreAssessmentPhase.quickScreening:
        return 'Quick check of foundational knowledge across all grades.';
      case PreAssessmentPhase.deepDive:
        return 'Detailed assessment of areas that need attention.';
      case PreAssessmentPhase.boundaryDetection:
        return 'Finding the exact boundary of your knowledge.';
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Assessment?'),
        content: const Text(
          'Your progress will be lost. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(preAssessmentProvider.notifier).clearAssessment();
              context.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
