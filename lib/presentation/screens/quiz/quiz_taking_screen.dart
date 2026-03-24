import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';
import 'package:streamshaala/presentation/providers/user/quiz_provider.dart';
import 'package:streamshaala/domain/entities/pedagogy/learning_path_context.dart';
import 'package:streamshaala/presentation/providers/pedagogy/learning_path_provider.dart';

// Extracted widgets
import 'package:streamshaala/presentation/screens/quiz/widgets/quiz_widgets.dart';

/// Quiz Taking Screen - Comprehensive quiz interface
/// Supports all question types with responsive layouts
///
/// Supports two assessment types:
/// - 'readiness': PRE-assessment for gap analysis (before learning)
/// - 'knowledge': POST-assessment for validation (after learning)
class QuizTakingScreen extends ConsumerStatefulWidget {
  final String entityId;
  final String studentId;
  final String assessmentType;
  final LearningPathContext? pathContext;

  const QuizTakingScreen({
    super.key,
    required this.entityId,
    required this.studentId,
    this.assessmentType = 'knowledge',
    this.pathContext,
  });

  @override
  ConsumerState<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends ConsumerState<QuizTakingScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _questionTransitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _textAnswerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State variables
  bool _isSubmitting = false;
  Timer? _quizTimer;
  int _remainingSeconds = 0;
  bool _isNavigating = false;
  String? _currentQuestionId;
  late final AssessmentType _assessmentType;
  DateTime? _quizStartTime;

  @override
  void initState() {
    super.initState();
    _assessmentType =
        AssessmentTypeExtension.fromQueryValue(widget.assessmentType);
    _initializeAnimations();
    _checkForActiveSession();
    if (widget.pathContext != null) {
      _quizStartTime = DateTime.now();
    }
  }

  void _initializeAnimations() {
    _questionTransitionController = AnimationController(
      duration: AppTheme.animationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _questionTransitionController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _questionTransitionController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Future<void> _checkForActiveSession() async {
    final quizState = ref.read(quizProvider);
    final session = quizState.activeSession;

    if (session != null &&
        session.quizId == widget.entityId &&
        session.studentId == widget.studentId &&
        session.state == QuizSessionState.inProgress &&
        session.answers.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          QuizDialogs.showResumeDialog(
            context: context,
            session: session,
            onResume: () => _resumeSession(session),
            onStartFresh: _startFreshQuiz,
          );
        }
      });
    } else {
      _loadQuiz();
    }
  }

  Future<void> _startFreshQuiz() async {
    ref.read(quizProvider.notifier).clearActiveSession();
    _loadQuiz();
  }

  void _resumeSession(QuizSession session) {
    if (session.currentQuestion != null) {
      setState(() {
        _currentQuestionId = session.currentQuestion!.id;
      });
      _startTimer(session);
      _questionTransitionController.value = 1.0;
    }
  }

  Future<void> _loadQuiz() async {
    await Future.microtask(() async {
      await ref.read(quizProvider.notifier).loadQuiz(
            entityId: widget.entityId,
            studentId: widget.studentId,
            assessmentType: _assessmentType,
          );

      final quizState = ref.read(quizProvider);
      if (quizState.activeSession != null && mounted) {
        _startTimer(quizState.activeSession!);
        _questionTransitionController.value = 1.0;
      }
    });
  }

  void _startTimer(QuizSession session) {
    _remainingSeconds = 600; // 10 minutes placeholder
    _quizTimer?.cancel();
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
            QuizDialogs.showTimeUpDialog(
              context: context,
              onSubmit: _submitQuiz,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _questionTransitionController.dispose();
    _textAnswerController.dispose();
    _scrollController.dispose();
    _quizTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    if (quizState.isLoading && !quizState.hasActiveSession) {
      return const QuizLoadingScaffold();
    }

    if (quizState.error != null && !quizState.hasActiveSession) {
      return QuizErrorScaffold(
        error: quizState.error!,
        onRetry: _loadQuiz,
      );
    }

    if (!quizState.hasActiveSession) {
      return const QuizNoSessionScaffold();
    }

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(quizState);
          case DeviceType.tablet:
            return _buildTabletLayout(quizState);
          case DeviceType.desktop:
            return _buildDesktopLayout(quizState);
        }
      },
    );
  }

  Widget _buildMobileLayout(QuizState quizState) {
    final session = quizState.activeSession!;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildAppBar(session, compact: true),
        body: SafeArea(
          child: Column(
            children: [
              QuizProgressBar(
                progressPercentage: quizState.progressPercentage,
                assessmentType: _assessmentType,
              ),
              if (session.currentQuestionIndex == 0)
                QuizAssessmentContextHelper(
                  assessmentType: _assessmentType,
                  compact: true,
                ),
              Expanded(
                child: IgnorePointer(
                  ignoring: _isNavigating,
                  child: _buildQuestionContent(session),
                ),
              ),
              QuizNavigationButtons(
                session: session,
                isSubmitting: _isSubmitting,
                isNavigating: _isNavigating,
                onPrevious: _previousQuestion,
                onNext: _nextQuestion,
                onSubmit: _submitQuiz,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            onPressed: () => showMobileQuestionNavigator(
              context: context,
              session: session,
              isNavigating: _isNavigating,
              onQuestionTap: _navigateToQuestion,
            ),
            tooltip: 'Jump to Question',
            child: const Icon(Icons.list_alt),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(QuizState quizState) {
    final session = quizState.activeSession!;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildAppBar(session, compact: false),
        body: SafeArea(
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: QuizNavigationSidebar(
                  session: session,
                  isNavigating: _isNavigating,
                  onQuestionTap: _navigateToQuestion,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    QuizProgressBar(
                      progressPercentage: quizState.progressPercentage,
                      assessmentType: _assessmentType,
                    ),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: _isNavigating,
                        child: _buildQuestionContent(session, enhanced: false),
                      ),
                    ),
                    QuizNavigationButtons(
                      session: session,
                      isSubmitting: _isSubmitting,
                      isNavigating: _isNavigating,
                      onPrevious: _previousQuestion,
                      onNext: _nextQuestion,
                      onSubmit: _submitQuiz,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(QuizState quizState) {
    final session = quizState.activeSession!;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildAppBar(session, compact: false),
        body: SafeArea(
          child: Row(
            children: [
              SizedBox(
                width: 280,
                child: QuizNavigationSidebar(
                  session: session,
                  enhanced: true,
                  isNavigating: _isNavigating,
                  onQuestionTap: _navigateToQuestion,
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      children: [
                        QuizProgressBar(
                          progressPercentage: quizState.progressPercentage,
                          assessmentType: _assessmentType,
                        ),
                        Expanded(
                          child: IgnorePointer(
                            ignoring: _isNavigating,
                            child:
                                _buildQuestionContent(session, enhanced: true),
                          ),
                        ),
                        QuizNavigationButtons(
                          session: session,
                          isSubmitting: _isSubmitting,
                          isNavigating: _isNavigating,
                          enhanced: true,
                          onPrevious: _previousQuestion,
                          onNext: _nextQuestion,
                          onSubmit: _submitQuiz,
                        ),
                      ],
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

  PreferredSizeWidget _buildAppBar(QuizSession session, {bool compact = false}) {
    final hasBackup =
        session.answersBackup != null && session.answersBackup!.isNotEmpty;

    return QuizAppBar(
      session: session,
      assessmentType: _assessmentType,
      entityId: widget.entityId,
      remainingSeconds: _remainingSeconds,
      compact: compact,
      hasBackup: hasBackup,
      onPause: () => QuizDialogs.showPauseDialog(context),
      onClearAll: () => QuizDialogs.showClearAllConfirmation(
        context: context,
        ref: ref,
        session: session,
        onCleared: () => _textAnswerController.clear(),
      ),
      onRestore: hasBackup
          ? () => QuizDialogs.showRestoreConfirmation(
                context: context,
                ref: ref,
                session: session,
                onRestored: _updateTextControllerFromSession,
              )
          : null,
    );
  }

  Widget _buildQuestionContent(QuizSession session, {bool enhanced = false}) {
    final currentQuestion = session.currentQuestion;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(enhanced ? AppTheme.spacingXl : AppTheme.spacingMd),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            key: ValueKey(
                'question_content_${currentQuestion?.id ?? 'none'}_${session.currentQuestionIndex}'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentQuestion != null) ...[
                QuizQuestionHeader(
                  question: currentQuestion,
                  questionIndex: session.currentQuestionIndex,
                  totalQuestions: session.questions.length,
                ),
                SizedBox(
                    height: enhanced ? AppTheme.spacingLg : AppTheme.spacingMd),
                _buildQuestionText(currentQuestion, large: enhanced),
                SizedBox(
                    height: enhanced ? AppTheme.spacingXl : AppTheme.spacingLg),
                _buildAnswerSection(currentQuestion, enhanced: enhanced),
                if (currentQuestion.hasHints) ...[
                  SizedBox(
                      height:
                          enhanced ? AppTheme.spacingLg : AppTheme.spacingMd),
                  QuizHintSection(
                    question: currentQuestion,
                    enhanced: enhanced,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionText(Question question, {bool large = false}) {
    return SelectableText(
      question.questionText,
      style: large
          ? context.textTheme.headlineSmall
          : context.textTheme.bodyLarge?.copyWith(height: 1.5),
    );
  }

  Widget _buildAnswerSection(Question question, {bool enhanced = false}) {
    final session = ref.watch(quizProvider).activeSession;
    final hasAnswer = session?.answers.containsKey(question.id) ?? false;

    Widget answerWidget;
    switch (question.questionType) {
      case QuestionType.mcq:
        answerWidget = MultipleChoiceAnswers(
          question: question,
          enhanced: enhanced,
        );
        break;
      case QuestionType.trueFalse:
        answerWidget = TrueFalseAnswers(
          question: question,
          enhanced: enhanced,
        );
        break;
      case QuestionType.fillBlank:
        answerWidget = FillInBlankAnswer(
          question: question,
          controller: _textAnswerController,
          enhanced: enhanced,
        );
        break;
      case QuestionType.numerical:
        answerWidget = NumericalAnswer(
          question: question,
          controller: _textAnswerController,
          enhanced: enhanced,
        );
        break;
      case QuestionType.match:
        answerWidget = MatchingAnswers(
          question: question,
          enhanced: enhanced,
        );
        break;
    }

    final wrappedAnswerWidget = AbsorbPointer(
      absorbing: _isNavigating,
      child: answerWidget,
    );

    return Column(
      key: ValueKey('answer_section_${question.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        wrappedAnswerWidget,
        if (hasAnswer && !_isNavigating) ...[
          const SizedBox(height: AppTheme.spacingMd),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(quizProvider.notifier).clearAnswer(
                    questionId: question.id,
                  );
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Answer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.error,
              side: BorderSide(color: context.colorScheme.error),
            ),
          ),
        ],
      ],
    );
  }

  void _updateTextControllerFromSession() {
    final updatedSession = ref.read(quizProvider).activeSession;
    if (updatedSession != null && updatedSession.currentQuestion != null) {
      final restoredAnswer =
          updatedSession.getAnswer(updatedSession.currentQuestion!.id);
      if (restoredAnswer != null) {
        _textAnswerController.text = restoredAnswer;
      } else {
        _textAnswerController.clear();
      }
    }
  }

  Future<void> _navigateToQuestion(int index) async {
    final session = ref.read(quizProvider).activeSession;
    if (session == null || index == session.currentQuestionIndex) return;

    setState(() {
      _isNavigating = true;
    });

    await _questionTransitionController.reverse();

    ref.read(quizProvider.notifier).navigateToQuestion(index);

    final updatedSession = ref.read(quizProvider).activeSession;
    if (updatedSession != null && updatedSession.currentQuestion != null) {
      final previousAnswer =
          updatedSession.answers[updatedSession.currentQuestion!.id];

      setState(() {
        if (previousAnswer != null) {
          _textAnswerController.text = previousAnswer;
        } else {
          _textAnswerController.clear();
        }
      });
    }

    await _questionTransitionController.forward();

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      final newSession = ref.read(quizProvider).activeSession;
      setState(() {
        _isNavigating = false;
        _currentQuestionId = newSession?.currentQuestion?.id;
      });
    }
  }

  Future<void> _previousQuestion() async {
    final session = ref.read(quizProvider).activeSession;
    if (session == null || session.isFirstQuestion) return;
    await _navigateToQuestion(session.currentQuestionIndex - 1);
  }

  Future<void> _nextQuestion() async {
    final session = ref.read(quizProvider).activeSession;
    if (session == null || session.isLastQuestion) return;

    setState(() => _isSubmitting = true);
    await _navigateToQuestion(session.currentQuestionIndex + 1);
    if (!mounted) return;
    setState(() => _isSubmitting = false);
  }

  Future<void> _submitQuiz() async {
    final confirm = await QuizDialogs.showSubmitConfirmation(context);
    if (confirm != true) return;

    setState(() => _isSubmitting = true);

    await ref.read(quizProvider.notifier).completeQuiz();

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final quizState = ref.read(quizProvider);

    if (quizState.lastResult != null) {
      if (widget.pathContext != null) {
        final timeSpent = _quizStartTime != null
            ? DateTime.now().difference(_quizStartTime!).inSeconds
            : 0;

        await ref.read(learningPathProvider.notifier).completeNode(
              nodeId: widget.pathContext!.nodeId,
              score: quizState.lastResult!.scorePercentage,
              metadata: {
                'type': 'quiz',
                'passed': quizState.lastResult!.passed,
                'correctAnswers': quizState.lastResult!.correctAnswers,
                'totalQuestions': quizState.lastResult!.totalQuestions,
                'timeSpent': timeSpent,
              },
            );
      }

      if (mounted) {
        final baseResultsPath =
            RouteConstants.getQuizResultsPath(widget.entityId, widget.studentId);
        final resultsPath =
            '$baseResultsPath?type=${_assessmentType.queryValue}';

        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          context.push(
            resultsPath,
            extra: {
              'result': quizState.lastResult,
              'pathContext': widget.pathContext,
            },
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error: Could not load quiz results. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    final confirm = await QuizDialogs.showExitConfirmation(context);
    return confirm ?? false;
  }
}
