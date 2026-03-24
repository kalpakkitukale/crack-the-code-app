import 'package:flutter/material.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/presentation/widgets/quiz/quiz_breadcrumb.dart';

/// Hero section displaying score with animation and status messaging.
class ResultsHeroSection extends StatelessWidget {
  final QuizResult result;
  final AssessmentType assessmentType;
  final Animation<double> scoreAnimation;
  final Animation<double> fadeInAnimation;
  final bool compact;
  final bool large;

  const ResultsHeroSection({
    super.key,
    required this.result,
    required this.assessmentType,
    required this.scoreAnimation,
    required this.fadeInAnimation,
    this.compact = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scoreAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeInAnimation,
          child: Card(
            elevation: AppTheme.elevation2,
            child: Container(
              padding: EdgeInsets.all(
                large
                    ? AppTheme.spacingXxl
                    : compact
                        ? AppTheme.spacingLg
                        : AppTheme.spacingXl,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(),
                ),
              ),
              child: Column(
                children: [
                  if (result.subjectName != null && result.quizLevel != null)
                    _buildBreadcrumb(),
                  _buildStatusIcon(context),
                  SizedBox(height: _getSpacing(large: large, compact: compact)),
                  _buildStatusMessage(context),
                  SizedBox(
                      height:
                          _getSpacing(large: large, compact: compact, small: true)),
                  _buildEncouragingMessage(context),
                  SizedBox(height: _getSpacing(large: large, compact: compact)),
                  _buildCircularScoreIndicator(context),
                  SizedBox(height: _getSpacing(large: large, compact: compact)),
                  _buildStatBadges(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: QuizBreadcrumb(
        level: _parseQuizLevel(result.quizLevel!),
        subjectName: result.subjectName,
        chapterName: result.chapterName,
        topicName: result.topicName,
        videoTitle: result.videoTitle,
        textStyle: TextStyle(
          color: AppTheme.lightOnPrimary.withValues(alpha: 0.9),
          fontSize: large ? 16 : compact ? 12 : 14,
          fontWeight: FontWeight.w500,
        ),
        iconColor: AppTheme.lightOnPrimary.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    IconData iconData;
    double size;

    if (result.isExcellent) {
      iconData = Icons.emoji_events;
      size = large ? 80 : 64;
    } else if (result.passed) {
      iconData = Icons.check_circle;
      size = large ? 72 : 56;
    } else {
      iconData = Icons.school;
      size = large ? 72 : 56;
    }

    return Icon(iconData, size: size, color: AppTheme.lightOnPrimary);
  }

  Widget _buildStatusMessage(BuildContext context) {
    return Text(
      _getStatusMessage(),
      style: (large
              ? context.textTheme.displaySmall
              : compact
                  ? context.textTheme.headlineMedium
                  : context.textTheme.headlineLarge)
          ?.copyWith(
        color: AppTheme.lightOnPrimary,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEncouragingMessage(BuildContext context) {
    return Text(
      assessmentType.getResultsMessage(
        passed: result.passed,
        score: result.scorePercentage,
      ),
      style:
          (compact ? context.textTheme.bodyMedium : context.textTheme.bodyLarge)
              ?.copyWith(
        color: AppTheme.lightOnPrimary.withValues(alpha: 0.9),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCircularScoreIndicator(BuildContext context) {
    final size = large ? 200.0 : compact ? 140.0 : 180.0;
    final percentage = scoreAnimation.value;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: large ? 12 : compact ? 8 : 10,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightOnPrimary.withValues(alpha: 0.3),
              ),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: large ? 12 : compact ? 8 : 10,
              backgroundColor: Colors.transparent,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.lightOnPrimary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toInt()}%',
                style: (large
                        ? context.textTheme.displayLarge
                        : compact
                            ? context.textTheme.displaySmall
                            : context.textTheme.displayMedium)
                    ?.copyWith(
                  color: AppTheme.lightOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                result.scoreDisplay,
                style: (compact
                        ? context.textTheme.titleMedium
                        : context.textTheme.titleLarge)
                    ?.copyWith(
                  color: AppTheme.lightOnPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadges(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatBadge(
          icon: Icons.check_circle,
          label: 'Correct',
          value: '${result.correctAnswers}',
          compact: compact,
        ),
        SizedBox(width: compact ? AppTheme.spacingSm : AppTheme.spacingMd),
        _StatBadge(
          icon: Icons.quiz,
          label: 'Total',
          value: '${result.totalQuestions}',
          compact: compact,
        ),
        SizedBox(width: compact ? AppTheme.spacingSm : AppTheme.spacingMd),
        _StatBadge(
          icon: Icons.timer,
          label: 'Time',
          value: result.formattedTimeTaken,
          compact: compact,
        ),
      ],
    );
  }

  List<Color> _getGradientColors() {
    if (assessmentType == AssessmentType.readiness) {
      if (result.scorePercentage >= 80) {
        return [AppTheme.readinessReady, AppTheme.readinessReadyLight];
      } else {
        return [
          assessmentType.primaryColor,
          assessmentType.primaryColor.withValues(alpha: 0.7)
        ];
      }
    }

    if (result.isExcellent) {
      return [AppTheme.readinessReady, AppTheme.readinessReadyLight];
    } else if (result.passed) {
      return [
        AppTheme.successColor,
        AppTheme.successColor.withValues(alpha: 0.7)
      ];
    } else {
      return [AppTheme.readinessNeedsWork, AppTheme.readinessNeedsWorkLight];
    }
  }

  String _getStatusMessage() {
    if (assessmentType == AssessmentType.readiness) {
      if (result.scorePercentage >= 80) {
        return 'Excellent Foundation!';
      } else if (result.scorePercentage >= 60) {
        return 'Good Starting Point!';
      } else if (result.scorePercentage >= 40) {
        return 'Found Your Gaps!';
      } else {
        return 'Let\'s Get Started!';
      }
    }

    if (result.isExcellent) {
      return 'Outstanding!';
    } else if (result.isGood) {
      return 'Well Done!';
    } else if (result.passed) {
      return 'Passed!';
    } else {
      return 'Keep Learning!';
    }
  }

  double _getSpacing({required bool large, required bool compact, bool small = false}) {
    if (small) {
      return large
          ? AppTheme.spacingSm
          : compact
              ? AppTheme.spacingXs
              : AppTheme.spacingSm;
    }
    return large
        ? AppTheme.spacingLg
        : compact
            ? AppTheme.spacingSm
            : AppTheme.spacingMd;
  }

  QuizLevel _parseQuizLevel(String level) {
    switch (level.toLowerCase()) {
      case 'video':
        return QuizLevel.video;
      case 'topic':
        return QuizLevel.topic;
      case 'chapter':
        return QuizLevel.chapter;
      case 'subject':
        return QuizLevel.subject;
      default:
        return QuizLevel.topic;
    }
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool compact;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppTheme.spacingSm : AppTheme.spacingMd,
        vertical: compact ? AppTheme.spacingXs : AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightOnPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: AppTheme.lightOnPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 16 : 20, color: AppTheme.lightOnPrimary),
          SizedBox(height: compact ? 2 : 4),
          Text(
            value,
            style:
                (compact ? context.textTheme.labelMedium : context.textTheme.labelLarge)
                    ?.copyWith(
              color: AppTheme.lightOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightOnPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
