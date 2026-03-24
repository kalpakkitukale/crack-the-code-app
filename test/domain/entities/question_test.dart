/// Question entity tests
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/entities/quiz/question.dart';

import '../../fixtures/quiz_fixtures.dart';

void main() {
  group('Question', () {
    // =========================================================================
    // CONSTRUCTION TESTS
    // =========================================================================
    group('construction', () {
      test('creates_question_with_all_fields', () {
        final question = QuizFixtures.question1;

        expect(question.id, 'q1');
        expect(question.questionText, 'What is 2 + 2?');
        expect(question.questionType, QuestionType.mcq);
        expect(question.options.length, 4);
        expect(question.correctAnswer, '4');
        expect(question.explanation, isNotEmpty);
        expect(question.hints.length, 1);
        expect(question.difficulty, 'basic');
        expect(question.conceptTags, isNotEmpty);
      });
    });

    // =========================================================================
    // ANSWER CHECKING TESTS
    // =========================================================================
    group('isCorrect', () {
      test('exact_match_returns_true', () {
        final question = QuizFixtures.question1;
        expect(question.isCorrect('4'), true);
      });

      test('case_insensitive_match_returns_true', () {
        final question = QuizFixtures.question2;
        expect(question.isCorrect('delhi'), true);
        expect(question.isCorrect('DELHI'), true);
        expect(question.isCorrect('Delhi'), true);
      });

      test('wrong_answer_returns_false', () {
        final question = QuizFixtures.question1;
        expect(question.isCorrect('3'), false);
        expect(question.isCorrect('5'), false);
      });

      test('handles_answer_with_option_prefix', () {
        final question = QuizFixtures.question4;
        // Should strip "A. " prefix
        expect(question.isCorrect('A. H2O'), true);
        expect(question.isCorrect('a. H2O'), true);
      });

      test('handles_whitespace', () {
        final question = QuizFixtures.question1;
        expect(question.isCorrect(' 4 '), true);
        expect(question.isCorrect('  4'), true);
      });

      test('single_letter_answers_work', () {
        // Test that single letters like "a", "b", "c", "d" aren't stripped
        final question = const Question(
          id: 'test',
          questionText: 'Test question',
          questionType: QuestionType.mcq,
          options: ['a', 'b', 'c', 'd'],
          correctAnswer: 'a',
          explanation: 'Test',
          hints: [],
          difficulty: 'basic',
          conceptTags: [],
        );

        expect(question.isCorrect('a'), true);
        expect(question.isCorrect('b'), false);
      });
    });

    // =========================================================================
    // HINT TESTS
    // =========================================================================
    group('hints', () {
      test('hasHints_with_hints_returns_true', () {
        final question = QuizFixtures.question1;
        expect(question.hasHints, true);
      });

      test('hasHints_without_hints_returns_false', () {
        final question = const Question(
          id: 'no-hints',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A', 'B'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'basic',
          conceptTags: [],
        );
        expect(question.hasHints, false);
      });

      test('hintCount_returns_correct_count', () {
        final question = QuizFixtures.question1;
        expect(question.hintCount, 1);
      });

      test('getHint_with_valid_index_returns_hint', () {
        final question = QuizFixtures.question1;
        expect(question.getHint(0), isNotNull);
        expect(question.getHint(0), contains('addition'));
      });

      test('getHint_with_invalid_index_returns_null', () {
        final question = QuizFixtures.question1;
        expect(question.getHint(-1), isNull);
        expect(question.getHint(100), isNull);
      });
    });

    // =========================================================================
    // DIFFICULTY TESTS
    // =========================================================================
    group('difficulty', () {
      test('isBasic_for_basic_question', () {
        final question = QuizFixtures.question1;
        expect(question.isBasic, true);
        expect(question.isIntermediate, false);
        expect(question.isAdvanced, false);
      });

      test('isIntermediate_for_intermediate_question', () {
        final question = QuizFixtures.question3; // Planet question is intermediate
        expect(question.isBasic, false);
        expect(question.isIntermediate, true);
        expect(question.isAdvanced, false);
      });

      test('difficulty_is_case_insensitive', () {
        final questionUpper = const Question(
          id: 'test',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'BASIC',
          conceptTags: [],
        );
        expect(questionUpper.isBasic, true);

        final questionMixed = const Question(
          id: 'test',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'BaSiC',
          conceptTags: [],
        );
        expect(questionMixed.isBasic, true);
      });
    });

    // =========================================================================
    // VIDEO LINK TESTS
    // =========================================================================
    group('videoLink', () {
      test('hasVideoLink_with_timestamp_returns_true', () {
        final question = const Question(
          id: 'test',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'basic',
          conceptTags: [],
          videoTimestamp: '02:30',
        );
        expect(question.hasVideoLink, true);
      });

      test('hasVideoLink_without_timestamp_returns_false', () {
        final question = QuizFixtures.question1;
        expect(question.hasVideoLink, false);
      });

      test('hasVideoLink_with_empty_timestamp_returns_false', () {
        final question = const Question(
          id: 'test',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'basic',
          conceptTags: [],
          videoTimestamp: '',
        );
        expect(question.hasVideoLink, false);
      });
    });

    // =========================================================================
    // QUESTION TYPE TESTS
    // =========================================================================
    group('questionType', () {
      test('mcq_type', () {
        final question = QuizFixtures.question1;
        expect(question.questionType, QuestionType.mcq);
      });

      test('all_types_exist', () {
        expect(QuestionType.values, contains(QuestionType.mcq));
        expect(QuestionType.values, contains(QuestionType.trueFalse));
        expect(QuestionType.values, contains(QuestionType.fillBlank));
        expect(QuestionType.values, contains(QuestionType.match));
        expect(QuestionType.values, contains(QuestionType.numerical));
      });
    });

    // =========================================================================
    // POINTS TESTS
    // =========================================================================
    group('points', () {
      test('default_points_is_1', () {
        final question = QuizFixtures.question1;
        expect(question.points, 1);
      });

      test('can_set_custom_points', () {
        final question = const Question(
          id: 'test',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'basic',
          conceptTags: [],
          points: 5,
        );
        expect(question.points, 5);
      });
    });

    // =========================================================================
    // TOPIC IDS TESTS
    // =========================================================================
    group('topicIds', () {
      test('default_is_empty', () {
        final question = QuizFixtures.question1;
        expect(question.topicIds, isEmpty);
      });

      test('can_have_topic_ids', () {
        final question = const Question(
          id: 'test',
          questionText: 'Test',
          questionType: QuestionType.mcq,
          options: ['A'],
          correctAnswer: 'A',
          explanation: '',
          hints: [],
          difficulty: 'basic',
          conceptTags: [],
          topicIds: ['topic-1', 'topic-2'],
        );
        expect(question.topicIds, ['topic-1', 'topic-2']);
      });
    });

    // =========================================================================
    // SAMPLE QUESTIONS FROM FIXTURES
    // =========================================================================
    group('fixtures', () {
      test('all_sample_questions_are_valid', () {
        final questions = QuizFixtures.sampleQuestions;

        expect(questions.length, 5);

        for (final q in questions) {
          expect(q.id, isNotEmpty);
          expect(q.questionText, isNotEmpty);
          expect(q.options.length, greaterThanOrEqualTo(2));
          expect(q.correctAnswer, isNotEmpty);
          expect(q.options.contains(q.correctAnswer), true,
              reason: 'Correct answer "${q.correctAnswer}" should be in options for question ${q.id}');
        }
      });

      test('each_question_has_unique_id', () {
        final questions = QuizFixtures.sampleQuestions;
        final ids = questions.map((q) => q.id).toSet();
        expect(ids.length, questions.length);
      });
    });
  });
}
