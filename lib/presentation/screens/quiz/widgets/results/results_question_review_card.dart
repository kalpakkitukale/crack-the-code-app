import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';

/// Card displaying expandable question review items.
class ResultsQuestionReviewCard extends StatefulWidget {
  final QuizResult result;
  final Map<String, Question> questionsCache;
  final QuizSession? cachedSession;
  final bool enhanced;

  const ResultsQuestionReviewCard({
    super.key,
    required this.result,
    required this.questionsCache,
    this.cachedSession,
    this.enhanced = false,
  });

  @override
  State<ResultsQuestionReviewCard> createState() =>
      _ResultsQuestionReviewCardState();
}

class _ResultsQuestionReviewCardState extends State<ResultsQuestionReviewCard> {
  final Map<String, bool> _expandedQuestions = {};

  @override
  Widget build(BuildContext context) {
    final questions = widget.result.questionResults.entries.toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          widget.enhanced ? AppTheme.spacingLg : AppTheme.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppTheme.spacingMd),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: AppTheme.spacingMd),
              itemBuilder: (context, index) {
                final entry = questions[index];
                final questionId = entry.key;
                final isCorrect = entry.value;
                final isExpanded = _expandedQuestions[questionId] ?? false;

                return _QuestionReviewItem(
                  questionNumber: index + 1,
                  questionId: questionId,
                  isCorrect: isCorrect,
                  isExpanded: isExpanded,
                  enhanced: widget.enhanced,
                  question: widget.questionsCache[questionId],
                  cachedSession: widget.cachedSession,
                  onToggle: () {
                    setState(() {
                      _expandedQuestions[questionId] = !isExpanded;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.list_alt,
          color: context.colorScheme.primary,
          size: widget.enhanced ? 28 : 24,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Text(
          'Question Review',
          style: (widget.enhanced
                  ? context.textTheme.titleLarge
                  : context.textTheme.titleMedium)
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          '${widget.result.correctAnswers}/${widget.result.totalQuestions} Correct',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _QuestionReviewItem extends StatelessWidget {
  final int questionNumber;
  final String questionId;
  final bool isCorrect;
  final bool isExpanded;
  final bool enhanced;
  final Question? question;
  final QuizSession? cachedSession;
  final VoidCallback onToggle;

  const _QuestionReviewItem({
    required this.questionNumber,
    required this.questionId,
    required this.isCorrect,
    required this.isExpanded,
    required this.enhanced,
    required this.question,
    required this.cachedSession,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Container(
          padding: EdgeInsets.all(enhanced ? AppTheme.spacingMd : AppTheme.spacingSm),
          decoration: BoxDecoration(
            color: isCorrect
                ? AppTheme.successColor.withValues(alpha: 0.05)
                : AppTheme.errorColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: isCorrect
                  ? AppTheme.successColor.withValues(alpha: 0.2)
                  : AppTheme.errorColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCollapsedHeader(context),
              if (isExpanded) _buildExpandedContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: enhanced ? 32 : 28,
          height: enhanced ? 32 : 28,
          decoration: BoxDecoration(
            color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$questionNumber',
              style: context.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
          size: enhanced ? 24 : 20,
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            isCorrect ? 'Correct' : 'Incorrect',
            style:
                (enhanced ? context.textTheme.titleMedium : context.textTheme.titleSmall)
                    ?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
            ),
          ),
        ),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacingMd),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionMetadata(context),
            if (question != null) ...[
              if (question!.conceptTags.isNotEmpty) _buildConceptTags(context),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                question!.questionText,
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              if (cachedSession != null) ...[
                const SizedBox(height: AppTheme.spacingMd),
                _buildAnswerDisplay(context),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionMetadata(BuildContext context) {
    return Row(
      children: [
        Text(
          'Question $questionNumber',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (question != null) ...[
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            '• Difficulty: ${question!.difficulty.substring(0, 1).toUpperCase()}${question!.difficulty.substring(1)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConceptTags(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spacingXs),
      child: Wrap(
        spacing: AppTheme.spacingXs,
        runSpacing: AppTheme.spacingXs,
        children: question!.conceptTags.take(3).map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingXs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Text(
              tag,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnswerDisplay(BuildContext context) {
    final studentAnswer = cachedSession!.getAnswer(questionId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnswerBox(
          label: 'Your Answer',
          answer: _getAnswerText(question!, studentAnswer),
          isCorrect: isCorrect,
          icon: isCorrect ? Icons.check_circle : Icons.cancel,
        ),
        if (!isCorrect) ...[
          const SizedBox(height: AppTheme.spacingSm),
          _AnswerBox(
            label: 'Correct Answer',
            answer: _getAnswerText(question!, question!.correctAnswer),
            isCorrect: true,
            icon: Icons.lightbulb_outline,
          ),
        ],
        if (question!.explanation.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingSm),
          _ExplanationBox(explanation: question!.explanation),
        ],
      ],
    );
  }

  String _getAnswerText(Question question, String? answer) {
    if (answer == null) return 'No answer';

    if (answer.length == 1 &&
        answer.toUpperCase().codeUnitAt(0) >= 65 &&
        answer.toUpperCase().codeUnitAt(0) <= 90) {
      final index = answer.toUpperCase().codeUnitAt(0) - 65;
      if (index >= 0 && index < question.options.length) {
        return '${answer.toUpperCase()}. ${question.options[index]}';
      }
    }

    return answer;
  }
}

class _AnswerBox extends StatelessWidget {
  final String label;
  final String answer;
  final bool isCorrect;
  final IconData icon;

  const _AnswerBox({
    required this.label,
    required this.answer,
    required this.isCorrect,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppTheme.successColor : AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: AppTheme.spacingXs),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(answer, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ExplanationBox extends StatelessWidget {
  final String explanation;

  const _ExplanationBox({required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingXs),
              Text(
                'Explanation',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(explanation, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}
