/// Manual test script to verify recommendations system
/// Run with: dart run test_recommendations_manual.dart

import 'package:crack_the_code/infrastructure/di/injection_container.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/usecases/pedagogy/generate_quiz_recommendations_usecase.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';

void main() async {
  print('🧪 Testing Recommendations System...\n');

  try {
    // Initialize dependencies
    print('📦 Initializing dependencies...');
    await initializeDependencies();
    print('✅ Dependencies initialized\n');

    // Create mock quiz result with weak areas
    print('📝 Creating mock quiz result...');
    final quizResult = QuizResult(
      sessionId: 'test_001',
      totalQuestions: 10,
      correctAnswers: 4,
      scorePercentage: 40.0,
      passed: false,
      questionResults: {},
      timeTaken: const Duration(minutes: 5),
      evaluatedAt: DateTime.now(),
      weakAreas: ['Factors', 'Multiples', 'LCM'],
      conceptAnalysis: {
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
      },
    );
    print('✅ Quiz result created with ${quizResult.weakAreas!.length} weak areas\n');

    // Generate recommendations
    print('🔄 Generating recommendations...');
    final useCase = injectionContainer.generateQuizRecommendationsUseCase;
    final params = GenerateQuizRecommendationsParams(
      quizResult: quizResult,
      studentId: 'test_student',
      assessmentType: AssessmentType.readiness,
    );

    final result = await useCase(params);

    result.fold(
      (failure) {
        print('❌ ERROR: ${failure.message}');
        print('\nTest FAILED');
      },
      (bundle) {
        print('✅ Recommendations generated successfully!\n');
        print('📊 Results:');
        print('   Total recommendations: ${bundle.totalCount}');
        print('   Critical gaps: ${bundle.criticalCount}');
        print('   Estimated time: ${bundle.totalEstimatedMinutes} min');
        print('   Assessment type: ${bundle.assessmentType.name}');
        print('');

        print('📋 Top Recommendations:');
        for (var i = 0; i < bundle.top3.length; i++) {
          final rec = bundle.top3[i];
          print('   ${i + 1}. ${rec.topicName}');
          print('      Severity: ${rec.severity.name}');
          print('      Priority: ${rec.priorityScore}/100');
          print('      Videos: ${rec.videoCount}');
          print('      Time: ${rec.formattedTimeEstimate}');
          print('');
        }

        print('✅ Test PASSED\n');
      },
    );
  } catch (e, stack) {
    print('❌ EXCEPTION: $e');
    print('Stack trace:');
    print(stack);
    print('\nTest FAILED');
  }
}
