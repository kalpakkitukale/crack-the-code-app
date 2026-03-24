import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';

void main() {
  group('QuizResult', () {
    test('calculates incorrect answers correctly', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 17,
        scorePercentage: 85.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.incorrectAnswers, 3);
    });

    test('formats score display correctly', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 17,
        scorePercentage: 85.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.scoreDisplay, '17/20');
    });

    test('formats percentage display correctly', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 17,
        scorePercentage: 85.5,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.percentageDisplay, '86%');
    });

    test('identifies excellent performance correctly', () {
      final excellentResult = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 19,
        scorePercentage: 95.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(excellentResult.isExcellent, true);
      expect(excellentResult.isGood, false);
      expect(excellentResult.isAverage, false);
      expect(excellentResult.isPoor, false);
    });

    test('identifies good performance correctly', () {
      final goodResult = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 17,
        scorePercentage: 85.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(goodResult.isExcellent, false);
      expect(goodResult.isGood, true);
      expect(goodResult.isAverage, false);
      expect(goodResult.isPoor, false);
    });

    test('identifies average performance correctly', () {
      final averageResult = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 13,
        scorePercentage: 65.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(averageResult.isExcellent, false);
      expect(averageResult.isGood, false);
      expect(averageResult.isAverage, true);
      expect(averageResult.isPoor, false);
    });

    test('identifies poor performance correctly', () {
      final poorResult = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 10,
        scorePercentage: 50.0,
        passed: false,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(poorResult.isExcellent, false);
      expect(poorResult.isGood, false);
      expect(poorResult.isAverage, false);
      expect(poorResult.isPoor, true);
    });

    test('assigns grade correctly for A (>= 90%)', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 19,
        scorePercentage: 95.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.grade, 'A');
    });

    test('assigns grade correctly for B (80-89%)', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 17,
        scorePercentage: 85.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.grade, 'B');
    });

    test('assigns grade correctly for C (70-79%)', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 15,
        scorePercentage: 75.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.grade, 'C');
    });

    test('assigns grade correctly for D (60-69%)', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 13,
        scorePercentage: 65.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.grade, 'D');
    });

    test('assigns grade correctly for F (< 60%)', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 10,
        scorePercentage: 50.0,
        passed: false,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(result.grade, 'F');
    });

    test('formats time taken correctly', () {
      final result = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 17,
        scorePercentage: 85.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5, seconds: 30),
        evaluatedAt: DateTime.now(),
      );

      expect(result.timeTakenMinutes, 5);
      expect(result.formattedTimeTaken, '5m 30s');
    });

    test('detects weak areas correctly', () {
      final resultWithWeakAreas = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 10,
        scorePercentage: 50.0,
        passed: false,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
        weakAreas: ['Thermodynamics', 'Kinematics'],
      );

      expect(resultWithWeakAreas.hasWeakAreas, true);

      final resultWithoutWeakAreas = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 19,
        scorePercentage: 95.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
      );

      expect(resultWithoutWeakAreas.hasWeakAreas, false);
    });

    test('detects strong areas correctly', () {
      final resultWithStrongAreas = QuizResult(
        sessionId: 'test-session',
        totalQuestions: 20,
        correctAnswers: 19,
        scorePercentage: 95.0,
        passed: true,
        questionResults: {},
        timeTaken: const Duration(minutes: 5),
        evaluatedAt: DateTime.now(),
        strongAreas: ['Mechanics', 'Optics'],
      );

      expect(resultWithStrongAreas.hasStrongAreas, true);
    });
  });

  group('ConceptScore', () {
    test('calculates percentage correctly', () {
      const conceptScore = ConceptScore(
        concept: 'Mechanics',
        total: 10,
        correct: 8,
      );

      expect(conceptScore.percentage, 80.0);
    });

    test('calculates incorrect count correctly', () {
      const conceptScore = ConceptScore(
        concept: 'Mechanics',
        total: 10,
        correct: 8,
      );

      expect(conceptScore.incorrect, 2);
    });

    test('identifies mastered concepts correctly', () {
      const mastered = ConceptScore(
        concept: 'Mechanics',
        total: 10,
        correct: 9,
      );

      const notMastered = ConceptScore(
        concept: 'Thermodynamics',
        total: 10,
        correct: 6,
      );

      expect(mastered.isMastered, true);
      expect(notMastered.isMastered, false);
    });

    test('identifies concepts needing improvement correctly', () {
      const needsWork = ConceptScore(
        concept: 'Thermodynamics',
        total: 10,
        correct: 5,
      );

      const good = ConceptScore(
        concept: 'Mechanics',
        total: 10,
        correct: 7,
      );

      expect(needsWork.needsImprovement, true);
      expect(good.needsImprovement, false);
    });

    test('handles zero total correctly', () {
      const emptyScore = ConceptScore(
        concept: 'New Topic',
        total: 0,
        correct: 0,
      );

      expect(emptyScore.percentage, 0.0);
      expect(emptyScore.incorrect, 0);
    });
  });
}
