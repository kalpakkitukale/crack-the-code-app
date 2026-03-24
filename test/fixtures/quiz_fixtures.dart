/// Quiz test fixtures
library;

import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt_status.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendation_status.dart';

/// Fixtures for Quiz entity testing
class QuizFixtures {
  // ============== Questions ==============

  static Question get question1 => const Question(
        id: 'q1',
        questionText: 'What is 2 + 2?',
        questionType: QuestionType.mcq,
        options: ['3', '4', '5', '6'],
        correctAnswer: '4',
        explanation: 'Simple addition: 2 + 2 = 4',
        hints: ['Think about basic addition'],
        difficulty: 'basic',
        conceptTags: ['basic-addition', 'arithmetic'],
      );

  static Question get question2 => const Question(
        id: 'q2',
        questionText: 'What is the capital of India?',
        questionType: QuestionType.mcq,
        options: ['Mumbai', 'Delhi', 'Kolkata', 'Chennai'],
        correctAnswer: 'Delhi',
        explanation: 'New Delhi is the capital city of India.',
        hints: ['It is in the northern part of India'],
        difficulty: 'basic',
        conceptTags: ['geography-capitals'],
      );

  static Question get question3 => const Question(
        id: 'q3',
        questionText: 'Which planet is closest to the Sun?',
        questionType: QuestionType.mcq,
        options: ['Venus', 'Earth', 'Mercury', 'Mars'],
        correctAnswer: 'Mercury',
        explanation: 'Mercury is the first planet from the Sun.',
        hints: ['It has the shortest orbital period'],
        difficulty: 'intermediate',
        conceptTags: ['astronomy-planets'],
      );

  static Question get question4 => const Question(
        id: 'q4',
        questionText: 'What is the chemical symbol for water?',
        questionType: QuestionType.mcq,
        options: ['H2O', 'CO2', 'NaCl', 'O2'],
        correctAnswer: 'H2O',
        explanation: 'Water is composed of 2 hydrogen and 1 oxygen atom.',
        hints: ['H stands for Hydrogen, O stands for Oxygen'],
        difficulty: 'basic',
        conceptTags: ['chemistry-formulas'],
      );

  static Question get question5 => const Question(
        id: 'q5',
        questionText: 'Who wrote Romeo and Juliet?',
        questionType: QuestionType.mcq,
        options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
        correctAnswer: 'William Shakespeare',
        explanation: 'William Shakespeare wrote Romeo and Juliet around 1594-1596.',
        hints: ['He is known as the Bard of Avon'],
        difficulty: 'basic',
        conceptTags: ['literature-authors'],
      );

  static List<Question> get sampleQuestions => [
        question1,
        question2,
        question3,
        question4,
        question5,
      ];

  // ============== Quiz Sessions ==============

  static QuizSession get emptySession => QuizSession(
        id: 'session-empty',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: const [],
        startTime: DateTime(2024, 1, 15, 10, 0),
        state: QuizSessionState.notStarted,
        currentQuestionIndex: 0,
        answers: const {},
      );

  static QuizSession get notStartedSession => QuizSession(
        id: 'session-not-started',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: sampleQuestions,
        startTime: DateTime(2024, 1, 15, 10, 0),
        state: QuizSessionState.notStarted,
        currentQuestionIndex: 0,
        answers: const {},
      );

  static QuizSession get inProgressSession => QuizSession(
        id: 'session-in-progress',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: sampleQuestions,
        startTime: DateTime(2024, 1, 15, 10, 0),
        state: QuizSessionState.inProgress,
        currentQuestionIndex: 2,
        answers: const {'q1': '4', 'q2': 'Delhi'},
      );

  static QuizSession get partiallyAnsweredSession => QuizSession(
        id: 'session-partial',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: sampleQuestions,
        startTime: DateTime(2024, 1, 15, 10, 0),
        state: QuizSessionState.inProgress,
        currentQuestionIndex: 3,
        answers: const {'q1': '4', 'q2': 'Mumbai', 'q3': 'Mercury'}, // One wrong
      );

  static QuizSession get fullyAnsweredSession => QuizSession(
        id: 'session-full',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: sampleQuestions,
        startTime: DateTime(2024, 1, 15, 10, 0),
        state: QuizSessionState.inProgress,
        currentQuestionIndex: 4,
        answers: const {
          'q1': '4',
          'q2': 'Delhi',
          'q3': 'Mercury',
          'q4': 'H2O',
          'q5': 'William Shakespeare',
        },
      );

  static QuizSession get completedSession => QuizSession(
        id: 'session-completed',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: sampleQuestions,
        startTime: DateTime(2024, 1, 15, 10, 0),
        endTime: DateTime(2024, 1, 15, 10, 15),
        state: QuizSessionState.completed,
        currentQuestionIndex: 4,
        answers: const {
          'q1': '4',
          'q2': 'Delhi',
          'q3': 'Mercury',
          'q4': 'H2O',
          'q5': 'William Shakespeare',
        },
      );

  static QuizSession get sessionWithBackup => QuizSession(
        id: 'session-backup',
        quizId: 'quiz-1',
        studentId: 'student-1',
        questions: sampleQuestions,
        startTime: DateTime(2024, 1, 15, 10, 0),
        state: QuizSessionState.inProgress,
        currentQuestionIndex: 0,
        answers: const {},
        answersBackup: const {'q1': '4', 'q2': 'Delhi'},
      );

  // ============== Quiz Attempts ==============

  static QuizAttempt get sampleAttempt => QuizAttempt(
        id: 'attempt-1',
        quizId: 'quiz-1',
        studentId: 'student-1',
        answers: const {'q1': '4', 'q2': 'Delhi', 'q3': 'Mercury', 'q4': 'H2O'},
        score: 0.8,
        passed: true,
        completedAt: DateTime(2024, 1, 15, 10, 15),
        timeTaken: 900,
        totalQuestions: 5,
        correctAnswers: 4,
        assessmentType: AssessmentType.practice,
        status: QuizAttemptStatus.completed,
        recommendationStatus: RecommendationStatus.none,
      );

  static List<QuizAttempt> get sampleAttemptHistory => [
        QuizAttempt(
          id: 'attempt-1',
          quizId: 'quiz-1',
          studentId: 'student-1',
          answers: const {'q1': '4', 'q2': 'Delhi', 'q3': 'Mercury', 'q4': 'H2O'},
          score: 0.8,
          passed: true,
          completedAt: DateTime(2024, 1, 15, 10, 15),
          timeTaken: 900,
          totalQuestions: 5,
          correctAnswers: 4,
          assessmentType: AssessmentType.practice,
          status: QuizAttemptStatus.completed,
          recommendationStatus: RecommendationStatus.none,
        ),
        QuizAttempt(
          id: 'attempt-2',
          quizId: 'quiz-2',
          studentId: 'student-1',
          answers: const {'q1': '4', 'q2': 'Mumbai', 'q3': 'Mercury'},
          score: 0.6,
          passed: false,
          completedAt: DateTime(2024, 1, 14, 10, 15),
          timeTaken: 1200,
          totalQuestions: 5,
          correctAnswers: 3,
          assessmentType: AssessmentType.knowledge,
          status: QuizAttemptStatus.completed,
          recommendationStatus: RecommendationStatus.none,
        ),
        QuizAttempt(
          id: 'attempt-3',
          quizId: 'quiz-3',
          studentId: 'student-1',
          answers: const {'q1': '4', 'q2': 'Delhi', 'q3': 'Mercury', 'q4': 'H2O', 'q5': 'William Shakespeare'},
          score: 1.0,
          passed: true,
          completedAt: DateTime(2024, 1, 13, 10, 15),
          timeTaken: 600,
          totalQuestions: 5,
          correctAnswers: 5,
          assessmentType: AssessmentType.readiness,
          status: QuizAttemptStatus.completed,
          recommendationStatus: RecommendationStatus.none,
        ),
      ];

  // ============== Helpers ==============

  /// Create a session with specific number of questions and answers
  static QuizSession sessionWithProgress({
    required int totalQuestions,
    required int answeredQuestions,
    required int currentIndex,
  }) {
    final questions = List.generate(
      totalQuestions,
      (i) => Question(
        id: 'q$i',
        questionText: 'Question $i',
        questionType: QuestionType.mcq,
        options: const ['A', 'B', 'C', 'D'],
        correctAnswer: 'A',
        explanation: 'Explanation for question $i',
        hints: const ['Hint 1'],
        difficulty: 'basic',
        conceptTags: ['concept-$i'],
      ),
    );

    final answers = <String, String>{};
    for (int i = 0; i < answeredQuestions; i++) {
      answers['q$i'] = 'A';
    }

    return QuizSession(
      id: 'session-custom',
      quizId: 'quiz-custom',
      studentId: 'student-1',
      questions: questions,
      startTime: DateTime.now(),
      state: QuizSessionState.inProgress,
      currentQuestionIndex: currentIndex,
      answers: answers,
    );
  }

  // ============== Quiz Results ==============

  static QuizResult get perfectResult => QuizResult(
        sessionId: 'session-1',
        totalQuestions: 5,
        correctAnswers: 5,
        scorePercentage: 100.0,
        passed: true,
        questionResults: const {
          'q1': true,
          'q2': true,
          'q3': true,
          'q4': true,
          'q5': true,
        },
        timeTaken: const Duration(minutes: 15),
        evaluatedAt: DateTime(2024, 1, 15, 10, 15),
      );

  static QuizResult get passingResult => QuizResult(
        sessionId: 'session-2',
        totalQuestions: 5,
        correctAnswers: 4,
        scorePercentage: 80.0,
        passed: true,
        questionResults: const {
          'q1': true,
          'q2': true,
          'q3': false,
          'q4': true,
          'q5': true,
        },
        timeTaken: const Duration(minutes: 12),
        evaluatedAt: DateTime(2024, 1, 15, 10, 12),
      );

  static QuizResult get failingResult => QuizResult(
        sessionId: 'session-3',
        totalQuestions: 5,
        correctAnswers: 2,
        scorePercentage: 40.0,
        passed: false,
        questionResults: const {
          'q1': true,
          'q2': false,
          'q3': false,
          'q4': true,
          'q5': false,
        },
        timeTaken: const Duration(minutes: 20),
        evaluatedAt: DateTime(2024, 1, 15, 10, 20),
      );
}
