import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/presentation/providers/pedagogy/recommendations_provider.dart';

/// Debug screen for testing recommendations flow without full quiz
///
/// This bypasses the need for content database and directly generates
/// recommendations from mock quiz results.
class TestRecommendationsScreen extends ConsumerWidget {
  const TestRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Recommendations'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.science,
                size: 80,
                color: Colors.deepPurple[300],
              ),
              const SizedBox(height: AppTheme.spacingLg),
              const Text(
                'Recommendations System Test',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              const Text(
                'Test the complete recommendations flow with mock data',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Test Readiness Check with weak areas
              _TestButton(
                title: 'Readiness Check',
                subtitle: 'With weak areas (45% score)',
                color: const Color(0xFF7C4DFF),
                icon: Icons.explore,
                onTap: () => _generateRecommendations(
                  context,
                  ref,
                  AssessmentType.readiness,
                  scorePercentage: 45.0,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Test Knowledge Check with weak areas
              _TestButton(
                title: 'Knowledge Check',
                subtitle: 'With weak areas (55% score)',
                color: const Color(0xFF00ACC1),
                icon: Icons.check_circle,
                onTap: () => _generateRecommendations(
                  context,
                  ref,
                  AssessmentType.knowledge,
                  scorePercentage: 55.0,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Test perfect score
              _TestButton(
                title: 'Perfect Score',
                subtitle: 'No weak areas (100% score)',
                color: Colors.green,
                icon: Icons.celebration,
                onTap: () => _generateRecommendations(
                  context,
                  ref,
                  AssessmentType.readiness,
                  scorePercentage: 100.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateRecommendations(
    BuildContext context,
    WidgetRef ref,
    AssessmentType assessmentType, {
    required double scorePercentage,
  }) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppTheme.spacingMd),
                Text('Generating recommendations...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Create mock quiz result
    final quizResult = QuizResult(
      sessionId: 'test_session_${DateTime.now().millisecondsSinceEpoch}',
      totalQuestions: 10,
      correctAnswers: (scorePercentage / 10).round(),
      scorePercentage: scorePercentage,
      passed: scorePercentage >= 60,
      questionResults: {},
      timeTaken: const Duration(minutes: 5),
      evaluatedAt: DateTime.now(),

      // Add weak areas if not perfect score
      weakAreas: scorePercentage < 100 ? [
        'Factors',
        'Multiples',
        'LCM',
      ] : [],

      // Add concept analysis
      conceptAnalysis: scorePercentage < 100 ? {
        'math_4_factors': const ConceptScore(
          concept: 'math_4_factors',
          total: 3,
          correct: 0,
        ),
        'math_4_multiples': const ConceptScore(
          concept: 'math_4_multiples',
          total: 3,
          correct: 1,
        ),
        'math_5_lcm': const ConceptScore(
          concept: 'math_5_lcm',
          total: 2,
          correct: 0,
        ),
      } : null,

      // Metadata
      subjectName: 'Mathematics',
      topicName: 'Number System',
    );

    // Generate recommendations
    await ref.read(recommendationsProvider.notifier).generateFromQuizResult(
      quizResult: quizResult,
      studentId: 'test_student_001',
      assessmentType: assessmentType,
    );

    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Check if recommendations were generated
    final recState = ref.read(recommendationsProvider);

    if (recState.error != null) {
      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${recState.error}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
      return;
    }

    // Navigate to recommendations screen
    if (context.mounted && recState.hasRecommendations) {
      context.push(
        RouteConstants.recommendations,
        extra: recState.bundle,
      );
    } else if (context.mounted) {
      // Perfect score - show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            scorePercentage >= 100
                ? '🎉 Perfect Score! No recommendations needed.'
                : 'No recommendations generated. Check logs for details.',
          ),
          backgroundColor: scorePercentage >= 100 ? Colors.green : Colors.orange,
        ),
      );
    }
  }
}

class _TestButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _TestButton({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
