import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_provider.dart';
import 'package:crack_the_code/presentation/providers/user/quiz_history_provider.dart';
import 'package:crack_the_code/presentation/providers/pedagogy/recommendations_provider.dart';
import 'package:crack_the_code/presentation/screens/quiz/widgets/confetti_animation.dart';
import 'package:crack_the_code/presentation/screens/quiz/widgets/concept_performance_chart.dart';
import 'package:crack_the_code/presentation/widgets/quiz/assessment_context_indicator.dart';
import 'package:crack_the_code/presentation/widgets/pedagogy/recommendations_preview_card.dart';
import 'package:crack_the_code/presentation/widgets/quiz/post_quiz_actions_card.dart';
import 'package:crack_the_code/domain/entities/pedagogy/learning_path_context.dart';
import 'package:crack_the_code/presentation/providers/auth/user_id_provider.dart';

// Extracted widgets
import 'package:crack_the_code/presentation/screens/quiz/widgets/results/results_widgets.dart';

/// Quiz Results Screen - Comprehensive results display with performance analysis
class QuizResultsScreen extends ConsumerStatefulWidget {
  final String entityId;
  final QuizResult? result;
  final String assessmentType;
  final LearningPathContext? pathContext;
  final String? recommendationsHistoryId;

  const QuizResultsScreen({
    super.key,
    required this.entityId,
    this.result,
    this.assessmentType = 'knowledge',
    this.pathContext,
    this.recommendationsHistoryId,
  });

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _confettiController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _fadeInAnimation;

  late QuizResult _result;
  bool _showConfetti = false;
  bool _hasError = false;
  String? _errorMessage;
  final Map<String, Question> _questionsCache = {};
  QuizSession? _cachedSession;
  late final AssessmentType _assessmentType;

  @override
  void initState() {
    super.initState();
    _assessmentType =
        AssessmentTypeExtension.fromQueryValue(widget.assessmentType);
    _initializeResult();
    _loadQuestions();
    _initializeAnimations();
    _startAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRecommendations();
    });
  }

  void _initializeResult() {
    if (widget.result != null) {
      _result = widget.result!;
      _hasError = false;
    } else {
      final providerResult = ref.read(quizProvider).lastResult;
      if (providerResult != null) {
        _result = providerResult;
        _hasError = false;
      } else {
        logger.warning(
            'Quiz results not available - both widget.result and provider.lastResult are null');
        _hasError = true;
        _errorMessage =
            'Quiz results are no longer available.\n\nThis may happen if you navigated away and returned.\nPlease take the quiz again to see results.';
        _result = QuizResult(
          sessionId: widget.entityId,
          totalQuestions: 0,
          correctAnswers: 0,
          scorePercentage: 0,
          passed: false,
          questionResults: {},
          timeTaken: Duration.zero,
          evaluatedAt: DateTime.now(),
        );
      }
    }
  }

  void _initializeAnimations() {
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0.0, end: _result.scorePercentage)
        .animate(CurvedAnimation(
      parent: _scoreAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scoreAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scoreAnimationController.forward();
        if (_result.passed) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() => _showConfetti = true);
              _confettiController.forward();
            }
          });
        }
      }
    });
  }

  Future<void> _loadQuestions() async {
    logger.info('[QuizResults] Loading questions for entityId: ${widget.entityId}');

    if (_result.questions != null && _result.questions!.isNotEmpty) {
      logger.info(
          '[QuizResults] ✓ Found ${_result.questions!.length} questions in quiz result');
      for (final question in _result.questions!) {
        _questionsCache[question.id] = question;
      }

      if (_cachedSession == null) {
        final answersMap = _result.answers ?? <String, String>{};
        _cachedSession = QuizSession(
          id: _result.sessionId,
          quizId: widget.entityId,
          studentId: 'student',
          questions: _result.questions!,
          answers: answersMap,
          state: QuizSessionState.completed,
          currentQuestionIndex: 0,
          startTime: _result.evaluatedAt,
        );
      }

      if (mounted) setState(() {});
      return;
    }

    final quizSession = ref.read(quizProvider).activeSession;
    if (quizSession != null && quizSession.questions.isNotEmpty) {
      _cachedSession = quizSession;
      for (final question in quizSession.questions) {
        _questionsCache[question.id] = question;
      }
      return;
    }

    try {
      final repository = ref.read(quizRepositoryProvider);
      final result = await repository.resumeSession(_result.sessionId);
      result.fold(
        (failure) => logger.error(
            '[QuizResults] ✗ Failed to load session: ${failure.message}'),
        (session) {
          _cachedSession = session;
          for (final question in session.questions) {
            _questionsCache[question.id] = question;
          }
          if (mounted) setState(() {});
        },
      );
    } catch (e, stackTrace) {
      logger.error('[QuizResults] ✗ Exception loading questions: $e', e, stackTrace);
    }
  }

  Future<void> _generateRecommendations() async {
    if (widget.result != null) {
      bool loaded = false;
      if (widget.recommendationsHistoryId != null) {
        loaded = await ref.read(recommendationsProvider.notifier).loadByHistoryId(
              historyId: widget.recommendationsHistoryId!,
            );
        if (loaded) return;
      }
      if (!loaded) {
        loaded = await ref.read(recommendationsProvider.notifier).loadFromDatabase(
              quizAttemptId: _result.sessionId,
            );
        if (loaded) return;
      }
    }

    if (_assessmentType != AssessmentType.readiness) {
      if (!_result.hasWeakAreas && !_result.hasConceptAnalysis) return;
    }

    final studentId = ref.read(effectiveUserIdProvider);
    ref.read(recommendationsProvider.notifier).generateFromQuizResult(
          quizResult: _result,
          studentId: studentId,
          assessmentType: _assessmentType,
        );
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _buildErrorState(context);

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResultsHeroSection(
                  result: _result,
                  assessmentType: _assessmentType,
                  scoreAnimation: _scoreAnimation,
                  fadeInAnimation: _fadeInAnimation,
                  compact: true,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                ResultsPerformanceCard(result: _result),
                const SizedBox(height: AppTheme.spacingMd),
                if (_result.hasConceptAnalysis) ...[
                  _buildConceptAnalysisCard(),
                  const SizedBox(height: AppTheme.spacingMd),
                ],
                if (_assessmentType == AssessmentType.readiness ||
                    _result.hasWeakAreas) ...[
                  _buildRecommendationsSection(),
                  const SizedBox(height: AppTheme.spacingMd),
                ],
                _buildPostQuizActionsCard(),
                const SizedBox(height: AppTheme.spacingMd),
                ResultsQuestionReviewCard(
                  result: _result,
                  questionsCache: _questionsCache,
                  cachedSession: _cachedSession,
                ),
                const SizedBox(height: AppTheme.spacingXl),
              ],
            ),
          ),
          if (_showConfetti) _buildConfetti(),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(vertical: true),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResultsHeroSection(
                  result: _result,
                  assessmentType: _assessmentType,
                  scoreAnimation: _scoreAnimation,
                  fadeInAnimation: _fadeInAnimation,
                ),
                const SizedBox(height: AppTheme.spacingXl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ResultsPerformanceCard(result: _result)),
                    const SizedBox(width: AppTheme.spacingMd),
                    if (_result.hasConceptAnalysis)
                      Expanded(child: _buildConceptAnalysisCard()),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingLg),
                ResultsQuestionReviewCard(
                  result: _result,
                  questionsCache: _questionsCache,
                  cachedSession: _cachedSession,
                ),
                const SizedBox(height: AppTheme.spacingXl),
              ],
            ),
          ),
          if (_showConfetti) _buildConfetti(),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(vertical: false),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ResultsHeroSection(
                      result: _result,
                      assessmentType: _assessmentType,
                      scoreAnimation: _scoreAnimation,
                      fadeInAnimation: _fadeInAnimation,
                      large: true,
                    ),
                    const SizedBox(height: AppTheme.spacingXxl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ResultsPerformanceCard(
                              result: _result, enhanced: true),
                        ),
                        const SizedBox(width: AppTheme.spacingLg),
                        if (_result.hasConceptAnalysis)
                          Expanded(
                            flex: 3,
                            child: _buildConceptAnalysisCard(enhanced: true),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    ResultsQuestionReviewCard(
                      result: _result,
                      questionsCache: _questionsCache,
                      cachedSession: _cachedSession,
                      enhanced: true,
                    ),
                    const SizedBox(height: AppTheme.spacingXxl),
                    _buildActionButtons(vertical: false, enhanced: true),
                  ],
                ),
              ),
            ),
          ),
          if (_showConfetti) _buildConfetti(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _assessmentType.iconFilled,
            color: _assessmentType.primaryColor,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Flexible(
            child: Text(
              '${_assessmentType.displayName} Results',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _handleExit,
        tooltip: 'Close',
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppTheme.spacingXs),
          child: AssessmentContextIndicator(
            assessmentType: _assessmentType,
            displayMode: AssessmentContextDisplayMode.badge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: _handleShare,
          tooltip: 'Share Results',
        ),
      ],
    );
  }

  Widget _buildConceptAnalysisCard({bool enhanced = false}) {
    return Card(
      child: Padding(
        padding:
            EdgeInsets.all(enhanced ? AppTheme.spacingLg : AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: context.colorScheme.primary,
                  size: enhanced ? 28 : 24,
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Concept Analysis',
                  style: (enhanced
                          ? context.textTheme.titleLarge
                          : context.textTheme.titleMedium)
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            if (_result.conceptAnalysis != null)
              ConceptPerformanceChart(
                conceptScores: _result.conceptAnalysis!,
                height: enhanced ? 200 : 150,
              ),
            if (_result.hasStrongAreas) ...[
              const SizedBox(height: AppTheme.spacingLg),
              _buildConceptSection(
                title: 'Strong Areas',
                icon: Icons.check_circle,
                color: AppTheme.successColor,
                concepts: _result.strongAreas!,
              ),
            ],
            if (_result.hasWeakAreas) ...[
              const SizedBox(height: AppTheme.spacingMd),
              _buildConceptSection(
                title: 'Areas to Improve',
                icon: Icons.trending_up,
                color: AppTheme.warningColor,
                concepts: _result.weakAreas!,
              ),
            ],
            if (_result.recommendation != null) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(
                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: context.colorScheme.primary, size: 20),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(_result.recommendation!,
                          style: context.textTheme.bodySmall),
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

  Widget _buildConceptSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> concepts,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Wrap(
          spacing: AppTheme.spacingXs,
          runSpacing: AppTheme.spacingXs,
          children: concepts.map((concept) {
            return Chip(
              label: Text(concept, style: context.textTheme.labelSmall),
              backgroundColor: color.withValues(alpha: 0.1),
              side: BorderSide(color: color.withValues(alpha: 0.3)),
              visualDensity: VisualDensity.compact,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingXs),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Consumer(
      builder: (context, ref, child) {
        final recState = ref.watch(recommendationsProvider);

        if (recState.isLoading) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Analyzing your performance...',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (recState.error != null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: context.colorScheme.error),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'Failed to generate recommendations',
                    style: context.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    recState.error!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  FilledButton.icon(
                    onPressed: _generateRecommendations,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (recState.hasRecommendations) {
          return RecommendationsPreviewCard(
            bundle: recState.bundle!,
            assessmentType: _assessmentType,
            onViewAll: _handleViewRecommendations,
          );
        }

        final shouldShowCongratulations = !_result.hasWeakAreas &&
            (_assessmentType != AssessmentType.readiness ||
                _result.scorePercentage >= 80);

        if (shouldShowCongratulations) {
          return Card(
            color: _assessmentType == AssessmentType.readiness
                ? AppTheme.readinessAssessment.withValues(alpha: 0.1)
                : AppTheme.practiceAssessment.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.celebration,
                    size: 48,
                    color: _assessmentType == AssessmentType.readiness
                        ? AppTheme.readinessAssessment
                        : AppTheme.practiceAssessment,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    _assessmentType == AssessmentType.readiness
                        ? 'Excellent Foundation!'
                        : 'Perfect Score!',
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    _assessmentType == AssessmentType.readiness
                        ? 'You\'re ready to learn new concepts! Your foundation is strong.'
                        : 'You\'ve mastered this content! Keep up the great work.',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPostQuizActionsCard() {
    return PostQuizActionsCard(
      passed: _result.passed,
      scorePercentage: _result.scorePercentage,
      onReviewAnswers: _questionsCache.isNotEmpty ? _handleExpandAllQuestions : null,
      onNextTopic: _result.passed ? _handleContinueLearning : null,
      onTakeAnotherQuiz: _result.passed ? _handleTakeAnotherQuiz : null,
      onWatchVideos: !_result.passed ? _handleWatchVideos : null,
      onRetryQuiz: !_result.passed ? _handleRetry : null,
      onContinuePath: widget.pathContext != null ? _handleContinuePath : null,
      isInLearningPath: widget.pathContext != null,
    );
  }

  Widget _buildActionButtons({
    required bool vertical,
    bool enhanced = false,
  }) {
    final buttons = <Widget>[
      if (!_result.passed)
        ElevatedButton.icon(
          onPressed: _handleRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry Quiz'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(enhanced ? 160 : 120, AppTheme.minTouchTarget),
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: context.colorScheme.onPrimary,
          ),
        ),
      if (_result.hasWeakAreas) ...[
        if (vertical)
          const SizedBox(height: AppTheme.spacingSm)
        else
          const SizedBox(width: AppTheme.spacingSm),
        OutlinedButton.icon(
          onPressed: _handleViewRecommendations,
          icon: const Icon(Icons.video_library),
          label: const Text('Review Topics'),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(enhanced ? 160 : 120, AppTheme.minTouchTarget),
            foregroundColor: context.colorScheme.primary,
            side: BorderSide(color: context.colorScheme.primary, width: 2),
          ),
        ),
      ],
      if (vertical)
        const SizedBox(height: AppTheme.spacingSm)
      else
        const SizedBox(width: AppTheme.spacingSm),
      if (widget.pathContext != null)
        ElevatedButton.icon(
          onPressed: _handleContinuePath,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Continue Path'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(enhanced ? 160 : 120, AppTheme.minTouchTarget),
            backgroundColor: AppTheme.successColor,
          ),
        )
      else
        OutlinedButton.icon(
          onPressed: _handleContinueLearning,
          icon: const Icon(Icons.arrow_forward),
          label: Text(_result.passed ? 'Continue Learning' : 'Back to Content'),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(enhanced ? 160 : 120, AppTheme.minTouchTarget),
            foregroundColor: context.colorScheme.primary,
            side: BorderSide(color: context.colorScheme.primary, width: 2),
          ),
        ),
    ];

    if (vertical) {
      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            border: Border(top: BorderSide(color: context.colorScheme.outline)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttons,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: buttons,
        ),
      );
    }
  }

  Widget _buildConfetti() {
    return IgnorePointer(
      child: ConfettiAnimation(controller: _confettiController),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: AppTheme.errorColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: AppTheme.errorColor),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                'Results Unavailable',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.errorColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                _errorMessage ?? 'Quiz results could not be loaded.',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXl),
              FilledButton.icon(
                onPressed: () => context.go(RouteConstants.home),
                icon: const Icon(Icons.home),
                label: const Text('Return Home'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  minimumSize: const Size(200, AppTheme.minTouchTarget),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              OutlinedButton.icon(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go(RouteConstants.home);
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, AppTheme.minTouchTarget),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handler methods
  void _handleExpandAllQuestions() {
    // Scroll to question review section - handled by the card itself
  }

  void _handleTakeAnotherQuiz() => context.go(RouteConstants.practice);

  void _handleWatchVideos() {
    context.go('/browse');
    if (_result.topicName != null) {
      context.showSnackBar(
        'Review videos for "${_result.topicName}" in the content browser',
        backgroundColor: context.colorScheme.primary,
      );
    }
  }

  Future<void> _handleRetry() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retry Quiz?'),
        content: const Text(
          'Are you sure you want to retry this quiz? Your current results will be saved in history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            child: const Text('Retry'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (mounted) {
      if (widget.entityId == 'daily_challenge') {
        context.go(RouteConstants.home);
        context.showSnackBar(
          'Daily challenge reset. Click the Daily Challenge card to retry!',
          backgroundColor: context.colorScheme.primary,
        );
      } else {
        context.go(RouteConstants.getQuizPath(widget.entityId, 'student'));
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(quizProvider.notifier).clearLastResult();
        ref.read(quizProvider.notifier).clearActiveSession();
      });
    }
  }

  void _handleViewRecommendations() {
    final recState = ref.read(recommendationsProvider);
    if (!recState.hasRecommendations) {
      context.showSnackBar(
        'Generating recommendations...',
        backgroundColor: context.colorScheme.primary,
      );
      return;
    }
    context.push(RouteConstants.recommendations, extra: recState.bundle);
  }

  void _handleContinueLearning() {
    if (widget.entityId == 'daily_challenge') {
      context.go(RouteConstants.home);
    } else {
      Navigator.of(context).pop();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(quizProvider.notifier).clearLastResult();
      ref.read(quizProvider.notifier).clearActiveSession();
    });
  }

  void _handleContinuePath() {
    if (widget.pathContext == null) return;

    ref.read(quizProvider.notifier).clearLastResult();
    ref.read(quizProvider.notifier).clearActiveSession();

    Navigator.of(context).pop(
      CompletionResult.quiz(
        nodeId: widget.pathContext!.nodeId,
        scorePercentage: _result.scorePercentage,
        timeSpent: _result.timeTaken.inSeconds,
        passed: _result.passed,
        correctAnswers: _result.correctAnswers,
        totalQuestions: _result.totalQuestions,
      ),
    );
  }

  void _handleShare() {
    context.showSnackBar(
      'Share feature coming soon!',
      backgroundColor: context.colorScheme.primary,
    );
  }

  void _handleExit() {
    if (widget.entityId == 'daily_challenge') {
      context.go(RouteConstants.home);
    } else {
      Navigator.of(context).pop();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(quizProvider.notifier).clearLastResult();
      ref.read(quizProvider.notifier).clearActiveSession();
    });
  }
}
