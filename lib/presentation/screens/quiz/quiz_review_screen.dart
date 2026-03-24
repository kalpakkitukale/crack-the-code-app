import 'package:flutter/material.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';

/// Quiz Review Screen - Dedicated full-screen interface for reviewing quiz answers
///
/// Features:
/// - Question-by-question navigation with swipe gestures
/// - Visual indication of correct/incorrect answers
/// - Detailed explanations for each question
/// - Filter to show only wrong answers
/// - Progress indicator
/// - Concept tags and difficulty display
class QuizReviewScreen extends StatefulWidget {
  final QuizResult result;
  final bool showWrongOnly;

  const QuizReviewScreen({
    super.key,
    required this.result,
    this.showWrongOnly = false,
  });

  @override
  State<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  late PageController _pageController;
  late List<Question> _questionsToShow;
  late Map<String, bool> _correctnessMap;
  int _currentIndex = 0;
  bool _showWrongOnly = false;

  @override
  void initState() {
    super.initState();
    _showWrongOnly = widget.showWrongOnly;
    _initializeQuestions();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializeQuestions() {
    // Build correctness map
    _correctnessMap = {};
    final questions = widget.result.questions ?? [];
    final answers = widget.result.answers ?? {};

    for (final question in questions) {
      final studentAnswer = answers[question.id] ?? '';
      _correctnessMap[question.id] = question.isCorrect(studentAnswer);
    }

    // Filter questions based on showWrongOnly
    _questionsToShow = _showWrongOnly
        ? questions.where((q) => _correctnessMap[q.id] == false).toList()
        : questions;
  }

  void _toggleFilter() {
    setState(() {
      _showWrongOnly = !_showWrongOnly;
      _currentIndex = 0;
      _initializeQuestions();
      _pageController.jumpToPage(0);
    });
  }

  void _goToQuestion(int index) {
    if (index >= 0 && index < _questionsToShow.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questionsToShow.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Review'),
        ),
        body: _buildEmptyState(),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questionsToShow.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildQuestionReviewPage(
                  _questionsToShow[index],
                  index,
                );
              },
            ),
          ),
          _buildNavigationBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Quiz Review'),
      actions: [
        // Filter toggle button
        IconButton(
          icon: Icon(
            _showWrongOnly ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: _showWrongOnly ? AppTheme.errorColor : null,
          ),
          tooltip: _showWrongOnly ? 'Show All Questions' : 'Show Wrong Answers Only',
          onPressed: _toggleFilter,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final total = _questionsToShow.length;
    final current = _currentIndex + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: context.theme.colorScheme.surface,
      child: Column(
        children: [
          // Progress bar
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: current / total,
                  backgroundColor: context.theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.colorScheme.primary,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$current / $total',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Filter indicator
          if (_showWrongOnly) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.errorColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt,
                    size: 16,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Showing Wrong Answers Only',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionReviewPage(Question question, int index) {
    final studentAnswer = widget.result.answers?[question.id] ?? '';
    final isCorrect = _correctnessMap[question.id] ?? false;

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(question, studentAnswer, isCorrect);
          case DeviceType.tablet:
          case DeviceType.desktop:
            return _buildTabletLayout(question, studentAnswer, isCorrect);
        }
      },
    );
  }

  Widget _buildMobileLayout(Question question, String studentAnswer, bool isCorrect) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question, isCorrect),
          const SizedBox(height: 16),
          _buildQuestionText(question),
          const SizedBox(height: 24),
          _buildOptionsSection(question, studentAnswer, isCorrect),
          const SizedBox(height: 24),
          _buildExplanationSection(question),
          const SizedBox(height: 80), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildTabletLayout(Question question, String studentAnswer, bool isCorrect) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: _buildMobileLayout(question, studentAnswer, isCorrect),
      ),
    );
  }

  Widget _buildQuestionHeader(Question question, bool isCorrect) {
    return Row(
      children: [
        // Result indicator
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCorrect
                ? AppTheme.successColor.withValues(alpha: 0.1)
                : AppTheme.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCorrect ? 'Correct Answer' : 'Incorrect Answer',
                style: context.textTheme.titleMedium?.copyWith(
                  color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildDifficultyChip(question.difficulty),
                  const SizedBox(width: 8),
                  Text(
                    '${question.points} point${question.points > 1 ? 's' : ''}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    if (difficulty.toLowerCase() == 'basic') {
      chipColor = Colors.green;
    } else if (difficulty.toLowerCase() == 'intermediate') {
      chipColor = Colors.orange;
    } else {
      chipColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildQuestionText(Question question) {
    return Card(
      elevation: 0,
      color: context.theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question',
              style: context.textTheme.labelLarge?.copyWith(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText,
              style: context.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            if (question.conceptTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: question.conceptTags.map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: context.textTheme.bodySmall,
                    ),
                    backgroundColor: context.theme.colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection(Question question, String studentAnswer, bool isCorrect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Answer Options',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final optionKey = String.fromCharCode(65 + index); // A, B, C, D...
          final isStudentAnswer = studentAnswer == optionKey;
          final isCorrectAnswer = question.correctAnswer == optionKey;

          Color? backgroundColor;
          Color? borderColor;
          IconData? icon;
          Color? iconColor;

          if (isCorrectAnswer) {
            backgroundColor = AppTheme.successColor.withValues(alpha: 0.1);
            borderColor = AppTheme.successColor;
            icon = Icons.check_circle;
            iconColor = AppTheme.successColor;
          } else if (isStudentAnswer && !isCorrect) {
            backgroundColor = AppTheme.errorColor.withValues(alpha: 0.1);
            borderColor = AppTheme.errorColor;
            icon = Icons.cancel;
            iconColor = AppTheme.errorColor;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor ?? context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor ?? context.theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: borderColor != null ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Option letter
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: borderColor?.withValues(alpha: 0.2) ??
                          context.theme.colorScheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: borderColor ?? context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: borderColor,
                        fontWeight: borderColor != null ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, color: iconColor, size: 24),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
        // Labels
        const SizedBox(height: 8),
        if (!isCorrect)
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  border: Border.all(color: AppTheme.errorColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Your answer',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.errorColor,
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  border: Border.all(color: AppTheme.successColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Correct answer',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildExplanationSection(Question question) {
    return Card(
      elevation: 0,
      color: context.theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Explanation',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.explanation,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    final canGoPrevious = _currentIndex > 0;
    final canGoNext = _currentIndex < _questionsToShow.length - 1;

    // Count wrong answers
    final wrongAnswersCount = _correctnessMap.values.where((isCorrect) => !isCorrect).length;
    final hasWrongAnswers = wrongAnswersCount > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Retry wrong answers button (only show if there are wrong answers)
            if (hasWrongAnswers && !_showWrongOnly)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleRetryWrongAnswers,
                    icon: const Icon(Icons.replay),
                    label: Text('Retry $wrongAnswersCount Wrong Answer${wrongAnswersCount > 1 ? 's' : ''}'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppTheme.minTouchTarget),
                      foregroundColor: AppTheme.errorColor,
                      side: BorderSide(color: AppTheme.errorColor.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
              ),

            // Navigation buttons
            Row(
              children: [
                // Previous button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: canGoPrevious ? () => _goToQuestion(_currentIndex - 1) : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppTheme.minTouchTarget),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Next button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canGoNext
                        ? () => _goToQuestion(_currentIndex + 1)
                        : () => Navigator.of(context).pop(),
                    icon: Icon(canGoNext ? Icons.arrow_forward : Icons.check),
                    label: Text(canGoNext ? 'Next' : 'Done'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, AppTheme.minTouchTarget),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRetryWrongAnswers() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final wrongCount = _correctnessMap.values.where((isCorrect) => !isCorrect).length;
        return AlertDialog(
          title: const Text('Retry Wrong Answers?'),
          content: Text(
            'Do you want to retry the $wrongCount question${wrongCount > 1 ? 's' : ''} you got wrong?\n\n'
            'This will create a new quiz with only these questions.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.replay),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    // Get only wrong questions
    final wrongQuestions = widget.result.questions
        ?.where((q) => _correctnessMap[q.id] == false)
        .toList() ?? [];

    if (wrongQuestions.isEmpty) {
      if (mounted) {
        context.showSnackBar('No wrong answers to retry!');
      }
      return;
    }

    // Show snackbar and navigate back
    if (mounted) {
      context.showSnackBar(
        'Feature coming soon: Retry ${wrongQuestions.length} question${wrongQuestions.length > 1 ? 's' : ''}',
        backgroundColor: context.theme.colorScheme.primary,
      );

      // In production, this would:
      // 1. Create a new quiz session with only wrong questions
      // 2. Navigate to quiz taking screen
      // Example:
      // final newQuiz = Quiz(
      //   id: 'retry-${widget.result.sessionId}',
      //   questions: wrongQuestions,
      //   ...
      // );
      // context.go(RouteConstants.getQuizPath(...));
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 24),
            Text(
              'All Correct!',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You answered all questions correctly.\nThere are no wrong answers to review.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Results'),
            ),
          ],
        ),
      ),
    );
  }
}
