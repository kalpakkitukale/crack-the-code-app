import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/core/utils/semantic_colors.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/entities/pedagogy/quiz_recommendation.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/domain/services/learning_path_generator.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/presentation/screens/pedagogy/foundation_path_screen.dart';
import 'package:crack_the_code/presentation/screens/pedagogy/recommended_videos_screen.dart';
import 'package:crack_the_code/presentation/providers/auth/user_id_provider.dart';

/// Provider for learning path generator service
final learningPathGeneratorProvider = Provider<LearningPathGenerator>((ref) {
  return injectionContainer.learningPathGenerator;
});

/// Full Recommendations Screen - Detailed view of all personalized learning recommendations
///
/// Shows comprehensive gap analysis with:
/// - Assessment type context and score summary
/// - All identified knowledge gaps with severity levels
/// - Recommended videos for each gap
/// - Action buttons for guided learning path or flexible video browsing
class RecommendationsScreen extends ConsumerWidget {
  final RecommendationsBundle bundle;

  const RecommendationsScreen({
    super.key,
    required this.bundle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final assessmentType = bundle.assessmentType;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bundle.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (bundle.subjectName != null)
              Text(
                bundle.subjectName!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
        backgroundColor: assessmentType.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Assessment type badge
          Container(
            margin: const EdgeInsets.only(right: AppTheme.spacingMd),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: assessmentType.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: assessmentType.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  assessmentType.iconFilled,
                  size: 16,
                  color: assessmentType.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  assessmentType.shortLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: assessmentType.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          switch (deviceType) {
            case DeviceType.mobile:
              return _buildMobileLayout(context);
            case DeviceType.tablet:
            case DeviceType.desktop:
              return _buildWideLayout(context);
          }
        },
      ),
      bottomNavigationBar: _buildActionBar(context, ref),
    );
  }

  /// Mobile layout (single column)
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80), // Space for action bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreSummaryCard(context),
          const SizedBox(height: AppTheme.spacingMd),
          _buildInstructionsCard(context),
          const SizedBox(height: AppTheme.spacingMd),
          _buildRecommendationsList(context),
        ],
      ),
    );
  }

  /// Wide layout (tablet/desktop with two columns)
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left sidebar with summary and instructions
        SizedBox(
          width: 360,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreSummaryCard(context),
                const SizedBox(height: AppTheme.spacingMd),
                _buildInstructionsCard(context),
              ],
            ),
          ),
        ),

        // Right content area with recommendations
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppTheme.spacingLg,
              right: AppTheme.spacingLg,
              bottom: 100, // Space for action bar
            ),
            child: _buildRecommendationsList(context),
          ),
        ),
      ],
    );
  }

  /// Score summary card (compact)
  Widget _buildScoreSummaryCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Your Performance',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                // Score
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Score',
                    bundle.quizScore != null
                        ? '${bundle.quizScore!.toInt()}%'
                        : 'N/A',
                    Icons.percent,
                  ),
                ),
                // Gaps found
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Areas to Improve',
                    '${bundle.totalCount}',
                    Icons.flag_outlined,
                  ),
                ),
                // Time estimate
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Est. Time',
                    bundle.formattedTotalTime,
                    Icons.schedule,
                  ),
                ),
              ],
            ),
            if (bundle.criticalCount > 0) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.severityCritical.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.severityCritical.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.priority_high,
                      color: AppTheme.severityCritical,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        '${bundle.criticalCount} critical ${bundle.criticalCount == 1 ? 'gap' : 'gaps'} require immediate attention',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.severityCritical,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Instructions card
  Widget _buildInstructionsCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'How to Use',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              bundle.instructions,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              bundle.encouragementMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: bundle.assessmentType.primaryColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// List of all recommendations
  Widget _buildRecommendationsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          child: Text(
            'Recommended Learning Path',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        // CRITICAL FIX: Use Column instead of ListView to avoid gesture conflicts
        // ListView participates in gesture arena even with NeverScrollableScrollPhysics
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < bundle.recommendations.length; i++) ...[
                _RecommendationCard(
                  recommendation: bundle.recommendations[i],
                  index: i,
                  assessmentType: bundle.assessmentType,
                ),
                if (i < bundle.recommendations.length - 1)
                  const SizedBox(height: AppTheme.spacingMd),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingXl),
      ],
    );
  }

  /// Fixed bottom action bar
  Widget _buildActionBar(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Browse Videos button (secondary)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleBrowseVideos(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: bundle.assessmentType.primaryColor,
                  side: BorderSide(color: bundle.assessmentType.borderColor),
                  minimumSize: const Size(0, 48),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.video_library, size: 20),
                    const SizedBox(width: AppTheme.spacingSm),
                    Flexible(
                      child: Text(
                        bundle.secondaryActionText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            // Start Journey button (primary)
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => _handleStartGuidedPath(context, ref),
                style: FilledButton.styleFrom(
                  backgroundColor: bundle.assessmentType.primaryColor,
                  minimumSize: const Size(0, 48),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, size: 20),
                    const SizedBox(width: AppTheme.spacingSm),
                    Flexible(
                      child: Text(
                        bundle.primaryActionText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle start guided learning path
  Future<void> _handleStartGuidedPath(BuildContext context, WidgetRef ref) async {
    logger.info('[Recommendations] Generating guided learning path');

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: bundle.assessmentType.primaryColor,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Creating your learning path...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Get learning path generator from provider
      final learningPathGenerator = ref.read(learningPathGeneratorProvider);

      // Extract gaps from recommendations
      final gaps = bundle.recommendations.map((r) => r.gap).toList();

      // Determine subject info (use first recommendation or defaults)
      final subjectName = bundle.subjectName ?? 'Subject';
      final subjectId = bundle.quizResultId; // Use quiz result ID as subject ID

      // Determine target grade (use highest grade from gaps + 1)
      final targetGrade = gaps.isEmpty
          ? 10
          : gaps.map((g) => g.gradeLevel).reduce((a, b) => a > b ? a : b) + 1;

      // Get student ID from auth provider
      final studentId = ref.read(effectiveUserIdProvider);

      // Generate learning path from gaps
      final path = await learningPathGenerator.generatePathFromAnalysis(
        studentId: studentId,
        subjectId: subjectId,
        subjectName: subjectName,
        targetGrade: targetGrade,
        gaps: gaps,
      );

      // Dismiss loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        logger.info('[Recommendations] Generated path with ${path.nodes.length} nodes');

        // Navigate to FoundationPathScreen with generated path
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FoundationPathScreen.withPath(
              initialPath: path,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.error('[Recommendations] Failed to generate learning path', e, stackTrace);

      // Dismiss loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        context.showSnackBar(
          'Failed to generate learning path. Please try again.',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  /// Handle browse videos
  void _handleBrowseVideos(BuildContext context) {
    logger.info('[Recommendations] Opening video browser');

    // Navigate to video browsing screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendedVideosScreen(bundle: bundle),
      ),
    );
  }
}

/// Individual recommendation card
class _RecommendationCard extends StatelessWidget {
  final QuizRecommendation recommendation;
  final int index;
  final AssessmentType assessmentType;

  const _RecommendationCard({
    required this.recommendation,
    required this.index,
    required this.assessmentType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with rank, severity, and concept name
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: _getSeverityColor(recommendation.severity).withValues(alpha: 0.1),
              border: Border(
                left: BorderSide(
                  color: _getSeverityColor(recommendation.severity),
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Rank badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: assessmentType.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: assessmentType.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    // Severity badge
                    _SeverityBadge(severity: recommendation.severity),
                    const Spacer(),
                    // Time estimate
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recommendation.formattedTimeEstimate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                // Concept name
                Text(
                  recommendation.conceptName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                // Mastery progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Mastery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${recommendation.masteryPercentage.toInt()}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: recommendation.masteryPercentage / 100,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        _getMasteryColor(recommendation.masteryPercentage),
                      ),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Why it matters section
          if (recommendation.blockingImpact > 0)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: assessmentType.primaryColor,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      recommendation.whyItMatters,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Recommended videos
          if (recommendation.hasVideos) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                0,
                AppTheme.spacingSm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    'Recommended Videos (${recommendation.videoCount})',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // CRITICAL FIX: Remove ScrollView wrapper - it blocks tap events
            // Use Wrap widget to handle overflow gracefully without blocking taps
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                0,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < recommendation.recommendedVideos.length; i++) ...[
                      _VideoThumbnailCard(video: recommendation.recommendedVideos[i]),
                      if (i < recommendation.recommendedVideos.length - 1)
                        const SizedBox(width: AppTheme.spacingMd),
                    ],
                  ],
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Text(
                'Videos will be available soon for this topic',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getSeverityColor(GapSeverity severity) {
    return SemanticColors.getSeverityColor(severity);
  }

  Color _getMasteryColor(double mastery) {
    return SemanticColors.getScoreColor(mastery);
  }
}

/// Video thumbnail card
class _VideoThumbnailCard extends StatelessWidget {
  final Video video;

  const _VideoThumbnailCard({required this.video});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // CRITICAL FIX: Use Card + InkWell pattern (same as RecommendedVideosScreen which works)
    // This pattern has proven to work reliably on both iOS and Android
    return SizedBox(
      width: 280,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => _handleVideoTap(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video thumbnail with play button overlay
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Thumbnail image
                      CachedNetworkImage(
                        imageUrl: video.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildVideoPlaceholder(context, colorScheme),
                        errorWidget: (context, url, error) => _buildVideoPlaceholder(context, colorScheme),
                      ),
                      // Dark overlay for better play button visibility
                      Container(
                        color: AppTheme.darkSurface.withValues(alpha: 0.3),
                      ),
                      // Play button overlay (wrapped in IgnorePointer so taps pass through)
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.darkSurface.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      // Duration badge (wrapped in IgnorePointer so taps pass through)
                      if (video.durationDisplay.isNotEmpty)
                        IgnorePointer(
                          child: Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.darkSurface.withValues(alpha: 0.87),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.durationDisplay,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Video title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  video.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build placeholder for videos without thumbnails
  Widget _buildVideoPlaceholder(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_display,
            size: 64,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(height: 8),
          Text(
            'Video Available',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to play',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  void _handleVideoTap(BuildContext context) {
    logger.info('[Recommendations] Opening video: ${video.id} (YouTube ID: ${video.youtubeId})');

    try {
      final videoPath = RouteConstants.getVideoPath(video.youtubeId);
      logger.debug('[Recommendations] Navigating to: $videoPath');
      context.push(videoPath);
    } catch (e, stackTrace) {
      logger.error('[Recommendations] Failed to navigate to video', e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening video: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}

/// Severity badge widget
class _SeverityBadge extends StatelessWidget {
  final GapSeverity severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, icon) = _getSeverityStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            severity.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getSeverityStyle() {
    switch (severity) {
      case GapSeverity.critical:
        return (AppTheme.severityCritical, Icons.error_outline);
      case GapSeverity.severe:
        return (AppTheme.severitySevere, Icons.warning_amber_outlined);
      case GapSeverity.moderate:
        return (AppTheme.severityModerate, Icons.info_outline);
      case GapSeverity.mild:
        return (AppTheme.severityMild, Icons.lightbulb_outline);
    }
  }
}
